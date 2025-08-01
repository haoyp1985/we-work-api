package com.wework.platform.common.dto;

import lombok.Data;
import lombok.Builder;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.List;

/**
 * 监控统计DTO
 * 
 * @author WeWork Platform Team
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MonitorStatistics {

    /**
     * 租户ID (为空表示系统级统计)
     */
    private String tenantId;

    /**
     * 统计时间
     */
    private LocalDateTime statisticsTime;

    /**
     * 统计周期(秒)
     */
    private Integer periodSeconds;

    // ========== 账号统计 ==========
    
    /**
     * 总账号数
     */
    private Integer totalAccounts;

    /**
     * 在线账号数
     */
    private Integer onlineAccounts;

    /**
     * 离线账号数
     */
    private Integer offlineAccounts;

    /**
     * 异常账号数
     */
    private Integer errorAccounts;

    /**
     * 恢复中账号数
     */
    private Integer recoveringAccounts;

    /**
     * 在线率(%)
     */
    private Double onlineRate;

    /**
     * 平均健康度评分
     */
    private Double avgHealthScore;

    /**
     * 健康账号数(健康度>=80)
     */
    private Integer healthyAccounts;

    /**
     * 需要关注账号数(健康度<60)
     */
    private Integer attentionNeededAccounts;

    /**
     * 危险账号数(健康度<40)
     */
    private Integer criticalAccounts;

    // ========== 告警统计 ==========
    
    /**
     * 活跃告警总数
     */
    private Integer activeAlerts;

    /**
     * 严重告警数
     */
    private Integer criticalAlerts;

    /**
     * 错误告警数
     */
    private Integer errorAlerts;

    /**
     * 警告告警数
     */
    private Integer warningAlerts;

    /**
     * 信息告警数
     */
    private Integer infoAlerts;

    /**
     * 新增告警数(本周期)
     */
    private Integer newAlerts;

    /**
     * 已解决告警数(本周期)
     */
    private Integer resolvedAlerts;

    /**
     * 告警解决率(%)
     */
    private Double alertResolutionRate;

    /**
     * 平均告警解决时间(分钟)
     */
    private Double avgResolutionTime;

    // ========== 性能统计 ==========
    
    /**
     * 平均API响应时间(毫秒)
     */
    private Double avgApiResponseTime;

    /**
     * API成功率(%)
     */
    private Double apiSuccessRate;

    /**
     * 总API调用次数
     */
    private Long totalApiCalls;

    /**
     * 成功API调用次数
     */
    private Long successfulApiCalls;

    /**
     * 失败API调用次数
     */
    private Long failedApiCalls;

    /**
     * 心跳正常率(%)
     */
    private Double heartbeatNormalRate;

    /**
     * 平均心跳间隔(秒)
     */
    private Double avgHeartbeatInterval;

    // ========== 恢复统计 ==========
    
    /**
     * 自动恢复次数
     */
    private Integer autoRecoveryAttempts;

    /**
     * 自动恢复成功次数
     */
    private Integer autoRecoverySuccesses;

    /**
     * 自动恢复成功率(%)
     */
    private Double autoRecoverySuccessRate;

    /**
     * 平均恢复时间(分钟)
     */
    private Double avgRecoveryTime;

    /**
     * 手动干预次数
     */
    private Integer manualInterventions;

    // ========== 资源统计 ==========
    
    /**
     * 系统CPU使用率(%)
     */
    private Double systemCpuUsage;

    /**
     * 系统内存使用率(%)
     */
    private Double systemMemoryUsage;

    /**
     * 数据库连接数
     */
    private Integer databaseConnections;

    /**
     * Redis连接数
     */
    private Integer redisConnections;

    /**
     * 消息队列积压数
     */
    private Integer messageQueueBacklog;

    // ========== 趋势数据 ==========
    
    /**
     * 健康度趋势(最近24小时)
     */
    private List<TrendPoint> healthScoreTrend;

    /**
     * 在线率趋势(最近24小时)
     */
    private List<TrendPoint> onlineRateTrend;

    /**
     * 告警数量趋势(最近24小时)
     */
    private List<TrendPoint> alertCountTrend;

    /**
     * API响应时间趋势(最近24小时)
     */
    private List<TrendPoint> apiResponseTimeTrend;

    // ========== 详细分布 ==========
    
    /**
     * 状态分布
     */
    private Map<String, Integer> statusDistribution;

    /**
     * 健康度分布
     */
    private Map<String, Integer> healthScoreDistribution;

    /**
     * 告警类型分布
     */
    private Map<String, Integer> alertTypeDistribution;

    /**
     * 租户分布(系统级统计时使用)
     */
    private Map<String, Integer> tenantDistribution;

    // ========== 异常统计 ==========
    
    /**
     * 异常类型统计
     */
    private Map<String, Integer> errorTypeStatistics;

    /**
     * 故障频率最高的账号(Top 10)
     */
    private List<AccountFaultInfo> topFaultyAccounts;

    /**
     * 恢复最频繁的账号(Top 10)
     */
    private List<AccountRecoveryInfo> topRecoveredAccounts;

    /**
     * 趋势点数据
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TrendPoint {
        private LocalDateTime timestamp;
        private Double value;
        private String label;
    }

    /**
     * 账号故障信息
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class AccountFaultInfo {
        private String accountId;
        private String accountName;
        private Integer faultCount;
        private String lastFaultTime;
        private String faultType;
    }

    /**
     * 账号恢复信息
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class AccountRecoveryInfo {
        private String accountId;
        private String accountName;
        private Integer recoveryCount;
        private String lastRecoveryTime;
        private Double avgRecoveryTime;
    }

    /**
     * 获取整体健康度等级
     */
    public String getOverallHealthLevel() {
        if (avgHealthScore == null) return "UNKNOWN";
        
        if (avgHealthScore >= 90) return "EXCELLENT";
        if (avgHealthScore >= 80) return "GOOD";
        if (avgHealthScore >= 60) return "FAIR";
        if (avgHealthScore >= 40) return "POOR";
        return "CRITICAL";
    }

    /**
     * 是否需要紧急关注
     */
    public boolean needsUrgentAttention() {
        return (criticalAccounts != null && criticalAccounts > 0) ||
               (criticalAlerts != null && criticalAlerts > 0) ||
               (avgHealthScore != null && avgHealthScore < 40);
    }

    /**
     * 获取系统稳定性评分
     */
    public int getSystemStabilityScore() {
        if (onlineRate == null || apiSuccessRate == null || avgHealthScore == null) return 0;
        
        double stabilityScore = (onlineRate + apiSuccessRate + avgHealthScore) / 3;
        return (int) Math.round(stabilityScore);
    }

    /**
     * 获取服务质量等级
     */
    public String getServiceQualityLevel() {
        int stabilityScore = getSystemStabilityScore();
        
        if (stabilityScore >= 95) return "PREMIUM";
        if (stabilityScore >= 90) return "EXCELLENT";
        if (stabilityScore >= 80) return "GOOD";
        if (stabilityScore >= 70) return "ACCEPTABLE";
        return "POOR";
    }

    /**
     * 添加趋势点
     */
    public void addHealthScoreTrendPoint(LocalDateTime timestamp, Double value) {
        if (healthScoreTrend == null) {
            healthScoreTrend = new java.util.ArrayList<>();
        }
        healthScoreTrend.add(TrendPoint.builder().timestamp(timestamp).value(value).build());
    }

    /**
     * 添加状态分布
     */
    public void addStatusDistribution(String status, Integer count) {
        if (statusDistribution == null) {
            statusDistribution = new java.util.HashMap<>();
        }
        statusDistribution.put(status, count);
    }

    /**
     * 计算可用性
     */
    public double getAvailability() {
        if (totalAccounts == null || totalAccounts == 0) return 0.0;
        if (onlineAccounts == null) return 0.0;
        return (double) onlineAccounts / totalAccounts * 100;
    }
}