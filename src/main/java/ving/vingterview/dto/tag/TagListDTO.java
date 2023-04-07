package ving.vingterview.dto.tag;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
public class TagListDTO {
    private List<TagDTO> tags;
}
