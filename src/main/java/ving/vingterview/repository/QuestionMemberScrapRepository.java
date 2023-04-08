package ving.vingterview.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import ving.vingterview.domain.comment.CommentMemberLike;
import ving.vingterview.domain.question.Question;
import ving.vingterview.domain.question.QuestionMemberScrap;
import ving.vingterview.domain.tag.TagQuestion;

import java.util.List;
import java.util.Optional;

public interface QuestionMemberScrapRepository extends JpaRepository<QuestionMemberScrap,Long> {

    int countByQuestion(Question question);

    @Query("select s from QuestionMemberScrap s " +
            "join fetch s.question q " +
            "where s.member.id = :memberId")
    List<QuestionMemberScrap> findAllQuestionByMemberId(@Param("memberId") Long scrapMemberId);

    Optional<QuestionMemberScrap> findByQuestionIdAndMemberId(Long questionId, Long memberId);
}
