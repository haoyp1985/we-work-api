package com.wework.platform.message.service;

import com.wework.platform.common.dto.message.BatchSendMessageRequest;
import com.wework.platform.common.dto.message.SendMessageRequest;
import com.wework.platform.common.dto.message.SendMessageResponse;

import java.util.Map;

/**
 * 消息发送服务接口
 *
 * @author WeWork Platform Team
 */
public interface MessageSendService {

    /**
     * 发送消息
     * @param request 发送请求
     * @return 发送结果
     */
    SendMessageResponse sendMessage(SendMessageRequest request);

    /**
     * 异步发送消息
     * @param request 发送请求
     * @return 异步任务ID
     */
    String sendMessageAsync(SendMessageRequest request);

    /**
     * 批量发送消息
     * @param request 批量发送请求
     * @return 发送结果
     */
    Map<String, Object> batchSendMessage(BatchSendMessageRequest request);

    /**
     * 重试发送消息
     * @param messageId 消息ID
     * @return 重试结果
     */
    SendMessageResponse retryMessage(String messageId);

    /**
     * 撤回消息
     * @param guid 实例GUID
     * @param messageId 消息ID
     * @return 撤回结果
     */
    Map<String, Object> recallMessage(String guid, String messageId);

    /**
     * 获取消息发送状态
     * @param messageId 消息ID
     * @return 状态信息
     */
    Map<String, Object> getMessageStatus(String messageId);
}