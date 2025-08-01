package com.wework.platform.common.utils;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTVerificationException;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.auth0.jwt.interfaces.JWTVerifier;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

/**
 * JWT工具类
 * 
 * @author WeWork Platform Team
 */
@Slf4j
@Component
public class JwtUtils {

    @Value("${jwt.secret:wework-platform-secret-key}")
    private String secret;

    @Value("${jwt.expiration:7200}")
    private Long expiration;

    private static final String ISSUER = "wework-platform";

    /**
     * 生成JWT Token
     */
    public String generateToken(String userId, String tenantId, String username) {
        try {
            Algorithm algorithm = Algorithm.HMAC256(secret);
            Date expiresAt = Date.from(LocalDateTime.now()
                    .plusSeconds(expiration)
                    .atZone(ZoneId.systemDefault())
                    .toInstant());

            return JWT.create()
                    .withIssuer(ISSUER)
                    .withSubject(userId)
                    .withClaim("tenantId", tenantId)
                    .withClaim("username", username)
                    .withIssuedAt(new Date())
                    .withExpiresAt(expiresAt)
                    .sign(algorithm);
        } catch (Exception e) {
            log.error("生成JWT Token失败", e);
            throw new RuntimeException("生成JWT Token失败", e);
        }
    }

    /**
     * 验证JWT Token
     */
    public DecodedJWT verifyToken(String token) {
        try {
            Algorithm algorithm = Algorithm.HMAC256(secret);
            JWTVerifier verifier = JWT.require(algorithm)
                    .withIssuer(ISSUER)
                    .build();
            return verifier.verify(token);
        } catch (JWTVerificationException e) {
            log.warn("JWT Token验证失败: {}", e.getMessage());
            throw new RuntimeException("JWT Token验证失败", e);
        }
    }

    /**
     * 从Token中获取用户ID
     */
    public String getUserId(String token) {
        return verifyToken(token).getSubject();
    }

    /**
     * 从Token中获取租户ID
     */
    public String getTenantId(String token) {
        return verifyToken(token).getClaim("tenantId").asString();
    }

    /**
     * 从Token中获取用户名
     */
    public String getUsername(String token) {
        return verifyToken(token).getClaim("username").asString();
    }

    /**
     * 检查Token是否过期
     */
    public boolean isTokenExpired(String token) {
        try {
            DecodedJWT decodedJWT = verifyToken(token);
            return decodedJWT.getExpiresAt().before(new Date());
        } catch (Exception e) {
            return true;
        }
    }

    /**
     * 刷新Token
     */
    public String refreshToken(String token) {
        try {
            DecodedJWT decodedJWT = verifyToken(token);
            String userId = decodedJWT.getSubject();
            String tenantId = decodedJWT.getClaim("tenantId").asString();
            String username = decodedJWT.getClaim("username").asString();
            
            return generateToken(userId, tenantId, username);
        } catch (Exception e) {
            log.error("刷新JWT Token失败", e);
            throw new RuntimeException("刷新JWT Token失败", e);
        }
    }
}