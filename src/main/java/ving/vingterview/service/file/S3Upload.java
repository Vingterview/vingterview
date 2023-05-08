package ving.vingterview.service.file;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;

@Slf4j
@RequiredArgsConstructor
@Service("S3Upload")
public class S3Upload implements FileStore{

    @Value("${cloud.s3.bucket}")
    private String bucket;

    @Value("${cloud.s3.dir_image}")
    private String dir;
    private final AmazonS3 amazonS3;

    @Override
    public String getFullPath(String fileName) {
        return amazonS3.getUrl(bucket, dir+fileName).toString();
    }

    @Override
    @Async("threadPoolTaskExecutor")
    public void uploadFile(MultipartFile multipartFile, String storeName) {
        ObjectMetadata objMetaData = new ObjectMetadata();
        try {
            objMetaData.setContentLength(multipartFile.getInputStream().available());
            amazonS3.putObject(new PutObjectRequest(bucket,dir+storeName,multipartFile.getInputStream() ,objMetaData).withCannedAcl(CannedAccessControlList.PublicRead));
//            amazonS3.putObject(bucket,dir+storeName,multipartFile.getInputStream() ,objMetaData);

        } catch (IOException e) {
            log.error("FileNotUploadException ", e);
        }



    }

    @Override
    @Async("threadPoolTaskExecutor")
    public void uploadFile(String storeName) {
        log.info("Started uploading file at {} {}", LocalDateTime.now(),Thread.currentThread().getName());

        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
        body.add("videoPath", getFullPath(storeName));
        body.add("name", storeName);
        body.add("bucket", "bucketAddress");
        HttpEntity<?> request = new HttpEntity<>(body, headers);
        ResponseEntity<String> response = restTemplate.postForEntity("http://localhost:5000/boards/video", request, String.class);

        log.info("Response from flask server {}", response);
        log.info("Ended uploading file at {} {}", LocalDateTime.now(),Thread.currentThread().getName());

    }

    @Override
    public void deleteFile(String storeName) {
        amazonS3.deleteObject(bucket,dir+storeName);
    }
}
