package com.wework.platform.user.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.wework.platform.common.core.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 角色权限关联实体
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("role_permissions")
public class RolePermission extends BaseEntity {

    /**
     * 角色ID
     */
    private String roleId;

    /**
     * 权限ID
     */
    private String permissionId;
}