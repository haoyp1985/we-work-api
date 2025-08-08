-- AI智能体平台数据库表结构
-- 连接到ai_agent_platform数据库

\c ai_agent_platform;

-- 1. AI智能体管理

-- AI智能体主表
CREATE TABLE ai_agents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    agent_name VARCHAR(100) NOT NULL,
    agent_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 智能体信息
    description TEXT,
    agent_type VARCHAR(50) NOT NULL CHECK (agent_type IN ('chatbot', 'assistant', 'automation', 'analytics', 'custom')),
    category VARCHAR(50),
    tags JSONB DEFAULT '[]',
    
    -- 配置信息
    model_config JSONB DEFAULT '{}',
    prompt_config JSONB DEFAULT '{}',
    behavior_config JSONB DEFAULT '{}',
    integration_config JSONB DEFAULT '{}',
    
    -- 能力配置
    capabilities JSONB DEFAULT '[]',
    permissions JSONB DEFAULT '[]',
    constraints JSONB DEFAULT '{}',
    
    -- 状态管理
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'training', 'deployed', 'archived')),
    version VARCHAR(20) DEFAULT '1.0.0',
    is_public BOOLEAN DEFAULT FALSE,
    
    -- 性能指标
    performance_metrics JSONB DEFAULT '{}',
    usage_statistics JSONB DEFAULT '{}',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, agent_code)
);

-- AI模型配置表
CREATE TABLE ai_models (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    model_name VARCHAR(100) NOT NULL,
    model_type VARCHAR(50) NOT NULL CHECK (model_type IN ('llm', 'embedding', 'vision', 'audio', 'custom')),
    
    -- 模型信息
    provider VARCHAR(50) NOT NULL,
    model_id VARCHAR(100) NOT NULL,
    version VARCHAR(20),
    description TEXT,
    
    -- 配置信息
    model_config JSONB DEFAULT '{}',
    parameters JSONB DEFAULT '{}',
    capabilities JSONB DEFAULT '[]',
    
    -- 性能信息
    max_tokens INTEGER,
    temperature DECIMAL(3,2) DEFAULT 0.7,
    top_p DECIMAL(3,2) DEFAULT 1.0,
    frequency_penalty DECIMAL(3,2) DEFAULT 0.0,
    presence_penalty DECIMAL(3,2) DEFAULT 0.0,
    
    -- 成本信息
    cost_per_token DECIMAL(10,6),
    cost_per_1k_tokens DECIMAL(10,6),
    
    -- 状态管理
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'deprecated')),
    is_default BOOLEAN DEFAULT FALSE,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, model_name)
);

-- 对话会话表
CREATE TABLE ai_conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    agent_id UUID NOT NULL,
    user_id UUID,
    
    -- 会话信息
    session_id VARCHAR(100) UNIQUE,
    conversation_title VARCHAR(200),
    conversation_type VARCHAR(50) DEFAULT 'chat' CHECK (conversation_type IN ('chat', 'task', 'analysis', 'automation')),
    
    -- 上下文信息
    context_data JSONB DEFAULT '{}',
    user_context JSONB DEFAULT '{}',
    agent_context JSONB DEFAULT '{}',
    
    -- 会话状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'paused', 'completed', 'archived')),
    current_step INTEGER DEFAULT 0,
    total_steps INTEGER DEFAULT 0,
    
    -- 性能指标
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_time TIMESTAMP,
    duration_seconds INTEGER,
    message_count INTEGER DEFAULT 0,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, session_id)
);

-- 对话消息表
CREATE TABLE ai_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    conversation_id UUID NOT NULL,
    
    -- 消息信息
    message_type VARCHAR(20) NOT NULL CHECK (message_type IN ('user', 'assistant', 'system', 'function')),
    role VARCHAR(20) NOT NULL,
    content TEXT NOT NULL,
    content_type VARCHAR(20) DEFAULT 'text' CHECK (content_type IN ('text', 'image', 'audio', 'file', 'json')),
    
    -- 消息元数据
    metadata JSONB DEFAULT '{}',
    attachments JSONB DEFAULT '[]',
    function_call JSONB DEFAULT '{}',
    
    -- 模型信息
    model_used VARCHAR(100),
    model_response JSONB DEFAULT '{}',
    tokens_used INTEGER,
    cost DECIMAL(10,6),
    
    -- 消息状态
    status VARCHAR(20) DEFAULT 'sent' CHECK (status IN ('sent', 'delivered', 'read', 'failed')),
    is_visible BOOLEAN DEFAULT TRUE,
    
    -- 时间信息
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    delivered_at TIMESTAMP,
    read_at TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 2. 知识库管理

-- 知识库主表
CREATE TABLE ai_knowledge_bases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    kb_name VARCHAR(100) NOT NULL,
    kb_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 知识库信息
    description TEXT,
    kb_type VARCHAR(50) DEFAULT 'document' CHECK (kb_type IN ('document', 'faq', 'code', 'custom')),
    category VARCHAR(50),
    
    -- 配置信息
    embedding_model VARCHAR(100),
    chunk_size INTEGER DEFAULT 1000,
    chunk_overlap INTEGER DEFAULT 200,
    similarity_threshold DECIMAL(3,2) DEFAULT 0.8,
    
    -- 状态管理
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'indexing', 'archived')),
    is_public BOOLEAN DEFAULT FALSE,
    
    -- 统计信息
    document_count INTEGER DEFAULT 0,
    chunk_count INTEGER DEFAULT 0,
    total_size BIGINT DEFAULT 0,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, kb_code)
);

-- 知识库文档表
CREATE TABLE ai_knowledge_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    kb_id UUID NOT NULL,
    
    -- 文档信息
    document_name VARCHAR(200) NOT NULL,
    document_type VARCHAR(50) DEFAULT 'text' CHECK (document_type IN ('text', 'pdf', 'docx', 'html', 'markdown', 'json')),
    file_path TEXT,
    file_url TEXT,
    file_size BIGINT,
    
    -- 文档内容
    content TEXT,
    content_hash VARCHAR(64),
    metadata JSONB DEFAULT '{}',
    
    -- 处理状态
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'indexed', 'failed')),
    chunk_count INTEGER DEFAULT 0,
    last_indexed_at TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, kb_id, content_hash)
);

-- 知识库块表
CREATE TABLE ai_knowledge_chunks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    kb_id UUID NOT NULL,
    document_id UUID NOT NULL,
    
    -- 块信息
    chunk_index INTEGER NOT NULL,
    chunk_text TEXT NOT NULL,
    chunk_hash VARCHAR(64),
    
    -- 向量信息
    embedding_vector BYTEA,
    embedding_model VARCHAR(100),
    embedding_dimension INTEGER,
    
    -- 元数据
    metadata JSONB DEFAULT '{}',
    tags JSONB DEFAULT '[]',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, kb_id, document_id, chunk_index)
);

-- 3. 工作流管理

-- 工作流定义表
CREATE TABLE ai_workflows (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    workflow_name VARCHAR(100) NOT NULL,
    workflow_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 工作流信息
    description TEXT,
    workflow_type VARCHAR(50) DEFAULT 'automation' CHECK (workflow_type IN ('automation', 'decision', 'integration', 'custom')),
    category VARCHAR(50),
    
    -- 工作流配置
    workflow_config JSONB DEFAULT '{}',
    trigger_config JSONB DEFAULT '{}',
    step_config JSONB DEFAULT '[]',
    
    -- 状态管理
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'active', 'inactive', 'archived')),
    version VARCHAR(20) DEFAULT '1.0.0',
    is_template BOOLEAN DEFAULT FALSE,
    
    -- 执行配置
    timeout_seconds INTEGER DEFAULT 300,
    retry_count INTEGER DEFAULT 3,
    concurrent_limit INTEGER DEFAULT 1,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, workflow_code)
);

-- 工作流执行表
CREATE TABLE ai_workflow_executions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    workflow_id UUID NOT NULL,
    
    -- 执行信息
    execution_id VARCHAR(100) UNIQUE,
    trigger_type VARCHAR(50),
    trigger_data JSONB DEFAULT '{}',
    
    -- 执行状态
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'running', 'completed', 'failed', 'cancelled')),
    current_step INTEGER DEFAULT 0,
    total_steps INTEGER DEFAULT 0,
    
    -- 执行结果
    result_data JSONB DEFAULT '{}',
    error_message TEXT,
    execution_log JSONB DEFAULT '[]',
    
    -- 时间信息
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    duration_seconds INTEGER,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, execution_id)
);

-- 4. 训练管理

-- 训练任务表
CREATE TABLE ai_training_tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    agent_id UUID,
    
    -- 任务信息
    task_name VARCHAR(100) NOT NULL,
    task_type VARCHAR(50) NOT NULL CHECK (task_type IN ('fine_tuning', 'pre_training', 'reinforcement', 'custom')),
    description TEXT,
    
    -- 训练配置
    training_config JSONB DEFAULT '{}',
    dataset_config JSONB DEFAULT '{}',
    hyperparameters JSONB DEFAULT '{}',
    
    -- 训练状态
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'running', 'completed', 'failed', 'cancelled')),
    progress_percentage DECIMAL(5,2) DEFAULT 0,
    current_epoch INTEGER DEFAULT 0,
    total_epochs INTEGER DEFAULT 0,
    
    -- 训练结果
    model_output_path TEXT,
    performance_metrics JSONB DEFAULT '{}',
    training_log JSONB DEFAULT '[]',
    
    -- 时间信息
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    duration_seconds INTEGER,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 训练数据集表
CREATE TABLE ai_training_datasets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    dataset_name VARCHAR(100) NOT NULL,
    dataset_type VARCHAR(50) DEFAULT 'conversation' CHECK (dataset_type IN ('conversation', 'qa', 'classification', 'custom')),
    
    -- 数据集信息
    description TEXT,
    data_format VARCHAR(20) DEFAULT 'json' CHECK (data_format IN ('json', 'csv', 'txt', 'custom')),
    data_source VARCHAR(100),
    
    -- 数据集配置
    dataset_config JSONB DEFAULT '{}',
    validation_split DECIMAL(3,2) DEFAULT 0.2,
    test_split DECIMAL(3,2) DEFAULT 0.1,
    
    -- 统计信息
    total_samples INTEGER DEFAULT 0,
    training_samples INTEGER DEFAULT 0,
    validation_samples INTEGER DEFAULT 0,
    test_samples INTEGER DEFAULT 0,
    
    -- 状态管理
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'processing', 'archived')),
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, dataset_name)
);

-- 5. 评估管理

-- 评估任务表
CREATE TABLE ai_evaluation_tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    agent_id UUID,
    model_id UUID,
    
    -- 任务信息
    task_name VARCHAR(100) NOT NULL,
    evaluation_type VARCHAR(50) DEFAULT 'performance' CHECK (evaluation_type IN ('performance', 'accuracy', 'safety', 'custom')),
    description TEXT,
    
    -- 评估配置
    evaluation_config JSONB DEFAULT '{}',
    test_dataset_id UUID,
    metrics_config JSONB DEFAULT '[]',
    
    -- 评估状态
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'running', 'completed', 'failed')),
    progress_percentage DECIMAL(5,2) DEFAULT 0,
    
    -- 评估结果
    evaluation_results JSONB DEFAULT '{}',
    metrics_summary JSONB DEFAULT '{}',
    recommendations JSONB DEFAULT '[]',
    
    -- 时间信息
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    duration_seconds INTEGER,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 6. 监控分析

-- AI性能监控表
CREATE TABLE ai_performance_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    agent_id UUID,
    model_id UUID,
    
    -- 指标信息
    metric_name VARCHAR(100) NOT NULL,
    metric_type VARCHAR(50) NOT NULL CHECK (metric_type IN ('latency', 'throughput', 'accuracy', 'cost', 'custom')),
    metric_value DECIMAL(15,4) NOT NULL,
    metric_unit VARCHAR(20),
    
    -- 上下文信息
    context_data JSONB DEFAULT '{}',
    labels JSONB DEFAULT '{}',
    
    -- 时间信息
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- AI使用统计表
CREATE TABLE ai_usage_statistics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    agent_id UUID,
    model_id UUID,
    
    -- 统计信息
    statistic_type VARCHAR(50) NOT NULL,
    statistic_name VARCHAR(100) NOT NULL,
    statistic_period VARCHAR(20) DEFAULT 'daily' CHECK (statistic_period IN ('hourly', 'daily', 'weekly', 'monthly')),
    
    -- 数值统计
    total_count BIGINT DEFAULT 0,
    success_count BIGINT DEFAULT 0,
    failure_count BIGINT DEFAULT 0,
    total_cost DECIMAL(15,4) DEFAULT 0,
    total_tokens BIGINT DEFAULT 0,
    
    -- 时间统计
    period_start TIMESTAMP NOT NULL,
    period_end TIMESTAMP NOT NULL,
    
    -- 扩展数据
    metadata JSONB DEFAULT '{}',
    breakdown JSONB DEFAULT '{}',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 约束
    UNIQUE(tenant_id, statistic_type, statistic_name, period_start)
);

-- 创建触发器函数来更新updated_at字段
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 为所有表添加updated_at触发器
CREATE TRIGGER update_ai_agents_updated_at BEFORE UPDATE ON ai_agents FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_ai_models_updated_at BEFORE UPDATE ON ai_models FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_ai_conversations_updated_at BEFORE UPDATE ON ai_conversations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_ai_messages_updated_at BEFORE UPDATE ON ai_messages FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_ai_knowledge_bases_updated_at BEFORE UPDATE ON ai_knowledge_bases FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_ai_knowledge_documents_updated_at BEFORE UPDATE ON ai_knowledge_documents FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_ai_knowledge_chunks_updated_at BEFORE UPDATE ON ai_knowledge_chunks FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_ai_workflows_updated_at BEFORE UPDATE ON ai_workflows FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_ai_workflow_executions_updated_at BEFORE UPDATE ON ai_workflow_executions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_ai_training_tasks_updated_at BEFORE UPDATE ON ai_training_tasks FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_ai_training_datasets_updated_at BEFORE UPDATE ON ai_training_datasets FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_ai_evaluation_tasks_updated_at BEFORE UPDATE ON ai_evaluation_tasks FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_ai_performance_metrics_updated_at BEFORE UPDATE ON ai_performance_metrics FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_ai_usage_statistics_updated_at BEFORE UPDATE ON ai_usage_statistics FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
