-- 核心业务数据库表结构
-- 连接到core_business数据库

\c core_business;

-- 1. 业务配置管理

-- 业务配置表
CREATE TABLE business_configs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    config_name VARCHAR(100) NOT NULL,
    config_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 配置信息
    description TEXT,
    config_type VARCHAR(50) NOT NULL CHECK (config_type IN ('system', 'business', 'feature', 'custom')),
    category VARCHAR(50),
    
    -- 配置内容
    config_value JSONB DEFAULT '{}',
    config_schema JSONB DEFAULT '{}',
    validation_rules JSONB DEFAULT '{}',
    
    -- 配置状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'draft', 'archived')),
    is_encrypted BOOLEAN DEFAULT FALSE,
    version VARCHAR(20) DEFAULT '1.0.0',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, config_code)
);

-- 业务规则表
CREATE TABLE business_rules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    rule_name VARCHAR(100) NOT NULL,
    rule_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 规则信息
    description TEXT,
    rule_type VARCHAR(50) NOT NULL CHECK (rule_type IN ('validation', 'calculation', 'workflow', 'decision', 'custom')),
    category VARCHAR(50),
    
    -- 规则配置
    rule_config JSONB DEFAULT '{}',
    condition_config JSONB DEFAULT '{}',
    action_config JSONB DEFAULT '{}',
    
    -- 规则状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'draft', 'archived')),
    priority INTEGER DEFAULT 0,
    is_enabled BOOLEAN DEFAULT TRUE,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, rule_code)
);

-- 2. 工作流管理

-- 工作流定义表
CREATE TABLE business_workflows (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    workflow_name VARCHAR(100) NOT NULL,
    workflow_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 工作流信息
    description TEXT,
    workflow_type VARCHAR(50) DEFAULT 'business' CHECK (workflow_type IN ('business', 'approval', 'notification', 'integration', 'custom')),
    category VARCHAR(50),
    
    -- 工作流配置
    workflow_config JSONB DEFAULT '{}',
    step_config JSONB DEFAULT '[]',
    trigger_config JSONB DEFAULT '{}',
    
    -- 工作流状态
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'active', 'inactive', 'archived')),
    version VARCHAR(20) DEFAULT '1.0.0',
    is_template BOOLEAN DEFAULT FALSE,
    
    -- 执行配置
    timeout_seconds INTEGER DEFAULT 3600,
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
CREATE TABLE business_workflow_executions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    workflow_id UUID NOT NULL,
    
    -- 执行信息
    execution_id VARCHAR(100) UNIQUE,
    business_key VARCHAR(100),
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

-- 3. 业务事件管理

-- 业务事件表
CREATE TABLE business_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    
    -- 事件信息
    event_name VARCHAR(100) NOT NULL,
    event_type VARCHAR(50) NOT NULL CHECK (event_type IN ('create', 'update', 'delete', 'status_change', 'custom')),
    event_source VARCHAR(100) NOT NULL,
    
    -- 事件数据
    event_data JSONB DEFAULT '{}',
    event_metadata JSONB DEFAULT '{}',
    correlation_id VARCHAR(100),
    
    -- 事件状态
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'processed', 'failed', 'ignored')),
    processing_attempts INTEGER DEFAULT 0,
    
    -- 时间信息
    occurred_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed_at TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 事件订阅表
CREATE TABLE business_event_subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    
    -- 订阅信息
    subscription_name VARCHAR(100) NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    event_source VARCHAR(100),
    
    -- 订阅配置
    subscription_config JSONB DEFAULT '{}',
    filter_config JSONB DEFAULT '{}',
    handler_config JSONB DEFAULT '{}',
    
    -- 订阅状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'draft')),
    is_enabled BOOLEAN DEFAULT TRUE,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, subscription_name)
);

-- 4. 业务数据管理

-- 业务数据表
CREATE TABLE business_data (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    
    -- 数据信息
    data_name VARCHAR(100) NOT NULL,
    data_type VARCHAR(50) NOT NULL CHECK (data_type IN ('master', 'transaction', 'reference', 'audit', 'custom')),
    data_category VARCHAR(50),
    
    -- 数据内容
    data_content JSONB DEFAULT '{}',
    data_schema JSONB DEFAULT '{}',
    data_metadata JSONB DEFAULT '{}',
    
    -- 数据状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'archived', 'deleted')),
    version VARCHAR(20) DEFAULT '1.0.0',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 业务数据版本表
CREATE TABLE business_data_versions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    data_id UUID NOT NULL,
    
    -- 版本信息
    version_number VARCHAR(20) NOT NULL,
    version_type VARCHAR(20) DEFAULT 'incremental' CHECK (version_type IN ('major', 'minor', 'incremental', 'patch')),
    
    -- 版本内容
    version_data JSONB DEFAULT '{}',
    change_summary TEXT,
    change_details JSONB DEFAULT '{}',
    
    -- 版本状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'deprecated')),
    is_current BOOLEAN DEFAULT FALSE,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, data_id, version_number)
);

-- 5. 业务集成管理

-- 集成配置表
CREATE TABLE business_integrations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    integration_name VARCHAR(100) NOT NULL,
    integration_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 集成信息
    description TEXT,
    integration_type VARCHAR(50) NOT NULL CHECK (integration_type IN ('api', 'database', 'message', 'file', 'custom')),
    category VARCHAR(50),
    
    -- 集成配置
    connection_config JSONB DEFAULT '{}',
    authentication_config JSONB DEFAULT '{}',
    mapping_config JSONB DEFAULT '{}',
    
    -- 集成状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'testing', 'error')),
    is_enabled BOOLEAN DEFAULT TRUE,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, integration_code)
);

-- 集成执行记录表
CREATE TABLE business_integration_executions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    integration_id UUID NOT NULL,
    
    -- 执行信息
    execution_type VARCHAR(50) NOT NULL CHECK (execution_type IN ('sync', 'async', 'batch', 'real_time')),
    operation_type VARCHAR(50) NOT NULL CHECK (operation_type IN ('read', 'write', 'sync', 'transform')),
    
    -- 执行数据
    input_data JSONB DEFAULT '{}',
    output_data JSONB DEFAULT '{}',
    error_data JSONB DEFAULT '{}',
    
    -- 执行状态
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'running', 'completed', 'failed', 'cancelled')),
    progress_percentage DECIMAL(5,2) DEFAULT 0,
    
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

-- 6. 业务报表管理

-- 报表定义表
CREATE TABLE business_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    report_name VARCHAR(100) NOT NULL,
    report_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 报表信息
    description TEXT,
    report_type VARCHAR(50) DEFAULT 'analytical' CHECK (report_type IN ('operational', 'analytical', 'executive', 'custom')),
    category VARCHAR(50),
    
    -- 报表配置
    report_config JSONB DEFAULT '{}',
    data_source_config JSONB DEFAULT '{}',
    layout_config JSONB DEFAULT '{}',
    
    -- 报表状态
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'active', 'inactive', 'archived')),
    is_scheduled BOOLEAN DEFAULT FALSE,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, report_code)
);

-- 报表执行记录表
CREATE TABLE business_report_executions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    report_id UUID NOT NULL,
    
    -- 执行信息
    execution_type VARCHAR(50) DEFAULT 'manual' CHECK (execution_type IN ('manual', 'scheduled', 'triggered')),
    parameters JSONB DEFAULT '{}',
    
    -- 执行状态
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'running', 'completed', 'failed', 'cancelled')),
    progress_percentage DECIMAL(5,2) DEFAULT 0,
    
    -- 执行结果
    result_data JSONB DEFAULT '{}',
    output_format VARCHAR(20) DEFAULT 'pdf' CHECK (output_format IN ('pdf', 'excel', 'html', 'json', 'csv')),
    file_path TEXT,
    
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

-- 7. 业务审计管理

-- 业务审计日志表
CREATE TABLE business_audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    
    -- 审计信息
    audit_type VARCHAR(50) NOT NULL CHECK (audit_type IN ('create', 'update', 'delete', 'access', 'custom')),
    audit_source VARCHAR(100) NOT NULL,
    audit_action VARCHAR(100) NOT NULL,
    
    -- 审计数据
    before_data JSONB DEFAULT '{}',
    after_data JSONB DEFAULT '{}',
    changed_fields JSONB DEFAULT '[]',
    
    -- 用户信息
    user_id UUID,
    user_name VARCHAR(100),
    ip_address INET,
    user_agent TEXT,
    
    -- 时间信息
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
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
CREATE TRIGGER update_business_configs_updated_at BEFORE UPDATE ON business_configs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_business_rules_updated_at BEFORE UPDATE ON business_rules FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_business_workflows_updated_at BEFORE UPDATE ON business_workflows FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_business_workflow_executions_updated_at BEFORE UPDATE ON business_workflow_executions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_business_events_updated_at BEFORE UPDATE ON business_events FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_business_event_subscriptions_updated_at BEFORE UPDATE ON business_event_subscriptions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_business_data_updated_at BEFORE UPDATE ON business_data FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_business_data_versions_updated_at BEFORE UPDATE ON business_data_versions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_business_integrations_updated_at BEFORE UPDATE ON business_integrations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_business_integration_executions_updated_at BEFORE UPDATE ON business_integration_executions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_business_reports_updated_at BEFORE UPDATE ON business_reports FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_business_report_executions_updated_at BEFORE UPDATE ON business_report_executions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_business_audit_logs_updated_at BEFORE UPDATE ON business_audit_logs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
