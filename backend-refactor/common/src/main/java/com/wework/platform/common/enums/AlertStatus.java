package com.wework.platform.common.enums;

/**
 * 告警状态枚举
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
public enum AlertStatus {
    
    /**
     * 启用
     */
    ENABLED("启用"),
    
    /**
     * 禁用
     */
    DISABLED("禁用"),
    
    /**
     * 活跃
     */
    ACTIVE("活跃"),
    
    /**
     * 已抑制
     */
    SUPPRESSED("已抑制"),
    
    /**
     * 待处理
     */
    PENDING("待处理"),
    
    /**
     * 处理中
     */
    PROCESSING("处理中"),
    
    /**
     * 已解决
     */
    RESOLVED("已解决"),
    
    /**
     * 已忽略
     */
    IGNORED("已忽略");

    private final String description;

    AlertStatus(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}