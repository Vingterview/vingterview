package ving.vingterview.dto.comment;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

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

    private LocalDateTime createTime;
    private LocalDateTime updateTime;

    @Builder
    public CommentDTO(Long commentId, Long boardId, Long memberId, String memberNickname, String profileImageUrl, String content, int likeCount, LocalDateTime createTime, LocalDateTime updateTime) {
        this.commentId = commentId;
        this.boardId = boardId;
        this.memberId = memberId;
        this.memberNickname = memberNickname;
        this.profileImageUrl = profileImageUrl;
        this.content = content;
        this.likeCount = likeCount;
        this.createTime = createTime;
        this.updateTime = updateTime;
    }
}
