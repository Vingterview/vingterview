package ving.vingterview.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ving.vingterview.domain.question.Question;

import java.util.List;

public interface QuestionRepository extends JpaRepository<Question,Long> {

    List<Question> findAllByMemberId(Long memberId);

}
