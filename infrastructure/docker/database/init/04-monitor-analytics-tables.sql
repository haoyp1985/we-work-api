-- =================================================================
-- WeWork Platform - monitor_analytics 数据库表结构
-- 版本: v2.0
-- 数据库: monitor_analytics
-- 说明: 监控数据、性能分析相关表
-- =================================================================

USE `monitor_analytics`;

-- ===== 账号监控数据 =====

-- 账号监控数据表 (分区表)
CREATE TABLE `account_metrics` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '指标ID',
    `account_id` VARCHAR(36) NOT NULL COMMENT '账号ID',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `metric_type` VARCHAR(50) NOT NULL COMMENT '指标类型',
    `metric_value` DECIMAL(15,4) NOT NULL COMMENT '指标值',
    `metric_unit` VARCHAR(20) COMMENT '指标单位',
    `tags` JSON COMMENT '标签',
    `recorded_at` TIMESTAMP NOT NULL COMMENT '记录时间',
    
    INDEX `idx_account_id` (`account_id`),
    INDEX `idx_tenant_id` (`tenant_id`),
    INDEX `idx_metric_type` (`metric_type`),
    INDEX `idx_recorded_at` (`recorded_at`),
    INDEX `idx_account_metric_time` (`account_id`, `metric_type`, `recorded_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
PARTITION BY RANGE (UNIX_TIMESTAMP(`recorded_at`)) (
    PARTITION p202501 VALUES LESS THAN (UNIX_TIMESTAMP('2025-02-01')),
    PARTITION p202502 VALUES LESS THAN (UNIX_TIMESTAMP('2025-03-01')),
    PARTITION p202503 VALUES LESS THAN (UNIX_TIMESTAMP('2025-04-01')),
    PARTITION p202504 VALUES LESS THAN (UNIX_TIMESTAMP('2025-05-01')),
    PARTITION p202505 VALUES LESS THAN (UNIX_TIMESTAMP('2025-06-01')),
    PARTITION p202506 VALUES LESS THAN (UNIX_TIMESTAMP('2025-07-01')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
) COMMENT='账号监控数据表';

-- 系统性能指标表
CREATE TABLE `system_metrics` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '指标ID',
    `service_name` VARCHAR(50) NOT NULL COMMENT '服务名称',
    `instance_id` VARCHAR(100) COMMENT '实例ID',
    `metric_name` VARCHAR(100) NOT NULL COMMENT '指标名称',
    `metric_value` DECIMAL(15,4) NOT NULL COMMENT '指标值',
    `metric_unit` VARCHAR(20) COMMENT '指标单位',
    `labels` JSON COMMENT '标签',
    `recorded_at` TIMESTAMP NOT NULL COMMENT '记录时间',
    
    INDEX `idx_service_name` (`service_name`),
    INDEX `idx_metric_name` (`metric_name`),
    INDEX `idx_recorded_at` (`recorded_at`),
    INDEX `idx_service_metric_time` (`service_name`, `metric_name`, `recorded_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
PARTITION BY RANGE (UNIX_TIMESTAMP(`recorded_at`)) (
    PARTITION p202501 VALUES LESS THAN (UNIX_TIMESTAMP('2025-02-01')),
    PARTITION p202502 VALUES LESS THAN (UNIX_TIMESTAMP('2025-03-01')),
    PARTITION p202503 VALUES LESS THAN (UNIX_TIMESTAMP('2025-04-01')),
    PARTITION p202504 VALUES LESS THAN (UNIX_TIMESTAMP('2025-05-01')),
    PARTITION p202505 VALUES LESS THAN (UNIX_TIMESTAMP('2025-06-01')),
    PARTITION p202506 VALUES LESS THAN (UNIX_TIMESTAMP('2025-07-01')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
) COMMENT='系统性能指标表';

-- ===== 告警管理 =====

-- 系统告警表
CREATE TABLE `system_alerts` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '告警ID',
    `alert_type` VARCHAR(50) NOT NULL COMMENT '告警类型',
    `alert_level` ENUM('info', 'warning', 'error', 'critical') NOT NULL COMMENT '告警级别',
    `alert_title` VARCHAR(200) NOT NULL COMMENT '告警标题',
    `alert_content` TEXT NOT NULL COMMENT '告警内容',
    `resource_type` VARCHAR(50) COMMENT '资源类型',
    `resource_id` VARCHAR(36) COMMENT '资源ID',
    `tenant_id` VARCHAR(36) COMMENT '租户ID',
    `service_name` VARCHAR(50) COMMENT '服务名称',
    `metric_name` VARCHAR(100) COMMENT '指标名称',
    `threshold_value` DECIMAL(15,4) COMMENT '阈值',
    `actual_value` DECIMAL(15,4) COMMENT '实际值',
    `status` ENUM('active', 'acknowledged', 'resolved', 'suppressed') DEFAULT 'active' COMMENT '告警状态',
    `acknowledged_by` VARCHAR(36) COMMENT '确认人',
    `acknowledged_at` TIMESTAMP NULL COMMENT '确认时间',
    `resolved_at` TIMESTAMP NULL COMMENT '解决时间',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX `idx_alert_type` (`alert_type`),
    INDEX `idx_alert_level` (`alert_level`),
    INDEX `idx_status` (`status`),
    INDEX `idx_tenant_id` (`tenant_id`),
    INDEX `idx_service_name` (`service_name`),
    INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统告警表';

-- 告警规则表
CREATE TABLE `alert_rules` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '规则ID',
    `rule_name` VARCHAR(100) NOT NULL COMMENT '规则名称',
    `rule_type` VARCHAR(50) NOT NULL COMMENT '规则类型',
    `metric_name` VARCHAR(100) NOT NULL COMMENT '指标名称',
    `condition_type` ENUM('>', '>=', '<', '<=', '=', '!=') NOT NULL COMMENT '条件类型',
    `threshold_value` DECIMAL(15,4) NOT NULL COMMENT '阈值',
    `alert_level` ENUM('info', 'warning', 'error', 'critical') NOT NULL COMMENT '告警级别',
    `evaluation_interval` INT DEFAULT 60 COMMENT '评估间隔(秒)',
    `recovery_threshold` DECIMAL(15,4) COMMENT '恢复阈值',
    `notification_config` JSON COMMENT '通知配置',
    `labels` JSON COMMENT '标签',
    `is_enabled` BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    `created_by` VARCHAR(36) COMMENT '创建者ID',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX `idx_rule_name` (`rule_name`),
    INDEX `idx_rule_type` (`rule_type`),
    INDEX `idx_metric_name` (`metric_name`),
    INDEX `idx_is_enabled` (`is_enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='告警规则表';

-- 告警通知记录表
CREATE TABLE `alert_notifications` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '通知ID',
    `alert_id` VARCHAR(36) NOT NULL COMMENT '告警ID',
    `notification_type` ENUM('email', 'sms', 'webhook', 'dingtalk', 'wechat') NOT NULL COMMENT '通知类型',
    `recipient` VARCHAR(255) NOT NULL COMMENT '接收者',
    `notification_content` TEXT NOT NULL COMMENT '通知内容',
    `send_status` ENUM('pending', 'sent', 'failed') DEFAULT 'pending' COMMENT '发送状态',
    `failure_reason` TEXT COMMENT '失败原因',
    `retry_count` INT DEFAULT 0 COMMENT '重试次数',
    `sent_at` TIMESTAMP NULL COMMENT '发送时间',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX `idx_alert_id` (`alert_id`),
    INDEX `idx_notification_type` (`notification_type`),
    INDEX `idx_send_status` (`send_status`),
    INDEX `idx_sent_at` (`sent_at`),
    FOREIGN KEY (`alert_id`) REFERENCES `system_alerts`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='告警通知记录表';

-- ===== 性能统计 =====

-- 性能统计表
CREATE TABLE `performance_stats` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '统计ID',
    `stat_date` DATE NOT NULL COMMENT '统计日期',
    `stat_hour` TINYINT COMMENT '统计小时(0-23)',
    `tenant_id` VARCHAR(36) COMMENT '租户ID',
    `service_name` VARCHAR(50) COMMENT '服务名称',
    `metric_name` VARCHAR(100) NOT NULL COMMENT '指标名称',
    `metric_value` DECIMAL(15,4) NOT NULL COMMENT '指标值',
    `metric_count` BIGINT DEFAULT 1 COMMENT '指标次数',
    `min_value` DECIMAL(15,4) COMMENT '最小值',
    `max_value` DECIMAL(15,4) COMMENT '最大值',
    `avg_value` DECIMAL(15,4) COMMENT '平均值',
    `sum_value` DECIMAL(15,4) COMMENT '总和',
    `p50_value` DECIMAL(15,4) COMMENT '50分位值',
    `p95_value` DECIMAL(15,4) COMMENT '95分位值',
    `p99_value` DECIMAL(15,4) COMMENT '99分位值',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    UNIQUE KEY `uk_date_hour_tenant_service_metric` (`stat_date`, `stat_hour`, `tenant_id`, `service_name`, `metric_name`),
    INDEX `idx_stat_date` (`stat_date`),
    INDEX `idx_tenant_id` (`tenant_id`),
    INDEX `idx_service_name` (`service_name`),
    INDEX `idx_metric_name` (`metric_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='性能统计表';

-- 业务统计表
CREATE TABLE `business_stats` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '统计ID',
    `stat_date` DATE NOT NULL COMMENT '统计日期',
    `tenant_id` VARCHAR(36) NOT NULL COMMENT '租户ID',
    `account_count` INT DEFAULT 0 COMMENT '账号数量',
    `online_account_count` INT DEFAULT 0 COMMENT '在线账号数',
    `message_sent_count` BIGINT DEFAULT 0 COMMENT '发送消息数',
    `message_success_count` BIGINT DEFAULT 0 COMMENT '成功消息数',
    `message_failed_count` BIGINT DEFAULT 0 COMMENT '失败消息数',
    `contact_count` BIGINT DEFAULT 0 COMMENT '联系人数量',
    `group_count` BIGINT DEFAULT 0 COMMENT '群聊数量',
    `file_upload_count` BIGINT DEFAULT 0 COMMENT '文件上传数',
    `file_storage_size` BIGINT DEFAULT 0 COMMENT '文件存储大小(字节)',
    `api_call_count` BIGINT DEFAULT 0 COMMENT 'API调用次数',
    `error_count` BIGINT DEFAULT 0 COMMENT '错误次数',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY `uk_date_tenant` (`stat_date`, `tenant_id`),
    INDEX `idx_stat_date` (`stat_date`),
    INDEX `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='业务统计表';

-- ===== 日志收集 =====

-- 错误日志表 (分区表)
CREATE TABLE `error_logs` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '日志ID',
    `service_name` VARCHAR(50) NOT NULL COMMENT '服务名称',
    `instance_id` VARCHAR(100) COMMENT '实例ID',
    `tenant_id` VARCHAR(36) COMMENT '租户ID',
    `user_id` VARCHAR(36) COMMENT '用户ID',
    `error_type` VARCHAR(100) NOT NULL COMMENT '错误类型',
    `error_code` VARCHAR(50) COMMENT '错误代码',
    `error_message` TEXT NOT NULL COMMENT '错误信息',
    `stack_trace` TEXT COMMENT '堆栈跟踪',
    `request_path` VARCHAR(500) COMMENT '请求路径',
    `request_method` VARCHAR(10) COMMENT '请求方法',
    `request_params` JSON COMMENT '请求参数',
    `ip_address` VARCHAR(45) COMMENT 'IP地址',
    `user_agent` TEXT COMMENT '用户代理',
    `trace_id` VARCHAR(100) COMMENT '追踪ID',
    `span_id` VARCHAR(100) COMMENT 'Span ID',
    `occurred_at` TIMESTAMP NOT NULL COMMENT '发生时间',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX `idx_service_name` (`service_name`),
    INDEX `idx_tenant_id` (`tenant_id`),
    INDEX `idx_error_type` (`error_type`),
    INDEX `idx_occurred_at` (`occurred_at`),
    INDEX `idx_trace_id` (`trace_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
PARTITION BY RANGE (UNIX_TIMESTAMP(`occurred_at`)) (
    PARTITION p202501 VALUES LESS THAN (UNIX_TIMESTAMP('2025-02-01')),
    PARTITION p202502 VALUES LESS THAN (UNIX_TIMESTAMP('2025-03-01')),
    PARTITION p202503 VALUES LESS THAN (UNIX_TIMESTAMP('2025-04-01')),
    PARTITION p202504 VALUES LESS THAN (UNIX_TIMESTAMP('2025-05-01')),
    PARTITION p202505 VALUES LESS THAN (UNIX_TIMESTAMP('2025-06-01')),
    PARTITION p202506 VALUES LESS THAN (UNIX_TIMESTAMP('2025-07-01')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
) COMMENT='错误日志表';

-- API调用日志表 (分区表)
CREATE TABLE `api_call_logs` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '日志ID',
    `service_name` VARCHAR(50) NOT NULL COMMENT '服务名称',
    `tenant_id` VARCHAR(36) COMMENT '租户ID',
    `user_id` VARCHAR(36) COMMENT '用户ID',
    `api_path` VARCHAR(500) NOT NULL COMMENT 'API路径',
    `http_method` VARCHAR(10) NOT NULL COMMENT 'HTTP方法',
    `request_size` BIGINT COMMENT '请求大小(字节)',
    `response_size` BIGINT COMMENT '响应大小(字节)',
    `response_code` INT NOT NULL COMMENT '响应状态码',
    `response_time` INT NOT NULL COMMENT '响应时间(毫秒)',
    `ip_address` VARCHAR(45) COMMENT 'IP地址',
    `user_agent` TEXT COMMENT '用户代理',
    `trace_id` VARCHAR(100) COMMENT '追踪ID',
    `called_at` TIMESTAMP NOT NULL COMMENT '调用时间',
    
    INDEX `idx_service_name` (`service_name`),
    INDEX `idx_tenant_id` (`tenant_id`),
    INDEX `idx_api_path` (`api_path`),
    INDEX `idx_response_code` (`response_code`),
    INDEX `idx_called_at` (`called_at`),
    INDEX `idx_trace_id` (`trace_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
PARTITION BY RANGE (UNIX_TIMESTAMP(`called_at`)) (
    PARTITION p202501 VALUES LESS THAN (UNIX_TIMESTAMP('2025-02-01')),
    PARTITION p202502 VALUES LESS THAN (UNIX_TIMESTAMP('2025-03-01')),
    PARTITION p202503 VALUES LESS THAN (UNIX_TIMESTAMP('2025-04-01')),
    PARTITION p202504 VALUES LESS THAN (UNIX_TIMESTAMP('2025-05-01')),
    PARTITION p202505 VALUES LESS THAN (UNIX_TIMESTAMP('2025-06-01')),
    PARTITION p202506 VALUES LESS THAN (UNIX_TIMESTAMP('2025-07-01')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
) COMMENT='API调用日志表';

-- ===== 数据保留策略 =====

-- 数据保留配置表
CREATE TABLE `data_retention_policies` (
    `id` VARCHAR(36) PRIMARY KEY COMMENT '策略ID',
    `table_name` VARCHAR(100) NOT NULL COMMENT '表名',
    `retention_days` INT NOT NULL COMMENT '保留天数',
    `archive_enabled` BOOLEAN DEFAULT FALSE COMMENT '是否启用归档',
    `archive_storage` VARCHAR(100) COMMENT '归档存储',
    `compression_enabled` BOOLEAN DEFAULT FALSE COMMENT '是否启用压缩',
    `is_enabled` BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    `last_cleanup_at` TIMESTAMP NULL COMMENT '最后清理时间',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY `uk_table_name` (`table_name`),
    INDEX `idx_is_enabled` (`is_enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='数据保留策略表';