package com.wework.platform.account.client;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.wework.platform.common.exception.BusinessException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;
import reactor.core.publisher.Mono;

import java.time.Duration;
import java.util.Map;

/**
 * 企微API客户端
 *
 * @author WeWork Platform Team
 */
@Slf4j
@Component
public class WeWorkApiClient {

    private final WebClient webClient;

    @Value("${wework.api.base-url}")
    private String baseUrl;

    @Value("${wework.api.timeout:30000}")
    private Integer timeout;

    public WeWorkApiClient() {
        this.webClient = WebClient.builder()
                .codecs(configurer -> configurer.defaultCodecs().maxInMemorySize(10 * 1024 * 1024))
                .build();
    }

    /**
     * 创建新实例
     */
    public String createInstance(String clientType, String proxy, String bridge) {
        String url = baseUrl + "/api/newInstance";
        
        JSONObject request = new JSONObject();
        request.put("clientType", clientType != null ? clientType : "261");
        if (proxy != null) request.put("proxy", proxy);
        if (bridge != null) request.put("bridge", bridge);

        try {
            log.info("创建企微实例，请求参数: {}", request.toJSONString());
            
            String response = webClient.post()
                    .uri(url)
                    .header("Content-Type", "application/json")
                    .bodyValue(request.toJSONString())
                    .retrieve()
                    .bodyToMono(String.class)
                    .timeout(Duration.ofMillis(timeout))
                    .block();

            log.info("创建企微实例响应: {}", response);
            
            JSONObject result = JSON.parseObject(response);
            if (result.getBoolean("success") == Boolean.TRUE) {
                JSONObject data = result.getJSONObject("data");
                return data.getString("guid");
            } else {
                throw new BusinessException("创建企微实例失败: " + result.getString("message"));
            }
            
        } catch (WebClientResponseException e) {
            log.error("创建企微实例请求失败: {}", e.getMessage(), e);
            throw new BusinessException("创建企微实例请求失败: " + e.getMessage());
        } catch (Exception e) {
            log.error("创建企微实例异常: {}", e.getMessage(), e);
            throw new BusinessException("创建企微实例异常: " + e.getMessage());
        }
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
     * 通用POST请求
     */
    public JSONObject post(String endpoint, Map<String, Object> params) {
        String url = baseUrl + endpoint;
        
        try {
            String response = webClient.post()
                    .uri(url)
                    .header("Content-Type", "application/json")
                    .bodyValue(JSON.toJSONString(params))
                    .retrieve()
                    .bodyToMono(String.class)
                    .timeout(Duration.ofMillis(timeout))
                    .block();

            return JSON.parseObject(response);
            
        } catch (WebClientResponseException e) {
            log.error("API请求失败: {} - {}", url, e.getMessage());
            throw new BusinessException("API请求失败: " + e.getMessage());
        } catch (Exception e) {
            log.error("API请求异常: {} - {}", url, e.getMessage());
            throw new BusinessException("API请求异常: " + e.getMessage());
        }
    }
}