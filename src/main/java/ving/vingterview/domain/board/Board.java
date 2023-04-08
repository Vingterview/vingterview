package ving.vingterview.domain.board;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ving.vingterview.domain.EntityDate;
import ving.vingterview.domain.comment.Comment;
import ving.vingterview.domain.member.Member;
import ving.vingterview.domain.question.Question;

import java.util.List;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Board extends EntityDate {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
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


    @OneToMany(mappedBy = "board",cascade = CascadeType.REMOVE)
    private List<Comment> comments;

    @OneToMany(mappedBy = "board",cascade = CascadeType.REMOVE)
    private List<BoardMemberLike> boardMemberLikes;

    @Builder
    public Board(Question question, Member member, String content, String videoUrl) {
        this.question = question;
        this.member = member;
        this.content = content;
        this.videoUrl = videoUrl;
    }

    public void update(Question question , String content, String videoUrl) {
        this.question = question;
        this.content = content;
        this.videoUrl = videoUrl;
    }

}
