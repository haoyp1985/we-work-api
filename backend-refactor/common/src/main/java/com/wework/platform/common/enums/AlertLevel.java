package com.wework.platform.common.enums;

/**
 * 告警级别枚举
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
public enum AlertLevel {
    
    /**
     * 信息级别
     */
    INFO("信息级别"),
    
    /**
     * 警告级别
     */
    WARNING("警告级别"),
    
    /**
     * 低级别
     */
    LOW("低级别"),
    
    /**
     * 中级别
     */
    MEDIUM("中级别"),
    
    /**
     * 高级别
     */
    HIGH("高级别"),
    
    /**
     * 严重级别
     */
    CRITICAL("严重级别");

    private final String description;

    AlertLevel(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}