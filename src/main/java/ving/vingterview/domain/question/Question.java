package ving.vingterview.domain.question;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ving.vingterview.domain.EntityDate;
import ving.vingterview.domain.member.Member;
import ving.vingterview.domain.tag.TagQuestion;

import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Question extends EntityDate {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "question_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id")
    private Member member;
    private String content;

    @OneToMany(mappedBy = "question")
    private List<TagQuestion> tags = new ArrayList<>();

    @OneToMany(mappedBy = "question", cascade = CascadeType.REMOVE)
    private List<QuestionMemberScrap> scraps = new ArrayList<>();


    @Builder
    public Question(Member member, String content) {
        this.member = member;
        this.content = content;
    }

    public void setMemberNull() {
        member = null;
    }

}
