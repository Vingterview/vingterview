package ving.vingterview.service.comment;

import jakarta.persistence.EntityManager;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;
import ving.vingterview.domain.board.Board;
import ving.vingterview.domain.comment.Comment;
import ving.vingterview.domain.member.Member;
import ving.vingterview.dto.comment.CommentCreateDTO;
import ving.vingterview.dto.comment.CommentDTO;
import ving.vingterview.dto.comment.CommentListDTO;
import ving.vingterview.dto.comment.CommentUpdateDTO;

import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

import static org.assertj.core.api.Assertions.*;
import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
class CommentServiceTest {

    @Autowired
    CommentService commentService;
    @Autowired
    EntityManager em;

    // 댓글 달기
    @Test
    void create() {
        CommentCreateDTO dto = new CommentCreateDTO();
        dto.setMemberId(1L);
        dto.setBoardId(1L);
        dto.setContent("첫번째 댓글입니다");

        Long commentId = commentService.create(dto);

        CommentDTO foundDto = commentService.findOne(commentId);

        assertThat(dto.getMemberId()).isEqualTo(foundDto.getMemberId());
        assertThat(dto.getBoardId()).isEqualTo(foundDto.getBoardId());
        assertThat(dto.getContent()).isEqualTo(foundDto.getContent());
    }

    // 같은 게시글에 두번 댓글을 다는 경우
    @Test
    void createDuplicate() {
        CommentCreateDTO dto1 = new CommentCreateDTO();
        dto1.setMemberId(1L);
        dto1.setBoardId(1L);
        dto1.setContent("첫번째 댓글입니다");

        CommentCreateDTO dto2 = new CommentCreateDTO();
        dto2.setMemberId(1L);
        dto2.setBoardId(1L);
        dto2.setContent("같은 게시글의 두번째 댓글입니다");

        Long commentId1 = commentService.create(dto1);
        Long commentId2 = commentService.create(dto2);

        CommentDTO foundDto1 = commentService.findOne(commentId1);
        CommentDTO foundDto2 = commentService.findOne(commentId2);

        assertThat(dto1.getMemberId()).isEqualTo(foundDto1.getMemberId());
        assertThat(dto1.getBoardId()).isEqualTo(foundDto1.getBoardId());
        assertThat(dto1.getContent()).isEqualTo(foundDto1.getContent());

        assertThat(dto2.getMemberId()).isEqualTo(foundDto2.getMemberId());
        assertThat(dto2.getBoardId()).isEqualTo(foundDto2.getBoardId());
        assertThat(dto2.getContent()).isEqualTo(foundDto2.getContent());
    }

    // 댓글 수정
    @Test
    void update() {
        CommentCreateDTO dto = new CommentCreateDTO();
        dto.setMemberId(1L);
        dto.setBoardId(1L);
        dto.setContent("첫번째 댓글입니다");

        Long commentId = commentService.create(dto);

        CommentUpdateDTO updateDTO = new CommentUpdateDTO();
        updateDTO.setContent("수정한 댓글입니다");

        Long updateId = commentService.update(commentId, updateDTO);

        CommentDTO foundDto = commentService.findOne(updateId);
        assertThat(foundDto.getContent()).isEqualTo(updateDTO.getContent());
    }

    // 댓글 삭제
    @Test
    void delete() {
        CommentCreateDTO dto = new CommentCreateDTO();
        dto.setMemberId(1L);
        dto.setBoardId(1L);
        dto.setContent("첫번째 댓글입니다");

        Long commentId = commentService.create(dto);

        commentService.delete(commentId);

        assertThatThrownBy(() -> commentService.findOne(commentId)).isInstanceOf(NoSuchElementException.class);
    }

    // 없는 댓글을 찾는 경우
    @Test
    void findNothing() {
        assertThatThrownBy(() -> commentService.findOne(100L)).isInstanceOf(NoSuchElementException.class);
    }

    // 게시글로 댓글 필터링
    @Test
    void findByBoard() {
        List<Member> members = new ArrayList<>();
        for (int i = 0; i < 5; i++) {
            Member member = Member.builder().name("testMember" + i).build();
            em.persist(member);
            members.add(member);
        }

        Board board = Board.builder().member(members.get(0)).content("testBoard").build();
        em.persist(board);

        List<Comment> comments = new ArrayList<>();
        for (Member member : members) {
            Comment comment = Comment.builder().board(board).member(member).content("testComment" + member.getId()).build();
            em.persist(comment);
            comments.add(comment);
        }

        List<CommentDTO> foundComments = commentService.findByBoard(board.getId()).getComments();
        assertThat(foundComments).extracting("boardId").containsOnly(board.getId());
        assertThat(foundComments).extracting("memberId")
                .containsExactlyElementsOf(comments.stream().map(comment -> comment.getMember().getId()).toList());
        assertThat(foundComments).extracting("commentId")
                .containsExactlyElementsOf(comments.stream().map(comment -> comment.getId()).toList());
        assertThat(foundComments).extracting("content")
                .containsExactlyElementsOf(comments.stream().map(comment -> comment.getContent()).toList());
    }

    // 게시글에 달린 댓글이 없는 경우
    @Test
    void findNothingByBoard() {
        Member member = Member.builder().name("testMember1").build();
        Board board = Board.builder().member(member).content("testBoard").build();
        em.persist(member);
        em.persist(board);

        List<CommentDTO> comments = commentService.findByBoard(board.getId()).getComments();

        assertThat(comments.size()).isEqualTo(0);
    }

    // 게시글이 없는 경우
    @Test
    void findByWrongBoardId() {
        Member member = Member.builder().name("testMember1").build();
        Board board = Board.builder().member(member).content("testBoard").build();
        em.persist(member);
        em.persist(board);

        assertThatThrownBy(() -> commentService.findByBoard(board.getId() + 100L))
                .isInstanceOf(NoSuchElementException.class);
    }

    // 작성자로 댓글 필터링
    @Test
    void findByMember() {
        List<Member> members = new ArrayList<>();
        for (int i = 0; i < 5; i++) {
            Member member = Member.builder().name("testMember" + i).build();
            em.persist(member);
            members.add(member);
        }
        Member member = members.get(0);

        List<Board> boards = new ArrayList<>();
        for (int i = 0; i < 5; i++) {
            Board board = Board.builder().member(members.get(i)).content("testBoard").build();
            em.persist(board);
            boards.add(board);
        }

        List<Comment> comments = new ArrayList<>();
        for (Board board : boards) {
            Comment comment = Comment.builder().board(board).member(member).content("testComment" + member.getId()).build();
            em.persist(comment);
            comments.add(comment);
        }

        List<CommentDTO> foundComments = commentService.findByMember(member.getId()).getComments();
        assertThat(foundComments).extracting("memberId").containsOnly(member.getId());
        assertThat(foundComments).extracting("boardId")
                .containsExactlyElementsOf(comments.stream().map(comment -> comment.getBoard().getId()).toList());
        assertThat(foundComments).extracting("commentId")
                .containsExactlyElementsOf(comments.stream().map(comment -> comment.getId()).toList());
        assertThat(foundComments).extracting("content")
                .containsExactlyElementsOf(comments.stream().map(comment -> comment.getContent()).toList());
    }

    // 사용자가 작성한 댓글이 없는 경우
    @Test
    void findNothingByMember() {
        Member member = Member.builder().name("testMember1").build();
        Board board = Board.builder().member(member).content("testBoard").build();
        em.persist(member);
        em.persist(board);

        List<CommentDTO> comments = commentService.findByMember(member.getId()).getComments();

        assertThat(comments.size()).isEqualTo(0);
    }

    // 사용자가 없는 경우
    @Test
    void findByWrongMemberId() {
        Member member = Member.builder().name("testMember1").build();
        Board board = Board.builder().member(member).content("testBoard").build();
        em.persist(member);
        em.persist(board);

        assertThatThrownBy(() -> commentService.findByMember(member.getId() + 100L))
                .isInstanceOf(NoSuchElementException.class);
    }
}