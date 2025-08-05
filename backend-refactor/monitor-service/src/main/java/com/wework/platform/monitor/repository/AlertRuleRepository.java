package com.wework.platform.monitor.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.common.enums.AlertLevel;
import com.wework.platform.common.enums.AlertStatus;
import com.wework.platform.monitor.entity.AlertRule;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 告警规则Repository
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
@Mapper
public interface AlertRuleRepository extends BaseMapper<AlertRule> {

    /**
     * 分页查询租户的告警规则
     *
     * @param page 分页参数
     * @param tenantId 租户ID
     * @param ruleName 规则名称
     * @param metricName 指标名称
     * @param alertLevel 告警级别
     * @param status 状态
     * @return 分页结果
     */
    @Select("<script>" +
            "SELECT * FROM alert_rules " +
            "WHERE tenant_id = #{tenantId} " +
            "<if test='ruleName != null and ruleName != \"\"'>" +
            "AND rule_name LIKE CONCAT('%', #{ruleName}, '%') " +
            "</if>" +
            "<if test='metricName != null and metricName != \"\"'>" +
            "AND metric_name = #{metricName} " +
            "</if>" +
            "<if test='alertLevel != null'>" +
            "AND alert_level = #{alertLevel} " +
            "</if>" +
            "<if test='status != null'>" +
            "AND status = #{status} " +
            "</if>" +
            "AND deleted_at IS NULL " +
            "ORDER BY created_at DESC" +
            "</script>")
    IPage<AlertRule> selectPageByConditions(
            Page<AlertRule> page,
            @Param("tenantId") String tenantId,
            @Param("ruleName") String ruleName,
            @Param("metricName") String metricName,
            @Param("alertLevel") AlertLevel alertLevel,
            @Param("status") AlertStatus status
    );

    /**
     * 查询启用的告警规则
     *
     * @param tenantId 租户ID
     * @return 规则列表
     */
    @Select("SELECT * FROM alert_rules " +
            "WHERE tenant_id = #{tenantId} " +
            "AND status = 'ENABLED' " +
            "AND deleted_at IS NULL " +
            "ORDER BY created_at DESC")
    List<AlertRule> selectEnabledRules(@Param("tenantId") String tenantId);

    /**
     * 查询需要执行的告警规则
     *
     * @param currentTime 当前时间
     * @return 规则列表
     */
    @Select("SELECT * FROM alert_rules " +
            "WHERE status = 'ENABLED' " +
            "AND deleted_at IS NULL " +
            "AND (last_executed_at IS NULL OR " +
            "TIMESTAMPDIFF(MINUTE, last_executed_at, #{currentTime}) >= evaluation_interval)")
    List<AlertRule> selectRulesForExecution(@Param("currentTime") LocalDateTime currentTime);

    /**
     * 根据指标名称查询规则
     *
     * @param tenantId 租户ID
     * @param metricName 指标名称
     * @return 规则列表
     */
    @Select("SELECT * FROM alert_rules " +
            "WHERE tenant_id = #{tenantId} " +
            "AND metric_name = #{metricName} " +
            "AND status = 'ENABLED' " +
            "AND deleted_at IS NULL")
    List<AlertRule> selectByMetricName(
            @Param("tenantId") String tenantId,
            @Param("metricName") String metricName
    );

    /**
     * 更新规则最后执行时间
     *
     * @param id 规则ID
     * @param executedAt 执行时间
     * @return 影响行数
     */
    @Update("UPDATE alert_rules SET last_executed_at = #{executedAt} " +
            "WHERE id = #{id}")
    int updateLastExecutedAt(
            @Param("id") String id,
            @Param("executedAt") LocalDateTime executedAt
    );

    /**
     * 更新规则最后告警时间
     *
     * @param id 规则ID
     * @param alertedAt 告警时间
     * @return 影响行数
     */
    @Update("UPDATE alert_rules SET last_alerted_at = #{alertedAt} " +
            "WHERE id = #{id}")
    int updateLastAlertedAt(
            @Param("id") String id,
            @Param("alertedAt") LocalDateTime alertedAt
    );

    /**
     * 统计告警规则数量
     *
     * @param tenantId 租户ID
     * @param status 状态
     * @return 数量
     */
    @Select("<script>" +
            "SELECT COUNT(*) FROM alert_rules " +
            "WHERE tenant_id = #{tenantId} " +
            "<if test='status != null'>" +
            "AND status = #{status} " +
            "</if>" +
            "AND deleted_at IS NULL" +
            "</script>")
    Long countByTenantAndStatus(
            @Param("tenantId") String tenantId,
            @Param("status") AlertStatus status
    );

    /**
     * 查询租户规则名称是否存在
     *
     * @param tenantId 租户ID
     * @param ruleName 规则名称
     * @param excludeId 排除的ID
     * @return 是否存在
     */
    @Select("<script>" +
            "SELECT COUNT(*) FROM alert_rules " +
            "WHERE tenant_id = #{tenantId} " +
            "AND rule_name = #{ruleName} " +
            "<if test='excludeId != null and excludeId != \"\"'>" +
            "AND id != #{excludeId} " +
            "</if>" +
            "AND deleted_at IS NULL" +
            "</script>")
    Long countByRuleName(
            @Param("tenantId") String tenantId,
            @Param("ruleName") String ruleName,
            @Param("excludeId") String excludeId
    );
}