package com.wework.platform.common.dto.message;

import com.wework.platform.common.enums.MessageTemplateType;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;
import java.util.Map;

/**
 * 发送消息请求DTO
 *
 * @author WeWork Platform Team
 */
@Data
@Schema(description = "发送消息请求")
public class SendMessageRequest {

    /**
     * 企微账号GUID
     */
    @NotBlank(message = "企微账号GUID不能为空")
    @Schema(description = "企微账号GUID", example = "5b1eb388-a4df-3da5-a49a-507eea46632c")
    private String guid;

    /**
     * 会话ID
     */
    @NotBlank(message = "会话ID不能为空")
    @Schema(description = "会话ID", example = "S:1688857160788209")
    private String conversationId;

    /**
     * 消息类型
     */
    @NotNull(message = "消息类型不能为空")
    @Schema(description = "消息类型")
    private MessageTemplateType messageType;

    /**
     * 消息内容
     */
    @Schema(description = "消息内容")
    private String content;

    /**
     * 文件ID（图片、视频、文件等）
     */
    @Schema(description = "文件ID")
    private String fileId;

    /**
     * 文件大小
     */
    @Schema(description = "文件大小（字节）")
    private Long fileSize;

    /**
     * 文件名称
     */
    @Schema(description = "文件名称")
    private String fileName;

    /**
     * AES密钥
     */
    @Schema(description = "AES密钥")
    private String aesKey;

    /**
     * MD5校验值
     */
    @Schema(description = "MD5校验值")
    private String md5;

    /**
     * 图片宽度
     */
    @Schema(description = "图片宽度")
    private Integer imageWidth;

    /**
     * 图片高度
     */
    @Schema(description = "图片高度")
    private Integer imageHeight;

    /**
     * 是否高清图片
     */
    @Schema(description = "是否高清图片")
    private Boolean isHd;

    /**
     * 视频时长（秒）
     */
    @Schema(description = "视频时长（秒）")
    private Integer videoDuration;

    /**
     * 链接标题
     */
    @Schema(description = "链接标题")
    private String linkTitle;

    /**
     * 链接描述
     */
    @Schema(description = "链接描述")
    private String linkDescription;

    /**
     * 链接URL
     */
    @Schema(description = "链接URL")
    private String linkUrl;

    /**
     * 链接缩略图URL
     */
    @Schema(description = "链接缩略图URL")
    private String linkImageUrl;

    /**
     * 小程序用户名
     */
    @Schema(description = "小程序用户名")
    private String miniProgramUsername;

    /**
     * 小程序AppId
     */
    @Schema(description = "小程序AppId")
    private String miniProgramAppId;

    /**
     * 小程序名称
     */
    @Schema(description = "小程序名称")
    private String miniProgramAppName;

    /**
     * 小程序图标
     */
    @Schema(description = "小程序图标")
    private String miniProgramAppIcon;

    /**
     * 小程序标题
     */
    @Schema(description = "小程序标题")
    private String miniProgramTitle;

    /**
     * 小程序页面路径
     */
    @Schema(description = "小程序页面路径")
    private String miniProgramPagePath;

    /**
     * @用户列表（群聊时使用）
     */
    @Schema(description = "@用户列表")
    private List<String> atList;

    /**
     * 引用消息ID
     */
    @Schema(description = "引用消息ID")
    private String quoteMessageId;

    /**
     * 引用消息内容
     */
    @Schema(description = "引用消息内容")
    private String quoteContent;

    /**
     * 经度（位置消息使用）
     */
    @Schema(description = "经度")
    private Double longitude;

    /**
     * 纬度（位置消息使用）
     */
    @Schema(description = "纬度")
    private Double latitude;

    /**
     * 位置标题
     */
    @Schema(description = "位置标题")
    private String locationTitle;

    /**
     * 位置地址
     */
    @Schema(description = "位置地址")
    private String locationAddress;

    /**
     * 扩展参数
     */
    @Schema(description = "扩展参数")
    private Map<String, Object> extra;

    /**
     * 指定提供商代码（可选）
     */
    @Schema(description = "指定提供商代码")
    private String providerCode;

    /**
     * 是否异步发送
     */
    @Schema(description = "是否异步发送", defaultValue = "false")
    private Boolean async = false;

    /**
     * 消息优先级（1-10，数值越大优先级越高）
     */
    @Schema(description = "消息优先级", defaultValue = "5")
    private Integer priority = 5;

    /**
     * 重试次数
     */
    @Schema(description = "重试次数", defaultValue = "3")
    private Integer retryCount = 3;
}