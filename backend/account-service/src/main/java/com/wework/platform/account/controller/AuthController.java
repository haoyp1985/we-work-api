package com.wework.platform.account.controller;

import com.wework.platform.common.dto.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 认证授权控制器
 *
 * @author WeWork Platform Team
 */
@Slf4j
@RestController
@RequestMapping("/auth")
@Tag(name = "认证授权", description = "用户认证、权限管理相关接口")
public class AuthController {

    @GetMapping("/menus")
    @Operation(summary = "获取用户菜单", description = "获取当前用户的菜单权限")
    public ApiResponse<List<Map<String, Object>>> getUserMenus() {
        log.info("获取用户菜单");
        
        // 临时返回模拟菜单数据
        List<Map<String, Object>> menus = List.of(
            Map.of(
                "id", "dashboard",
                "name", "仪表盘",
                "path", "/dashboard",
                "icon", "Dashboard",
                "children", List.of()
            ),
            Map.of(
                "id", "accounts",
                "name", "账号管理",
                "path", "/accounts",
                "icon", "User",
                "children", List.of(
                    Map.of("id", "account-list", "name", "账号列表", "path", "/accounts/list", "icon", "List"),
                    Map.of("id", "account-create", "name", "创建账号", "path", "/accounts/create", "icon", "Plus")
                )
            ),
            Map.of(
                "id", "messages",
                "name", "消息管理",
                "path", "/messages",
                "icon", "Message",
                "children", List.of(
                    Map.of("id", "message-send", "name", "发送消息", "path", "/messages/send", "icon", "Send"),
                    Map.of("id", "message-history", "name", "消息历史", "path", "/messages/history", "icon", "History")
                )
            ),
            Map.of(
                "id", "system",
                "name", "系统管理",
                "path", "/system",
                "icon", "Settings",
                "children", List.of(
                    Map.of("id", "system-config", "name", "系统配置", "path", "/system/config", "icon", "Setting"),
                    Map.of("id", "system-logs", "name", "系统日志", "path", "/system/logs", "icon", "FileText")
                )
            )
        );
        
        return ApiResponse.success("获取菜单成功", menus);
    }

    @GetMapping("/permissions")
    @Operation(summary = "获取用户权限", description = "获取当前用户的权限列表")
    public ApiResponse<List<String>> getUserPermissions() {
        log.info("获取用户权限");
        
        // 临时返回模拟权限数据
        List<String> permissions = List.of(
            "dashboard:view",
            "account:view",
            "account:create",
            "account:edit",
            "account:delete",
            "message:send",
            "message:view",
            "system:config",
            "system:logs"
        );
        
        return ApiResponse.success("获取权限成功", permissions);
    }

    @GetMapping("/user-info")
    @Operation(summary = "获取当前用户信息", description = "获取当前登录用户的基本信息")
    public ApiResponse<Map<String, Object>> getCurrentUserInfo() {
        log.info("获取当前用户信息");
        
        // 临时返回模拟用户信息
        Map<String, Object> userInfo = Map.of(
            "userId", "admin",
            "username", "admin", 
            "nickname", "系统管理员",
            "avatar", "https://avatars.githubusercontent.com/u/1?v=4",
            "email", "admin@wework.com",
            "phone", "13800138000",
            "role", "ADMIN",
            "tenantId", "default",
            "enabled", true,
            "lastLoginTime", "2025-08-01T09:57:00"
        );
        
        return ApiResponse.success("获取用户信息成功", userInfo);
    }
}