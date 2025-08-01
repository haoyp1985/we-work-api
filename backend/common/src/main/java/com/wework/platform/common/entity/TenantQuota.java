package com.wework.platform.common.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 租户配额实体
 * 
 * @author WeWork Platform Team
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("tenant_quotas")
public class TenantQuota extends BaseEntity {

    /**
     * 租户ID
     */
    private String tenantId;

    /**
     * 最大账号数
     */
    private Integer maxAccounts;

    /**
     * 最大同时在线账号数
     */
    private Integer maxOnlineAccounts;

    /**
     * 日最大消息数
     */
    private Long maxDailyMessages;

    /**
     * 月最大消息数
     */
    private Long maxMonthlyMessages;

    /**
     * 日最大API调用次数
     */
    private Long maxDailyApiCalls;

    /**
     * 小时最大API调用次数
     */
    private Long maxHourlyApiCalls;

    /**
     * 最大存储空间(GB)
     */
    private BigDecimal maxStorageGb;

    /**
     * 月最大带宽(GB)
     */
    private BigDecimal maxBandwidthGb;

    /**
     * 最大监控规则数
     */
    private Integer maxMonitorRules;

    /**
     * 每日最大告警数
     */
    private Integer maxAlertsPerDay;

    /**
     * 是否启用自动恢复
     */
    private Boolean enableAutoRecovery;

    /**
     * 是否启用自定义回调
     */
    private Boolean enableCustomCallback;

    /**
     * 是否启用高级监控
     */
    private Boolean enableAdvancedMonitoring;

    /**
     * 是否启用API访问
     */
    private Boolean enableApiAccess;

    /**
     * 生效开始日期
     */
    private LocalDate effectiveFrom;

    /**
     * 生效结束日期
     */
    private LocalDate effectiveTo;

    /**
     * 检查配额是否有效
     */
    public boolean isEffective() {
        LocalDate now = LocalDate.now();
        return (effectiveFrom == null || !now.isBefore(effectiveFrom)) &&
               (effectiveTo == null || !now.isAfter(effectiveTo));
    }

    /**
     * 检查账号数量是否超限
     */
    public boolean isAccountCountExceeded(int currentCount) {
        return maxAccounts != null && currentCount > maxAccounts;
    }

    /**
     * 检查在线账号数量是否超限
     */
    public boolean isOnlineAccountCountExceeded(int currentCount) {
        return maxOnlineAccounts != null && currentCount > maxOnlineAccounts;
    }

    /**
     * 检查消息数量是否超限
     */
    public boolean isDailyMessageCountExceeded(long currentCount) {
        return maxDailyMessages != null && currentCount > maxDailyMessages;
    }

    /**
     * 检查API调用是否超限
     */
    public boolean isDailyApiCallCountExceeded(long currentCount) {
        return maxDailyApiCalls != null && currentCount > maxDailyApiCalls;
    }

    /**
     * 检查小时API调用是否超限
     */
    public boolean isHourlyApiCallCountExceeded(long currentCount) {
        return maxHourlyApiCalls != null && currentCount > maxHourlyApiCalls;
    }

    /**
     * 检查存储空间是否超限
     */
    public boolean isStorageExceeded(BigDecimal currentUsage) {
        return maxStorageGb != null && currentUsage != null && 
               currentUsage.compareTo(maxStorageGb) > 0;
    }

    /**
     * 检查带宽是否超限
     */
    public boolean isBandwidthExceeded(BigDecimal currentUsage) {
        return maxBandwidthGb != null && currentUsage != null && 
               currentUsage.compareTo(maxBandwidthGb) > 0;
    }

    /**
     * 检查监控规则数量是否超限
     */
    public boolean isMonitorRuleCountExceeded(int currentCount) {
        return maxMonitorRules != null && currentCount > maxMonitorRules;
    }

    /**
     * 获取账号使用率
     */
    public double getAccountUsageRate(int currentCount) {
        if (maxAccounts == null || maxAccounts == 0) return 0.0;
        return (double) currentCount / maxAccounts * 100;
    }

    /**
     * 获取消息使用率
     */
    public double getDailyMessageUsageRate(long currentCount) {
        if (maxDailyMessages == null || maxDailyMessages == 0) return 0.0;
        return (double) currentCount / maxDailyMessages * 100;
    }

    /**
     * 获取存储使用率
     */
    public double getStorageUsageRate(BigDecimal currentUsage) {
        if (maxStorageGb == null || maxStorageGb.equals(BigDecimal.ZERO) || currentUsage == null) {
            return 0.0;
        }
        return currentUsage.divide(maxStorageGb, 4, BigDecimal.ROUND_HALF_UP)
                .multiply(BigDecimal.valueOf(100)).doubleValue();
    }

    /**
     * 检查是否即将到期
     */
    public boolean isExpiringWithin(int days) {
        if (effectiveTo == null) return false;
        return effectiveTo.isBefore(LocalDate.now().plusDays(days));
    }

    /**
     * 获取剩余有效天数
     */
    public long getRemainingDays() {
        if (effectiveTo == null) return Long.MAX_VALUE;
        return java.time.temporal.ChronoUnit.DAYS.between(LocalDate.now(), effectiveTo);
    }
}