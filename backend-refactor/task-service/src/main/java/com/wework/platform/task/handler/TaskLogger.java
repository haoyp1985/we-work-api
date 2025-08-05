package com.wework.platform.task.handler;

/**
 * 任务日志记录器接口
 * 用于在任务执行过程中记录日志
 * 
 * @author WeWork Platform Team
 * @since 1.0.0
 */
public interface TaskLogger {

    /**
     * 记录信息日志
     * 
     * @param message 日志消息
     */
    void info(String message);

    /**
     * 记录信息日志（带格式化）
     * 
     * @param format 格式字符串
     * @param args 参数
     */
    void info(String format, Object... args);

    /**
     * 记录警告日志
     * 
     * @param message 日志消息
     */
    void warn(String message);

    /**
     * 记录警告日志（带格式化）
     * 
     * @param format 格式字符串
     * @param args 参数
     */
    void warn(String format, Object... args);

    /**
     * 记录错误日志
     * 
     * @param message 日志消息
     */
    void error(String message);

    /**
     * 记录错误日志（带异常）
     * 
     * @param message 日志消息
     * @param exception 异常
     */
    void error(String message, Exception exception);

    /**
     * 记录错误日志（带格式化）
     * 
     * @param format 格式字符串
     * @param args 参数
     */
    void error(String format, Object... args);

    /**
     * 记录调试日志
     * 
     * @param message 日志消息
     */
    void debug(String message);

    /**
     * 记录调试日志（带格式化）
     * 
     * @param format 格式字符串
     * @param args 参数
     */
    void debug(String format, Object... args);

    /**
     * 记录执行步骤日志
     * 
     * @param step 执行步骤
     * @param message 日志消息
     */
    void step(String step, String message);

    /**
     * 记录进度日志
     * 
     * @param progress 进度百分比（0-100）
     * @param message 日志消息
     */
    void progress(int progress, String message);
}