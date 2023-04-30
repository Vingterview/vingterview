package ving.vingterview.service.file;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import ving.vingterview.domain.file.UploadFile;
import ving.vingterview.domain.file.VideoFile;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;

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
    @Async("threadPoolTaskExecutor")
    public void uploadFile(MultipartFile multipartFile, String storeFileName) {

        try {
            log.info("Started uploading file at {} {}", LocalDateTime.now(),Thread.currentThread().getName());
            multipartFile.transferTo(new File(getFullPath(storeFileName)));
            log.info("Ended uploading file at {} {}", LocalDateTime.now(),Thread.currentThread().getName());

        } catch (IOException e) {
            log.warn("업로드 폴더 생성 실패 {}", e.getMessage());
        }
    }

    @Override
    public void uploadFile(String storeName) {

    }


    @Override
    public void deleteFile(String fileName) {
        File file = new File(getFullPath(fileName));
        if (file.exists()) {
            file.delete();
        }
    }
}
