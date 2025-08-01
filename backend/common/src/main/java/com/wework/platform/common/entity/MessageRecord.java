package com.wework.platform.common.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.wework.platform.common.enums.MessageStatus;
import com.wework.platform.common.enums.MessageType;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

/**
 * 消息记录实体
 * 
 * @author WeWork Platform Team
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("message_records")
public class MessageRecord extends BaseEntity {

    /**
     * 租户ID
     */
    private String tenantId;

    /**
     * 账号ID
     */
    private String accountId;

    /**
     * 会话ID
     */
    private String conversationId;

    /**
     * 消息类型
     */
    private MessageType messageType;

    /**
     * 消息内容(JSON格式)
     */
    private String content;

    /**
     * 发送状态
     */
    private MessageStatus status;

    /**
     * 企微消息ID
     */
    private String weworkMsgId;

    /**
     * 错误信息
     */
    private String errorMsg;

    /**
     * 发送时间
     */
    private LocalDateTime sendTime;

    /**
     * 回调时间
     */
    private LocalDateTime callbackTime;
}