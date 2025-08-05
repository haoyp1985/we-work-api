package com.wework.platform.common.enums;

/**
 * 任务类型枚举
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
public enum TaskType {
    
    /**
     * 定时任务
     */
    SCHEDULED("定时任务"),
    
    /**
     * 立即执行
     */
    IMMEDIATE("立即执行"),
    
    /**
     * 延迟任务
     */
    DELAYED("延迟任务"),
    
    /**
     * 重复任务
     */
    RECURRING("重复任务"),
    
    /**
     * 手动任务
     */
    MANUAL("手动任务"),
    
    /**
     * 系统任务
     */
    SYSTEM("系统任务"),
    
    /**
     * 批量任务
     */
    BATCH("批量任务");

    private final String description;

    TaskType(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}