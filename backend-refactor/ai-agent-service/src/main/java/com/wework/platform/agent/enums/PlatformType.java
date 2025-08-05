package com.wework.platform.agent.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.Getter;

/**
 * 外部平台类型枚举
 */
@Getter
public enum PlatformType {

    /**
     * Coze平台
     */
    COZE("COZE", "Coze平台"),

    /**
     * Dify平台
     */
    DIFY("DIFY", "Dify平台"),

    /**
     * OpenAI平台
     */
    OPENAI("OPENAI", "OpenAI平台"),

    /**
     * 阿里百炼平台
     */
    ALIBABA_DASHSCOPE("ALIBABA_DASHSCOPE", "阿里百炼平台"),

    /**
     * 百度文心一言
     */
    BAIDU_WENXIN("BAIDU_WENXIN", "百度文心一言"),

    /**
     * 腾讯混元
     */
    TENCENT_HUNYUAN("TENCENT_HUNYUAN", "腾讯混元"),

    /**
     * 字节豆包
     */
    BYTEDANCE_DOUBAO("BYTEDANCE_DOUBAO", "字节豆包"),

    /**
     * Azure OpenAI
     */
    AZURE_OPENAI("AZURE_OPENAI", "Azure OpenAI"),

    /**
     * Google Gemini
     */
    GOOGLE_GEMINI("GOOGLE_GEMINI", "Google Gemini"),

    /**
     * Anthropic Claude
     */
    ANTHROPIC_CLAUDE("ANTHROPIC_CLAUDE", "Anthropic Claude"),

    /**
     * 自定义平台
     */
    CUSTOM("CUSTOM", "自定义平台");

    @EnumValue
    @JsonValue
    private final String code;

    private final String description;

    PlatformType(String code, String description) {
        this.code = code;
        this.description = description;
    }

    public static PlatformType fromCode(String code) {
        for (PlatformType type : values()) {
            if (type.getCode().equals(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("未知的平台类型: " + code);
    }

    /**
     * 是否为直接模型调用平台
     */
    public boolean isDirectModelPlatform() {
        return this == ALIBABA_DASHSCOPE || this == OPENAI || this == AZURE_OPENAI || 
               this == BAIDU_WENXIN || this == TENCENT_HUNYUAN || this == BYTEDANCE_DOUBAO ||
               this == GOOGLE_GEMINI || this == ANTHROPIC_CLAUDE;
    }

    /**
     * 是否为AI Agent平台
     */
    public boolean isAgentPlatform() {
        return this == COZE || this == DIFY;
    }
}