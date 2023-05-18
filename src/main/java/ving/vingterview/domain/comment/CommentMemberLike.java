package ving.vingterview.domain.comment;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ving.vingterview.domain.LikeType;
import ving.vingterview.domain.member.Member;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class CommentMemberLike {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "comment_member_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "comment_id")
    private Comment comment;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id")
    private Member member;

    @Enumerated(EnumType.STRING)
    private LikeType likeStatus;

    @Builder
    public CommentMemberLike(Comment comment, Member member) {
        this.comment = comment;
        this.member = member;
        this.likeStatus = LikeType.LIKE;
    }

    public void updateStatus() {
        if (this.likeStatus == LikeType.LIKE) {
            this.likeStatus = LikeType.UNLIKE;
        }else{
            this.likeStatus = LikeType.LIKE;
        }
    }
}
