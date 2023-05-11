package ving.vingterview.service.file;


import org.springframework.web.multipart.MultipartFile;

import java.util.UUID;

public interface FileStore {


    String getFullPath(String fileName,boolean isImg);


    void uploadFile(MultipartFile multipartFile,String storeName);

    void uploadFile(String storeName);


    void deleteFile(String fileName);



    default String createStoreFileName(String originalFilename) {
        String ext = extractExt(originalFilename); // 확장자 추출
        String uuid = UUID.randomUUID().toString();
        return uuid + "." + ext;
    }
    default String extractExt(String originalFilename) {
        int pos = originalFilename.lastIndexOf(".");
        return originalFilename.substring(pos + 1);
    }


}
