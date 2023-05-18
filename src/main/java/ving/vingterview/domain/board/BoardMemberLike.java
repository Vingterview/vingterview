package ving.vingterview.domain.board;

import jakarta.persistence.*;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ving.vingterview.domain.LikeType;
import ving.vingterview.domain.member.Member;

@Entity
@Getter
@NoArgsConstructor
public class BoardMemberLike {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "board_member_id")
    private Long id;

    @Enumerated(EnumType.STRING)
    private LikeType likeStatus;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "board_id")
    private Board board;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id")
    private Member member;

    @Builder
    public BoardMemberLike(Board board, Member member) {
        this.board = board;
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
