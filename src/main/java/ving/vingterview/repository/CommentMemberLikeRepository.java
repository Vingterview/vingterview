package ving.vingterview.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ving.vingterview.domain.LikeType;
import ving.vingterview.domain.comment.Comment;
import ving.vingterview.domain.comment.CommentMemberLike;

import java.util.Optional;

public interface CommentMemberLikeRepository extends JpaRepository<CommentMemberLike,Long> {

    Optional<CommentMemberLike> findByCommentIdAndMemberId(Long commentId, Long memberId);

    int countByCommentAndLikeStatus(Comment comment, LikeType status);

}
