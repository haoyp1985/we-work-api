-- 创建企微平台数据库
CREATE DATABASE IF NOT EXISTS `wework_platform` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 创建Nacos配置中心数据库
CREATE DATABASE IF NOT EXISTS `nacos_config` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用企微平台数据库
USE `wework_platform`;

-- 创建租户表
CREATE TABLE `tenants` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '租户ID',
    `tenant_name` VARCHAR(100) NOT NULL COMMENT '租户名称',
    `tenant_code` VARCHAR(50) UNIQUE NOT NULL COMMENT '租户编码',
    `max_accounts` INT DEFAULT 10 COMMENT '最大账号数',
    `max_daily_messages` INT DEFAULT 10000 COMMENT '日最大消息数',
    `webhook_url` VARCHAR(500) COMMENT '回调地址',
    `config` JSON COMMENT '租户配置',
    `status` ENUM('active', 'suspended', 'deleted') DEFAULT 'active' COMMENT '状态',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX `idx_tenant_code` (`tenant_code`),
    INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='租户表';

-- 创建企微账号表
CREATE TABLE `wework_accounts` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '账号ID',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `account_name` VARCHAR(100) NOT NULL COMMENT '账号名称',
    `guid` VARCHAR(100) UNIQUE COMMENT '企微实例GUID',
    `phone` VARCHAR(20) COMMENT '绑定手机号',
    `status` ENUM('created', 'logging', 'online', 'offline', 'error') NOT NULL DEFAULT 'created' COMMENT '状态',
    `config` JSON COMMENT '账号配置',
    `last_login_time` TIMESTAMP NULL COMMENT '最后登录时间',
    `last_heartbeat_time` TIMESTAMP NULL COMMENT '最后心跳时间',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX `idx_tenant_status` (`tenant_id`, `status`),
    INDEX `idx_guid` (`guid`),
    INDEX `idx_status_heartbeat` (`status`, `last_heartbeat_time`),
    FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企微账号表';

-- 创建账号状态历史表
CREATE TABLE `account_status_history` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '历史ID',
    `account_id` VARCHAR(36) NOT NULL COMMENT '账号ID',
    `old_status` VARCHAR(20) COMMENT '原状态',
    `new_status` VARCHAR(20) NOT NULL COMMENT '新状态',
    `reason` VARCHAR(500) COMMENT '变更原因',
    `extra_data` JSON COMMENT '额外数据',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX `idx_account_time` (`account_id`, `created_at`),
    FOREIGN KEY (`account_id`) REFERENCES `wework_accounts`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='账号状态历史表';

-- 创建消息记录表
CREATE TABLE `message_records` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '消息ID',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `account_id` VARCHAR(36) NOT NULL COMMENT '账号ID',
    `conversation_id` VARCHAR(100) NOT NULL COMMENT '会话ID',
    `message_type` ENUM('text', 'image', 'file', 'at', 'miniprogram') NOT NULL COMMENT '消息类型',
    `content` JSON NOT NULL COMMENT '消息内容',
    `status` ENUM('pending', 'sending', 'sent', 'delivered', 'failed') NOT NULL DEFAULT 'pending' COMMENT '发送状态',
    `wework_msg_id` VARCHAR(100) COMMENT '企微消息ID',
    `error_msg` TEXT COMMENT '错误信息',
    `send_time` TIMESTAMP NULL COMMENT '发送时间',
    `callback_time` TIMESTAMP NULL COMMENT '回调时间',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX `idx_tenant_account` (`tenant_id`, `account_id`),
    INDEX `idx_status_time` (`status`, `created_at`),
    INDEX `idx_conversation` (`conversation_id`, `created_at`),
    FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`account_id`) REFERENCES `wework_accounts`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息记录表';

-- 创建消息模板表
CREATE TABLE `message_templates` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '模板ID',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `template_name` VARCHAR(100) NOT NULL COMMENT '模板名称',
    `template_type` VARCHAR(50) NOT NULL COMMENT '模板类型',
    `template_content` JSON NOT NULL COMMENT '模板内容',
    `variables` JSON COMMENT '变量定义',
    `is_active` BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY `uk_tenant_name` (`tenant_id`, `template_name`),
    FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息模板表';

-- 创建会话信息表
CREATE TABLE `conversations` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '会话ID',
    `account_id` VARCHAR(36) NOT NULL COMMENT '账号ID',
    `conversation_id` VARCHAR(100) NOT NULL COMMENT '企微会话ID',
    `conversation_name` VARCHAR(200) COMMENT '会话名称',
    `conversation_type` ENUM('private', 'group') NOT NULL COMMENT '会话类型',
    `member_count` INT DEFAULT 0 COMMENT '成员数量',
    `last_msg_time` TIMESTAMP NULL COMMENT '最后消息时间',
    `is_active` BOOLEAN DEFAULT TRUE COMMENT '是否活跃',
    `extra_info` JSON COMMENT '额外信息',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY `uk_account_conversation` (`account_id`, `conversation_id`),
    INDEX `idx_account_type` (`account_id`, `conversation_type`),
    FOREIGN KEY (`account_id`) REFERENCES `wework_accounts`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会话信息表';

-- 创建租户配额使用记录表
CREATE TABLE `tenant_usage` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '使用记录ID',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `usage_date` DATE NOT NULL COMMENT '使用日期',
    `account_count` INT DEFAULT 0 COMMENT '账号数量',
    `message_count` INT DEFAULT 0 COMMENT '消息数量',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY `uk_tenant_date` (`tenant_id`, `usage_date`),
    FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='租户配额使用记录表';

-- 创建用户表
CREATE TABLE `users` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '用户ID',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `username` VARCHAR(50) UNIQUE NOT NULL COMMENT '用户名',
    `password` VARCHAR(255) NOT NULL COMMENT '密码hash',
    `email` VARCHAR(100) COMMENT '邮箱',
    `phone` VARCHAR(20) COMMENT '手机号',
    `real_name` VARCHAR(50) COMMENT '真实姓名',
    `role` ENUM('admin', 'operator', 'viewer') NOT NULL DEFAULT 'viewer' COMMENT '角色',
    `status` ENUM('active', 'disabled') DEFAULT 'active' COMMENT '状态',
    `last_login_time` TIMESTAMP NULL COMMENT '最后登录时间',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX `idx_tenant_role` (`tenant_id`, `role`),
    INDEX `idx_username` (`username`),
    FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 创建系统配置表
CREATE TABLE `system_configs` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '配置ID',
    `config_key` VARCHAR(100) UNIQUE NOT NULL COMMENT '配置键',
    `config_value` TEXT COMMENT '配置值',
    `config_type` ENUM('string', 'number', 'boolean', 'json') DEFAULT 'string' COMMENT '配置类型',
    `description` VARCHAR(500) COMMENT '配置描述',
    `is_public` BOOLEAN DEFAULT FALSE COMMENT '是否公开',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX `idx_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';