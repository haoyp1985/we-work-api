package com.wework.platform.common.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 错误码枚举
 *
 * @author WeWork Platform Team
 * @since 2.0.0
 */
@Getter
@AllArgsConstructor
public enum ErrorCode {

    /**
     * 成功
     */
    SUCCESS("0000", "操作成功"),

    /**
     * 系统错误
     */
    SYSTEM_ERROR("1000", "系统错误"),

    /**
     * 参数错误
     */
    PARAM_ERROR("1001", "参数错误"),

    /**
     * 数据不存在
     */
    DATA_NOT_FOUND("1002", "数据不存在"),

    /**
     * 数据已存在
     */
    DATA_ALREADY_EXISTS("1003", "数据已存在"),

    /**
     * 权限不足
     */
    PERMISSION_DENIED("1004", "权限不足"),

    /**
     * 任务定义不存在
     */
    TASK_DEFINITION_NOT_FOUND("2001", "任务定义不存在"),

    /**
     * 任务定义已存在
     */
    TASK_DEFINITION_ALREADY_EXISTS("2002", "任务定义已存在"),

    /**
     * 任务实例不存在
     */
    TASK_INSTANCE_NOT_FOUND("2003", "任务实例不存在"),

    /**
     * 任务调度类型不支持
     */
    UNSUPPORTED_SCHEDULE_TYPE("2004", "不支持的任务调度类型"),

    /**
     * 任务处理器不存在
     */
    TASK_HANDLER_NOT_FOUND("2005", "任务处理器不存在"),

    /**
     * 任务执行失败
     */
    TASK_EXECUTION_FAILED("2006", "任务执行失败"),

    /**
     * Cron表达式无效
     */
    INVALID_CRON_EXPRESSION("2007", "Cron表达式无效"),

    /**
     * 任务已在运行
     */
    TASK_ALREADY_RUNNING("2008", "任务已在运行"),

    /**
     * 任务状态不正确
     */
    INVALID_TASK_STATUS("2009", "任务状态不正确"),

    /**
     * 分布式锁获取失败
     */
    DISTRIBUTED_LOCK_FAILED("2010", "分布式锁获取失败");

    /**
     * 错误码
     */
    private final String code;

    /**
     * 错误描述
     */
    private final String message;

    /**
     * 根据错误码获取枚举
     */
    public static ErrorCode fromCode(String code) {
        for (ErrorCode errorCode : ErrorCode.values()) {
            if (errorCode.getCode().equals(code)) {
                return errorCode;
            }
        }
        return SYSTEM_ERROR;
    }

    /**
     * 判断是否为成功
     */
    public boolean isSuccess() {
        return SUCCESS.equals(this);
    }

    @Override
    public String toString() {
        return String.format("[%s] %s", code, message);
    }
}