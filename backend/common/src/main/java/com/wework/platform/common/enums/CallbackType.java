package com.wework.platform.common.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 企微回调类型枚举
 *
 * @author WeWork Platform Team
 */
@Getter
@AllArgsConstructor
public enum CallbackType {

    /**
     * 二维码变化
     */
    QR_CODE_CHANGE(11002, "QR_CODE_CHANGE", "二维码变化", "登录二维码状态变化"),

    /**
     * 登录成功
     */
    LOGIN_SUCCESS(11003, "LOGIN_SUCCESS", "登录成功", "账号登录成功"),

    /**
     * 退出登录
     */
    LOGOUT(11004, "LOGOUT", "退出登录", "账号退出登录"),

    /**
     * 新消息
     */
    NEW_MESSAGE(11010, "NEW_MESSAGE", "新消息", "收到新消息"),

    /**
     * 其他设备登录
     */
    OTHER_DEVICE_LOGIN(11011, "OTHER_DEVICE_LOGIN", "其他设备登录", "其他设备登录提醒"),

    /**
     * 消息同步回调
     */
    MESSAGE_SYNC(11013, "MESSAGE_SYNC", "消息同步回调", "消息发送或接收同步"),

    /**
     * 视频/语音电话
     */
    VIDEO_VOICE_CALL(2166, "VIDEO_VOICE_CALL", "视频/语音电话", "视频或语音通话事件"),

    /**
     * 联系人变化
     */
    CONTACT_CHANGE(11020, "CONTACT_CHANGE", "联系人变化", "联系人列表变化"),

    /**
     * 群聊变化
     */
    GROUP_CHANGE(11021, "GROUP_CHANGE", "群聊变化", "群聊信息变化"),

    /**
     * 系统通知
     */
    SYSTEM_NOTIFICATION(11030, "SYSTEM_NOTIFICATION", "系统通知", "系统级通知消息");

    /**
     * 回调类型ID
     */
    private final Integer typeId;

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
     * 根据类型ID获取回调类型
     */
    public static CallbackType fromTypeId(Integer typeId) {
        for (CallbackType type : values()) {
            if (type.getTypeId().equals(typeId)) {
                return type;
            }
        }
        return SYSTEM_NOTIFICATION; // 默认返回系统通知
    }

    /**
     * 根据代码获取回调类型
     */
    public static CallbackType fromCode(String code) {
        for (CallbackType type : values()) {
            if (type.getCode().equals(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown callback type code: " + code);
    }
}