-- ======================================================
-- AI智能体平台数据库初始化脚本
-- 版本: 1.0.0
-- 创建日期: 2024-01-15
-- 描述: 创建AI智能体服务所需的数据库表结构
-- ======================================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS ai_agent_platform 
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE ai_agent_platform;

-- ======================================================
-- 1. AI智能体表 (agents)
-- ======================================================
DROP TABLE IF EXISTS agents;
CREATE TABLE agents (
    id VARCHAR(36) PRIMARY KEY COMMENT '智能体ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    name VARCHAR(100) NOT NULL COMMENT '智能体名称',
    description TEXT COMMENT '智能体描述',
    avatar_url VARCHAR(500) COMMENT '头像URL',
    type ENUM('CHAT_ASSISTANT', 'WORKFLOW', 'CODE_ASSISTANT', 'KNOWLEDGE_QA', 'CUSTOM') NOT NULL DEFAULT 'CHAT_ASSISTANT' COMMENT '智能体类型',
    status ENUM('DRAFT', 'PUBLISHED', 'DISABLED') NOT NULL DEFAULT 'DRAFT' COMMENT '状态',
    version VARCHAR(20) NOT NULL DEFAULT '1.0.0' COMMENT '版本号',
    config JSON COMMENT '智能体配置',
    tags JSON COMMENT '标签列表',
    created_by VARCHAR(36) NOT NULL COMMENT '创建人ID',
    updated_by VARCHAR(36) COMMENT '更新人ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at TIMESTAMP NULL DEFAULT NULL COMMENT '删除时间',
    
    INDEX idx_tenant_id (tenant_id),
    INDEX idx_type (type),
    INDEX idx_status (status),
    INDEX idx_created_by (created_by),
    INDEX idx_created_at (created_at),
    INDEX idx_tenant_type_status (tenant_id, type, status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI智能体表';

-- ======================================================
-- 2. 外部平台配置表 (platform_configs)
-- ======================================================
DROP TABLE IF EXISTS platform_configs;
CREATE TABLE platform_configs (
    id VARCHAR(36) PRIMARY KEY COMMENT '配置ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    name VARCHAR(100) NOT NULL COMMENT '配置名称',
    platform_type ENUM('COZE', 'DIFY', 'ALIBABA_DASHSCOPE', 'OPENAI', 'CLAUDE', 'WENXIN_YIYAN') NOT NULL COMMENT '平台类型',
    config JSON NOT NULL COMMENT '平台配置',
    is_default BOOLEAN DEFAULT FALSE COMMENT '是否默认配置',
    enabled BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    created_by VARCHAR(36) NOT NULL COMMENT '创建人ID',
    updated_by VARCHAR(36) COMMENT '更新人ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at TIMESTAMP NULL DEFAULT NULL COMMENT '删除时间',
    
    INDEX idx_tenant_id (tenant_id),
    INDEX idx_platform_type (platform_type),
    INDEX idx_tenant_platform (tenant_id, platform_type),
    INDEX idx_tenant_default (tenant_id, is_default),
    UNIQUE KEY uk_tenant_platform_name (tenant_id, platform_type, name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='外部平台配置表';

-- ======================================================
-- 3. AI模型配置表 (model_configs)
-- ======================================================
DROP TABLE IF EXISTS model_configs;
CREATE TABLE model_configs (
    id VARCHAR(36) PRIMARY KEY COMMENT '模型配置ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    platform_config_id VARCHAR(36) NOT NULL COMMENT '关联的平台配置ID',
    name VARCHAR(100) NOT NULL COMMENT '模型名称',
    model_name VARCHAR(100) NOT NULL COMMENT '实际模型名称',
    model_type ENUM('CHAT', 'COMPLETION', 'EMBEDDING', 'IMAGE_GENERATION', 'MULTIMODAL') NOT NULL DEFAULT 'CHAT' COMMENT '模型类型',
    config JSON NOT NULL COMMENT '模型配置参数',
    is_default BOOLEAN DEFAULT FALSE COMMENT '是否默认模型',
    enabled BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    created_by VARCHAR(36) NOT NULL COMMENT '创建人ID',
    updated_by VARCHAR(36) COMMENT '更新人ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at TIMESTAMP NULL DEFAULT NULL COMMENT '删除时间',
    
    INDEX idx_tenant_id (tenant_id),
    INDEX idx_platform_config_id (platform_config_id),
    INDEX idx_model_type (model_type),
    INDEX idx_tenant_default (tenant_id, is_default),
    UNIQUE KEY uk_tenant_platform_model (tenant_id, platform_config_id, name),
    FOREIGN KEY (platform_config_id) REFERENCES platform_configs(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI模型配置表';

-- ======================================================
-- 4. 对话会话表 (conversations)
-- ======================================================
DROP TABLE IF EXISTS conversations;
CREATE TABLE conversations (
    id VARCHAR(36) PRIMARY KEY COMMENT '会话ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    user_id VARCHAR(36) NOT NULL COMMENT '用户ID',
    agent_id VARCHAR(36) NOT NULL COMMENT '智能体ID',
    title VARCHAR(200) COMMENT '会话标题',
    status ENUM('ACTIVE', 'ENDED', 'ARCHIVED') NOT NULL DEFAULT 'ACTIVE' COMMENT '会话状态',
    context JSON COMMENT '会话上下文',
    metadata JSON COMMENT '会话元数据',
    message_count INT DEFAULT 0 COMMENT '消息数量',
    last_message_at TIMESTAMP NULL COMMENT '最后消息时间',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at TIMESTAMP NULL DEFAULT NULL COMMENT '删除时间',
    
    INDEX idx_tenant_id (tenant_id),
    INDEX idx_user_id (user_id),
    INDEX idx_agent_id (agent_id),
    INDEX idx_status (status),
    INDEX idx_last_message_at (last_message_at),
    INDEX idx_tenant_user (tenant_id, user_id),
    INDEX idx_tenant_agent (tenant_id, agent_id),
    FOREIGN KEY (agent_id) REFERENCES agents(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='对话会话表';

-- ======================================================
-- 5. 消息表 (messages)
-- ======================================================
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
    id VARCHAR(36) PRIMARY KEY COMMENT '消息ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    conversation_id VARCHAR(36) NOT NULL COMMENT '会话ID',
    user_id VARCHAR(36) NOT NULL COMMENT '用户ID',
    agent_id VARCHAR(36) NOT NULL COMMENT '智能体ID',
    type ENUM('TEXT', 'IMAGE', 'FILE', 'AUDIO', 'VIDEO', 'TOOL_CALL', 'SYSTEM') NOT NULL DEFAULT 'TEXT' COMMENT '消息类型',
    role ENUM('USER', 'ASSISTANT', 'SYSTEM') NOT NULL COMMENT '消息角色',
    content TEXT NOT NULL COMMENT '消息内容',
    attachments JSON COMMENT '附件信息',
    metadata JSON COMMENT '消息元数据',
    status ENUM('SENDING', 'SENT', 'FAILED') NOT NULL DEFAULT 'SENT' COMMENT '消息状态',
    parent_message_id VARCHAR(36) COMMENT '父消息ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at TIMESTAMP NULL DEFAULT NULL COMMENT '删除时间',
    
    INDEX idx_tenant_id (tenant_id),
    INDEX idx_conversation_id (conversation_id),
    INDEX idx_user_id (user_id),
    INDEX idx_agent_id (agent_id),
    INDEX idx_type (type),
    INDEX idx_role (role),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    INDEX idx_conversation_created (conversation_id, created_at),
    INDEX idx_parent_message_id (parent_message_id),
    FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE,
    FOREIGN KEY (agent_id) REFERENCES agents(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息表';

-- ======================================================
-- 6. 外部调用记录表 (call_records)
-- ======================================================
DROP TABLE IF EXISTS call_records;
CREATE TABLE call_records (
    id VARCHAR(36) PRIMARY KEY COMMENT '调用记录ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    user_id VARCHAR(36) NOT NULL COMMENT '用户ID',
    conversation_id VARCHAR(36) COMMENT '会话ID',
    message_id VARCHAR(36) COMMENT '消息ID',
    agent_id VARCHAR(36) NOT NULL COMMENT '智能体ID',
    platform_config_id VARCHAR(36) COMMENT '平台配置ID',
    model_config_id VARCHAR(36) COMMENT '模型配置ID',
    platform_type VARCHAR(50) NOT NULL COMMENT '平台类型',
    model_name VARCHAR(100) COMMENT '模型名称',
    request_data JSON COMMENT '请求数据',
    response_data JSON COMMENT '响应数据',
    status ENUM('SUCCESS', 'FAILED', 'TIMEOUT', 'RATE_LIMITED') NOT NULL COMMENT '调用状态',
    error_message TEXT COMMENT '错误信息',
    start_time TIMESTAMP NOT NULL COMMENT '开始时间',
    end_time TIMESTAMP COMMENT '结束时间',
    duration_ms INT COMMENT '耗时(毫秒)',
    token_count JSON COMMENT 'Token使用统计',
    cost_amount DECIMAL(10,4) COMMENT '调用成本',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX idx_tenant_id (tenant_id),
    INDEX idx_user_id (user_id),
    INDEX idx_conversation_id (conversation_id),
    INDEX idx_message_id (message_id),
    INDEX idx_agent_id (agent_id),
    INDEX idx_platform_config_id (platform_config_id),
    INDEX idx_model_config_id (model_config_id),
    INDEX idx_platform_type (platform_type),
    INDEX idx_status (status),
    INDEX idx_start_time (start_time),
    INDEX idx_tenant_start (tenant_id, start_time),
    INDEX idx_agent_start (agent_id, start_time),
    FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE SET NULL,
    FOREIGN KEY (message_id) REFERENCES messages(id) ON DELETE SET NULL,
    FOREIGN KEY (agent_id) REFERENCES agents(id) ON DELETE CASCADE,
    FOREIGN KEY (platform_config_id) REFERENCES platform_configs(id) ON DELETE SET NULL,
    FOREIGN KEY (model_config_id) REFERENCES model_configs(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='外部调用记录表';

-- ======================================================
-- 7. 插入初始数据
-- ======================================================

-- 插入示例租户
INSERT INTO agents (id, tenant_id, name, description, type, status, created_by) VALUES
('agent-001', 'tenant-001', '通用聊天助手', '一个通用的AI聊天助手，可以回答各种问题', 'CHAT_ASSISTANT', 'PUBLISHED', 'admin'),
('agent-002', 'tenant-001', '代码助手', '专门用于编程和代码相关问题的AI助手', 'CODE_ASSISTANT', 'PUBLISHED', 'admin'),
('agent-003', 'tenant-001', '知识问答', '基于企业知识库的问答助手', 'KNOWLEDGE_QA', 'DRAFT', 'admin');

-- 插入示例平台配置
INSERT INTO platform_configs (id, tenant_id, name, platform_type, config, is_default, created_by) VALUES
('platform-001', 'tenant-001', '阿里百炼配置', 'ALIBABA_DASHSCOPE', '{"api_key": "your-api-key", "base_url": "https://dashscope.aliyuncs.com", "timeout": 60000}', TRUE, 'admin'),
('platform-002', 'tenant-001', 'Coze平台配置', 'COZE', '{"api_key": "your-coze-api-key", "base_url": "https://www.coze.cn", "timeout": 60000}', FALSE, 'admin');

-- 插入示例模型配置
INSERT INTO model_configs (id, tenant_id, platform_config_id, name, model_name, model_type, config, is_default, created_by) VALUES
('model-001', 'tenant-001', 'platform-001', '通义千问Turbo', 'qwen-turbo', 'CHAT', '{"max_tokens": 4096, "temperature": 0.7, "top_p": 0.9}', TRUE, 'admin'),
('model-002', 'tenant-001', 'platform-001', '通义千问Plus', 'qwen-plus', 'CHAT', '{"max_tokens": 8192, "temperature": 0.8, "top_p": 0.95}', FALSE, 'admin');

-- ======================================================
-- 8. 创建视图
-- ======================================================

-- 创建智能体统计视图
CREATE OR REPLACE VIEW agent_statistics AS
SELECT 
    a.tenant_id,
    a.type,
    a.status,
    COUNT(*) as agent_count,
    COUNT(CASE WHEN a.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY) THEN 1 END) as recent_count
FROM agents a 
WHERE a.deleted_at IS NULL
GROUP BY a.tenant_id, a.type, a.status;

-- 创建调用统计视图
CREATE OR REPLACE VIEW call_statistics AS
SELECT 
    cr.tenant_id,
    cr.platform_type,
    cr.status,
    DATE(cr.start_time) as call_date,
    COUNT(*) as call_count,
    AVG(cr.duration_ms) as avg_duration_ms,
    SUM(CASE WHEN cr.cost_amount IS NOT NULL THEN cr.cost_amount ELSE 0 END) as total_cost
FROM call_records cr
GROUP BY cr.tenant_id, cr.platform_type, cr.status, DATE(cr.start_time);

-- ======================================================
-- 9. 创建存储过程
-- ======================================================

DELIMITER //

-- 清理过期数据的存储过程
CREATE PROCEDURE CleanupExpiredData()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    
    -- 清理30天前的调用记录
    DELETE FROM call_records 
    WHERE created_at < DATE_SUB(NOW(), INTERVAL 30 DAY);
    
    -- 清理已删除超过7天的软删除记录
    DELETE FROM agents 
    WHERE deleted_at IS NOT NULL 
    AND deleted_at < DATE_SUB(NOW(), INTERVAL 7 DAY);
    
    DELETE FROM conversations 
    WHERE deleted_at IS NOT NULL 
    AND deleted_at < DATE_SUB(NOW(), INTERVAL 7 DAY);
    
    DELETE FROM messages 
    WHERE deleted_at IS NOT NULL 
    AND deleted_at < DATE_SUB(NOW(), INTERVAL 7 DAY);
    
    DELETE FROM platform_configs 
    WHERE deleted_at IS NOT NULL 
    AND deleted_at < DATE_SUB(NOW(), INTERVAL 7 DAY);
    
    DELETE FROM model_configs 
    WHERE deleted_at IS NOT NULL 
    AND deleted_at < DATE_SUB(NOW(), INTERVAL 7 DAY);
    
END //

DELIMITER ;

-- ======================================================
-- 10. 创建事件调度器(可选)
-- ======================================================

-- 开启事件调度器
SET GLOBAL event_scheduler = ON;

-- 创建定期清理任务
CREATE EVENT IF NOT EXISTS daily_cleanup
ON SCHEDULE EVERY 1 DAY
STARTS TIMESTAMP(CURRENT_DATE, '02:00:00')
DO
  CALL CleanupExpiredData();

-- ======================================================
-- 初始化完成
-- ======================================================

SELECT 'AI智能体平台数据库初始化完成！' as message;
SELECT COUNT(*) as agent_count FROM agents;
SELECT COUNT(*) as platform_count FROM platform_configs;
SELECT COUNT(*) as model_count FROM model_configs;