package com.wework.platform.message.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.List;

/**
 * 更新模板请求
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UpdateTemplateRequest implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 模板名称
     */
    private String templateName;

    /**
     * 模板类型
     */
    private Integer templateType;

    /**
     * 消息类别
     */
    private Integer messageCategory;

    /**
     * 模板标题
     */
    private String title;

    /**
     * 模板内容
     */
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
     * 状态
     */
    private Integer status;

    /**
     * 备注
     */
    private String remark;
}