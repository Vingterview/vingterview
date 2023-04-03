package ving.vingterview.dto.comment;

import lombok.Data;

@Data
public class CommentDTO {

    private Long commentId;
    private Long boardId;
    private Long memberId;
    private String memberNickname;
    private String profileImageUrl;
    private String content;
    private int likeCount;
}
