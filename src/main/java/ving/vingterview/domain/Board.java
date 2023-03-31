package ving.vingterview.domain;

import jakarta.persistence.*;
import lombok.Getter;

@Entity
@Getter
public class Board extends EntityDate{

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

}
