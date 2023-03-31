package ving.vingterview.domain;

import jakarta.persistence.*;
import lombok.Getter;

@Entity
@Getter
public class CommentMemberLike {

    @Id
    @GeneratedValue
    @Column(name = "comment_member_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "comment_id")
    private Comment comment;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id")
    private Member member;
}
