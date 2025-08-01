-- ===========================================================================
-- 企微账号管理系统 - 多租户数据库表结构
-- ===========================================================================

USE wework_platform;

-- ---------------------------------------------------------------------------
-- 1. 扩展企微账号主表 (支持完整的状态管理和多租户)
-- ---------------------------------------------------------------------------
DROP TABLE IF EXISTS wework_accounts;
CREATE TABLE wework_accounts (
    id VARCHAR(36) PRIMARY KEY COMMENT '主键ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID (多租户必填字段)',
    account_name VARCHAR(100) NOT NULL COMMENT '账号名称',
    wework_guid VARCHAR(100) UNIQUE COMMENT '企微实例GUID',
    proxy_id VARCHAR(100) COMMENT '代理ID',
    phone VARCHAR(20) COMMENT '绑定手机号',
    callback_url VARCHAR(500) COMMENT '回调地址',
    
    -- 状态相关字段
    status ENUM(
        'CREATED', 'INITIALIZING', 'WAITING_QR', 'WAITING_CONFIRM',
        'VERIFYING', 'ONLINE', 'OFFLINE', 'ERROR', 'RECOVERING'
    ) NOT NULL DEFAULT 'CREATED' COMMENT '账号状态',
    health_score INT DEFAULT 100 COMMENT '健康度评分 (0-100)',
    last_login_time TIMESTAMP NULL COMMENT '最后登录时间',
    last_heartbeat_time TIMESTAMP NULL COMMENT '最后心跳时间',
    
    -- 配置相关字段
    auto_reconnect BOOLEAN DEFAULT TRUE COMMENT '是否自动重连',
    monitor_interval INT DEFAULT 30 COMMENT '监控间隔(秒)',
    max_retry_count INT DEFAULT 3 COMMENT '最大重试次数',
    retry_count INT DEFAULT 0 COMMENT '当前重试次数',
    config_json JSON COMMENT '账号配置(JSON格式)',
    tenant_tag VARCHAR(50) COMMENT '租户标签(用于分组管理)',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    -- 索引设计 (支持多租户查询优化)
    INDEX idx_tenant_status (tenant_id, status),
    INDEX idx_tenant_name (tenant_id, account_name),
    INDEX idx_status_heartbeat (status, last_heartbeat_time),
    INDEX idx_health_score (health_score),
    INDEX idx_tenant_tag (tenant_id, tenant_tag),
    INDEX idx_wework_guid (wework_guid),
    INDEX idx_retry_count (retry_count),
    
    -- 外键约束
    CONSTRAINT fk_account_tenant FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企微账号表';

-- ---------------------------------------------------------------------------
-- 2. 账号状态历史表 (记录所有状态变更)
-- ---------------------------------------------------------------------------
DROP TABLE IF EXISTS account_status_history;
CREATE TABLE account_status_history (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
    account_id VARCHAR(36) NOT NULL COMMENT '账号ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID (用于多租户隔离)',
    
    -- 状态变更信息
    old_status ENUM(
        'CREATED', 'INITIALIZING', 'WAITING_QR', 'WAITING_CONFIRM',
        'VERIFYING', 'ONLINE', 'OFFLINE', 'ERROR', 'RECOVERING'
    ) COMMENT '旧状态',
    new_status ENUM(
        'CREATED', 'INITIALIZING', 'WAITING_QR', 'WAITING_CONFIRM',
        'VERIFYING', 'ONLINE', 'OFFLINE', 'ERROR', 'RECOVERING'
    ) NOT NULL COMMENT '新状态',
    change_reason VARCHAR(500) COMMENT '变更原因',
    trigger_type ENUM('MANUAL', 'AUTO', 'CALLBACK', 'MONITOR', 'SCHEDULED', 'SYSTEM') 
        NOT NULL DEFAULT 'AUTO' COMMENT '触发类型',
    extra_data JSON COMMENT '额外数据(JSON格式)',
    
    -- 操作审计信息
    operator_id VARCHAR(36) COMMENT '操作用户ID',
    operator_name VARCHAR(100) COMMENT '操作用户名',
    ip_address VARCHAR(45) COMMENT 'IP地址',
    user_agent VARCHAR(500) COMMENT '用户代理',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    -- 索引设计
    INDEX idx_account_time (account_id, created_at),
    INDEX idx_tenant_time (tenant_id, created_at),
    INDEX idx_status_change (old_status, new_status),
    INDEX idx_trigger_type (trigger_type),
    INDEX idx_operator (operator_id),
    
    -- 外键约束
    CONSTRAINT fk_history_account FOREIGN KEY (account_id) REFERENCES wework_accounts(id) ON DELETE CASCADE,
    CONSTRAINT fk_history_tenant FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='账号状态历史表';

-- ---------------------------------------------------------------------------
-- 3. 账号告警表 (支持多级告警和租户隔离)
-- ---------------------------------------------------------------------------
DROP TABLE IF EXISTS account_alerts;
CREATE TABLE account_alerts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
    account_id VARCHAR(36) NOT NULL COMMENT '账号ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID (用于多租户隔离)',
    
    -- 告警基本信息
    alert_type ENUM(
        'HEARTBEAT_TIMEOUT', 'API_CALL_FAILED', 'STATUS_MISMATCH', 'LOGIN_FAILED',
        'AUTO_RECOVER_FAILED', 'RETRY_LIMIT_REACHED', 'QUOTA_EXCEEDED', 'RESPONSE_TIME_HIGH',
        'MESSAGE_SEND_FAILED', 'SYSTEM_RESOURCE_LOW', 'NETWORK_ERROR', 'CALLBACK_ERROR',
        'DATABASE_ERROR', 'CACHE_ERROR', 'QUEUE_BACKLOG'
    ) NOT NULL COMMENT '告警类型',
    alert_level ENUM('INFO', 'WARNING', 'ERROR', 'CRITICAL') NOT NULL COMMENT '告警级别',
    alert_message TEXT NOT NULL COMMENT '告警消息',
    alert_data JSON COMMENT '告警详细数据(JSON格式)',
    
    -- 告警状态管理
    status ENUM('ACTIVE', 'ACKNOWLEDGED', 'RESOLVED', 'SUPPRESSED', 'EXPIRED') 
        DEFAULT 'ACTIVE' COMMENT '告警状态',
    first_occurred_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '首次发生时间',
    last_occurred_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最后发生时间',
    occurrence_count INT DEFAULT 1 COMMENT '发生次数',
    
    -- 处理信息
    acknowledged_by VARCHAR(36) COMMENT '确认人ID',
    acknowledged_at TIMESTAMP NULL COMMENT '确认时间',
    resolved_by VARCHAR(36) COMMENT '解决人ID',
    resolved_at TIMESTAMP NULL COMMENT '解决时间',
    resolution TEXT COMMENT '解决方案',
    
    -- 自动化处理
    auto_recovery_attempts INT DEFAULT 0 COMMENT '自动恢复尝试次数',
    notification_status JSON COMMENT '通知状态(JSON格式记录各种通知渠道的发送状态)',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    -- 索引设计
    INDEX idx_account_level (account_id, alert_level),
    INDEX idx_tenant_level (tenant_id, alert_level),
    INDEX idx_status_time (status, created_at),
    INDEX idx_alert_type (alert_type),
    INDEX idx_occurrence_time (last_occurred_at),
    INDEX idx_resolved_time (resolved_at),
    
    -- 外键约束
    CONSTRAINT fk_alert_account FOREIGN KEY (account_id) REFERENCES wework_accounts(id) ON DELETE CASCADE,
    CONSTRAINT fk_alert_tenant FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='账号告警表';

-- ---------------------------------------------------------------------------
-- 4. 租户使用统计表 (支持SaaS计费和配额管理)
-- ---------------------------------------------------------------------------
DROP TABLE IF EXISTS tenant_usage;
CREATE TABLE tenant_usage (
    id VARCHAR(36) PRIMARY KEY COMMENT '主键ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    usage_date DATE NOT NULL COMMENT '统计日期',
    
    -- 账号使用统计
    account_count INT DEFAULT 0 COMMENT '账号数量',
    online_account_count INT DEFAULT 0 COMMENT '在线账号数量',
    peak_online_accounts INT DEFAULT 0 COMMENT '峰值在线账号数',
    
    -- 消息使用统计
    message_count BIGINT DEFAULT 0 COMMENT '消息发送数量',
    message_success_count BIGINT DEFAULT 0 COMMENT '消息发送成功数量',
    message_failed_count BIGINT DEFAULT 0 COMMENT '消息发送失败数量',
    
    -- API调用统计
    api_call_count BIGINT DEFAULT 0 COMMENT 'API调用次数',
    api_success_count BIGINT DEFAULT 0 COMMENT 'API调用成功次数',
    avg_response_time INT DEFAULT 0 COMMENT '平均响应时间(毫秒)',
    
    -- 告警统计
    alert_count INT DEFAULT 0 COMMENT '告警数量',
    critical_alert_count INT DEFAULT 0 COMMENT '严重告警数量',
    recovery_count INT DEFAULT 0 COMMENT '异常恢复次数',
    
    -- 资源使用统计
    storage_used DECIMAL(10,2) DEFAULT 0.00 COMMENT '存储使用量(MB)',
    bandwidth_used DECIMAL(10,2) DEFAULT 0.00 COMMENT '带宽使用量(MB)',
    
    -- 计费相关
    cost DECIMAL(10,2) DEFAULT 0.00 COMMENT '费用金额',
    billed BOOLEAN DEFAULT FALSE COMMENT '是否已计费',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    -- 唯一约束和索引
    UNIQUE KEY uk_tenant_date (tenant_id, usage_date),
    INDEX idx_usage_date (usage_date),
    INDEX idx_tenant_month (tenant_id, usage_date),
    INDEX idx_billing_status (billed, usage_date),
    
    -- 外键约束
    CONSTRAINT fk_usage_tenant FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='租户使用统计表';

-- ---------------------------------------------------------------------------
-- 5. 账号监控规则表 (支持租户级别的监控配置)
-- ---------------------------------------------------------------------------
DROP TABLE IF EXISTS account_monitor_rules;
CREATE TABLE account_monitor_rules (
    id VARCHAR(36) PRIMARY KEY COMMENT '主键ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 规则基本信息
    rule_name VARCHAR(100) NOT NULL COMMENT '规则名称',
    rule_description TEXT COMMENT '规则描述',
    rule_type ENUM(
        'HEARTBEAT', 'API_FAILURE_RATE', 'RESPONSE_TIME', 'LOGIN_TIMEOUT',
        'OFFLINE_DURATION', 'RETRY_COUNT', 'HEALTH_SCORE', 'MESSAGE_FAILURE_RATE',
        'QUEUE_LENGTH', 'MEMORY_USAGE', 'CPU_USAGE', 'DISK_USAGE',
        'CONNECTION_COUNT', 'CACHE_HIT_RATE'
    ) NOT NULL COMMENT '监控规则类型',
    
    -- 阈值配置
    threshold_value DECIMAL(10,2) NOT NULL COMMENT '阈值',
    operator ENUM('>', '<', '>=', '<=', '==', '!=') NOT NULL DEFAULT '>=' COMMENT '比较操作符',
    check_interval INT NOT NULL DEFAULT 60 COMMENT '检查间隔(秒)',
    duration INT DEFAULT 0 COMMENT '持续时间(秒) - 超过阈值需要持续多久才触发告警',
    
    -- 告警配置
    alert_level ENUM('INFO', 'WARNING', 'ERROR', 'CRITICAL') NOT NULL COMMENT '告警级别',
    enable_auto_recovery BOOLEAN DEFAULT FALSE COMMENT '是否启用自动恢复',
    max_auto_recovery_attempts INT DEFAULT 3 COMMENT '最大自动恢复次数',
    silent_period INT DEFAULT 300 COMMENT '静默期(秒) - 告警后的静默时间',
    
    -- 适用范围
    applicable_account_tags VARCHAR(200) COMMENT '适用账号标签 (为空表示适用所有账号)',
    
    -- 配置信息
    rule_config JSON COMMENT '规则配置(JSON格式)',
    notification_config JSON COMMENT '通知渠道配置(JSON格式)',
    
    -- 状态和统计
    is_active BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    execution_count BIGINT DEFAULT 0 COMMENT '执行次数',
    trigger_count BIGINT DEFAULT 0 COMMENT '触发次数',
    last_executed_at TIMESTAMP NULL COMMENT '最后执行时间',
    last_triggered_at TIMESTAMP NULL COMMENT '最后触发时间',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    -- 索引设计
    INDEX idx_tenant_type (tenant_id, rule_type),
    INDEX idx_tenant_active (tenant_id, is_active),
    INDEX idx_rule_type (rule_type),
    INDEX idx_alert_level (alert_level),
    INDEX idx_execution_stats (execution_count, trigger_count),
    
    -- 外键约束
    CONSTRAINT fk_rule_tenant FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='账号监控规则表';

-- ---------------------------------------------------------------------------
-- 6. 租户配额表 (扩展现有租户表的配额管理)
-- ---------------------------------------------------------------------------
DROP TABLE IF EXISTS tenant_quotas;
CREATE TABLE tenant_quotas (
    id VARCHAR(36) PRIMARY KEY COMMENT '主键ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 账号配额
    max_accounts INT NOT NULL DEFAULT 10 COMMENT '最大账号数',
    max_online_accounts INT COMMENT '最大同时在线账号数',
    
    -- 消息配额
    max_daily_messages BIGINT NOT NULL DEFAULT 10000 COMMENT '日最大消息数',
    max_monthly_messages BIGINT COMMENT '月最大消息数',
    
    -- API调用配额
    max_daily_api_calls BIGINT DEFAULT 100000 COMMENT '日最大API调用次数',
    max_hourly_api_calls BIGINT DEFAULT 5000 COMMENT '小时最大API调用次数',
    
    -- 存储配额
    max_storage_gb DECIMAL(8,2) DEFAULT 10.00 COMMENT '最大存储空间(GB)',
    max_bandwidth_gb DECIMAL(8,2) DEFAULT 100.00 COMMENT '月最大带宽(GB)',
    
    -- 监控配额
    max_monitor_rules INT DEFAULT 50 COMMENT '最大监控规则数',
    max_alerts_per_day INT DEFAULT 1000 COMMENT '每日最大告警数',
    
    -- 功能权限
    enable_auto_recovery BOOLEAN DEFAULT TRUE COMMENT '是否启用自动恢复',
    enable_custom_callback BOOLEAN DEFAULT TRUE COMMENT '是否启用自定义回调',
    enable_advanced_monitoring BOOLEAN DEFAULT FALSE COMMENT '是否启用高级监控',
    enable_api_access BOOLEAN DEFAULT TRUE COMMENT '是否启用API访问',
    
    -- 有效期
    effective_from DATE NOT NULL COMMENT '生效开始日期',
    effective_to DATE COMMENT '生效结束日期',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    -- 索引设计
    UNIQUE KEY uk_tenant_quota (tenant_id),
    INDEX idx_effective_period (effective_from, effective_to),
    
    -- 外键约束
    CONSTRAINT fk_quota_tenant FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='租户配额表';

-- ---------------------------------------------------------------------------
-- 7. 创建视图 (简化常用查询)
-- ---------------------------------------------------------------------------

-- 账号状态统计视图
CREATE VIEW v_account_status_summary AS
SELECT 
    wa.tenant_id,
    wa.status,
    COUNT(*) as account_count,
    AVG(wa.health_score) as avg_health_score,
    MAX(wa.last_heartbeat_time) as latest_heartbeat
FROM wework_accounts wa
GROUP BY wa.tenant_id, wa.status;

-- 租户告警统计视图
CREATE VIEW v_tenant_alert_summary AS
SELECT 
    aa.tenant_id,
    aa.alert_level,
    aa.status,
    COUNT(*) as alert_count,
    MAX(aa.created_at) as latest_alert_time
FROM account_alerts aa
WHERE aa.created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
GROUP BY aa.tenant_id, aa.alert_level, aa.status;

-- ---------------------------------------------------------------------------
-- 8. 创建存储过程 (常用操作)
-- ---------------------------------------------------------------------------

DELIMITER //

-- 获取租户账号使用情况
CREATE PROCEDURE sp_get_tenant_account_usage(IN p_tenant_id VARCHAR(36))
BEGIN
    SELECT 
        COUNT(*) as total_accounts,
        COUNT(CASE WHEN status = 'ONLINE' THEN 1 END) as online_accounts,
        COUNT(CASE WHEN status = 'OFFLINE' THEN 1 END) as offline_accounts,
        COUNT(CASE WHEN status = 'ERROR' THEN 1 END) as error_accounts,
        AVG(health_score) as avg_health_score,
        MAX(last_heartbeat_time) as latest_heartbeat
    FROM wework_accounts 
    WHERE tenant_id = p_tenant_id;
END //

-- 检查租户配额使用情况
CREATE PROCEDURE sp_check_tenant_quota(IN p_tenant_id VARCHAR(36))
BEGIN
    SELECT 
        tq.max_accounts,
        COUNT(wa.id) as current_accounts,
        (COUNT(wa.id) / tq.max_accounts * 100) as account_usage_percent,
        tq.max_daily_messages,
        COALESCE(tu.message_count, 0) as today_messages,
        (COALESCE(tu.message_count, 0) / tq.max_daily_messages * 100) as message_usage_percent
    FROM tenant_quotas tq
    LEFT JOIN wework_accounts wa ON tq.tenant_id = wa.tenant_id
    LEFT JOIN tenant_usage tu ON tq.tenant_id = tu.tenant_id AND tu.usage_date = CURDATE()
    WHERE tq.tenant_id = p_tenant_id
    GROUP BY tq.tenant_id, tq.max_accounts, tq.max_daily_messages, tu.message_count;
END //

DELIMITER ;

-- ---------------------------------------------------------------------------
-- 9. 插入初始数据
-- ---------------------------------------------------------------------------

-- 为默认租户创建配额
INSERT INTO tenant_quotas (id, tenant_id, max_accounts, max_daily_messages, effective_from) 
VALUES (UUID(), 'default', 100, 100000, CURDATE())
ON DUPLICATE KEY UPDATE max_accounts = max_accounts;

-- 创建默认监控规则
INSERT INTO account_monitor_rules (id, tenant_id, rule_name, rule_type, threshold_value, operator, alert_level) VALUES
(UUID(), 'default', '心跳超时监控', 'HEARTBEAT', 5.00, '>', 'WARNING'),
(UUID(), 'default', 'API失败率监控', 'API_FAILURE_RATE', 5.00, '>', 'ERROR'),
(UUID(), 'default', '响应时间监控', 'RESPONSE_TIME', 2000.00, '>', 'WARNING'),
(UUID(), 'default', '健康度监控', 'HEALTH_SCORE', 60.00, '<', 'WARNING');

-- ---------------------------------------------------------------------------
-- 结束
-- ---------------------------------------------------------------------------

-- 显示表结构信息
SHOW TABLES LIKE '%account%';
SHOW TABLES LIKE 'tenant%';

SELECT 'WeWork Account Management Tables Created Successfully!' as Result;