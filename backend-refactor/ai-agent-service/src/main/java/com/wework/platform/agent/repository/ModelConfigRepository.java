package com.wework.platform.agent.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.agent.entity.ModelConfig;
import com.wework.platform.agent.enums.PlatformType;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 模型配置数据访问接口
 */
@Mapper
public interface ModelConfigRepository extends BaseMapper<ModelConfig> {

    /**
     * 分页查询模型配置列表
     *
     * @param page         分页参数
     * @param tenantId     租户ID
     * @param name         配置名称(模糊匹配)
     * @param platformType 平台类型
     * @param modelName    模型名称(模糊匹配)
     * @param enabled      是否启用
     * @return 分页结果
     */
        IPage<ModelConfig> selectPageByConditions(Page<ModelConfig> page,
                                             @Param("tenantId") String tenantId,
                                             @Param("name") String name,
                                             @Param("platformType") PlatformType platformType,
                                             @Param("modelName") String modelName,
                                             @Param("enabled") Boolean enabled);

    /**
     * 根据租户ID和平台类型查询模型配置列表
     *
     * @param tenantId     租户ID
     * @param platformType 平台类型
     * @param enabled      是否启用
     * @return 配置列表
     */
        List<ModelConfig> selectByTenantAndType(@Param("tenantId") String tenantId,
                                           @Param("platformType") PlatformType platformType,
                                           @Param("enabled") Boolean enabled);

    /**
     * 根据租户ID查询所有启用的模型配置
     *
     * @param tenantId 租户ID
     * @return 启用的配置列表
     */
        List<ModelConfig> selectEnabledByTenant(@Param("tenantId") String tenantId);

    /**
     * 根据模型名称查询配置
     *
     * @param tenantId     租户ID
     * @param platformType 平台类型
     * @param modelName    模型名称
     * @return 配置信息
     */
        ModelConfig selectByModel(@Param("tenantId") String tenantId,
                             @Param("platformType") PlatformType platformType,
                             @Param("modelName") String modelName);

    /**
     * 检查API密钥是否已存在
     *
     * @param tenantId     租户ID
     * @param platformType 平台类型
     * @param apiKey       API密钥
     * @param excludeId    排除的配置ID
     * @return 是否存在
     */
        int countByApiKey(@Param("tenantId") String tenantId,
                     @Param("platformType") PlatformType platformType,
                     @Param("apiKey") String apiKey,
                     @Param("excludeId") String excludeId);

    /**
     * 更新配置启用状态
     *
     * @param tenantId 租户ID
     * @param id       配置ID
     * @param enabled  是否启用
     * @return 更新记录数
     */
        int updateEnabled(@Param("tenantId") String tenantId,
                     @Param("id") String id,
                     @Param("enabled") Boolean enabled);

    /**
     * 统计模型配置数量
     *
     * @param tenantId 租户ID
     * @return 各平台模型配置数量
     */
        List<ModelTypeCount> selectCountByType(@Param("tenantId") String tenantId);

    /**
     * 查询最受欢迎的模型配置
     *
     * @param tenantId 租户ID
     * @param limit    限制数量
     * @return 热门模型配置
     */
        List<ModelConfig> selectPopularModels(@Param("tenantId") String tenantId,
                                         @Param("limit") Integer limit);

    /**
     * 模型类型统计内部类
     */
    class ModelTypeCount {
        private PlatformType platformType;
        private String modelName;
        private Long count;

        // getters and setters
        public PlatformType getPlatformType() { return platformType; }
        public void setPlatformType(PlatformType platformType) { this.platformType = platformType; }
        public String getModelName() { return modelName; }
        public void setModelName(String modelName) { this.modelName = modelName; }
        public Long getCount() { return count; }
        public void setCount(Long count) { this.count = count; }
    }
}