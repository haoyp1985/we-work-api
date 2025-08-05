package com.wework.platform.message.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wework.platform.common.core.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 消息模板实体
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("message_templates")
public class MessageTemplate extends BaseEntity {

    /**
     * 模板ID
     */
    @TableId(type = IdType.ASSIGN_ID)
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
     * 模板编码 (唯一标识)
     */
    private String templateCode;

    /**
     * 模板类型 (1:文本, 2:图文, 3:卡片, 4:小程序)
     */
    private Integer templateType;

    /**
     * 消息类型 (1:营销, 2:通知, 3:提醒, 4:其他)
     */
    private Integer messageCategory;

    /**
     * 模板标题
     */
    private String title;

    /**
     * 模板内容 (支持变量替换)
     */
    private String content;

    /**
     * 变量定义 (JSON格式)
     */
    private String variables;

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
     * 是否系统模板
     */
    private Boolean isSystem;

    /**
     * 适用场景描述
     */
    private String scenario;

    /**
     * 审核状态 (0:待审核, 1:审核通过, 2:审核拒绝)
     */
    private Integer auditStatus;

    /**
     * 审核备注
     */
    private String auditRemark;

    /**
     * 审核人ID
     */
    private String auditorId;

    /**
     * 审核时间
     */
    private Long auditTime;

    /**
     * 扩展配置 (JSON格式)
     */
    private String extConfig;

    /**
     * 备注
     */
    private String remark;
}