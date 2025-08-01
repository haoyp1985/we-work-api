package com.wework.platform.account.controller;

import com.wework.platform.account.dto.*;
import com.wework.platform.account.service.AccountService;
import com.wework.platform.common.dto.ApiResponse;
import com.wework.platform.common.dto.PageRequest;
import com.wework.platform.common.dto.PageResponse;
import com.wework.platform.common.utils.JwtUtils;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 账号管理控制器
 *
 * @author WeWork Platform Team
 */
@Slf4j
@RestController
@RequestMapping("/accounts")
@RequiredArgsConstructor
@Tag(name = "账号管理", description = "企微账号的创建、登录、状态管理等操作")
public class AccountController {

    private final AccountService accountService;
    private final JwtUtils jwtUtils;

    @PostMapping
    @Operation(summary = "创建账号", description = "为指定租户创建新的企微账号")
    public ApiResponse<AccountResponse> createAccount(
            @Valid @RequestBody AccountCreateRequest request) {
        log.info("创建账号请求: {}", request.getAccountName());
        AccountResponse response = accountService.createAccount(request);
        return ApiResponse.success("账号创建成功", response);
    }

    @GetMapping("/{accountId}")
    @Operation(summary = "获取账号详情", description = "根据账号ID获取账号的详细信息")
    public ApiResponse<AccountResponse> getAccount(
            @Parameter(description = "账号ID") @PathVariable String accountId) {
        log.debug("获取账号详情: {}", accountId);
        AccountResponse response = accountService.getAccount(accountId);
        return ApiResponse.success(response);
    }

    @GetMapping
    @Operation(summary = "分页查询账号", description = "根据租户ID分页查询账号列表")
    public ApiResponse<PageResponse<AccountResponse>> listAccounts(
            @Parameter(description = "租户ID") @RequestParam("tenantId") String tenantId,
            @Parameter(description = "页码") @RequestParam(value = "page", defaultValue = "1") Integer page,
            @Parameter(description = "每页大小") @RequestParam(value = "size", defaultValue = "20") Integer size,
            @Parameter(description = "排序字段") @RequestParam(value = "sortBy", required = false) String sortBy,
            @Parameter(description = "排序方向") @RequestParam(value = "sortDir", defaultValue = "desc") String sortDir,
            @Parameter(description = "搜索关键词") @RequestParam(value = "keyword", required = false) String keyword) {
        
        log.debug("分页查询账号: 租户ID={}, 页码={}, 大小={}", tenantId, page, size);
        
        PageRequest pageRequest = new PageRequest();
        pageRequest.setPage(page);
        pageRequest.setSize(size);
        pageRequest.setSortBy(sortBy);
        pageRequest.setSortDir(sortDir);
        pageRequest.setKeyword(keyword);
        
        PageResponse<AccountResponse> response = accountService.listAccounts(tenantId, pageRequest);
        return ApiResponse.success(response);
    }

    @PutMapping("/{accountId}")
    @Operation(summary = "更新账号", description = "更新指定账号的基本信息")
    public ApiResponse<AccountResponse> updateAccount(
            @Parameter(description = "账号ID") @PathVariable String accountId,
            @Valid @RequestBody AccountCreateRequest request) {
        log.info("更新账号: {}", accountId);
        AccountResponse response = accountService.updateAccount(accountId, request);
        return ApiResponse.success("账号更新成功", response);
    }

    @DeleteMapping("/{accountId}")
    @Operation(summary = "删除账号", description = "删除指定的企微账号")
    public ApiResponse<Void> deleteAccount(
            @Parameter(description = "账号ID") @PathVariable String accountId) {
        log.info("删除账号: {}", accountId);
        accountService.deleteAccount(accountId);
        return ApiResponse.success();
    }

    @PostMapping("/{accountId}/login")
    @Operation(summary = "账号登录", description = "启动账号登录流程，获取登录二维码")
    public ApiResponse<LoginQRCodeResponse> loginAccount(
            @Parameter(description = "账号ID") @PathVariable String accountId,
            @Valid @RequestBody AccountLoginRequest request) {
        log.info("账号登录: {}", accountId);
        request.setAccountId(accountId);
        LoginQRCodeResponse response = accountService.loginAccount(request);
        return ApiResponse.success("登录二维码生成成功", response);
    }

    @PostMapping("/{accountId}/logout")
    @Operation(summary = "账号登出", description = "让指定账号下线")
    public ApiResponse<Void> logoutAccount(
            @Parameter(description = "账号ID") @PathVariable String accountId) {
        log.info("账号登出: {}", accountId);
        accountService.logoutAccount(accountId);
        return ApiResponse.success();
    }

    @GetMapping("/{accountId}/status")
    @Operation(summary = "获取账号状态", description = "获取账号的实时状态信息")
    public ApiResponse<AccountStatusResponse> getAccountStatus(
            @Parameter(description = "账号ID") @PathVariable String accountId) {
        log.debug("获取账号状态: {}", accountId);
        AccountStatusResponse response = accountService.getAccountStatus(accountId);
        return ApiResponse.success(response);
    }

    @PostMapping("/{accountId}/restart")
    @Operation(summary = "重启账号", description = "重启指定的企微账号")
    public ApiResponse<Void> restartAccount(
            @Parameter(description = "账号ID") @PathVariable String accountId) {
        log.info("重启账号: {}", accountId);
        accountService.restartAccount(accountId);
        return ApiResponse.success();
    }

    @PostMapping("/batch/status")
    @Operation(summary = "批量获取账号状态", description = "批量获取多个账号的状态信息")
    public ApiResponse<List<AccountStatusResponse>> batchGetAccountStatus(
            @RequestBody List<String> accountIds) {
        log.debug("批量获取账号状态: {}", accountIds.size());
        List<AccountStatusResponse> response = accountService.batchGetAccountStatus(accountIds);
        return ApiResponse.success(response);
    }

    @PostMapping("/{accountId}/verify-code")
    @Operation(summary = "验证登录验证码", description = "验证二步验证的登录验证码")
    public ApiResponse<Void> verifyLoginCode(
            @Parameter(description = "账号ID") @PathVariable String accountId,
            @Parameter(description = "验证码") @RequestParam String code) {
        log.info("验证登录验证码: {}", accountId);
        accountService.verifyLoginCode(accountId, code);
        return ApiResponse.success();
    }

    // ==================== 管理员认证接口 ====================
    
    @PostMapping("/login")
    @Operation(summary = "管理员登录", description = "管理后台用户名密码登录")
    public ApiResponse<AdminLoginResponse> adminLogin(
            @Valid @RequestBody AdminLoginRequest request) {
        log.info("管理员登录: {}", request.getUsername());
        
        // 简单的用户名密码验证（实际项目中应该从数据库验证）
        if (!"admin".equals(request.getUsername()) || !"123456".equals(request.getPassword())) {
            return ApiResponse.error("用户名或密码错误");
        }
        
        // 创建用户信息
        UserInfo userInfo = new UserInfo();
        userInfo.setUserId("admin");
        userInfo.setUsername("admin");
        userInfo.setNickname("系统管理员");
        userInfo.setRole("ADMIN");
        userInfo.setTenantId("default");
        userInfo.setEnabled(true);
        userInfo.setCreateTime(LocalDateTime.now());
        userInfo.setLastLoginTime(LocalDateTime.now());
        
        // 生成JWT Token
        String token = jwtUtils.generateToken("admin", "admin", "default");
        String refreshToken = jwtUtils.generateToken("admin", "admin", "default");
        
        // 构建响应
        AdminLoginResponse response = new AdminLoginResponse();
        response.setToken(token);
        response.setRefreshToken(refreshToken);
        response.setUser(userInfo);
        response.setExpiresIn(7200); // 2小时
        
        return ApiResponse.success("登录成功", response);
    }

    @PostMapping("/logout")
    @Operation(summary = "管理员登出", description = "管理后台用户登出")
    public ApiResponse<Void> adminLogout() {
        log.info("管理员登出");
        // 实际项目中可以将token加入黑名单
        return ApiResponse.success();
    }

    @GetMapping("/profile")
    @Operation(summary = "获取用户信息", description = "获取当前登录用户的详细信息")
    public ApiResponse<UserInfo> getUserProfile() {
        log.info("获取用户信息");
        
        // 实际项目中应该从JWT token中获取用户ID，然后从数据库查询
        UserInfo userInfo = new UserInfo();
        userInfo.setUserId("admin");
        userInfo.setUsername("admin");
        userInfo.setNickname("系统管理员");
        userInfo.setRole("ADMIN");
        userInfo.setTenantId("default");
        userInfo.setEnabled(true);
        userInfo.setCreateTime(LocalDateTime.now());
        userInfo.setLastLoginTime(LocalDateTime.now());
        
        return ApiResponse.success(userInfo);
    }

    @GetMapping("/qr-code")
    @Operation(summary = "获取登录二维码", description = "获取二维码登录信息")
    public ApiResponse<LoginQRCodeResponse> getLoginQrCode() {
        log.info("获取登录二维码");
        
        // 临时返回模拟数据，实际项目中应该生成真实的二维码
        LoginQRCodeResponse response = new LoginQRCodeResponse();
        response.setQrcodeKey("temp-qr-key-" + System.currentTimeMillis());
        response.setQrcodeContent("https://work.weixin.qq.com/wework_admin/loginpage_wx?login_type=CorpApp&");
        response.setExpiresIn(300);
        
        return ApiResponse.success("二维码生成成功", response);
    }

    @PostMapping("/qr-verify")
    @Operation(summary = "验证二维码登录", description = "验证二维码扫码登录")
    public ApiResponse<AdminLoginResponse> verifyQrCode(
            @RequestBody QrVerifyRequest request) {
        log.info("验证二维码登录: {}", request.getKey());
        
        // 临时返回登录成功响应
        UserInfo userInfo = new UserInfo();
        userInfo.setUserId("qr-user");
        userInfo.setUsername("qr-user");
        userInfo.setNickname("二维码用户");
        userInfo.setRole("USER");
        userInfo.setTenantId("default");
        userInfo.setEnabled(true);
        userInfo.setCreateTime(LocalDateTime.now());
        userInfo.setLastLoginTime(LocalDateTime.now());
        
        String token = jwtUtils.generateToken("qr-user", "qr-user", "default");
        String refreshToken = jwtUtils.generateToken("qr-user", "qr-user", "default");
        
        AdminLoginResponse response = new AdminLoginResponse();
        response.setToken(token);
        response.setRefreshToken(refreshToken);
        response.setUser(userInfo);
        response.setExpiresIn(7200);
        
        return ApiResponse.success("登录成功", response);
    }

    @PostMapping("/auth/refresh")
    @Operation(summary = "刷新令牌", description = "使用刷新令牌获取新的访问令牌")
    public ApiResponse<RefreshTokenResponse> refreshToken() {
        log.info("刷新令牌");
        
        // 临时返回新的token
        String newToken = jwtUtils.generateToken("admin", "admin", "default");
        String newRefreshToken = jwtUtils.generateToken("admin", "admin", "default");
        
        RefreshTokenResponse response = new RefreshTokenResponse();
        response.setToken(newToken);
        response.setRefreshToken(newRefreshToken);
        
        return ApiResponse.success("令牌刷新成功", response);
    }

    // ==================== 统计接口 ====================
    
    @GetMapping("/stats")
    @Operation(summary = "获取账号统计信息", description = "获取账号相关的统计数据")
    public ApiResponse<Map<String, Object>> getAccountStats() {
        log.info("获取账号统计信息");
        
        // 临时返回模拟统计数据
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalAccounts", 156);
        stats.put("activeAccounts", 142);
        stats.put("inactiveAccounts", 14);
        stats.put("newAccountsToday", 5);
        stats.put("loginCountToday", 89);
        stats.put("lastUpdateTime", LocalDateTime.now());
        
        return ApiResponse.success("获取统计信息成功", stats);
    }
}