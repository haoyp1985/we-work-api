package com.wework.platform.agent.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.agent.entity.Agent;
import com.wework.platform.agent.enums.AgentStatus;
import com.wework.platform.agent.enums.AgentType;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

/**
 * 智能体数据访问接口
 */
@Mapper
public interface AgentRepository extends BaseMapper<Agent> {

    /**
     * 分页查询智能体列表
     *
     * @param page     分页参数
     * @param tenantId 租户ID
     * @param name     智能体名称(模糊匹配)
     * @param type     智能体类型
     * @param status   智能体状态
     * @param enabled  是否启用
     * @return 分页结果
     */
    @Select({
        "<script>",
        "SELECT * FROM agents",
        "WHERE tenant_id = #{tenantId}",
        "AND deleted = 0",
        "<if test='name != null and name != \"\"'>",
        "AND name LIKE CONCAT('%', #{name}, '%')",
        "</if>",
        "<if test='type != null'>",
        "AND type = #{type}",
        "</if>",
        "<if test='status != null'>",
        "AND status = #{status}",
        "</if>",
        "<if test='enabled != null'>",
        "AND enabled = #{enabled}",
        "</if>",
        "ORDER BY sort_order ASC, created_at DESC",
        "</script>"
    })
    IPage<Agent> selectPageByConditions(Page<Agent> page,
                                       @Param("tenantId") String tenantId,
                                       @Param("name") String name,
                                       @Param("type") AgentType type,
                                       @Param("status") AgentStatus status,
                                       @Param("enabled") Boolean enabled);

    /**
     * 根据租户ID和状态查询智能体列表
     *
     * @param tenantId 租户ID
     * @param statuses 状态列表
     * @return 智能体列表
     */
    @Select({
        "<script>",
        "SELECT * FROM agents",
        "WHERE tenant_id = #{tenantId}",
        "AND deleted = 0",
        "<if test='statuses != null and statuses.size() > 0'>",
        "AND status IN",
        "<foreach item='status' collection='statuses' open='(' separator=',' close=')'>",
        "#{status}",
        "</foreach>",
        "</if>",
        "ORDER BY sort_order ASC, created_at DESC",
        "</script>"
    })
    List<Agent> selectByTenantAndStatuses(@Param("tenantId") String tenantId,
                                         @Param("statuses") List<AgentStatus> statuses);

    /**
     * 根据平台配置ID查询智能体列表
     *
     * @param tenantId         租户ID
     * @param platformConfigId 平台配置ID
     * @return 智能体列表
     */
    @Select("SELECT * FROM agents WHERE tenant_id = #{tenantId} AND platform_config_id = #{platformConfigId} AND deleted = 0")
    List<Agent> selectByPlatformConfigId(@Param("tenantId") String tenantId,
                                        @Param("platformConfigId") String platformConfigId);

    /**
     * 根据模型配置ID查询智能体列表
     *
     * @param tenantId      租户ID
     * @param modelConfigId 模型配置ID
     * @return 智能体列表
     */
    @Select("SELECT * FROM agents WHERE tenant_id = #{tenantId} AND model_config_id = #{modelConfigId} AND deleted = 0")
    List<Agent> selectByModelConfigId(@Param("tenantId") String tenantId,
                                     @Param("modelConfigId") String modelConfigId);

    /**
     * 更新智能体状态
     *
     * @param tenantId 租户ID
     * @param id       智能体ID
     * @param status   新状态
     * @return 更新记录数
     */
    @Update("UPDATE agents SET status = #{status}, updated_at = NOW() WHERE tenant_id = #{tenantId} AND id = #{id} AND deleted = 0")
    int updateStatus(@Param("tenantId") String tenantId,
                    @Param("id") String id,
                    @Param("status") AgentStatus status);

    /**
     * 更新智能体启用状态
     *
     * @param tenantId 租户ID
     * @param id       智能体ID
     * @param enabled  是否启用
     * @return 更新记录数
     */
    @Update("UPDATE agents SET enabled = #{enabled}, updated_at = NOW() WHERE tenant_id = #{tenantId} AND id = #{id} AND deleted = 0")
    int updateEnabled(@Param("tenantId") String tenantId,
                     @Param("id") String id,
                     @Param("enabled") Boolean enabled);

    /**
     * 统计租户下的智能体数量
     *
     * @param tenantId 租户ID
     * @return 智能体数量统计
     */
    @Select({
        "SELECT",
        "COUNT(*) as total,",
        "SUM(CASE WHEN enabled = 1 THEN 1 ELSE 0 END) as enabled_count,",
        "SUM(CASE WHEN status = 'RUNNING' THEN 1 ELSE 0 END) as running_count",
        "FROM agents",
        "WHERE tenant_id = #{tenantId} AND deleted = 0"
    })
    AgentStatistics selectStatistics(@Param("tenantId") String tenantId);

    /**
     * 智能体统计信息内部类
     */
    class AgentStatistics {
        private Long total;
        private Long enabledCount;
        private Long runningCount;

        // getters and setters
        public Long getTotal() { return total; }
        public void setTotal(Long total) { this.total = total; }
        public Long getEnabledCount() { return enabledCount; }
        public void setEnabledCount(Long enabledCount) { this.enabledCount = enabledCount; }
        public Long getRunningCount() { return runningCount; }
        public void setRunningCount(Long runningCount) { this.runningCount = runningCount; }
    }
}