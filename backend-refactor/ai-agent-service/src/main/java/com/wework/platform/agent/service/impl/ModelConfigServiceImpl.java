package com.wework.platform.agent.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.wework.platform.agent.dto.ModelConfigDTO;
import com.wework.platform.agent.entity.ModelConfig;
import com.wework.platform.agent.entity.PlatformConfig;
import com.wework.platform.agent.enums.PlatformType;
import com.wework.platform.agent.repository.ModelConfigRepository;
import com.wework.platform.agent.repository.PlatformConfigRepository;
import com.wework.platform.agent.service.ModelConfigService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 模型配置服务实现
 * 
 * @author WeWork Platform Team
 * @since 2024-01-15
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ModelConfigServiceImpl implements ModelConfigService {

    private final ModelConfigRepository modelConfigRepository;
    private final PlatformConfigRepository platformConfigRepository;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public ModelConfigDTO createModelConfig(String tenantId, String platformConfigId, String modelName, 
                                          String displayName, Map<String, Object> parameters) {
        log.info("创建模型配置, tenantId={}, platformConfigId={}, modelName={}", 
                tenantId, platformConfigId, modelName);
        
        // 验证平台配置是否存在
        validatePlatformConfig(tenantId, platformConfigId);
        
        // 检查同平台下模型名称是否重复
        boolean exists = modelConfigRepository.exists(
            new LambdaQueryWrapper<ModelConfig>()
                .eq(ModelConfig::getTenantId, tenantId)
                .eq(ModelConfig::getPlatformConfigId, platformConfigId)
                .eq(ModelConfig::getModelName, modelName)
        );
        
        if (exists) {
            throw new IllegalArgumentException("模型名称已存在: " + modelName);
        }
        
        // 创建模型配置
        ModelConfig modelConfig = new ModelConfig();
        modelConfig.setTenantId(tenantId);
        modelConfig.setName(StringUtils.hasText(displayName) ? displayName : modelName);
        modelConfig.setModelName(modelName);
        try {
            modelConfig.setConfigJson(parameters != null ? objectMapper.writeValueAsString(parameters) : "{}");
        } catch (Exception e) {
            modelConfig.setConfigJson("{}");
        }
        modelConfig.setEnabled(true);
        modelConfig.setCreatedAt(LocalDateTime.now());
        modelConfig.setUpdatedAt(LocalDateTime.now());
        
        // 保存到数据库
        modelConfigRepository.insert(modelConfig);
        
        log.info("模型配置创建成功, configId={}", modelConfig.getId());
        return convertToDTO(modelConfig);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public ModelConfigDTO updateModelConfig(String tenantId, String configId, String displayName, 
                                          Map<String, Object> parameters) {
        log.info("更新模型配置, tenantId={}, configId={}", tenantId, configId);
        
        ModelConfig modelConfig = getModelConfigEntity(tenantId, configId);
        
        // 更新字段
        if (StringUtils.hasText(displayName)) {
            modelConfig.setName(displayName);
        }
        if (parameters != null && !parameters.isEmpty()) {
            modelConfig.setConfigJson(parameters);
        }
        
        modelConfig.setUpdatedAt(LocalDateTime.now());
        
        // 保存更新
        modelConfigRepository.updateById(modelConfig);
        
        log.info("模型配置更新成功, configId={}", configId);
        return convertToDTO(modelConfig);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteModelConfig(String tenantId, String configId) {
        log.info("删除模型配置, tenantId={}, configId={}", tenantId, configId);
        
        ModelConfig modelConfig = getModelConfigEntity(tenantId, configId);
        
        // 物理删除
        modelConfigRepository.deleteById(configId);
        
        log.info("模型配置删除成功, configId={}", configId);
    }

    @Override
    public ModelConfigDTO getModelConfig(String tenantId, String configId) {
        log.debug("查询模型配置详情, tenantId={}, configId={}", tenantId, configId);
        
        ModelConfig modelConfig = getModelConfigEntity(tenantId, configId);
        return convertToDTO(modelConfig);
    }

    @Override
    public List<ModelConfigDTO> getTenantModelConfigs(String tenantId) {
        log.debug("查询租户模型配置, tenantId={}", tenantId);
        
        List<ModelConfig> configs = modelConfigRepository.selectList(
            new LambdaQueryWrapper<ModelConfig>()
                .eq(ModelConfig::getTenantId, tenantId)
                .orderByDesc(ModelConfig::getUpdatedAt)
        );
        
        return configs.stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    @Override
    public List<ModelConfigDTO> getModelConfigsByPlatform(String tenantId, String platformConfigId) {
        log.debug("查询平台模型配置, tenantId={}, platformConfigId={}", tenantId, platformConfigId);
        
        List<ModelConfig> configs = modelConfigRepository.selectList(
            new LambdaQueryWrapper<ModelConfig>()
                .eq(ModelConfig::getTenantId, tenantId)
                .eq(ModelConfig::getPlatformConfigId, platformConfigId)
                .orderByDesc(ModelConfig::getUpdatedAt)
        );
        
        return configs.stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    @Override
    public List<ModelConfigDTO> getEnabledModelConfigs(String tenantId) {
        log.debug("查询已启用模型配置, tenantId={}", tenantId);
        
        List<ModelConfig> configs = modelConfigRepository.selectList(
            new LambdaQueryWrapper<ModelConfig>()
                .eq(ModelConfig::getTenantId, tenantId)
                .eq(ModelConfig::getEnabled, true)
                .orderByDesc(ModelConfig::getUpdatedAt)
        );
        
        return configs.stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void enableModelConfig(String tenantId, String configId) {
        log.info("启用模型配置, tenantId={}, configId={}", tenantId, configId);
        
        ModelConfig modelConfig = getModelConfigEntity(tenantId, configId);
        modelConfig.setEnabled(true);
        modelConfig.setUpdatedAt(LocalDateTime.now());
        
        modelConfigRepository.updateById(modelConfig);
        
        log.info("模型配置启用成功, configId={}", configId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void disableModelConfig(String tenantId, String configId) {
        log.info("禁用模型配置, tenantId={}, configId={}", tenantId, configId);
        
        ModelConfig modelConfig = getModelConfigEntity(tenantId, configId);
        modelConfig.setEnabled(false);
        modelConfig.setUpdatedAt(LocalDateTime.now());
        
        modelConfigRepository.updateById(modelConfig);
        
        log.info("模型配置禁用成功, configId={}", configId);
    }

    @Override
    public List<ModelConfigDTO> getModelConfigsByType(String tenantId, PlatformType platformType) {
        log.debug("查询指定类型模型配置, tenantId={}, platformType={}", tenantId, platformType);
        
        // 先查询该类型的平台配置
        List<PlatformConfig> platformConfigs = platformConfigRepository.selectList(
            new LambdaQueryWrapper<PlatformConfig>()
                .eq(PlatformConfig::getTenantId, tenantId)
                .eq(PlatformConfig::getPlatformType, platformType)
                .eq(PlatformConfig::getEnabled, true)
        );
        
        if (platformConfigs.isEmpty()) {
            return List.of();
        }
        
        // 获取平台配置ID列表
        List<String> platformConfigIds = platformConfigs.stream()
            .map(PlatformConfig::getId)
            .collect(Collectors.toList());
        
        // 查询对应的模型配置
        List<ModelConfig> modelConfigs = modelConfigRepository.selectList(
            new LambdaQueryWrapper<ModelConfig>()
                .eq(ModelConfig::getTenantId, tenantId)
                .in(ModelConfig::getPlatformConfigId, platformConfigIds)
                .eq(ModelConfig::getEnabled, true)
                .orderByDesc(ModelConfig::getUpdatedAt)
        );
        
        return modelConfigs.stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    @Override
    public ModelConfigDTO getDefaultModelConfig(String tenantId, String platformConfigId) {
        log.debug("查询默认模型配置, tenantId={}, platformConfigId={}", tenantId, platformConfigId);
        
        // 查找已启用的第一个配置作为默认配置
        ModelConfig config = modelConfigRepository.selectOne(
            new LambdaQueryWrapper<ModelConfig>()
                .eq(ModelConfig::getTenantId, tenantId)
                .eq(ModelConfig::getPlatformConfigId, platformConfigId)
                .eq(ModelConfig::getEnabled, true)
                .orderByDesc(ModelConfig::getUpdatedAt)
                .last("LIMIT 1")
        );
        
        return config != null ? convertToDTO(config) : null;
    }

    @Override
    public ModelConfigDTO findModelConfigByName(String tenantId, String platformConfigId, String modelName) {
        log.debug("根据名称查询模型配置, tenantId={}, platformConfigId={}, modelName={}", 
                 tenantId, platformConfigId, modelName);
        
        ModelConfig config = modelConfigRepository.selectOne(
            new LambdaQueryWrapper<ModelConfig>()
                .eq(ModelConfig::getTenantId, tenantId)
                .eq(ModelConfig::getPlatformConfigId, platformConfigId)
                .eq(ModelConfig::getModelName, modelName)
                .eq(ModelConfig::getEnabled, true)
        );
        
        return config != null ? convertToDTO(config) : null;
    }

    @Override
    public boolean hasModelConfig(String tenantId, String platformConfigId) {
        return modelConfigRepository.exists(
            new LambdaQueryWrapper<ModelConfig>()
                .eq(ModelConfig::getTenantId, tenantId)
                .eq(ModelConfig::getPlatformConfigId, platformConfigId)
                .eq(ModelConfig::getEnabled, true)
        );
    }

    @Override
    public long countModelConfigs(String tenantId) {
        return modelConfigRepository.selectCount(
            new LambdaQueryWrapper<ModelConfig>()
                .eq(ModelConfig::getTenantId, tenantId)
        );
    }

    @Override
    public long countEnabledModelConfigs(String tenantId) {
        return modelConfigRepository.selectCount(
            new LambdaQueryWrapper<ModelConfig>()
                .eq(ModelConfig::getTenantId, tenantId)
                .eq(ModelConfig::getEnabled, true)
        );
    }

    @Override
    public long countPlatformModelConfigs(String tenantId, String platformConfigId) {
        return modelConfigRepository.selectCount(
            new LambdaQueryWrapper<ModelConfig>()
                .eq(ModelConfig::getTenantId, tenantId)
                .eq(ModelConfig::getPlatformConfigId, platformConfigId)
        );
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void batchCreateModelConfigs(String tenantId, String platformConfigId, 
                                       List<Map<String, Object>> modelConfigs) {
        log.info("批量创建模型配置, tenantId={}, platformConfigId={}, count={}", 
                tenantId, platformConfigId, modelConfigs.size());
        
        // 验证平台配置是否存在
        validatePlatformConfig(tenantId, platformConfigId);
        
        for (Map<String, Object> configMap : modelConfigs) {
            String modelName = (String) configMap.get("modelName");
            String displayName = (String) configMap.get("displayName");
            @SuppressWarnings("unchecked")
            Map<String, Object> parameters = (Map<String, Object>) configMap.get("parameters");
            
            if (!StringUtils.hasText(modelName)) {
                log.warn("跳过无效的模型配置, modelName为空");
                continue;
            }
            
            // 检查是否已存在
            boolean exists = modelConfigRepository.exists(
                new LambdaQueryWrapper<ModelConfig>()
                    .eq(ModelConfig::getTenantId, tenantId)
                    .eq(ModelConfig::getPlatformConfigId, platformConfigId)
                    .eq(ModelConfig::getModelName, modelName)
            );
            
            if (exists) {
                log.warn("模型配置已存在，跳过创建: {}", modelName);
                continue;
            }
            
            // 创建模型配置
            ModelConfig modelConfig = new ModelConfig();
            modelConfig.setTenantId(tenantId);
            modelConfig.setPlatformType(platformConfigId);
            modelConfig.setModelName(modelName);
            modelConfig.setName(StringUtils.hasText(displayName) ? displayName : modelName);
            modelConfig.setConfigJson(parameters);
            modelConfig.setEnabled(true);
            modelConfig.setCreatedAt(LocalDateTime.now());
            modelConfig.setUpdatedAt(LocalDateTime.now());
            
            modelConfigRepository.insert(modelConfig);
            
            log.debug("模型配置创建成功: {}", modelName);
        }
        
        log.info("批量创建模型配置完成, tenantId={}, platformConfigId={}", tenantId, platformConfigId);
    }

    /**
     * 验证平台配置是否存在
     */
    private void validatePlatformConfig(String tenantId, String platformConfigId) {
        PlatformConfig platformConfig = platformConfigRepository.selectOne(
            new LambdaQueryWrapper<PlatformConfig>()
                .eq(PlatformConfig::getId, platformConfigId)
                .eq(PlatformConfig::getTenantId, tenantId)
        );
        
        if (platformConfig == null) {
            throw new IllegalArgumentException("平台配置不存在: " + platformConfigId);
        }
    }

    /**
     * 获取模型配置实体
     */
    private ModelConfig getModelConfigEntity(String tenantId, String configId) {
        ModelConfig config = modelConfigRepository.selectOne(
            new LambdaQueryWrapper<ModelConfig>()
                .eq(ModelConfig::getId, configId)
                .eq(ModelConfig::getTenantId, tenantId)
        );
        
        if (config == null) {
            throw new IllegalArgumentException("模型配置不存在: " + configId);
        }
        
        return config;
    }

    /**
     * 转换为DTO
     */
    private ModelConfigDTO convertToDTO(ModelConfig config) {
        ModelConfigDTO dto = new ModelConfigDTO();
        BeanUtils.copyProperties(config, dto);
        return dto;
    }
}