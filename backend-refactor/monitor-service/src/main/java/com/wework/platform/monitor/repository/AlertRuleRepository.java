package com.wework.platform.monitor.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.common.enums.AlertLevel;
import com.wework.platform.common.enums.AlertStatus;
import com.wework.platform.monitor.entity.AlertRule;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

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
        List<AlertRule> selectEnabledRules(@Param("tenantId") String tenantId);

    /**
     * 查询需要执行的告警规则
     *
     * @param currentTime 当前时间
     * @return 规则列表
     */
        List<AlertRule> selectRulesForExecution(@Param("currentTime") LocalDateTime currentTime);

    /**
     * 根据指标名称查询规则
     *
     * @param tenantId 租户ID
     * @param metricName 指标名称
     * @return 规则列表
     */
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
        Long countByRuleName(
            @Param("tenantId") String tenantId,
            @Param("ruleName") String ruleName,
            @Param("excludeId") String excludeId
    );
}