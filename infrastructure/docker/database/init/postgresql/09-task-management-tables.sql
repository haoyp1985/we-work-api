-- 任务管理数据库表结构
-- 连接到task_management数据库

\c task_management;

-- 1. 任务定义管理

-- 任务模板表
CREATE TABLE task_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    template_name VARCHAR(100) NOT NULL,
    template_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 模板信息
    description TEXT,
    template_type VARCHAR(50) DEFAULT 'standard' CHECK (template_type IN ('standard', 'recurring', 'milestone', 'custom')),
    category VARCHAR(50),
    
    -- 模板配置
    template_config JSONB DEFAULT '{}',
    step_config JSONB DEFAULT '[]',
    validation_config JSONB DEFAULT '{}',
    
    -- 模板状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'draft', 'archived')),
    is_public BOOLEAN DEFAULT FALSE,
    version VARCHAR(20) DEFAULT '1.0.0',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, template_code)
);

-- 任务定义表
CREATE TABLE task_definitions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    task_name VARCHAR(100) NOT NULL,
    task_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 任务信息
    description TEXT,
    task_type VARCHAR(50) DEFAULT 'manual' CHECK (task_type IN ('manual', 'automated', 'approval', 'notification', 'custom')),
    category VARCHAR(50),
    
    -- 任务配置
    task_config JSONB DEFAULT '{}',
    workflow_config JSONB DEFAULT '{}',
    integration_config JSONB DEFAULT '{}',
    
    -- 任务状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'draft', 'archived')),
    is_template BOOLEAN DEFAULT FALSE,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, task_code)
);

-- 2. 任务执行管理

-- 任务实例表
CREATE TABLE task_instances (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    task_id UUID NOT NULL,
    
    -- 实例信息
    instance_name VARCHAR(100) NOT NULL,
    instance_code VARCHAR(50) UNIQUE NOT NULL,
    parent_instance_id UUID,
    
    -- 实例配置
    instance_config JSONB DEFAULT '{}',
    input_data JSONB DEFAULT '{}',
    output_data JSONB DEFAULT '{}',
    
    -- 实例状态
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'running', 'completed', 'failed', 'cancelled', 'paused')),
    progress_percentage DECIMAL(5,2) DEFAULT 0,
    current_step INTEGER DEFAULT 0,
    total_steps INTEGER DEFAULT 0,
    
    -- 时间信息
    scheduled_at TIMESTAMP,
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    due_date TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, instance_code)
);

-- 任务步骤表
CREATE TABLE task_steps (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    task_instance_id UUID NOT NULL,
    
    -- 步骤信息
    step_name VARCHAR(100) NOT NULL,
    step_type VARCHAR(50) DEFAULT 'action' CHECK (step_type IN ('action', 'decision', 'approval', 'notification', 'custom')),
    step_order INTEGER NOT NULL,
    
    -- 步骤配置
    step_config JSONB DEFAULT '{}',
    input_config JSONB DEFAULT '{}',
    output_config JSONB DEFAULT '{}',
    
    -- 步骤状态
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'running', 'completed', 'failed', 'skipped')),
    result_data JSONB DEFAULT '{}',
    error_message TEXT,
    
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

-- 3. 任务分配管理

-- 任务分配表
CREATE TABLE task_assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    task_instance_id UUID NOT NULL,
    
    -- 分配信息
    assignee_id UUID NOT NULL,
    assignee_type VARCHAR(20) DEFAULT 'user' CHECK (assignee_type IN ('user', 'role', 'team', 'system')),
    assignment_type VARCHAR(20) DEFAULT 'primary' CHECK (assignment_type IN ('primary', 'secondary', 'reviewer', 'approver')),
    
    -- 分配配置
    assignment_config JSONB DEFAULT '{}',
    notification_config JSONB DEFAULT '{}',
    
    -- 分配状态
    status VARCHAR(20) DEFAULT 'assigned' CHECK (status IN ('assigned', 'accepted', 'in_progress', 'completed', 'rejected')),
    accepted_at TIMESTAMP,
    completed_at TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 任务协作表
CREATE TABLE task_collaborations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    task_instance_id UUID NOT NULL,
    
    -- 协作信息
    collaborator_id UUID NOT NULL,
    collaboration_type VARCHAR(20) DEFAULT 'participant' CHECK (collaboration_type IN ('participant', 'observer', 'consultant', 'reviewer')),
    
    -- 协作配置
    collaboration_config JSONB DEFAULT '{}',
    permissions JSONB DEFAULT '[]',
    
    -- 协作状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'removed')),
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 4. 任务工作流管理

-- 工作流定义表
CREATE TABLE task_workflows (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    workflow_name VARCHAR(100) NOT NULL,
    workflow_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 工作流信息
    description TEXT,
    workflow_type VARCHAR(50) DEFAULT 'sequential' CHECK (workflow_type IN ('sequential', 'parallel', 'conditional', 'custom')),
    category VARCHAR(50),
    
    -- 工作流配置
    workflow_config JSONB DEFAULT '{}',
    step_definitions JSONB DEFAULT '[]',
    transition_config JSONB DEFAULT '{}',
    
    -- 工作流状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'draft', 'archived')),
    version VARCHAR(20) DEFAULT '1.0.0',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, workflow_code)
);

-- 工作流执行表
CREATE TABLE task_workflow_executions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    workflow_id UUID NOT NULL,
    task_instance_id UUID NOT NULL,
    
    -- 执行信息
    execution_id VARCHAR(100) UNIQUE,
    current_step VARCHAR(100),
    execution_path JSONB DEFAULT '[]',
    
    -- 执行状态
    status VARCHAR(20) DEFAULT 'running' CHECK (status IN ('running', 'completed', 'failed', 'cancelled', 'paused')),
    progress_percentage DECIMAL(5,2) DEFAULT 0,
    
    -- 执行结果
    result_data JSONB DEFAULT '{}',
    error_message TEXT,
    execution_log JSONB DEFAULT '[]',
    
    -- 时间信息
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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

-- 5. 任务审批管理

-- 审批流程表
CREATE TABLE task_approval_processes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    process_name VARCHAR(100) NOT NULL,
    process_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 流程信息
    description TEXT,
    process_type VARCHAR(50) DEFAULT 'sequential' CHECK (process_type IN ('sequential', 'parallel', 'any', 'custom')),
    category VARCHAR(50),
    
    -- 流程配置
    process_config JSONB DEFAULT '{}',
    approval_steps JSONB DEFAULT '[]',
    escalation_config JSONB DEFAULT '{}',
    
    -- 流程状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'draft', 'archived')),
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, process_code)
);

-- 审批实例表
CREATE TABLE task_approval_instances (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    process_id UUID NOT NULL,
    task_instance_id UUID NOT NULL,
    
    -- 实例信息
    instance_title VARCHAR(200) NOT NULL,
    current_step INTEGER DEFAULT 0,
    total_steps INTEGER DEFAULT 0,
    
    -- 实例状态
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'approved', 'rejected', 'cancelled')),
    approval_result VARCHAR(20),
    approval_reason TEXT,
    
    -- 时间信息
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_at TIMESTAMP,
    rejected_at TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 审批步骤表
CREATE TABLE task_approval_steps (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    approval_instance_id UUID NOT NULL,
    
    -- 步骤信息
    step_name VARCHAR(100) NOT NULL,
    step_order INTEGER NOT NULL,
    approver_id UUID NOT NULL,
    approver_type VARCHAR(20) DEFAULT 'user' CHECK (approver_type IN ('user', 'role', 'team')),
    
    -- 步骤状态
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'skipped')),
    approval_decision VARCHAR(20),
    approval_comment TEXT,
    
    -- 时间信息
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_at TIMESTAMP,
    rejected_at TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 6. 任务通知管理

-- 通知模板表
CREATE TABLE task_notification_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    template_name VARCHAR(100) NOT NULL,
    template_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 模板信息
    description TEXT,
    notification_type VARCHAR(50) DEFAULT 'email' CHECK (notification_type IN ('email', 'sms', 'push', 'in_app', 'webhook', 'custom')),
    category VARCHAR(50),
    
    -- 模板内容
    subject_template TEXT,
    content_template TEXT,
    content_type VARCHAR(20) DEFAULT 'text' CHECK (content_type IN ('text', 'html', 'markdown')),
    
    -- 模板配置
    template_config JSONB DEFAULT '{}',
    variables JSONB DEFAULT '[]',
    conditions JSONB DEFAULT '{}',
    
    -- 模板状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'draft', 'archived')),
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, template_code)
);

-- 通知记录表
CREATE TABLE task_notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    task_instance_id UUID NOT NULL,
    
    -- 通知信息
    notification_type VARCHAR(50) NOT NULL CHECK (notification_type IN ('email', 'sms', 'push', 'in_app', 'webhook', 'custom')),
    recipient_id UUID NOT NULL,
    recipient_type VARCHAR(20) DEFAULT 'user' CHECK (recipient_type IN ('user', 'role', 'team', 'email')),
    
    -- 通知内容
    subject VARCHAR(200),
    content TEXT,
    content_data JSONB DEFAULT '{}',
    
    -- 通知状态
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'sent', 'delivered', 'read', 'failed')),
    delivery_attempts INTEGER DEFAULT 0,
    error_message TEXT,
    
    -- 时间信息
    scheduled_at TIMESTAMP,
    sent_at TIMESTAMP,
    delivered_at TIMESTAMP,
    read_at TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 7. 任务统计管理

-- 任务使用统计表
CREATE TABLE task_usage_statistics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    
    -- 统计信息
    statistic_type VARCHAR(50) NOT NULL,
    statistic_name VARCHAR(100) NOT NULL,
    statistic_period VARCHAR(20) DEFAULT 'daily' CHECK (statistic_period IN ('hourly', 'daily', 'weekly', 'monthly')),
    
    -- 数值统计
    total_count BIGINT DEFAULT 0,
    completed_count BIGINT DEFAULT 0,
    failed_count BIGINT DEFAULT 0,
    cancelled_count BIGINT DEFAULT 0,
    
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

-- 任务性能指标表
CREATE TABLE task_performance_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    task_id UUID,
    
    -- 指标信息
    metric_name VARCHAR(100) NOT NULL,
    metric_type VARCHAR(50) NOT NULL CHECK (metric_type IN ('duration', 'throughput', 'success_rate', 'error_rate', 'custom')),
    metric_value DECIMAL(15,4) NOT NULL,
    metric_unit VARCHAR(20),
    
    -- 指标标签
    labels JSONB DEFAULT '{}',
    tags JSONB DEFAULT '{}',
    
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
CREATE TRIGGER update_task_templates_updated_at BEFORE UPDATE ON task_templates FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_task_definitions_updated_at BEFORE UPDATE ON task_definitions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_task_instances_updated_at BEFORE UPDATE ON task_instances FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_task_steps_updated_at BEFORE UPDATE ON task_steps FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_task_assignments_updated_at BEFORE UPDATE ON task_assignments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_task_collaborations_updated_at BEFORE UPDATE ON task_collaborations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_task_workflows_updated_at BEFORE UPDATE ON task_workflows FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_task_workflow_executions_updated_at BEFORE UPDATE ON task_workflow_executions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_task_approval_processes_updated_at BEFORE UPDATE ON task_approval_processes FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_task_approval_instances_updated_at BEFORE UPDATE ON task_approval_instances FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_task_approval_steps_updated_at BEFORE UPDATE ON task_approval_steps FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_task_notification_templates_updated_at BEFORE UPDATE ON task_notification_templates FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_task_notifications_updated_at BEFORE UPDATE ON task_notifications FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_task_usage_statistics_updated_at BEFORE UPDATE ON task_usage_statistics FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_task_performance_metrics_updated_at BEFORE UPDATE ON task_performance_metrics FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
