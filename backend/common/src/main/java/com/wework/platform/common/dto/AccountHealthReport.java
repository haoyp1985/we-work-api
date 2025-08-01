package com.wework.platform.common.dto;

import com.wework.platform.common.enums.AccountStatus;
import lombok.Data;
import lombok.Builder;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.List;

/**
 * 账号健康报告DTO
 * 
 * @author WeWork Platform Team
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AccountHealthReport {

    /**
     * 账号ID
     */
    private String accountId;

    /**
     * 租户ID
     */
    private String tenantId;

    /**
     * 账号名称
     */
    private String accountName;

    /**
     * 当前状态
     */
    private AccountStatus status;

    /**
     * 健康度评分 (0-100)
     */
    private Integer healthScore;

    /**
     * 上次健康度评分
     */
    private Integer previousHealthScore;

    /**
     * 健康度变化趋势
     */
    private String healthTrend;

    /**
     * 最后心跳时间
     */
    private LocalDateTime lastHeartbeatTime;

    /**
     * 心跳间隔(秒)
     */
    private Long heartbeatInterval;

    /**
     * 是否心跳正常
     */
    private Boolean heartbeatNormal;

    /**
     * API响应时间(毫秒)
     */
    private Long apiResponseTime;

    /**
     * API成功率(%)
     */
    private Double apiSuccessRate;

    /**
     * 重试次数
     */
    private Integer retryCount;

    /**
     * 最大重试次数
     */
    private Integer maxRetryCount;

    /**
     * 在线时长(分钟)
     */
    private Long onlineDuration;

    /**
     * 离线时长(分钟)
     */
    private Long offlineDuration;

    /**
     * 错误次数
     */
    private Integer errorCount;

    /**
     * 恢复次数
     */
    private Integer recoveryCount;

    /**
     * 告警级别
     */
    private String alertLevel;

    /**
     * 活跃告警数量
     */
    private Integer activeAlertCount;

    /**
     * 性能指标
     */
    private Map<String, Object> performanceMetrics;

    /**
     * 健康检查详情
     */
    private List<HealthCheckItem> healthCheckItems;

    /**
     * 建议操作
     */
    private List<String> recommendedActions;

    /**
     * 风险评估
     */
    private String riskAssessment;

    /**
     * 检查时间
     */
    private LocalDateTime checkTime;

    /**
     * 数据有效期(秒)
     */
    private Integer dataValidSeconds;

    /**
     * 健康检查项
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class HealthCheckItem {
        private String checkName;
        private String checkType;
        private Boolean passed;
        private String result;
        private String message;
        private Object value;
        private Object threshold;
        private String severity;
    }

    /**
     * 获取健康度等级
     */
    public String getHealthLevel() {
        if (healthScore == null) return "UNKNOWN";
        
        if (healthScore >= 90) return "EXCELLENT";
        if (healthScore >= 80) return "GOOD";
        if (healthScore >= 60) return "FAIR";
        if (healthScore >= 40) return "POOR";
        return "CRITICAL";
    }

    /**
     * 获取健康度颜色
     */
    public String getHealthColor() {
        if (healthScore == null) return "gray";
        
        if (healthScore >= 90) return "green";
        if (healthScore >= 80) return "blue";
        if (healthScore >= 60) return "orange";
        if (healthScore >= 40) return "yellow";
        return "red";
    }

    /**
     * 是否需要关注
     */
    public boolean needsAttention() {
        return healthScore != null && healthScore < 60;
    }

    /**
     * 是否处于危险状态
     */
    public boolean isCritical() {
        return healthScore != null && healthScore < 40;
    }

    /**
     * 获取健康度变化
     */
    public int getHealthScoreChange() {
        if (healthScore == null || previousHealthScore == null) return 0;
        return healthScore - previousHealthScore;
    }

    /**
     * 是否健康度在改善
     */
    public boolean isImproving() {
        return getHealthScoreChange() > 0;
    }

    /**
     * 是否健康度在下降
     */
    public boolean isDeclining() {
        return getHealthScoreChange() < 0;
    }

    /**
     * 获取状态描述
     */
    public String getStatusDescription() {
        if (status == null) return "未知状态";
        
        String baseDescription = status.getDescription();
        if (healthScore != null) {
            baseDescription += String.format(" (健康度: %d)", healthScore);
        }
        
        return baseDescription;
    }

    /**
     * 获取风险级别
     */
    public String getRiskLevel() {
        if (isCritical()) return "HIGH";
        if (needsAttention()) return "MEDIUM";
        return "LOW";
    }

    /**
     * 添加健康检查项
     */
    public void addHealthCheckItem(String name, String type, Boolean passed, String result, String message) {
        if (healthCheckItems == null) {
            healthCheckItems = new java.util.ArrayList<>();
        }
        
        healthCheckItems.add(HealthCheckItem.builder()
                .checkName(name)
                .checkType(type)
                .passed(passed)
                .result(result)
                .message(message)
                .build());
    }

    /**
     * 添加建议操作
     */
    public void addRecommendedAction(String action) {
        if (recommendedActions == null) {
            recommendedActions = new java.util.ArrayList<>();
        }
        recommendedActions.add(action);
    }

    /**
     * 设置性能指标
     */
    public void addPerformanceMetric(String key, Object value) {
        if (performanceMetrics == null) {
            performanceMetrics = new java.util.HashMap<>();
        }
        performanceMetrics.put(key, value);
    }
}