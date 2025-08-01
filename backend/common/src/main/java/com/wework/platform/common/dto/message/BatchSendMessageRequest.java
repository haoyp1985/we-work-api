package com.wework.platform.common.dto.message;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.util.List;
import java.util.Map;

/**
 * 批量发送消息请求DTO
 *
 * @author WeWork Platform Team
 */
@Data
@Schema(description = "批量发送消息请求")
public class BatchSendMessageRequest {

    /**
     * 企微账号GUID
     */
    @NotBlank(message = "企微账号GUID不能为空")
    @Schema(description = "企微账号GUID", example = "5b1eb388-a4df-3da5-a49a-507eea46632c")
    private String guid;

    /**
     * 用户列表（私聊群发）
     */
    @Schema(description = "用户列表（私聊群发）")
    @Size(max = 200, message = "用户列表最多200个")
    private List<String> userList;

    /**
     * 群聊列表（群聊群发）
     */
    @Schema(description = "群聊列表（群聊群发）")
    @Size(max = 200, message = "群聊列表最多200个")
    private List<String> roomList;

    /**
     * 文本消息内容
     */
    @Schema(description = "文本消息内容")
    private String content;

    /**
     * 图片消息列表
     */
    @Schema(description = "图片消息列表")
    @Valid
    private List<ImageMessage> imageMsgList;

    /**
     * 视频消息列表
     */
    @Schema(description = "视频消息列表")
    @Valid
    private List<VideoMessage> videoMsgList;

    /**
     * 小程序消息列表
     */
    @Schema(description = "小程序消息列表")
    @Valid
    private List<MiniProgramMessage> miniProgramMsgList;

    /**
     * 链接消息列表
     */
    @Schema(description = "链接消息列表")
    @Valid
    private List<LinkMessage> linkMsgList;

    /**
     * 文件消息列表
     */
    @Schema(description = "文件消息列表")
    @Valid
    private List<FileMessage> fileMsgList;

    /**
     * 指定提供商代码（可选）
     */
    @Schema(description = "指定提供商代码")
    private String providerCode;

    /**
     * 扩展参数
     */
    @Schema(description = "扩展参数")
    private Map<String, Object> extra;

    /**
     * 图片消息
     */
    @Data
    @Schema(description = "图片消息")
    public static class ImageMessage {
        @Schema(description = "图片URL")
        private String imageUrl;

        @Schema(description = "文件大小")
        private Integer size;

        @Schema(description = "缩略图宽度")
        private Integer thumbWidth;

        @Schema(description = "缩略图高度")
        private Integer thumbHeight;
    }

    /**
     * 视频消息
     */
    @Data
    @Schema(description = "视频消息")
    public static class VideoMessage {
        @Schema(description = "文件ID")
        private String fileId;

        @Schema(description = "文件大小")
        private Integer size;

        @Schema(description = "文件名")
        private String fileName;

        @Schema(description = "AES密钥")
        private String aesKey;

        @Schema(description = "MD5校验值")
        private String md5;

        @Schema(description = "视频时长")
        private Integer videoDuration;

        @Schema(description = "视频宽度")
        private Integer videoWidth;

        @Schema(description = "视频高度")
        private Integer videoHeight;
    }

    /**
     * 小程序消息
     */
    @Data
    @Schema(description = "小程序消息")
    public static class MiniProgramMessage {
        @Schema(description = "小程序用户名")
        private String username;

        @Schema(description = "小程序AppId")
        private String appid;

        @Schema(description = "小程序名称")
        private String appname;

        @Schema(description = "小程序图标")
        private String appicon;

        @Schema(description = "小程序标题")
        private String title;

        @Schema(description = "页面路径")
        private String pagePath;

        @Schema(description = "文件ID")
        private String fileId;

        @Schema(description = "文件大小")
        private Integer size;

        @Schema(description = "AES密钥")
        private String aesKey;

        @Schema(description = "MD5校验值")
        private String md5;
    }

    /**
     * 链接消息
     */
    @Data
    @Schema(description = "链接消息")
    public static class LinkMessage {
        @Schema(description = "链接标题")
        private String title;

        @Schema(description = "链接描述")
        private String description;

        @Schema(description = "链接URL")
        private String url;

        @Schema(description = "链接图片URL")
        private String imageUrl;
    }

    /**
     * 文件消息
     */
    @Data
    @Schema(description = "文件消息")
    public static class FileMessage {
        @Schema(description = "文件ID")
        private String fileId;

        @Schema(description = "文件大小")
        private Integer size;

        @Schema(description = "文件名")
        private String fileName;

        @Schema(description = "AES密钥")
        private String aesKey;

        @Schema(description = "MD5校验值")
        private String md5;
    }
}