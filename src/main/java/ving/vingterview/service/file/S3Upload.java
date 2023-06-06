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
import java.util.UUID;

@Slf4j
@RequiredArgsConstructor
@Service
public class S3Upload{
    @Value("${video.dir}")
    private String tempDir;

    @Value("${cloud.s3.bucket}")
    private String bucket;


    private final AmazonS3 amazonS3;

    public String createStoreFileName(String originalFilename) {
        String ext = extractExt(originalFilename); // 확장자 추출
        String uuid = UUID.randomUUID().toString();
        return uuid + "." + ext;
    }
    public String extractExt(String originalFilename) {
        int pos = originalFilename.lastIndexOf(".");
        return originalFilename.substring(pos + 1);
    }

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
     *
     * @param storeName
     * @param imgNumber
     */
    @Async("threadPoolTaskExecutor")

    public void uploadFile(String storeName, Long imgNumber) {
        log.info("Started uploading file at {} {}", LocalDateTime.now(),Thread.currentThread().getName());

        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
//        String videoPath = tempDir + storeName;
        String videoPath = amazonS3.getUrl(bucket, "temp/" + storeName).toString();
        body.add("imgNumber", imgNumber.toString());
        body.add("name", storeName);
        body.add("bucket", bucket);
        HttpEntity<?> request = new HttpEntity<>(body, headers);
        ResponseEntity<String> response = null;
        try {
            response = restTemplate.postForEntity("http://18.116.5.117:5000/boards/video", request, String.class);
            log.info("Response from flask server {}", response);
            log.info("Ended uploading file at {} {}", LocalDateTime.now(),Thread.currentThread().getName());
        } catch (ResourceAccessException e) {
            log.error("비디오 변환 과정에서 오류 발생하였습니다.");
            e.printStackTrace();
            File file = new File(videoPath);
            file.delete();
        }


    }

    public void deleteFile(String storeName) {

//        amazonS3.deleteObject(bucket,dir+storeName);
    }
    public void tempFileUpload(MultipartFile multipartFile,String storeName) {
        ObjectMetadata objMetaData = new ObjectMetadata();

        try {
            objMetaData.setContentLength(multipartFile.getInputStream().available());
            amazonS3.putObject(new PutObjectRequest(bucket, "temp/" + storeName, multipartFile.getInputStream(), objMetaData).withCannedAcl(CannedAccessControlList.PublicRead));
            log.info("파일 임시 업로드 성공");
        } catch (IOException e) {
            log.error("파일 임시 업로드 실패 {}", e.getMessage());
        }

    }
}


