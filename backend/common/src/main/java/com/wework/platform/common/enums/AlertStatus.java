package com.wework.platform.common.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 告警状态枚举
 * 
 * @author WeWork Platform Team
 */
@Getter
@AllArgsConstructor
public enum AlertStatus {

    /**
     * 活跃
     */
    ACTIVE("active", "活跃", "#F56C6C"),

    /**
     * 已确认
     */
    ACKNOWLEDGED("acknowledged", "已确认", "#E6A23C"),

    /**
     * 已解决
     */
    RESOLVED("resolved", "已解决", "#67C23A"),

    /**
     * 已抑制
     */
    SUPPRESSED("suppressed", "已抑制", "#909399"),

    /**
     * 已过期
     */
    EXPIRED("expired", "已过期", "#C0C4CC");

    @EnumValue
    @JsonValue
    private final String code;
    private final String displayName;
    private final String color;

    public static AlertStatus fromCode(String code) {
        for (AlertStatus status : values()) {
            if (status.getCode().equals(code)) {
                return status;
            }
        }
        throw new IllegalArgumentException("Unknown alert status code: " + code);
    }

    /**
     * 是否为活跃状态
     */
    public boolean isActive() {
        return this == ACTIVE;
    }

    /**
     * 是否已处理
     */
    public boolean isHandled() {
        return this == ACKNOWLEDGED || this == RESOLVED;
    }

    /**
     * 是否已结束
     */
    public boolean isFinished() {
        return this == RESOLVED || this == EXPIRED;
    }

    /**
     * 是否需要处理
     */
    public boolean needsAction() {
        return this == ACTIVE;
    }

    /**
     * 获取Element Plus对应的类型
     */
    public String getElementType() {
        switch (this) {
            case ACTIVE:
                return "danger";
            case ACKNOWLEDGED:
                return "warning";
            case RESOLVED:
                return "success";
            case SUPPRESSED:
                return "info";
            case EXPIRED:
                return "info";
            default:
                return "info";
        }
    }

    /**
     * 获取状态优先级
     */
    public int getPriority() {
        switch (this) {
            case ACTIVE:
                return 4;
            case ACKNOWLEDGED:
                return 3;
            case SUPPRESSED:
                return 2;
            case RESOLVED:
                return 1;
            case EXPIRED:
                return 0;
            default:
                return 0;
        }
    }
}