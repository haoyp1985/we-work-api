package com.wework.platform.agent.dto;

import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

/**
 * 模型信息DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ModelInfo {
    
    /**
     * 模型ID
     */
    private String id;
    
    /**
     * 模型名称
     */
    private String name;
    
    /**
     * 模型显示名称
     */
    private String displayName;
    
    /**
     * 模型描述
     */
    private String description;
    
    /**
     * 模型版本
     */
    private String version;
    
    /**
     * 支持的功能
     */
    private List<String> capabilities;
    
    /**
     * 最大Token数
     */
    private Integer maxTokens;
    
    /**
     * 价格信息
     */
    private BigDecimal pricePerToken;
    
    /**
     * 是否可用
     */
    private Boolean available;
    
    /**
     * 模型类型
     */
    private String type;
}