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


    public MemberDTO() {
    }

    public MemberDTO(Long memberId, String id, String name, int age, String email, String nickname, String profileImageUrl) {
        this.memberId = memberId;
        this.id = id;
        this.name = name;
        this.age = age;
        this.email = email;
        this.nickname = nickname;
        this.profileImageUrl = profileImageUrl;
    }
}
