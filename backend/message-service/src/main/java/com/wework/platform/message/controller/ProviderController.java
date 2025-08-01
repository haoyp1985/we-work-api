package com.wework.platform.message.controller;

import com.wework.platform.common.dto.ApiResponse;
import com.wework.platform.message.provider.WeWorkApiProvider;
import com.wework.platform.message.provider.WeWorkProviderManager;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 企微接口提供商管理控制器
 *
 * @author WeWork Platform Team
 */
@Slf4j
@RestController
@RequestMapping("/providers")
@RequiredArgsConstructor
@Tag(name = "提供商管理", description = "企微接口提供商管理相关接口")
public class ProviderController {

    private final WeWorkProviderManager providerManager;

    @GetMapping("")
    @Operation(summary = "获取所有提供商", description = "获取所有可用的企微接口提供商列表")
    public ApiResponse<List<Map<String, Object>>> getAllProviders() {
        
        List<Map<String, Object>> providers = providerManager.getAllProviders().stream()
                .map(this::buildProviderInfo)
                .toList();
        
        return ApiResponse.success(providers);
    }

    @GetMapping("/{providerCode}")
    @Operation(summary = "获取指定提供商信息", description = "根据提供商代码获取详细信息")
    public ApiResponse<Map<String, Object>> getProvider(
            @Parameter(description = "提供商代码") @PathVariable String providerCode) {
        
        return providerManager.getProvider(providerCode)
                .map(this::buildProviderInfo)
                .map(ApiResponse::success)
                .orElse(ApiResponse.notFound("提供商不存在: " + providerCode));
    }

    @GetMapping("/default")
    @Operation(summary = "获取默认提供商", description = "获取当前默认使用的提供商")
    public ApiResponse<Map<String, Object>> getDefaultProvider() {
        
        WeWorkApiProvider defaultProvider = providerManager.getDefaultProvider();
        return ApiResponse.success(buildProviderInfo(defaultProvider));
    }

    @GetMapping("/health")
    @Operation(summary = "健康检查", description = "检查所有提供商的健康状态")
    public ApiResponse<Map<String, Boolean>> healthCheck() {
        
        Map<String, Boolean> healthStatus = providerManager.healthCheck();
        return ApiResponse.success(healthStatus);
    }

    @GetMapping("/{providerCode}/health")
    @Operation(summary = "单个提供商健康检查", description = "检查指定提供商的健康状态")
    public ApiResponse<Map<String, Object>> checkProviderHealth(
            @Parameter(description = "提供商代码") @PathVariable String providerCode) {
        
        return providerManager.getProvider(providerCode)
                .map(provider -> {
                    boolean healthy = provider.healthCheck();
                    Map<String, Object> result = Map.of(
                        "providerCode", providerCode,
                        "providerName", provider.getProviderName(),
                        "healthy", healthy,
                        "checkTime", System.currentTimeMillis()
                    );
                    return ApiResponse.success(result);
                })
                .orElse(ApiResponse.notFound("提供商不存在: " + providerCode));
    }

    @GetMapping("/stats")
    @Operation(summary = "获取提供商统计", description = "获取所有提供商的统计信息")
    public ApiResponse<Map<String, Object>> getProviderStats() {
        
        Map<String, Object> stats = providerManager.getProviderStats();
        return ApiResponse.success(stats);
    }

    @GetMapping("/{providerCode}/clients")
    @Operation(summary = "获取提供商客户端列表", description = "获取指定提供商的所有客户端实例")
    public ApiResponse<List<String>> getProviderClients(
            @Parameter(description = "提供商代码") @PathVariable String providerCode) {
        
        return providerManager.getProvider(providerCode)
                .map(provider -> {
                    List<String> clients = provider.getAllClients();
                    return ApiResponse.success(clients);
                })
                .orElse(ApiResponse.notFound("提供商不存在: " + providerCode));
    }

    @GetMapping("/{providerCode}/clients/{guid}/status")
    @Operation(summary = "获取客户端状态", description = "获取指定客户端实例的状态")
    public ApiResponse<Map<String, Object>> getClientStatus(
            @Parameter(description = "提供商代码") @PathVariable String providerCode,
            @Parameter(description = "客户端GUID") @PathVariable String guid) {
        
        return providerManager.getProvider(providerCode)
                .map(provider -> {
                    Map<String, Object> status = provider.getClientStatus(guid);
                    return ApiResponse.success(status);
                })
                .orElse(ApiResponse.notFound("提供商不存在: " + providerCode));
    }

    // ================================
    // 私有方法
    // ================================

    /**
     * 构建提供商信息
     */
    private Map<String, Object> buildProviderInfo(WeWorkApiProvider provider) {
        return Map.of(
            "code", provider.getProviderCode(),
            "name", provider.getProviderName(),
            "enabled", provider.isEnabled(),
            "priority", provider.getPriority(),
            "healthy", safeHealthCheck(provider),
            "apiUrl", provider.buildApiUrl(""),
            "supportedFeatures", getSupportedFeatures(provider)
        );
    }

    /**
     * 安全的健康检查
     */
    private boolean safeHealthCheck(WeWorkApiProvider provider) {
        try {
            return provider.healthCheck();
        } catch (Exception e) {
            log.warn("提供商健康检查失败: {}, 错误: {}", provider.getProviderCode(), e.getMessage());
            return false;
        }
    }

    /**
     * 获取支持的功能列表
     */
    private List<String> getSupportedFeatures(WeWorkApiProvider provider) {
        List<String> features = List.of(
            "SEND_TEXT", "SEND_IMAGE", "SEND_VIDEO", "SEND_FILE", "SEND_VOICE",
            "SEND_LINK", "SEND_MINIPROGRAM", "SEND_CONTACT", "SEND_LOCATION",
            "SEND_GIF", "SEND_MENTION", "SEND_QUOTE", "BATCH_SEND", "CALLBACK_HANDLE"
        );
        
        return features.stream()
                .filter(provider::supports)
                .toList();
    }
}