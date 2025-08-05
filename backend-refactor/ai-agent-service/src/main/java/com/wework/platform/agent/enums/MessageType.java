package com.wework.platform.agent.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.Getter;

/**
 * 消息类型枚举
 */
@Getter
public enum MessageType {

    /**
     * 文本消息
     */
    TEXT("TEXT", "文本消息"),

    /**
     * 图片消息
     */
    IMAGE("IMAGE", "图片消息"),

    /**
     * 语音消息
     */
    AUDIO("AUDIO", "语音消息"),

    /**
     * 视频消息
     */
    VIDEO("VIDEO", "视频消息"),

    /**
     * 文件消息
     */
    FILE("FILE", "文件消息"),

    /**
     * 富文本消息
     */
    RICH_TEXT("RICH_TEXT", "富文本消息"),

    /**
     * 卡片消息
     */
    CARD("CARD", "卡片消息"),

    /**
     * 系统消息
     */
    SYSTEM("SYSTEM", "系统消息"),

    /**
     * 事件消息
     */
    EVENT("EVENT", "事件消息"),

    /**
     * 工具调用消息
     */
    TOOL_CALL("TOOL_CALL", "工具调用消息"),

    /**
     * 工具响应消息
     */
    TOOL_RESPONSE("TOOL_RESPONSE", "工具响应消息"),

    /**
     * 多模态消息
     */
    MULTIMODAL("MULTIMODAL", "多模态消息");

    @EnumValue
    @JsonValue
    private final String code;

    private final String description;

    MessageType(String code, String description) {
        this.code = code;
        this.description = description;
    }

    public static MessageType fromCode(String code) {
        for (MessageType type : values()) {
            if (type.getCode().equals(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("未知的消息类型: " + code);
    }

    /**
     * 是否为用户输入类型
     */
    public boolean isUserInput() {
        return this == TEXT || this == IMAGE || this == AUDIO || 
               this == VIDEO || this == FILE || this == MULTIMODAL;
    }

    /**
     * 是否为系统类型
     */
    public boolean isSystemType() {
        return this == SYSTEM || this == EVENT;
    }

    /**
     * 是否为工具类型
     */
    public boolean isToolType() {
        return this == TOOL_CALL || this == TOOL_RESPONSE;
    }
}