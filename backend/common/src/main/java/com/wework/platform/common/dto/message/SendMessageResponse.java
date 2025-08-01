package com.wework.platform.common.dto.message;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Map;

/**
 * 发送消息响应DTO
 *
 * @author WeWork Platform Team
 */
@Data
@Schema(description = "发送消息响应")
public class SendMessageResponse {

    /**
     * 是否成功
     */
    @Schema(description = "是否成功")
    private Boolean success;

    /**
     * 错误码
     */
    @Schema(description = "错误码")
    private Integer errorCode;

    /**
     * 错误信息
     */
    @Schema(description = "错误信息")
    private String errorMessage;

    /**
     * 消息ID
     */
    @Schema(description = "消息ID")
    private String messageId;

    /**
     * 消息序列号
     */
    @Schema(description = "消息序列号")
    private String messageSeq;

    /**
     * 发送时间
     */
    @Schema(description = "发送时间")
    private LocalDateTime sendTime;

    /**
     * 发送者ID
     */
    @Schema(description = "发送者ID")
    private String senderId;

    /**
     * 接收者ID
     */
    @Schema(description = "接收者ID")
    private String receiverId;

    /**
     * 房间ID（群聊时有值）
     */
    @Schema(description = "房间ID")
    private String roomId;

    /**
     * 消息类型
     */
    @Schema(description = "消息类型")
    private Integer messageType;

    /**
     * 内容类型
     */
    @Schema(description = "内容类型")
    private Integer contentType;

    /**
     * 消息内容（编码后）
     */
    @Schema(description = "消息内容（编码后）")
    private String content;

    /**
     * 发送者名称
     */
    @Schema(description = "发送者名称")
    private String senderName;

    /**
     * 设备信息
     */
    @Schema(description = "设备信息")
    private String devInfo;

    /**
     * 应用信息
     */
    @Schema(description = "应用信息")
    private String appInfo;

    /**
     * 扩展内容
     */
    @Schema(description = "扩展内容")
    private String extraContent;

    /**
     * 是否服务器失败
     */
    @Schema(description = "是否服务器失败")
    private Boolean isSvrFail;

    /**
     * 使用的提供商代码
     */
    @Schema(description = "使用的提供商代码")
    private String providerCode;

    /**
     * 请求ID（用于追踪）
     */
    @Schema(description = "请求ID")
    private String requestId;

    /**
     * 耗时（毫秒）
     */
    @Schema(description = "耗时（毫秒）")
    private Long duration;

    /**
     * 扩展数据
     */
    @Schema(description = "扩展数据")
    private Map<String, Object> extra;

    /**
     * 创建成功响应
     */
    public static SendMessageResponse success(String messageId, String messageSeq) {
        SendMessageResponse response = new SendMessageResponse();
        response.setSuccess(true);
        response.setErrorCode(0);
        response.setErrorMessage("ok");
        response.setMessageId(messageId);
        response.setMessageSeq(messageSeq);
        response.setSendTime(LocalDateTime.now());
        return response;
    }

    /**
     * 创建失败响应
     */
    public static SendMessageResponse error(Integer errorCode, String errorMessage) {
        SendMessageResponse response = new SendMessageResponse();
        response.setSuccess(false);
        response.setErrorCode(errorCode);
        response.setErrorMessage(errorMessage);
        response.setSendTime(LocalDateTime.now());
        return response;
    }
}