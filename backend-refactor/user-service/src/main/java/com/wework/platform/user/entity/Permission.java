package com.wework.platform.user.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.wework.platform.common.core.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 权限实体
 *
 * @author WeWork Platform Team
 * @since 2.0.0
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("permissions")
public class Permission extends BaseEntity {

    /**
     * 权限编码
     */
    @TableField("permission_code")
    private String permissionCode;

    /**
     * 权限名称
     */
    @TableField("permission_name")
    private String permissionName;

    /**
     * 权限描述
     */
    @TableField("description")
    private String description;

    /**
     * 权限类型（MENU:菜单, BUTTON:按钮, API:接口）
     */
    @TableField("permission_type")
    private String permissionType;

    /**
     * 父权限ID
     */
    @TableField("parent_id")
    private String parentId;

    /**
     * 权限路径
     */
    @TableField("permission_path")
    private String permissionPath;

    /**
     * 菜单图标
     */
    @TableField("icon")
    private String icon;

    /**
     * 组件路径
     */
    @TableField("component")
    private String component;

    /**
     * 是否系统内置权限
     */
    @TableField("is_builtin")
    private Boolean isBuiltin;

    /**
     * 权限状态
     */
    @TableField("status")
    private String status;

    /**
     * 排序
     */
    @TableField("sort_order")
    private Integer sortOrder;

    /**
     * 是否删除（软删除）
     */
    @TableLogic
    @TableField("deleted")
    private Boolean deleted;
}