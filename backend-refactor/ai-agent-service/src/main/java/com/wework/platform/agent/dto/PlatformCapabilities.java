package com.wework.platform.agent.dto;

import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.util.List;

/**
 * 平台功能信息DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PlatformCapabilities {
    
    /**
     * 支持的消息类型
     */
    private List<String> supportedMessageTypes;
    
    /**
     * 支持流式响应
     */
    private Boolean supportsStreaming;
    
    /**
     * 支持上下文管理
     */
    private Boolean supportsContext;
    
    /**
     * 支持文件上传
     */
    private Boolean supportsFileUpload;
    
    /**
     * 支持图片处理
     */
    private Boolean supportsImageProcessing;
    
    /**
     * 支持语音处理
     */
    private Boolean supportsVoiceProcessing;
    
    /**
     * 最大上下文长度
     */
    private Integer maxContextLength;
    
    /**
     * 最大Token数
     */
    private Integer maxTokens;
    
    /**
     * 支持的模型列表
     */
    private List<String> supportedModels;
    
    /**
     * 支持的参数
     */
    private List<String> supportedParameters;
    
    /**
     * 平台版本
     */
    private String version;
    
    /**
     * 额外功能描述
     */
    private String description;
}