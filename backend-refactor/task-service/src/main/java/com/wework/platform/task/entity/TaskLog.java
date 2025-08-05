package com.wework.platform.task.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 任务执行日志实体
 * 记录任务执行过程中的详细日志信息
 * 
 * @author WeWork Platform Team
 * @since 1.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("task_logs")
@Schema(description = "任务执行日志")
public class TaskLog {

    /**
     * 日志ID
     */
    @TableId(value = "id", type = IdType.ASSIGN_UUID)
    @Schema(description = "日志ID", example = "550e8400-e29b-41d4-a716-446655440000")
    private String id;

    /**
     * 租户ID
     */
    @TableField("tenant_id")
    @Schema(description = "租户ID", example = "tenant_001")
    private String tenantId;

    /**
     * 任务实例ID
     */
    @TableField("instance_id")
    @Schema(description = "任务实例ID", example = "550e8400-e29b-41d4-a716-446655440001")
    private String instanceId;

    /**
     * 日志级别
     */
    @TableField("log_level")
    @Schema(description = "日志级别", example = "INFO", allowableValues = {"DEBUG", "INFO", "WARN", "ERROR"})
    private String logLevel;

    /**
     * 日志内容
     */
    @TableField("log_content")
    @Schema(description = "日志内容", example = "任务开始执行...")
    private String logContent;

    /**
     * 异常堆栈信息
     */
    @TableField("exception_stack")
    @Schema(description = "异常堆栈信息")
    private String exceptionStack;

    /**
     * 执行节点
     */
    @TableField("execution_node")
    @Schema(description = "执行节点", example = "node-001")
    private String executionNode;

    /**
     * 执行步骤
     */
    @TableField("execution_step")
    @Schema(description = "执行步骤", example = "数据预处理")
    private String executionStep;

    /**
     * 扩展数据
     */
    @TableField(value = "extra_data", typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    @Schema(description = "扩展数据")
    private Object extraData;

    /**
     * 日志时间
     */
    @TableField("log_time")
    @Schema(description = "日志时间", example = "2024-01-15T10:30:00")
    private LocalDateTime logTime;

    /**
     * 创建时间
     */
    @TableField(value = "created_at", fill = FieldFill.INSERT)
    @Schema(description = "创建时间", example = "2024-01-15T10:30:00")
    private LocalDateTime createdAt;

    /**
     * 日志级别枚举
     */
    public enum LogLevel {
        DEBUG("DEBUG", "调试"),
        INFO("INFO", "信息"),
        WARN("WARN", "警告"),
        ERROR("ERROR", "错误");

        private final String code;
        private final String description;

        LogLevel(String code, String description) {
            this.code = code;
            this.description = description;
        }

        public String getCode() {
            return code;
        }

        public String getDescription() {
            return description;
        }

        public static LogLevel fromCode(String code) {
            for (LogLevel level : values()) {
                if (level.code.equals(code)) {
                    return level;
                }
            }
            throw new IllegalArgumentException("Unknown log level: " + code);
        }
    }

    /**
     * 创建信息日志
     */
    public static TaskLog info(String instanceId, String tenantId, String content) {
        return TaskLog.builder()
                .instanceId(instanceId)
                .tenantId(tenantId)
                .logLevel(LogLevel.INFO.getCode())
                .logContent(content)
                .logTime(LocalDateTime.now())
                .build();
    }

    /**
     * 创建错误日志
     */
    public static TaskLog error(String instanceId, String tenantId, String content, String exceptionStack) {
        return TaskLog.builder()
                .instanceId(instanceId)
                .tenantId(tenantId)
                .logLevel(LogLevel.ERROR.getCode())
                .logContent(content)
                .exceptionStack(exceptionStack)
                .logTime(LocalDateTime.now())
                .build();
    }

    /**
     * 创建警告日志
     */
    public static TaskLog warn(String instanceId, String tenantId, String content) {
        return TaskLog.builder()
                .instanceId(instanceId)
                .tenantId(tenantId)
                .logLevel(LogLevel.WARN.getCode())
                .logContent(content)
                .logTime(LocalDateTime.now())
                .build();
    }

    /**
     * 创建调试日志
     */
    public static TaskLog debug(String instanceId, String tenantId, String content) {
        return TaskLog.builder()
                .instanceId(instanceId)
                .tenantId(tenantId)
                .logLevel(LogLevel.DEBUG.getCode())
                .logContent(content)
                .logTime(LocalDateTime.now())
                .build();
    }
}