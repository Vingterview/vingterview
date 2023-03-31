package ving.vingterview.domain;

import jakarta.persistence.*;
import lombok.Getter;

@Entity
@Getter
public class Question extends EntityDate{

    @Id
    @GeneratedValue
    @Column(name = "question_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id")
    private Member member;
    private String content;
}
