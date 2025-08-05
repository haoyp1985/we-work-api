package com.wework.platform.agent.controller;

import com.wework.platform.agent.dto.PlatformConfigDTO;
import com.wework.platform.agent.dto.response.ApiResult;
import com.wework.platform.agent.enums.PlatformType;
import com.wework.platform.agent.service.PlatformConfigService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.util.List;
import java.util.Map;

/**
 * 平台配置管理控制器
 * 
 * @author WeWork Platform Team
 * @since 2024-01-15
 */
@Slf4j
@RestController
@RequestMapping("/api/v1/platform-configs")
@RequiredArgsConstructor
@Validated
@Tag(name = "平台配置管理", description = "外部AI平台配置的管理接口")
public class PlatformConfigController {

    private final PlatformConfigService platformConfigService;

    @PostMapping
    @Operation(summary = "创建平台配置", description = "创建新的外部AI平台配置")
    public ApiResult<PlatformConfigDTO> createPlatformConfig(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "平台类型", required = true)
            @RequestParam @NotNull PlatformType platformType,
            
            @Parameter(description = "配置名称", required = true)
            @RequestParam @NotBlank String name,
            
            @Parameter(description = "API地址", required = true)
            @RequestParam @NotBlank String apiUrl,
            
            @Parameter(description = "API密钥", required = true)
            @RequestParam @NotBlank String apiKey,
            
            @Parameter(description = "其他配置参数", required = false)
            @RequestBody(required = false) Map<String, Object> config) {
        
        log.info("创建平台配置, tenantId={}, platformType={}, name={}", 
                tenantId, platformType, name);
        
        try {
            PlatformConfigDTO platformConfig = platformConfigService.createPlatformConfig(
                tenantId, platformType, name, apiUrl, apiKey, config);
            
            log.info("平台配置创建成功, configId={}", platformConfig.getId());
            return ApiResult.success(platformConfig);
            
        } catch (Exception e) {
            log.error("创建平台配置失败, tenantId={}, platformType={}, name={}, error={}", 
                     tenantId, platformType, name, e.getMessage(), e);
            return ApiResult.error("创建平台配置失败: " + e.getMessage());
        }
    }

    @PutMapping("/{configId}")
    @Operation(summary = "更新平台配置", description = "更新现有的平台配置")
    public ApiResult<PlatformConfigDTO> updatePlatformConfig(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "配置ID", required = true)
            @PathVariable @NotBlank String configId,
            
            @Parameter(description = "配置名称", required = false)
            @RequestParam(required = false) String name,
            
            @Parameter(description = "API地址", required = false)
            @RequestParam(required = false) String apiUrl,
            
            @Parameter(description = "API密钥", required = false)
            @RequestParam(required = false) String apiKey,
            
            @Parameter(description = "其他配置参数", required = false)
            @RequestBody(required = false) Map<String, Object> config) {
        
        log.info("更新平台配置, tenantId={}, configId={}", tenantId, configId);
        
        try {
            PlatformConfigDTO platformConfig = platformConfigService.updatePlatformConfig(
                tenantId, configId, name, apiUrl, apiKey, config);
            
            log.info("平台配置更新成功, configId={}", configId);
            return ApiResult.success(platformConfig);
            
        } catch (Exception e) {
            log.error("更新平台配置失败, tenantId={}, configId={}, error={}", 
                     tenantId, configId, e.getMessage(), e);
            return ApiResult.error("更新平台配置失败: " + e.getMessage());
        }
    }

    @DeleteMapping("/{configId}")
    @Operation(summary = "删除平台配置", description = "删除指定的平台配置")
    public ApiResult<Void> deletePlatformConfig(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "配置ID", required = true)
            @PathVariable @NotBlank String configId) {
        
        log.info("删除平台配置, tenantId={}, configId={}", tenantId, configId);
        
        try {
            platformConfigService.deletePlatformConfig(tenantId, configId);
            
            log.info("平台配置删除成功, configId={}", configId);
            return ApiResult.success();
            
        } catch (Exception e) {
            log.error("删除平台配置失败, tenantId={}, configId={}, error={}", 
                     tenantId, configId, e.getMessage(), e);
            return ApiResult.error("删除平台配置失败: " + e.getMessage());
        }
    }

    @GetMapping("/{configId}")
    @Operation(summary = "获取平台配置详情", description = "根据ID获取平台配置详细信息")
    public ApiResult<PlatformConfigDTO> getPlatformConfig(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "配置ID", required = true)
            @PathVariable @NotBlank String configId) {
        
        log.debug("获取平台配置详情, tenantId={}, configId={}", tenantId, configId);
        
        try {
            PlatformConfigDTO platformConfig = platformConfigService.getPlatformConfig(tenantId, configId);
            
            return ApiResult.success(platformConfig);
            
        } catch (Exception e) {
            log.error("获取平台配置详情失败, tenantId={}, configId={}, error={}", 
                     tenantId, configId, e.getMessage(), e);
            return ApiResult.error("获取平台配置详情失败: " + e.getMessage());
        }
    }

    @GetMapping
    @Operation(summary = "获取租户平台配置列表", description = "获取租户下所有的平台配置")
    public ApiResult<List<PlatformConfigDTO>> getTenantPlatformConfigs(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId) {
        
        log.debug("获取租户平台配置列表, tenantId={}", tenantId);
        
        try {
            List<PlatformConfigDTO> configs = platformConfigService.getTenantPlatformConfigs(tenantId);
            
            return ApiResult.success(configs);
            
        } catch (Exception e) {
            log.error("获取租户平台配置列表失败, tenantId={}, error={}", tenantId, e.getMessage(), e);
            return ApiResult.error("获取平台配置列表失败: " + e.getMessage());
        }
    }

    @GetMapping("/type/{platformType}")
    @Operation(summary = "按类型获取平台配置", description = "获取指定类型的平台配置列表")
    public ApiResult<List<PlatformConfigDTO>> getPlatformConfigsByType(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "平台类型", required = true)
            @PathVariable PlatformType platformType) {
        
        log.debug("按类型获取平台配置, tenantId={}, platformType={}", tenantId, platformType);
        
        try {
            List<PlatformConfigDTO> configs = platformConfigService.getPlatformConfigsByType(tenantId, platformType);
            
            return ApiResult.success(configs);
            
        } catch (Exception e) {
            log.error("按类型获取平台配置失败, tenantId={}, platformType={}, error={}", 
                     tenantId, platformType, e.getMessage(), e);
            return ApiResult.error("获取平台配置失败: " + e.getMessage());
        }
    }

    @GetMapping("/enabled")
    @Operation(summary = "获取已启用的平台配置", description = "获取租户下所有已启用的平台配置")
    public ApiResult<List<PlatformConfigDTO>> getEnabledPlatformConfigs(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId) {
        
        log.debug("获取已启用的平台配置, tenantId={}", tenantId);
        
        try {
            List<PlatformConfigDTO> configs = platformConfigService.getEnabledPlatformConfigs(tenantId);
            
            return ApiResult.success(configs);
            
        } catch (Exception e) {
            log.error("获取已启用平台配置失败, tenantId={}, error={}", tenantId, e.getMessage(), e);
            return ApiResult.error("获取已启用平台配置失败: " + e.getMessage());
        }
    }

    @PostMapping("/{configId}/enable")
    @Operation(summary = "启用平台配置", description = "启用指定的平台配置")
    public ApiResult<Void> enablePlatformConfig(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "配置ID", required = true)
            @PathVariable @NotBlank String configId) {
        
        log.info("启用平台配置, tenantId={}, configId={}", tenantId, configId);
        
        try {
            platformConfigService.enablePlatformConfig(tenantId, configId);
            
            log.info("平台配置启用成功, configId={}", configId);
            return ApiResult.success();
            
        } catch (Exception e) {
            log.error("启用平台配置失败, tenantId={}, configId={}, error={}", 
                     tenantId, configId, e.getMessage(), e);
            return ApiResult.error("启用平台配置失败: " + e.getMessage());
        }
    }

    @PostMapping("/{configId}/disable")
    @Operation(summary = "禁用平台配置", description = "禁用指定的平台配置")
    public ApiResult<Void> disablePlatformConfig(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "配置ID", required = true)
            @PathVariable @NotBlank String configId) {
        
        log.info("禁用平台配置, tenantId={}, configId={}", tenantId, configId);
        
        try {
            platformConfigService.disablePlatformConfig(tenantId, configId);
            
            log.info("平台配置禁用成功, configId={}", configId);
            return ApiResult.success();
            
        } catch (Exception e) {
            log.error("禁用平台配置失败, tenantId={}, configId={}, error={}", 
                     tenantId, configId, e.getMessage(), e);
            return ApiResult.error("禁用平台配置失败: " + e.getMessage());
        }
    }

    @PostMapping("/{configId}/test")
    @Operation(summary = "测试平台配置连接", description = "测试指定平台配置的连接可用性")
    public ApiResult<Boolean> testPlatformConfig(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "配置ID", required = true)
            @PathVariable @NotBlank String configId) {
        
        log.info("测试平台配置连接, tenantId={}, configId={}", tenantId, configId);
        
        try {
            boolean testResult = platformConfigService.testPlatformConfig(tenantId, configId);
            
            log.info("平台配置连接测试完成, configId={}, result={}", configId, testResult);
            return ApiResult.success(testResult);
            
        } catch (Exception e) {
            log.error("测试平台配置连接失败, tenantId={}, configId={}, error={}", 
                     tenantId, configId, e.getMessage(), e);
            return ApiResult.error("测试连接失败: " + e.getMessage());
        }
    }

    @GetMapping("/type/{platformType}/default")
    @Operation(summary = "获取默认平台配置", description = "获取指定类型的默认平台配置")
    public ApiResult<PlatformConfigDTO> getDefaultPlatformConfig(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "平台类型", required = true)
            @PathVariable PlatformType platformType) {
        
        log.debug("获取默认平台配置, tenantId={}, platformType={}", tenantId, platformType);
        
        try {
            PlatformConfigDTO config = platformConfigService.getDefaultPlatformConfig(tenantId, platformType);
            
            if (config == null) {
                return ApiResult.error("未找到默认平台配置");
            }
            
            return ApiResult.success(config);
            
        } catch (Exception e) {
            log.error("获取默认平台配置失败, tenantId={}, platformType={}, error={}", 
                     tenantId, platformType, e.getMessage(), e);
            return ApiResult.error("获取默认平台配置失败: " + e.getMessage());
        }
    }

    @GetMapping("/statistics")
    @Operation(summary = "获取平台配置统计信息", description = "获取租户下平台配置的统计数据")
    public ApiResult<Map<String, Long>> getPlatformConfigStatistics(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId) {
        
        log.debug("获取平台配置统计信息, tenantId={}", tenantId);
        
        try {
            Map<String, Long> statistics = Map.of(
                "TOTAL", platformConfigService.countPlatformConfigs(tenantId),
                "ENABLED", platformConfigService.countEnabledPlatformConfigs(tenantId)
            );
            
            return ApiResult.success(statistics);
            
        } catch (Exception e) {
            log.error("获取平台配置统计信息失败, tenantId={}, error={}", tenantId, e.getMessage(), e);
            return ApiResult.error("获取统计信息失败: " + e.getMessage());
        }
    }

    @GetMapping("/check/{platformType}")
    @Operation(summary = "检查平台配置是否存在", description = "检查指定类型的平台配置是否已配置")
    public ApiResult<Boolean> hasPlatformConfig(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "平台类型", required = true)
            @PathVariable PlatformType platformType) {
        
        log.debug("检查平台配置是否存在, tenantId={}, platformType={}", tenantId, platformType);
        
        try {
            boolean exists = platformConfigService.hasPlatformConfig(tenantId, platformType);
            
            return ApiResult.success(exists);
            
        } catch (Exception e) {
            log.error("检查平台配置失败, tenantId={}, platformType={}, error={}", 
                     tenantId, platformType, e.getMessage(), e);
            return ApiResult.error("检查平台配置失败: " + e.getMessage());
        }
    }
}