package com.wework.platform.message.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 创建任务请求
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateTaskRequest implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 任务名称
     */
    @NotBlank(message = "任务名称不能为空")
    private String taskName;

    /**
     * 任务类型 (1:即时发送, 2:定时发送, 3:周期发送)
     */
    @NotNull(message = "任务类型不能为空")
    private Integer taskType;

    /**
     * 发送方式 (1:单发, 2:群发, 3:朋友圈)
     */
    @NotNull(message = "发送方式不能为空")
    private Integer sendType;

    /**
     * 账号ID列表
     */
    @NotNull(message = "账号列表不能为空")
    private List<String> accountIds;

    /**
     * 接收者配置
     */
    @NotNull(message = "接收者配置不能为空")
    private ReceiverConfig receivers;

    /**
     * 消息内容 (与模板二选一)
     */
    private SendMessageRequest.MessageContent messageContent;

    /**
     * 模板配置 (与消息内容二选一)
     */
    private TemplateConfig templateConfig;

    /**
     * 计划发送时间 (定时发送时必填)
     */
    private LocalDateTime scheduleTime;

    /**
     * 周期配置 (周期发送时必填)
     */
    private PeriodicConfig periodicConfig;

    /**
     * 发送策略
     */
    private SendStrategy sendStrategy;

    /**
     * 回调配置
     */
    private CallbackConfig callbackConfig;

    /**
     * 备注
     */
    private String remark;

    /**
     * 接收者配置
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ReceiverConfig {
        /**
         * 接收者类型 (1:指定用户, 2:指定群组, 3:标签筛选, 4:条件筛选)
         */
        private Integer receiverType;

        /**
         * 用户ID列表 (接收者类型为1时)
         */
        private List<String> userIds;

        /**
         * 群组ID列表 (接收者类型为2时)
         */
        private List<String> groupIds;

        /**
         * 标签ID列表 (接收者类型为3时)
         */
        private List<String> tagIds;

        /**
         * 筛选条件 (接收者类型为4时)
         */
        private Map<String, Object> filterConditions;

        /**
         * 排除的用户ID列表
         */
        private List<String> excludeUserIds;
    }

    /**
     * 模板配置
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TemplateConfig {
        /**
         * 模板ID
         */
        @NotBlank(message = "模板ID不能为空")
        private String templateId;

        /**
         * 模板参数
         */
        private Map<String, Object> templateParams;
    }

    /**
     * 周期配置
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class PeriodicConfig {
        /**
         * CRON表达式
         */
        @NotBlank(message = "CRON表达式不能为空")
        private String cronExpression;

        /**
         * 开始时间
         */
        private LocalDateTime startTime;

        /**
         * 结束时间
         */
        private LocalDateTime endTime;

        /**
         * 最大执行次数
         */
        private Integer maxExecuteCount;
    }

    /**
     * 发送策略
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class SendStrategy {
        /**
         * 发送速率 (每分钟发送数量)
         */
        private Integer sendRate;

        /**
         * 发送时段 (格式: HH:mm-HH:mm)
         */
        private List<String> sendTimeRanges;

        /**
         * 失败处理 (1:跳过, 2:重试)
         */
        private Integer failureHandling = 2;

        /**
         * 重试配置
         */
        private SendMessageRequest.RetryConfig retryConfig;
    }

    /**
     * 回调配置
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CallbackConfig {
        /**
         * 回调URL
         */
        private String callbackUrl;

        /**
         * 回调事件 (1:任务开始, 2:任务完成, 3:任务失败, 4:消息发送成功, 5:消息发送失败)
         */
        private List<Integer> callbackEvents;

        /**
         * 回调认证信息
         */
        private Map<String, String> authHeaders;
    }
}