-- =================================================================
-- WeWork Platform - saas_unified_core 数据库表结构
-- 版本: v2.0
-- 数据库: saas_unified_core
-- 说明: 用户权限管理、系统配置相关表
-- =================================================================

USE `saas_unified_core`;

-- ===== 租户管理 =====

-- 租户表
CREATE TABLE `tenants` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '租户ID',
    `tenant_name` VARCHAR(100) NOT NULL COMMENT '租户名称',
    `tenant_code` VARCHAR(50) UNIQUE NOT NULL COMMENT '租户编码',
    `contact_email` VARCHAR(100) COMMENT '联系邮箱',
    `contact_phone` VARCHAR(20) COMMENT '联系电话',
    `status` ENUM('active', 'inactive', 'suspended') DEFAULT 'active' COMMENT '状态',
    `quota_accounts` INT DEFAULT 100 COMMENT '账号配额',
    `quota_messages` BIGINT DEFAULT 1000000 COMMENT '消息配额',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX `idx_tenant_code` (`tenant_code`),
    INDEX `idx_status` (`status`),
    INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='租户表';

-- ===== 用户权限管理 =====

-- 用户表
CREATE TABLE `users` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '用户ID',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `username` VARCHAR(50) NOT NULL COMMENT '用户名',
    `password` VARCHAR(255) NOT NULL COMMENT '密码(加密)',
    `real_name` VARCHAR(50) COMMENT '真实姓名',
    `email` VARCHAR(100) COMMENT '邮箱',
    `phone` VARCHAR(20) COMMENT '手机号',
    `avatar_url` VARCHAR(255) COMMENT '头像URL',
    `status` ENUM('active', 'inactive', 'locked') DEFAULT 'active' COMMENT '状态',
    `last_login_at` TIMESTAMP NULL COMMENT '最后登录时间',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY `uk_tenant_username` (`tenant_id`, `username`),
    INDEX `idx_tenant_id` (`tenant_id`),
    INDEX `idx_email` (`email`),
    INDEX `idx_status` (`status`),
    FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 角色表
CREATE TABLE `roles` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '角色ID',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `role_name` VARCHAR(50) NOT NULL COMMENT '角色名称',
    `role_code` VARCHAR(50) NOT NULL COMMENT '角色编码',
    `description` TEXT COMMENT '角色描述',
    `is_system` BOOLEAN DEFAULT FALSE COMMENT '是否系统角色',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY `uk_tenant_role_code` (`tenant_id`, `role_code`),
    INDEX `idx_tenant_id` (`tenant_id`),
    FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色表';

-- 权限表
CREATE TABLE `permissions` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '权限ID',
    `permission_name` VARCHAR(100) NOT NULL COMMENT '权限名称',
    `permission_code` VARCHAR(100) UNIQUE NOT NULL COMMENT '权限编码',
    `resource_type` VARCHAR(50) NOT NULL COMMENT '资源类型',
    `action_type` VARCHAR(50) NOT NULL COMMENT '操作类型',
    `description` TEXT COMMENT '权限描述',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX `idx_permission_code` (`permission_code`),
    INDEX `idx_resource_type` (`resource_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='权限表';

-- 用户角色关联表
CREATE TABLE `user_roles` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT 'ID',
    `user_id` VARCHAR(36) NOT NULL COMMENT '用户ID',
    `role_id` VARCHAR(36) NOT NULL COMMENT '角色ID',
    `assigned_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '分配时间',
    
    UNIQUE KEY `uk_user_role` (`user_id`, `role_id`),
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_role_id` (`role_id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户角色关联表';

-- 角色权限关联表
CREATE TABLE `role_permissions` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT 'ID',
    `role_id` VARCHAR(36) NOT NULL COMMENT '角色ID',
    `permission_id` VARCHAR(36) NOT NULL COMMENT '权限ID',
    `assigned_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '分配时间',
    
    UNIQUE KEY `uk_role_permission` (`role_id`, `permission_id`),
    INDEX `idx_role_id` (`role_id`),
    INDEX `idx_permission_id` (`permission_id`),
    FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`permission_id`) REFERENCES `permissions`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色权限关联表';

-- ===== 系统配置 =====

-- 系统配置表
CREATE TABLE `system_configs` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '配置ID',
    `config_key` VARCHAR(100) UNIQUE NOT NULL COMMENT '配置键',
    `config_value` TEXT NOT NULL COMMENT '配置值',
    `config_type` ENUM('string', 'number', 'boolean', 'json') DEFAULT 'string' COMMENT '配置类型',
    `description` TEXT COMMENT '配置描述',
    `is_encrypted` BOOLEAN DEFAULT FALSE COMMENT '是否加密',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX `idx_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';

-- 租户配置表
CREATE TABLE `tenant_configs` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '配置ID',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `config_key` VARCHAR(100) NOT NULL COMMENT '配置键',
    `config_value` TEXT NOT NULL COMMENT '配置值',
    `config_type` ENUM('string', 'number', 'boolean', 'json') DEFAULT 'string' COMMENT '配置类型',
    `description` TEXT COMMENT '配置描述',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY `uk_tenant_config_key` (`tenant_id`, `config_key`),
    INDEX `idx_tenant_id` (`tenant_id`),
    FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='租户配置表';

-- ===== 审计日志 =====

-- 操作日志表
CREATE TABLE `operation_logs` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '日志ID',
    `tenant_id` VARCHAR(36) COMMENT '租户ID',
    `user_id` VARCHAR(36) COMMENT '用户ID',
    `operation_type` VARCHAR(50) NOT NULL COMMENT '操作类型',
    `resource_type` VARCHAR(50) NOT NULL COMMENT '资源类型',
    `resource_id` VARCHAR(36) COMMENT '资源ID',
    `operation_desc` TEXT COMMENT '操作描述',
    `request_data` JSON COMMENT '请求数据',
    `response_data` JSON COMMENT '响应数据',
    `ip_address` VARCHAR(45) COMMENT 'IP地址',
    `user_agent` TEXT COMMENT '用户代理',
    `status` ENUM('success', 'failed') NOT NULL COMMENT '操作状态',
    `error_message` TEXT COMMENT '错误信息',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX `idx_tenant_id` (`tenant_id`),
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_operation_type` (`operation_type`),
    INDEX `idx_created_at` (`created_at`),
    FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志表';

-- ===== 配额管理 =====

-- 租户配额使用表
CREATE TABLE `tenant_quota_usage` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT 'ID',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `resource_type` VARCHAR(50) NOT NULL COMMENT '资源类型',
    `quota_limit` BIGINT NOT NULL COMMENT '配额限制',
    `quota_used` BIGINT DEFAULT 0 COMMENT '已使用配额',
    `period_type` ENUM('day', 'month', 'year') NOT NULL COMMENT '周期类型',
    `period_start` DATE NOT NULL COMMENT '周期开始日期',
    `period_end` DATE NOT NULL COMMENT '周期结束日期',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY `uk_tenant_resource_period` (`tenant_id`, `resource_type`, `period_start`),
    INDEX `idx_tenant_id` (`tenant_id`),
    INDEX `idx_period` (`period_start`, `period_end`),
    FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='租户配额使用表';

-- ===== 字典数据 =====

-- 字典表
CREATE TABLE `dictionaries` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '字典ID',
    `dict_code` VARCHAR(50) NOT NULL COMMENT '字典编码',
    `dict_name` VARCHAR(100) NOT NULL COMMENT '字典名称',
    `parent_id` VARCHAR(36) COMMENT '父级ID',
    `dict_value` VARCHAR(255) COMMENT '字典值',
    `sort_order` INT DEFAULT 0 COMMENT '排序',
    `is_enabled` BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    `description` TEXT COMMENT '描述',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX `idx_dict_code` (`dict_code`),
    INDEX `idx_parent_id` (`parent_id`),
    INDEX `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字典表';

-- ===== 优化索引 =====

-- 复合索引优化
CREATE INDEX `idx_tenant_status_created` ON `users` (`tenant_id`, `status`, `created_at`);
CREATE INDEX `idx_operation_tenant_time` ON `operation_logs` (`tenant_id`, `operation_type`, `created_at`);