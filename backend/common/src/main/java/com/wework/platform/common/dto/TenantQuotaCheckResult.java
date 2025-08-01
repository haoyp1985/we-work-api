package com.wework.platform.common.dto;

import lombok.Data;
import lombok.Builder;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;
import java.util.ArrayList;

/**
 * 租户配额检查结果DTO
 * 
 * @author WeWork Platform Team
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TenantQuotaCheckResult {

    /**
     * 是否通过检查
     */
    private boolean passed;

    /**
     * 检查类型
     */
    private String quotaType;

    /**
     * 当前使用量
     */
    private Long currentUsage;

    /**
     * 配额限制
     */
    private Long quotaLimit;

    /**
     * 请求数量
     */
    private Long requestCount;

    /**
     * 使用率
     */
    private Double usageRate;

    /**
     * 检查消息
     */
    private String message;

    /**
     * 错误代码
     */
    private String errorCode;

    /**
     * 详细信息
     */
    private Object details;

    /**
     * 建议操作
     */
    private List<String> suggestions;

    /**
     * 是否为警告级别
     */
    private boolean warning;

    /**
     * 警告阈值
     */
    private Double warningThreshold;

    /**
     * 剩余可用量
     */
    private Long remainingQuota;

    /**
     * 超出量
     */
    private Long excessAmount;

    /**
     * 创建成功结果
     */
    public static TenantQuotaCheckResult success(String quotaType, Long currentUsage, Long quotaLimit) {
        return TenantQuotaCheckResult.builder()
                .passed(true)
                .quotaType(quotaType)
                .currentUsage(currentUsage)
                .quotaLimit(quotaLimit)
                .usageRate(calculateUsageRate(currentUsage, quotaLimit))
                .remainingQuota(quotaLimit - currentUsage)
                .message("配额检查通过")
                .suggestions(new ArrayList<>())
                .build();
    }

    /**
     * 创建失败结果
     */
    public static TenantQuotaCheckResult failure(String quotaType, Long currentUsage, Long quotaLimit, 
                                               Long requestCount, String errorCode, String message) {
        return TenantQuotaCheckResult.builder()
                .passed(false)
                .quotaType(quotaType)
                .currentUsage(currentUsage)
                .quotaLimit(quotaLimit)
                .requestCount(requestCount)
                .usageRate(calculateUsageRate(currentUsage, quotaLimit))
                .excessAmount(currentUsage + requestCount - quotaLimit)
                .errorCode(errorCode)
                .message(message)
                .suggestions(generateSuggestions(quotaType))
                .build();
    }

    /**
     * 创建警告结果
     */
    public static TenantQuotaCheckResult warning(String quotaType, Long currentUsage, Long quotaLimit,
                                               Double warningThreshold, String message) {
        return TenantQuotaCheckResult.builder()
                .passed(true)
                .warning(true)
                .quotaType(quotaType)
                .currentUsage(currentUsage)
                .quotaLimit(quotaLimit)
                .usageRate(calculateUsageRate(currentUsage, quotaLimit))
                .warningThreshold(warningThreshold)
                .remainingQuota(quotaLimit - currentUsage)
                .message(message)
                .suggestions(generateWarningSuggestions(quotaType))
                .build();
    }

    /**
     * 创建无限制结果
     */
    public static TenantQuotaCheckResult unlimited(String quotaType) {
        return TenantQuotaCheckResult.builder()
                .passed(true)
                .quotaType(quotaType)
                .currentUsage(0L)
                .quotaLimit(Long.MAX_VALUE)
                .usageRate(0.0)
                .message("无配额限制")
                .suggestions(new ArrayList<>())
                .build();
    }

    /**
     * 计算使用率
     */
    private static Double calculateUsageRate(Long currentUsage, Long quotaLimit) {
        if (quotaLimit == null || quotaLimit == 0 || currentUsage == null) {
            return 0.0;
        }
        return (double) currentUsage / quotaLimit * 100;
    }

    /**
     * 生成建议
     */
    private static List<String> generateSuggestions(String quotaType) {
        List<String> suggestions = new ArrayList<>();
        switch (quotaType) {
            case "ACCOUNT":
                suggestions.add("升级套餐以获得更多账号配额");
                suggestions.add("删除不活跃的账号");
                suggestions.add("联系客服咨询企业套餐");
                break;
            case "MESSAGE":
                suggestions.add("升级套餐以获得更多消息配额");
                suggestions.add("优化消息发送策略");
                suggestions.add("使用批量发送减少API调用");
                break;
            case "API_CALL":
                suggestions.add("优化API调用频率");
                suggestions.add("使用缓存减少重复调用");
                suggestions.add("升级套餐以获得更多API配额");
                break;
            case "STORAGE":
                suggestions.add("清理不必要的文件");
                suggestions.add("压缩存储文件");
                suggestions.add("升级存储套餐");
                break;
            default:
                suggestions.add("联系客服了解更多详情");
                break;
        }
        return suggestions;
    }

    /**
     * 生成警告建议
     */
    private static List<String> generateWarningSuggestions(String quotaType) {
        List<String> suggestions = new ArrayList<>();
        suggestions.add("当前使用率较高，建议关注配额使用情况");
        suggestions.add("考虑提前升级套餐以避免服务中断");
        return suggestions;
    }

    /**
     * 添加建议
     */
    public void addSuggestion(String suggestion) {
        if (this.suggestions == null) {
            this.suggestions = new ArrayList<>();
        }
        this.suggestions.add(suggestion);
    }

    /**
     * 设置详细信息
     */
    public void setDetails(String key, Object value) {
        if (this.details == null) {
            this.details = new java.util.HashMap<>();
        }
        ((java.util.Map<String, Object>) this.details).put(key, value);
    }

    /**
     * 检查是否接近配额限制
     */
    public boolean isNearLimit(double threshold) {
        return usageRate != null && usageRate >= threshold;
    }

    /**
     * 获取配额状态描述
     */
    public String getStatusDescription() {
        if (!passed) {
            return "配额已超限";
        } else if (warning) {
            return "配额使用率较高";
        } else if (isNearLimit(80.0)) {
            return "接近配额限制";
        } else {
            return "配额使用正常";
        }
    }

    /**
     * 获取状态颜色
     */
    public String getStatusColor() {
        if (!passed) {
            return "error";
        } else if (warning || isNearLimit(80.0)) {
            return "warning";
        } else {
            return "success";
        }
    }
}