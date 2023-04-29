package ving.vingterview.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.LoginUrlAuthenticationEntryPoint;
import ving.vingterview.service.auth.OAuth2MemberService;

@Configuration
@RequiredArgsConstructor
@EnableWebSecurity  // SpringSecurity 설정 활성화
public class SecurityConfig {

    private final OAuth2MemberService customOAuth2UserService;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http
                .csrf().disable()
                .headers().frameOptions().disable()
                .and()
                    .authorizeHttpRequests()
                        .requestMatchers("/login", "/auth", "/logout-success").permitAll()
                        .anyRequest().authenticated()
                .and()
                    .exceptionHandling()
//                        .authenticationEntryPoint((request, response, exception) -> response.sendRedirect("/login"))
                        .authenticationEntryPoint(new LoginUrlAuthenticationEntryPoint("/login"))
                .and()
                    .logout()
                        .logoutSuccessUrl("/logout-success")
                .and()
                    .oauth2Login()
                        .defaultSuccessUrl("/login-success")
                        .userInfoEndpoint()
                            .userService(customOAuth2UserService);

        return http.build();
    }
}
