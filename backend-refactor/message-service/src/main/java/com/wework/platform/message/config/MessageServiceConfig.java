package com.wework.platform.message.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import java.time.Duration;
import java.util.List;

/**
 * 消息服务配置
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Configuration
@ConfigurationProperties(prefix = "app.message")
public class MessageServiceConfig {

    /**
     * 企业微信配置
     */
    private WeWorkConfig weWork = new WeWorkConfig();

    /**
     * 消息发送配置
     */
    private SendConfig send = new SendConfig();

    /**
     * 模板配置
     */
    private TemplateConfig template = new TemplateConfig();

    /**
     * 任务调度配置
     */
    private TaskConfig task = new TaskConfig();

    /**
     * 重试配置
     */
    private RetryConfig retry = new RetryConfig();

    /**
     * 限流配置
     */
    private RateLimitConfig rateLimit = new RateLimitConfig();

    /**
     * 企业微信配置
     */
    @Data
    public static class WeWorkConfig {
        /**
         * API基础URL
         */
        private String apiBaseUrl = "https://qyapi.weixin.qq.com";

        /**
         * 连接超时时间(毫秒)
         */
        private Duration connectTimeout = Duration.ofSeconds(10);

        /**
         * 读取超时时间(毫秒)
         */
        private Duration readTimeout = Duration.ofSeconds(30);

        /**
         * 最大重试次数
         */
        private Integer maxRetries = 3;

        /**
         * 重试间隔(毫秒)
         */
        private Duration retryInterval = Duration.ofSeconds(2);

        /**
         * 是否启用SSL验证
         */
        private Boolean sslEnabled = true;

        /**
         * 用户代理
         */
        private String userAgent = "WeWork-Platform/2.0.0";
    }

    /**
     * 消息发送配置
     */
    @Data
    public static class SendConfig {
        /**
         * 单次最大发送数量
         */
        private Integer maxBatchSize = 100;

        /**
         * 发送超时时间(毫秒)
         */
        private Duration sendTimeout = Duration.ofMinutes(5);

        /**
         * 是否启用异步发送
         */
        private Boolean asyncEnabled = true;

        /**
         * 异步发送线程池大小
         */
        private Integer asyncThreadPoolSize = 10;

        /**
         * 是否记录发送日志
         */
        private Boolean logEnabled = true;

        /**
         * 是否启用消息去重
         */
        private Boolean deduplicationEnabled = true;

        /**
         * 去重缓存过期时间(分钟)
         */
        private Duration deduplicationCacheExpire = Duration.ofMinutes(30);

        /**
         * 支持的消息类型
         */
        private List<Integer> supportedTypes = List.of(0, 1, 2, 3, 4, 5);
    }

    /**
     * 模板配置
     */
    @Data
    public static class TemplateConfig {
        /**
         * 模板内容最大长度
         */
        private Integer maxContentLength = 4000;

        /**
         * 模板参数最大数量
         */
        private Integer maxParameterCount = 50;

        /**
         * 参数名称最大长度
         */
        private Integer maxParameterNameLength = 50;

        /**
         * 是否启用模板缓存
         */
        private Boolean cacheEnabled = true;

        /**
         * 模板缓存过期时间(分钟)
         */
        private Duration cacheExpire = Duration.ofMinutes(60);

        /**
         * 是否启用模板语法检查
         */
        private Boolean syntaxCheckEnabled = true;

        /**
         * 支持的占位符前缀
         */
        private List<String> placeholderPrefixes = List.of("${", "{{");

        /**
         * 支持的占位符后缀
         */
        private List<String> placeholderSuffixes = List.of("}", "}}");
    }

    /**
     * 任务调度配置
     */
    @Data
    public static class TaskConfig {
        /**
         * 任务扫描间隔(秒)
         */
        private Duration scanInterval = Duration.ofSeconds(30);

        /**
         * 单次处理任务数量
         */
        private Integer batchSize = 10;

        /**
         * 任务执行超时时间(分钟)
         */
        private Duration executionTimeout = Duration.ofMinutes(30);

        /**
         * 是否启用任务监控
         */
        private Boolean monitoringEnabled = true;

        /**
         * 任务日志保留天数
         */
        private Integer logRetentionDays = 30;

        /**
         * 是否启用任务优先级
         */
        private Boolean priorityEnabled = true;

        /**
         * 最大并发执行任务数
         */
        private Integer maxConcurrentTasks = 5;

        /**
         * 任务队列最大长度
         */
        private Integer maxQueueSize = 1000;
    }

    /**
     * 重试配置
     */
    @Data
    public static class RetryConfig {
        /**
         * 是否启用自动重试
         */
        private Boolean enabled = true;

        /**
         * 最大重试次数
         */
        private Integer maxAttempts = 3;

        /**
         * 重试间隔(秒)
         */
        private Duration retryInterval = Duration.ofSeconds(30);

        /**
         * 重试退避策略 (FIXED, EXPONENTIAL, LINEAR)
         */
        private String backoffStrategy = "EXPONENTIAL";

        /**
         * 退避乘数
         */
        private Double backoffMultiplier = 2.0;

        /**
         * 最大重试间隔(分钟)
         */
        private Duration maxRetryInterval = Duration.ofMinutes(30);

        /**
         * 需要重试的异常类型
         */
        private List<String> retryableExceptions = List.of(
                "java.net.SocketTimeoutException",
                "java.net.ConnectException",
                "org.springframework.web.client.ResourceAccessException"
        );
    }

    /**
     * 限流配置
     */
    @Data
    public static class RateLimitConfig {
        /**
         * 是否启用限流
         */
        private Boolean enabled = true;

        /**
         * 每秒最大请求数
         */
        private Integer maxRequestsPerSecond = 100;

        /**
         * 每分钟最大请求数
         */
        private Integer maxRequestsPerMinute = 3000;

        /**
         * 每小时最大请求数
         */
        private Integer maxRequestsPerHour = 50000;

        /**
         * 每天最大请求数
         */
        private Integer maxRequestsPerDay = 1000000;

        /**
         * 限流算法 (TOKEN_BUCKET, SLIDING_WINDOW)
         */
        private String algorithm = "TOKEN_BUCKET";

        /**
         * 是否启用租户级别限流
         */
        private Boolean tenantLevelEnabled = true;

        /**
         * 是否启用用户级别限流
         */
        private Boolean userLevelEnabled = true;
    }
}