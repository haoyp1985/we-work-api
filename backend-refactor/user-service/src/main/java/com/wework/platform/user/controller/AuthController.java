package com.wework.platform.user.controller;

import com.wework.platform.common.core.base.Result;
import com.wework.platform.common.security.UserContext;
import com.wework.platform.common.security.UserContextHolder;
import com.wework.platform.user.dto.LoginRequest;
import com.wework.platform.user.dto.LoginResponse;
import com.wework.platform.user.dto.UserDTO;
import com.wework.platform.user.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

/**
 * 认证控制器
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
@Tag(name = "认证管理", description = "用户认证相关接口")
public class AuthController {

    private final UserService userService;

    @Operation(summary = "用户登录", description = "用户名密码登录")
    @PostMapping("/login")
    public Result<LoginResponse> login(@Valid @RequestBody LoginRequest request, HttpServletRequest httpRequest) {
        String clientIp = getClientIp(httpRequest);
        LoginResponse response = userService.login(request, clientIp);
        return Result.success(response);
    }

    @Operation(summary = "用户登出", description = "退出登录")
    @PostMapping("/logout")
    public Result<Void> logout() {
        UserContext userContext = UserContextHolder.getContext();
        if (userContext != null) {
            userService.logout(userContext.getUserId());
        }
        return Result.success();
    }

    @Operation(summary = "刷新令牌", description = "使用刷新令牌获取新的访问令牌")
    @PostMapping("/refresh")
    public Result<String> refreshToken(@Parameter(description = "刷新令牌") @RequestParam String refreshToken) {
        String accessToken = userService.refreshToken(refreshToken);
        return Result.success(accessToken);
    }

    @Operation(summary = "获取当前用户信息", description = "获取当前登录用户的详细信息")
    @GetMapping("/user-info")
    public Result<UserDTO> getCurrentUser() {
        UserContext userContext = UserContextHolder.getContext();
        UserDTO userDTO = userService.getCurrentUser(userContext.getUserId());
        return Result.success(userDTO);
    }

    @Operation(summary = "修改当前用户密码", description = "用户自己修改密码")
    @PostMapping("/change-password")
    public Result<Void> changePassword(@Parameter(description = "旧密码") @RequestParam String oldPassword,
                                      @Parameter(description = "新密码") @RequestParam String newPassword) {
        UserContext userContext = UserContextHolder.getContext();
        userService.changePassword(userContext.getUserId(), oldPassword, newPassword);
        return Result.success();
    }

    /**
     * 获取客户端真实IP地址
     */
    private String getClientIp(HttpServletRequest request) {
        String xip = request.getHeader("X-Real-IP");
        String xfor = request.getHeader("X-Forwarded-For");
        
        if (xfor != null && xfor.length() != 0 && !"unknown".equalsIgnoreCase(xfor)) {
            // 多次反向代理后会有多个ip值，第一个ip才是真实ip
            int index = xfor.indexOf(",");
            if (index != -1) {
                return xfor.substring(0, index);
            } else {
                return xfor;
            }
        }
        
        if (xip != null && xip.length() != 0 && !"unknown".equalsIgnoreCase(xip)) {
            return xip;
        }
        
        if (xip == null || xip.length() == 0 || "unknown".equalsIgnoreCase(xip)) {
            xip = request.getHeader("Proxy-Client-IP");
        }
        if (xip == null || xip.length() == 0 || "unknown".equalsIgnoreCase(xip)) {
            xip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (xip == null || xip.length() == 0 || "unknown".equalsIgnoreCase(xip)) {
            xip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (xip == null || xip.length() == 0 || "unknown".equalsIgnoreCase(xip)) {
            xip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (xip == null || xip.length() == 0 || "unknown".equalsIgnoreCase(xip)) {
            xip = request.getRemoteAddr();
        }
        
        return xip;
    }
}