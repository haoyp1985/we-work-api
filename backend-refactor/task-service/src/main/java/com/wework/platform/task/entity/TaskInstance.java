package com.wework.platform.task.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.wework.platform.common.enums.TaskStatus;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

/**
 * 任务实例表
 * 记录每次任务执行的具体实例
 */
@Data
@EqualsAndHashCode(callSuper = false)
@TableName("task_instances")
public class TaskInstance {

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
     * 任务定义ID
     */
    @TableField("task_definition_id")
    private String taskDefinitionId;

    /**
     * 执行状态
     * PENDING: 待执行
     * RUNNING: 执行中
     * SUCCESS: 执行成功
     * FAILED: 执行失败
     * TIMEOUT: 执行超时
     * CANCELLED: 已取消
     */
    @TableField("execution_status")
    private TaskStatus executionStatus;

    /**
     * 开始执行时间
     */
    @TableField("start_time")
    private LocalDateTime startTime;

    /**
     * 结束执行时间
     */
    @TableField("end_time")
    private LocalDateTime endTime;

    /**
     * 执行耗时（毫秒）
     */
    @TableField("execution_duration")
    private Long executionDuration;

    /**
     * 执行结果
     */
    @TableField("execution_result")
    private String executionResult;

    /**
     * 错误信息
     */
    @TableField("error_message")
    private String errorMessage;

    /**
     * 错误堆栈
     */
    @TableField("error_stack")
    private String errorStack;

    /**
     * 执行参数
     */
    @TableField("execution_params")
    private String executionParams;

    /**
     * 执行节点
     */
    @TableField("execution_node")
    private String executionNode;

    /**
     * 重试次数
     */
    @TableField("retry_count")
    private Integer retryCount;

    /**
     * 最大重试次数
     */
    @TableField("max_retry_count")
    private Integer maxRetryCount;

    /**
     * 下次重试时间
     */
    @TableField("next_retry_time")
    private LocalDateTime nextRetryTime;

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
     * 删除标记
     */
    @TableLogic
    @TableField("deleted_at")
    private LocalDateTime deletedAt;

    /**
     * 版本号（乐观锁）
     */
    @Version
    @TableField("version")
    private Integer version;

    /**
     * 获取任务定义ID（用于兼容接口调用）
     */
    public String getDefinitionId() {
        return this.taskDefinitionId;
    }

    /**
     * 设置任务定义ID（用于兼容接口调用）
     */
    public void setDefinitionId(String definitionId) {
        this.taskDefinitionId = definitionId;
    }

    /**
     * 设置执行状态（用于兼容接口调用）
     */
    public void setStatus(TaskStatus status) {
        this.executionStatus = status;
    }

    /**
     * 获取执行状态（用于兼容接口调用）
     */
    public TaskStatus getStatus() {
        return this.executionStatus;
    }

    // 实例名称字段不存在，移除错误的方法

    /**
     * 获取执行节点
     */
    public String getExecutionNode() {
        return this.executionNode;
    }

    /**
     * 设置执行节点
     */
    public void setExecutionNode(String executionNode) {
        this.executionNode = executionNode;
    }

    // 实例名称字段不存在于TaskInstance实体中，移除错误方法

    /**
     * 获取重试次数
     */
    public Integer getRetryCount() {
        return this.retryCount;
    }

    /**
     * 设置下次重试时间
     */
    public void setNextRetryTime(LocalDateTime nextRetryTime) {
        this.nextRetryTime = nextRetryTime;
    }

    /**
     * 设置错误信息
     */
    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    /**
     * 设置开始时间
     */
    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }

    /**
     * 设置结束时间
     */
    public void setEndTime(LocalDateTime endTime) {
        this.endTime = endTime;
    }

    /**
     * 设置结果数据（存储到executionResult字段）
     */
    public void setResultData(Object resultData) {
        if (resultData != null) {
            this.executionResult = resultData.toString();
        }
    }
}