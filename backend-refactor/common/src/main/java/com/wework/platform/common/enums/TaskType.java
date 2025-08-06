package com.wework.platform.common.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 任务类型枚举
 *
 * @author WeWork Platform Team
 * @since 2.0.0
 */
@Getter
@AllArgsConstructor
public enum TaskType {

    /**
     * 定时任务
     */
    SCHEDULED("SCHEDULED", "定时任务"),

    /**
     * 即时任务
     */
    IMMEDIATE("IMMEDIATE", "即时任务"),

    /**
     * 延迟任务
     */
    DELAYED("DELAYED", "延迟任务"),

    /**
     * 周期任务
     */
    PERIODIC("PERIODIC", "周期任务"),

    /**
     * 一次性任务
     */
    ONE_TIME("ONE_TIME", "一次性任务"),

    /**
     * 消息任务
     */
    MESSAGE("MESSAGE", "消息任务"),

    /**
     * 数据同步任务
     */
    DATA_SYNC("DATA_SYNC", "数据同步任务"),

    /**
     * 清理任务
     */
    CLEANUP("CLEANUP", "清理任务"),

    /**
     * 备份任务
     */
    BACKUP("BACKUP", "备份任务"),

    /**
     * 报告任务
     */
    REPORT("REPORT", "报告任务"),

    /**
     * 监控任务
     */
    MONITOR("MONITOR", "监控任务"),

    /**
     * 自定义任务
     */
    CUSTOM("CUSTOM", "自定义任务");

    /**
     * 类型码
     */
    private final String code;

    /**
     * 类型描述
     */
    private final String description;

    /**
     * 根据类型码获取枚举
     */
    public static TaskType fromCode(String code) {
        for (TaskType type : TaskType.values()) {
            if (type.getCode().equals(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown TaskType code: " + code);
    }

    /**
     * 判断是否为定时任务
     */
    public boolean isScheduled() {
        return this == SCHEDULED || this == PERIODIC;
    }

    /**
     * 判断是否为一次性任务
     */
    public boolean isOneTime() {
        return this == ONE_TIME || this == IMMEDIATE;
    }

    /**
     * 判断是否需要定时执行
     */
    public boolean requiresScheduling() {
        return this == SCHEDULED || this == PERIODIC || this == DELAYED;
    }
}