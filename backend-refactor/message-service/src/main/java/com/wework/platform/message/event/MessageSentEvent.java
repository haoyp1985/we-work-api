package com.wework.platform.message.event;

import org.springframework.context.ApplicationEvent;

/**
 * 消息发送事件
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
public class MessageSentEvent extends ApplicationEvent {

    private final String messageId;
    private final boolean success;
    private final String errorCode;
    private final String errorMessage;
    private final Long timestamp;

    /**
     * 创建消息发送事件
     *
     * @param messageId 消息ID
     * @param success 是否成功
     */
    public MessageSentEvent(String messageId, boolean success) {
        super(messageId);
        this.messageId = messageId;
        this.success = success;
        this.errorCode = null;
        this.errorMessage = null;
        this.timestamp = System.currentTimeMillis();
    }

    /**
     * 创建消息发送失败事件
     *
     * @param messageId 消息ID
     * @param errorCode 错误码
     * @param errorMessage 错误信息
     */
    public MessageSentEvent(String messageId, String errorCode, String errorMessage) {
        super(messageId);
        this.messageId = messageId;
        this.success = false;
        this.errorCode = errorCode;
        this.errorMessage = errorMessage;
        this.timestamp = System.currentTimeMillis();
    }

    public String getMessageId() {
        return messageId;
    }

    public boolean isSuccess() {
        return success;
    }

    public String getErrorCode() {
        return errorCode;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public Long getEventTimestamp() {
        return timestamp;
    }
}