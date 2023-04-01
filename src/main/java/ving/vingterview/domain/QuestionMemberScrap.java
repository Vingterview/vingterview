package ving.vingterview.domain;

import jakarta.persistence.*;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor
public class QuestionMemberScrap {

    @Id
    @GeneratedValue
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
}
