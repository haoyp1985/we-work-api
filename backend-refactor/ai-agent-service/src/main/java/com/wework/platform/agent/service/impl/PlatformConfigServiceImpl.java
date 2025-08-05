package com.wework.platform.agent.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.wework.platform.agent.dto.PlatformConfigDTO;
import com.wework.platform.agent.entity.PlatformConfig;
import com.wework.platform.agent.enums.PlatformType;
import com.wework.platform.agent.repository.PlatformConfigRepository;
import com.wework.platform.agent.service.PlatformConfigService;
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
 * 平台配置服务实现
 * 
 * @author WeWork Platform Team
 * @since 2024-01-15
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class PlatformConfigServiceImpl implements PlatformConfigService {

    private final PlatformConfigRepository platformConfigRepository;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public PlatformConfigDTO createPlatformConfig(String tenantId, PlatformType platformType, 
                                                 String name, String apiUrl, String apiKey, 
                                                 Map<String, Object> config) {
        log.info("创建平台配置, tenantId={}, platformType={}, name={}", 
                tenantId, platformType, name);
        
        // 检查同租户下同类型平台配置名称是否重复
        boolean exists = platformConfigRepository.exists(
            new LambdaQueryWrapper<PlatformConfig>()
                .eq(PlatformConfig::getTenantId, tenantId)
                .eq(PlatformConfig::getPlatformType, platformType)
                .eq(PlatformConfig::getName, name)
        );
        
        if (exists) {
            throw new IllegalArgumentException(
                String.format("平台配置名称已存在: %s [%s]", name, platformType.name())
            );
        }
        
        // 创建配置
        PlatformConfig platformConfig = new PlatformConfig();
        platformConfig.setTenantId(tenantId);
        platformConfig.setPlatformType(platformType);
        platformConfig.setName(name);
        platformConfig.setApiUrl(apiUrl);
        platformConfig.setApiKey(apiKey);
        platformConfig.setConfig(config);
        platformConfig.setEnabled(true);
        platformConfig.setCreatedAt(LocalDateTime.now());
        platformConfig.setUpdatedAt(LocalDateTime.now());
        
        // 保存到数据库
        platformConfigRepository.insert(platformConfig);
        
        log.info("平台配置创建成功, configId={}", platformConfig.getId());
        return convertToDTO(platformConfig);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public PlatformConfigDTO updatePlatformConfig(String tenantId, String configId, 
                                                 String name, String apiUrl, String apiKey, 
                                                 Map<String, Object> config) {
        log.info("更新平台配置, tenantId={}, configId={}", tenantId, configId);
        
        PlatformConfig platformConfig = getPlatformConfigEntity(tenantId, configId);
        
        // 如果修改名称，检查是否重复
        if (StringUtils.hasText(name) && !name.equals(platformConfig.getName())) {
            boolean exists = platformConfigRepository.exists(
                new LambdaQueryWrapper<PlatformConfig>()
                    .eq(PlatformConfig::getTenantId, tenantId)
                    .eq(PlatformConfig::getPlatformType, platformConfig.getPlatformType())
                    .eq(PlatformConfig::getName, name)
                    .ne(PlatformConfig::getId, configId)
            );
            
            if (exists) {
                throw new IllegalArgumentException("平台配置名称已存在: " + name);
            }
            platformConfig.setName(name);
        }
        
        // 更新字段
        if (StringUtils.hasText(apiUrl)) {
            platformConfig.setApiUrl(apiUrl);
        }
        if (StringUtils.hasText(apiKey)) {
            platformConfig.setApiKey(apiKey);
        }
        if (config != null && !config.isEmpty()) {
            platformConfig.setConfig(config);
        }
        
        platformConfig.setUpdatedAt(LocalDateTime.now());
        
        // 保存更新
        platformConfigRepository.updateById(platformConfig);
        
        log.info("平台配置更新成功, configId={}", configId);
        return convertToDTO(platformConfig);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deletePlatformConfig(String tenantId, String configId) {
        log.info("删除平台配置, tenantId={}, configId={}", tenantId, configId);
        
        PlatformConfig platformConfig = getPlatformConfigEntity(tenantId, configId);
        
        // 物理删除
        platformConfigRepository.deleteById(configId);
        
        log.info("平台配置删除成功, configId={}", configId);
    }

    @Override
    public PlatformConfigDTO getPlatformConfig(String tenantId, String configId) {
        log.debug("查询平台配置详情, tenantId={}, configId={}", tenantId, configId);
        
        PlatformConfig platformConfig = getPlatformConfigEntity(tenantId, configId);
        return convertToDTO(platformConfig);
    }

    @Override
    public List<PlatformConfigDTO> getTenantPlatformConfigs(String tenantId) {
        log.debug("查询租户平台配置, tenantId={}", tenantId);
        
        List<PlatformConfig> configs = platformConfigRepository.selectList(
            new LambdaQueryWrapper<PlatformConfig>()
                .eq(PlatformConfig::getTenantId, tenantId)
                .orderByDesc(PlatformConfig::getUpdatedAt)
        );
        
        return configs.stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    @Override
    public List<PlatformConfigDTO> getPlatformConfigsByType(String tenantId, PlatformType platformType) {
        log.debug("查询指定类型平台配置, tenantId={}, platformType={}", tenantId, platformType);
        
        List<PlatformConfig> configs = platformConfigRepository.selectList(
            new LambdaQueryWrapper<PlatformConfig>()
                .eq(PlatformConfig::getTenantId, tenantId)
                .eq(PlatformConfig::getPlatformType, platformType)
                .orderByDesc(PlatformConfig::getUpdatedAt)
        );
        
        return configs.stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    @Override
    public List<PlatformConfigDTO> getEnabledPlatformConfigs(String tenantId) {
        log.debug("查询已启用平台配置, tenantId={}", tenantId);
        
        List<PlatformConfig> configs = platformConfigRepository.selectList(
            new LambdaQueryWrapper<PlatformConfig>()
                .eq(PlatformConfig::getTenantId, tenantId)
                .eq(PlatformConfig::getEnabled, true)
                .orderByDesc(PlatformConfig::getUpdatedAt)
        );
        
        return configs.stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void enablePlatformConfig(String tenantId, String configId) {
        log.info("启用平台配置, tenantId={}, configId={}", tenantId, configId);
        
        PlatformConfig platformConfig = getPlatformConfigEntity(tenantId, configId);
        platformConfig.setEnabled(true);
        platformConfig.setUpdatedAt(LocalDateTime.now());
        
        platformConfigRepository.updateById(platformConfig);
        
        log.info("平台配置启用成功, configId={}", configId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void disablePlatformConfig(String tenantId, String configId) {
        log.info("禁用平台配置, tenantId={}, configId={}", tenantId, configId);
        
        PlatformConfig platformConfig = getPlatformConfigEntity(tenantId, configId);
        platformConfig.setEnabled(false);
        platformConfig.setUpdatedAt(LocalDateTime.now());
        
        platformConfigRepository.updateById(platformConfig);
        
        log.info("平台配置禁用成功, configId={}", configId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean testPlatformConfig(String tenantId, String configId) {
        log.info("测试平台配置连接, tenantId={}, configId={}", tenantId, configId);
        
        PlatformConfig platformConfig = getPlatformConfigEntity(tenantId, configId);
        
        try {
            // 根据平台类型执行不同的连接测试
            boolean testResult = performConnectionTest(platformConfig);
            
            if (testResult) {
                log.info("平台配置连接测试成功, configId={}", configId);
            } else {
                log.warn("平台配置连接测试失败, configId={}", configId);
            }
            
            return testResult;
            
        } catch (Exception e) {
            log.error("平台配置连接测试异常, configId={}", configId, e);
            return false;
        }
    }

    @Override
    public PlatformConfigDTO getDefaultPlatformConfig(String tenantId, PlatformType platformType) {
        log.debug("查询默认平台配置, tenantId={}, platformType={}", tenantId, platformType);
        
        // 查找已启用的第一个配置作为默认配置
        PlatformConfig config = platformConfigRepository.selectOne(
            new LambdaQueryWrapper<PlatformConfig>()
                .eq(PlatformConfig::getTenantId, tenantId)
                .eq(PlatformConfig::getPlatformType, platformType)
                .eq(PlatformConfig::getEnabled, true)
                .orderByDesc(PlatformConfig::getUpdatedAt)
                .last("LIMIT 1")
        );
        
        return config != null ? convertToDTO(config) : null;
    }

    @Override
    public boolean hasPlatformConfig(String tenantId, PlatformType platformType) {
        return platformConfigRepository.exists(
            new LambdaQueryWrapper<PlatformConfig>()
                .eq(PlatformConfig::getTenantId, tenantId)
                .eq(PlatformConfig::getPlatformType, platformType)
                .eq(PlatformConfig::getEnabled, true)
        );
    }

    @Override
    public long countPlatformConfigs(String tenantId) {
        return platformConfigRepository.selectCount(
            new LambdaQueryWrapper<PlatformConfig>()
                .eq(PlatformConfig::getTenantId, tenantId)
        );
    }

    @Override
    public long countEnabledPlatformConfigs(String tenantId) {
        return platformConfigRepository.selectCount(
            new LambdaQueryWrapper<PlatformConfig>()
                .eq(PlatformConfig::getTenantId, tenantId)
                .eq(PlatformConfig::getEnabled, true)
        );
    }

    /**
     * 执行连接测试
     */
    private boolean performConnectionTest(PlatformConfig config) {
        switch (config.getPlatformType()) {
            case COZE:
                return testCozeConnection(config);
            case DIFY:
                return testDifyConnection(config);
            case ALIBABA_DASHSCOPE:
                return testDashScopeConnection(config);
            case OPENAI:
                return testOpenAIConnection(config);
            case CLAUDE:
                return testClaudeConnection(config);
            case WENXIN:
                return testWenxinConnection(config);
            default:
                log.warn("不支持的平台类型连接测试: {}", config.getPlatformType());
                return false;
        }
    }

    /**
     * 测试Coze平台连接
     */
    private boolean testCozeConnection(PlatformConfig config) {
        // TODO: 实现Coze平台连接测试
        log.debug("执行Coze平台连接测试, configId={}", config.getId());
        return true;
    }

    /**
     * 测试Dify平台连接
     */
    private boolean testDifyConnection(PlatformConfig config) {
        // TODO: 实现Dify平台连接测试
        log.debug("执行Dify平台连接测试, configId={}", config.getId());
        return true;
    }

    /**
     * 测试阿里百炼连接
     */
    private boolean testDashScopeConnection(PlatformConfig config) {
        // TODO: 实现阿里百炼连接测试
        log.debug("执行阿里百炼连接测试, configId={}", config.getId());
        return true;
    }

    /**
     * 测试OpenAI连接
     */
    private boolean testOpenAIConnection(PlatformConfig config) {
        // TODO: 实现OpenAI连接测试
        log.debug("执行OpenAI连接测试, configId={}", config.getId());
        return true;
    }

    /**
     * 测试Claude连接
     */
    private boolean testClaudeConnection(PlatformConfig config) {
        // TODO: 实现Claude连接测试
        log.debug("执行Claude连接测试, configId={}", config.getId());
        return true;
    }

    /**
     * 测试文心一言连接
     */
    private boolean testWenxinConnection(PlatformConfig config) {
        // TODO: 实现文心一言连接测试
        log.debug("执行文心一言连接测试, configId={}", config.getId());
        return true;
    }

    /**
     * 获取平台配置实体
     */
    private PlatformConfig getPlatformConfigEntity(String tenantId, String configId) {
        PlatformConfig config = platformConfigRepository.selectOne(
            new LambdaQueryWrapper<PlatformConfig>()
                .eq(PlatformConfig::getId, configId)
                .eq(PlatformConfig::getTenantId, tenantId)
        );
        
        if (config == null) {
            throw new IllegalArgumentException("平台配置不存在: " + configId);
        }
        
        return config;
    }

    /**
     * 转换为DTO
     */
    private PlatformConfigDTO convertToDTO(PlatformConfig config) {
        PlatformConfigDTO dto = new PlatformConfigDTO();
        BeanUtils.copyProperties(config, dto);
        
        // 敏感信息脱敏
        if (StringUtils.hasText(dto.getApiKey())) {
            dto.setApiKey(maskApiKey(dto.getApiKey()));
        }
        
        return dto;
    }

    /**
     * API Key脱敏
     */
    private String maskApiKey(String apiKey) {
        if (apiKey.length() <= 8) {
            return "****";
        }
        
        String prefix = apiKey.substring(0, 4);
        String suffix = apiKey.substring(apiKey.length() - 4);
        return prefix + "****" + suffix;
    }
}