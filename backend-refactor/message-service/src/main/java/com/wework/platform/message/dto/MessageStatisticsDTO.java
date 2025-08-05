package com.wework.platform.message.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * 消息统计数据传输对象
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MessageStatisticsDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 统计时间范围
     */
    private TimeRange timeRange;

    /**
     * 总体统计
     */
    private OverallStatistics overall;

    /**
     * 消息类型统计
     */
    private List<TypeStatistics> messageTypeStats;

    /**
     * 发送方式统计
     */
    private List<TypeStatistics> sendTypeStats;

    /**
     * 账号统计
     */
    private List<AccountStatistics> accountStats;

    /**
     * 时间趋势统计
     */
    private List<TrendStatistics> trendStats;

    /**
     * 模板使用统计
     */
    private List<TemplateStatistics> templateStats;

    /**
     * 错误分析
     */
    private List<ErrorStatistics> errorStats;

    /**
     * 时间范围
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TimeRange {
        private Long startTime;
        private Long endTime;
        private String startTimeStr;
        private String endTimeStr;
    }

    /**
     * 总体统计
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class OverallStatistics {
        /**
         * 总消息数
         */
        private Long totalMessages;

        /**
         * 成功数量
         */
        private Long successCount;

        /**
         * 失败数量
         */
        private Long failCount;

        /**
         * 待发送数量
         */
        private Long pendingCount;

        /**
         * 成功率
         */
        private Double successRate;

        /**
         * 平均发送时长（秒）
         */
        private Double avgSendDuration;

        /**
         * 总任务数
         */
        private Long totalTasks;

        /**
         * 活跃账号数
         */
        private Integer activeAccounts;

        /**
         * 覆盖用户数
         */
        private Long coveredUsers;

        /**
         * 覆盖群组数
         */
        private Long coveredGroups;
    }

    /**
     * 类型统计
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TypeStatistics {
        /**
         * 类型值
         */
        private Integer type;

        /**
         * 类型名称
         */
        private String typeName;

        /**
         * 消息数量
         */
        private Long messageCount;

        /**
         * 成功数量
         */
        private Long successCount;

        /**
         * 失败数量
         */
        private Long failCount;

        /**
         * 成功率
         */
        private Double successRate;

        /**
         * 占比
         */
        private Double percentage;
    }

    /**
     * 账号统计
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class AccountStatistics {
        /**
         * 账号ID
         */
        private String accountId;

        /**
         * 账号名称
         */
        private String accountName;

        /**
         * 发送数量
         */
        private Long messageCount;

        /**
         * 成功数量
         */
        private Long successCount;

        /**
         * 失败数量
         */
        private Long failCount;

        /**
         * 成功率
         */
        private Double successRate;

        /**
         * 最后发送时间
         */
        private Long lastSendTime;
    }

    /**
     * 趋势统计
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TrendStatistics {
        /**
         * 时间点
         */
        private Long timestamp;

        /**
         * 时间字符串
         */
        private String timeStr;

        /**
         * 发送数量
         */
        private Long sendCount;

        /**
         * 成功数量
         */
        private Long successCount;

        /**
         * 失败数量
         */
        private Long failCount;

        /**
         * 成功率
         */
        private Double successRate;
    }

    /**
     * 模板统计
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TemplateStatistics {
        /**
         * 模板ID
         */
        private String templateId;

        /**
         * 模板名称
         */
        private String templateName;

        /**
         * 使用次数
         */
        private Long useCount;

        /**
         * 成功次数
         */
        private Long successCount;

        /**
         * 失败次数
         */
        private Long failCount;

        /**
         * 成功率
         */
        private Double successRate;

        /**
         * 热度评分
         */
        private Double hotScore;
    }

    /**
     * 错误统计
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ErrorStatistics {
        /**
         * 错误码
         */
        private String errorCode;

        /**
         * 错误描述
         */
        private String errorMessage;

        /**
         * 出现次数
         */
        private Long errorCount;

        /**
         * 占比
         */
        private Double percentage;

        /**
         * 受影响账号
         */
        private List<String> affectedAccounts;

        /**
         * 首次出现时间
         */
        private Long firstOccurTime;

        /**
         * 最后出现时间
         */
        private Long lastOccurTime;
    }
}