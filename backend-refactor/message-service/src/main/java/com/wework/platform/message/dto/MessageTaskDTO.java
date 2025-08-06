package com.wework.platform.message.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * 消息任务数据传输对象
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MessageTaskDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 任务ID
     */
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
     * 任务类型名称
     */
    private String taskTypeName;

    /**
     * 发送方式 (1:单发, 2:群发, 3:朋友圈)
     */
    private Integer sendType;

    /**
     * 发送方式名称
     */
    private String sendTypeName;

    /**
     * 账号信息
     */
    private List<AccountInfo> accounts;

    /**
     * 接收者信息
     */
    private ReceiverInfo receivers;

    /**
     * 消息内容
     */
    private SendMessageRequest.MessageContent messageContent;

    /**
     * 模板信息
     */
    private TemplateInfo templateInfo;

    /**
     * 任务状态 (0:待执行, 1:执行中, 2:已完成, 3:已取消, 4:执行失败)
     */
    private Integer taskStatus;

    /**
     * 任务状态名称
     */
    private String taskStatusName;

    /**
     * 计划发送时间
     */
    private Long scheduleTime;

    /**
     * 开始执行时间
     */
    private Long startTime;

    /**
     * 完成时间
     */
    private Long completeTime;

    /**
     * 总数量
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
     * 成功率
     */
    private Double successRate;

    /**
     * 错误信息
     */
    private String errorMessage;

    /**
     * 周期配置
     */
    private String cronExpression;

    /**
     * 下次执行时间
     */
    private Long nextExecuteTime;

    /**
     * 执行次数
     */
    private Integer executeCount;

    /**
     * 最大执行次数
     */
    private Integer maxExecuteCount;

    /**
     * 创建人信息
     */
    private CreatorInfo creator;

    /**
     * 审核状态 (0:待审核, 1:审核通过, 2:审核拒绝)
     */
    private Integer auditStatus;

    /**
     * 审核状态名称
     */
    private String auditStatusName;

    /**
     * 审核信息
     */
    private AuditInfo auditInfo;

    /**
     * 创建时间
     */
    private Long createdAt;

    /**
     * 更新时间
     */
    private Long updatedAt;

    /**
     * 备注
     */
    private String remark;

    /**
     * 审核时间
     */
    private Long auditTime;

    /**
     * 账号信息
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class AccountInfo {
        private String accountId;
        private String accountName;
        private String status;
    }

    /**
     * 接收者信息
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ReceiverInfo {
        private Integer totalCount;
        private List<String> userIds;
        private List<String> groupIds;
        private Map<String, String> userNames;
        private Map<String, String> groupNames;
    }

    /**
     * 模板信息
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TemplateInfo {
        private String templateId;
        private String templateName;
        private String templateCode;
        private Map<String, Object> templateParams;
    }

    /**
     * 创建人信息
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CreatorInfo {
        private String creatorId;
        private String creatorName;
        private String department;
    }

    /**
     * 审核信息
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class AuditInfo {
        private String auditorId;
        private String auditorName;
        private Long auditTime;
        private String auditRemark;
    }
}