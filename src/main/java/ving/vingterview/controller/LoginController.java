package ving.vingterview.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import ving.vingterview.dto.login.LoginDTO;
import ving.vingterview.dto.login.LoginResponseDTO;

@RestController
@RequiredArgsConstructor
public class LoginController {

    @PostMapping("/login")
    public ResponseEntity<LoginResponseDTO> login(@ModelAttribute LoginDTO loginDTO) {
        LoginResponseDTO dto = new LoginResponseDTO();
        dto.setMemberId(1L);
        return new ResponseEntity<>(dto, HttpStatus.CREATED);
    }
    @PostMapping("/logout")
    public void logout() {
        // 로그아웃
        return;
    }
}
