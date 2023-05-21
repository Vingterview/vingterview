package ving.vingterview.service.comment;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.AccessDeniedException;
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
    public Long create(Long memberId, CommentCreateDTO commentCreateDTO) {
        Board board = boardRepository.findById(commentCreateDTO.getBoardId())
                .orElseThrow(()->new EntityNotFoundException("게시글 없음"));
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new EntityNotFoundException("회원 없음"));
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
                .orElseThrow(()->new EntityNotFoundException("댓글 없음"));
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
    public CommentListDTO findByBoard(Long boardId,int page,int size) {
        Board board = boardRepository.findById(boardId)
                .orElseThrow(() -> new EntityNotFoundException("게시글 없음"));

        /****페이징 추가 부분 ******/
        PageRequest pageRequest = PageRequest.of(page, size, Sort.by("createTime").ascending());
        Slice<Comment> comments = commentRepository.findSliceByBoard(board,pageRequest);
        /*****페이징 추가 부분 *****/


        List<CommentDTO> results = comments.stream()
                .map(comment -> {
                    Member member = comment.getMember();
                    int likeCount = likeRepository.countByCommentAndLikeStatus(comment, LikeType.LIKE);
                    return convertToCommentDTO(comment, member, board, likeCount);
                })
                .toList();

        /*****페이징 추가 부분 *****/
        return new CommentListDTO(results,page+1,comments.hasNext());
        /*****페이징 추가 부분 *****/
    }

    /**
     * 회원이 작성한 댓글 조회
     * @param memberId
     * @return
     */
    @Transactional(readOnly = true)
    public CommentListDTO findByMember(Long memberId,int page,int size) {
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new EntityNotFoundException("회원 없음"));

        /****페이징 추가 부분 ******/
        PageRequest pageRequest = PageRequest.of(page, size, Sort.by("createTime").ascending());
        Slice<Comment> comments = commentRepository.findSliceByMember(member,pageRequest);
        /*****페이징 추가 부분 *****/

        List<CommentDTO> results = comments.stream()
                .map((comment) -> {
                    Board board = comment.getBoard();
                    int likeCount = likeRepository.countByCommentAndLikeStatus(comment, LikeType.LIKE);
                    return convertToCommentDTO(comment, member, board, likeCount);
                })
                .toList();

        /*****페이징 추가 부분 *****/
        return new CommentListDTO(results,page+1,comments.hasNext());
        /*****페이징 추가 부분 *****/
    }

    /**
     * 댓글 수정
     *
     * @param id
     * @param commentUpdateDTO
     * @param memberId
     * @return
     */
    public Long update(Long id, CommentUpdateDTO commentUpdateDTO, Long memberId) {
        Comment comment = commentRepository.findById(id)
                .orElseThrow(()->new EntityNotFoundException("댓글 없음"));

        if (comment.getMember().getId() != memberId) {
            throw new AccessDeniedException("작성자만 댓글을 수정할 수 있습니다.");
        }

        comment.update(commentUpdateDTO.getContent());
        return comment.getId();
    }

    /**
     * 댓글 삭제
     *
     * @param id
     * @param memberId
     */
    public void delete(Long id, Long memberId) {
        Comment comment = commentRepository.findById(id)
                .orElseThrow(()->new EntityNotFoundException("댓글 없음"));

        if (comment.getMember().getId() != memberId) {
            throw new AccessDeniedException("작성자만 댓글을 삭제할 수 있습니다.");
        }
        commentRepository.deleteById(id);
    }

    /**
     * 좋야요
     * @param memberId
     * @param boardId
     */
    public void like(Long memberId, Long boardId) {
        Optional<CommentMemberLike> like = likeRepository.findByCommentIdAndMemberId(boardId, memberId);

        if (like.isEmpty()) {
            Comment comment = commentRepository.findById(boardId).orElseThrow(() -> new EntityNotFoundException("해당 댓글을 찾을 수 없습니다."));
            Member member = memberRepository.findById(memberId).orElseThrow(() -> new EntityNotFoundException("해당 멤버를 찾을 수 없습니다."));
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
                .createTime(comment.getCreateTime())
                .updateTime(comment.getUpdateTime())
                .build();
    }
}
