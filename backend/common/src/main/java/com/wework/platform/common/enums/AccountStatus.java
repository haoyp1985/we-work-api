package com.wework.platform.common.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 账号状态枚举
 * 
 * @author WeWork Platform Team
 */
@Getter
@AllArgsConstructor
public enum AccountStatus {

    /**
     * 已创建
     */
    CREATED("created", "已创建"),

    /**
     * 登录中
     */
    LOGGING("logging", "登录中"),

    /**
     * 在线
     */
    ONLINE("online", "在线"),

    /**
     * 离线
     */
    OFFLINE("offline", "离线"),

    /**
     * 异常
     */
    ERROR("error", "异常");

    @EnumValue
    @JsonValue
    private final String code;
    private final String description;

    public static AccountStatus fromCode(String code) {
        for (AccountStatus status : values()) {
            if (status.getCode().equals(code)) {
                return status;
            }
        }
        throw new IllegalArgumentException("Unknown account status code: " + code);
    }

    /**
     * 是否为在线状态
     */
    public boolean isOnline() {
        return this == ONLINE;
    }

    /**
     * 是否为异常状态
     */
    public boolean isError() {
        return this == ERROR;
    }
}