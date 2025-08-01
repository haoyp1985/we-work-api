package com.wework.platform.message.provider;

import com.wework.platform.common.dto.message.*;
import com.wework.platform.common.enums.MessageTemplateType;

import java.util.List;
import java.util.Map;

/**
 * 企微API提供商接口
 * 
 * 定义统一的企微API调用接口，支持多个提供商实现
 *
 * @author WeWork Platform Team
 */
public interface WeWorkApiProvider {

    /**
     * 获取提供商代码
     */
    String getProviderCode();

    /**
     * 获取提供商名称
     */
    String getProviderName();

    /**
     * 是否启用
     */
    boolean isEnabled();

    /**
     * 获取优先级（数值越小优先级越高）
     */
    int getPriority();

    /**
     * 检查是否支持指定功能
     */
    boolean supports(String feature);

    /**
     * 检查是否支持指定消息类型
     */
    boolean supportsMessageType(MessageTemplateType messageType);

    /**
     * 健康检查
     */
    boolean healthCheck();

    // ================================
    // 实例管理相关API
    // ================================

    /**
     * 获取所有实例列表
     */
    List<String> getAllClients();

    /**
     * 获取实例状态
     * @param guid 实例GUID
     * @return 状态信息
     */
    Map<String, Object> getClientStatus(String guid);

    /**
     * 获取登录二维码
     * @param guid 实例GUID
     * @return 二维码信息
     */
    Map<String, Object> getLoginQrCode(String guid);

    // ================================
    // 会话管理相关API
    // ================================

    /**
     * 获取会话列表
     * @param guid 实例GUID
     * @param beginSeq 开始序列号
     * @param limit 限制数量
     * @return 会话列表
     */
    Map<String, Object> getSessionList(String guid, String beginSeq, int limit);

    // ================================
    // 消息发送相关API
    // ================================

    /**
     * 发送文本消息
     * @param request 发送请求
     * @return 发送结果
     */
    SendMessageResponse sendTextMessage(SendMessageRequest request);

    /**
     * 发送图片消息
     * @param request 发送请求
     * @return 发送结果
     */
    SendMessageResponse sendImageMessage(SendMessageRequest request);

    /**
     * 发送视频消息
     * @param request 发送请求
     * @return 发送结果
     */
    SendMessageResponse sendVideoMessage(SendMessageRequest request);

    /**
     * 发送文件消息
     * @param request 发送请求
     * @return 发送结果
     */
    SendMessageResponse sendFileMessage(SendMessageRequest request);

    /**
     * 发送语音消息
     * @param request 发送请求
     * @return 发送结果
     */
    SendMessageResponse sendVoiceMessage(SendMessageRequest request);

    /**
     * 发送链接消息
     * @param request 发送请求
     * @return 发送结果
     */
    SendMessageResponse sendLinkMessage(SendMessageRequest request);

    /**
     * 发送小程序消息
     * @param request 发送请求
     * @return 发送结果
     */
    SendMessageResponse sendMiniProgramMessage(SendMessageRequest request);

    /**
     * 发送名片消息
     * @param request 发送请求
     * @return 发送结果
     */
    SendMessageResponse sendContactMessage(SendMessageRequest request);

    /**
     * 发送位置消息
     * @param request 发送请求
     * @return 发送结果
     */
    SendMessageResponse sendLocationMessage(SendMessageRequest request);

    /**
     * 发送GIF消息
     * @param request 发送请求
     * @return 发送结果
     */
    SendMessageResponse sendGifMessage(SendMessageRequest request);

    /**
     * 发送群@消息
     * @param request 发送请求
     * @return 发送结果
     */
    SendMessageResponse sendMentionMessage(SendMessageRequest request);

    /**
     * 发送引用消息
     * @param request 发送请求
     * @return 发送结果
     */
    SendMessageResponse sendQuoteMessage(SendMessageRequest request);

    /**
     * 批量发送消息（群发助手）
     * @param request 批量发送请求
     * @return 发送结果
     */
    Map<String, Object> batchSendMessage(BatchSendMessageRequest request);

    /**
     * 撤回消息
     * @param guid 实例GUID
     * @param messageId 消息ID
     * @return 撤回结果
     */
    Map<String, Object> recallMessage(String guid, String messageId);

    /**
     * 标记消息已读
     * @param guid 实例GUID
     * @param conversationId 会话ID
     * @return 标记结果
     */
    Map<String, Object> markMessageRead(String guid, String conversationId);

    // ================================
    // 回调处理相关
    // ================================

    /**
     * 处理回调数据
     * @param callbackData 回调数据
     */
    void handleCallback(CallbackData callbackData);

    // ================================
    // 工具方法
    // ================================

    /**
     * 验证会话ID格式
     * @param conversationId 会话ID
     * @return 验证后的会话ID
     */
    default String validateConversationId(String conversationId) {
        if (conversationId == null || conversationId.trim().isEmpty()) {
            throw new IllegalArgumentException("会话ID不能为空");
        }
        
        // 如果没有前缀，默认为私聊
        if (!conversationId.startsWith("S:") && !conversationId.startsWith("R:")) {
            if (conversationId.matches("\\d+")) {
                return "S:" + conversationId;
            }
        }
        
        return conversationId;
    }

    /**
     * 构建API URL
     * @param endpoint 端点
     * @return 完整URL
     */
    String buildApiUrl(String endpoint);

    /**
     * 获取错误信息
     * @param errorCode 错误码
     * @return 错误描述
     */
    default String getErrorMessage(Integer errorCode) {
        if (errorCode == null || errorCode == 0) {
            return "成功";
        }
        
        return switch (errorCode) {
            case -2003 -> "参数格式错误，请检查会话ID格式";
            case -4017 -> "权限不足，无法发送消息到此联系人";
            default -> "未知错误: " + errorCode;
        };
    }
}