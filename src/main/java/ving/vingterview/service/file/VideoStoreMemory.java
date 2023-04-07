package ving.vingterview.service.file;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
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
@Component("videoStore")
public class VideoStoreMemory implements FileStore {

    @Value("${video.dir}")
    private String fileDir;

    @Override
    public String getFullPath(String fileName) {
        return fileDir + fileName;
    }

    @Override
    @Transactional
    public List<UploadFile> storeFiles(List<MultipartFile> multipartFiles) {

        List<UploadFile> storeFileResult = new ArrayList<>();

        for (MultipartFile multipartFile : multipartFiles) {
            if (!multipartFile.isEmpty()) {
                storeFileResult.add(storeFile(multipartFile));
            }
        }

        return storeFileResult;
    }

    @Override
    @Transactional
    public UploadFile storeFile(MultipartFile multipartFile) {

        if (multipartFile.isEmpty()) {
            return null;
        }

        String originalFilename = multipartFile.getOriginalFilename();
        String storeFileName = createStoreFileName(originalFilename);
        try {
            multipartFile.transferTo(new File(getFullPath(storeFileName)));
        } catch (IOException e) {
            log.warn("업로드 폴더 생성 실패 {}", e.getMessage());
        }
        return new ImgFile(originalFilename, storeFileName);
    }

    @Override
    public void deleteFile(String fileName) {
        File file = new File(getFullPath(fileName));
        if (file.exists()) {
            file.delete();
        }
    }
}
