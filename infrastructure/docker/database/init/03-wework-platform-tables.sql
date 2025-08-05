-- =================================================================
-- WeWork Platform - wework_platform 数据库表结构
-- 版本: v2.0
-- 数据库: wework_platform
-- 说明: 企微账号管理、消息发送相关表
-- =================================================================

USE `wework_platform`;

-- ===== 企微账号管理 =====

-- 企微账号表
CREATE TABLE `wework_accounts` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '账号ID',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `account_name` VARCHAR(100) NOT NULL COMMENT '账号名称',
    `wework_guid` VARCHAR(100) UNIQUE NOT NULL COMMENT '企微GUID',
    `wework_corp_id` VARCHAR(100) COMMENT '企业ID',
    `wework_secret` VARCHAR(255) COMMENT '企业密钥',
    `account_config` JSON COMMENT '账号配置',
    `status` ENUM('created', 'initializing', 'waiting_qr', 'waiting_confirm', 'verifying', 'online', 'offline', 'error', 'recovering') DEFAULT 'created' COMMENT '账号状态',
    `last_heartbeat_at` TIMESTAMP NULL COMMENT '最后心跳时间',
    `error_message` TEXT COMMENT '错误信息',
    `login_qr_code` TEXT COMMENT '登录二维码',
    `device_info` JSON COMMENT '设备信息',
    `proxy_config` JSON COMMENT '代理配置',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX `idx_tenant_id` (`tenant_id`),
    INDEX `idx_wework_guid` (`wework_guid`),
    INDEX `idx_status` (`status`),
    INDEX `idx_last_heartbeat` (`last_heartbeat_at`),
    INDEX `idx_tenant_status_created` (`tenant_id`, `status`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企微账号表';

-- 账号状态变更记录表
CREATE TABLE `account_status_logs` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '记录ID',
    `account_id` VARCHAR(36) NOT NULL COMMENT '账号ID',
    `old_status` VARCHAR(50) COMMENT '原状态',
    `new_status` VARCHAR(50) NOT NULL COMMENT '新状态',
    `change_reason` VARCHAR(255) COMMENT '变更原因',
    `error_details` TEXT COMMENT '错误详情',
    `operator_id` VARCHAR(36) COMMENT '操作人ID',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX `idx_account_id` (`account_id`),
    INDEX `idx_new_status` (`new_status`),
    INDEX `idx_created_at` (`created_at`),
    FOREIGN KEY (`account_id`) REFERENCES `wework_accounts`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='账号状态变更记录表';

-- ===== 联系人管理 =====

-- 联系人表
CREATE TABLE `contacts` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '联系人ID',
    `account_id` VARCHAR(36) NOT NULL COMMENT '账号ID',
    `contact_wework_id` VARCHAR(100) NOT NULL COMMENT '企微联系人ID',
    `contact_name` VARCHAR(100) COMMENT '联系人姓名',
    `contact_alias` VARCHAR(100) COMMENT '联系人备注',
    `contact_type` ENUM('user', 'group', 'external') NOT NULL COMMENT '联系人类型',
    `contact_avatar` VARCHAR(255) COMMENT '头像URL',
    `phone_number` VARCHAR(20) COMMENT '手机号',
    `email` VARCHAR(100) COMMENT '邮箱',
    `department` VARCHAR(100) COMMENT '部门',
    `is_friend` BOOLEAN DEFAULT FALSE COMMENT '是否好友',
    `is_blocked` BOOLEAN DEFAULT FALSE COMMENT '是否被拉黑',
    `tags` JSON COMMENT '标签',
    `last_active_at` TIMESTAMP NULL COMMENT '最后活跃时间',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY `uk_account_contact` (`account_id`, `contact_wework_id`),
    INDEX `idx_account_id` (`account_id`),
    INDEX `idx_contact_type` (`contact_type`),
    INDEX `idx_contact_name` (`contact_name`),
    FOREIGN KEY (`account_id`) REFERENCES `wework_accounts`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='联系人表';

-- 群聊表
CREATE TABLE `groups` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '群聊ID',
    `account_id` VARCHAR(36) NOT NULL COMMENT '账号ID',
    `group_wework_id` VARCHAR(100) NOT NULL COMMENT '企微群ID',
    `group_name` VARCHAR(100) NOT NULL COMMENT '群名称',
    `group_notice` TEXT COMMENT '群公告',
    `member_count` INT DEFAULT 0 COMMENT '成员数量',
    `is_owner` BOOLEAN DEFAULT FALSE COMMENT '是否群主',
    `is_admin` BOOLEAN DEFAULT FALSE COMMENT '是否管理员',
    `group_avatar` VARCHAR(255) COMMENT '群头像',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY `uk_account_group` (`account_id`, `group_wework_id`),
    INDEX `idx_account_id` (`account_id`),
    INDEX `idx_group_name` (`group_name`),
    FOREIGN KEY (`account_id`) REFERENCES `wework_accounts`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='群聊表';

-- ===== 消息管理 =====

-- 消息模板表
CREATE TABLE `message_templates` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '模板ID',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `template_name` VARCHAR(100) NOT NULL COMMENT '模板名称',
    `template_type` ENUM('text', 'image', 'file', 'video', 'card', 'link') NOT NULL COMMENT '模板类型',
    `template_content` JSON NOT NULL COMMENT '模板内容',
    `variables` JSON COMMENT '变量配置',
    `tags` JSON COMMENT '标签',
    `is_active` BOOLEAN DEFAULT TRUE COMMENT '是否激活',
    `usage_count` BIGINT DEFAULT 0 COMMENT '使用次数',
    `created_by` VARCHAR(36) COMMENT '创建者ID',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX `idx_tenant_id` (`tenant_id`),
    INDEX `idx_template_type` (`template_type`),
    INDEX `idx_template_name` (`template_name`),
    INDEX `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息模板表';

-- 消息发送任务表
CREATE TABLE `message_tasks` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '任务ID',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `task_name` VARCHAR(100) NOT NULL COMMENT '任务名称',
    `task_type` ENUM('single', 'batch', 'scheduled', 'recurring') NOT NULL COMMENT '任务类型',
    `account_id` VARCHAR(36) NOT NULL COMMENT '发送账号ID',
    `template_id` VARCHAR(36) COMMENT '消息模板ID',
    `message_content` JSON NOT NULL COMMENT '消息内容',
    `recipients` JSON NOT NULL COMMENT '收件人列表',
    `send_config` JSON COMMENT '发送配置',
    `schedule_config` JSON COMMENT '定时配置',
    `status` ENUM('pending', 'running', 'paused', 'completed', 'failed', 'cancelled') DEFAULT 'pending' COMMENT '任务状态',
    `total_count` INT DEFAULT 0 COMMENT '总发送数量',
    `success_count` INT DEFAULT 0 COMMENT '成功数量',
    `failed_count` INT DEFAULT 0 COMMENT '失败数量',
    `progress_percentage` DECIMAL(5,2) DEFAULT 0.00 COMMENT '完成进度',
    `started_at` TIMESTAMP NULL COMMENT '开始时间',
    `completed_at` TIMESTAMP NULL COMMENT '完成时间',
    `error_message` TEXT COMMENT '错误信息',
    `created_by` VARCHAR(36) COMMENT '创建者ID',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX `idx_tenant_id` (`tenant_id`),
    INDEX `idx_account_id` (`account_id`),
    INDEX `idx_status` (`status`),
    INDEX `idx_task_type` (`task_type`),
    INDEX `idx_created_at` (`created_at`),
    INDEX `idx_tenant_type_created` (`tenant_id`, `task_type`, `created_at`),
    FOREIGN KEY (`account_id`) REFERENCES `wework_accounts`(`id`),
    FOREIGN KEY (`template_id`) REFERENCES `message_templates`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息发送任务表';

-- 消息发送记录表 (分区表)
CREATE TABLE `message_records` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '记录ID',
    `task_id` VARCHAR(36) NOT NULL COMMENT '任务ID',
    `account_id` VARCHAR(36) NOT NULL COMMENT '发送账号ID',
    `recipient_id` VARCHAR(100) NOT NULL COMMENT '接收者ID',
    `recipient_name` VARCHAR(100) COMMENT '接收者姓名',
    `recipient_type` ENUM('user', 'group') NOT NULL COMMENT '接收者类型',
    `message_type` ENUM('text', 'image', 'file', 'video', 'card', 'link') NOT NULL COMMENT '消息类型',
    `message_content` JSON NOT NULL COMMENT '消息内容',
    `wework_message_id` VARCHAR(100) COMMENT '企微消息ID',
    `send_status` ENUM('pending', 'sending', 'sent', 'delivered', 'read', 'failed') DEFAULT 'pending' COMMENT '发送状态',
    `failure_reason` VARCHAR(255) COMMENT '失败原因',
    `retry_count` INT DEFAULT 0 COMMENT '重试次数',
    `sent_at` TIMESTAMP NULL COMMENT '发送时间',
    `delivered_at` TIMESTAMP NULL COMMENT '送达时间',
    `read_at` TIMESTAMP NULL COMMENT '阅读时间',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX `idx_task_id` (`task_id`),
    INDEX `idx_account_id` (`account_id`),
    INDEX `idx_recipient_id` (`recipient_id`),
    INDEX `idx_send_status` (`send_status`),
    INDEX `idx_sent_at` (`sent_at`),
    INDEX `idx_account_status_sent` (`account_id`, `send_status`, `sent_at`),
    FOREIGN KEY (`task_id`) REFERENCES `message_tasks`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`account_id`) REFERENCES `wework_accounts`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
PARTITION BY RANGE (UNIX_TIMESTAMP(`created_at`)) (
    PARTITION p202501 VALUES LESS THAN (UNIX_TIMESTAMP('2025-02-01')),
    PARTITION p202502 VALUES LESS THAN (UNIX_TIMESTAMP('2025-03-01')),
    PARTITION p202503 VALUES LESS THAN (UNIX_TIMESTAMP('2025-04-01')),
    PARTITION p202504 VALUES LESS THAN (UNIX_TIMESTAMP('2025-05-01')),
    PARTITION p202505 VALUES LESS THAN (UNIX_TIMESTAMP('2025-06-01')),
    PARTITION p202506 VALUES LESS THAN (UNIX_TIMESTAMP('2025-07-01')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
) COMMENT='消息发送记录表';

-- 消息回调记录表
CREATE TABLE `message_callbacks` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '回调ID',
    `message_record_id` VARCHAR(36) NOT NULL COMMENT '消息记录ID',
    `callback_type` ENUM('delivery', 'read', 'click', 'reply') NOT NULL COMMENT '回调类型',
    `callback_data` JSON NOT NULL COMMENT '回调数据',
    `callback_time` TIMESTAMP NOT NULL COMMENT '回调时间',
    `processed` BOOLEAN DEFAULT FALSE COMMENT '是否已处理',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX `idx_message_record_id` (`message_record_id`),
    INDEX `idx_callback_type` (`callback_type`),
    INDEX `idx_callback_time` (`callback_time`),
    INDEX `idx_processed` (`processed`),
    FOREIGN KEY (`message_record_id`) REFERENCES `message_records`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息回调记录表';

-- ===== 文件管理 =====

-- 文件资源表
CREATE TABLE `file_resources` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '文件ID',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `file_name` VARCHAR(255) NOT NULL COMMENT '文件名',
    `file_type` ENUM('image', 'video', 'audio', 'document', 'other') NOT NULL COMMENT '文件类型',
    `file_size` BIGINT NOT NULL COMMENT '文件大小(字节)',
    `file_path` VARCHAR(500) NOT NULL COMMENT '文件路径',
    `file_url` VARCHAR(500) COMMENT '访问URL',
    `file_hash` VARCHAR(64) COMMENT '文件哈希',
    `mime_type` VARCHAR(100) COMMENT 'MIME类型',
    `storage_type` ENUM('local', 'oss', 'cos', 's3') DEFAULT 'local' COMMENT '存储类型',
    `usage_count` BIGINT DEFAULT 0 COMMENT '使用次数',
    `uploaded_by` VARCHAR(36) COMMENT '上传者ID',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX `idx_tenant_id` (`tenant_id`),
    INDEX `idx_file_type` (`file_type`),
    INDEX `idx_file_hash` (`file_hash`),
    INDEX `idx_uploaded_by` (`uploaded_by`),
    INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文件资源表';

-- 文件使用记录表
CREATE TABLE `file_usage_records` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '记录ID',
    `file_id` VARCHAR(36) NOT NULL COMMENT '文件ID',
    `usage_type` ENUM('message', 'template', 'avatar', 'other') NOT NULL COMMENT '使用类型',
    `reference_id` VARCHAR(36) COMMENT '关联ID',
    `used_by` VARCHAR(36) COMMENT '使用者ID',
    `used_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '使用时间',
    
    INDEX `idx_file_id` (`file_id`),
    INDEX `idx_usage_type` (`usage_type`),
    INDEX `idx_reference_id` (`reference_id`),
    INDEX `idx_used_at` (`used_at`),
    FOREIGN KEY (`file_id`) REFERENCES `file_resources`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文件使用记录表';

-- ===== 标签管理 =====

-- 标签表
CREATE TABLE `tags` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '标签ID',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `tag_name` VARCHAR(50) NOT NULL COMMENT '标签名称',
    `tag_color` VARCHAR(7) DEFAULT '#409EFF' COMMENT '标签颜色',
    `tag_type` ENUM('contact', 'group', 'message', 'custom') DEFAULT 'custom' COMMENT '标签类型',
    `description` TEXT COMMENT '标签描述',
    `created_by` VARCHAR(36) COMMENT '创建者ID',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    UNIQUE KEY `uk_tenant_tag_name` (`tenant_id`, `tag_name`),
    INDEX `idx_tenant_id` (`tenant_id`),
    INDEX `idx_tag_type` (`tag_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签表';

-- 标签关联表
CREATE TABLE `tag_relations` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '关联ID',
    `tag_id` VARCHAR(36) NOT NULL COMMENT '标签ID',
    `target_type` ENUM('contact', 'group', 'message', 'account') NOT NULL COMMENT '目标类型',
    `target_id` VARCHAR(36) NOT NULL COMMENT '目标ID',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    UNIQUE KEY `uk_tag_target` (`tag_id`, `target_type`, `target_id`),
    INDEX `idx_tag_id` (`tag_id`),
    INDEX `idx_target` (`target_type`, `target_id`),
    FOREIGN KEY (`tag_id`) REFERENCES `tags`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签关联表';