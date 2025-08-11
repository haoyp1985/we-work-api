package com.wework.platform.account.controller;

import com.wework.platform.common.core.base.Result;
import com.wework.platform.common.enums.ResultCode;
import com.wework.platform.common.core.exception.BusinessException;
import com.wework.platform.common.security.UserContextHolder;
import com.wework.platform.common.tenant.TenantContext;
import com.wework.platform.account.dto.CreateAccountRequest;
import com.wework.platform.account.service.WeWorkAccountService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/accounts/provision")
@RequiredArgsConstructor
@Tag(name = "企微账号开通", description = "登录并创建企微账号流程")
public class WeWorkProvisionController {

    private final WeWorkAccountService accountService;

    @Operation(summary = "发起登录并创建流程", description = "返回taskId与qrcode内容")
    @PostMapping
    public Result<String> provision(@Valid @RequestBody CreateAccountRequest request) {
        String tenantId = TenantContext.getTenantId();
        String userId = TenantContext.getUserId();
        if (!StringUtils.hasText(tenantId)) {
            tenantId = UserContextHolder.getCurrentTenantId();
        }
        if (!StringUtils.hasText(userId)) {
            userId = UserContextHolder.getCurrentUserId();
        }
        if (!StringUtils.hasText(tenantId)) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "租户ID不能为空，请在请求头 X-Tenant-Id 传递或登录后重试");
        }
        if (!StringUtils.hasText(userId)) {
            userId = "system";
        }
        String taskId = accountService.startProvision(request, tenantId, userId);
        return Result.success(taskId);
    }

    @Operation(summary = "查询开通状态", description = "根据taskId查询当前状态")
    @GetMapping("/status")
    public Result<com.wework.platform.account.dto.ProvisionStatusDTO> provisionStatus(@RequestParam String taskId) {
        var status = accountService.queryProvisionStatus(taskId);
        return Result.success(status);
    }

    @Operation(summary = "获取二维码内容", description = "根据taskId获取当前二维码内容")
    @GetMapping("/qrcode")
    public Result<String> provisionQrcode(@RequestParam String taskId) {
        String content = accountService.getProvisionQrcode(taskId);
        return Result.success(content);
    }
}


