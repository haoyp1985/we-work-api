package com.wework.platform.common.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 消息状态枚举
 * 
 * @author WeWork Platform Team
 */
@Getter
@AllArgsConstructor
public enum MessageStatus {

    /**
     * 待发送
     */
    PENDING("pending", "待发送"),

    /**
     * 发送中
     */
    SENDING("sending", "发送中"),

    /**
     * 已发送
     */
    SENT("sent", "已发送"),

    /**
     * 已送达
     */
    DELIVERED("delivered", "已送达"),

    /**
     * 发送失败
     */
    FAILED("failed", "发送失败");

    @EnumValue
    @JsonValue
    private final String code;
    private final String description;

    public static MessageStatus fromCode(String code) {
        for (MessageStatus status : values()) {
            if (status.getCode().equals(code)) {
                return status;
            }
        }
        throw new IllegalArgumentException("Unknown message status code: " + code);
    }

    /**
     * 是否为最终状态
     */
    public boolean isFinalStatus() {
        return this == DELIVERED || this == FAILED;
    }

    /**
     * 是否为成功状态
     */
    public boolean isSuccess() {
        return this == SENT || this == DELIVERED;
    }
}