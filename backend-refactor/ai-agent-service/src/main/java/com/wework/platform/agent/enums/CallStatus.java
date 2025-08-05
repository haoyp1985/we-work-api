package com.wework.platform.agent.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.Getter;

/**
 * 外部平台调用状态枚举
 */
@Getter
public enum CallStatus {

    /**
     * 准备中
     */
    PENDING("PENDING", "准备中"),

    /**
     * 调用中
     */
    CALLING("CALLING", "调用中"),

    /**
     * 成功
     */
    SUCCESS("SUCCESS", "成功"),

    /**
     * 失败
     */
    FAILED("FAILED", "失败"),

    /**
     * 超时
     */
    TIMEOUT("TIMEOUT", "超时"),

    /**
     * 限流
     */
    RATE_LIMITED("RATE_LIMITED", "限流"),

    /**
     * 认证失败
     */
    AUTH_FAILED("AUTH_FAILED", "认证失败"),

    /**
     * 配额不足
     */
    QUOTA_EXCEEDED("QUOTA_EXCEEDED", "配额不足"),

    /**
     * 服务不可用
     */
    SERVICE_UNAVAILABLE("SERVICE_UNAVAILABLE", "服务不可用"),

    /**
     * 已取消
     */
    CANCELLED("CANCELLED", "已取消");

    @EnumValue
    @JsonValue
    private final String code;

    private final String description;

    CallStatus(String code, String description) {
        this.code = code;
        this.description = description;
    }

    public static CallStatus fromCode(String code) {
        for (CallStatus status : values()) {
            if (status.getCode().equals(code)) {
                return status;
            }
        }
        throw new IllegalArgumentException("未知的调用状态: " + code);
    }

    /**
     * 是否为成功状态
     */
    public boolean isSuccess() {
        return this == SUCCESS;
    }

    /**
     * 是否为失败状态
     */
    public boolean isFailed() {
        return this == FAILED || this == TIMEOUT || this == RATE_LIMITED || 
               this == AUTH_FAILED || this == QUOTA_EXCEEDED || this == SERVICE_UNAVAILABLE;
    }

    /**
     * 是否为进行中状态
     */
    public boolean isInProgress() {
        return this == PENDING || this == CALLING;
    }

    /**
     * 是否为终止状态
     */
    public boolean isFinished() {
        return !isInProgress() && this != CANCELLED;
    }

    /**
     * 是否可重试
     */
    public boolean isRetryable() {
        return this == FAILED || this == TIMEOUT || this == RATE_LIMITED || this == SERVICE_UNAVAILABLE;
    }
}