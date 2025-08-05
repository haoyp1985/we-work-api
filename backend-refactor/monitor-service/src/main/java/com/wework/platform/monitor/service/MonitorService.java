package com.wework.platform.monitor.service;

import com.wework.platform.common.dto.Result;
import com.wework.platform.monitor.dto.MonitorStatisticsDTO;

/**
 * 监控服务接口
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
public interface MonitorService {

    /**
     * 获取监控统计信息
     *
     * @param tenantId 租户ID
     * @return 统计信息
     */
    Result<MonitorStatisticsDTO> getMonitorStatistics(String tenantId);

    /**
     * 执行告警规则评估
     *
     * @return 执行结果
     */
    Result<Integer> evaluateAlertRules();

    /**
     * 系统健康检查
     *
     * @return 健康状态
     */
    Result<Boolean> healthCheck();

    /**
     * 清理过期数据
     *
     * @param metricRetentionDays 指标保留天数
     * @param alertRetentionDays 告警保留天数
     * @return 清理结果
     */
    Result<String> cleanupExpiredData(Integer metricRetentionDays, Integer alertRetentionDays);

    /**
     * 刷新监控配置
     *
     * @return 操作结果
     */
    Result<Void> refreshConfiguration();

    /**
     * 获取系统状态信息
     *
     * @return 系统状态
     */
    Result<String> getSystemStatus();
}