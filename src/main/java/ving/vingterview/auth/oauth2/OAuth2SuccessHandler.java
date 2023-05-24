package ving.vingterview.auth.oauth2;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import org.springframework.web.util.UriComponentsBuilder;
import ving.vingterview.auth.jwt.JwtTokenProvider;
import ving.vingterview.domain.member.Member;
import ving.vingterview.auth.dto.Token;
import ving.vingterview.repository.MemberRepository;

import java.io.IOException;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@Component
public class OAuth2SuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    private final MemberRepository memberRepository;
    private final JwtTokenProvider tokenProvider;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException {

        log.info("OAuth2 authenticated");

        OAuth2User oAuth2User = (OAuth2User) authentication.getPrincipal();
        Map<String, Object> attributes = oAuth2User.getAttributes();
        String email = (String) attributes.get("email");
        String name = (String) attributes.get("name");
        log.info("email {} , name {}", email, name);
        Member member = memberRepository.findByEmail(email)
                .orElse(Member.builder()
                        .email(email)
                        .name(name)
                        .profileImageUrl("https://vingterview.s3.ap-northeast-2.amazonaws.com/image/1b9ec992-d85f-4758-bbfc-69b0c68ccc47.png")
                        .build());
        log.info("save member");
        memberRepository.save(member);

        Token token = tokenProvider.generateToken(member.getId(), email);

        String targetUrl = UriComponentsBuilder.fromUriString("/token")
                .queryParam("access_token", token.getAccessToken())
                .queryParam("refresh_token", token.getRefreshToken())
                .build().toUriString();
        getRedirectStrategy().sendRedirect(request, response, targetUrl);
    }
}