package ving.vingterview.dto.board;

import lombok.Data;

@Data
public class BoardCreateDTO {

    private Long questionId;
    private Long memberId;
    private String content;
}
