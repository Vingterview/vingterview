package ving.vingterview.dto.question;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import ving.vingterview.dto.tag.TagDTO;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
public class QuestionDTO {

    private Long questionId;
    private String questionContent;
    private LocalDateTime createTime;
    private int scrapCount;
    private int boardCount;
    private List<TagDTO> tags;

    @Builder
    public QuestionDTO(Long questionId, String questionContent, LocalDateTime createTime, int scrapCount, int boardCount, List<TagDTO> tags) {
        this.questionId = questionId;
        this.questionContent = questionContent;
        this.createTime = createTime;
        this.scrapCount = scrapCount;
        this.boardCount = boardCount;
        this.tags = tags;
    }
}
