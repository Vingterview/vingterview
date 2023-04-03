package ving.vingterview.dto.question;

import lombok.Data;

import java.util.List;

@Data
public class QuestionCreateDTO {

    private List<Long> tags;
    private Long memberId;
    private String questionContent;
}
