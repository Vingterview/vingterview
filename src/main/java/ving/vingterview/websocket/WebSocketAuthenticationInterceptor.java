package ving.vingterview.websocket;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;
import ving.vingterview.auth.jwt.JwtUserDetails;
import ving.vingterview.domain.member.Member;
import ving.vingterview.repository.MemberRepository;

import java.util.Map;

@Slf4j
@Component
@RequiredArgsConstructor
public class WebSocketAuthenticationInterceptor implements HandshakeInterceptor {

    private final MemberRepository memberRepository;

    @Override
    public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler, Map<String, Object> attributes) throws Exception {
        JwtUserDetails principal = (JwtUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long memberId = principal.getId();
        Member member = memberRepository.findById(memberId).orElseThrow(() -> new EntityNotFoundException("찾을 수 없는 사용자입니다."));
//        Member member = memberRepository.findById(2L).orElseThrow(() -> new EntityNotFoundException("찾을 수 없는 사용자입니다."));

        attributes.put("name", member.getName());
        attributes.put("imageUrl", member.getProfileImageUrl());
        return true;
    }

    @Override
    public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler, Exception exception) {
    }


}
