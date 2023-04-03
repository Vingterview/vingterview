package ving.vingterview.dto.comment;

import lombok.Data;

import java.util.List;

@Data
public class CommentListDTO {

    private List<CommentDTO> comments;
}
