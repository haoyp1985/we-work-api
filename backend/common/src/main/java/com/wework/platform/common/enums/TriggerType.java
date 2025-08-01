package com.wework.platform.common.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 触发类型枚举
 * 
 * @author WeWork Platform Team
 */
@Getter
@AllArgsConstructor
public enum TriggerType {

    /**
     * 手动触发
     */
    MANUAL("manual", "手动触发"),

    /**
     * 自动触发
     */
    AUTO("auto", "自动触发"),

    /**
     * 回调触发
     */
    CALLBACK("callback", "回调触发"),

    /**
     * 监控触发
     */
    MONITOR("monitor", "监控触发"),

    /**
     * 定时任务触发
     */
    SCHEDULED("scheduled", "定时任务触发"),

    /**
     * 系统触发
     */
    SYSTEM("system", "系统触发");

    @EnumValue
    @JsonValue
    private final String code;
    private final String description;

    public static TriggerType fromCode(String code) {
        for (TriggerType type : values()) {
            if (type.getCode().equals(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown trigger type code: " + code);
    }

    /**
     * 是否为自动触发
     */
    public boolean isAutomatic() {
        return this == AUTO || this == CALLBACK || this == MONITOR || this == SCHEDULED || this == SYSTEM;
    }

    /**
     * 是否需要记录操作人
     */
    public boolean needsOperator() {
        return this == MANUAL;
    }
}