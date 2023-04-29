package ving.vingterview.service.auth;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import ving.vingterview.dto.auth.OAuthAttributes;
import ving.vingterview.dto.auth.SessionMember;
import ving.vingterview.domain.member.Member;
import ving.vingterview.repository.MemberRepository;

import java.util.Set;

@Slf4j
@RequiredArgsConstructor
@Service
public class OAuth2MemberService implements OAuth2UserService<OAuth2UserRequest, OAuth2User> {

    private final MemberRepository memberRepository;
    private final HttpSession session;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        //////////////////////////////////////////////////////////////////////////////////////////////////
        log.info("=============================OAuthService=============================");

        log.info("access token: {}", userRequest.getAccessToken().getTokenValue());
        log.info("RedirectUri: {}", userRequest.getClientRegistration().getRedirectUri());
        log.info("ClientId: {}", userRequest.getClientRegistration().getClientId());
        log.info("RegistrationId: {}", userRequest.getClientRegistration().getRegistrationId());
        log.info("UserNameAttributeName: {}", userRequest.getClientRegistration().getProviderDetails().getUserInfoEndpoint().getUserNameAttributeName());
        log.info("ClientName: {}", userRequest.getClientRegistration().getClientName());
        log.info("AdditionalParameters: {}", userRequest.getAdditionalParameters().values());
        log.info("AccessTokenIssuedAt: {}", userRequest.getAccessToken().getIssuedAt());
        //////////////////////////////////////////////////////////////////////////////////////////////////

        OAuth2UserService delegate = new DefaultOAuth2UserService();
        OAuth2User oAuth2User = delegate.loadUser(userRequest);

        String registrationId = userRequest.getClientRegistration().getRegistrationId();
        String userNameAttributeName = userRequest.getClientRegistration().getProviderDetails().getUserInfoEndpoint().getUserNameAttributeName();

        OAuthAttributes attributes = OAuthAttributes.of(registrationId, userNameAttributeName, oAuth2User.getAttributes());

        //////////////////////////////////////////////////////////////////////////////////////////////////
        log.info("OAuth2User: {}", oAuth2User.getName());
        log.info("registrationId: {}", registrationId);
        log.info("userNameAttributeName: {}", userNameAttributeName);

        Set<String> keySet = oAuth2User.getAttributes().keySet();
        log.info("attributes: {}",keySet);
        keySet.stream().forEach(key ->
                log.info("key: {}, values: {}", key, oAuth2User.getAttributes().get(key)));
        log.info("=============================OAuthService=============================");
        //////////////////////////////////////////////////////////////////////////////////////////////////

        Member member = memberRepository.findByEmail(attributes.getEmail())
                .orElse(attributes.toEntity());

        memberRepository.save(member);
        session.setAttribute("member", new SessionMember(member));

        return new DefaultOAuth2User(
                null,
                attributes.getAttributes(),
                attributes.getNameAttributeKey()
        );
    }
}
