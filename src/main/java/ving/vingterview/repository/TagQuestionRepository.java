package ving.vingterview.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ving.vingterview.domain.tag.TagQuestion;

public interface TagQuestionRepository extends JpaRepository<TagQuestion,Long> {
}
