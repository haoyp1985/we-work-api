package com.wework.platform.agent.controller;

import com.wework.platform.agent.dto.ModelConfigDTO;
import com.wework.platform.agent.dto.response.ApiResult;
import com.wework.platform.agent.enums.PlatformType;
import com.wework.platform.agent.service.ModelConfigService;
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
 * 模型配置管理控制器
 * 
 * @author WeWork Platform Team
 * @since 2024-01-15
 */
@Slf4j
@RestController
@RequestMapping("/api/v1/model-configs")
@RequiredArgsConstructor
@Validated
@Tag(name = "模型配置管理", description = "AI模型配置的管理接口")
public class ModelConfigController {

    private final ModelConfigService modelConfigService;

    @PostMapping
    @Operation(summary = "创建模型配置", description = "为指定平台创建新的模型配置")
    public ApiResult<ModelConfigDTO> createModelConfig(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "平台配置ID", required = true)
            @RequestParam @NotBlank String platformConfigId,
            
            @Parameter(description = "模型名称", required = true)
            @RequestParam @NotBlank String modelName,
            
            @Parameter(description = "显示名称", required = false)
            @RequestParam(required = false) String displayName,
            
            @Parameter(description = "模型参数", required = false)
            @RequestBody(required = false) Map<String, Object> parameters) {
        
        log.info("创建模型配置, tenantId={}, platformConfigId={}, modelName={}", 
                tenantId, platformConfigId, modelName);
        
        try {
            ModelConfigDTO modelConfig = modelConfigService.createModelConfig(
                tenantId, platformConfigId, modelName, displayName, parameters);
            
            log.info("模型配置创建成功, configId={}", modelConfig.getId());
            return ApiResult.success(modelConfig);
            
        } catch (Exception e) {
            log.error("创建模型配置失败, tenantId={}, platformConfigId={}, modelName={}, error={}", 
                     tenantId, platformConfigId, modelName, e.getMessage(), e);
            return ApiResult.error("创建模型配置失败: " + e.getMessage());
        }
    }

    @PutMapping("/{configId}")
    @Operation(summary = "更新模型配置", description = "更新现有的模型配置")
    public ApiResult<ModelConfigDTO> updateModelConfig(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "配置ID", required = true)
            @PathVariable @NotBlank String configId,
            
            @Parameter(description = "显示名称", required = false)
            @RequestParam(required = false) String displayName,
            
            @Parameter(description = "模型参数", required = false)
            @RequestBody(required = false) Map<String, Object> parameters) {
        
        log.info("更新模型配置, tenantId={}, configId={}", tenantId, configId);
        
        try {
            ModelConfigDTO modelConfig = modelConfigService.updateModelConfig(
                tenantId, configId, displayName, parameters);
            
            log.info("模型配置更新成功, configId={}", configId);
            return ApiResult.success(modelConfig);
            
        } catch (Exception e) {
            log.error("更新模型配置失败, tenantId={}, configId={}, error={}", 
                     tenantId, configId, e.getMessage(), e);
            return ApiResult.error("更新模型配置失败: " + e.getMessage());
        }
    }

    @DeleteMapping("/{configId}")
    @Operation(summary = "删除模型配置", description = "删除指定的模型配置")
    public ApiResult<Void> deleteModelConfig(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "配置ID", required = true)
            @PathVariable @NotBlank String configId) {
        
        log.info("删除模型配置, tenantId={}, configId={}", tenantId, configId);
        
        try {
            modelConfigService.deleteModelConfig(tenantId, configId);
            
            log.info("模型配置删除成功, configId={}", configId);
            return ApiResult.success();
            
        } catch (Exception e) {
            log.error("删除模型配置失败, tenantId={}, configId={}, error={}", 
                     tenantId, configId, e.getMessage(), e);
            return ApiResult.error("删除模型配置失败: " + e.getMessage());
        }
    }

    @GetMapping("/{configId}")
    @Operation(summary = "获取模型配置详情", description = "根据ID获取模型配置详细信息")
    public ApiResult<ModelConfigDTO> getModelConfig(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "配置ID", required = true)
            @PathVariable @NotBlank String configId) {
        
        log.debug("获取模型配置详情, tenantId={}, configId={}", tenantId, configId);
        
        try {
            ModelConfigDTO modelConfig = modelConfigService.getModelConfig(tenantId, configId);
            
            return ApiResult.success(modelConfig);
            
        } catch (Exception e) {
            log.error("获取模型配置详情失败, tenantId={}, configId={}, error={}", 
                     tenantId, configId, e.getMessage(), e);
            return ApiResult.error("获取模型配置详情失败: " + e.getMessage());
        }
    }

    @GetMapping
    @Operation(summary = "获取租户模型配置列表", description = "获取租户下所有的模型配置")
    public ApiResult<List<ModelConfigDTO>> getTenantModelConfigs(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId) {
        
        log.debug("获取租户模型配置列表, tenantId={}", tenantId);
        
        try {
            List<ModelConfigDTO> configs = modelConfigService.getTenantModelConfigs(tenantId);
            
            return ApiResult.success(configs);
            
        } catch (Exception e) {
            log.error("获取租户模型配置列表失败, tenantId={}, error={}", tenantId, e.getMessage(), e);
            return ApiResult.error("获取模型配置列表失败: " + e.getMessage());
        }
    }

    @GetMapping("/platform/{platformConfigId}")
    @Operation(summary = "按平台获取模型配置", description = "获取指定平台的模型配置列表")
    public ApiResult<List<ModelConfigDTO>> getModelConfigsByPlatform(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "平台配置ID", required = true)
            @PathVariable @NotBlank String platformConfigId) {
        
        log.debug("按平台获取模型配置, tenantId={}, platformConfigId={}", tenantId, platformConfigId);
        
        try {
            List<ModelConfigDTO> configs = modelConfigService.getModelConfigsByPlatform(tenantId, platformConfigId);
            
            return ApiResult.success(configs);
            
        } catch (Exception e) {
            log.error("按平台获取模型配置失败, tenantId={}, platformConfigId={}, error={}", 
                     tenantId, platformConfigId, e.getMessage(), e);
            return ApiResult.error("获取模型配置失败: " + e.getMessage());
        }
    }

    @GetMapping("/type/{platformType}")
    @Operation(summary = "按平台类型获取模型配置", description = "获取指定平台类型的模型配置列表")
    public ApiResult<List<ModelConfigDTO>> getModelConfigsByType(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "平台类型", required = true)
            @PathVariable PlatformType platformType) {
        
        log.debug("按平台类型获取模型配置, tenantId={}, platformType={}", tenantId, platformType);
        
        try {
            List<ModelConfigDTO> configs = modelConfigService.getModelConfigsByType(tenantId, platformType);
            
            return ApiResult.success(configs);
            
        } catch (Exception e) {
            log.error("按平台类型获取模型配置失败, tenantId={}, platformType={}, error={}", 
                     tenantId, platformType, e.getMessage(), e);
            return ApiResult.error("获取模型配置失败: " + e.getMessage());
        }
    }

    @GetMapping("/enabled")
    @Operation(summary = "获取已启用的模型配置", description = "获取租户下所有已启用的模型配置")
    public ApiResult<List<ModelConfigDTO>> getEnabledModelConfigs(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId) {
        
        log.debug("获取已启用的模型配置, tenantId={}", tenantId);
        
        try {
            List<ModelConfigDTO> configs = modelConfigService.getEnabledModelConfigs(tenantId);
            
            return ApiResult.success(configs);
            
        } catch (Exception e) {
            log.error("获取已启用模型配置失败, tenantId={}, error={}", tenantId, e.getMessage(), e);
            return ApiResult.error("获取已启用模型配置失败: " + e.getMessage());
        }
    }

    @PostMapping("/{configId}/enable")
    @Operation(summary = "启用模型配置", description = "启用指定的模型配置")
    public ApiResult<Void> enableModelConfig(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "配置ID", required = true)
            @PathVariable @NotBlank String configId) {
        
        log.info("启用模型配置, tenantId={}, configId={}", tenantId, configId);
        
        try {
            modelConfigService.enableModelConfig(tenantId, configId);
            
            log.info("模型配置启用成功, configId={}", configId);
            return ApiResult.success();
            
        } catch (Exception e) {
            log.error("启用模型配置失败, tenantId={}, configId={}, error={}", 
                     tenantId, configId, e.getMessage(), e);
            return ApiResult.error("启用模型配置失败: " + e.getMessage());
        }
    }

    @PostMapping("/{configId}/disable")
    @Operation(summary = "禁用模型配置", description = "禁用指定的模型配置")
    public ApiResult<Void> disableModelConfig(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "配置ID", required = true)
            @PathVariable @NotBlank String configId) {
        
        log.info("禁用模型配置, tenantId={}, configId={}", tenantId, configId);
        
        try {
            modelConfigService.disableModelConfig(tenantId, configId);
            
            log.info("模型配置禁用成功, configId={}", configId);
            return ApiResult.success();
            
        } catch (Exception e) {
            log.error("禁用模型配置失败, tenantId={}, configId={}, error={}", 
                     tenantId, configId, e.getMessage(), e);
            return ApiResult.error("禁用模型配置失败: " + e.getMessage());
        }
    }

    @GetMapping("/platform/{platformConfigId}/default")
    @Operation(summary = "获取平台默认模型配置", description = "获取指定平台的默认模型配置")
    public ApiResult<ModelConfigDTO> getDefaultModelConfig(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "平台配置ID", required = true)
            @PathVariable @NotBlank String platformConfigId) {
        
        log.debug("获取平台默认模型配置, tenantId={}, platformConfigId={}", tenantId, platformConfigId);
        
        try {
            ModelConfigDTO config = modelConfigService.getDefaultModelConfig(tenantId, platformConfigId);
            
            if (config == null) {
                return ApiResult.error("未找到默认模型配置");
            }
            
            return ApiResult.success(config);
            
        } catch (Exception e) {
            log.error("获取平台默认模型配置失败, tenantId={}, platformConfigId={}, error={}", 
                     tenantId, platformConfigId, e.getMessage(), e);
            return ApiResult.error("获取默认模型配置失败: " + e.getMessage());
        }
    }

    @GetMapping("/find")
    @Operation(summary = "根据名称查找模型配置", description = "在指定平台下根据模型名称查找配置")
    public ApiResult<ModelConfigDTO> findModelConfigByName(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "平台配置ID", required = true)
            @RequestParam @NotBlank String platformConfigId,
            
            @Parameter(description = "模型名称", required = true)
            @RequestParam @NotBlank String modelName) {
        
        log.debug("根据名称查找模型配置, tenantId={}, platformConfigId={}, modelName={}", 
                 tenantId, platformConfigId, modelName);
        
        try {
            ModelConfigDTO config = modelConfigService.findModelConfigByName(tenantId, platformConfigId, modelName);
            
            if (config == null) {
                return ApiResult.error("未找到指定的模型配置");
            }
            
            return ApiResult.success(config);
            
        } catch (Exception e) {
            log.error("根据名称查找模型配置失败, tenantId={}, platformConfigId={}, modelName={}, error={}", 
                     tenantId, platformConfigId, modelName, e.getMessage(), e);
            return ApiResult.error("查找模型配置失败: " + e.getMessage());
        }
    }

    @PostMapping("/batch")
    @Operation(summary = "批量创建模型配置", description = "为指定平台批量创建模型配置")
    public ApiResult<Void> batchCreateModelConfigs(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "平台配置ID", required = true)
            @RequestParam @NotBlank String platformConfigId,
            
            @Parameter(description = "模型配置列表", required = true)
            @RequestBody @NotNull List<Map<String, Object>> modelConfigs) {
        
        log.info("批量创建模型配置, tenantId={}, platformConfigId={}, count={}", 
                tenantId, platformConfigId, modelConfigs.size());
        
        try {
            modelConfigService.batchCreateModelConfigs(tenantId, platformConfigId, modelConfigs);
            
            log.info("批量创建模型配置成功, tenantId={}, platformConfigId={}, count={}", 
                    tenantId, platformConfigId, modelConfigs.size());
            return ApiResult.success();
            
        } catch (Exception e) {
            log.error("批量创建模型配置失败, tenantId={}, platformConfigId={}, error={}", 
                     tenantId, platformConfigId, e.getMessage(), e);
            return ApiResult.error("批量创建模型配置失败: " + e.getMessage());
        }
    }

    @GetMapping("/statistics")
    @Operation(summary = "获取模型配置统计信息", description = "获取租户下模型配置的统计数据")
    public ApiResult<Map<String, Long>> getModelConfigStatistics(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId) {
        
        log.debug("获取模型配置统计信息, tenantId={}", tenantId);
        
        try {
            Map<String, Long> statistics = Map.of(
                "TOTAL", modelConfigService.countModelConfigs(tenantId),
                "ENABLED", modelConfigService.countEnabledModelConfigs(tenantId)
            );
            
            return ApiResult.success(statistics);
            
        } catch (Exception e) {
            log.error("获取模型配置统计信息失败, tenantId={}, error={}", tenantId, e.getMessage(), e);
            return ApiResult.error("获取统计信息失败: " + e.getMessage());
        }
    }

    @GetMapping("/platform/{platformConfigId}/count")
    @Operation(summary = "获取平台模型配置数量", description = "获取指定平台的模型配置总数")
    public ApiResult<Long> countPlatformModelConfigs(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "平台配置ID", required = true)
            @PathVariable @NotBlank String platformConfigId) {
        
        log.debug("获取平台模型配置数量, tenantId={}, platformConfigId={}", tenantId, platformConfigId);
        
        try {
            long count = modelConfigService.countPlatformModelConfigs(tenantId, platformConfigId);
            
            return ApiResult.success(count);
            
        } catch (Exception e) {
            log.error("获取平台模型配置数量失败, tenantId={}, platformConfigId={}, error={}", 
                     tenantId, platformConfigId, e.getMessage(), e);
            return ApiResult.error("获取模型配置数量失败: " + e.getMessage());
        }
    }

    @GetMapping("/platform/{platformConfigId}/check")
    @Operation(summary = "检查平台是否有模型配置", description = "检查指定平台是否已配置模型")
    public ApiResult<Boolean> hasModelConfig(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "平台配置ID", required = true)
            @PathVariable @NotBlank String platformConfigId) {
        
        log.debug("检查平台是否有模型配置, tenantId={}, platformConfigId={}", tenantId, platformConfigId);
        
        try {
            boolean exists = modelConfigService.hasModelConfig(tenantId, platformConfigId);
            
            return ApiResult.success(exists);
            
        } catch (Exception e) {
            log.error("检查平台模型配置失败, tenantId={}, platformConfigId={}, error={}", 
                     tenantId, platformConfigId, e.getMessage(), e);
            return ApiResult.error("检查模型配置失败: " + e.getMessage());
        }
    }
}