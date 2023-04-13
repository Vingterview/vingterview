package ving.vingterview.service.comment;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ving.vingterview.domain.LikeType;
import ving.vingterview.domain.board.Board;
import ving.vingterview.domain.comment.Comment;
import ving.vingterview.domain.comment.CommentMemberLike;
import ving.vingterview.domain.member.Member;
import ving.vingterview.dto.comment.CommentCreateDTO;
import ving.vingterview.dto.comment.CommentDTO;
import ving.vingterview.dto.comment.CommentListDTO;
import ving.vingterview.dto.comment.CommentUpdateDTO;
import ving.vingterview.repository.BoardRepository;
import ving.vingterview.repository.CommentMemberLikeRepository;
import ving.vingterview.repository.CommentRepository;
import ving.vingterview.repository.MemberRepository;

import java.util.*;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class CommentService {

    private final CommentRepository commentRepository;
    private final BoardRepository boardRepository;
    private final MemberRepository memberRepository;
    private final CommentMemberLikeRepository likeRepository;

    /**
     * 댓글 등록
     * @param commentCreateDTO
     * @return
     */
    public Long create(CommentCreateDTO commentCreateDTO) {
        Board board = boardRepository.findById(commentCreateDTO.getBoardId())
                .orElseThrow(()->new NoSuchElementException("게시글 없음"));
        Member member = memberRepository.findById(commentCreateDTO.getMemberId())
                .orElseThrow(()->new NoSuchElementException("회원 없음"));
        String content = commentCreateDTO.getContent();

        Comment comment = new Comment(board, member, content);

        return commentRepository.save(comment).getId();
    }

    /**
     * 댓글 id로 댓글 1개 조회
     * @param id
     * @return
     */
    @Transactional(readOnly = true)
    public CommentDTO findOne(Long id) {
        Comment comment = commentRepository.findById(id)
                .orElseThrow(()->new NoSuchElementException("댓글 없음"));
        Member member = comment.getMember();
        Board board = comment.getBoard();
        int likeCount = likeRepository.countByCommentAndLikeStatus(comment, LikeType.LIKE);

        return convertToCommentDTO(comment, member, board, likeCount);
    }

    /**
     * 게시글에 달린 댓글 조회
     * @param boardId
     * @return
     */
    @Transactional(readOnly = true)
    public CommentListDTO findByBoard(Long boardId) {
        Board board = boardRepository.findById(boardId)
                .orElseThrow(() -> new NoSuchElementException("게시글 없음"));
        List<Comment> comments = commentRepository.findAllByBoard(board);
        List<CommentDTO> results = comments.stream()
                .map(comment -> {
                    Member member = comment.getMember();
                    int likeCount = likeRepository.countByCommentAndLikeStatus(comment, LikeType.LIKE);
                    return convertToCommentDTO(comment, member, board, likeCount);
                })
                .toList();
        return new CommentListDTO(results);
    }

    /**
     * 회원이 작성한 댓글 조회
     * @param memberId
     * @return
     */
    @Transactional(readOnly = true)
    public CommentListDTO findByMember(Long memberId) {
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new NoSuchElementException("회원 없음"));
        List<Comment> comments = commentRepository.findAllByMember(member);


        List<CommentDTO> results = comments.stream()
                .map((comment) -> {
                    Board board = comment.getBoard();
                    int likeCount = likeRepository.countByCommentAndLikeStatus(comment, LikeType.LIKE);
                    return convertToCommentDTO(comment, member, board, likeCount);
                })
                .toList();
        return new CommentListDTO(results);
    }

    /**
     * 댓글 수정
     * @param id
     * @param commentUpdateDTO
     * @return
     */
    public Long update(Long id, CommentUpdateDTO commentUpdateDTO) {
        Comment comment = commentRepository.findById(id)
                .orElseThrow(()->new NoSuchElementException("댓글 없음"));
        comment.update(commentUpdateDTO.getContent());
        return comment.getId();
    }

    /**
     * 댓글 삭제
     * @param id
     */
    public void delete(Long id) {
        commentRepository.deleteById(id);
    }

    /**
     * 좋아요
     * @param id
     */
    public void like(Long id) {
        Long member_id = 1L;
        Optional<CommentMemberLike> like = likeRepository.findByCommentIdAndMemberId(id, member_id);

        if (like.isEmpty()) {
            Comment comment = commentRepository.findById(id).orElseThrow(() -> new NoSuchElementException("해당 댓글을 찾을 수 없습니다."));
            Member member = memberRepository.findById(member_id).orElseThrow(() -> new NoSuchElementException("해당 멤버를 찾을 수 없습니다."));
            likeRepository.save(new CommentMemberLike(comment, member));

        } else {
            like.get().updateStatus();
        }
    }

    // 유틸리티 메소드
    /**
     * DTO로 변환
     * @param comment
     * @param member
     * @param board
     * @return
     */
    private static CommentDTO convertToCommentDTO(Comment comment, Member member, Board board, int likeCount) {

        return CommentDTO.builder()
                .commentId(comment.getId())
                .boardId(board.getId())
                .memberId(member.getId())
                .content(comment.getContent())
                .memberNickname(member.getNickname())
                .profileImageUrl(member.getProfileImageUrl())
                .likeCount(likeCount)
                .build();
    }
}
