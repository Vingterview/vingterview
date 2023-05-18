package ving.vingterview.dto.comment;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class CommentListDTO {

    private List<CommentDTO> comments;

//    public CommentListDTO(List<CommentDTO> comments) {
//        this.comments = comments;
//    }

    /**
     * 페이징 기능 구현 용도
     */
    private int nextPage;
    private boolean hasNext;
}
