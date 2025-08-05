package com.wework.platform.monitor.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * 监控服务配置
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Configuration
@ConfigurationProperties(prefix = "app.monitor")
public class MonitorServiceConfig {

    /**
     * 指标相关配置
     */
    private MetricConfig metric = new MetricConfig();

    /**
     * 告警相关配置
     */
    private AlertConfig alert = new AlertConfig();

    /**
     * 清理任务配置
     */
    private CleanupConfig cleanup = new CleanupConfig();

    /**
     * 通知配置
     */
    private NotificationConfig notification = new NotificationConfig();

    @Data
    public static class MetricConfig {
        /**
         * 指标数据保留天数
         */
        private Integer retentionDays = 30;

        /**
         * 批量插入大小
         */
        private Integer batchSize = 100;

        /**
         * 最大查询记录数
         */
        private Integer maxQueryLimit = 1000;

        /**
         * 是否启用指标压缩
         */
        private Boolean enableCompression = true;
    }

    @Data
    public static class AlertConfig {
        /**
         * 告警数据保留天数
         */
        private Integer retentionDays = 90;

        /**
         * 规则评估间隔(秒)
         */
        private Integer evaluationInterval = 60;

        /**
         * 最大告警数量
         */
        private Integer maxAlertCount = 10000;

        /**
         * 是否启用自动评估
         */
        private Boolean enableAutoEvaluation = true;

        /**
         * 通知重试次数
         */
        private Integer notificationRetryCount = 3;

        /**
         * 通知超时时间(秒)
         */
        private Integer notificationTimeout = 30;
    }

    @Data
    public static class CleanupConfig {
        /**
         * 清理任务执行时间(cron表达式)
         */
        private String cronExpression = "0 0 2 * * ?";

        /**
         * 是否启用自动清理
         */
        private Boolean enableAutoCleanup = true;

        /**
         * 清理批次大小
         */
        private Integer batchSize = 1000;
    }

    @Data
    public static class NotificationConfig {
        /**
         * 是否启用邮件通知
         */
        private Boolean enableEmail = true;

        /**
         * 是否启用短信通知
         */
        private Boolean enableSms = false;

        /**
         * 是否启用Webhook通知
         */
        private Boolean enableWebhook = true;

        /**
         * 是否启用企微通知
         */
        private Boolean enableWeWork = true;

        /**
         * 邮件服务器配置
         */
        private EmailConfig email = new EmailConfig();

        /**
         * Webhook配置
         */
        private WebhookConfig webhook = new WebhookConfig();
    }

    @Data
    public static class EmailConfig {
        /**
         * 邮件服务器地址
         */
        private String host;

        /**
         * 邮件服务器端口
         */
        private Integer port = 587;

        /**
         * 用户名
         */
        private String username;

        /**
         * 密码
         */
        private String password;

        /**
         * 发送者邮箱
         */
        private String from;

        /**
         * 是否启用SSL
         */
        private Boolean enableSsl = true;
    }

    @Data
    public static class WebhookConfig {
        /**
         * Webhook URL
         */
        private String url;

        /**
         * 连接超时时间(秒)
         */
        private Integer connectionTimeout = 10;

        /**
         * 读取超时时间(秒)
         */
        private Integer readTimeout = 30;

        /**
         * 是否验证SSL证书
         */
        private Boolean verifySSL = true;
    }
}