package ving.vingterview.dto.board;

import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

@Data
public class VideoDTO {

    private MultipartFile video;
}
