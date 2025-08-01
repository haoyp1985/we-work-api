package com.wework.platform.common.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 告警级别枚举
 * 
 * @author WeWork Platform Team
 */
@Getter
@AllArgsConstructor
public enum AlertLevel {

    /**
     * 信息
     */
    INFO("info", "信息", 1, "#909399"),

    /**
     * 警告
     */
    WARNING("warning", "警告", 2, "#E6A23C"),

    /**
     * 错误
     */
    ERROR("error", "错误", 3, "#F56C6C"),

    /**
     * 严重
     */
    CRITICAL("critical", "严重", 4, "#F56C6C");

    @EnumValue
    @JsonValue
    private final String code;
    private final String displayName;
    private final int severity; // 严重程度，数值越高越严重
    private final String color; // 颜色代码

    public static AlertLevel fromCode(String code) {
        for (AlertLevel level : values()) {
            if (level.getCode().equals(code)) {
                return level;
            }
        }
        throw new IllegalArgumentException("Unknown alert level code: " + code);
    }

    /**
     * 是否为严重告警
     */
    public boolean isCritical() {
        return this == CRITICAL || this == ERROR;
    }

    /**
     * 是否需要立即处理
     */
    public boolean needsImmediateAction() {
        return this == CRITICAL;
    }

    /**
     * 是否需要通知
     */
    public boolean needsNotification() {
        return this.severity >= WARNING.severity;
    }

    /**
     * 获取Element Plus对应的类型
     */
    public String getElementType() {
        switch (this) {
            case INFO:
                return "info";
            case WARNING:
                return "warning";
            case ERROR:
                return "error";
            case CRITICAL:
                return "error";
            default:
                return "info";
        }
    }
}