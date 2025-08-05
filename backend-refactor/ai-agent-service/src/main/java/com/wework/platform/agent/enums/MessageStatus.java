package com.wework.platform.agent.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.Getter;

/**
 * 消息状态枚举
 */
@Getter
public enum MessageStatus {

    /**
     * 已发送
     */
    SENT("SENT", "已发送"),

    /**
     * 处理中
     */
    PROCESSING("PROCESSING", "处理中"),

    /**
     * 已送达
     */
    DELIVERED("DELIVERED", "已送达"),

    /**
     * 已读
     */
    READ("READ", "已读"),

    /**
     * 发送失败
     */
    FAILED("FAILED", "发送失败"),

    /**
     * 处理失败
     */
    PROCESS_FAILED("PROCESS_FAILED", "处理失败"),

    /**
     * 超时
     */
    TIMEOUT("TIMEOUT", "超时"),

    /**
     * 已撤回
     */
    RECALLED("RECALLED", "已撤回"),

    /**
     * 已删除
     */
    DELETED("DELETED", "已删除");

    @EnumValue
    @JsonValue
    private final String code;

    private final String description;

    MessageStatus(String code, String description) {
        this.code = code;
        this.description = description;
    }

    public static MessageStatus fromCode(String code) {
        for (MessageStatus status : values()) {
            if (status.getCode().equals(code)) {
                return status;
            }
        }
        throw new IllegalArgumentException("未知的消息状态: " + code);
    }

    /**
     * 是否为成功状态
     */
    public boolean isSuccess() {
        return this == SENT || this == DELIVERED || this == READ;
    }

    /**
     * 是否为失败状态
     */
    public boolean isFailed() {
        return this == FAILED || this == PROCESS_FAILED || this == TIMEOUT;
    }

    /**
     * 是否为处理中状态
     */
    public boolean isProcessing() {
        return this == PROCESSING;
    }

    /**
     * 是否为终止状态
     */
    public boolean isFinished() {
        return this != PROCESSING;
    }
}