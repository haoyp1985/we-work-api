-- =====================================================
-- 统一智能体交互运维平台 - MySQL数据库设计
-- =====================================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS ai_agent_platform 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE ai_agent_platform;

-- =====================================================
-- 1. 用户权限管理模块
-- =====================================================

-- 用户表
CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    email VARCHAR(100) NOT NULL UNIQUE COMMENT '邮箱',
    password_hash VARCHAR(255) NOT NULL COMMENT '密码哈希',
    display_name VARCHAR(100) DEFAULT NULL COMMENT '显示名称',
    avatar_url VARCHAR(500) DEFAULT NULL COMMENT '头像URL',
    status ENUM('active', 'inactive', 'banned') DEFAULT 'active' COMMENT '状态',
    last_login_at TIMESTAMP NULL COMMENT '最后登录时间',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB COMMENT='用户表';

-- 角色表
CREATE TABLE roles (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '角色ID',
    name VARCHAR(50) NOT NULL UNIQUE COMMENT '角色名称',
    description TEXT COMMENT '角色描述',
    is_system BOOLEAN DEFAULT FALSE COMMENT '是否系统角色',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX idx_name (name)
) ENGINE=InnoDB COMMENT='角色表';

-- 权限表
CREATE TABLE permissions (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '权限ID',
    name VARCHAR(100) NOT NULL UNIQUE COMMENT '权限名称',
    resource VARCHAR(50) NOT NULL COMMENT '资源类型',
    action VARCHAR(50) NOT NULL COMMENT '操作类型',
    description TEXT COMMENT '权限描述',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX idx_name (name),
    INDEX idx_resource_action (resource, action)
) ENGINE=InnoDB COMMENT='权限表';

-- 用户角色关联表
CREATE TABLE user_roles (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'ID',
    user_id BIGINT UNSIGNED NOT NULL COMMENT '用户ID',
    role_id BIGINT UNSIGNED NOT NULL COMMENT '角色ID',
    granted_by BIGINT UNSIGNED DEFAULT NULL COMMENT '授权人ID',
    granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '授权时间',
    expires_at TIMESTAMP NULL COMMENT '过期时间',
    
    UNIQUE KEY uk_user_role (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
    FOREIGN KEY (granted_by) REFERENCES users(id) ON DELETE SET NULL,
    
    INDEX idx_user_id (user_id),
    INDEX idx_role_id (role_id),
    INDEX idx_expires_at (expires_at)
) ENGINE=InnoDB COMMENT='用户角色关联表';

-- 角色权限关联表
CREATE TABLE role_permissions (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'ID',
    role_id BIGINT UNSIGNED NOT NULL COMMENT '角色ID',
    permission_id BIGINT UNSIGNED NOT NULL COMMENT '权限ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    UNIQUE KEY uk_role_permission (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE,
    
    INDEX idx_role_id (role_id),
    INDEX idx_permission_id (permission_id)
) ENGINE=InnoDB COMMENT='角色权限关联表';

-- API密钥表
CREATE TABLE api_keys (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'API密钥ID',
    key_id VARCHAR(64) NOT NULL UNIQUE COMMENT '密钥标识',
    key_hash VARCHAR(255) NOT NULL COMMENT '密钥哈希',
    user_id BIGINT UNSIGNED NOT NULL COMMENT '用户ID',
    name VARCHAR(100) NOT NULL COMMENT '密钥名称',
    permissions JSON DEFAULT NULL COMMENT '权限列表',
    rate_limits JSON DEFAULT NULL COMMENT '限流配置',
    last_used_at TIMESTAMP NULL COMMENT '最后使用时间',
    expires_at TIMESTAMP NULL COMMENT '过期时间',
    status ENUM('active', 'inactive', 'revoked') DEFAULT 'active' COMMENT '状态',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    
    INDEX idx_key_id (key_id),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_expires_at (expires_at)
) ENGINE=InnoDB COMMENT='API密钥表';

-- =====================================================
-- 2. 平台管理模块
-- =====================================================

-- 平台表
CREATE TABLE platforms (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '平台ID',
    name VARCHAR(50) NOT NULL COMMENT '平台名称',
    type ENUM('dify', 'coze', 'fastgpt', 'custom') NOT NULL COMMENT '平台类型',
    base_url VARCHAR(500) NOT NULL COMMENT '平台基础URL',
    auth_type ENUM('bearer', 'apikey', 'custom') NOT NULL COMMENT '认证类型',
    auth_config JSON NOT NULL COMMENT '认证配置',
    capabilities JSON DEFAULT NULL COMMENT '平台能力配置',
    rate_limits JSON DEFAULT NULL COMMENT '限流配置',
    priority INT DEFAULT 100 COMMENT '优先级(数字越小优先级越高)',
    status ENUM('active', 'inactive', 'maintenance') DEFAULT 'active' COMMENT '状态',
    health_check_url VARCHAR(500) DEFAULT NULL COMMENT '健康检查URL',
    health_check_interval INT DEFAULT 60 COMMENT '健康检查间隔(秒)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX idx_type (type),
    INDEX idx_status (status),
    INDEX idx_priority (priority)
) ENGINE=InnoDB COMMENT='平台表';

-- =====================================================
-- 3. 智能体管理模块
-- =====================================================

-- 智能体表
CREATE TABLE agents (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '智能体ID',
    name VARCHAR(100) NOT NULL COMMENT '智能体名称',
    description TEXT COMMENT '智能体描述',
    category VARCHAR(50) DEFAULT NULL COMMENT '分类',
    type ENUM('chatbot', 'workflow', 'plugin') DEFAULT 'chatbot' COMMENT '类型',
    avatar_url VARCHAR(500) DEFAULT NULL COMMENT '头像URL',
    config JSON NOT NULL COMMENT '智能体配置',
    status ENUM('draft', 'active', 'inactive', 'archived') DEFAULT 'draft' COMMENT '状态',
    version VARCHAR(20) DEFAULT '1.0.0' COMMENT '版本号',
    created_by BIGINT UNSIGNED NOT NULL COMMENT '创建者ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT,
    
    INDEX idx_name (name),
    INDEX idx_category (category),
    INDEX idx_type (type),
    INDEX idx_status (status),
    INDEX idx_created_by (created_by),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB COMMENT='智能体表';

-- 智能体版本表
CREATE TABLE agent_versions (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '版本ID',
    agent_id BIGINT UNSIGNED NOT NULL COMMENT '智能体ID',
    version VARCHAR(20) NOT NULL COMMENT '版本号',
    config JSON NOT NULL COMMENT '版本配置',
    changelog TEXT COMMENT '变更日志',
    is_current BOOLEAN DEFAULT FALSE COMMENT '是否当前版本',
    created_by BIGINT UNSIGNED NOT NULL COMMENT '创建者ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    FOREIGN KEY (agent_id) REFERENCES agents(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT,
    
    UNIQUE KEY uk_agent_version (agent_id, version),
    INDEX idx_agent_id (agent_id),
    INDEX idx_is_current (is_current),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB COMMENT='智能体版本表';

-- 平台智能体映射表
CREATE TABLE platform_agents (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'ID',
    agent_id BIGINT UNSIGNED NOT NULL COMMENT '智能体ID',
    platform_id BIGINT UNSIGNED NOT NULL COMMENT '平台ID',
    platform_agent_id VARCHAR(100) NOT NULL COMMENT '平台智能体ID',
    platform_config JSON DEFAULT NULL COMMENT '平台特定配置',
    sync_status ENUM('pending', 'success', 'failed', 'outdated') DEFAULT 'pending' COMMENT '同步状态',
    last_sync_at TIMESTAMP NULL COMMENT '最后同步时间',
    sync_error TEXT DEFAULT NULL COMMENT '同步错误信息',
    is_enabled BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    FOREIGN KEY (agent_id) REFERENCES agents(id) ON DELETE CASCADE,
    FOREIGN KEY (platform_id) REFERENCES platforms(id) ON DELETE CASCADE,
    
    UNIQUE KEY uk_agent_platform (agent_id, platform_id),
    INDEX idx_agent_id (agent_id),
    INDEX idx_platform_id (platform_id),
    INDEX idx_sync_status (sync_status),
    INDEX idx_last_sync_at (last_sync_at)
) ENGINE=InnoDB COMMENT='平台智能体映射表';

-- =====================================================
-- 4. 调度策略管理
-- =====================================================

-- 调度策略表
CREATE TABLE scheduling_strategies (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '策略ID',
    agent_id BIGINT UNSIGNED NOT NULL COMMENT '智能体ID',
    strategy_type ENUM('round_robin', 'least_connections', 'response_time', 'cost_optimized', 'custom') DEFAULT 'response_time' COMMENT '调度策略类型',
    platform_priorities JSON DEFAULT NULL COMMENT '平台优先级配置',
    load_balance_config JSON DEFAULT NULL COMMENT '负载均衡配置',
    failover_config JSON DEFAULT NULL COMMENT '故障转移配置',
    is_enabled BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    FOREIGN KEY (agent_id) REFERENCES agents(id) ON DELETE CASCADE,
    
    UNIQUE KEY uk_agent_strategy (agent_id),
    INDEX idx_agent_id (agent_id),
    INDEX idx_strategy_type (strategy_type)
) ENGINE=InnoDB COMMENT='调度策略表';

-- =====================================================
-- 5. 知识库管理模块
-- =====================================================

-- 知识库表
CREATE TABLE knowledge_bases (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '知识库ID',
    name VARCHAR(100) NOT NULL COMMENT '知识库名称',
    description TEXT COMMENT '知识库描述',
    type ENUM('qa_pairs', 'documents', 'structured', 'mixed') DEFAULT 'documents' COMMENT '知识库类型',
    embedding_model VARCHAR(100) DEFAULT 'text-embedding-ada-002' COMMENT '嵌入模型',
    config JSON DEFAULT NULL COMMENT '知识库配置',
    status ENUM('active', 'inactive', 'processing') DEFAULT 'active' COMMENT '状态',
    document_count INT DEFAULT 0 COMMENT '文档数量',
    total_chunks INT DEFAULT 0 COMMENT '总块数',
    created_by BIGINT UNSIGNED NOT NULL COMMENT '创建者ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT,
    
    INDEX idx_name (name),
    INDEX idx_type (type),
    INDEX idx_status (status),
    INDEX idx_created_by (created_by)
) ENGINE=InnoDB COMMENT='知识库表';

-- 知识文档表
CREATE TABLE knowledge_documents (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '文档ID',
    knowledge_base_id BIGINT UNSIGNED NOT NULL COMMENT '知识库ID',
    title VARCHAR(200) NOT NULL COMMENT '文档标题',
    content LONGTEXT NOT NULL COMMENT '文档内容',
    file_url VARCHAR(500) DEFAULT NULL COMMENT '原始文件URL',
    file_type VARCHAR(50) DEFAULT NULL COMMENT '文件类型',
    file_size BIGINT DEFAULT NULL COMMENT '文件大小(字节)',
    metadata JSON DEFAULT NULL COMMENT '文档元数据',
    chunk_count INT DEFAULT 0 COMMENT '分块数量',
    process_status ENUM('pending', 'processing', 'completed', 'failed') DEFAULT 'pending' COMMENT '处理状态',
    process_error TEXT DEFAULT NULL COMMENT '处理错误信息',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    FOREIGN KEY (knowledge_base_id) REFERENCES knowledge_bases(id) ON DELETE CASCADE,
    
    INDEX idx_knowledge_base_id (knowledge_base_id),
    INDEX idx_title (title),
    INDEX idx_process_status (process_status),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB COMMENT='知识文档表';

-- 智能体知识库关联表
CREATE TABLE agent_knowledge_bases (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'ID',
    agent_id BIGINT UNSIGNED NOT NULL COMMENT '智能体ID',
    knowledge_base_id BIGINT UNSIGNED NOT NULL COMMENT '知识库ID',
    priority INT DEFAULT 100 COMMENT '优先级',
    is_enabled BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    FOREIGN KEY (agent_id) REFERENCES agents(id) ON DELETE CASCADE,
    FOREIGN KEY (knowledge_base_id) REFERENCES knowledge_bases(id) ON DELETE CASCADE,
    
    UNIQUE KEY uk_agent_kb (agent_id, knowledge_base_id),
    INDEX idx_agent_id (agent_id),
    INDEX idx_knowledge_base_id (knowledge_base_id),
    INDEX idx_priority (priority)
) ENGINE=InnoDB COMMENT='智能体知识库关联表';

-- =====================================================
-- 6. 工具管理模块
-- =====================================================

-- 工具表
CREATE TABLE tools (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '工具ID',
    name VARCHAR(100) NOT NULL COMMENT '工具名称',
    description TEXT COMMENT '工具描述',
    type ENUM('built_in', 'custom', 'api', 'plugin') DEFAULT 'custom' COMMENT '工具类型',
    config JSON NOT NULL COMMENT '工具配置',
    tool_schema JSON DEFAULT NULL COMMENT '工具模式定义',
    status ENUM('active', 'inactive', 'deprecated') DEFAULT 'active' COMMENT '状态',
    created_by BIGINT UNSIGNED NOT NULL COMMENT '创建者ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT,
    
    INDEX idx_name (name),
    INDEX idx_type (type),
    INDEX idx_status (status),
    INDEX idx_created_by (created_by)
) ENGINE=InnoDB COMMENT='工具表';

-- 智能体工具关联表
CREATE TABLE agent_tools (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'ID',
    agent_id BIGINT UNSIGNED NOT NULL COMMENT '智能体ID',
    tool_id BIGINT UNSIGNED NOT NULL COMMENT '工具ID',
    config JSON DEFAULT NULL COMMENT '工具配置',
    is_enabled BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    FOREIGN KEY (agent_id) REFERENCES agents(id) ON DELETE CASCADE,
    FOREIGN KEY (tool_id) REFERENCES tools(id) ON DELETE CASCADE,
    
    UNIQUE KEY uk_agent_tool (agent_id, tool_id),
    INDEX idx_agent_id (agent_id),
    INDEX idx_tool_id (tool_id)
) ENGINE=InnoDB COMMENT='智能体工具关联表';

-- =====================================================
-- 7. 会话与消息模块（核心业务）
-- =====================================================

-- 会话表
CREATE TABLE conversations (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '会话ID',
    conversation_id VARCHAR(64) NOT NULL UNIQUE COMMENT '会话唯一标识',
    agent_id BIGINT UNSIGNED NOT NULL COMMENT '智能体ID',
    user_id VARCHAR(100) NOT NULL COMMENT '用户ID(业务系统用户标识)',
    session_key VARCHAR(100) DEFAULT NULL COMMENT '会话分组标识',
    title VARCHAR(200) DEFAULT NULL COMMENT '会话标题',
    status ENUM('active', 'idle', 'completed', 'expired', 'error', 'archived') DEFAULT 'active' COMMENT '会话状态',
    
    -- 会话配置
    session_config JSON DEFAULT NULL COMMENT '会话配置',
    variables JSON DEFAULT NULL COMMENT '会话变量',
    context JSON DEFAULT NULL COMMENT '会话上下文',
    
    -- 统计信息
    message_count INT DEFAULT 0 COMMENT '消息数量',
    total_tokens INT DEFAULT 0 COMMENT '总Token数',
    total_cost DECIMAL(10,4) DEFAULT 0 COMMENT '总费用',
    
    -- 时间管理
    last_message_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '最后消息时间',
    expires_at TIMESTAMP NULL COMMENT '过期时间',
    
    -- 平台信息
    primary_platform_id BIGINT UNSIGNED DEFAULT NULL COMMENT '主要使用平台',
    platform_sessions JSON DEFAULT NULL COMMENT '各平台会话映射',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    FOREIGN KEY (agent_id) REFERENCES agents(id) ON DELETE RESTRICT,
    FOREIGN KEY (primary_platform_id) REFERENCES platforms(id) ON DELETE SET NULL,
    
    INDEX idx_conversation_id (conversation_id),
    INDEX idx_agent_user (agent_id, user_id),
    INDEX idx_session_key (session_key),
    INDEX idx_status (status),
    INDEX idx_last_message_at (last_message_at),
    INDEX idx_expires_at (expires_at),
    INDEX idx_created_at (created_at),
    INDEX idx_user_agent_session (user_id, agent_id, session_key)
) ENGINE=InnoDB COMMENT='会话表';

-- 消息表
CREATE TABLE messages (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '消息ID',
    message_id VARCHAR(64) NOT NULL UNIQUE COMMENT '消息唯一标识',
    conversation_id BIGINT UNSIGNED NOT NULL COMMENT '会话ID',
    role ENUM('user', 'assistant', 'system', 'function') NOT NULL COMMENT '角色',
    content_type ENUM('text', 'image', 'audio', 'file', 'card', 'mixed') DEFAULT 'text' COMMENT '内容类型',
    content LONGTEXT NOT NULL COMMENT '消息内容',
    metadata JSON DEFAULT NULL COMMENT '消息元数据',
    
    -- 响应信息（仅assistant消息）
    platform_id BIGINT UNSIGNED DEFAULT NULL COMMENT '响应平台ID',
    response_time DECIMAL(8,3) DEFAULT NULL COMMENT '响应时间(秒)',
    tokens JSON DEFAULT NULL COMMENT 'Token使用情况',
    confidence DECIMAL(5,3) DEFAULT NULL COMMENT '置信度',
    finish_reason VARCHAR(50) DEFAULT NULL COMMENT '结束原因',
    
    -- 扩展信息
    knowledge_sources JSON DEFAULT NULL COMMENT '知识来源',
    tools_used JSON DEFAULT NULL COMMENT '使用的工具',
    platform_specific JSON DEFAULT NULL COMMENT '平台特定数据',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE,
    FOREIGN KEY (platform_id) REFERENCES platforms(id) ON DELETE SET NULL,
    
    INDEX idx_message_id (message_id),
    INDEX idx_conversation_id (conversation_id),
    INDEX idx_role (role),
    INDEX idx_created_at (created_at),
    INDEX idx_platform_id (platform_id)
) ENGINE=InnoDB COMMENT='消息表';

-- =====================================================
-- 8. 监控运维模块
-- =====================================================

-- 调用日志表（按月分区）
CREATE TABLE call_logs (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '日志ID',
    request_id VARCHAR(64) NOT NULL COMMENT '请求ID',
    api_key_id BIGINT UNSIGNED DEFAULT NULL COMMENT 'API密钥ID',
    user_id VARCHAR(100) DEFAULT NULL COMMENT '用户ID',
    agent_id BIGINT UNSIGNED DEFAULT NULL COMMENT '智能体ID',
    conversation_id BIGINT UNSIGNED DEFAULT NULL COMMENT '会话ID',
    platform_id BIGINT UNSIGNED DEFAULT NULL COMMENT '平台ID',
    
    -- 请求信息
    method VARCHAR(10) NOT NULL COMMENT 'HTTP方法',
    endpoint VARCHAR(200) NOT NULL COMMENT '接口端点',
    request_size INT DEFAULT 0 COMMENT '请求大小(字节)',
    response_size INT DEFAULT 0 COMMENT '响应大小(字节)',
    
    -- 响应信息
    status_code INT NOT NULL COMMENT 'HTTP状态码',
    response_time DECIMAL(8,3) NOT NULL COMMENT '响应时间(秒)',
    tokens JSON DEFAULT NULL COMMENT 'Token使用情况',
    
    -- 错误信息
    error_code VARCHAR(50) DEFAULT NULL COMMENT '错误码',
    error_message TEXT DEFAULT NULL COMMENT '错误信息',
    
    -- 客户端信息
    client_ip VARCHAR(45) DEFAULT NULL COMMENT '客户端IP',
    user_agent TEXT DEFAULT NULL COMMENT 'User Agent',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    -- 复合主键，包含分区键
    PRIMARY KEY (id, created_at),
    
    -- 移除外键约束，保留索引
    INDEX idx_request_id (request_id),
    INDEX idx_api_key_id (api_key_id),
    INDEX idx_agent_id (agent_id),
    INDEX idx_platform_id (platform_id),
    INDEX idx_status_code (status_code),
    INDEX idx_created_at (created_at),
    INDEX idx_response_time (response_time)
) ENGINE=InnoDB COMMENT='调用日志表'
PARTITION BY RANGE (UNIX_TIMESTAMP(created_at)) (
    PARTITION p202506 VALUES LESS THAN (UNIX_TIMESTAMP('2025-07-01 00:00:00')),
    PARTITION p202507 VALUES LESS THAN (UNIX_TIMESTAMP('2025-08-01 00:00:00')),
    PARTITION p202508 VALUES LESS THAN (UNIX_TIMESTAMP('2025-09-01 00:00:00')),
    PARTITION p202509 VALUES LESS THAN (UNIX_TIMESTAMP('2025-10-01 00:00:00')),
    PARTITION p202510 VALUES LESS THAN (UNIX_TIMESTAMP('2025-11-01 00:00:00')),
    PARTITION p202511 VALUES LESS THAN (UNIX_TIMESTAMP('2025-12-01 00:00:00')),
    PARTITION p202512 VALUES LESS THAN (UNIX_TIMESTAMP('2026-01-01 00:00:00')),
    PARTITION p202601 VALUES LESS THAN (UNIX_TIMESTAMP('2026-02-01 00:00:00')),
    PARTITION p202602 VALUES LESS THAN (UNIX_TIMESTAMP('2026-03-01 00:00:00')),
    PARTITION p202603 VALUES LESS THAN (UNIX_TIMESTAMP('2026-04-01 00:00:00')),
    PARTITION p202604 VALUES LESS THAN (UNIX_TIMESTAMP('2026-05-01 00:00:00')),
    PARTITION p202605 VALUES LESS THAN (UNIX_TIMESTAMP('2026-06-01 00:00:00')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- 平台指标表（按日分区）
CREATE TABLE platform_metrics (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '指标ID',
    platform_id BIGINT UNSIGNED NOT NULL COMMENT '平台ID',
    metric_type ENUM('response_time', 'success_rate', 'error_rate', 'qps', 'token_usage', 'cost') NOT NULL COMMENT '指标类型',
    metric_value DECIMAL(15,6) NOT NULL COMMENT '指标值',
    time_window ENUM('1m', '5m', '15m', '1h', '1d') NOT NULL COMMENT '时间窗口',
    labels JSON DEFAULT NULL COMMENT '标签信息',
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '记录时间',
    
    -- 复合主键，包含分区键
    PRIMARY KEY (id, recorded_at),
    
    -- 移除外键约束，保留索引
    INDEX idx_platform_metric (platform_id, metric_type),
    INDEX idx_recorded_at (recorded_at),
    INDEX idx_metric_type (metric_type)
) ENGINE=InnoDB COMMENT='平台指标表'
PARTITION BY RANGE (UNIX_TIMESTAMP(recorded_at)) (
    PARTITION p202506 VALUES LESS THAN (UNIX_TIMESTAMP('2025-07-01 00:00:00')),
    PARTITION p202507 VALUES LESS THAN (UNIX_TIMESTAMP('2025-08-01 00:00:00')),
    PARTITION p202508 VALUES LESS THAN (UNIX_TIMESTAMP('2025-09-01 00:00:00')),
    PARTITION p202509 VALUES LESS THAN (UNIX_TIMESTAMP('2025-10-01 00:00:00')),
    PARTITION p202510 VALUES LESS THAN (UNIX_TIMESTAMP('2025-11-01 00:00:00')),
    PARTITION p202511 VALUES LESS THAN (UNIX_TIMESTAMP('2025-12-01 00:00:00')),
    PARTITION p202512 VALUES LESS THAN (UNIX_TIMESTAMP('2026-01-01 00:00:00')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- 系统告警表
CREATE TABLE system_alerts (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '告警ID',
    alert_type ENUM('platform_down', 'high_error_rate', 'slow_response', 'quota_exceeded', 'custom') NOT NULL COMMENT '告警类型',
    severity ENUM('low', 'medium', 'high', 'critical') NOT NULL COMMENT '严重程度',
    title VARCHAR(200) NOT NULL COMMENT '告警标题',
    message TEXT NOT NULL COMMENT '告警消息',
    source_type ENUM('platform', 'agent', 'system', 'user') NOT NULL COMMENT '告警源类型',
    source_id BIGINT UNSIGNED DEFAULT NULL COMMENT '告警源ID',
    status ENUM('open', 'acknowledged', 'resolved', 'suppressed') DEFAULT 'open' COMMENT '告警状态',
    metadata JSON DEFAULT NULL COMMENT '告警元数据',
    acknowledged_by BIGINT UNSIGNED DEFAULT NULL COMMENT '确认人ID',
    acknowledged_at TIMESTAMP NULL COMMENT '确认时间',
    resolved_at TIMESTAMP NULL COMMENT '解决时间',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    FOREIGN KEY (acknowledged_by) REFERENCES users(id) ON DELETE SET NULL,
    
    INDEX idx_alert_type (alert_type),
    INDEX idx_severity (severity),
    INDEX idx_status (status),
    INDEX idx_source (source_type, source_id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB COMMENT='系统告警表';

-- 审计日志表
CREATE TABLE audit_logs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '审计ID',
    user_id BIGINT UNSIGNED DEFAULT NULL COMMENT '用户ID',
    api_key_id BIGINT UNSIGNED DEFAULT NULL COMMENT 'API密钥ID',
    action VARCHAR(100) NOT NULL COMMENT '操作动作',
    resource_type VARCHAR(50) NOT NULL COMMENT '资源类型',
    resource_id BIGINT UNSIGNED DEFAULT NULL COMMENT '资源ID',
    details JSON DEFAULT NULL COMMENT '操作详情',
    ip_address VARCHAR(45) DEFAULT NULL COMMENT 'IP地址',
    user_agent TEXT DEFAULT NULL COMMENT 'User Agent',
    result ENUM('success', 'failure', 'error') NOT NULL COMMENT '操作结果',
    error_message TEXT DEFAULT NULL COMMENT '错误信息',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (api_key_id) REFERENCES api_keys(id) ON DELETE SET NULL,
    
    INDEX idx_user_id (user_id),
    INDEX idx_action (action),
    INDEX idx_resource (resource_type, resource_id),
    INDEX idx_result (result),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB COMMENT='审计日志表';

-- =====================================================
-- 9. 系统配置模块
-- =====================================================

-- 系统配置表
CREATE TABLE system_configs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '配置ID',
    config_key VARCHAR(100) NOT NULL UNIQUE COMMENT '配置键',
    config_value JSON NOT NULL COMMENT '配置值',
    description TEXT COMMENT '配置描述',
    category VARCHAR(50) DEFAULT 'general' COMMENT '配置分类',
    is_encrypted BOOLEAN DEFAULT FALSE COMMENT '是否加密',
    is_public BOOLEAN DEFAULT FALSE COMMENT '是否公开可读',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX idx_config_key (config_key),
    INDEX idx_category (category)
) ENGINE=InnoDB COMMENT='系统配置表';

-- =====================================================
-- 10. 初始化数据
-- =====================================================

-- 插入系统角色
INSERT INTO roles (name, description, is_system) VALUES
('super_admin', '超级管理员', TRUE),
('admin', '管理员', TRUE),
('operator', '运营人员', TRUE),
('developer', '开发者', TRUE),
('viewer', '只读用户', TRUE);

-- 插入系统权限
INSERT INTO permissions (name, resource, action, description) VALUES
-- 智能体权限
('agent:create', 'agent', 'create', '创建智能体'),
('agent:read', 'agent', 'read', '查看智能体'),
('agent:update', 'agent', 'update', '更新智能体'),
('agent:delete', 'agent', 'delete', '删除智能体'),
('agent:deploy', 'agent', 'deploy', '部署智能体'),

-- 对话权限
('chat:use', 'chat', 'use', '使用对话功能'),
('chat:history', 'chat', 'history', '查看对话历史'),

-- 知识库权限
('knowledge:create', 'knowledge', 'create', '创建知识库'),
('knowledge:read', 'knowledge', 'read', '查看知识库'),
('knowledge:update', 'knowledge', 'update', '更新知识库'),
('knowledge:delete', 'knowledge', 'delete', '删除知识库'),

-- 系统权限
('system:monitor', 'system', 'monitor', '系统监控'),
('system:config', 'system', 'config', '系统配置'),
('user:manage', 'user', 'manage', '用户管理'),
('platform:manage', 'platform', 'manage', '平台管理');

-- 插入基础配置
INSERT INTO system_configs (config_key, config_value, description, category) VALUES
('system.name', '"AI智能体平台"', '系统名称', 'general'),
('system.version', '"1.0.0"', '系统版本', 'general'),
('chat.default_timeout', '30', '默认对话超时时间(秒)', 'chat'),
('chat.max_conversation_idle', '1800', '会话最大空闲时间(秒)', 'chat'),
('chat.default_context_window', '20', '默认上下文窗口大小', 'chat'),
('rate_limit.default_rpm', '1000', '默认每分钟请求数限制', 'rate_limit'),
('rate_limit.default_tokens_per_hour', '100000', '默认每小时Token限制', 'rate_limit');

-- 创建默认管理员用户（密码：admin123，实际使用时应修改）
INSERT INTO users (username, email, password_hash, display_name, status) VALUES
('admin', 'admin@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeZf8BEhncH.Zg2fy', '系统管理员', 'active');

-- 为管理员分配超级管理员角色
INSERT INTO user_roles (user_id, role_id) VALUES (1, 1);

-- =====================================================
-- 11. 创建视图（常用查询优化）
-- =====================================================

-- 智能体概览视图
CREATE VIEW agent_overview AS
SELECT 
    a.id,
    a.name,
    a.description,
    a.category,
    a.type,
    a.status,
    a.version,
    u.display_name AS created_by_name,
    COUNT(DISTINCT pa.platform_id) AS platform_count,
    COUNT(DISTINCT akb.knowledge_base_id) AS knowledge_base_count,
    COUNT(DISTINCT at.tool_id) AS tool_count,
    a.created_at,
    a.updated_at
FROM agents a
LEFT JOIN users u ON a.created_by = u.id
LEFT JOIN platform_agents pa ON a.id = pa.agent_id AND pa.is_enabled = TRUE
LEFT JOIN agent_knowledge_bases akb ON a.id = akb.agent_id AND akb.is_enabled = TRUE
LEFT JOIN agent_tools at ON a.id = at.agent_id AND at.is_enabled = TRUE
GROUP BY a.id, a.name, a.description, a.category, a.type, a.status, a.version, u.display_name, a.created_at, a.updated_at;

-- 平台健康状态视图
CREATE VIEW platform_health AS
SELECT 
    p.id,
    p.name,
    p.type,
    p.status,
    COUNT(DISTINCT pa.agent_id) AS agent_count,
    COALESCE(AVG(pm.metric_value), 0) AS avg_response_time,
    p.created_at,
    p.updated_at
FROM platforms p
LEFT JOIN platform_agents pa ON p.id = pa.platform_id AND pa.is_enabled = TRUE
LEFT JOIN platform_metrics pm ON p.id = pm.platform_id 
    AND pm.metric_type = 'response_time' 
    AND pm.recorded_at >= DATE_SUB(NOW(), INTERVAL 1 HOUR)
GROUP BY p.id, p.name, p.type, p.status, p.created_at, p.updated_at;

-- =====================================================
-- 12. 创建存储过程（常用操作优化）
-- =====================================================

DELIMITER //

-- 清理过期会话存储过程
CREATE PROCEDURE CleanupExpiredConversations()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_conversation_id BIGINT;
    DECLARE cur CURSOR FOR 
        SELECT id FROM conversations 
        WHERE status IN ('expired', 'completed') 
        AND updated_at < DATE_SUB(NOW(), INTERVAL 30 DAY);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    START TRANSACTION;
    
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO v_conversation_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- 更新会话状态为已归档
        UPDATE conversations 
        SET status = 'archived' 
        WHERE id = v_conversation_id;
        
    END LOOP;
    CLOSE cur;
    
    COMMIT;
END //

-- 自动标记空闲会话存储过程
CREATE PROCEDURE MarkIdleConversations()
BEGIN
    UPDATE conversations 
    SET status = 'idle'
    WHERE status = 'active' 
    AND last_message_at < DATE_SUB(NOW(), INTERVAL 30 MINUTE);
END //

DELIMITER ;

-- =====================================================
-- 13. 创建定时任务（需要MySQL事件调度器）
-- =====================================================

-- 启用事件调度器
SET GLOBAL event_scheduler = ON;

-- 创建定时清理任务
CREATE EVENT IF NOT EXISTS cleanup_expired_conversations
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
CALL CleanupExpiredConversations();

-- 创建空闲会话标记任务
CREATE EVENT IF NOT EXISTS mark_idle_conversations
ON SCHEDULE EVERY 5 MINUTE
STARTS CURRENT_TIMESTAMP
DO
CALL MarkIdleConversations();

-- =====================================================
-- 脚本执行完成提示
-- =====================================================

SELECT 'AI智能体平台数据库初始化完成！' AS message;
SELECT '默认管理员账号：admin@example.com，密码：admin123' AS notice;
SELECT '请及时修改默认密码并配置生产环境参数！' AS warning; 

🔧 使用说明
1. 执行脚本
mysql -u root -p < mysql-database-schema.sql
2. 默认账号
用户名：admin@example.com
密码：admin123
⚠️ 生产环境请立即修改！
-- 启用事件调度器（自动清理任务）
SET GLOBAL event_scheduler = ON;
3. 重要配置
-- 启用事件调度器（自动清理任务）
SET GLOBAL event_scheduler = ON;
4. 分区维护
需要定期添加新的分区来支持未来的数据：
-- 添加新月份分区
ALTER TABLE call_logs ADD PARTITION (
    PARTITION p202502 VALUES LESS THAN (202503)
);
