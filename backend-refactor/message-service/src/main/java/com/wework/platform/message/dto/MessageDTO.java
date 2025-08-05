package com.wework.platform.message.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * 消息数据传输对象
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MessageDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 消息ID
     */
    private String id;

    /**
     * 租户ID
     */
    private String tenantId;

    /**
     * 账号ID
     */
    private String accountId;

    /**
     * 账号名称
     */
    private String accountName;

    /**
     * 消息类型 (1:文本, 2:图片, 3:视频, 4:文件, 5:链接, 6:小程序, 7:群发)
     */
    private Integer messageType;

    /**
     * 消息类型名称
     */
    private String messageTypeName;

    /**
     * 发送方式 (1:单发, 2:群发, 3:朋友圈)
     */
    private Integer sendType;

    /**
     * 发送方式名称
     */
    private String sendTypeName;

    /**
     * 接收者ID
     */
    private String receiverId;

    /**
     * 接收者名称
     */
    private String receiverName;

    /**
     * 接收者类型 (1:个人, 2:群组)
     */
    private Integer receiverType;

    /**
     * 消息内容
     */
    private String content;

    /**
     * 模板ID
     */
    private String templateId;

    /**
     * 模板名称
     */
    private String templateName;

    /**
     * 发送状态 (0:待发送, 1:发送中, 2:发送成功, 3:发送失败, 4:部分成功)
     */
    private Integer sendStatus;

    /**
     * 发送状态名称
     */
    private String sendStatusName;

    /**
     * 发送时间
     */
    private Long sendTime;

    /**
     * 完成时间
     */
    private Long completeTime;

    /**
     * 错误码
     */
    private String errorCode;

    /**
     * 错误信息
     */
    private String errorMessage;

    /**
     * 重试次数
     */
    private Integer retryCount;

    /**
     * 最大重试次数
     */
    private Integer maxRetryCount;

    /**
     * 企微消息ID
     */
    private String weworkMsgId;

    /**
     * 任务ID
     */
    private String taskId;

    /**
     * 任务名称
     */
    private String taskName;

    /**
     * 创建时间
     */
    private Long createdAt;

    /**
     * 更新时间
     */
    private Long updatedAt;

    /**
     * 备注
     */
    private String remark;
}