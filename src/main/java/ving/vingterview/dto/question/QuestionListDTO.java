package ving.vingterview.dto.question;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class QuestionListDTO {

    private List<QuestionDTO> questions;

    /**
     * 페이징 기능 구현 용도
     */
    private int nextPage;
    private boolean hasNext;
}
