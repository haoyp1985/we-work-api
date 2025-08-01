package com.wework.platform.gateway.filter;

import com.wework.platform.gateway.util.JwtUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.Arrays;
import java.util.List;

/**
 * JWT认证过滤器
 * 
 * @author WeWork Platform Team
 * @since 1.0.0
 */
@Slf4j
@Component
public class AuthenticationFilter extends AbstractGatewayFilterFactory<AuthenticationFilter.Config> {

    @Autowired
    private JwtUtil jwtUtil;

    private static final List<String> SKIP_AUTH_PATHS = Arrays.asList(
        // 处理后路径（StripPrefix之后）
        "/accounts/login",
        "/accounts/qr-code",
        "/callbacks/wework",
        // 其他路径
        "/health",
        "/actuator",
        "/swagger-ui",
        "/v3/api-docs"
    );

    public AuthenticationFilter() {
        super(Config.class);
    }

    @Override
    public GatewayFilter apply(Config config) {
        return (exchange, chain) -> {
            ServerHttpRequest request = exchange.getRequest();
            String path = request.getURI().getPath();

            // 检查是否需要跳过认证
            if (shouldSkipAuth(path)) {
                log.debug("跳过认证检查: {}", path);
                return chain.filter(exchange);
            }

            // 获取JWT Token
            String token = extractToken(request);
            if (!StringUtils.hasText(token)) {
                log.warn("访问路径 {} 缺少认证token", path);
                return handleUnauthorized(exchange);
            }

            // 验证JWT Token
            try {
                if (!jwtUtil.validateToken(token)) {
                    log.warn("访问路径 {} 的token无效", path);
                    return handleUnauthorized(exchange);
                }

                // 提取用户信息并添加到请求头
                String userId = jwtUtil.getUserId(token);
                String username = jwtUtil.getUsername(token);
                
                ServerHttpRequest modifiedRequest = request.mutate()
                    .header("X-User-Id", userId)
                    .header("X-Username", username)
                    .build();
                
                ServerWebExchange modifiedExchange = exchange.mutate()
                    .request(modifiedRequest)
                    .build();

                log.debug("用户 {} (ID: {}) 访问路径: {}", username, userId, path);
                return chain.filter(modifiedExchange);

            } catch (Exception e) {
                log.error("JWT token验证失败: {}", e.getMessage());
                return handleUnauthorized(exchange);
            }
        };
    }

    /**
     * 检查是否需要跳过认证
     */
    private boolean shouldSkipAuth(String path) {
        return SKIP_AUTH_PATHS.stream()
            .anyMatch(skipPath -> path.startsWith(skipPath));
    }

    /**
     * 从请求中提取JWT Token
     */
    private String extractToken(ServerHttpRequest request) {
        String authHeader = request.getHeaders().getFirst(HttpHeaders.AUTHORIZATION);
        if (StringUtils.hasText(authHeader) && authHeader.startsWith("Bearer ")) {
            return authHeader.substring(7);
        }
        return null;
    }

    /**
     * 处理未认证请求
     */
    private Mono<Void> handleUnauthorized(ServerWebExchange exchange) {
        ServerHttpResponse response = exchange.getResponse();
        response.setStatusCode(HttpStatus.UNAUTHORIZED);
        response.getHeaders().add("Content-Type", "application/json;charset=UTF-8");
        
        String body = "{\"code\":401,\"message\":\"未认证\",\"data\":null}";
        return response.writeWith(Mono.just(response.bufferFactory().wrap(body.getBytes())));
    }

    public static class Config {
        // 配置类，暂时为空
    }
}