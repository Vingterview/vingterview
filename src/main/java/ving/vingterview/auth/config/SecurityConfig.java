package ving.vingterview.auth.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.LoginUrlAuthenticationEntryPoint;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import ving.vingterview.auth.jwt.JwtAuthFilter;
import ving.vingterview.auth.jwt.JwtTokenProvider;
import ving.vingterview.auth.oauth2.OAuth2MemberService;
import ving.vingterview.auth.oauth2.OAuth2SuccessHandler;

@Configuration
@RequiredArgsConstructor
@EnableWebSecurity  // SpringSecurity 설정 활성화
public class SecurityConfig {

    private final OAuth2MemberService oAuth2MemberService;

    private final OAuth2SuccessHandler oAuth2SuccessHandler;
    private final JwtTokenProvider tokenProvider;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http
                .cors().and()
                .csrf().disable()
                .headers().frameOptions().disable()
                .and()
                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()
                    .authorizeHttpRequests()
                        .requestMatchers("/","/resources/**","/login", "/auth", "/logout-success", "/token", "/v3/api-docs/**","/swagger-ui/**").permitAll()
                        .anyRequest().authenticated()
                .and()
                    .logout()
                        .logoutSuccessUrl("/logout-success")
                .and()
                    .oauth2Login()
                        .successHandler(oAuth2SuccessHandler)
                        .userInfoEndpoint()
                            .userService(oAuth2MemberService);

        http.addFilterBefore(new JwtAuthFilter(tokenProvider), UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
