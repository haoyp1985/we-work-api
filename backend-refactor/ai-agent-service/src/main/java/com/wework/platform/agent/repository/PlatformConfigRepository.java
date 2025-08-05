package com.wework.platform.agent.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.agent.entity.PlatformConfig;
import com.wework.platform.agent.enums.PlatformType;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

/**
 * 外部平台配置数据访问接口
 */
@Mapper
public interface PlatformConfigRepository extends BaseMapper<PlatformConfig> {

    /**
     * 分页查询平台配置列表
     *
     * @param page         分页参数
     * @param tenantId     租户ID
     * @param name         配置名称(模糊匹配)
     * @param platformType 平台类型
     * @param enabled      是否启用
     * @return 分页结果
     */
    @Select({
        "<script>",
        "SELECT * FROM platform_configs",
        "WHERE tenant_id = #{tenantId}",
        "AND deleted = 0",
        "<if test='name != null and name != \"\"'>",
        "AND name LIKE CONCAT('%', #{name}, '%')",
        "</if>",
        "<if test='platformType != null'>",
        "AND platform_type = #{platformType}",
        "</if>",
        "<if test='enabled != null'>",
        "AND enabled = #{enabled}",
        "</if>",
        "ORDER BY created_at DESC",
        "</script>"
    })
    IPage<PlatformConfig> selectPageByConditions(Page<PlatformConfig> page,
                                                @Param("tenantId") String tenantId,
                                                @Param("name") String name,
                                                @Param("platformType") PlatformType platformType,
                                                @Param("enabled") Boolean enabled);

    /**
     * 根据租户ID和平台类型查询配置列表
     *
     * @param tenantId     租户ID
     * @param platformType 平台类型
     * @param enabled      是否启用
     * @return 配置列表
     */
    @Select({
        "<script>",
        "SELECT * FROM platform_configs",
        "WHERE tenant_id = #{tenantId}",
        "AND platform_type = #{platformType}",
        "AND deleted = 0",
        "<if test='enabled != null'>",
        "AND enabled = #{enabled}",
        "</if>",
        "ORDER BY created_at DESC",
        "</script>"
    })
    List<PlatformConfig> selectByTenantAndType(@Param("tenantId") String tenantId,
                                              @Param("platformType") PlatformType platformType,
                                              @Param("enabled") Boolean enabled);

    /**
     * 根据租户ID查询所有启用的平台配置
     *
     * @param tenantId 租户ID
     * @return 启用的配置列表
     */
    @Select("SELECT * FROM platform_configs WHERE tenant_id = #{tenantId} AND enabled = 1 AND deleted = 0 ORDER BY created_at DESC")
    List<PlatformConfig> selectEnabledByTenant(@Param("tenantId") String tenantId);

    /**
     * 根据Bot ID查询配置
     *
     * @param tenantId 租户ID
     * @param botId    Bot ID
     * @return 配置信息
     */
    @Select("SELECT * FROM platform_configs WHERE tenant_id = #{tenantId} AND bot_id = #{botId} AND deleted = 0")
    PlatformConfig selectByBotId(@Param("tenantId") String tenantId,
                                @Param("botId") String botId);

    /**
     * 检查API密钥是否已存在
     *
     * @param tenantId     租户ID
     * @param platformType 平台类型
     * @param apiKey       API密钥
     * @param excludeId    排除的配置ID
     * @return 是否存在
     */
    @Select({
        "<script>",
        "SELECT COUNT(1) FROM platform_configs",
        "WHERE tenant_id = #{tenantId}",
        "AND platform_type = #{platformType}",
        "AND api_key = #{apiKey}",
        "AND deleted = 0",
        "<if test='excludeId != null and excludeId != \"\"'>",
        "AND id != #{excludeId}",
        "</if>",
        "</script>"
    })
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
    @Update("UPDATE platform_configs SET enabled = #{enabled}, updated_at = NOW() WHERE tenant_id = #{tenantId} AND id = #{id} AND deleted = 0")
    int updateEnabled(@Param("tenantId") String tenantId,
                     @Param("id") String id,
                     @Param("enabled") Boolean enabled);

    /**
     * 统计平台配置数量
     *
     * @param tenantId 租户ID
     * @return 各平台配置数量
     */
    @Select({
        "SELECT platform_type, COUNT(*) as count",
        "FROM platform_configs",
        "WHERE tenant_id = #{tenantId} AND deleted = 0",
        "GROUP BY platform_type"
    })
    List<PlatformTypeCount> selectCountByType(@Param("tenantId") String tenantId);

    /**
     * 平台类型统计内部类
     */
    class PlatformTypeCount {
        private PlatformType platformType;
        private Long count;

        // getters and setters
        public PlatformType getPlatformType() { return platformType; }
        public void setPlatformType(PlatformType platformType) { this.platformType = platformType; }
        public Long getCount() { return count; }
        public void setCount(Long count) { this.count = count; }
    }
}