package com.wework.platform.message.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * 消息模板数据传输对象
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MessageTemplateDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 模板ID
     */
    private String id;

    /**
     * 租户ID
     */
    private String tenantId;

    /**
     * 模板名称
     */
    private String templateName;

    /**
     * 模板编码
     */
    private String templateCode;

    /**
     * 模板类型 (1:文本, 2:图文, 3:卡片, 4:小程序)
     */
    private Integer templateType;

    /**
     * 模板类型名称
     */
    private String templateTypeName;

    /**
     * 消息类别 (1:营销, 2:通知, 3:提醒, 4:其他)
     */
    private Integer messageCategory;

    /**
     * 消息类别名称
     */
    private String messageCategoryName;

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
    private List<TemplateVariable> variables;

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
     * 状态 (0:草稿, 1:启用, 2:停用)
     */
    private Integer status;

    /**
     * 状态名称
     */
    private String statusName;

    /**
     * 使用次数
     */
    private Integer useCount;

    /**
     * 成功次数
     */
    private Integer successCount;

    /**
     * 失败次数
     */
    private Integer failCount;

    /**
     * 成功率
     */
    private Double successRate;

    /**
     * 是否系统模板
     */
    private Boolean isSystem;

    /**
     * 适用场景
     */
    private String scenario;

    /**
     * 审核状态 (0:待审核, 1:审核通过, 2:审核拒绝)
     */
    private Integer auditStatus;

    /**
     * 审核状态名称
     */
    private String auditStatusName;

    /**
     * 审核备注
     */
    private String auditRemark;

    /**
     * 审核人名称
     */
    private String auditorName;

    /**
     * 审核时间
     */
    private Long auditTime;

    /**
     * 创建人ID
     */
    private String creatorId;

    /**
     * 创建人名称
     */
    private String creatorName;

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

    /**
     * 模板变量定义
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TemplateVariable {
        /**
         * 变量名
         */
        private String name;

        /**
         * 变量键
         */
        private String key;

        /**
         * 变量类型 (string, number, date, boolean)
         */
        private String type;

        /**
         * 默认值
         */
        private String defaultValue;

        /**
         * 是否必填
         */
        private Boolean required;

        /**
         * 描述
         */
        private String description;

        /**
         * 示例值
         */
        private String example;
    }
}