package ving.vingterview.dto.member;

import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

@Data
public class ProfileImageDTO {
    private MultipartFile profileImage;
}
