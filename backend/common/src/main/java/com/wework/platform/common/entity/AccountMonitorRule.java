package com.wework.platform.common.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.TableField;
import com.wework.platform.common.enums.AlertLevel;
import com.wework.platform.common.enums.AlertType;
import com.wework.platform.common.enums.MonitorRuleType;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 账号监控规则实体
 * 
 * @author WeWork Platform Team
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("account_monitor_rules")
public class AccountMonitorRule extends BaseEntity {

    /**
     * 租户ID
     */
    private String tenantId;

    /**
     * 规则名称
     */
    private String ruleName;

    /**
     * 规则描述
     */
    private String ruleDescription;

    /**
     * 规则表达式 (JavaScript表达式)
     */
    private String ruleExpression;

    /**
     * 告警消息模板
     */
    private String alertMessage;

    /**
     * 规则优先级 (数值越大优先级越高)
     */
    private Integer priority;

    /**
     * 描述信息
     */
    private String description;

    /**
     * 告警类型
     */
    private AlertType alertType;

    /**
     * 监控规则类型
     */
    private MonitorRuleType ruleType;

    /**
     * 阈值
     */
    private BigDecimal thresholdValue;

    /**
     * 比较操作符 (>, <, >=, <=, ==, !=)
     */
    private String operator;

    /**
     * 检查间隔(秒)
     */
    private Integer checkInterval;

    /**
     * 持续时间(秒) - 超过阈值需要持续多久才触发告警
     */
    private Integer duration;

    /**
     * 告警级别
     */
    private AlertLevel alertLevel;

    /**
     * 是否启用
     */
    private Boolean enabled;

    /**
     * 是否启用自动恢复
     */
    private Boolean enableAutoRecovery;

    /**
     * 最大自动恢复次数
     */
    private Integer maxAutoRecoveryAttempts;

    /**
     * 静默期(秒) - 告警后的静默时间
     */
    private Integer silentPeriod;

    /**
     * 适用账号标签 (为空表示适用所有账号)
     */
    private String applicableAccountTags;

    /**
     * 规则配置(JSON格式)
     */
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private Object ruleConfig;

    /**
     * 通知渠道配置(JSON格式)
     */
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private Object notificationConfig;

    /**
     * 执行次数
     */
    private Long executionCount;

    /**
     * 触发次数
     */
    private Long triggerCount;

    /**
     * 最后执行时间
     */
    private java.time.LocalDateTime lastExecutedAt;

    /**
     * 最后触发时间
     */
    private java.time.LocalDateTime lastTriggeredAt;

    /**
     * 检查值是否超过阈值
     */
    public boolean checkThreshold(BigDecimal value) {
        if (value == null || thresholdValue == null || operator == null) {
            return false;
        }

        switch (operator) {
            case ">":
                return value.compareTo(thresholdValue) > 0;
            case ">=":
                return value.compareTo(thresholdValue) >= 0;
            case "<":
                return value.compareTo(thresholdValue) < 0;
            case "<=":
                return value.compareTo(thresholdValue) <= 0;
            case "==":
                return value.compareTo(thresholdValue) == 0;
            case "!=":
                return value.compareTo(thresholdValue) != 0;
            default:
                return false;
        }
    }

    /**
     * 检查账号标签是否匹配
     */
    public boolean matchesAccountTag(String accountTag) {
        if (applicableAccountTags == null || applicableAccountTags.trim().isEmpty()) {
            return true; // 空标签表示适用所有账号
        }
        if (accountTag == null) {
            return false;
        }
        return applicableAccountTags.contains(accountTag);
    }

    /**
     * 获取触发率
     */
    public double getTriggerRate() {
        if (executionCount == null || executionCount == 0) return 0.0;
        return (triggerCount != null ? triggerCount : 0) * 100.0 / executionCount;
    }

    /**
     * 增加执行计数
     */
    public void incrementExecutionCount() {
        this.executionCount = (this.executionCount == null ? 0 : this.executionCount) + 1;
        this.lastExecutedAt = java.time.LocalDateTime.now();
    }

    /**
     * 增加触发计数
     */
    public void incrementTriggerCount() {
        this.triggerCount = (this.triggerCount == null ? 0 : this.triggerCount) + 1;
        this.lastTriggeredAt = java.time.LocalDateTime.now();
    }

    /**
     * 获取规则描述
     */
    public String getRuleDisplayText() {
        return String.format("%s %s %s (%s)", 
            ruleType != null ? ruleType.getDisplayName() : "未知类型",
            operator != null ? operator : "?",
            thresholdValue != null ? thresholdValue.toString() : "?",
            alertLevel != null ? alertLevel.getDisplayName() : "未知级别");
    }
}