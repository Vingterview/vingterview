package ving.vingterview.dto.comment;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class CommentDTO {

    private Long commentId;
    private Long boardId;
    private Long memberId;
    private String memberNickname;
    private String profileImageUrl;
    private String content;
    private int likeCount;

    @Builder
    public CommentDTO(Long commentId, Long boardId, Long memberId, String memberNickname, String profileImageUrl, String content, int likeCount) {
        this.commentId = commentId;
        this.boardId = boardId;
        this.memberId = memberId;
        this.memberNickname = memberNickname;
        this.profileImageUrl = profileImageUrl;
        this.content = content;
        this.likeCount = likeCount;
    }
}
