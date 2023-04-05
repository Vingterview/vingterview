package ving.vingterview.domain.member;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ving.vingterview.domain.EntityDate;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Member  extends EntityDate {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "member_id")
    private Long id;

    private String loginId;
    private String password;
    private String name;
    private String nickname;
    private int age;
    private String email;
    private String profileImageUrl;


    @Builder
    public Member(String loginId, String password, String name, String nickname, int age,String email,String profileImageUrl) {
        this.loginId = loginId;
        this.password = password;
        this.name = name;
        this.nickname = nickname;
        this.age = age;
        this.email = email;
        this.profileImageUrl = profileImageUrl;

    }

    public void update(String name, int age, String email, String nickname, String profileImageUrl) {

        this.name = name;
        this.nickname = nickname;
        this.age = age;
        this.email = email;
        this.profileImageUrl = profileImageUrl;
    }
}
