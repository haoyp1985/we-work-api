package com.wework.platform.common.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 监控规则类型枚举
 * 
 * @author WeWork Platform Team
 */
@Getter
@AllArgsConstructor
public enum MonitorRuleType {

    /**
     * 心跳检查
     */
    HEARTBEAT("heartbeat", "心跳检查", "分钟", "检查账号心跳间隔时间"),

    /**
     * API失败率
     */
    API_FAILURE_RATE("api_failure_rate", "API失败率", "%", "API调用失败率"),

    /**
     * 响应时间
     */
    RESPONSE_TIME("response_time", "响应时间", "毫秒", "API响应时间"),

    /**
     * 登录超时
     */
    LOGIN_TIMEOUT("login_timeout", "登录超时", "分钟", "登录流程超时时间"),

    /**
     * 离线时长
     */
    OFFLINE_DURATION("offline_duration", "离线时长", "分钟", "账号离线持续时间"),

    /**
     * 重试次数
     */
    RETRY_COUNT("retry_count", "重试次数", "次", "账号重试次数"),

    /**
     * 健康度评分
     */
    HEALTH_SCORE("health_score", "健康度评分", "分", "账号健康度评分"),

    /**
     * 消息发送失败率
     */
    MESSAGE_FAILURE_RATE("message_failure_rate", "消息发送失败率", "%", "消息发送失败率"),

    /**
     * 队列长度
     */
    QUEUE_LENGTH("queue_length", "队列长度", "条", "消息队列积压数量"),

    /**
     * 内存使用率
     */
    MEMORY_USAGE("memory_usage", "内存使用率", "%", "系统内存使用率"),

    /**
     * CPU使用率
     */
    CPU_USAGE("cpu_usage", "CPU使用率", "%", "系统CPU使用率"),

    /**
     * 磁盘使用率
     */
    DISK_USAGE("disk_usage", "磁盘使用率", "%", "系统磁盘使用率"),

    /**
     * 连接数
     */
    CONNECTION_COUNT("connection_count", "连接数", "个", "数据库连接数"),

    /**
     * 缓存命中率
     */
    CACHE_HIT_RATE("cache_hit_rate", "缓存命中率", "%", "缓存命中率"),

    /**
     * 内置规则
     */
    BUILTIN("builtin", "内置规则", "", "系统预定义的监控规则");

    @EnumValue
    @JsonValue
    private final String code;
    private final String displayName;
    private final String unit; // 单位
    private final String description; // 描述

    public static MonitorRuleType fromCode(String code) {
        for (MonitorRuleType type : values()) {
            if (type.getCode().equals(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown monitor rule type code: " + code);
    }

    /**
     * 是否为账号级监控
     */
    public boolean isAccountLevel() {
        return this == HEARTBEAT || this == LOGIN_TIMEOUT || this == OFFLINE_DURATION ||
               this == RETRY_COUNT || this == HEALTH_SCORE;
    }

    /**
     * 是否为API级监控
     */
    public boolean isApiLevel() {
        return this == API_FAILURE_RATE || this == RESPONSE_TIME;
    }

    /**
     * 是否为业务级监控
     */
    public boolean isBusinessLevel() {
        return this == MESSAGE_FAILURE_RATE || this == QUEUE_LENGTH;
    }

    /**
     * 是否为系统级监控
     */
    public boolean isSystemLevel() {
        return this == MEMORY_USAGE || this == CPU_USAGE || this == DISK_USAGE ||
               this == CONNECTION_COUNT || this == CACHE_HIT_RATE;
    }

    /**
     * 获取默认检查间隔(秒)
     */
    public int getDefaultCheckInterval() {
        if (isSystemLevel()) {
            return 60; // 系统级监控每分钟检查一次
        } else if (isApiLevel()) {
            return 30; // API级监控每30秒检查一次
        } else if (isAccountLevel()) {
            return 30; // 账号级监控每30秒检查一次
        } else if (isBusinessLevel()) {
            return 120; // 业务级监控每2分钟检查一次
        }
        return 60;
    }

    /**
     * 获取默认告警级别
     */
    public AlertLevel getDefaultAlertLevel() {
        if (this == HEARTBEAT || this == LOGIN_TIMEOUT || this == OFFLINE_DURATION) {
            return AlertLevel.WARNING;
        } else if (this == API_FAILURE_RATE || this == MESSAGE_FAILURE_RATE) {
            return AlertLevel.ERROR;
        } else if (isSystemLevel()) {
            return AlertLevel.CRITICAL;
        }
        return AlertLevel.WARNING;
    }

    /**
     * 获取建议阈值
     */
    public String getRecommendedThreshold() {
        switch (this) {
            case HEARTBEAT:
                return "5"; // 5分钟
            case API_FAILURE_RATE:
                return "5"; // 5%
            case RESPONSE_TIME:
                return "2000"; // 2秒
            case LOGIN_TIMEOUT:
                return "10"; // 10分钟
            case OFFLINE_DURATION:
                return "5"; // 5分钟
            case RETRY_COUNT:
                return "3"; // 3次
            case HEALTH_SCORE:
                return "60"; // 60分
            case MESSAGE_FAILURE_RATE:
                return "10"; // 10%
            case QUEUE_LENGTH:
                return "1000"; // 1000条
            case MEMORY_USAGE:
                return "80"; // 80%
            case CPU_USAGE:
                return "80"; // 80%
            case DISK_USAGE:
                return "85"; // 85%
            case CONNECTION_COUNT:
                return "80"; // 80个
            case CACHE_HIT_RATE:
                return "90"; // 90%
            default:
                return "100";
        }
    }
}