package ving.vingterview.repository;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ving.vingterview.domain.question.Question;

import java.util.List;
import java.util.Optional;


public interface QuestionRepository extends JpaRepository<Question,Long> {

    Slice<Question> findAllByMemberId(Long memberId,Pageable pageable);

    Slice<Question> findSliceBy(Pageable pageable);

    @Query("select q from Question q " +
            "left outer join QuestionMemberScrap qms on q.id = qms.question.id " +
            "group by q.id " +
            "order by count(qms.id) desc , q.createTime desc")
    Slice<Question> orderByScrap(PageRequest pageRequest);

    @Query("select q from Question q " +
            "left outer join Board b on q.id = b.question.id " +
            "group by q.id " +
            "order by count(b.id) desc , q.createTime desc")
    Slice<Question> orderByVideo(PageRequest pageRequest);

    @Query("select q from Question  q order by rand() limit 1")
    Question findRandom();
}
