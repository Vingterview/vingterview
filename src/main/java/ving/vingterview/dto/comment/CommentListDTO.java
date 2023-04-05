package ving.vingterview.dto.comment;

import lombok.Data;

import java.util.List;

@Data
public class CommentListDTO {

    private List<CommentDTO> comments;

    public CommentListDTO(List<CommentDTO> comments) {
        this.comments = comments;
    }
}
