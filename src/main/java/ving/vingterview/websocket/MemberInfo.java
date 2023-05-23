package ving.vingterview.websocket;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.util.Base64;

@Data
@Slf4j
public class MemberInfo {
    String sessionId;
    String name;
    String encodedImage;

    public void convertImageToBase64(String imageUrl) {
        URL url = null;
        InputStream is = null;
        ByteArrayOutputStream baos = null;
        try {
            url = new URL(imageUrl);
            is = url.openStream();
            baos = new ByteArrayOutputStream();

            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = is.read(buffer)) != -1) {
                baos.write(buffer, 0, bytesRead);
            }

            byte[] imageBytes = baos.toByteArray();
            String base64Image = Base64.getEncoder().encodeToString(imageBytes);

            is.close();
            baos.close();
            this.encodedImage = base64Image;

        }
        catch (Exception e) {
            log.error("Exception convertImageToBase64");
            if(imageUrl == "https://vingterview.s3.ap-northeast-2.amazonaws.com/image/ced77a75-31f1-47ce-82a0-6923b55cb7bb.png"){
                log.error("기본 이미지 인코딩 실패");
                this.encodedImage = "";
                return;
            }
            convertImageToBase64("https://vingterview.s3.ap-northeast-2.amazonaws.com/image/ced77a75-31f1-47ce-82a0-6923b55cb7bb.png");
        }
    }
}
