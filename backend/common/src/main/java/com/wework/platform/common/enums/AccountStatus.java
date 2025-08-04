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
    CREATED("CREATED", "已创建", 1),

    /**
     * 初始化中
     */
    INITIALIZING("INITIALIZING", "初始化中", 2),

    /**
     * 等待扫码
     */
    WAITING_QR("WAITING_QR", "等待扫码", 3),

    /**
     * 等待确认
     */
    WAITING_CONFIRM("WAITING_CONFIRM", "等待确认", 4),

    /**
     * 验证中
     */
    VERIFYING("VERIFYING", "验证中", 5),

    /**
     * 在线
     */
    ONLINE("ONLINE", "在线", 10),

    /**
     * 离线
     */
    OFFLINE("OFFLINE", "离线", 6),

    /**
     * 异常
     */
    ERROR("ERROR", "异常", 7),

    /**
     * 恢复中
     */
    RECOVERING("RECOVERING", "恢复中", 8);

    @EnumValue
    @JsonValue
    private final String code;
    private final String description;
    private final int priority; // 状态优先级，数值越高表示状态越好

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

    /**
     * 是否为最终状态
     */
    public boolean isFinalState() {
        return this == ONLINE || this == OFFLINE || this == ERROR;
    }

    /**
     * 是否为过渡状态
     */
    public boolean isTransitionState() {
        return this == INITIALIZING || this == WAITING_QR || 
               this == WAITING_CONFIRM || this == VERIFYING || 
               this == RECOVERING;
    }

    /**
     * 是否可以开始登录
     */
    public boolean canStartLogin() {
        return this == CREATED || this == OFFLINE || this == ERROR;
    }

    /**
     * 是否需要用户干预
     */
    public boolean needsUserIntervention() {
        return this == WAITING_QR || this == WAITING_CONFIRM || this == VERIFYING;
    }

    /**
     * 获取状态颜色（用于前端显示）
     */
    public String getStatusColor() {
        switch (this) {
            case ONLINE:
                return "success";
            case OFFLINE:
                return "warning";
            case ERROR:
                return "danger";
            case RECOVERING:
            case INITIALIZING:
                return "info";
            case WAITING_QR:
            case WAITING_CONFIRM:
            case VERIFYING:
                return "primary";
            default:
                return "default";
        }
    }
}