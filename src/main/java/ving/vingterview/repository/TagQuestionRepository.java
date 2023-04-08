package ving.vingterview.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import ving.vingterview.domain.question.Question;
import ving.vingterview.domain.tag.TagQuestion;

import java.util.List;

public interface TagQuestionRepository extends JpaRepository<TagQuestion,Long> {

    @Query("select tq from TagQuestion tq " +
            "join fetch tq.question q " +
            "where tq.tag.id in (:tagIds)")
    List<TagQuestion> findAllQuestionByTagId(@Param("tagIds") List<Long> tagIds);

}
