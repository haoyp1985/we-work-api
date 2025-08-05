package com.wework.platform.message.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * 发送消息请求
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SendMessageRequest implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 账号ID
     */
    @NotBlank(message = "账号ID不能为空")
    private String accountId;

    /**
     * 消息类型 (1:文本, 2:图片, 3:视频, 4:文件, 5:链接, 6:小程序, 7:群发)
     */
    @NotNull(message = "消息类型不能为空")
    private Integer messageType;

    /**
     * 接收者ID列表
     */
    @NotNull(message = "接收者不能为空")
    private List<String> receiverIds;

    /**
     * 接收者类型 (1:个人, 2:群组)
     */
    @NotNull(message = "接收者类型不能为空")
    private Integer receiverType;

    /**
     * 消息内容 (根据消息类型不同，内容结构不同)
     */
    private MessageContent content;

    /**
     * 模板ID (使用模板发送时)
     */
    private String templateId;

    /**
     * 模板参数 (使用模板时的变量值)
     */
    private Map<String, Object> templateParams;

    /**
     * 是否异步发送
     */
    private Boolean async = true;

    /**
     * 重试配置
     */
    private RetryConfig retryConfig;

    /**
     * 回调URL
     */
    private String callbackUrl;

    /**
     * 扩展参数
     */
    private Map<String, Object> extParams;

    /**
     * 备注
     */
    private String remark;

    /**
     * 消息内容
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class MessageContent {
        /**
         * 文本内容
         */
        private String text;

        /**
         * 媒体ID (图片/视频/文件)
         */
        private String mediaId;

        /**
         * 标题
         */
        private String title;

        /**
         * 描述
         */
        private String description;

        /**
         * 链接URL
         */
        private String url;

        /**
         * 缩略图URL
         */
        private String thumbUrl;

        /**
         * 小程序AppID
         */
        private String appId;

        /**
         * 小程序页面路径
         */
        private String pagePath;

        /**
         * 文件名
         */
        private String fileName;

        /**
         * 文件大小
         */
        private Long fileSize;

        /**
         * 附加数据
         */
        private Map<String, Object> extra;
    }

    /**
     * 重试配置
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RetryConfig {
        /**
         * 最大重试次数
         */
        private Integer maxRetryCount = 3;

        /**
         * 重试间隔（秒）
         */
        private Integer retryInterval = 60;

        /**
         * 重试策略 (1:固定间隔, 2:指数退避)
         */
        private Integer retryStrategy = 1;
    }
}