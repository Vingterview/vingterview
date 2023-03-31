package ving.vingterview.domain;

import jakarta.persistence.*;
import lombok.Getter;

@Entity
@Getter
public class TagQuestion {

    @Id
    @GeneratedValue
    @Column(name = "tag_question_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "tag_id")
    private Tag tag;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "question_id")
    private Question question;
}
