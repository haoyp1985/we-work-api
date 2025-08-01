package com.wework.platform.account.service;

import com.wework.platform.common.entity.AccountAlert;
import com.wework.platform.common.enums.AlertLevel;
import com.wework.platform.common.enums.AlertStatus;
import com.wework.platform.common.enums.AlertType;

import java.util.List;
import java.util.Map;

/**
 * 告警管理器接口
 * 
 * @author WeWork Platform Team
 */
public interface AlertManager {

    /**
     * 创建告警
     */
    AccountAlert createAlert(AccountAlert alert);

    /**
     * 创建告警 - 简化方法
     */
    AccountAlert createAlert(String tenantId, String accountId, AlertType alertType, 
                           AlertLevel alertLevel, String message, Object alertData);

    /**
     * 更新告警状态
     */
    void updateAlertStatus(String alertId, AlertStatus status, String userId, String resolution);

    /**
     * 确认告警
     */
    void acknowledgeAlert(String alertId, String userId);

    /**
     * 解决告警
     */
    void resolveAlert(String alertId, String userId, String resolution);

    /**
     * 抑制告警
     */
    void suppressAlert(String alertId, String userId, int suppressMinutes);

    /**
     * 批量处理告警
     */
    void batchProcessAlerts(List<String> alertIds, AlertStatus status, String userId, String reason);

    /**
     * 获取活跃告警
     */
    List<AccountAlert> getActiveAlerts(String tenantId);

    /**
     * 获取账号的活跃告警
     */
    List<AccountAlert> getAccountActiveAlerts(String tenantId, String accountId);

    /**
     * 获取告警统计
     */
    Map<String, Integer> getAlertStatistics(String tenantId);

    /**
     * 检查重复告警
     */
    boolean isDuplicateAlert(String tenantId, String accountId, AlertType alertType);

    /**
     * 告警聚合
     */
    List<AlertAggregation> aggregateAlerts(String tenantId, String groupBy, int timeWindowMinutes);

    /**
     * 告警升级
     */
    void escalateAlert(String alertId);

    /**
     * 自动解决过期告警
     */
    int autoResolveExpiredAlerts();

    /**
     * 发送告警通知
     */
    void sendAlertNotification(AccountAlert alert);

    /**
     * 获取告警趋势
     */
    List<AlertTrendPoint> getAlertTrend(String tenantId, int days);

    /**
     * 告警聚合结果
     */
    interface AlertAggregation {
        String getGroupKey();
        int getCount();
        AlertLevel getMaxLevel();
        String getFirstAlertTime();
        String getLastAlertTime();
        List<String> getAlertIds();
    }

    /**
     * 告警趋势点
     */
    interface AlertTrendPoint {
        String getTimestamp();
        int getCount();
        Map<String, Integer> getLevelDistribution();
    }
}