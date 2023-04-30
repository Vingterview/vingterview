package ving.vingterview.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
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
            " join fetch b.question  q " +
            " where " +
            " m.id = :memberId")
    Slice<Board> findByMemberIdWithMemberQuestion(@Param(value = "memberId") Long memberId,Pageable pageable);

    @Query("select b from Board  b " +
            " join fetch b.member m " +
            " join fetch b.question  q " +
            " where " +
            " q.id = :questionId")
    Slice<Board> findByQuestionIdWithMemberQuestion(@Param(value = "questionId") Long questionId,Pageable pageable);

    Page<Board> findPageBy(Pageable pageable);
    Slice<Board> findSliceBy(Pageable pageable);

    @Query("select b from Board b " +
            " left outer join b.boardMemberLikes bml " +
            " join fetch b.member m " +
            " join fetch b.question q " +
            " group by b.id " +
            " order by count(bml.id) desc, b.createTime desc ")
    Slice<Board> orderSliceByLike(Pageable pageable);

    @Query("select b from Board b " +
            " left outer join b.comments c " +
            " join fetch b.member m " +
            " join fetch b.question q " +
            " group by b.id " +
            " order by count(c.id) desc, b.createTime desc ")
    Slice<Board> orderSliceByComment(Pageable pageable);

    int countByQuestion(Question question);


}
