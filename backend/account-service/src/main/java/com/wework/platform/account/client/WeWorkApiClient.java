package com.wework.platform.account.client;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.wework.platform.common.exception.BusinessException;
import com.wework.platform.common.service.TenantQuotaService;
import com.wework.platform.common.dto.TenantQuotaCheckResult;
import com.wework.platform.common.tenant.TenantContext;
import com.wework.platform.common.tenant.TenantRequired;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;
import org.springframework.retry.annotation.Backoff;
import org.springframework.retry.annotation.Retryable;

import jakarta.annotation.PostConstruct;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 企微API客户端 - 支持多租户
 *
 * @author WeWork Platform Team
 */
@Slf4j
@Component
@RequiredArgsConstructor
@TenantRequired
public class WeWorkApiClient {

    private final TenantQuotaService tenantQuotaService;
    
    private WebClient webClient;

    @Value("${wework.api.base-url}")
    private String baseUrl;

    @Value("${wework.api.timeout:30000}")
    private Integer timeout;

    @Value("${wework.api.retry.max-attempts:3}")
    private Integer maxRetryAttempts;

    @Value("${wework.api.retry.delay:1000}")
    private Long retryDelay;

    /**
     * 租户级别的API配置缓存
     */
    private final Map<String, TenantApiConfig> tenantConfigCache = new ConcurrentHashMap<>();

    @PostConstruct
    public void init() {
        this.webClient = WebClient.builder()
                .codecs(configurer -> configurer.defaultCodecs().maxInMemorySize(10 * 1024 * 1024))
                .build();
    }

    /**
     * 创建新实例 - 支持多租户
     */
    @TenantRequired
    @Retryable(value = {Exception.class}, maxAttempts = 3, backoff = @Backoff(delay = 1000))
    public String createInstance(String tenantId, String clientType, String proxy, String bridge) {
        log.info("租户 {} 创建企微实例", tenantId);
        
        // 检查租户账号配额
        checkAccountQuota(tenantId, 1);
        
        String url = baseUrl + "/api/newInstance";
        
        // 获取租户级别的配置
        TenantApiConfig tenantConfig = getTenantApiConfig(tenantId);
        
        JSONObject request = new JSONObject();
        request.put("clientType", clientType != null ? clientType : tenantConfig.getDefaultClientType());
        if (proxy != null) request.put("proxy", proxy);
        if (bridge != null) request.put("bridge", bridge);
        
        // 添加租户回调地址
        if (tenantConfig.getCallbackUrl() != null) {
            request.put("callbackUrl", tenantConfig.getCallbackUrl());
        }

        try {
            log.info("租户 {} 创建企微实例，请求参数: {}", tenantId, request.toJSONString());
            
            long startTime = System.currentTimeMillis();
            
            String response = webClient.post()
                    .uri(url)
                    .header("Content-Type", "application/json")
                    .header("X-Tenant-Id", tenantId)
                    .bodyValue(request.toJSONString())
                    .retrieve()
                    .bodyToMono(String.class)
                    .timeout(Duration.ofMillis(getApiTimeout(tenantId)))
                    .block();

            long responseTime = System.currentTimeMillis() - startTime;
            
            log.info("租户 {} 创建企微实例响应: {}, 耗时: {}ms", tenantId, response, responseTime);
            
            // 记录API使用统计
            recordApiUsage(tenantId, 1, responseTime, true);
            
            JSONObject result = JSON.parseObject(response);
            if (result.getBoolean("success") == Boolean.TRUE) {
                JSONObject data = result.getJSONObject("data");
                String guid = data.getString("guid");
                
                // 记录账号使用
                recordAccountUsage(tenantId);
                
                return guid;
            } else {
                recordApiUsage(tenantId, 1, responseTime, false);
                throw new BusinessException("创建企微实例失败: " + result.getString("message"));
            }
            
        } catch (WebClientResponseException e) {
            recordApiUsage(tenantId, 1, 0, false);
            log.error("租户 {} 创建企微实例请求失败: {}", tenantId, e.getMessage(), e);
            throw new BusinessException("创建企微实例请求失败: " + e.getMessage());
        } catch (Exception e) {
            recordApiUsage(tenantId, 1, 0, false);
            log.error("租户 {} 创建企微实例异常: {}", tenantId, e.getMessage(), e);
            throw new BusinessException("创建企微实例异常: " + e.getMessage());
        }
    }
    
    /**
     * 创建新实例 - 兼容原有接口
     */
    public String createInstance(String clientType, String proxy, String bridge) {
        String tenantId = TenantContext.getTenantId();
        if (tenantId == null) {
            throw new BusinessException("缺少租户上下文");
        }
        return createInstance(tenantId, clientType, proxy, bridge);
    }

    /**
     * 获取登录二维码
     */
    public JSONObject getLoginQRCode(String guid) {
        String url = baseUrl + "/api/getLoginQrcode";
        
        JSONObject request = new JSONObject();
        request.put("guid", guid);

        try {
            log.info("获取登录二维码，GUID: {}", guid);
            
            String response = webClient.post()
                    .uri(url)
                    .header("Content-Type", "application/json")
                    .bodyValue(request.toJSONString())
                    .retrieve()
                    .bodyToMono(String.class)
                    .timeout(Duration.ofMillis(timeout))
                    .block();

            log.debug("获取登录二维码响应: {}", response);
            
            JSONObject result = JSON.parseObject(response);
            if (result.getBoolean("success") == Boolean.TRUE) {
                return result.getJSONObject("data");
            } else {
                throw new BusinessException("获取登录二维码失败: " + result.getString("message"));
            }
            
        } catch (WebClientResponseException e) {
            log.error("获取登录二维码请求失败: {}", e.getMessage(), e);
            throw new BusinessException("获取登录二维码请求失败: " + e.getMessage());
        } catch (Exception e) {
            log.error("获取登录二维码异常: {}", e.getMessage(), e);
            throw new BusinessException("获取登录二维码异常: " + e.getMessage());
        }
    }

    /**
     * 检查登录状态
     */
    public JSONObject checkLogin(String guid) {
        String url = baseUrl + "/api/checkLogin";
        
        JSONObject request = new JSONObject();
        request.put("guid", guid);

        try {
            String response = webClient.post()
                    .uri(url)
                    .header("Content-Type", "application/json")
                    .bodyValue(request.toJSONString())
                    .retrieve()
                    .bodyToMono(String.class)
                    .timeout(Duration.ofMillis(timeout))
                    .block();

            JSONObject result = JSON.parseObject(response);
            if (result.getBoolean("success") == Boolean.TRUE) {
                return result.getJSONObject("data");
            } else {
                return null;
            }
            
        } catch (Exception e) {
            log.warn("检查登录状态异常: {}", e.getMessage());
            return null;
        }
    }

    /**
     * 获取实例状态
     */
    public JSONObject getInstanceStatus(String guid) {
        String url = baseUrl + "/api/getInstanceStatus";
        
        JSONObject request = new JSONObject();
        request.put("guid", guid);

        try {
            String response = webClient.post()
                    .uri(url)
                    .header("Content-Type", "application/json")
                    .bodyValue(request.toJSONString())
                    .retrieve()
                    .bodyToMono(String.class)
                    .timeout(Duration.ofMillis(timeout))
                    .block();

            JSONObject result = JSON.parseObject(response);
            if (result.getBoolean("success") == Boolean.TRUE) {
                return result.getJSONObject("data");
            } else {
                throw new BusinessException("获取实例状态失败: " + result.getString("message"));
            }
            
        } catch (WebClientResponseException e) {
            log.error("获取实例状态请求失败: {}", e.getMessage(), e);
            throw new BusinessException("获取实例状态请求失败: " + e.getMessage());
        } catch (Exception e) {
            log.error("获取实例状态异常: {}", e.getMessage(), e);
            throw new BusinessException("获取实例状态异常: " + e.getMessage());
        }
    }

    /**
     * 停止实例
     */
    public void stopInstance(String guid) {
        String url = baseUrl + "/api/stopInstance";
        
        JSONObject request = new JSONObject();
        request.put("guid", guid);

        try {
            log.info("停止企微实例，GUID: {}", guid);
            
            String response = webClient.post()
                    .uri(url)
                    .header("Content-Type", "application/json")
                    .bodyValue(request.toJSONString())
                    .retrieve()
                    .bodyToMono(String.class)
                    .timeout(Duration.ofMillis(timeout))
                    .block();

            JSONObject result = JSON.parseObject(response);
            if (result.getBoolean("success") != Boolean.TRUE) {
                throw new BusinessException("停止企微实例失败: " + result.getString("message"));
            }
            
        } catch (WebClientResponseException e) {
            log.error("停止企微实例请求失败: {}", e.getMessage(), e);
            throw new BusinessException("停止企微实例请求失败: " + e.getMessage());
        } catch (Exception e) {
            log.error("停止企微实例异常: {}", e.getMessage(), e);
            throw new BusinessException("停止企微实例异常: " + e.getMessage());
        }
    }

    /**
     * 删除实例
     */
    public void deleteInstance(String guid) {
        String url = baseUrl + "/api/deleteInstance";
        
        JSONObject request = new JSONObject();
        request.put("guid", guid);

        try {
            log.info("删除企微实例，GUID: {}", guid);
            
            String response = webClient.post()
                    .uri(url)
                    .header("Content-Type", "application/json")
                    .bodyValue(request.toJSONString())
                    .retrieve()
                    .bodyToMono(String.class)
                    .timeout(Duration.ofMillis(timeout))
                    .block();

            JSONObject result = JSON.parseObject(response);
            if (result.getBoolean("success") != Boolean.TRUE) {
                log.warn("删除企微实例失败: {}", result.getString("message"));
            }
            
        } catch (Exception e) {
            log.warn("删除企微实例异常: {}", e.getMessage());
        }
    }

    /**
     * 验证登录验证码
     */
    public void verifyLoginCode(String guid, String code) {
        String url = baseUrl + "/api/loginByCode";
        
        JSONObject request = new JSONObject();
        request.put("guid", guid);
        request.put("code", code);

        try {
            log.info("验证登录验证码，GUID: {}", guid);
            
            String response = webClient.post()
                    .uri(url)
                    .header("Content-Type", "application/json")
                    .bodyValue(request.toJSONString())
                    .retrieve()
                    .bodyToMono(String.class)
                    .timeout(Duration.ofMillis(timeout))
                    .block();

            JSONObject result = JSON.parseObject(response);
            if (result.getBoolean("success") != Boolean.TRUE) {
                throw new BusinessException("验证登录验证码失败: " + result.getString("message"));
            }
            
        } catch (WebClientResponseException e) {
            log.error("验证登录验证码请求失败: {}", e.getMessage(), e);
            throw new BusinessException("验证登录验证码请求失败: " + e.getMessage());
        } catch (Exception e) {
            log.error("验证登录验证码异常: {}", e.getMessage(), e);
            throw new BusinessException("验证登录验证码异常: " + e.getMessage());
        }
    }

    /**
     * 通用POST请求 - 支持多租户
     */
    @TenantRequired
    public JSONObject post(String tenantId, String endpoint, Map<String, Object> params) {
        // 检查API调用配额
        checkApiQuota(tenantId, 1);
        
        String url = baseUrl + endpoint;
        
        try {
            long startTime = System.currentTimeMillis();
            
            String response = webClient.post()
                    .uri(url)
                    .header("Content-Type", "application/json")
                    .header("X-Tenant-Id", tenantId)
                    .bodyValue(JSON.toJSONString(params))
                    .retrieve()
                    .bodyToMono(String.class)
                    .timeout(Duration.ofMillis(getApiTimeout(tenantId)))
                    .block();

            long responseTime = System.currentTimeMillis() - startTime;
            recordApiUsage(tenantId, 1, responseTime, true);
            
            return JSON.parseObject(response);
            
        } catch (WebClientResponseException e) {
            recordApiUsage(tenantId, 1, 0, false);
            log.error("租户 {} API请求失败: {} - {}", tenantId, url, e.getMessage());
            throw new BusinessException("API请求失败: " + e.getMessage());
        } catch (Exception e) {
            recordApiUsage(tenantId, 1, 0, false);
            log.error("租户 {} API请求异常: {} - {}", tenantId, url, e.getMessage());
            throw new BusinessException("API请求异常: " + e.getMessage());
        }
    }
    
    /**
     * 通用POST请求 - 兼容原有接口
     */
    public JSONObject post(String endpoint, Map<String, Object> params) {
        String tenantId = TenantContext.getTenantId();
        if (tenantId == null) {
            throw new BusinessException("缺少租户上下文");
        }
        return post(tenantId, endpoint, params);
    }

    // ========== 私有辅助方法 ==========

    /**
     * 检查账号配额
     */
    private void checkAccountQuota(String tenantId, int requestCount) {
        TenantQuotaCheckResult result = tenantQuotaService.checkAccountQuota(tenantId, requestCount);
        if (!result.isPassed()) {
            throw new BusinessException("账号配额不足: " + result.getMessage());
        }
    }

    /**
     * 检查API调用配额
     */
    private void checkApiQuota(String tenantId, long requestCount) {
        TenantQuotaCheckResult result = tenantQuotaService.checkApiCallQuota(tenantId, requestCount);
        if (!result.isPassed()) {
            throw new BusinessException("API调用配额不足: " + result.getMessage());
        }
        
        // 检查小时配额
        TenantQuotaCheckResult hourlyResult = tenantQuotaService.checkHourlyApiCallQuota(tenantId, requestCount);
        if (!hourlyResult.isPassed()) {
            throw new BusinessException("API调用频率过高: " + hourlyResult.getMessage());
        }
    }

    /**
     * 记录API使用统计
     */
    private void recordApiUsage(String tenantId, long apiCallCount, long responseTime, boolean success) {
        try {
            long successCount = success ? apiCallCount : 0;
            tenantQuotaService.recordApiUsage(tenantId, apiCallCount, successCount, (int) responseTime);
        } catch (Exception e) {
            log.warn("记录API使用统计失败: {}", e.getMessage());
        }
    }

    /**
     * 记录账号使用
     */
    private void recordAccountUsage(String tenantId) {
        try {
            // 这里可以根据实际情况记录账号使用
            // tenantQuotaService.recordAccountUsage(tenantId, accountCount);
            log.debug("记录租户 {} 账号使用", tenantId);
        } catch (Exception e) {
            log.warn("记录账号使用失败: {}", e.getMessage());
        }
    }

    /**
     * 获取租户API配置
     */
    private TenantApiConfig getTenantApiConfig(String tenantId) {
        return tenantConfigCache.computeIfAbsent(tenantId, this::loadTenantApiConfig);
    }

    /**
     * 加载租户API配置
     */
    private TenantApiConfig loadTenantApiConfig(String tenantId) {
        // 这里可以从数据库或配置服务加载租户特定的配置
        // 暂时返回默认配置
        return TenantApiConfig.builder()
                .tenantId(tenantId)
                .defaultClientType("261")
                .timeout(timeout)
                .maxRetryAttempts(maxRetryAttempts)
                .retryDelay(retryDelay)
                .callbackUrl(generateTenantCallbackUrl(tenantId))
                .createdAt(LocalDateTime.now())
                .build();
    }

    /**
     * 生成租户回调URL
     */
    private String generateTenantCallbackUrl(String tenantId) {
        // 为每个租户生成独立的回调URL，确保回调隔离
        return baseUrl.replace("/api", "") + "/callback/tenant/" + tenantId;
    }

    /**
     * 获取API超时时间
     */
    private int getApiTimeout(String tenantId) {
        TenantApiConfig config = getTenantApiConfig(tenantId);
        return config.getTimeout() != null ? config.getTimeout() : timeout;
    }

    /**
     * 清除租户配置缓存
     */
    public void clearTenantConfigCache(String tenantId) {
        tenantConfigCache.remove(tenantId);
        log.info("清除租户 {} 的API配置缓存", tenantId);
    }

    /**
     * 租户API配置类
     */
    @lombok.Data
    @lombok.Builder
    @lombok.NoArgsConstructor
    @lombok.AllArgsConstructor
    public static class TenantApiConfig {
        private String tenantId;
        private String defaultClientType;
        private Integer timeout;
        private Integer maxRetryAttempts;
        private Long retryDelay;
        private String callbackUrl;
        private String proxyUrl;
        private String bridgeUrl;
        private Map<String, Object> customHeaders;
        private Map<String, Object> customParams;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;
    }
}