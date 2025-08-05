package com.wework.platform.message.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wework.platform.common.core.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

/**
 * 消息记录实体
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("messages")
public class Message extends BaseEntity {

    /**
     * 消息ID
     */
    @TableId(type = IdType.ASSIGN_ID)
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
     * 消息类型 (1:文本, 2:图片, 3:视频, 4:文件, 5:链接, 6:小程序, 7:群发)
     */
    private Integer messageType;

    /**
     * 发送方式 (1:单发, 2:群发, 3:朋友圈)
     */
    private Integer sendType;

    /**
     * 接收者ID (用户ID或群ID)
     */
    private String receiverId;

    /**
     * 接收者类型 (1:个人, 2:群组)
     */
    private Integer receiverType;

    /**
     * 消息内容 (JSON格式)
     */
    private String content;

    /**
     * 模板ID (如果使用模板)
     */
    private String templateId;

    /**
     * 发送状态 (0:待发送, 1:发送中, 2:发送成功, 3:发送失败, 4:部分成功)
     */
    private Integer sendStatus;

    /**
     * 发送时间
     */
    private LocalDateTime sendTime;

    /**
     * 完成时间
     */
    private LocalDateTime completeTime;

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
     * 下次重试时间
     */
    private LocalDateTime nextRetryTime;

    /**
     * 企微消息ID
     */
    private String weworkMsgId;

    /**
     * 批次ID (批量发送时使用)
     */
    private String batchId;

    /**
     * 任务ID (关联消息任务)
     */
    private String taskId;

    /**
     * 回调URL
     */
    private String callbackUrl;

    /**
     * 扩展字段 (JSON格式)
     */
    private String extData;

    /**
     * 备注
     */
    private String remark;
}