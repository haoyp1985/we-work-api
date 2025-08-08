package com.wework.platform.user.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.wework.platform.common.core.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.time.LocalDateTime;

/**
 * 用户实体
 *
 * @author WeWork Platform Team
 * @since 2.0.0
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("saas_users")
public class User extends BaseEntity {

    /**
     * 租户ID
     */
    @TableField("tenant_id")
    private String tenantId;

    /**
     * 用户名（登录账号）
     */
    @TableField("username")
    private String username;

    /**
     * 明文密码占位（不落库）。为兼容旧表字段名而保留，实际不使用。
     */
    @TableField(exist = false)
    private String password;

    /**
     * 密码哈希值
     */
    @TableField("password_hash")
    private String passwordHash;

    /**
     * 真实姓名
     */
    @TableField("real_name")
    private String realName;

    /**
     * 昵称（当前库无该列，避免映射）
     */
    @TableField(exist = false)
    private String nickname;

    /**
     * 邮箱
     */
    @TableField("email")
    private String email;

    /**
     * 手机号
     */
    @TableField("phone")
    private String phone;

    /**
     * 头像URL
     */
    @TableField("avatar_url")
    private String avatar;

    /**
     * 用户状态
     */
    @TableField("status")
    private String status;

    /**
     * 是否系统管理员
     */
    @TableField("is_admin")
    private Boolean isAdmin;

    /**
     * 最后登录时间
     */
    @TableField("last_login_at")
    private LocalDateTime lastLoginTime;

    /**
     * 最后登录IP
     */
    @TableField("last_login_ip")
    private String lastLoginIp;

    /**
     * 登录失败次数
     */
    @TableField("failed_login_attempts")
    private Integer failedLoginCount;

    /**
     * 账号锁定到期时间
     */
    @TableField("locked_until")
    private LocalDateTime lockedUntil;

}