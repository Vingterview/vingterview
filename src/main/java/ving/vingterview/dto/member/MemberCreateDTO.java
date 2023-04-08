package ving.vingterview.dto.member;


import lombok.Data;

@Data
public class MemberCreateDTO {

    private String loginId;
    private String password;
    private String name;
    private int age;
    private String email;
    private String nickname;

    private String profileImageUrl;
}
