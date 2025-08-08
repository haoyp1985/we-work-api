-- 企微平台数据库表结构
-- 连接到wework_platform_wechat数据库

\c wework_platform_wechat;

-- 1. 企业微信配置管理

-- 企业微信应用配置表
CREATE TABLE wework_app_configs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    app_name VARCHAR(100) NOT NULL,
    app_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 应用信息
    description TEXT,
    app_type VARCHAR(50) NOT NULL CHECK (app_type IN ('internal', 'external', 'third_party')),
    category VARCHAR(50),
    
    -- 企业微信配置
    corp_id VARCHAR(100) NOT NULL,
    agent_id VARCHAR(100),
    secret VARCHAR(200),
    token VARCHAR(100),
    encoding_aes_key VARCHAR(100),
    
    -- 权限配置
    permissions JSONB DEFAULT '[]',
    scopes JSONB DEFAULT '[]',
    features JSONB DEFAULT '[]',
    
    -- 状态管理
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'testing', 'archived')),
    is_default BOOLEAN DEFAULT FALSE,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, app_code)
);

-- 企业微信部门表
CREATE TABLE wework_departments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    wework_dept_id INTEGER NOT NULL,
    
    -- 部门信息
    dept_name VARCHAR(100) NOT NULL,
    dept_name_en VARCHAR(100),
    parent_dept_id INTEGER,
    order_num INTEGER DEFAULT 0,
    
    -- 部门配置
    dept_config JSONB DEFAULT '{}',
    contact_info JSONB DEFAULT '{}',
    
    -- 状态管理
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'deleted')),
    sync_status VARCHAR(20) DEFAULT 'pending' CHECK (sync_status IN ('pending', 'syncing', 'synced', 'failed')),
    
    -- 同步信息
    last_sync_at TIMESTAMP,
    sync_error TEXT,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, wework_dept_id)
);

-- 企业微信成员表
CREATE TABLE wework_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    wework_user_id VARCHAR(100) NOT NULL,
    
    -- 成员基本信息
    name VARCHAR(100) NOT NULL,
    mobile VARCHAR(20),
    email VARCHAR(100),
    avatar_url TEXT,
    
    -- 成员详细信息
    gender INTEGER DEFAULT 0 CHECK (gender IN (0, 1, 2)), -- 0:未知 1:男 2:女
    position VARCHAR(100),
    department_ids JSONB DEFAULT '[]',
    main_department_id INTEGER,
    
    -- 成员状态
    status INTEGER DEFAULT 1 CHECK (status IN (1, 2, 4)), -- 1:已激活 2:已禁用 4:未激活
    enable INTEGER DEFAULT 1 CHECK (enable IN (0, 1)), -- 0:禁用 1:启用
    
    -- 成员配置
    member_config JSONB DEFAULT '{}',
    ext_attr JSONB DEFAULT '{}',
    
    -- 同步信息
    sync_status VARCHAR(20) DEFAULT 'pending' CHECK (sync_status IN ('pending', 'syncing', 'synced', 'failed')),
    last_sync_at TIMESTAMP,
    sync_error TEXT,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, wework_user_id)
);

-- 2. 消息管理

-- 消息模板表
CREATE TABLE wework_message_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    template_name VARCHAR(100) NOT NULL,
    template_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 模板信息
    description TEXT,
    template_type VARCHAR(50) DEFAULT 'text' CHECK (template_type IN ('text', 'image', 'voice', 'video', 'file', 'textcard', 'news', 'mpnews')),
    category VARCHAR(50),
    
    -- 模板内容
    content TEXT,
    content_config JSONB DEFAULT '{}',
    template_data JSONB DEFAULT '{}',
    
    -- 模板配置
    template_config JSONB DEFAULT '{}',
    variables JSONB DEFAULT '[]',
    conditions JSONB DEFAULT '{}',
    
    -- 状态管理
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'draft', 'archived')),
    is_system BOOLEAN DEFAULT FALSE,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, template_code)
);

-- 消息发送记录表
CREATE TABLE wework_message_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    app_id UUID NOT NULL,
    
    -- 消息信息
    message_type VARCHAR(50) NOT NULL CHECK (message_type IN ('text', 'image', 'voice', 'video', 'file', 'textcard', 'news', 'mpnews')),
    message_content TEXT,
    message_config JSONB DEFAULT '{}',
    
    -- 接收者信息
    receiver_type VARCHAR(20) DEFAULT 'user' CHECK (receiver_type IN ('user', 'department', 'tag', 'all')),
    receiver_ids JSONB DEFAULT '[]',
    receiver_count INTEGER DEFAULT 0,
    
    -- 发送状态
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'sending', 'sent', 'delivered', 'failed')),
    wework_msg_id VARCHAR(100),
    send_time TIMESTAMP,
    
    -- 发送结果
    success_count INTEGER DEFAULT 0,
    failure_count INTEGER DEFAULT 0,
    error_message TEXT,
    result_data JSONB DEFAULT '{}',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 3. 客户管理

-- 客户信息表
CREATE TABLE wework_customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    external_userid VARCHAR(100) NOT NULL,
    
    -- 客户基本信息
    name VARCHAR(100),
    avatar_url TEXT,
    type INTEGER DEFAULT 1 CHECK (type IN (1, 2)), -- 1:微信用户 2:企业微信用户
    gender INTEGER DEFAULT 0 CHECK (gender IN (0, 1, 2)), -- 0:未知 1:男 2:女
    
    -- 客户详细信息
    unionid VARCHAR(100),
    position VARCHAR(100),
    company VARCHAR(200),
    description TEXT,
    
    -- 客户状态
    status INTEGER DEFAULT 0 CHECK (status IN (0, 1, 2, 3)), -- 0:待通过 1:已通过 2:已拒绝 3:已删除
    follow_info JSONB DEFAULT '{}',
    
    -- 标签信息
    tags JSONB DEFAULT '[]',
    remark TEXT,
    
    -- 同步信息
    sync_status VARCHAR(20) DEFAULT 'pending' CHECK (sync_status IN ('pending', 'syncing', 'synced', 'failed')),
    last_sync_at TIMESTAMP,
    sync_error TEXT,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, external_userid)
);

-- 客户群组表
CREATE TABLE wework_customer_groups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    chat_id VARCHAR(100) NOT NULL,
    
    -- 群组信息
    name VARCHAR(200),
    owner VARCHAR(100),
    notice TEXT,
    member_list JSONB DEFAULT '[]',
    
    -- 群组状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'deleted')),
    member_count INTEGER DEFAULT 0,
    
    -- 群组配置
    group_config JSONB DEFAULT '{}',
    admin_list JSONB DEFAULT '[]',
    
    -- 同步信息
    sync_status VARCHAR(20) DEFAULT 'pending' CHECK (sync_status IN ('pending', 'syncing', 'synced', 'failed')),
    last_sync_at TIMESTAMP,
    sync_error TEXT,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, chat_id)
);

-- 4. 应用管理

-- 应用菜单表
CREATE TABLE wework_app_menus (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    app_id UUID NOT NULL,
    
    -- 菜单信息
    menu_name VARCHAR(100) NOT NULL,
    menu_type VARCHAR(20) DEFAULT 'click' CHECK (menu_type IN ('click', 'view', 'miniprogram', 'scancode_push', 'scancode_waitmsg', 'pic_sysphoto', 'pic_photo_or_album', 'pic_weixin', 'location_select')),
    menu_key VARCHAR(100),
    menu_url TEXT,
    
    -- 菜单配置
    menu_config JSONB DEFAULT '{}',
    sub_buttons JSONB DEFAULT '[]',
    
    -- 菜单状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'draft')),
    sort_order INTEGER DEFAULT 0,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 应用权限表
CREATE TABLE wework_app_permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    app_id UUID NOT NULL,
    
    -- 权限信息
    permission_name VARCHAR(100) NOT NULL,
    permission_type VARCHAR(50) NOT NULL CHECK (permission_type IN ('api', 'menu', 'data', 'custom')),
    permission_code VARCHAR(100) NOT NULL,
    
    -- 权限配置
    permission_config JSONB DEFAULT '{}',
    scope_config JSONB DEFAULT '{}',
    
    -- 权限状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'deprecated')),
    is_required BOOLEAN DEFAULT FALSE,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, app_id, permission_code)
);

-- 5. 数据同步

-- 同步任务表
CREATE TABLE wework_sync_tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    
    -- 任务信息
    task_name VARCHAR(100) NOT NULL,
    task_type VARCHAR(50) NOT NULL CHECK (task_type IN ('department', 'member', 'customer', 'group', 'message', 'custom')),
    description TEXT,
    
    -- 任务配置
    task_config JSONB DEFAULT '{}',
    sync_config JSONB DEFAULT '{}',
    
    -- 任务状态
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'running', 'completed', 'failed', 'cancelled')),
    progress_percentage DECIMAL(5,2) DEFAULT 0,
    
    -- 任务结果
    result_data JSONB DEFAULT '{}',
    error_message TEXT,
    sync_log JSONB DEFAULT '[]',
    
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

-- 同步日志表
CREATE TABLE wework_sync_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    task_id UUID,
    
    -- 日志信息
    log_type VARCHAR(50) NOT NULL CHECK (log_type IN ('info', 'warning', 'error', 'success')),
    log_message TEXT NOT NULL,
    log_data JSONB DEFAULT '{}',
    
    -- 时间信息
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 6. 统计分析

-- 企微使用统计表
CREATE TABLE wework_usage_statistics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    app_id UUID,
    
    -- 统计信息
    statistic_type VARCHAR(50) NOT NULL,
    statistic_name VARCHAR(100) NOT NULL,
    statistic_period VARCHAR(20) DEFAULT 'daily' CHECK (statistic_period IN ('hourly', 'daily', 'weekly', 'monthly')),
    
    -- 数值统计
    total_count BIGINT DEFAULT 0,
    success_count BIGINT DEFAULT 0,
    failure_count BIGINT DEFAULT 0,
    total_cost DECIMAL(15,4) DEFAULT 0,
    
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

-- 企微性能监控表
CREATE TABLE wework_performance_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    app_id UUID,
    
    -- 指标信息
    metric_name VARCHAR(100) NOT NULL,
    metric_type VARCHAR(50) NOT NULL CHECK (metric_type IN ('latency', 'throughput', 'error_rate', 'cost', 'custom')),
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

-- 创建触发器函数来更新updated_at字段
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 为所有表添加updated_at触发器
CREATE TRIGGER update_wework_app_configs_updated_at BEFORE UPDATE ON wework_app_configs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_wework_departments_updated_at BEFORE UPDATE ON wework_departments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_wework_members_updated_at BEFORE UPDATE ON wework_members FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_wework_message_templates_updated_at BEFORE UPDATE ON wework_message_templates FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_wework_message_records_updated_at BEFORE UPDATE ON wework_message_records FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_wework_customers_updated_at BEFORE UPDATE ON wework_customers FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_wework_customer_groups_updated_at BEFORE UPDATE ON wework_customer_groups FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_wework_app_menus_updated_at BEFORE UPDATE ON wework_app_menus FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_wework_app_permissions_updated_at BEFORE UPDATE ON wework_app_permissions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_wework_sync_tasks_updated_at BEFORE UPDATE ON wework_sync_tasks FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_wework_sync_logs_updated_at BEFORE UPDATE ON wework_sync_logs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_wework_usage_statistics_updated_at BEFORE UPDATE ON wework_usage_statistics FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_wework_performance_metrics_updated_at BEFORE UPDATE ON wework_performance_metrics FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
