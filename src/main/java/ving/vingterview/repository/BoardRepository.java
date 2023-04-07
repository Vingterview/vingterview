package ving.vingterview.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import ving.vingterview.domain.board.Board;

import java.util.Optional;

public interface BoardRepository extends JpaRepository<Board,Long> {

    @Query("select b from Board  b " +
            " join fetch b.member m " +
            " join fetch b.question  q" +
            " where b.id = :id")
    Optional<Board> findByIdWithMemberQuestion(@Param(value = "id") Long id);

}
