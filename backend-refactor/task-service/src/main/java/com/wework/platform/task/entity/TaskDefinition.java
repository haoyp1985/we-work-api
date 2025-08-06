package com.wework.platform.task.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.wework.platform.common.enums.TaskStatus;
import com.wework.platform.common.enums.TaskType;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

/**
 * 任务定义实体
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@EqualsAndHashCode(callSuper = false)
@TableName("task_definitions")
public class TaskDefinition {

    /**
     * 主键ID
     */
    @TableId(value = "id", type = IdType.ASSIGN_UUID)
    private String id;

    /**
     * 租户ID
     */
    @TableField("tenant_id")
    private String tenantId;

    /**
     * 任务名称
     */
    @TableField("task_name")
    private String taskName;

    /**
     * 任务描述
     */
    @TableField("description")
    private String description;

    /**
     * 任务类型
     */
    @TableField("task_type")
    private TaskType taskType;

    /**
     * 任务状态
     */
    @TableField("status")
    private TaskStatus status;

    /**
     * 任务执行类
     */
    @TableField("task_class")
    private String taskClass;

    /**
     * 任务方法名
     */
    @TableField("task_method")
    private String taskMethod;

    /**
     * 任务参数(JSON格式)
     */
    @TableField("task_params")
    private String taskParams;

    /**
     * Cron表达式
     */
    @TableField("cron_expression")
    private String cronExpression;

    /**
     * 固定间隔(秒)
     */
    @TableField("fixed_rate")
    private Integer fixedRate;

    /**
     * 固定延迟(秒)
     */
    @TableField("fixed_delay")
    private Integer fixedDelay;

    /**
     * 优先级(1-10，数字越大优先级越高)
     */
    @TableField("priority")
    private Integer priority;

    /**
     * 最大重试次数
     */
    @TableField("max_retry_count")
    private Integer maxRetryCount;

    /**
     * 当前重试次数
     */
    @TableField("retry_count")
    private Integer retryCount;

    /**
     * 超时时间(秒)
     */
    @TableField("timeout_seconds")
    private Integer timeoutSeconds;

    /**
     * 是否启用
     */
    @TableField("enabled")
    private Boolean enabled;

    /**
     * 上次执行时间
     */
    @TableField("last_executed_at")
    private LocalDateTime lastExecutedAt;

    /**
     * 下次执行时间
     */
    @TableField("next_execute_at")
    private LocalDateTime nextExecuteAt;

    /**
     * 创建时间
     */
    @TableField(value = "created_at", fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    /**
     * 更新时间
     */
    @TableField(value = "updated_at", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;

    /**
     * 创建人
     */
    @TableField(value = "created_by", fill = FieldFill.INSERT)
    private String createdBy;

    /**
     * 更新人
     */
    @TableField(value = "updated_by", fill = FieldFill.INSERT_UPDATE)
    private String updatedBy;

    /**
     * 软删除时间
     */
    @TableField("deleted_at")
    @TableLogic
    private LocalDateTime deletedAt;

    /**
     * 获取处理器类名（用于兼容接口调用）
     */
    public String getHandlerClass() {
        return this.taskClass;
    }

    /**
     * 设置处理器类名（用于兼容接口调用）
     */
    public void setHandlerClass(String handlerClass) {
        this.taskClass = handlerClass;
    }

    /**
     * 获取ID（Lombok生成的方法别名）
     */
    public String getId() {
        return this.definitionId;
    }

    /**
     * 获取参数
     */
    public String getParameters() {
        return this.defaultParameters;
    }

    /**
     * 获取最大重试次数
     */
    public Integer getMaxRetryCount() {
        return this.maxRetryCount;
    }

    /**
     * 获取重试间隔秒数
     */
    public Integer getRetryIntervalSeconds() {
        return this.retryIntervalSeconds;
    }
}