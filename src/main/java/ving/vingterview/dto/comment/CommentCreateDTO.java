package ving.vingterview.dto.comment;

import lombok.Data;

@Data
public class CommentCreateDTO {

    private Long boardId;
//    private Long memberId;
    private String content;
}
