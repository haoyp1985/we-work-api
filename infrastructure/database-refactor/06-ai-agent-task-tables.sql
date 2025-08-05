-- =================================================================
-- WeWork Platform - AI Agent Service & Task Service 数据库表结构
-- 版本: v2.0
-- 数据库: wework_platform
-- 说明: AI智能体管理、任务调度相关表
-- =================================================================

USE `wework_platform`;

-- ===== AI智能体服务表 =====

-- AI智能体表
CREATE TABLE `agents` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '智能体ID',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `name` VARCHAR(100) NOT NULL COMMENT '智能体名称',
    `description` TEXT COMMENT '智能体描述',
    `avatar` VARCHAR(255) COMMENT '智能体头像',
    `type` VARCHAR(50) NOT NULL COMMENT '智能体类型',
    `status` VARCHAR(50) NOT NULL COMMENT '智能体状态',
    `platform_type` VARCHAR(50) COMMENT '外部平台类型(COZE/DIFY/DIRECT_MODEL)',
    `platform_config_id` VARCHAR(36) COMMENT '外部平台配置ID',
    `model_config_id` VARCHAR(36) COMMENT '模型配置ID',
    `system_prompt` TEXT COMMENT '系统提示词',
    `config_json` JSON COMMENT '智能体配置JSON',
    `enabled` BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    `sort_order` INT DEFAULT 0 COMMENT '排序',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by` VARCHAR(36) COMMENT '创建者ID',
    `updated_by` VARCHAR(36) COMMENT '更新者ID',
    `deleted_at` TIMESTAMP NULL COMMENT '删除时间',
    
    INDEX `idx_tenant_id` (`tenant_id`),
    INDEX `idx_type` (`type`),
    INDEX `idx_status` (`status`),
    INDEX `idx_enabled` (`enabled`),
    INDEX `idx_sort_order` (`sort_order`),
    INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI智能体表';

-- 对话会话表
CREATE TABLE `conversations` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '会话ID',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `agent_id` VARCHAR(36) NOT NULL COMMENT '智能体ID',
    `user_id` VARCHAR(36) COMMENT '用户ID',
    `session_id` VARCHAR(100) COMMENT '会话标识',
    `title` VARCHAR(200) COMMENT '会话标题',
    `status` VARCHAR(50) DEFAULT 'active' COMMENT '会话状态',
    `context_data` JSON COMMENT '上下文数据',
    `message_count` INT DEFAULT 0 COMMENT '消息数量',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `last_message_at` TIMESTAMP NULL COMMENT '最后消息时间',
    `deleted_at` TIMESTAMP NULL COMMENT '删除时间',
    
    INDEX `idx_tenant_id` (`tenant_id`),
    INDEX `idx_agent_id` (`agent_id`),
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_session_id` (`session_id`),
    INDEX `idx_status` (`status`),
    INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='对话会话表';

-- 消息表（AI Agent用）
CREATE TABLE `agent_messages` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '消息ID',
    `conversation_id` VARCHAR(36) NOT NULL COMMENT '会话ID',
    `agent_id` VARCHAR(36) NOT NULL COMMENT '智能体ID',
    `role` VARCHAR(20) NOT NULL COMMENT '角色(user/assistant/system)',
    `content` TEXT NOT NULL COMMENT '消息内容',
    `content_type` VARCHAR(50) DEFAULT 'text' COMMENT '内容类型',
    `metadata` JSON COMMENT '元数据',
    `tokens` INT COMMENT 'Token数量',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX `idx_conversation_id` (`conversation_id`),
    INDEX `idx_agent_id` (`agent_id`),
    INDEX `idx_role` (`role`),
    INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI智能体消息表';

-- 调用记录表
CREATE TABLE `call_records` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '调用记录ID',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `agent_id` VARCHAR(36) NOT NULL COMMENT '智能体ID',
    `conversation_id` VARCHAR(36) COMMENT '会话ID',
    `request_id` VARCHAR(100) COMMENT '请求ID',
    `input_tokens` INT COMMENT '输入Token数',
    `output_tokens` INT COMMENT '输出Token数',
    `total_tokens` INT COMMENT '总Token数',
    `cost` DECIMAL(10,6) COMMENT '成本',
    `duration_ms` INT COMMENT '调用耗时(毫秒)',
    `status` VARCHAR(50) COMMENT '调用状态',
    `error_message` TEXT COMMENT '错误信息',
    `platform_request_id` VARCHAR(100) COMMENT '平台请求ID',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX `idx_tenant_id` (`tenant_id`),
    INDEX `idx_agent_id` (`agent_id`),
    INDEX `idx_conversation_id` (`conversation_id`),
    INDEX `idx_status` (`status`),
    INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI调用记录表';

-- 模型配置表
CREATE TABLE `model_configs` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '配置ID',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `name` VARCHAR(100) NOT NULL COMMENT '配置名称',
    `model_type` VARCHAR(50) NOT NULL COMMENT '模型类型',
    `model_name` VARCHAR(100) NOT NULL COMMENT '模型名称',
    `api_endpoint` VARCHAR(255) COMMENT 'API端点',
    `api_key` VARCHAR(255) COMMENT 'API密钥',
    `config_params` JSON COMMENT '配置参数',
    `enabled` BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by` VARCHAR(36) COMMENT '创建者ID',
    `updated_by` VARCHAR(36) COMMENT '更新者ID',
    `deleted_at` TIMESTAMP NULL COMMENT '删除时间',
    
    INDEX `idx_tenant_id` (`tenant_id`),
    INDEX `idx_model_type` (`model_type`),
    INDEX `idx_enabled` (`enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='模型配置表';

-- 平台配置表
CREATE TABLE `platform_configs` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '配置ID',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `platform_type` VARCHAR(50) NOT NULL COMMENT '平台类型',
    `name` VARCHAR(100) NOT NULL COMMENT '配置名称',
    `config_data` JSON NOT NULL COMMENT '配置数据',
    `enabled` BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by` VARCHAR(36) COMMENT '创建者ID',
    `updated_by` VARCHAR(36) COMMENT '更新者ID',
    `deleted_at` TIMESTAMP NULL COMMENT '删除时间',
    
    INDEX `idx_tenant_id` (`tenant_id`),
    INDEX `idx_platform_type` (`platform_type`),
    INDEX `idx_enabled` (`enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='平台配置表';

-- ===== 任务调度服务表 =====

-- 任务定义表
CREATE TABLE `task_definitions` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '任务ID',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `task_name` VARCHAR(100) NOT NULL COMMENT '任务名称',
    `description` TEXT COMMENT '任务描述',
    `task_type` VARCHAR(50) NOT NULL COMMENT '任务类型',
    `status` VARCHAR(50) NOT NULL COMMENT '任务状态',
    `task_class` VARCHAR(255) COMMENT '任务执行类',
    `task_method` VARCHAR(100) COMMENT '任务方法名',
    `task_params` JSON COMMENT '任务参数',
    `cron_expression` VARCHAR(100) COMMENT 'Cron表达式',
    `fixed_rate` INT COMMENT '固定间隔(秒)',
    `fixed_delay` INT COMMENT '固定延迟(秒)',
    `priority` INT DEFAULT 0 COMMENT '优先级(1-10)',
    `max_retry_count` INT DEFAULT 3 COMMENT '最大重试次数',
    `retry_count` INT DEFAULT 0 COMMENT '当前重试次数',
    `timeout_seconds` INT DEFAULT 300 COMMENT '超时时间(秒)',
    `enabled` BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    `next_execute_time` TIMESTAMP NULL COMMENT '下次执行时间',
    `last_execute_time` TIMESTAMP NULL COMMENT '上次执行时间',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by` VARCHAR(36) COMMENT '创建者ID',
    `updated_by` VARCHAR(36) COMMENT '更新者ID',
    `deleted_at` TIMESTAMP NULL COMMENT '删除时间',
    
    INDEX `idx_tenant_id` (`tenant_id`),
    INDEX `idx_task_type` (`task_type`),
    INDEX `idx_status` (`status`),
    INDEX `idx_enabled` (`enabled`),
    INDEX `idx_next_execute_time` (`next_execute_time`),
    INDEX `idx_priority` (`priority`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='任务定义表';

-- 任务实例表
CREATE TABLE `task_instances` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '实例ID',
    `task_definition_id` VARCHAR(36) NOT NULL COMMENT '任务定义ID',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `instance_name` VARCHAR(100) COMMENT '实例名称',
    `execute_params` JSON COMMENT '执行参数',
    `status` VARCHAR(50) NOT NULL COMMENT '执行状态',
    `start_time` TIMESTAMP NULL COMMENT '开始时间',
    `end_time` TIMESTAMP NULL COMMENT '结束时间',
    `duration_ms` INT COMMENT '执行耗时(毫秒)',
    `result_data` JSON COMMENT '执行结果',
    `error_message` TEXT COMMENT '错误信息',
    `retry_count` INT DEFAULT 0 COMMENT '重试次数',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX `idx_task_definition_id` (`task_definition_id`),
    INDEX `idx_tenant_id` (`tenant_id`),
    INDEX `idx_status` (`status`),
    INDEX `idx_start_time` (`start_time`),
    INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='任务实例表';

-- 任务执行日志表
CREATE TABLE `task_logs` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '日志ID',
    `task_instance_id` VARCHAR(36) NOT NULL COMMENT '任务实例ID',
    `task_definition_id` VARCHAR(36) NOT NULL COMMENT '任务定义ID',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `log_level` VARCHAR(20) NOT NULL COMMENT '日志级别',
    `log_message` TEXT NOT NULL COMMENT '日志消息',
    `log_data` JSON COMMENT '日志数据',
    `exception_stack` TEXT COMMENT '异常堆栈',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX `idx_task_instance_id` (`task_instance_id`),
    INDEX `idx_task_definition_id` (`task_definition_id`),
    INDEX `idx_tenant_id` (`tenant_id`),
    INDEX `idx_log_level` (`log_level`),
    INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='任务执行日志表';

-- ===== 外键约束 =====

-- AI智能体服务外键
ALTER TABLE `conversations` ADD CONSTRAINT `fk_conversations_agent` FOREIGN KEY (`agent_id`) REFERENCES `agents`(`id`) ON DELETE CASCADE;
ALTER TABLE `agent_messages` ADD CONSTRAINT `fk_agent_messages_conversation` FOREIGN KEY (`conversation_id`) REFERENCES `conversations`(`id`) ON DELETE CASCADE;
ALTER TABLE `call_records` ADD CONSTRAINT `fk_call_records_agent` FOREIGN KEY (`agent_id`) REFERENCES `agents`(`id`) ON DELETE CASCADE;

-- 任务调度服务外键
ALTER TABLE `task_instances` ADD CONSTRAINT `fk_task_instances_definition` FOREIGN KEY (`task_definition_id`) REFERENCES `task_definitions`(`id`) ON DELETE CASCADE;
ALTER TABLE `task_logs` ADD CONSTRAINT `fk_task_logs_instance` FOREIGN KEY (`task_instance_id`) REFERENCES `task_instances`(`id`) ON DELETE CASCADE;

-- ===== 初始化数据 =====

-- 插入默认任务类型
INSERT IGNORE INTO `task_definitions` (`id`, `tenant_id`, `task_name`, `description`, `task_type`, `status`, `enabled`) VALUES
('default-heartbeat-task', 'default', '心跳检测任务', '定期检测系统状态', 'HEARTBEAT', 'ACTIVE', true),
('default-cleanup-task', 'default', '数据清理任务', '定期清理过期数据', 'CLEANUP', 'ACTIVE', true),
('default-report-task', 'default', '报表生成任务', '定期生成统计报表', 'REPORT', 'ACTIVE', true);