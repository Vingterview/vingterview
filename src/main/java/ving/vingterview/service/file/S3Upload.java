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
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;

@Slf4j
@RequiredArgsConstructor
@Service("S3Upload")
public class S3Upload implements FileStore{
    @Value("${video.dir}")
    private String tempDir;

    @Value("${cloud.s3.bucket}")
    private String bucket;


    private final AmazonS3 amazonS3;

    @Override
    public String getFullPath(String fileName,boolean isImg) {
        String dir;
        if (isImg) {
            dir = "image/";
        }else{
            dir = "video/";
        }
        return amazonS3.getUrl(bucket, dir+fileName).toString();
    }

    /**
     * 프로필 이미지 업로드
     * @param multipartFile
     * @param storeName
     */
    @Override
    public void uploadFile(MultipartFile multipartFile, String storeName) {
        ObjectMetadata objMetaData = new ObjectMetadata();
        String dir = "image/";

        try {
            objMetaData.setContentLength(multipartFile.getInputStream().available());
            amazonS3.putObject(new PutObjectRequest(bucket,dir+storeName,multipartFile.getInputStream() ,objMetaData).withCannedAcl(CannedAccessControlList.PublicRead));
        } catch (IOException e) {
            log.error("FileNotUploadException ", e);
        }



    }

    /**
     * 비디오 업로드
     * @param storeName
     */
    @Override
    @Async("threadPoolTaskExecutor")
    public void uploadFile(String storeName) {
        log.info("Started uploading file at {} {}", LocalDateTime.now(),Thread.currentThread().getName());

        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
        String videoPath = tempDir + storeName;
        body.add("videoPath", videoPath);
        body.add("name", storeName);
        body.add("bucket", "bucketAddress");
        HttpEntity<?> request = new HttpEntity<>(body, headers);
        ResponseEntity<String> response = null;
        try {
            response = restTemplate.postForEntity("http://localhost:5000/boards/video", request, String.class);
            log.info("Response from flask server {}", response);
            log.info("Ended uploading file at {} {}", LocalDateTime.now(),Thread.currentThread().getName());
        } catch (ResourceAccessException e) {
            log.error("비디오 변환 과정에서 오류 발생하였습니다.");
            File file = new File(videoPath);
            file.delete();
        }


    }

    @Override
    public void deleteFile(String storeName) {

//        amazonS3.deleteObject(bucket,dir+storeName);
    }
}


