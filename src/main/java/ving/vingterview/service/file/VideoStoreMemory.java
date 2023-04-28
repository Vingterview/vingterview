package ving.vingterview.service.file;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.time.LocalDateTime;


@Slf4j
@Component("videoStore")
public class VideoStoreMemory implements FileStore {

    @Value("${video.dir}")
    private String fileDir;

    @Override
    public String getFullPath(String fileName) {
        return fileDir + fileName;
    }



    @Override
    public void uploadFile(MultipartFile multipartFile, String storeName) {

    }

    @Override
    @Async("threadPoolTaskExecutor")
    public void uploadFile(String storeFileName) {

        try {
            log.info("Started uploading file at {} {}", LocalDateTime.now(),Thread.currentThread().getName());


            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
            body.add("videoPath", getFullPath(storeFileName));
            body.add("name", storeFileName);
            body.add("bucket", "bucketAddress");
            HttpEntity<?> request = new HttpEntity<>(body, headers);
            ResponseEntity<String> response = restTemplate.postForEntity("http://localhost:5000/boards/video", request, String.class);

            log.info("Response from flask server {}", response);
            log.info("Ended uploading file at {} {}", LocalDateTime.now(),Thread.currentThread().getName());

        } catch (Exception e) {
            log.warn(e.getMessage());
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
