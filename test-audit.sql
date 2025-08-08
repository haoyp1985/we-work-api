USE saas_unified_core;

-- 测试saas_unified_audit_logs表
CREATE TABLE saas_unified_audit_logs (
    id VARCHAR(36) NOT NULL COMMENT 'Log ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT 'Tenant ID',
    
    -- 基础信息
    log_type ENUM('operation', 'security', 'business', 'system') NOT NULL COMMENT 'Log Type',
    module VARCHAR(50) NOT NULL COMMENT 'Business Module',
    sub_module VARCHAR(50) COMMENT 'Sub Module',
    
    -- 操作者信息
    operator_id VARCHAR(36) COMMENT 'Operator ID',
    operator_type ENUM('user', 'system', 'api', 'scheduled') DEFAULT 'user' COMMENT 'Operator Type',
    session_id VARCHAR(36) COMMENT 'Session ID',
    
    -- 操作详情
    action ENUM('create', 'read', 'update', 'delete', 'login', 'logout', 'status_change', 'config', 'alert') NOT NULL COMMENT 'Action Type',
    target_type VARCHAR(50) COMMENT 'Target Type',
    target_id VARCHAR(36) COMMENT 'Target ID',
    target_name VARCHAR(200) COMMENT 'Target Name',
    
    -- 变更数据 (JSON统一存储)
    change_data JSON COMMENT 'Change Data',
    
    -- 执行结果
    status ENUM('success', 'failure', 'partial') DEFAULT 'success' COMMENT 'Status',
    error_info JSON COMMENT 'Error Info',
    execution_time_ms INT COMMENT 'Execution Time (ms)',
    
    -- 环境信息
    ip_address VARCHAR(45) COMMENT 'IP Address',
    user_agent TEXT COMMENT 'User Agent',
    request_info JSON COMMENT 'Request Info',
    
    -- 业务扩展
    business_context JSON COMMENT 'Business Context',
    tags JSON COMMENT 'Tags',
    
    -- 时间信息
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Created At',
    
    -- 复合主键，包含分区键
    PRIMARY KEY (id, created_at),
    
    -- 索引设计
    INDEX idx_tenant_module (tenant_id, module),
    INDEX idx_operator (operator_id, created_at),
    INDEX idx_target (target_type, target_id),
    INDEX idx_log_type (log_type, created_at),
    INDEX idx_action (action, created_at)
    
    -- 注意：分区表不支持外键约束，这里使用应用层约束
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Unified Audit Logs Table';
