package com.wework.platform.account.controller;

import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.common.core.base.Result;
import com.wework.platform.common.security.UserContext;
import com.wework.platform.common.security.UserContextHolder;
import com.wework.platform.account.dto.*;
import com.wework.platform.account.service.WeWorkAccountService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 企微账号管理控制器
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@RestController
@RequestMapping("/accounts")
@RequiredArgsConstructor
@Tag(name = "企微账号管理", description = "企微账号管理相关接口")
public class WeWorkAccountController {

    private final WeWorkAccountService accountService;

    @Operation(summary = "分页查询账号列表", description = "根据条件分页查询企微账号列表")
    @GetMapping
    public Result<PageResult<WeWorkAccountDTO>> getAccountList(
            @Parameter(description = "页码") @RequestParam(defaultValue = "1") Integer pageNum,
            @Parameter(description = "页大小") @RequestParam(defaultValue = "20") Integer pageSize,
            @Parameter(description = "关键词") @RequestParam(required = false) String keyword,
            @Parameter(description = "状态") @RequestParam(required = false) Integer status) {
        
        UserContext userContext = UserContextHolder.getContext();
        PageResult<WeWorkAccountDTO> result = accountService.getAccountList(
                userContext.getTenantId(), pageNum, pageSize, keyword, status);
        return Result.success(result);
    }

    @Operation(summary = "根据ID获取账号详情", description = "根据账号ID获取企微账号详细信息")
    @GetMapping("/{accountId}")
    public Result<WeWorkAccountDTO> getAccountById(@Parameter(description = "账号ID") @PathVariable String accountId) {
        UserContext userContext = UserContextHolder.getContext();
        WeWorkAccountDTO accountDTO = accountService.getAccountById(accountId, userContext.getTenantId());
        return Result.success(accountDTO);
    }

    @Operation(summary = "创建企微账号", description = "创建新的企微账号")
    @PostMapping
    public Result<WeWorkAccountDTO> createAccount(@Valid @RequestBody CreateAccountRequest request) {
        UserContext userContext = UserContextHolder.getContext();
        WeWorkAccountDTO accountDTO = accountService.createAccount(
                request, userContext.getTenantId(), userContext.getUserId());
        return Result.success(accountDTO);
    }

    @Operation(summary = "更新企微账号", description = "更新企微账号信息")
    @PutMapping("/{accountId}")
    public Result<WeWorkAccountDTO> updateAccount(@Parameter(description = "账号ID") @PathVariable String accountId,
                                                 @Valid @RequestBody UpdateAccountRequest request) {
        UserContext userContext = UserContextHolder.getContext();
        WeWorkAccountDTO accountDTO = accountService.updateAccount(
                accountId, request, userContext.getTenantId(), userContext.getUserId());
        return Result.success(accountDTO);
    }

    @Operation(summary = "删除企微账号", description = "删除指定的企微账号")
    @DeleteMapping("/{accountId}")
    public Result<Void> deleteAccount(@Parameter(description = "账号ID") @PathVariable String accountId) {
        UserContext userContext = UserContextHolder.getContext();
        accountService.deleteAccount(accountId, userContext.getTenantId(), userContext.getUserId());
        return Result.success();
    }

    @Operation(summary = "登录企微账号", description = "登录企微账号，获取二维码")
    @PostMapping("/{accountId}/login")
    public Result<String> loginAccount(@Parameter(description = "账号ID") @PathVariable String accountId) {
        UserContext userContext = UserContextHolder.getContext();
        String qrCodeUrl = accountService.loginAccount(accountId, userContext.getTenantId(), userContext.getUserId());
        return Result.success(qrCodeUrl);
    }

    @Operation(summary = "登出企微账号", description = "登出企微账号")
    @PostMapping("/{accountId}/logout")
    public Result<Void> logoutAccount(@Parameter(description = "账号ID") @PathVariable String accountId) {
        UserContext userContext = UserContextHolder.getContext();
        accountService.logoutAccount(accountId, userContext.getTenantId(), userContext.getUserId());
        return Result.success();
    }

    @Operation(summary = "重启企微账号", description = "重启异常的企微账号")
    @PostMapping("/{accountId}/restart")
    public Result<Void> restartAccount(@Parameter(description = "账号ID") @PathVariable String accountId) {
        UserContext userContext = UserContextHolder.getContext();
        accountService.restartAccount(accountId, userContext.getTenantId(), userContext.getUserId());
        return Result.success();
    }

    @Operation(summary = "同步联系人", description = "同步企微账号的联系人信息")
    @PostMapping("/{accountId}/sync-contacts")
    public Result<String> syncContacts(@Parameter(description = "账号ID") @PathVariable String accountId) {
        UserContext userContext = UserContextHolder.getContext();
        String taskId = accountService.syncContacts(accountId, userContext.getTenantId(), userContext.getUserId());
        return Result.success(taskId);
    }

    @Operation(summary = "心跳检测", description = "对指定账号进行心跳检测")
    @PostMapping("/{accountId}/heartbeat")
    public Result<Boolean> heartbeat(@Parameter(description = "账号ID") @PathVariable String accountId) {
        boolean result = accountService.heartbeat(accountId);
        return Result.success(result);
    }

    @Operation(summary = "批量心跳检测", description = "对租户下所有在线账号进行心跳检测")
    @PostMapping("/batch-heartbeat")
    public Result<List<String>> batchHeartbeat() {
        UserContext userContext = UserContextHolder.getContext();
        List<String> offlineAccounts = accountService.batchHeartbeat(userContext.getTenantId());
        return Result.success(offlineAccounts);
    }

    @Operation(summary = "获取账号统计", description = "获取账号统计信息")
    @GetMapping("/statistics")
    public Result<AccountStatisticsDTO> getAccountStatistics() {
        UserContext userContext = UserContextHolder.getContext();
        AccountStatisticsDTO statistics = accountService.getAccountStatistics(userContext.getTenantId());
        return Result.success(statistics);
    }

    @Operation(summary = "自动恢复异常账号", description = "自动恢复异常状态的账号")
    @PostMapping("/auto-recover")
    public Result<List<String>> autoRecoverErrorAccounts() {
        UserContext userContext = UserContextHolder.getContext();
        List<String> recoveredAccounts = accountService.autoRecoverErrorAccounts(userContext.getTenantId());
        return Result.success(recoveredAccounts);
    }

    @Operation(summary = "检查企业ID是否存在", description = "检查企业ID是否已被使用")
    @GetMapping("/check-corp-id")
    public Result<Boolean> checkCorpIdExists(@Parameter(description = "企业ID") @RequestParam String corpId,
                                            @Parameter(description = "排除的账号ID") @RequestParam(required = false) String excludeAccountId) {
        UserContext userContext = UserContextHolder.getContext();
        boolean exists = accountService.isCorpIdExists(corpId, userContext.getTenantId(), excludeAccountId);
        return Result.success(exists);
    }

    @Operation(summary = "获取访问令牌", description = "获取指定账号的访问令牌")
    @GetMapping("/{accountId}/access-token")
    public Result<String> getAccessToken(@Parameter(description = "账号ID") @PathVariable String accountId) {
        String accessToken = accountService.getAccessToken(accountId);
        return Result.success(accessToken);
    }

    @Operation(summary = "刷新访问令牌", description = "刷新指定账号的访问令牌")
    @PostMapping("/{accountId}/refresh-token")
    public Result<String> refreshAccessToken(@Parameter(description = "账号ID") @PathVariable String accountId) {
        String accessToken = accountService.refreshAccessToken(accountId);
        return Result.success(accessToken);
    }
}