package ving.vingterview.domain.file;

import lombok.Getter;

@Getter
public class UploadFile {

    private String uploadFileName;
    private String storeFileName;

    protected UploadFile() {

    }
    public UploadFile(String uploadFileName, String storeFileName) {
        this.uploadFileName = uploadFileName;
        this.storeFileName = storeFileName;
    }
}
