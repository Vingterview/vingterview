package ving.vingterview.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import ving.vingterview.domain.board.Board;
import ving.vingterview.domain.question.Question;


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
            " where " +
            " b.id in :boardIds")
    List<Board> findByIdsWithMemberQuestion(@Param(value = "boardIds") List<Long> boardIds);

    @Query("select b from Board  b " +
            " join fetch b.member m " +
            " join fetch b.question  q" +
            " where " +
            " m.id = :memberId")
    List<Board> findByMemberIdWithMemberQuestion(@Param(value = "memberId") Long memberId);

    @Query("select b from Board  b " +
            " join fetch b.member m " +
            " join fetch b.question  q" +
            " where " +
            " q.id = :questionId")
    List<Board> findByQuestionIdWithMemberQuestion(@Param(value = "questionId") Long questionId);


    List<Board> findByMemberId(Long memberId);


    List<Board> findByQuestionId(Long questionId);

    int countByQuestion(Question question);
}
