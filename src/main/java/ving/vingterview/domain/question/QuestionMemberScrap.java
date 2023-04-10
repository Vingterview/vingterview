package ving.vingterview.domain.question;

import jakarta.persistence.*;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ving.vingterview.domain.member.Member;

@Entity
@Getter
@NoArgsConstructor
public class QuestionMemberScrap {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "question_member_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "question_id")
    private Question question;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id")
    private Member member;

    @Builder
    public QuestionMemberScrap(Question question, Member member) {
        this.question = question;
        this.member = member;
    }

    // 연관관계 편의 메소드
    public void setQuestion(Question question) {
        this.question = question;
        question.getScraps().add(this);
    }
}
