package ving.vingterview.service.board;

import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;
import org.springframework.transaction.annotation.Transactional;
import ving.vingterview.domain.LikeType;
import ving.vingterview.domain.board.Board;
import ving.vingterview.domain.board.BoardMemberLike;
import ving.vingterview.domain.comment.Comment;
import ving.vingterview.domain.member.Member;
import ving.vingterview.domain.question.Question;
import ving.vingterview.dto.board.BoardCreateDTO;
import ving.vingterview.dto.board.BoardDTO;
import ving.vingterview.dto.board.BoardListDTO;
import ving.vingterview.repository.BoardMemberLikeRepository;
import ving.vingterview.service.comment.CommentService;
import ving.vingterview.service.member.MemberService;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@Transactional
class BoardServiceTest {


    @Autowired
    BoardService boardService;
    @Autowired
    MemberService memberService;

    @Autowired
    CommentService commentService;

    @Autowired
    BoardMemberLikeRepository boardMemberLikeRepository;


    @Autowired
    EntityManager em;



    @Test
    void save() {

        Member member = Member.builder()
                .name("memberA")
                .build();

        Question question = Question.builder()
                .member(member)
                .build();

        em.persist(member);
        em.persist(question);

        em.flush();

        BoardCreateDTO boardCreateDTO = new BoardCreateDTO();
        boardCreateDTO.setQuestionId(question.getId());

        Long boardId = boardService.save(member.getId(), boardCreateDTO);

        Board board = em.find(Board.class, boardId);

        assertThat(boardId).isEqualTo(board.getId());


    }


    @Test
    void findAll() {

        Member member = Member.builder()
                .name("memberA")
                .build();

        Question question = Question.builder()
                .member(member)
                .build();


        em.persist(member);
        em.persist(question);

        em.flush();

        List<Long> boardIds = new ArrayList<>();
        for (int i = 0; i < 5; i++) {
            BoardCreateDTO boardCreateDTO = new BoardCreateDTO();
            boardCreateDTO.setQuestionId(question.getId());
            Long boardId = boardService.save(member.getId(), boardCreateDTO);
            boardIds.add(boardId);
        }

        List<BoardDTO> boardDTOS = new ArrayList<>();
        for (Long boardId : boardIds) {
            BoardDTO boardDTO = boardService.findById(boardId);
            boardDTOS.add(boardDTO);
        }
        
        
        BoardListDTO boardListDTO = boardService.findAll();
        List<BoardDTO> findBoardDTOS = boardListDTO.getBoards().stream().collect(Collectors.toList());
        
        assertThat(boardListDTO.getBoards().size()).isEqualTo(5);
        assertThat(findBoardDTOS).containsAll(boardDTOS);
        

    }
    @Test
    void findById() {
        Member member = Member.builder()
                .name("memberA")
                .build();

        Question question = Question.builder()
                .member(member)
                .build();

        em.persist(member);
        em.persist(question);

        BoardCreateDTO boardCreateDTO = new BoardCreateDTO();
        boardCreateDTO.setQuestionId(question.getId());

        Long savedId = boardService.save(member.getId(), boardCreateDTO);

        BoardDTO boardDTO = boardService.findById(savedId);
        Long findId = boardDTO.getBoardId();

        assertThat(findId).isEqualTo(savedId);


    }


    @Test
    void delete() {
        Member member = Member.builder()
                .name("memberA")
                .build();
        Question question = Question.builder()
                .member(member)
                .build();

        Board board = Board.builder()
                .member(member)
                .question(question)
                .build();

        em.persist(member);
        em.persist(question);
        em.persist(board);

        em.flush();

        boardService.delete(board.getId());
//        boardService.findById(board.getId());
        Assertions.assertThrows(RuntimeException.class, () -> boardService.findById(board.getId()));

    }
    

    @Test
    void like() {
        Member member = Member.builder()
                .name("memberA")
                .build();
        Question question = Question.builder()
                .member(member)
                .build();

        Board board = Board.builder()
                .member(member)
                .question(question)
                .build();

        em.persist(member);
        em.persist(question);
        em.persist(board);
        
        boardService.like(member.getId(), board.getId());

        BoardMemberLike findLike = boardMemberLikeRepository.findByMemberIdAndBoardId(member.getId(), board.getId()).get();
        assertThat(findLike.getLikeStatus()).isEqualTo(LikeType.LIKE);

        boardService.like(member.getId(), board.getId());
        assertThat(findLike.getLikeStatus()).isEqualTo(LikeType.UNLIKE);

        boardService.like(member.getId(), board.getId());
        assertThat(findLike.getLikeStatus()).isEqualTo(LikeType.LIKE);

        boardService.like(member.getId(), board.getId());
        assertThat(findLike.getLikeStatus()).isEqualTo(LikeType.UNLIKE);


    }

    @Test
    @Rollback(value = false)
    void findByMember() {
        Member member = Member.builder()
                .name("memberA")
                .build();

        Member member2 = Member.builder()
                .name("memberB")
                .build();

        Question question = Question.builder()
                .member(member)
                .build();

        em.persist(member);
        em.persist(member2);
        em.persist(question);

        List<Board> boards = new ArrayList<>();
        for (int i = 0; i < 5; i++) {
            Board board = Board.builder()
                    .member(member)
                    .question(question)
                    .build();
            em.persist(board);
            boards.add(board);
        }

        for (int i = 0; i < 5; i++) {
            Board board = Board.builder()
                    .member(member2)
                    .question(question)
                    .build();
            em.persist(board);
            boards.add(board);

        }

        em.flush();


        List<BoardDTO> findBoards = boardService.findByMember(member.getId()).getBoards();
        List<Long> findBoardsId = findBoards.stream().map(BoardDTO::getBoardId).collect(Collectors.toList());

        assertThat(findBoardsId.size()).isEqualTo(5);
        assertThat(findBoardsId).containsExactlyInAnyOrderElementsOf(boards.stream()
                .filter(board->board.getMember().getId().equals(member.getId()))
                .map(Board::getId).collect(Collectors.toList()));


    }

    @Test
    void findByQuestion() {
        Member member = Member.builder()
                .name("memberA")
                .build();

        Question question = Question.builder()
                .member(member)
                .build();


        Question question2 = Question.builder()
                .member(member)
                .build();

        em.persist(member);

        em.persist(question);
        em.persist(question2);

        List<Board> boards = new ArrayList<>();
        for (int i = 0; i < 5; i++) {
            Board board = Board.builder()
                    .member(member)
                    .question(question)
                    .build();
            em.persist(board);
            boards.add(board);
        }

        for (int i = 0; i < 5; i++) {
            Board board = Board.builder()
                    .member(member)
                    .question(question2)
                    .build();
            em.persist(board);
            boards.add(board);

        }

        em.flush();


        List<BoardDTO> findBoards = boardService.findByQuestion(question.getId()).getBoards();
        List<Long> findBoardsId = findBoards.stream().map(BoardDTO::getBoardId).collect(Collectors.toList());

        assertThat(findBoardsId.size()).isEqualTo(5);
        assertThat(findBoardsId).containsExactlyInAnyOrderElementsOf(boards.stream()
                .filter(board->board.getQuestion().getId().equals(question.getId()))
                .map(Board::getId).collect(Collectors.toList()));
    }


    @Test
    void boardCommentCount() {
        Member member = Member.builder()
                .name("memberA")
                .build();
        Question question = Question.builder()
                .member(member)
                .build();

        Board board = Board.builder()
                .member(member)
                .question(question)
                .build();

        em.persist(member);
        em.persist(question);
        em.persist(board);

        List<Comment> comments = new ArrayList<>();
        for (int i = 0; i < 5; i++) {
            Comment comment = Comment.builder()
                    .board(board)
                    .member(member)
                    .build();

            em.persist(comment);
            comments.add(comment);
        }

        em.flush();
        em.clear();

        Board findBoard = em.find(Board.class, board.getId());
        List<Comment> findComments = findBoard.getComments();
        assertThat(findComments.size()).isEqualTo(5);
        assertThat(findComments.stream().map(Comment::getId).collect(Collectors.toList()))
                .containsExactlyInAnyOrderElementsOf(comments.stream().map(Comment::getId).collect(Collectors.toList()));

    }

    @Test
    void boardLikeCount() {
        Member member = Member.builder()
                .name("memberA")
                .build();
        Question question = Question.builder()
                .member(member)
                .build();

        Board board = Board.builder()
                .member(member)
                .question(question)
                .build();

        em.persist(member);
        em.persist(question);
        em.persist(board);

        List<BoardMemberLike> likes = new ArrayList<>();
        for (int i = 0; i < 5; i++) {

            BoardMemberLike like = BoardMemberLike.builder()
                    .board(board)
                    .member(member)
                    .build();

            em.persist(like);
            likes.add(like);
        }

        em.flush();
        em.clear();

        Board findBoard = em.find(Board.class, board.getId());
        List<BoardMemberLike> findLikes = findBoard.getBoardMemberLikes();
        assertThat(findLikes.size()).isEqualTo(5);
        assertThat(findLikes.stream().map(BoardMemberLike::getId).collect(Collectors.toList()))
                .containsExactlyInAnyOrderElementsOf(likes.stream().map(BoardMemberLike::getId).collect(Collectors.toList()));
    }
}