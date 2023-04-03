package ving.vingterview.dto.board;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class BoardDTO {

    private Long id;
    private Long questionId;
    private String questionContent;
    private Long memberId;
    private String memberNickname;
    private String profileImageUrl;
    private String content;
    private String videoUrl;
    private int likeCount;
    private int commentCount;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;

}
