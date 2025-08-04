-- =====================================================
-- AI智能体平台数据库设计
-- 包含：平台管理、智能体管理、调度策略、知识库、工具、对话管理
-- =====================================================

-- 创建AI智能体平台数据库
CREATE DATABASE IF NOT EXISTS `ai_agent_platform` 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `ai_agent_platform`;

-- =====================================================
-- 1. 平台管理层
-- =====================================================

-- AI平台管理表
CREATE TABLE ai_platforms (
    id VARCHAR(36) PRIMARY KEY COMMENT '平台ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    platform_name VARCHAR(50) NOT NULL COMMENT '平台名称',
    platform_type ENUM('dify', 'coze', 'fastgpt', 'custom') NOT NULL COMMENT '平台类型',
    base_url VARCHAR(500) NOT NULL COMMENT '平台基础URL',
    auth_type ENUM('bearer', 'apikey', 'custom') NOT NULL COMMENT '认证类型',
    auth_config JSON NOT NULL COMMENT '认证配置',
    
    -- 平台能力配置
    capabilities JSON DEFAULT NULL COMMENT '平台能力配置',
    supported_models JSON COMMENT '支持的模型列表',
    rate_limits JSON DEFAULT NULL COMMENT '限流配置',
    priority INT DEFAULT 100 COMMENT '优先级(数字越小优先级越高)',
    
    -- 状态管理
    status ENUM('active', 'inactive', 'maintenance') DEFAULT 'active' COMMENT '状态',
    health_check_url VARCHAR(500) DEFAULT NULL COMMENT '健康检查URL',
    health_check_interval INT DEFAULT 60 COMMENT '健康检查间隔(秒)',
    
    -- 性能统计 (生命周期跟踪)
    total_requests BIGINT DEFAULT 0 COMMENT '总请求数',
    successful_requests BIGINT DEFAULT 0 COMMENT '成功请求数',
    failed_requests BIGINT DEFAULT 0 COMMENT '失败请求数',
    avg_response_time DECIMAL(8,3) DEFAULT 0 COMMENT '平均响应时间',
    last_health_check_at TIMESTAMP NULL COMMENT '最后健康检查时间',
    last_error_at TIMESTAMP NULL COMMENT '最后错误时间',
    
    -- 成本统计
    total_cost DECIMAL(10,4) DEFAULT 0 COMMENT '总费用',
    avg_cost_per_request DECIMAL(8,4) DEFAULT 0 COMMENT '平均每请求费用',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    
    INDEX idx_tenant_type (tenant_id, platform_type),
    INDEX idx_status (status),
    INDEX idx_priority (priority),
    INDEX idx_performance (avg_response_time, successful_requests)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI平台管理表';

-- =====================================================
-- 2. 智能体管理层
-- =====================================================

-- AI智能体表
CREATE TABLE ai_agents (
    id VARCHAR(36) PRIMARY KEY COMMENT '智能体ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    agent_name VARCHAR(100) NOT NULL COMMENT '智能体名称',
    description TEXT COMMENT '智能体描述',
    category VARCHAR(50) DEFAULT NULL COMMENT '分类',
    agent_type ENUM('chatbot', 'workflow', 'plugin') DEFAULT 'chatbot' COMMENT '类型',
    avatar_url VARCHAR(500) DEFAULT NULL COMMENT '头像URL',
    
    -- 智能体配置 (完整保留复杂度) 
    config JSON NOT NULL COMMENT '智能体基础配置',
    model_config JSON COMMENT '模型配置',
    prompt_config JSON COMMENT '提示词配置', 
    workflow_config JSON COMMENT '工作流配置',
    resource_config JSON COMMENT '资源配置',
    security_config JSON COMMENT '安全配置',
    
    -- 状态管理
    status ENUM('draft', 'testing', 'active', 'inactive', 'archived') DEFAULT 'draft' COMMENT '状态',
    version VARCHAR(20) DEFAULT '1.0.0' COMMENT '当前版本号',
    
    -- 使用统计 (生命周期跟踪)
    conversation_count BIGINT DEFAULT 0 COMMENT '对话总数',
    message_count BIGINT DEFAULT 0 COMMENT '消息总数',
    total_tokens BIGINT DEFAULT 0 COMMENT '总Token消耗',
    total_cost DECIMAL(10,4) DEFAULT 0 COMMENT '总费用',
    avg_response_time DECIMAL(8,3) DEFAULT 0 COMMENT '平均响应时间',
    success_rate DECIMAL(5,2) DEFAULT 0 COMMENT '成功率',
    satisfaction_score DECIMAL(3,2) DEFAULT 0 COMMENT '平均满意度',
    last_used_at TIMESTAMP NULL COMMENT '最后使用时间',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) NOT NULL COMMENT '创建者ID',
    
    INDEX idx_tenant_status (tenant_id, status),
    INDEX idx_category (category),
    INDEX idx_agent_type (agent_type),
    INDEX idx_created_by (created_by),
    INDEX idx_last_used (last_used_at),
    INDEX idx_performance (success_rate, avg_response_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI智能体表';

-- 智能体版本表 (生命周期跟踪核心)
CREATE TABLE ai_agent_versions (
    id VARCHAR(36) PRIMARY KEY COMMENT '版本ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    agent_id VARCHAR(36) NOT NULL COMMENT '智能体ID',
    
    version VARCHAR(20) NOT NULL COMMENT '版本号',
    version_name VARCHAR(100) COMMENT '版本名称',
    changelog TEXT COMMENT '变更日志',
    is_current BOOLEAN DEFAULT FALSE COMMENT '是否当前版本',
    
    -- 版本配置 (完整保留复杂度)
    config JSON NOT NULL COMMENT '版本完整配置',
    model_config JSON COMMENT '模型配置',
    prompt_config JSON COMMENT '提示词配置',
    workflow_config JSON COMMENT '工作流配置',
    diff_from_previous JSON COMMENT '与上一版本的差异',
    
    -- 版本状态
    status ENUM('draft', 'testing', 'stable', 'deprecated', 'archived') DEFAULT 'draft' COMMENT '版本状态',
    test_results JSON COMMENT '测试结果',
    
    -- 部署统计 (生命周期跟踪)
    deploy_count INT DEFAULT 0 COMMENT '部署次数',
    rollback_count INT DEFAULT 0 COMMENT '回滚次数',
    conversation_count BIGINT DEFAULT 0 COMMENT '对话次数',
    success_rate DECIMAL(5,2) COMMENT '成功率',
    avg_response_time DECIMAL(8,3) COMMENT '平均响应时间',
    total_tokens BIGINT DEFAULT 0 COMMENT 'Token消耗',
    total_cost DECIMAL(10,4) DEFAULT 0 COMMENT '费用消耗',
    first_deployed_at TIMESTAMP NULL COMMENT '首次部署时间',
    last_deployed_at TIMESTAMP NULL COMMENT '最后部署时间',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    created_by VARCHAR(36) NOT NULL COMMENT '创建者ID',
    
    UNIQUE KEY uk_agent_version (agent_id, version),
    INDEX idx_tenant_agent (tenant_id, agent_id),
    INDEX idx_is_current (is_current),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    INDEX idx_performance (success_rate, avg_response_time),
    
    FOREIGN KEY (agent_id) REFERENCES ai_agents(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='智能体版本表';

-- =====================================================
-- 3. 调度管理层 (核心)
-- =====================================================

-- 平台智能体映射表 (调度核心)
CREATE TABLE ai_platform_agents (
    id VARCHAR(36) PRIMARY KEY COMMENT 'ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    agent_id VARCHAR(36) NOT NULL COMMENT '智能体ID',
    platform_id VARCHAR(36) NOT NULL COMMENT '平台ID',
    
    platform_agent_id VARCHAR(100) NOT NULL COMMENT '平台智能体ID',
    platform_config JSON DEFAULT NULL COMMENT '平台特定配置',
    
    -- 同步状态 (生命周期跟踪)
    sync_status ENUM('pending', 'syncing', 'success', 'failed', 'outdated') DEFAULT 'pending' COMMENT '同步状态',
    last_sync_at TIMESTAMP NULL COMMENT '最后同步时间',
    sync_error TEXT DEFAULT NULL COMMENT '同步错误信息',
    sync_attempt_count INT DEFAULT 0 COMMENT '同步尝试次数',
    sync_duration_ms INT COMMENT '同步耗时(毫秒)',
    
    -- 部署状态
    deployment_status ENUM('deployed', 'deploying', 'failed', 'stopped', 'updating') DEFAULT 'stopped' COMMENT '部署状态',
    is_enabled BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    deployment_config JSON COMMENT '部署配置',
    
    -- 性能统计 (调度决策依据)
    total_requests BIGINT DEFAULT 0 COMMENT '总请求数',
    successful_requests BIGINT DEFAULT 0 COMMENT '成功请求数',
    failed_requests BIGINT DEFAULT 0 COMMENT '失败请求数',
    avg_response_time DECIMAL(8,3) DEFAULT 0 COMMENT '平均响应时间',
    last_request_at TIMESTAMP NULL COMMENT '最后请求时间',
    current_load INT DEFAULT 0 COMMENT '当前负载',
    max_concurrent_requests INT DEFAULT 100 COMMENT '最大并发请求数',
    
    -- 质量评估 (调度决策依据)
    quality_score DECIMAL(3,2) DEFAULT 0 COMMENT '质量评分',
    stability_score DECIMAL(3,2) DEFAULT 0 COMMENT '稳定性评分',
    cost_efficiency DECIMAL(8,4) DEFAULT 0 COMMENT '成本效率',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY uk_agent_platform (agent_id, platform_id),
    INDEX idx_tenant_agent (tenant_id, agent_id),
    INDEX idx_platform_id (platform_id),
    INDEX idx_sync_status (sync_status),
    INDEX idx_deployment_status (deployment_status),
    INDEX idx_performance (avg_response_time, successful_requests),
    INDEX idx_quality (quality_score, stability_score),
    
    FOREIGN KEY (agent_id) REFERENCES ai_agents(id) ON DELETE CASCADE,
    FOREIGN KEY (platform_id) REFERENCES ai_platforms(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='平台智能体映射表';

-- 调度策略表 (智能体调度核心)
CREATE TABLE ai_scheduling_strategies (
    id VARCHAR(36) PRIMARY KEY COMMENT '策略ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    agent_id VARCHAR(36) NOT NULL COMMENT '智能体ID',
    
    strategy_name VARCHAR(100) NOT NULL COMMENT '策略名称',
    strategy_type ENUM('round_robin', 'least_connections', 'response_time', 'cost_optimized', 'weighted', 'custom') DEFAULT 'response_time' COMMENT '调度策略类型',
    description TEXT COMMENT '策略描述',
    
    -- 调度配置 (完整保留复杂度)
    platform_weights JSON DEFAULT NULL COMMENT '平台权重配置',
    platform_priorities JSON DEFAULT NULL COMMENT '平台优先级配置',
    load_balance_config JSON DEFAULT NULL COMMENT '负载均衡配置',
    failover_config JSON DEFAULT NULL COMMENT '故障转移配置',
    health_check_config JSON DEFAULT NULL COMMENT '健康检查配置',
    routing_rules JSON DEFAULT NULL COMMENT '路由规则配置',
    cost_optimization_config JSON COMMENT '成本优化配置',
    
    -- 调度限制
    max_concurrent_requests INT DEFAULT 100 COMMENT '最大并发请求数',
    timeout_seconds INT DEFAULT 30 COMMENT '超时时间(秒)',
    retry_count INT DEFAULT 3 COMMENT '重试次数',
    retry_interval_ms INT DEFAULT 1000 COMMENT '重试间隔(毫秒)',
    circuit_breaker_config JSON COMMENT '熔断器配置',
    
    -- 调度统计 (生命周期跟踪)
    total_dispatches BIGINT DEFAULT 0 COMMENT '总调度次数',
    successful_dispatches BIGINT DEFAULT 0 COMMENT '成功调度次数',
    failed_dispatches BIGINT DEFAULT 0 COMMENT '失败调度次数',
    avg_dispatch_time DECIMAL(8,3) DEFAULT 0 COMMENT '平均调度时间(毫秒)',
    last_dispatch_at TIMESTAMP NULL COMMENT '最后调度时间',
    
    -- 平台使用统计 (调度效果分析)
    platform_usage_stats JSON COMMENT '各平台使用统计',
    performance_metrics JSON COMMENT '性能指标历史',
    cost_metrics JSON COMMENT '成本指标历史',
    
    -- 状态管理
    is_enabled BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY uk_agent_strategy (agent_id),
    INDEX idx_tenant_agent (tenant_id, agent_id),
    INDEX idx_strategy_type (strategy_type),
    INDEX idx_is_enabled (is_enabled),
    INDEX idx_performance (avg_dispatch_time, successful_dispatches),
    
    FOREIGN KEY (agent_id) REFERENCES ai_agents(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='调度策略表';

-- 调度历史表 (调度跟踪核心)
CREATE TABLE ai_dispatch_logs (
    id VARCHAR(36) PRIMARY KEY COMMENT '调度日志ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    request_id VARCHAR(64) NOT NULL COMMENT '请求ID',
    agent_id VARCHAR(36) NOT NULL COMMENT '智能体ID',
    strategy_id VARCHAR(36) COMMENT '使用的策略ID',
    
    -- 调度决策过程 (完整跟踪)
    available_platforms JSON NOT NULL COMMENT '可用平台列表',
    platform_scores JSON COMMENT '平台评分',
    selected_platform_id VARCHAR(36) COMMENT '选中的平台ID',
    selection_reason VARCHAR(500) COMMENT '选择原因',
    fallback_platforms JSON COMMENT '备用平台列表',
    
    -- 调度性能
    dispatch_time_ms DECIMAL(8,3) NOT NULL COMMENT '调度耗时(毫秒)',
    total_time_ms DECIMAL(8,3) COMMENT '总耗时(毫秒)',
    queue_wait_time_ms DECIMAL(8,3) COMMENT '队列等待时间',
    
    -- 调度结果
    dispatch_status ENUM('success', 'failed', 'timeout', 'no_available_platform') NOT NULL COMMENT '调度状态',
    response_status_code INT COMMENT '响应状态码',
    error_code VARCHAR(50) COMMENT '错误码',
    error_message TEXT COMMENT '错误信息',
    
    -- 重试信息
    retry_count INT DEFAULT 0 COMMENT '重试次数',
    retry_platforms JSON COMMENT '重试平台列表',
    final_platform_id VARCHAR(36) COMMENT '最终成功的平台ID',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX idx_tenant_agent (tenant_id, agent_id),
    INDEX idx_request_id (request_id),
    INDEX idx_selected_platform (selected_platform_id),
    INDEX idx_dispatch_status (dispatch_status),
    INDEX idx_created_at (created_at),
    INDEX idx_dispatch_time (dispatch_time_ms),
    
    FOREIGN KEY (agent_id) REFERENCES ai_agents(id) ON DELETE CASCADE,
    FOREIGN KEY (strategy_id) REFERENCES ai_scheduling_strategies(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='调度历史表';

-- =====================================================
-- 4. 知识库管理层
-- =====================================================

-- 知识库表
CREATE TABLE ai_knowledge_bases (
    id VARCHAR(36) PRIMARY KEY COMMENT '知识库ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    kb_name VARCHAR(100) NOT NULL COMMENT '知识库名称',
    description TEXT COMMENT '知识库描述',
    kb_type ENUM('qa_pairs', 'documents', 'structured', 'mixed') DEFAULT 'documents' COMMENT '知识库类型',
    embedding_model VARCHAR(100) DEFAULT 'text-embedding-ada-002' COMMENT '嵌入模型',
    
    -- 知识库配置
    config JSON DEFAULT NULL COMMENT '知识库配置',
    chunk_size INT DEFAULT 1000 COMMENT '文本块大小',
    chunk_overlap INT DEFAULT 200 COMMENT '文本块重叠',
    vector_dimension INT DEFAULT 1536 COMMENT '向量维度',
    
    -- 状态统计
    status ENUM('active', 'inactive', 'processing') DEFAULT 'active' COMMENT '状态',
    document_count INT DEFAULT 0 COMMENT '文档数量',
    total_chunks INT DEFAULT 0 COMMENT '总块数',
    index_status ENUM('building', 'ready', 'error') DEFAULT 'building' COMMENT '索引状态',
    
    -- 使用统计
    query_count BIGINT DEFAULT 0 COMMENT '查询次数',
    hit_count BIGINT DEFAULT 0 COMMENT '命中次数',
    avg_relevance_score DECIMAL(5,3) COMMENT '平均相关性评分',
    last_queried_at TIMESTAMP NULL COMMENT '最后查询时间',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) NOT NULL COMMENT '创建者ID',
    
    INDEX idx_tenant_status (tenant_id, status),
    INDEX idx_kb_type (kb_type),
    INDEX idx_created_by (created_by),
    INDEX idx_index_status (index_status),
    INDEX idx_usage_stats (query_count, hit_count)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='知识库表';

-- 知识文档表
CREATE TABLE ai_knowledge_documents (
    id VARCHAR(36) PRIMARY KEY COMMENT '文档ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    knowledge_base_id VARCHAR(36) NOT NULL COMMENT '知识库ID',
    
    title VARCHAR(200) NOT NULL COMMENT '文档标题',
    content LONGTEXT NOT NULL COMMENT '文档内容',
    file_url VARCHAR(500) DEFAULT NULL COMMENT '原始文件URL',
    file_type VARCHAR(50) DEFAULT NULL COMMENT '文件类型',
    file_size BIGINT DEFAULT NULL COMMENT '文件大小(字节)',
    
    -- 文档元数据
    metadata JSON DEFAULT NULL COMMENT '文档元数据',
    tags JSON COMMENT '标签',
    category VARCHAR(50) COMMENT '分类',
    
    -- 处理状态
    chunk_count INT DEFAULT 0 COMMENT '分块数量',
    process_status ENUM('pending', 'processing', 'completed', 'failed') DEFAULT 'pending' COMMENT '处理状态',
    process_error TEXT DEFAULT NULL COMMENT '处理错误信息',
    
    -- 使用统计
    query_count BIGINT DEFAULT 0 COMMENT '查询次数',
    hit_count BIGINT DEFAULT 0 COMMENT '命中次数',
    last_queried_at TIMESTAMP NULL COMMENT '最后查询时间',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX idx_tenant_kb (tenant_id, knowledge_base_id),
    INDEX idx_title (title),
    INDEX idx_process_status (process_status),
    INDEX idx_created_at (created_at),
    INDEX idx_category (category),
    
    FOREIGN KEY (knowledge_base_id) REFERENCES ai_knowledge_bases(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='知识文档表';

-- 智能体知识库关联表
CREATE TABLE ai_agent_knowledge_bases (
    id VARCHAR(36) PRIMARY KEY COMMENT 'ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    agent_id VARCHAR(36) NOT NULL COMMENT '智能体ID',
    knowledge_base_id VARCHAR(36) NOT NULL COMMENT '知识库ID',
    
    priority INT DEFAULT 100 COMMENT '优先级',
    is_enabled BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    search_config JSON COMMENT '搜索配置',
    
    -- 使用统计 (生命周期跟踪)
    query_count BIGINT DEFAULT 0 COMMENT '查询次数',
    hit_count BIGINT DEFAULT 0 COMMENT '命中次数',
    avg_relevance_score DECIMAL(5,3) COMMENT '平均相关性评分',
    last_used_at TIMESTAMP NULL COMMENT '最后使用时间',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    UNIQUE KEY uk_agent_kb (agent_id, knowledge_base_id),
    INDEX idx_tenant_agent (tenant_id, agent_id),
    INDEX idx_knowledge_base_id (knowledge_base_id),
    INDEX idx_priority (priority),
    INDEX idx_usage_stats (query_count, hit_count),
    
    FOREIGN KEY (agent_id) REFERENCES ai_agents(id) ON DELETE CASCADE,
    FOREIGN KEY (knowledge_base_id) REFERENCES ai_knowledge_bases(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='智能体知识库关联表';

-- =====================================================
-- 5. 工具管理层
-- =====================================================

-- 工具表
CREATE TABLE ai_tools (
    id VARCHAR(36) PRIMARY KEY COMMENT '工具ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    tool_name VARCHAR(100) NOT NULL COMMENT '工具名称',
    description TEXT COMMENT '工具描述',
    tool_type ENUM('built_in', 'custom', 'api', 'plugin') DEFAULT 'custom' COMMENT '工具类型',
    
    -- 工具配置 (完整保留复杂度)
    config JSON NOT NULL COMMENT '工具配置',
    tool_schema JSON DEFAULT NULL COMMENT '工具模式定义',
    api_config JSON COMMENT 'API配置(URL、认证等)',
    input_schema JSON COMMENT '输入参数模式',
    output_schema JSON COMMENT '输出结果模式',
    
    -- 状态管理
    status ENUM('active', 'inactive', 'deprecated') DEFAULT 'active' COMMENT '状态',
    
    -- 使用统计 (生命周期跟踪)
    usage_count BIGINT DEFAULT 0 COMMENT '使用次数',
    success_count BIGINT DEFAULT 0 COMMENT '成功次数',
    avg_execution_time DECIMAL(8,3) COMMENT '平均执行时间',
    last_used_at TIMESTAMP NULL COMMENT '最后使用时间',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) NOT NULL COMMENT '创建者ID',
    
    INDEX idx_tenant_status (tenant_id, status),
    INDEX idx_tool_type (tool_type),
    INDEX idx_created_by (created_by),
    INDEX idx_usage_stats (usage_count, success_count),
    
    FOREIGN KEY (created_by) REFERENCES ai_agents(created_by) -- 这里应该关联到用户表，但为了避免跨库关联，暂时这样处理
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='工具表';

-- 智能体工具关联表
CREATE TABLE ai_agent_tools (
    id VARCHAR(36) PRIMARY KEY COMMENT 'ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    agent_id VARCHAR(36) NOT NULL COMMENT '智能体ID',
    tool_id VARCHAR(36) NOT NULL COMMENT '工具ID',
    
    tool_config JSON DEFAULT NULL COMMENT '工具配置',
    is_enabled BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    execution_order INT DEFAULT 0 COMMENT '执行顺序',
    
    -- 使用统计 (生命周期跟踪)
    invocation_count BIGINT DEFAULT 0 COMMENT '调用次数',
    success_count BIGINT DEFAULT 0 COMMENT '成功次数',
    error_count BIGINT DEFAULT 0 COMMENT '错误次数',
    avg_execution_time DECIMAL(8,3) COMMENT '平均执行时间',
    last_invoked_at TIMESTAMP NULL COMMENT '最后调用时间',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    UNIQUE KEY uk_agent_tool (agent_id, tool_id),
    INDEX idx_tenant_agent (tenant_id, agent_id),
    INDEX idx_tool_id (tool_id),
    INDEX idx_execution_order (execution_order),
    INDEX idx_usage_stats (invocation_count, success_count),
    
    FOREIGN KEY (agent_id) REFERENCES ai_agents(id) ON DELETE CASCADE,
    FOREIGN KEY (tool_id) REFERENCES ai_tools(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='智能体工具关联表';

-- =====================================================
-- 6. 对话管理层 (生命周期跟踪核心)
-- =====================================================

-- 对话表
CREATE TABLE ai_conversations (
    id VARCHAR(36) PRIMARY KEY COMMENT '对话ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    conversation_id VARCHAR(64) UNIQUE NOT NULL COMMENT '对话唯一标识',
    agent_id VARCHAR(36) NOT NULL COMMENT '智能体ID',
    user_id VARCHAR(100) NOT NULL COMMENT '用户ID(业务系统用户标识)',
    session_key VARCHAR(100) DEFAULT NULL COMMENT '会话分组标识',
    
    -- 对话基本信息
    title VARCHAR(200) DEFAULT NULL COMMENT '对话标题',
    status ENUM('active', 'idle', 'completed', 'expired', 'error', 'archived') DEFAULT 'active' COMMENT '对话状态',
    
    -- 对话配置
    session_config JSON DEFAULT NULL COMMENT '会话配置',
    variables JSON DEFAULT NULL COMMENT '会话变量',
    context JSON DEFAULT NULL COMMENT '会话上下文',
    
    -- 统计信息 (生命周期跟踪)
    message_count INT DEFAULT 0 COMMENT '消息数量',
    total_tokens INT DEFAULT 0 COMMENT '总Token数',
    total_cost DECIMAL(10,4) DEFAULT 0 COMMENT '总费用',
    avg_response_time DECIMAL(8,3) COMMENT '平均响应时间',
    satisfaction_score DECIMAL(3,2) COMMENT '满意度评分',
    
    -- 时间管理
    last_message_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '最后消息时间',
    expires_at TIMESTAMP NULL COMMENT '过期时间',
    
    -- 平台信息 (调度跟踪)
    primary_platform_id VARCHAR(36) DEFAULT NULL COMMENT '主要使用平台',
    platform_sessions JSON DEFAULT NULL COMMENT '各平台会话映射',
    routing_history JSON COMMENT '路由历史记录',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX idx_tenant_agent (tenant_id, agent_id),
    INDEX idx_conversation_id (conversation_id),
    INDEX idx_agent_user (agent_id, user_id),
    INDEX idx_session_key (session_key),
    INDEX idx_status (status),
    INDEX idx_last_message (last_message_at),
    INDEX idx_expires_at (expires_at),
    INDEX idx_user_agent_session (user_id, agent_id, session_key),
    
    FOREIGN KEY (agent_id) REFERENCES ai_agents(id) ON DELETE RESTRICT,
    FOREIGN KEY (primary_platform_id) REFERENCES ai_platforms(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI对话表';

-- 消息表
CREATE TABLE ai_messages (
    id VARCHAR(36) PRIMARY KEY COMMENT '消息ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    message_id VARCHAR(64) UNIQUE NOT NULL COMMENT '消息唯一标识',
    conversation_id VARCHAR(36) NOT NULL COMMENT '对话ID',
    role ENUM('user', 'assistant', 'system', 'function') NOT NULL COMMENT '角色',
    
    -- 消息内容
    content_type ENUM('text', 'image', 'audio', 'file', 'card', 'mixed') DEFAULT 'text' COMMENT '内容类型',
    content LONGTEXT NOT NULL COMMENT '消息内容',
    metadata JSON DEFAULT NULL COMMENT '消息元数据',
    
    -- 响应信息 (生命周期跟踪核心)
    platform_id VARCHAR(36) DEFAULT NULL COMMENT '响应平台ID',
    response_time DECIMAL(8,3) DEFAULT NULL COMMENT '响应时间(秒)',
    tokens JSON DEFAULT NULL COMMENT 'Token使用情况',
    confidence DECIMAL(5,3) DEFAULT NULL COMMENT '置信度',
    finish_reason VARCHAR(50) DEFAULT NULL COMMENT '结束原因',
    
    -- 质量评估 (生命周期跟踪)
    quality_score DECIMAL(3,2) COMMENT '质量评分',
    relevance_score DECIMAL(3,2) COMMENT '相关性评分',
    user_feedback ENUM('positive', 'negative', 'neutral') COMMENT '用户反馈',
    
    -- 扩展信息
    knowledge_sources JSON DEFAULT NULL COMMENT '知识来源',
    tools_used JSON DEFAULT NULL COMMENT '使用的工具',
    platform_specific JSON DEFAULT NULL COMMENT '平台特定数据',
    error_info JSON COMMENT '错误信息',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX idx_tenant_conversation (tenant_id, conversation_id),
    INDEX idx_message_id (message_id),
    INDEX idx_conversation_id (conversation_id),
    INDEX idx_role (role),
    INDEX idx_platform_id (platform_id),
    INDEX idx_created_at (created_at),
    INDEX idx_user_feedback (user_feedback),
    
    FOREIGN KEY (conversation_id) REFERENCES ai_conversations(id) ON DELETE CASCADE,
    FOREIGN KEY (platform_id) REFERENCES ai_platforms(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI消息表';

-- =====================================================
-- 7. 调用日志表 (生命周期跟踪核心 - 分区表)
-- =====================================================

CREATE TABLE ai_call_logs (
    id VARCHAR(36) NOT NULL COMMENT '日志ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    request_id VARCHAR(64) NOT NULL COMMENT '请求ID',
    agent_id VARCHAR(36) DEFAULT NULL COMMENT '智能体ID',
    conversation_id VARCHAR(36) DEFAULT NULL COMMENT '对话ID',
    platform_id VARCHAR(36) DEFAULT NULL COMMENT '平台ID',
    
    -- 请求信息
    api_endpoint VARCHAR(200) NOT NULL COMMENT 'API端点',
    request_method VARCHAR(10) NOT NULL COMMENT 'HTTP方法',
    request_size INT DEFAULT 0 COMMENT '请求大小(字节)',
    request_data JSON COMMENT '请求数据',
    
    -- 响应信息 (生命周期跟踪核心)
    status_code INT NOT NULL COMMENT 'HTTP状态码',
    response_time DECIMAL(8,3) NOT NULL COMMENT '响应时间(秒)',
    response_size INT DEFAULT 0 COMMENT '响应大小(字节)',
    tokens JSON DEFAULT NULL COMMENT 'Token使用情况',
    cost DECIMAL(10,6) DEFAULT 0 COMMENT '费用',
    
    -- 错误信息
    error_code VARCHAR(50) DEFAULT NULL COMMENT '错误码',
    error_message TEXT DEFAULT NULL COMMENT '错误信息',
    
    -- 调度信息 (调度策略跟踪)
    routing_strategy VARCHAR(50) COMMENT '路由策略',
    selected_platform VARCHAR(50) COMMENT '选中的平台',
    fallback_platforms JSON COMMENT '备用平台列表',
    retry_count INT DEFAULT 0 COMMENT '重试次数',
    
    -- 客户端信息
    client_ip VARCHAR(45) DEFAULT NULL COMMENT '客户端IP',
    user_agent TEXT DEFAULT NULL COMMENT 'User Agent',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    -- 复合主键，包含分区键
    PRIMARY KEY (id, created_at),
    
    -- 索引设计
    INDEX idx_tenant_agent (tenant_id, agent_id),
    INDEX idx_request_id (request_id),
    INDEX idx_platform_id (platform_id),
    INDEX idx_status_code (status_code),
    INDEX idx_response_time (response_time),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI调用日志表'
PARTITION BY RANGE (UNIX_TIMESTAMP(created_at)) (
    PARTITION p202501 VALUES LESS THAN (UNIX_TIMESTAMP('2025-02-01 00:00:00')),
    PARTITION p202502 VALUES LESS THAN (UNIX_TIMESTAMP('2025-03-01 00:00:00')),
    PARTITION p202503 VALUES LESS THAN (UNIX_TIMESTAMP('2025-04-01 00:00:00')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- =====================================================
-- 8. 平台指标表 (分区表)
-- =====================================================

CREATE TABLE ai_platform_metrics (
    id VARCHAR(36) NOT NULL COMMENT '指标ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    platform_id VARCHAR(36) NOT NULL COMMENT '平台ID',
    
    metric_type ENUM('response_time', 'success_rate', 'error_rate', 'qps', 'token_usage', 'cost') NOT NULL COMMENT '指标类型',
    metric_value DECIMAL(15,6) NOT NULL COMMENT '指标值',
    time_window ENUM('1m', '5m', '15m', '1h', '1d') NOT NULL COMMENT '时间窗口',
    labels JSON DEFAULT NULL COMMENT '标签信息',
    
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '记录时间',
    
    -- 复合主键，包含分区键
    PRIMARY KEY (id, recorded_at),
    
    -- 索引设计
    INDEX idx_tenant_platform (tenant_id, platform_id),
    INDEX idx_platform_metric (platform_id, metric_type),
    INDEX idx_recorded_at (recorded_at),
    INDEX idx_metric_type (metric_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI平台指标表'
PARTITION BY RANGE (UNIX_TIMESTAMP(recorded_at)) (
    PARTITION p202501 VALUES LESS THAN (UNIX_TIMESTAMP('2025-02-01 00:00:00')),
    PARTITION p202502 VALUES LESS THAN (UNIX_TIMESTAMP('2025-03-01 00:00:00')),
    PARTITION p202503 VALUES LESS THAN (UNIX_TIMESTAMP('2025-04-01 00:00:00')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- =====================================================
-- 9. 创建视图 (常用查询优化)
-- =====================================================

-- 智能体概览视图
CREATE VIEW v_agent_overview AS
SELECT 
    a.id,
    a.agent_name,
    a.description,
    a.category,
    a.agent_type,
    a.status,
    a.version,
    a.conversation_count,
    a.success_rate,
    a.avg_response_time,
    a.total_cost,
    COUNT(DISTINCT pa.platform_id) as platform_count,
    COUNT(DISTINCT akb.knowledge_base_id) as knowledge_base_count,
    COUNT(DISTINCT at.tool_id) as tool_count,
    a.created_at,
    a.updated_at
FROM ai_agents a
LEFT JOIN ai_platform_agents pa ON a.id = pa.agent_id AND pa.is_enabled = TRUE
LEFT JOIN ai_agent_knowledge_bases akb ON a.id = akb.agent_id AND akb.is_enabled = TRUE
LEFT JOIN ai_agent_tools at ON a.id = at.agent_id AND at.is_enabled = TRUE
GROUP BY a.id, a.agent_name, a.description, a.category, a.agent_type, a.status, a.version, 
         a.conversation_count, a.success_rate, a.avg_response_time, a.total_cost, a.created_at, a.updated_at;

-- 平台健康状态视图
CREATE VIEW v_platform_health AS
SELECT 
    p.id,
    p.platform_name,
    p.platform_type,
    p.status,
    p.avg_response_time,
    p.successful_requests,
    p.failed_requests,
    CASE 
        WHEN p.total_requests > 0 THEN (p.successful_requests * 100.0 / p.total_requests)
        ELSE 0 
    END as success_rate,
    COUNT(DISTINCT pa.agent_id) as agent_count,
    p.last_health_check_at,
    p.created_at,
    p.updated_at
FROM ai_platforms p
LEFT JOIN ai_platform_agents pa ON p.id = pa.platform_id AND pa.is_enabled = TRUE
GROUP BY p.id, p.platform_name, p.platform_type, p.status, p.avg_response_time, 
         p.successful_requests, p.failed_requests, p.total_requests, p.last_health_check_at, 
         p.created_at, p.updated_at;

-- 对话统计视图
CREATE VIEW v_conversation_stats AS
SELECT 
    c.tenant_id,
    c.agent_id,
    DATE(c.created_at) as conversation_date,
    COUNT(*) as conversation_count,
    AVG(c.message_count) as avg_message_count,
    AVG(c.total_tokens) as avg_tokens,
    AVG(c.total_cost) as avg_cost,
    AVG(c.avg_response_time) as avg_response_time,
    AVG(c.satisfaction_score) as avg_satisfaction_score
FROM ai_conversations c
WHERE c.status != 'archived'
GROUP BY c.tenant_id, c.agent_id, DATE(c.created_at);

-- =====================================================
-- 10. 创建存储过程 (常用操作优化)
-- =====================================================

DELIMITER //

-- 获取智能体性能统计
CREATE PROCEDURE sp_get_agent_performance(IN p_agent_id VARCHAR(36))
BEGIN
    SELECT 
        a.agent_name,
        a.conversation_count,
        a.message_count,
        a.total_tokens,
        a.total_cost,
        a.avg_response_time,
        a.success_rate,
        a.satisfaction_score,
        COUNT(DISTINCT c.id) as active_conversations,
        AVG(m.response_time) as recent_avg_response_time
    FROM ai_agents a
    LEFT JOIN ai_conversations c ON a.id = c.agent_id AND c.status = 'active'
    LEFT JOIN ai_messages m ON c.id = m.conversation_id 
        AND m.created_at >= DATE_SUB(NOW(), INTERVAL 1 HOUR)
        AND m.role = 'assistant'
    WHERE a.id = p_agent_id
    GROUP BY a.id, a.agent_name, a.conversation_count, a.message_count, 
             a.total_tokens, a.total_cost, a.avg_response_time, 
             a.success_rate, a.satisfaction_score;
END //

-- 清理过期对话
CREATE PROCEDURE sp_cleanup_expired_conversations()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_conversation_id VARCHAR(36);
    DECLARE cur CURSOR FOR 
        SELECT id FROM ai_conversations 
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
        
        -- 更新对话状态为已归档
        UPDATE ai_conversations 
        SET status = 'archived' 
        WHERE id = v_conversation_id;
        
    END LOOP;
    CLOSE cur;
    
    COMMIT;
    
    SELECT '对话清理完成' as result;
END //

-- 自动标记空闲对话
CREATE PROCEDURE sp_mark_idle_conversations()
BEGIN
    UPDATE ai_conversations 
    SET status = 'idle'
    WHERE status = 'active' 
    AND last_message_at < DATE_SUB(NOW(), INTERVAL 30 MINUTE);
    
    SELECT CONCAT('标记空闲对话数量: ', ROW_COUNT()) as result;
END //

-- 更新智能体统计信息
CREATE PROCEDURE sp_update_agent_statistics(IN p_agent_id VARCHAR(36))
BEGIN
    UPDATE ai_agents 
    SET 
        conversation_count = (
            SELECT COUNT(*) FROM ai_conversations 
            WHERE agent_id = p_agent_id
        ),
        message_count = (
            SELECT COUNT(*) FROM ai_messages m
            JOIN ai_conversations c ON m.conversation_id = c.id
            WHERE c.agent_id = p_agent_id AND m.role = 'assistant'
        ),
        total_tokens = (
            SELECT COALESCE(SUM(JSON_EXTRACT(m.tokens, '$.total')), 0) 
            FROM ai_messages m
            JOIN ai_conversations c ON m.conversation_id = c.id
            WHERE c.agent_id = p_agent_id AND m.role = 'assistant'
        ),
        avg_response_time = (
            SELECT AVG(m.response_time) FROM ai_messages m
            JOIN ai_conversations c ON m.conversation_id = c.id
            WHERE c.agent_id = p_agent_id AND m.role = 'assistant'
            AND m.response_time IS NOT NULL
        ),
        success_rate = (
            SELECT 
                CASE 
                    WHEN COUNT(*) > 0 THEN 
                        (COUNT(CASE WHEN error_info IS NULL THEN 1 END) * 100.0 / COUNT(*))
                    ELSE 0 
                END
            FROM ai_messages m
            JOIN ai_conversations c ON m.conversation_id = c.id
            WHERE c.agent_id = p_agent_id AND m.role = 'assistant'
        ),
        last_used_at = (
            SELECT MAX(c.last_message_at) FROM ai_conversations c
            WHERE c.agent_id = p_agent_id
        )
    WHERE id = p_agent_id;
    
    SELECT '智能体统计信息更新完成' as result;
END //

DELIMITER ;

-- =====================================================
-- 11. 创建定时任务 (需要MySQL事件调度器)
-- =====================================================

-- 启用事件调度器
SET GLOBAL event_scheduler = ON;

-- 创建定时清理任务
CREATE EVENT IF NOT EXISTS cleanup_expired_conversations
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
CALL sp_cleanup_expired_conversations();

-- 创建空闲对话标记任务
CREATE EVENT IF NOT EXISTS mark_idle_conversations
ON SCHEDULE EVERY 5 MINUTE
STARTS CURRENT_TIMESTAMP
DO
CALL sp_mark_idle_conversations();

-- 创建统计信息更新任务
CREATE EVENT IF NOT EXISTS update_all_agent_statistics
ON SCHEDULE EVERY 1 HOUR
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_agent_id VARCHAR(36);
    DECLARE cur CURSOR FOR SELECT id FROM ai_agents WHERE status = 'active';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    agent_loop: LOOP
        FETCH cur INTO v_agent_id;
        IF done THEN
            LEAVE agent_loop;
        END IF;
        
        CALL sp_update_agent_statistics(v_agent_id);
        
    END LOOP;
    CLOSE cur;
END;

-- =====================================================
-- 12. 插入初始数据
-- =====================================================

-- 插入默认AI平台
INSERT INTO ai_platforms (id, tenant_id, platform_name, platform_type, base_url, auth_type, auth_config, status) VALUES
(UUID(), 'default-tenant', 'OpenAI', 'custom', 'https://api.openai.com', 'bearer', '{"api_key": "your-openai-api-key"}', 'active'),
(UUID(), 'default-tenant', 'Dify本地部署', 'dify', 'http://localhost:8000', 'bearer', '{"api_key": "your-dify-api-key"}', 'active');

-- 插入示例智能体
INSERT INTO ai_agents (id, tenant_id, agent_name, description, agent_type, config, created_by) VALUES
(UUID(), 'default-tenant', '通用聊天助手', '通用的对话助手，可以回答各种问题', 'chatbot', '{"model": "gpt-3.5-turbo", "temperature": 0.7, "max_tokens": 1000}', 'default-user'),
(UUID(), 'default-tenant', '文档问答助手', '基于知识库的文档问答助手', 'chatbot', '{"model": "gpt-4", "temperature": 0.3, "max_tokens": 2000}', 'default-user');

-- 插入默认工具
INSERT INTO ai_tools (id, tenant_id, tool_name, description, tool_type, config, created_by) VALUES
(UUID(), 'default-tenant', '天气查询', '查询指定城市的天气信息', 'api', '{"url": "https://api.weather.com", "method": "GET"}', 'default-user'),
(UUID(), 'default-tenant', '网络搜索', '在互联网上搜索相关信息', 'api', '{"url": "https://api.search.com", "method": "GET"}', 'default-user');

-- =====================================================
-- 完成提示
-- =====================================================

SELECT '🤖 AI智能体平台数据库初始化完成！' as message;
SELECT '📊 包含20+张表，支持完整的生命周期跟踪和智能调度' as features;
SELECT '🔧 已创建视图、存储过程和定时任务用于性能优化' as additional_features;
SELECT '📈 分区表设计支持大数据量的日志和指标存储' as performance_features;