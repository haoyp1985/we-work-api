package com.wework.platform.message.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wework.platform.common.core.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

/**
 * 消息任务实体
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("message_tasks")
public class MessageTask extends BaseEntity {

    /**
     * 任务ID
     */
    @TableId(type = IdType.ASSIGN_ID)
    private String id;

    /**
     * 租户ID
     */
    private String tenantId;

    /**
     * 任务名称
     */
    private String taskName;

    /**
     * 任务类型 (1:即时发送, 2:定时发送, 3:周期发送)
     */
    private Integer taskType;

    /**
     * 发送方式 (1:单发, 2:群发, 3:朋友圈)
     */
    private Integer sendType;

    /**
     * 账号ID列表 (JSON数组)
     */
    private String accountIds;

    /**
     * 接收者列表 (JSON格式)
     */
    private String receivers;

    /**
     * 消息内容 (JSON格式)
     */
    private String messageContent;

    /**
     * 模板ID
     */
    private String templateId;

    /**
     * 模板参数 (JSON格式)
     */
    private String templateParams;

    /**
     * 任务状态 (0:待执行, 1:执行中, 2:已完成, 3:已取消, 4:执行失败)
     */
    private Integer taskStatus;

    /**
     * 计划发送时间
     */
    private LocalDateTime scheduleTime;

    /**
     * 开始执行时间
     */
    private LocalDateTime startTime;

    /**
     * 完成时间
     */
    private LocalDateTime completeTime;

    /**
     * 总接收者数量
     */
    private Integer totalCount;

    /**
     * 已发送数量
     */
    private Integer sentCount;

    /**
     * 成功数量
     */
    private Integer successCount;

    /**
     * 失败数量
     */
    private Integer failCount;

    /**
     * 进度百分比
     */
    private Integer progress;

    /**
     * 错误信息
     */
    private String errorMessage;

    /**
     * 重试配置 (JSON格式)
     */
    private String retryConfig;

    /**
     * 发送策略 (JSON格式)
     */
    private String sendStrategy;

    /**
     * 周期配置 (CRON表达式)
     */
    private String cronExpression;

    /**
     * 下次执行时间
     */
    private LocalDateTime nextExecuteTime;

    /**
     * 执行次数
     */
    private Integer executeCount;

    /**
     * 最大执行次数
     */
    private Integer maxExecuteCount;

    /**
     * 创建人ID
     */
    private String creatorId;

    /**
     * 创建人名称
     */
    private String creatorName;

    /**
     * 审核状态 (0:待审核, 1:审核通过, 2:审核拒绝)
     */
    private Integer auditStatus;

    /**
     * 审核人ID
     */
    private String auditorId;

    /**
     * 审核时间
     */
    private Long auditTime;

    /**
     * 审核备注
     */
    private String auditRemark;

    /**
     * 回调配置 (JSON格式)
     */
    private String callbackConfig;

    /**
     * 扩展配置 (JSON格式)
     */
    private String extConfig;

    /**
     * 备注
     */
    private String remark;
}