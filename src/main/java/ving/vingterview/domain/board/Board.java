package ving.vingterview.domain.board;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ving.vingterview.domain.EntityDate;
import ving.vingterview.domain.member.Member;
import ving.vingterview.domain.question.Question;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Board extends EntityDate {

    @Id
    @GeneratedValue
    @Column(name = "board_id")
    private Long id;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "question_id")
    private Question question;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id")
    private Member member;
    private String content;
    private String videoUrl;


    @Builder
    public Board(Question question, Member member, String content, String videoUrl) {
        this.question = question;
        this.member = member;
        this.content = content;
        this.videoUrl = videoUrl;
    }
}
