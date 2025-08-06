package com.wework.platform.agent.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.Getter;

/**
 * 智能体状态枚举
 */
@Getter
public enum AgentStatus {

    /**
     * 草稿状态
     */
    DRAFT("DRAFT", "草稿"),

    /**
     * 配置中
     */
    CONFIGURING("CONFIGURING", "配置中"),

    /**
     * 测试中
     */
    TESTING("TESTING", "测试中"),

    /**
     * 已发布
     */
    PUBLISHED("PUBLISHED", "已发布"),

    /**
     * 运行中
     */
    RUNNING("RUNNING", "运行中"),

    /**
     * 已暂停
     */
    PAUSED("PAUSED", "已暂停"),

    /**
     * 维护中
     */
    MAINTENANCE("MAINTENANCE", "维护中"),

    /**
     * 已停用
     */
    DISABLED("DISABLED", "已停用"),

    /**
     * 异常状态
     */
    ERROR("ERROR", "异常状态"),

    /**
     * 已删除
     */
    DELETED("DELETED", "已删除");

    @EnumValue
    @JsonValue
    private final String code;

    private final String description;

    AgentStatus(String code, String description) {
        this.code = code;
        this.description = description;
    }

    public static AgentStatus fromCode(String code) {
        for (AgentStatus status : values()) {
            if (status.getCode().equals(code)) {
                return status;
            }
        }
        throw new IllegalArgumentException("未知的智能体状态: " + code);
    }
}