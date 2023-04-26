package ving.vingterview.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import ving.vingterview.annotation.LoginMember;
import ving.vingterview.dto.auth.SessionMember;
import ving.vingterview.dto.login.LoginResponseDTO;

@Slf4j
@RestController
@RequiredArgsConstructor
public class LoginController {

    @GetMapping("/login-success")
    public ResponseEntity<LoginResponseDTO> loginSuccess(@LoginMember SessionMember sessionMember) {
        LoginResponseDTO dto = new LoginResponseDTO();
        dto.setMemberId(sessionMember.getId());

        return new ResponseEntity<>(dto, HttpStatus.CREATED);
    }

    @GetMapping("/logout-success")
    public ResponseEntity<String> logoutSuccess() {
        return ResponseEntity.ok("logout");
    }
}
