package ving.vingterview.repository;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import ving.vingterview.domain.tag.TagQuestion;

import java.util.List;

public interface TagQuestionRepository extends JpaRepository<TagQuestion,Long> {

    @Query("select tq from TagQuestion tq " +
            "join fetch tq.question q " +
            "where tq.tag.id in (:tagIds)")
    Slice<TagQuestion> findAllQuestionByTagId(@Param("tagIds") List<Long> tagIds, Pageable pageable);

    @Query("select tq from TagQuestion tq " +
            " where tq.tag.id = :tagId" +
            " order by rand() " +
            " limit 3")
    List<TagQuestion> findRandom(@Param("tagId") Integer tagId);



}
