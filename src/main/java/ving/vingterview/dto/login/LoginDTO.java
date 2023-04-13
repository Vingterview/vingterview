package ving.vingterview.dto.login;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class LoginDTO {

    @JsonProperty("id")
    private String loginId;
    private String password;

}
