package com.wework.platform.common.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 消息类型枚举
 * 
 * @author WeWork Platform Team
 */
@Getter
@AllArgsConstructor
public enum MessageType {

    /**
     * 文本消息
     */
    TEXT("text", "文本消息"),

    /**
     * 图片消息
     */
    IMAGE("image", "图片消息"),

    /**
     * 文件消息
     */
    FILE("file", "文件消息"),

    /**
     * @消息
     */
    AT("at", "@消息"),

    /**
     * 小程序消息
     */
    MINIPROGRAM("miniprogram", "小程序消息");

    @EnumValue
    @JsonValue
    private final String code;
    private final String description;

    public static MessageType fromCode(String code) {
        for (MessageType type : values()) {
            if (type.getCode().equals(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown message type code: " + code);
    }
}