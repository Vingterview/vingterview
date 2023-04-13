package ving.vingterview.dto.question;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class QuestionListDTO {

    private List<QuestionDTO> questions;
}
