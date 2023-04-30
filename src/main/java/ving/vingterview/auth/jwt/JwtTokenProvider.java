package ving.vingterview.auth.jwt;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;
import ving.vingterview.auth.dto.Token;

import java.util.Date;

@Component
@RequiredArgsConstructor
public class JwtTokenProvider {

    @Value("${jwt.secret}")
    private String jwtSecret;

    //access token 지속시간 : 3개월(임시)
    private Long accessTokenValidTime = 3 * 30 * 24 * 60 * 60 * 1000L;

    //refresh token 지속시간 : 3개월
    private Long refreshTokenValidTime = 3 * 30 * 24 * 60 * 60 * 1000L;

    //TODO 토큰 재발급(DB에 저장된 refresh Token으로 사용자 조회 후 토큰 재발급)
    public Token refresh(String refreshToken) {
//        if (refreshToken != null) {
//            Long memberId = null;
//            String email = null;
//            return generateToken(memberId, email);
//        }
        return null;
    }

    public Token generateToken(Long memberId, String userEmail) {
        return new Token(
                generateAccessToken(memberId, userEmail),
                generateRefreshToken()
        );
    }

    public Authentication getAuthentication(String token) {
        Claims claims = getClaims(token);
        String email = claims.getSubject();
        Long memberId = Long.valueOf(claims.get("memberId", String.class));
        JwtUserDetails principal = new JwtUserDetails(memberId, email);
        return new UsernamePasswordAuthenticationToken(principal, "", null);
    }

    public boolean verifyToken(String token) {
        try {
            Jws<Claims> claims = Jwts.parser().setSigningKey(jwtSecret).parseClaimsJws(token);
            return !claims.getBody().getExpiration().before(new Date());
        } catch (Exception e) {
            return false;
        }
    }


    private Claims getClaims(String token) {
        return Jwts.parser().setSigningKey(jwtSecret).parseClaimsJws(token).getBody();
    }

    private String generateAccessToken(Long memberId, String userEmail) {
        Claims claims = Jwts.claims().setSubject(userEmail);
        Date now = new Date();

        return Jwts.builder()
                .setClaims(claims)
                .claim("memberId", String.valueOf(memberId))
                .setIssuedAt(now)
                .setExpiration(new Date(now.getTime() + accessTokenValidTime))
                .signWith(SignatureAlgorithm.HS256, jwtSecret)
                .compact();
    }

    private String generateRefreshToken() {
        Date now = new Date();

        return Jwts.builder()
                .setIssuedAt(now)
                .setExpiration(new Date(now.getTime() + refreshTokenValidTime))
                .signWith(SignatureAlgorithm.HS256, jwtSecret)
                .compact();
    }
}
