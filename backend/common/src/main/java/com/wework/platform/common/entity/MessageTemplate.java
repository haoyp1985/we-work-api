package com.wework.platform.common.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

/**
 * 消息模板实体
 *
 * @author WeWork Platform Team
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("message_templates")
public class MessageTemplate extends BaseEntity {

    /**
     * 模板名称
     */
    @TableField("template_name")
    private String templateName;

    /**
     * 模板类型（TEXT, IMAGE, VIDEO, LINK, MINIPROGRAM等）
     */
    @TableField("template_type")
    private String templateType;

    /**
     * 模板内容（JSON格式）
     */
    @TableField("template_content")
    private String templateContent;

    /**
     * 模板描述
     */
    @TableField("description")
    private String description;

    /**
     * 租户ID
     */
    @TableField("tenant_id")
    private Long tenantId;

    /**
     * 创建者ID
     */
    @TableField("created_by")
    private Long createdBy;

    /**
     * 是否启用
     */
    @TableField("enabled")
    private Boolean enabled;

    /**
     * 标签（用于分类）
     */
    @TableField("tags")
    private String tags;

    /**
     * 使用次数统计
     */
    @TableField("usage_count")
    private Long usageCount;

    /**
     * 最后使用时间
     */
    @TableField("last_used_time")
    private LocalDateTime lastUsedTime;
}