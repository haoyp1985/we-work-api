package com.wework.platform.common.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 告警类型枚举
 * 
 * @author WeWork Platform Team
 */
@Getter
@AllArgsConstructor
public enum AlertType {

    /**
     * 账号离线
     */
    ACCOUNT_OFFLINE("account_offline", "账号离线", "account", "账号状态变为离线"),

    /**
     * 心跳超时
     */
    HEARTBEAT_TIMEOUT("heartbeat_timeout", "心跳超时", "account", "账号心跳超过预设时间"),

    /**
     * 连接错误
     */
    CONNECTION_ERROR("connection_error", "连接错误", "network", "连接建立或保持失败"),

    /**
     * API调用失败
     */
    API_CALL_FAILED("api_call_failed", "API调用失败", "api", "企微API调用失败"),

    /**
     * 状态不匹配
     */
    STATUS_MISMATCH("status_mismatch", "状态不匹配", "status", "本地状态与API返回状态不一致"),

    /**
     * 登录失败
     */
    LOGIN_FAILED("login_failed", "登录失败", "login", "账号登录失败"),

    /**
     * 自动恢复失败
     */
    AUTO_RECOVER_FAILED("auto_recover_failed", "自动恢复失败", "recovery", "账号自动恢复失败"),

    /**
     * 重试次数超限
     */
    RETRY_LIMIT_REACHED("retry_limit_reached", "重试次数超限", "retry", "账号重试次数达到上限"),

    /**
     * 配额超限
     */
    QUOTA_EXCEEDED("quota_exceeded", "配额超限", "quota", "租户资源配额超限"),

    /**
     * 响应时间过长
     */
    RESPONSE_TIME_HIGH("response_time_high", "响应时间过长", "performance", "API响应时间超过阈值"),

    /**
     * 消息发送失败
     */
    MESSAGE_SEND_FAILED("message_send_failed", "消息发送失败", "message", "消息发送失败率过高"),

    /**
     * 系统资源不足
     */
    SYSTEM_RESOURCE_LOW("system_resource_low", "系统资源不足", "system", "系统资源使用率过高"),

    /**
     * 网络连接异常
     */
    NETWORK_ERROR("network_error", "网络连接异常", "network", "网络连接出现异常"),

    /**
     * 回调异常
     */
    CALLBACK_ERROR("callback_error", "回调异常", "callback", "回调处理出现异常"),

    /**
     * 数据库连接异常
     */
    DATABASE_ERROR("database_error", "数据库连接异常", "database", "数据库连接或查询异常"),

    /**
     * 缓存异常
     */
    CACHE_ERROR("cache_error", "缓存异常", "cache", "缓存服务异常"),

    /**
     * 队列积压
     */
    QUEUE_BACKLOG("queue_backlog", "队列积压", "queue", "消息队列积压过多");

    @EnumValue
    @JsonValue
    private final String code;
    private final String displayName;
    private final String category; // 告警类别
    private final String description; // 告警描述

    public static AlertType fromCode(String code) {
        for (AlertType type : values()) {
            if (type.getCode().equals(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown alert type code: " + code);
    }

    /**
     * 是否为账号相关告警
     */
    public boolean isAccountRelated() {
        return "account".equals(this.category) || 
               "login".equals(this.category) || 
               "recovery".equals(this.category) ||
               "retry".equals(this.category);
    }

    /**
     * 是否为系统相关告警
     */
    public boolean isSystemRelated() {
        return "system".equals(this.category) || 
               "database".equals(this.category) || 
               "cache".equals(this.category) ||
               "network".equals(this.category);
    }

    /**
     * 是否为业务相关告警
     */
    public boolean isBusinessRelated() {
        return "message".equals(this.category) || 
               "api".equals(this.category) || 
               "callback".equals(this.category) ||
               "quota".equals(this.category);
    }

    /**
     * 获取默认告警级别
     */
    public AlertLevel getDefaultLevel() {
        switch (this) {
            case AUTO_RECOVER_FAILED:
            case RETRY_LIMIT_REACHED:
            case QUOTA_EXCEEDED:
            case DATABASE_ERROR:
                return AlertLevel.CRITICAL;
            case LOGIN_FAILED:
            case STATUS_MISMATCH:
            case RESPONSE_TIME_HIGH:
            case MESSAGE_SEND_FAILED:
            case SYSTEM_RESOURCE_LOW:
            case NETWORK_ERROR:
            case QUEUE_BACKLOG:
                return AlertLevel.ERROR;
            case HEARTBEAT_TIMEOUT:
            case API_CALL_FAILED:
            case CALLBACK_ERROR:
            case CACHE_ERROR:
                return AlertLevel.WARNING;
            default:
                return AlertLevel.INFO;
        }
    }

    /**
     * 获取图标
     */
    public String getIcon() {
        switch (this.category) {
            case "account":
                return "user";
            case "api":
                return "link";
            case "status":
                return "info-filled";
            case "login":
                return "key";
            case "recovery":
                return "refresh";
            case "retry":
                return "warning-filled";
            case "quota":
                return "pie-chart";
            case "performance":
                return "timer";
            case "message":
                return "message";
            case "system":
                return "monitor";
            case "network":
                return "share";
            case "callback":
                return "phone";
            case "database":
                return "coin";
            case "cache":
                return "files";
            case "queue":
                return "list";
            default:
                return "warning";
        }
    }
}