package ving.vingterview.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ving.vingterview.domain.board.BoardMemberLike;

public interface BoardMemberLikeRepository extends JpaRepository<BoardMemberLike,Long> {
}
