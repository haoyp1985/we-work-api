package com.wework.platform.agent.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.Getter;

/**
 * 对话会话状态枚举
 */
@Getter
public enum ConversationStatus {

    /**
     * 活跃状态
     */
    ACTIVE("ACTIVE", "活跃"),

    /**
     * 等待用户回复
     */
    WAITING_USER("WAITING_USER", "等待用户回复"),

    /**
     * 等待AI回复
     */
    WAITING_AI("WAITING_AI", "等待AI回复"),

    /**
     * 处理中
     */
    PROCESSING("PROCESSING", "处理中"),

    /**
     * 已暂停
     */
    PAUSED("PAUSED", "已暂停"),

    /**
     * 已结束
     */
    ENDED("ENDED", "已结束"),

    /**
     * 超时
     */
    TIMEOUT("TIMEOUT", "超时"),

    /**
     * 异常状态
     */
    ERROR("ERROR", "异常");

    @EnumValue
    @JsonValue
    private final String code;

    private final String description;

    ConversationStatus(String code, String description) {
        this.code = code;
        this.description = description;
    }

    public static ConversationStatus fromCode(String code) {
        for (ConversationStatus status : values()) {
            if (status.getCode().equals(code)) {
                return status;
            }
        }
        throw new IllegalArgumentException("未知的会话状态: " + code);
    }

    /**
     * 是否为活跃状态
     */
    public boolean isActive() {
        return this == ACTIVE || this == WAITING_USER || this == WAITING_AI || this == PROCESSING;
    }

    /**
     * 是否为结束状态
     */
    public boolean isFinished() {
        return this == ENDED || this == TIMEOUT || this == ERROR;
    }
}