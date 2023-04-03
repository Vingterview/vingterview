package ving.vingterview.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import ving.vingterview.dto.login.LoginDTO;

@RestController
@RequiredArgsConstructor
public class LoginController {

    @PostMapping("/login")
    public Long login(@ModelAttribute LoginDTO loginDTO) {
        // 로그인
        return null;
    }

    @PostMapping("/logout")
    public void logout() {
        // 로그아웃
        return;
    }
}
