package com.wework.platform.monitor.service;

import com.wework.platform.common.dto.PageResult;
import com.wework.platform.common.dto.Result;
import com.wework.platform.common.enums.AlertLevel;
import com.wework.platform.common.enums.AlertStatus;
import com.wework.platform.monitor.dto.AlertDTO;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 告警服务接口
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
public interface AlertService {

    /**
     * 获取告警详情
     *
     * @param tenantId 租户ID
     * @param alertId 告警ID
     * @return 告警信息
     */
    Result<AlertDTO> getAlertById(String tenantId, String alertId);

    /**
     * 分页查询告警记录
     *
     * @param tenantId 租户ID
     * @param ruleId 规则ID
     * @param alertLevel 告警级别
     * @param status 状态
     * @param serviceName 服务名称
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @param pageNum 页码
     * @param pageSize 页大小
     * @return 分页结果
     */
    Result<PageResult<AlertDTO>> getAlerts(String tenantId, String ruleId, AlertLevel alertLevel,
                                          AlertStatus status, String serviceName,
                                          LocalDateTime startTime, LocalDateTime endTime,
                                          Integer pageNum, Integer pageSize);

    /**
     * 获取活跃告警
     *
     * @param tenantId 租户ID
     * @return 告警列表
     */
    Result<List<AlertDTO>> getActiveAlerts(String tenantId);

    /**
     * 获取未确认告警
     *
     * @param tenantId 租户ID
     * @return 告警列表
     */
    Result<List<AlertDTO>> getUnacknowledgedAlerts(String tenantId);

    /**
     * 确认告警
     *
     * @param tenantId 租户ID
     * @param alertId 告警ID
     * @param acknowledgedBy 确认人
     * @return 操作结果
     */
    Result<Void> acknowledgeAlert(String tenantId, String alertId, String acknowledgedBy);

    /**
     * 批量确认告警
     *
     * @param tenantId 租户ID
     * @param alertIds 告警ID列表
     * @param acknowledgedBy 确认人
     * @return 操作结果
     */
    Result<Void> batchAcknowledgeAlerts(String tenantId, List<String> alertIds, String acknowledgedBy);

    /**
     * 解决告警
     *
     * @param tenantId 租户ID
     * @param alertId 告警ID
     * @return 操作结果
     */
    Result<Void> resolveAlert(String tenantId, String alertId);

    /**
     * 抑制告警
     *
     * @param tenantId 租户ID
     * @param alertId 告警ID
     * @return 操作结果
     */
    Result<Void> suppressAlert(String tenantId, String alertId);

    /**
     * 删除告警记录
     *
     * @param tenantId 租户ID
     * @param alertId 告警ID
     * @return 操作结果
     */
    Result<Void> deleteAlert(String tenantId, String alertId);

    /**
     * 批量删除告警记录
     *
     * @param tenantId 租户ID
     * @param alertIds 告警ID列表
     * @return 操作结果
     */
    Result<Void> batchDeleteAlerts(String tenantId, List<String> alertIds);

    /**
     * 清理过期告警记录
     *
     * @param retentionDays 保留天数
     * @return 清理数量
     */
    Result<Integer> cleanupExpiredAlerts(Integer retentionDays);

    /**
     * 获取告警统计信息
     *
     * @param tenantId 租户ID
     * @param status 状态
     * @param alertLevel 告警级别
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 统计信息
     */
    Result<Long> getAlertCount(String tenantId, AlertStatus status, AlertLevel alertLevel,
                              LocalDateTime startTime, LocalDateTime endTime);

    /**
     * 发送告警通知
     *
     * @param alertId 告警ID
     * @return 操作结果
     */
    Result<Void> sendNotification(String alertId);

    /**
     * 重新发送告警通知
     *
     * @param tenantId 租户ID
     * @param alertId 告警ID
     * @return 操作结果
     */
    Result<Void> resendNotification(String tenantId, String alertId);
}