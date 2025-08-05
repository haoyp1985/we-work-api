package com.wework.platform.common.enums;

/**
 * 任务状态枚举
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
public enum TaskStatus {
    
    /**
     * 待执行
     */
    PENDING("待执行"),
    
    /**
     * 运行中
     */
    RUNNING("运行中"),
    
    /**
     * 已完成
     */
    COMPLETED("已完成"),
    
    /**
     * 失败
     */
    FAILED("失败"),
    
    /**
     * 已取消
     */
    CANCELLED("已取消"),
    
    /**
     * 暂停
     */
    PAUSED("暂停"),
    
    /**
     * 超时
     */
    TIMEOUT("超时");

    private final String description;

    TaskStatus(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}