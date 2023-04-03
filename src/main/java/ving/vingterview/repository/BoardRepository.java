package ving.vingterview.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ving.vingterview.domain.board.Board;

public interface BoardRepository extends JpaRepository<Board,Long> {
}
