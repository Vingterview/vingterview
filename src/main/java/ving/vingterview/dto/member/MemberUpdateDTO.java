package ving.vingterview.dto.member;


import lombok.Data;

@Data
public class MemberUpdateDTO {

    private String name;
    private int age;
    private String email;
    private String nickname;

}