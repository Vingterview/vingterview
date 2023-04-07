package ving.vingterview.repository;

import org.hibernate.annotations.BatchSize;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import ving.vingterview.domain.board.Board;

import java.util.List;
import java.util.Optional;

public interface BoardRepository extends JpaRepository<Board,Long> {

    @Query("select b from Board  b " +
            " join fetch b.member m " +
            " join fetch b.question  q" +
            " where b.id = :id ")
    Optional<Board> findByIdWithMemberQuestion(@Param(value = "id") Long id);

    @Query("select b from Board  b " +
            " join fetch b.member m " +
            " join fetch b.question  q" +
            " where b.id in :ids ")
    List<Board> findByIdsWithMemberQuestion(@Param(value = "ids") List<Long> ids);


    List<Board> findByMemberId(Long memberId);


    List<Board> findByQuestionId(Long questionId);
}
