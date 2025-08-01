package com.wework.platform.common.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 消息模板类型枚举
 *
 * @author WeWork Platform Team
 */
@Getter
@AllArgsConstructor
public enum MessageTemplateType {

    /**
     * 文本消息
     */
    TEXT("TEXT", "文本消息", "纯文本内容"),

    /**
     * 图片消息
     */
    IMAGE("IMAGE", "图片消息", "图片文件消息"),

    /**
     * 视频消息
     */
    VIDEO("VIDEO", "视频消息", "视频文件消息"),

    /**
     * 文件消息
     */
    FILE("FILE", "文件消息", "文档文件消息"),

    /**
     * 语音消息
     */
    VOICE("VOICE", "语音消息", "语音文件消息"),

    /**
     * 链接消息
     */
    LINK("LINK", "链接消息", "网页链接消息"),

    /**
     * 小程序消息
     */
    MINIPROGRAM("MINIPROGRAM", "小程序消息", "微信小程序卡片"),

    /**
     * 名片消息
     */
    CONTACT("CONTACT", "名片消息", "联系人名片"),

    /**
     * 位置消息
     */
    LOCATION("LOCATION", "位置消息", "地理位置信息"),

    /**
     * GIF消息
     */
    GIF("GIF", "GIF消息", "动态图片消息"),

    /**
     * 群@消息
     */
    MENTION("MENTION", "群@消息", "群聊@消息"),

    /**
     * 引用消息
     */
    QUOTE("QUOTE", "引用消息", "引用回复消息"),

    /**
     * 混合消息
     */
    MIXED("MIXED", "混合消息", "包含多种类型的复合消息");

    /**
     * 类型代码
     */
    private final String code;

    /**
     * 类型名称
     */
    private final String name;

    /**
     * 类型描述
     */
    private final String description;

    /**
     * 根据代码获取类型
     */
    public static MessageTemplateType fromCode(String code) {
        for (MessageTemplateType type : values()) {
            if (type.getCode().equals(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown message template type code: " + code);
    }
}