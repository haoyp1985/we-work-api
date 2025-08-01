package com.wework.platform.message.provider.impl;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.wework.platform.common.dto.message.*;
import com.wework.platform.common.enums.MessageTemplateType;
import com.wework.platform.message.provider.WeWorkApiProvider;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;
import reactor.core.publisher.Mono;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

/**
 * 广州孤星企微API提供商实现
 * 
 * 基于广州孤星企微协议的具体实现
 *
 * @author WeWork Platform Team
 */
@Slf4j
@Component
public class GuangzhouGuxingProvider implements WeWorkApiProvider {

    private final WebClient webClient;
    private final String apiBaseUrl;
    private final Integer timeoutMs;
    private final Integer retryCount;
    private final boolean enabled;
    private final int priority;

    // 支持的功能列表
    private static final Set<String> SUPPORTED_FEATURES = Set.of(
        "SEND_TEXT", "SEND_IMAGE", "SEND_VIDEO", "SEND_FILE", "SEND_VOICE",
        "SEND_LINK", "SEND_MINIPROGRAM", "SEND_CONTACT", "SEND_LOCATION",
        "SEND_GIF", "SEND_MENTION", "SEND_QUOTE", "BATCH_SEND", "CALLBACK_HANDLE"
    );

    public GuangzhouGuxingProvider(
            @Value("${app.wework.providers.guangzhou-guxing.api-base-url}") String apiBaseUrl,
            @Value("${app.wework.providers.guangzhou-guxing.timeout-ms:30000}") Integer timeoutMs,
            @Value("${app.wework.providers.guangzhou-guxing.retry-count:3}") Integer retryCount,
            @Value("${app.wework.providers.guangzhou-guxing.enabled:true}") boolean enabled,
            @Value("${app.wework.providers.guangzhou-guxing.priority:1}") int priority) {
        
        this.apiBaseUrl = apiBaseUrl;
        this.timeoutMs = timeoutMs;
        this.retryCount = retryCount;
        this.enabled = enabled;
        this.priority = priority;
        
        this.webClient = WebClient.builder()
                .baseUrl(apiBaseUrl)
                .codecs(configurer -> configurer.defaultCodecs().maxInMemorySize(10 * 1024 * 1024))
                .build();
    }

    @Override
    public String getProviderCode() {
        return "GUANGZHOU_GUXING";
    }

    @Override
    public String getProviderName() {
        return "广州孤星";
    }

    @Override
    public boolean isEnabled() {
        return enabled;
    }

    @Override
    public int getPriority() {
        return priority;
    }

    @Override
    public boolean supports(String feature) {
        return SUPPORTED_FEATURES.contains(feature);
    }

    @Override
    public boolean supportsMessageType(MessageTemplateType messageType) {
        return switch (messageType) {
            case TEXT, IMAGE, VIDEO, FILE, VOICE, LINK, 
                 MINIPROGRAM, CONTACT, LOCATION, GIF, 
                 MENTION, QUOTE -> true;
            case MIXED -> false; // 暂不支持混合消息
        };
    }

    @Override
    public boolean healthCheck() {
        try {
            String response = webClient.get()
                    .uri("/health")
                    .retrieve()
                    .bodyToMono(String.class)
                    .timeout(Duration.ofMillis(5000))
                    .block();
            
            return StringUtils.hasText(response);
        } catch (Exception e) {
            log.warn("广州孤星提供商健康检查失败: {}", e.getMessage());
            return false;
        }
    }

    @Override
    public List<String> getAllClients() {
        try {
            Map<String, Object> response = callApi("GET", "/client/all_clients", null);
            Object data = response.get("data");
            
            if (data instanceof List<?> list) {
                return list.stream()
                        .filter(String.class::isInstance)
                        .map(String.class::cast)
                        .toList();
            }
            
            return List.of();
        } catch (Exception e) {
            log.error("获取所有实例列表失败", e);
            throw new RuntimeException("获取实例列表失败: " + e.getMessage());
        }
    }

    @Override
    public Map<String, Object> getClientStatus(String guid) {
        try {
            Map<String, Object> params = Map.of("guid", guid);
            return callApi("POST", "/client/get_client_status", params);
        } catch (Exception e) {
            log.error("获取实例状态失败, guid: {}", guid, e);
            throw new RuntimeException("获取实例状态失败: " + e.getMessage());
        }
    }

    @Override
    public Map<String, Object> getLoginQrCode(String guid) {
        try {
            Map<String, Object> params = Map.of("guid", guid);
            return callApi("POST", "/login/get_qr_code", params);
        } catch (Exception e) {
            log.error("获取登录二维码失败, guid: {}", guid, e);
            throw new RuntimeException("获取登录二维码失败: " + e.getMessage());
        }
    }

    @Override
    public Map<String, Object> getSessionList(String guid, String beginSeq, int limit) {
        try {
            Map<String, Object> params = Map.of(
                "guid", guid,
                "begin_seq", beginSeq != null ? beginSeq : "0",
                "limit", limit
            );
            return callApi("POST", "/session/get_session_list", params);
        } catch (Exception e) {
            log.error("获取会话列表失败, guid: {}", guid, e);
            throw new RuntimeException("获取会话列表失败: " + e.getMessage());
        }
    }

    @Override
    public SendMessageResponse sendTextMessage(SendMessageRequest request) {
        try {
            long startTime = System.currentTimeMillis();
            String requestId = UUID.randomUUID().toString();
            
            // 验证会话ID格式
            String conversationId = validateConversationId(request.getConversationId());
            
            Map<String, Object> params = Map.of(
                "guid", request.getGuid(),
                "conversation_id", conversationId,
                "content", request.getContent() != null ? request.getContent() : ""
            );
            
            Map<String, Object> response = callApi("POST", "/msg/send_text", params);
            
            return buildSendMessageResponse(response, requestId, startTime);
            
        } catch (Exception e) {
            log.error("发送文本消息失败", e);
            return SendMessageResponse.error(-1, "发送文本消息失败: " + e.getMessage());
        }
    }

    @Override
    public SendMessageResponse sendImageMessage(SendMessageRequest request) {
        try {
            long startTime = System.currentTimeMillis();
            String requestId = UUID.randomUUID().toString();
            
            String conversationId = validateConversationId(request.getConversationId());
            
            Map<String, Object> params = Map.of(
                "guid", request.getGuid(),
                "conversation_id", conversationId,
                "file_id", request.getFileId() != null ? request.getFileId() : "",
                "size", request.getFileSize() != null ? request.getFileSize().intValue() : 0,
                "image_width", request.getImageWidth() != null ? request.getImageWidth() : 0,
                "image_height", request.getImageHeight() != null ? request.getImageHeight() : 0,
                "aes_key", request.getAesKey() != null ? request.getAesKey() : "",
                "md5", request.getMd5() != null ? request.getMd5() : "",
                "is_hd", request.getIsHd() != null ? request.getIsHd() : false
            );
            
            Map<String, Object> response = callApi("POST", "/msg/send_image", params);
            
            return buildSendMessageResponse(response, requestId, startTime);
            
        } catch (Exception e) {
            log.error("发送图片消息失败", e);
            return SendMessageResponse.error(-1, "发送图片消息失败: " + e.getMessage());
        }
    }

    @Override
    public SendMessageResponse sendVideoMessage(SendMessageRequest request) {
        // 实现视频消息发送逻辑
        throw new UnsupportedOperationException("视频消息发送功能待实现");
    }

    @Override
    public SendMessageResponse sendFileMessage(SendMessageRequest request) {
        // 实现文件消息发送逻辑
        throw new UnsupportedOperationException("文件消息发送功能待实现");
    }

    @Override
    public SendMessageResponse sendVoiceMessage(SendMessageRequest request) {
        // 实现语音消息发送逻辑
        throw new UnsupportedOperationException("语音消息发送功能待实现");
    }

    @Override
    public SendMessageResponse sendLinkMessage(SendMessageRequest request) {
        // 实现链接消息发送逻辑
        throw new UnsupportedOperationException("链接消息发送功能待实现");
    }

    @Override
    public SendMessageResponse sendMiniProgramMessage(SendMessageRequest request) {
        // 实现小程序消息发送逻辑
        throw new UnsupportedOperationException("小程序消息发送功能待实现");
    }

    @Override
    public SendMessageResponse sendContactMessage(SendMessageRequest request) {
        // 实现名片消息发送逻辑
        throw new UnsupportedOperationException("名片消息发送功能待实现");
    }

    @Override
    public SendMessageResponse sendLocationMessage(SendMessageRequest request) {
        // 实现位置消息发送逻辑
        throw new UnsupportedOperationException("位置消息发送功能待实现");
    }

    @Override
    public SendMessageResponse sendGifMessage(SendMessageRequest request) {
        // 实现GIF消息发送逻辑
        throw new UnsupportedOperationException("GIF消息发送功能待实现");
    }

    @Override
    public SendMessageResponse sendMentionMessage(SendMessageRequest request) {
        // 实现群@消息发送逻辑
        throw new UnsupportedOperationException("群@消息发送功能待实现");
    }

    @Override
    public SendMessageResponse sendQuoteMessage(SendMessageRequest request) {
        // 实现引用消息发送逻辑
        throw new UnsupportedOperationException("引用消息发送功能待实现");
    }

    @Override
    public Map<String, Object> batchSendMessage(BatchSendMessageRequest request) {
        try {
            String conversationId = validateConversationId(request.getGuid());
            
            Map<String, Object> params = Map.of(
                "guid", request.getGuid(),
                "user_list", request.getUserList() != null ? request.getUserList() : List.of(),
                "room_list", request.getRoomList() != null ? request.getRoomList() : List.of(),
                "content", request.getContent() != null ? request.getContent() : "",
                "image_msg_list", request.getImageMsgList() != null ? request.getImageMsgList() : List.of(),
                "video_msg_list", request.getVideoMsgList() != null ? request.getVideoMsgList() : List.of(),
                "weapp_msg_list", request.getMiniProgramMsgList() != null ? request.getMiniProgramMsgList() : List.of(),
                "link_msg_list", request.getLinkMsgList() != null ? request.getLinkMsgList() : List.of(),
                "file_msg_list", request.getFileMsgList() != null ? request.getFileMsgList() : List.of()
            );
            
            return callApi("POST", "/msg/send_group_msg", params);
            
        } catch (Exception e) {
            log.error("批量发送消息失败", e);
            throw new RuntimeException("批量发送消息失败: " + e.getMessage());
        }
    }

    @Override
    public Map<String, Object> recallMessage(String guid, String messageId) {
        // 实现撤回消息逻辑
        throw new UnsupportedOperationException("撤回消息功能待实现");
    }

    @Override
    public Map<String, Object> markMessageRead(String guid, String conversationId) {
        // 实现标记已读逻辑
        throw new UnsupportedOperationException("标记已读功能待实现");
    }

    @Override
    public void handleCallback(CallbackData callbackData) {
        log.info("收到回调数据: {}", callbackData);
        
        // 根据回调类型进行不同处理
        switch (callbackData.getCallbackType()) {
            case MESSAGE_SYNC -> handleMessageSyncCallback(callbackData);
            case LOGIN_SUCCESS -> handleLoginSuccessCallback(callbackData);
            case LOGOUT -> handleLogoutCallback(callbackData);
            case QR_CODE_CHANGE -> handleQrCodeChangeCallback(callbackData);
            default -> log.info("未处理的回调类型: {}", callbackData.getCallbackType());
        }
    }

    @Override
    public String buildApiUrl(String endpoint) {
        return apiBaseUrl + endpoint;
    }

    // ================================
    // 私有方法
    // ================================

    /**
     * 调用API
     */
    private Map<String, Object> callApi(String method, String endpoint, Map<String, Object> params) {
        try {
            String responseStr;
            
            if ("GET".equalsIgnoreCase(method)) {
                responseStr = webClient.get()
                        .uri(endpoint)
                        .retrieve()
                        .onStatus(status -> status.isError(), response -> {
                            return response.bodyToMono(String.class)
                                    .map(body -> new RuntimeException("API调用失败: " + body));
                        })
                        .bodyToMono(String.class)
                        .timeout(Duration.ofMillis(timeoutMs))
                        .retry(retryCount)
                        .block();
            } else {
                // POST请求处理
                WebClient.RequestBodySpec requestSpec = webClient.post().uri(endpoint);
                if (params != null) {
                    responseStr = requestSpec
                            .bodyValue(params)
                            .retrieve()
                            .onStatus(status -> status.isError(), response -> {
                                return response.bodyToMono(String.class)
                                        .map(body -> new RuntimeException("API调用失败: " + body));
                            })
                            .bodyToMono(String.class)
                            .timeout(Duration.ofMillis(timeoutMs))
                            .retry(retryCount)
                            .block();
                } else {
                    responseStr = requestSpec
                            .retrieve()
                            .onStatus(status -> status.isError(), response -> {
                                return response.bodyToMono(String.class)
                                        .map(body -> new RuntimeException("API调用失败: " + body));
                            })
                            .bodyToMono(String.class)
                            .timeout(Duration.ofMillis(timeoutMs))
                            .retry(retryCount)
                            .block();
                }
            }
            
            if (!StringUtils.hasText(responseStr)) {
                throw new RuntimeException("API响应为空");
            }
            
            return JSON.parseObject(responseStr, Map.class);
            
        } catch (WebClientResponseException e) {
            log.error("API调用异常, endpoint: {}, status: {}, body: {}", endpoint, e.getStatusCode(), e.getResponseBodyAsString());
            throw new RuntimeException("API调用失败: " + e.getMessage());
        } catch (Exception e) {
            log.error("API调用失败, endpoint: {}", endpoint, e);
            throw new RuntimeException("API调用失败: " + e.getMessage());
        }
    }

    /**
     * 构建发送消息响应
     */
    private SendMessageResponse buildSendMessageResponse(Map<String, Object> response, String requestId, long startTime) {
        SendMessageResponse result = new SendMessageResponse();
        result.setRequestId(requestId);
        result.setProviderCode(getProviderCode());
        result.setDuration(System.currentTimeMillis() - startTime);
        
        Integer errorCode = (Integer) response.get("error_code");
        String errorMessage = (String) response.get("error_message");
        
        result.setErrorCode(errorCode);
        result.setErrorMessage(errorMessage);
        result.setSuccess(errorCode != null && errorCode == 0);
        
        if (result.getSuccess()) {
            Map<String, Object> data = (Map<String, Object>) response.get("data");
            if (data != null) {
                Map<String, Object> msgData = (Map<String, Object>) data.get("msg_data");
                if (msgData != null) {
                    result.setMessageId((String) msgData.get("id"));
                    result.setMessageSeq((String) msgData.get("seq"));
                    result.setSenderId((String) msgData.get("sender"));
                    result.setReceiverId((String) msgData.get("receiver"));
                    result.setRoomId((String) msgData.get("roomid"));
                    result.setMessageType((Integer) msgData.get("messagetype"));
                    result.setContentType((Integer) msgData.get("contenttype"));
                    result.setContent((String) msgData.get("content"));
                    result.setSenderName((String) msgData.get("sendername"));
                    result.setDevInfo((String) msgData.get("devinfo"));
                    result.setAppInfo((String) msgData.get("appinfo"));
                    result.setExtraContent((String) msgData.get("extra_content"));
                    
                    // 转换发送时间
                    Object sendtime = msgData.get("sendtime");
                    if (sendtime instanceof Number) {
                        long timestamp = ((Number) sendtime).longValue();
                        result.setSendTime(LocalDateTime.now());
                    }
                }
                
                result.setIsSvrFail((Boolean) data.get("is_svr_fail"));
            }
        }
        
        return result;
    }

    /**
     * 处理消息同步回调
     */
    private void handleMessageSyncCallback(CallbackData callbackData) {
        log.info("处理消息同步回调: {}", callbackData.getGuid());
        // TODO: 实现消息同步处理逻辑
    }

    /**
     * 处理登录成功回调
     */
    private void handleLoginSuccessCallback(CallbackData callbackData) {
        log.info("处理登录成功回调: {}", callbackData.getGuid());
        // TODO: 实现登录成功处理逻辑
    }

    /**
     * 处理登出回调
     */
    private void handleLogoutCallback(CallbackData callbackData) {
        log.info("处理登出回调: {}", callbackData.getGuid());
        // TODO: 实现登出处理逻辑
    }

    /**
     * 处理二维码变化回调
     */
    private void handleQrCodeChangeCallback(CallbackData callbackData) {
        log.info("处理二维码变化回调: {}", callbackData.getGuid());
        // TODO: 实现二维码变化处理逻辑
    }
}