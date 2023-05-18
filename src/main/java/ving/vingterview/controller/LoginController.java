package ving.vingterview.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import ving.vingterview.annotation.LoginMemberId;
import ving.vingterview.auth.dto.Token;
import ving.vingterview.auth.jwt.JwtTokenProvider;
import ving.vingterview.dto.login.LoginResponseDTO;
import ving.vingterview.dto.login.LoginUrlDTO;

import java.io.IOException;

@Slf4j
@RestController
@RequiredArgsConstructor
public class LoginController {

    private final JwtTokenProvider tokenProvider;

    @GetMapping("/login-success")
    public ResponseEntity<LoginResponseDTO> loginSuccess(@LoginMemberId Long memberId) {
        LoginResponseDTO dto = new LoginResponseDTO();
        dto.setMemberId(memberId);

        return new ResponseEntity<>(dto, HttpStatus.CREATED);
    }

    @GetMapping("/logout-success")
    public ResponseEntity<String> logoutSuccess() {
        return ResponseEntity.ok("logout");
    }

    @GetMapping("/login")
    public ResponseEntity<LoginUrlDTO> login(HttpServletRequest request, HttpServletResponse response) throws IOException {
        //토큰 재발급 요청일경우 /token/refresh로 리다이렉션
        if (request.getHeader("X-Refresh-Token") != null) {
            response.sendRedirect("/token/refresh");
            return new ResponseEntity<>(null, HttpStatus.FOUND);
        }

        // 로그인 url 반환
        String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();

        LoginUrlDTO dto = new LoginUrlDTO();
        dto.setLoginUrl(baseUrl + "/oauth2/authorization/google");

        return ResponseEntity.ok(dto);
    }

    //TODO 토큰 재발급
    @GetMapping("/token/refresh")
    public ResponseEntity<Token> refreshToken(HttpServletRequest request, HttpServletResponse response) {
        String refreshTokenHeader = request.getHeader("X-Refresh-Token");
        String refreshToken = null;

        if (refreshTokenHeader != null && refreshTokenHeader.startsWith("Bearer")) {
            refreshToken = refreshTokenHeader.substring(7);
        }

        if (tokenProvider.verifyToken(refreshToken)) {
            Token token = tokenProvider.refresh(refreshToken);
            if (token != null) {
                return ResponseEntity.ok(token);
            } else {
                return new ResponseEntity<>(null, HttpStatus.BAD_REQUEST);
            }
        } else {
            return new ResponseEntity<>(null, HttpStatus.BAD_REQUEST);
        }
    }
}
