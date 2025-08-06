package com.wework.platform.common.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 任务状态枚举
 *
 * @author WeWork Platform Team
 * @since 2.0.0
 */
@Getter
@AllArgsConstructor
public enum TaskStatus {

    /**
     * 待执行
     */
    PENDING("PENDING", "待执行"),

    /**
     * 执行中
     */
    RUNNING("RUNNING", "执行中"),

    /**
     * 执行成功
     */
    SUCCESS("SUCCESS", "执行成功"),

    /**
     * 执行失败
     */
    FAILED("FAILED", "执行失败"),

    /**
     * 执行超时
     */
    TIMEOUT("TIMEOUT", "执行超时"),

    /**
     * 已取消
     */
    CANCELLED("CANCELLED", "已取消"),

    /**
     * 已暂停
     */
    PAUSED("PAUSED", "已暂停"),

    /**
     * 已停止
     */
    STOPPED("STOPPED", "已停止"),

    /**
     * 已删除
     */
    DELETED("DELETED", "已删除");

    /**
     * 状态码
     */
    private final String code;

    /**
     * 状态描述
     */
    private final String description;

    /**
     * 根据状态码获取枚举
     */
    public static TaskStatus fromCode(String code) {
        for (TaskStatus status : TaskStatus.values()) {
            if (status.getCode().equals(code)) {
                return status;
            }
        }
        throw new IllegalArgumentException("Unknown TaskStatus code: " + code);
    }

    /**
     * 判断是否为执行中状态
     */
    public boolean isRunning() {
        return this == RUNNING;
    }

    /**
     * 判断是否为最终状态（不会再改变）
     */
    public boolean isFinalStatus() {
        return this == SUCCESS || this == FAILED || this == TIMEOUT || this == CANCELLED || this == DELETED;
    }

    /**
     * 判断是否为成功状态
     */
    public boolean isSuccess() {
        return this == SUCCESS;
    }

    /**
     * 判断是否为失败状态
     */
    public boolean isFailure() {
        return this == FAILED || this == TIMEOUT;
    }

    /**
     * 判断是否可以重试
     */
    public boolean canRetry() {
        return this == FAILED || this == TIMEOUT;
    }
}