package com.wework.platform.common.tenant;

import com.wework.platform.common.utils.JwtUtils;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.HandlerInterceptor;

import java.util.Arrays;
import java.util.List;

/**
 * 租户拦截器
 * 自动从请求中提取租户信息并设置到上下文中
 * 
 * @author WeWork Platform Team
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class TenantInterceptor implements HandlerInterceptor {

    private final JwtUtils jwtUtils;

    /**
     * 不需要租户隔离的URL路径
     */
    private static final List<String> SKIP_TENANT_PATHS = Arrays.asList(
        "/api/health",
        "/api/login",
        "/api/logout", 
        "/api/register",
        "/actuator",
        "/swagger",
        "/v3/api-docs",
        "/error"
    );

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        try {
            String requestURI = request.getRequestURI();
            log.debug("租户拦截器处理请求: {}", requestURI);

            // 检查是否需要跳过租户隔离
            if (shouldSkipTenantCheck(requestURI)) {
                log.debug("跳过租户隔离检查: {}", requestURI);
                return true;
            }

            // 从请求头中提取租户信息
            extractTenantFromHeaders(request);

            // 从JWT Token中提取租户信息（如果请求头中没有）
            if (!TenantContext.hasTenantContext()) {
                extractTenantFromToken(request);
            }

            // 记录租户上下文
            if (TenantContext.hasTenantContext()) {
                log.debug("设置租户上下文成功: 租户={}, 用户={}", 
                    TenantContext.getTenantId(), TenantContext.getUserId());
            } else {
                log.debug("未设置租户上下文，可能是公开API");
            }

            return true;

        } catch (Exception e) {
            log.error("租户拦截器处理失败: {}", e.getMessage(), e);
            // 清除可能的部分上下文
            TenantContext.clear();
            throw e;
        }
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, 
                              Object handler, Exception ex) throws Exception {
        // 清除租户上下文，避免线程复用时的数据污染
        TenantContext.clear();
        log.debug("清除租户上下文完成");
    }

    /**
     * 检查是否需要跳过租户隔离
     */
    private boolean shouldSkipTenantCheck(String requestURI) {
        return SKIP_TENANT_PATHS.stream()
                .anyMatch(skipPath -> requestURI.startsWith(skipPath));
    }

    /**
     * 从请求头中提取租户信息
     */
    private void extractTenantFromHeaders(HttpServletRequest request) {
        String tenantId = request.getHeader("X-Tenant-Id");
        String userId = request.getHeader("X-User-Id");
        String username = request.getHeader("X-Username");
        String superAdmin = request.getHeader("X-Super-Admin");

        if (StringUtils.hasText(tenantId)) {
            log.debug("从请求头提取租户信息: 租户={}, 用户={}", tenantId, userId);
            TenantContext.setTenantId(tenantId);
            
            if (StringUtils.hasText(userId)) {
                TenantContext.setUserId(userId);
            }
            
            if (StringUtils.hasText(username)) {
                TenantContext.setUsername(username);
            }
            
            if (StringUtils.hasText(superAdmin)) {
                TenantContext.setSuperAdmin(Boolean.parseBoolean(superAdmin));
            }
        }
    }

    /**
     * 从JWT Token中提取租户信息
     */
    private void extractTenantFromToken(HttpServletRequest request) {
        String token = extractTokenFromRequest(request);
        
        if (!StringUtils.hasText(token)) {
            log.debug("请求中未找到JWT Token");
            return;
        }

        try {
            // 验证并解析Token
            // 验证Token（如果无效会抛出异常）
            jwtUtils.verifyToken(token);

            String tenantId = jwtUtils.getTenantId(token);
            String userId = jwtUtils.getUserId(token);
            String username = jwtUtils.getUsername(token);

            if (StringUtils.hasText(tenantId)) {
                log.debug("从JWT Token提取租户信息: 租户={}, 用户={}", tenantId, userId);
                TenantContext.setTenantId(tenantId);
                TenantContext.setUserId(userId);
                TenantContext.setUsername(username);
                
                // 检查是否为超级管理员（这里可以根据实际业务逻辑判断）
                boolean isSuperAdmin = "super_admin".equals(username) || "admin".equals(username);
                TenantContext.setSuperAdmin(isSuperAdmin);
            }

        } catch (Exception e) {
            log.warn("从JWT Token提取租户信息失败: {}", e.getMessage());
        }
    }

    /**
     * 从请求中提取JWT Token
     */
    private String extractTokenFromRequest(HttpServletRequest request) {
        // 从Authorization头中提取
        String authHeader = request.getHeader("Authorization");
        if (StringUtils.hasText(authHeader) && authHeader.startsWith("Bearer ")) {
            return authHeader.substring(7);
        }

        // 从token参数中提取
        String tokenParam = request.getParameter("token");
        if (StringUtils.hasText(tokenParam)) {
            return tokenParam;
        }

        return null;
    }
}