package ving.vingterview.service.file;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import ving.vingterview.domain.file.ImgFile;
import ving.vingterview.domain.file.UploadFile;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Component("imgStore")
public class ImgStoreMemory implements FileStore{

    @Value("${img.dir}")
    private String fileDir;

    @Override
    public String getFullPath(String fileName) {
        return fileDir + fileName;
    }


    @Override
    public UploadFile storeFile(String originalFileName) {

        String storeFileName = createStoreFileName(originalFileName);
        return new ImgFile(originalFileName, storeFileName);
    }

    @Override
    @Async
    public void uploadFile(MultipartFile multipartFile, String storeFileName) {

        if (multipartFile.isEmpty()) {
            log.warn("null");
        }

        try {
            multipartFile.transferTo(new File(getFullPath(storeFileName)));
        } catch (IOException e) {
            log.warn("업로드 폴더 생성 실패 {}", e.getMessage());
        }
    }

    @Override
    public void deleteFile(String fileName) {
        File file = new File(getFullPath(fileName));
        if (file.exists()) {
            file.delete();
        }
    }
}
