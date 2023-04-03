package ving.vingterview.dto.question;

import lombok.Data;
import ving.vingterview.dto.tag.TagDTO;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class QuestionDTO {

    private Long questionId;
    private String questionContent;
    private LocalDateTime createTime;
    private int scrapCount;
    private int boardCount;
    private List<TagDTO> tags;
}
