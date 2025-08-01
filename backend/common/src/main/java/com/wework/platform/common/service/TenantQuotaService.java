package com.wework.platform.common.service;

import com.wework.platform.common.entity.TenantQuota;
import com.wework.platform.common.entity.TenantUsage;
import com.wework.platform.common.dto.TenantQuotaCheckResult;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 租户配额服务接口
 * 
 * @author WeWork Platform Team
 */
public interface TenantQuotaService {

    /**
     * 获取租户配额
     */
    TenantQuota getTenantQuota(String tenantId);

    /**
     * 检查账号数量配额
     */
    TenantQuotaCheckResult checkAccountQuota(String tenantId, int requestCount);

    /**
     * 检查消息数量配额
     */
    TenantQuotaCheckResult checkMessageQuota(String tenantId, long requestCount);

    /**
     * 检查API调用配额
     */
    TenantQuotaCheckResult checkApiCallQuota(String tenantId, long requestCount);

    /**
     * 检查小时API调用配额
     */
    TenantQuotaCheckResult checkHourlyApiCallQuota(String tenantId, long requestCount);

    /**
     * 检查存储配额
     */
    TenantQuotaCheckResult checkStorageQuota(String tenantId, BigDecimal requestSize);

    /**
     * 检查带宽配额
     */
    TenantQuotaCheckResult checkBandwidthQuota(String tenantId, BigDecimal requestSize);

    /**
     * 检查监控规则配额
     */
    TenantQuotaCheckResult checkMonitorRuleQuota(String tenantId, int requestCount);

    /**
     * 检查功能权限
     */
    boolean hasFeaturePermission(String tenantId, String featureName);

    /**
     * 获取租户当前使用量
     */
    TenantUsage getCurrentUsage(String tenantId);

    /**
     * 获取租户指定日期的使用量
     */
    TenantUsage getUsageByDate(String tenantId, LocalDate date);

    /**
     * 更新租户配额
     */
    void updateTenantQuota(TenantQuota quota);

    /**
     * 记录资源使用
     */
    void recordAccountUsage(String tenantId, int accountCount);

    /**
     * 记录消息使用
     */
    void recordMessageUsage(String tenantId, long messageCount, long successCount, long failedCount);

    /**
     * 记录API使用
     */
    void recordApiUsage(String tenantId, long apiCallCount, long successCount, int avgResponseTime);

    /**
     * 记录存储使用
     */
    void recordStorageUsage(String tenantId, BigDecimal storageUsed);

    /**
     * 记录带宽使用
     */
    void recordBandwidthUsage(String tenantId, BigDecimal bandwidthUsed);

    /**
     * 记录告警
     */
    void recordAlertUsage(String tenantId, int alertCount, int criticalAlertCount);

    /**
     * 检查所有配额
     */
    TenantQuotaCheckResult checkAllQuotas(String tenantId);

    /**
     * 获取配额使用率警告
     */
    boolean isUsageWarning(String tenantId, double threshold);

    /**
     * 计算费用
     */
    BigDecimal calculateCost(String tenantId, LocalDate date);
}