package com.wework.platform.user.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.wework.platform.common.core.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 用户角色关联实体
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("user_roles")
public class UserRole extends BaseEntity {

    /**
     * 用户ID
     */
    private String userId;

    /**
     * 角色ID
     */
    private String roleId;
}