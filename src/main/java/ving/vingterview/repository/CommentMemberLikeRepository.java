package ving.vingterview.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ving.vingterview.domain.comment.CommentMemberLike;

public interface CommentMemberLikeRepository extends JpaRepository<CommentMemberLike,Long> {
}
