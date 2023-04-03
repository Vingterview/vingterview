package ving.vingterview.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ving.vingterview.domain.comment.Comment;

public interface CommentRepository extends JpaRepository<Comment,Long> {
}
