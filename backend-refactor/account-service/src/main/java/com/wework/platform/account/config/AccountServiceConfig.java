package com.wework.platform.account.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * Account Service 配置类
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Configuration
@EnableAsync
@EnableScheduling
@ConfigurationProperties(prefix = "app.account")
public class AccountServiceConfig {

    /**
     * 每个租户最大账号数量
     */
    private Integer maxAccountsPerTenant = 100;

    /**
     * 登录超时时间（秒）
     */
    private Integer loginTimeout = 300;

    /**
     * 心跳检测间隔（秒）
     */
    private Integer heartbeatInterval = 30;

    /**
     * 同步配置
     */
    private SyncConfig sync = new SyncConfig();

    /**
     * 企微API配置
     */
    private WeWorkConfig wework = new WeWorkConfig();

    // Getters and Setters
    public Integer getMaxAccountsPerTenant() {
        return maxAccountsPerTenant;
    }

    public void setMaxAccountsPerTenant(Integer maxAccountsPerTenant) {
        this.maxAccountsPerTenant = maxAccountsPerTenant;
    }

    public Integer getLoginTimeout() {
        return loginTimeout;
    }

    public void setLoginTimeout(Integer loginTimeout) {
        this.loginTimeout = loginTimeout;
    }

    public Integer getHeartbeatInterval() {
        return heartbeatInterval;
    }

    public void setHeartbeatInterval(Integer heartbeatInterval) {
        this.heartbeatInterval = heartbeatInterval;
    }

    public SyncConfig getSync() {
        return sync;
    }

    public void setSync(SyncConfig sync) {
        this.sync = sync;
    }

    public WeWorkConfig getWework() {
        return wework;
    }

    public void setWework(WeWorkConfig wework) {
        this.wework = wework;
    }

    /**
     * 同步配置
     */
    public static class SyncConfig {
        /**
         * 批量处理大小
         */
        private Integer batchSize = 100;

        /**
         * 最大重试次数
         */
        private Integer maxRetry = 3;

        /**
         * 超时时间（秒）
         */
        private Integer timeout = 30;

        // Getters and Setters
        public Integer getBatchSize() {
            return batchSize;
        }

        public void setBatchSize(Integer batchSize) {
            this.batchSize = batchSize;
        }

        public Integer getMaxRetry() {
            return maxRetry;
        }

        public void setMaxRetry(Integer maxRetry) {
            this.maxRetry = maxRetry;
        }

        public Integer getTimeout() {
            return timeout;
        }

        public void setTimeout(Integer timeout) {
            this.timeout = timeout;
        }
    }

    /**
     * 企微API配置
     */
    public static class WeWorkConfig {
        /**
         * API基础URL
         */
        private String apiBaseUrl = "http://localhost:9999";

        /**
         * 超时时间（秒）
         */
        private Integer timeout = 30;

        /**
         * 重试次数
         */
        private Integer retry = 3;

        // Getters and Setters
        public String getApiBaseUrl() {
            return apiBaseUrl;
        }

        public void setApiBaseUrl(String apiBaseUrl) {
            this.apiBaseUrl = apiBaseUrl;
        }

        public Integer getTimeout() {
            return timeout;
        }

        public void setTimeout(Integer timeout) {
            this.timeout = timeout;
        }

        public Integer getRetry() {
            return retry;
        }

        public void setRetry(Integer retry) {
            this.retry = retry;
        }
    }
}