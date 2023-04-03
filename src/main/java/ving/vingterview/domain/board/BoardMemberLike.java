package ving.vingterview.domain.board;

import jakarta.persistence.*;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ving.vingterview.domain.member.Member;

@Entity
@Getter
@NoArgsConstructor
public class BoardMemberLike {

    @Id
    @GeneratedValue
    @Column(name = "board_member_id")
    private Long id;

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
    }
}
