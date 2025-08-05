package com.wework.platform.message.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;

/**
 * 创建模板请求
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateTemplateRequest implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 模板名称
     */
    @NotBlank(message = "模板名称不能为空")
    private String templateName;

    /**
     * 模板编码
     */
    @NotBlank(message = "模板编码不能为空")
    private String templateCode;

    /**
     * 模板类型 (1:文本, 2:图文, 3:卡片, 4:小程序)
     */
    @NotNull(message = "模板类型不能为空")
    private Integer templateType;

    /**
     * 消息类别 (1:营销, 2:通知, 3:提醒, 4:其他)
     */
    @NotNull(message = "消息类别不能为空")
    private Integer messageCategory;

    /**
     * 模板标题
     */
    private String title;

    /**
     * 模板内容
     */
    @NotBlank(message = "模板内容不能为空")
    private String content;

    /**
     * 变量定义
     */
    private List<MessageTemplateDTO.TemplateVariable> variables;

    /**
     * 缩略图URL
     */
    private String thumbUrl;

    /**
     * 链接URL
     */
    private String linkUrl;

    /**
     * 小程序AppID
     */
    private String appId;

    /**
     * 小程序页面路径
     */
    private String pagePath;

    /**
     * 适用场景
     */
    private String scenario;

    /**
     * 备注
     */
    private String remark;
}