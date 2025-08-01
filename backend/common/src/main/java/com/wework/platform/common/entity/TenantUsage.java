package com.wework.platform.common.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 租户使用统计实体
 * 
 * @author WeWork Platform Team
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("tenant_usage")
public class TenantUsage extends BaseEntity {

    /**
     * 租户ID
     */
    private String tenantId;

    /**
     * 统计日期
     */
    private LocalDate usageDate;

    /**
     * 账号数量
     */
    private Integer accountCount;

    /**
     * 在线账号数量
     */
    private Integer onlineAccountCount;

    /**
     * 消息发送数量
     */
    private Long messageCount;

    /**
     * 消息发送成功数量
     */
    private Long messageSuccessCount;

    /**
     * 消息发送失败数量
     */
    private Long messageFailedCount;

    /**
     * API调用次数
     */
    private Long apiCallCount;

    /**
     * API调用成功次数
     */
    private Long apiSuccessCount;

    /**
     * 告警数量
     */
    private Integer alertCount;

    /**
     * 严重告警数量
     */
    private Integer criticalAlertCount;

    /**
     * 存储使用量(MB)
     */
    private BigDecimal storageUsed;

    /**
     * 带宽使用量(MB)
     */
    private BigDecimal bandwidthUsed;

    /**
     * 费用金额
     */
    private BigDecimal cost;

    /**
     * 是否已计费
     */
    private Boolean billed;

    /**
     * 峰值在线账号数
     */
    private Integer peakOnlineAccounts;

    /**
     * 平均响应时间(毫秒)
     */
    private Integer avgResponseTime;

    /**
     * 异常恢复次数
     */
    private Integer recoveryCount;

    /**
     * 获取消息成功率
     */
    public double getMessageSuccessRate() {
        if (messageCount == null || messageCount == 0) return 0.0;
        return (messageSuccessCount != null ? messageSuccessCount : 0) * 100.0 / messageCount;
    }

    /**
     * 获取API成功率
     */
    public double getApiSuccessRate() {
        if (apiCallCount == null || apiCallCount == 0) return 0.0;
        return (apiSuccessCount != null ? apiSuccessCount : 0) * 100.0 / apiCallCount;
    }

    /**
     * 获取账号在线率
     */
    public double getAccountOnlineRate() {
        if (accountCount == null || accountCount == 0) return 0.0;
        return (onlineAccountCount != null ? onlineAccountCount : 0) * 100.0 / accountCount;
    }

    /**
     * 检查是否超出配额
     */
    public boolean isOverQuota(Integer maxAccounts, Long maxMessages) {
        boolean overAccountQuota = maxAccounts != null && accountCount != null && accountCount > maxAccounts;
        boolean overMessageQuota = maxMessages != null && messageCount != null && messageCount > maxMessages;
        return overAccountQuota || overMessageQuota;
    }

    /**
     * 获取使用率描述
     */
    public String getUsageDescription() {
        return String.format("账号: %d, 消息: %d, 成功率: %.1f%%", 
            accountCount != null ? accountCount : 0,
            messageCount != null ? messageCount : 0,
            getMessageSuccessRate());
    }
}