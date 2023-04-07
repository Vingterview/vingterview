package ving.vingterview.dto.board;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor(access = AccessLevel.PROTECTED)
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



    @Builder
    public BoardDTO(Long id, Long questionId, String questionContent, Long memberId, String memberNickname, String profileImageUrl, String content, String videoUrl, int likeCount, int commentCount, LocalDateTime createTime, LocalDateTime updateTime) {
        this.id = id;
        this.questionId = questionId;
        this.questionContent = questionContent;
        this.memberId = memberId;
        this.memberNickname = memberNickname;
        this.profileImageUrl = profileImageUrl;
        this.content = content;
        this.videoUrl = videoUrl;
        this.likeCount = likeCount;
        this.commentCount = commentCount;
        this.createTime = createTime;
        this.updateTime = updateTime;
    }
}
