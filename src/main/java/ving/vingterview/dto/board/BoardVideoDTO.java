package ving.vingterview.dto.board;

import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

@Data
public class BoardVideoDTO {

    private MultipartFile video;
}
