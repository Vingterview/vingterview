package ving.vingterview.dto.auth;

import lombok.Getter;
import ving.vingterview.domain.member.Member;

import java.io.Serializable;

@Getter
public class SessionMember implements Serializable {

    private Long id;
    private String name;
    private String email;

    public SessionMember(Member member) {
        this.id = member.getId();
        this.name = member.getName();
        this.email = member.getEmail();
    }
}
