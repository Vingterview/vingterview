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
}
