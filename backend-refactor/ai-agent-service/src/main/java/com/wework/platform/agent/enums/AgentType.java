package com.wework.platform.agent.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.Getter;

/**
 * 智能体类型枚举
 */
@Getter
public enum AgentType {

    /**
     * 聊天助手
     */
    CHAT_ASSISTANT("CHAT_ASSISTANT", "聊天助手"),

    /**
     * 工作流智能体
     */
    WORKFLOW("WORKFLOW", "工作流智能体"),

    /**
     * 知识库助手
     */
    KNOWLEDGE_BASE("KNOWLEDGE_BASE", "知识库助手"),

    /**
     * 任务处理器
     */
    TASK_PROCESSOR("TASK_PROCESSOR", "任务处理器"),

    /**
     * 多模态智能体
     */
    MULTIMODAL("MULTIMODAL", "多模态智能体"),

    /**
     * 自定义智能体
     */
    CUSTOM("CUSTOM", "自定义智能体");

    @EnumValue
    @JsonValue
    private final String code;

    private final String description;

    AgentType(String code, String description) {
        this.code = code;
        this.description = description;
    }

    public static AgentType fromCode(String code) {
        for (AgentType type : values()) {
            if (type.getCode().equals(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("未知的智能体类型: " + code);
    }
}