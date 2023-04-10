package ving.vingterview.dto.member;


import lombok.Data;

@Data
public class MemberDTO {

    private Long memberId;
    private String id;
    private String name;
    private int age;
    private String email;
    private String nickname;
    private String profileImageUrl;

}
