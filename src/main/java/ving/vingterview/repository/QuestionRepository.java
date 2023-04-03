package ving.vingterview.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ving.vingterview.domain.question.Question;

public interface QuestionRepository extends JpaRepository<Question,Long> {
}
