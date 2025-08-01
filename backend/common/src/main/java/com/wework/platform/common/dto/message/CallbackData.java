package com.wework.platform.common.dto.message;

import com.wework.platform.common.enums.CallbackType;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 企微回调数据DTO
 *
 * @author WeWork Platform Team
 */
@Data
@Schema(description = "企微回调数据")
public class CallbackData {

    /**
     * 实例GUID
     */
    @Schema(description = "实例GUID")
    private String guid;

    /**
     * 回调类型ID
     */
    @Schema(description = "回调类型ID")
    private Integer notifyType;

    /**
     * 回调类型枚举
     */
    @Schema(description = "回调类型枚举")
    private CallbackType callbackType;

    /**
     * 回调数据
     */
    @Schema(description = "回调数据")
    private Object data;

    /**
     * 接收时间
     */
    @Schema(description = "接收时间")
    private LocalDateTime receiveTime;

    /**
     * 原始JSON数据
     */
    @Schema(description = "原始JSON数据")
    private String rawData;

    /**
     * 二维码变化数据
     */
    @Data
    @Schema(description = "二维码变化数据")
    public static class QrCodeChangeData {
        @Schema(description = "状态")
        private Integer status;

        @Schema(description = "VID")
        private Integer vid;

        @Schema(description = "昵称")
        private String nickname;

        @Schema(description = "头像")
        private String avatar;

        @Schema(description = "企业logo")
        private String logo;

        @Schema(description = "企业ID")
        private Integer corpId;
    }

    /**
     * 登录成功数据
     */
    @Data
    @Schema(description = "登录成功数据")
    public static class LoginSuccessData {
        @Schema(description = "用户ID")
        private String userId;

        @Schema(description = "姓名")
        private String name;

        @Schema(description = "真实姓名")
        private String realName;

        @Schema(description = "企业ID")
        private String corpId;

        @Schema(description = "性别")
        private Integer gender;

        @Schema(description = "部门ID")
        private String partyId;

        @Schema(description = "头像")
        private String avatar;

        @Schema(description = "企业简称")
        private String corpShortName;

        @Schema(description = "企业全称")
        private String corpFullName;
    }

    /**
     * 退出登录数据
     */
    @Data
    @Schema(description = "退出登录数据")
    public static class LogoutData {
        @Schema(description = "错误码")
        private Integer errorCode;

        @Schema(description = "错误信息")
        private String errorMessage;
    }

    /**
     * 消息数据
     */
    @Data
    @Schema(description = "消息数据")
    public static class MessageData {
        @Schema(description = "消息序列号")
        private String seq;

        @Schema(description = "消息ID")
        private String id;

        @Schema(description = "应用信息")
        private String appinfo;

        @Schema(description = "发送者")
        private String sender;

        @Schema(description = "接收者")
        private String receiver;

        @Schema(description = "房间ID")
        private String roomid;

        @Schema(description = "发送时间")
        private Long sendtime;

        @Schema(description = "发送者名称")
        private String senderName;

        @Schema(description = "内容类型")
        private Integer contentType;

        @Schema(description = "引用ID")
        private String referid;

        @Schema(description = "标志")
        private Integer flag;

        @Schema(description = "消息内容")
        private String content;

        @Schema(description = "@列表")
        private List<String> atList;

        @Schema(description = "引用内容")
        private String quoteContent;

        @Schema(description = "引用应用信息")
        private String quoteAppinfo;

        @Schema(description = "发送标志")
        private Integer sendFlag;

        @Schema(description = "消息类型")
        private Integer msgType;

        @Schema(description = "扩展内容")
        private String extraContent;

        @Schema(description = "ASID")
        private String asid;
    }

    /**
     * 视频/语音通话数据
     */
    @Data
    @Schema(description = "视频/语音通话数据")
    public static class CallData {
        @Schema(description = "通话类型")
        private Integer type;

        @Schema(description = "消息ID")
        private String msgid;

        @Schema(description = "时间戳")
        private Long timestamp;

        @Schema(description = "邀请消息")
        private Map<String, Object> inviteMsg;
    }

    /**
     * 根据回调类型ID创建回调数据
     */
    public static CallbackData fromNotifyType(String guid, Integer notifyType, Object data) {
        CallbackData callbackData = new CallbackData();
        callbackData.setGuid(guid);
        callbackData.setNotifyType(notifyType);
        callbackData.setCallbackType(CallbackType.fromTypeId(notifyType));
        callbackData.setData(data);
        callbackData.setReceiveTime(LocalDateTime.now());
        return callbackData;
    }
}