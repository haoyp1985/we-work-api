package com.wework.platform.common.security;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTVerificationException;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.wework.platform.common.core.exception.BusinessException;
import com.wework.platform.common.enums.ResultCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.List;

/**
 * JWT工具类
 *
 * @author WeWork Platform Team
 * @since 2.0.0
 */
@Slf4j
@Component
public class JwtUtils {

    @Value("${app.jwt.secret:WeWork-JWT-Secret-Key-2025}")
    private String secret;

    @Value("${app.jwt.expiration:7200}")
    private Long expiration;

    @Value("${app.jwt.issuer:wework-platform}")
    private String issuer;

    /**
     * 生成Access Token
     */
    public String generateAccessToken(UserContext userContext) {
        Algorithm algorithm = Algorithm.HMAC256(secret);
        
        return JWT.create()
                .withIssuer(issuer)
                .withSubject(userContext.getUserId())
                .withClaim("tenantId", userContext.getTenantId())
                .withClaim("username", userContext.getUsername())
                .withClaim("realName", userContext.getRealName())
                .withClaim("roles", userContext.getRoles())
                .withClaim("permissions", userContext.getPermissions())
                .withClaim("tokenType", "access")
                .withIssuedAt(new Date())
                .withExpiresAt(new Date(System.currentTimeMillis() + expiration * 1000))
                .sign(algorithm);
    }

    /**
     * 生成Refresh Token
     */
    public String generateRefreshToken(String userId) {
        Algorithm algorithm = Algorithm.HMAC256(secret);
        
        return JWT.create()
                .withIssuer(issuer)
                .withSubject(userId)
                .withClaim("tokenType", "refresh")
                .withIssuedAt(new Date())
                .withExpiresAt(new Date(System.currentTimeMillis() + expiration * 1000 * 7)) // 7倍过期时间
                .sign(algorithm);
    }

    /**
     * 验证Token
     */
    public boolean validateToken(String token) {
        try {
            Algorithm algorithm = Algorithm.HMAC256(secret);
            JWTVerifier verifier = JWT.require(algorithm)
                    .withIssuer(issuer)
                    .build();
            verifier.verify(token);
            return true;
        } catch (JWTVerificationException e) {
            log.warn("Token验证失败: {}", e.getMessage());
            return false;
        }
    }

    /**
     * 解析Token
     */
    public UserContext parseToken(String token) {
        try {
            DecodedJWT jwt = JWT.decode(token);
            
            return UserContext.builder()
                    .userId(jwt.getSubject())
                    .tenantId(jwt.getClaim("tenantId").asString())
                    .username(jwt.getClaim("username").asString())
                    .realName(jwt.getClaim("realName").asString())
                    .roles(jwt.getClaim("roles").asList(String.class))
                    .permissions(jwt.getClaim("permissions").asList(String.class))
                    .build();
        } catch (Exception e) {
            log.error("Token解析失败", e);
            throw new BusinessException(ResultCode.JWT_INVALID);
        }
    }

    /**
     * 获取Token过期时间
     */
    public Date getExpirationFromToken(String token) {
        try {
            DecodedJWT jwt = JWT.decode(token);
            return jwt.getExpiresAt();
        } catch (Exception e) {
            log.error("获取Token过期时间失败", e);
            return null;
        }
    }

    /**
     * 判断Token是否过期
     */
    public boolean isTokenExpired(String token) {
        Date expiration = getExpirationFromToken(token);
        return expiration != null && expiration.before(new Date());
    }

    /**
     * 获取Token剩余有效时间（秒）
     */
    public long getTokenRemainingTime(String token) {
        Date expiration = getExpirationFromToken(token);
        if (expiration == null) {
            return 0;
        }
        return Math.max(0, (expiration.getTime() - System.currentTimeMillis()) / 1000);
    }
}