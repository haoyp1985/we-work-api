-- PostgreSQL SaaS统一核心数据库表结构
-- 连接到saas_unified_core数据库

\c saas_unified_core;

-- 1. 核心身份管理层

-- 租户主表
CREATE TABLE saas_tenants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_code VARCHAR(50) UNIQUE NOT NULL,
    tenant_name VARCHAR(100) NOT NULL,
    
    -- 企业信息
    company_name VARCHAR(200),
    company_address TEXT,
    company_phone VARCHAR(50),
    company_email VARCHAR(100),
    business_license VARCHAR(100),
    legal_person VARCHAR(50),
    
    -- 订阅信息
    subscription_plan VARCHAR(50) DEFAULT 'basic',
    subscription_start_date TIMESTAMP,
    subscription_end_date TIMESTAMP,
    max_users INTEGER DEFAULT 100,
    max_storage_gb INTEGER DEFAULT 10,
    
    -- 技术配置
    api_rate_limit INTEGER DEFAULT 1000,
    webhook_url TEXT,
    callback_url TEXT,
    custom_domain VARCHAR(200),
    
    -- 集成配置
    wework_corp_id VARCHAR(100),
    wework_secret VARCHAR(200),
    dingtalk_app_key VARCHAR(100),
    dingtalk_app_secret VARCHAR(200),
    
    -- 状态管理
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended', 'deleted')),
    is_trial BOOLEAN DEFAULT FALSE,
    trial_expires_at TIMESTAMP,
    
    -- 功能开关
    features JSONB DEFAULT '{}',
    settings JSONB DEFAULT '{}',
    
    -- 资源限制
    resource_limits JSONB DEFAULT '{}',
    usage_metrics JSONB DEFAULT '{}',
    
    -- 安全配置
    security_settings JSONB DEFAULT '{}',
    audit_settings JSONB DEFAULT '{}',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 软删除
    deleted_at TIMESTAMP,
    version INTEGER DEFAULT 1
);

-- 用户主表
CREATE TABLE saas_users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES saas_tenants(id) ON DELETE CASCADE,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    
    -- 基本信息
    real_name VARCHAR(100),
    avatar_url TEXT,
    gender VARCHAR(10) CHECK (gender IN ('male', 'female', 'other')),
    birth_date DATE,
    
    -- 个人信息
    department VARCHAR(100),
    position VARCHAR(100),
    employee_id VARCHAR(50),
    hire_date DATE,
    
    -- 状态管理
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'locked', 'deleted')),
    is_admin BOOLEAN DEFAULT FALSE,
    is_super_admin BOOLEAN DEFAULT FALSE,
    
    -- 验证状态
    email_verified BOOLEAN DEFAULT FALSE,
    phone_verified BOOLEAN DEFAULT FALSE,
    mfa_enabled BOOLEAN DEFAULT FALSE,
    mfa_secret VARCHAR(100),
    
    -- 登录信息
    last_login_at TIMESTAMP,
    last_login_ip INET,
    login_count INTEGER DEFAULT 0,
    password_hash VARCHAR(255),
    password_changed_at TIMESTAMP,
    
    -- 密码策略
    password_expires_at TIMESTAMP,
    password_history JSONB DEFAULT '[]',
    failed_login_attempts INTEGER DEFAULT 0,
    locked_until TIMESTAMP,
    
    -- 多因子认证
    mfa_methods JSONB DEFAULT '[]',
    backup_codes JSONB DEFAULT '[]',
    
    -- 偏好设置
    preferences JSONB DEFAULT '{}',
    timezone VARCHAR(50) DEFAULT 'Asia/Shanghai',
    language VARCHAR(10) DEFAULT 'zh-CN',
    
    -- 扩展信息
    custom_fields JSONB DEFAULT '{}',
    metadata JSONB DEFAULT '{}',
    
    -- 软删除
    deleted_at TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 唯一约束
    UNIQUE(tenant_id, username),
    UNIQUE(tenant_id, email),
    UNIQUE(tenant_id, phone)
);

-- 角色管理表
CREATE TABLE saas_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES saas_tenants(id) ON DELETE CASCADE,
    role_code VARCHAR(50) NOT NULL,
    role_name VARCHAR(100) NOT NULL,
    
    -- 角色信息
    description TEXT,
    role_type VARCHAR(20) DEFAULT 'custom' CHECK (role_type IN ('system', 'custom', 'inherited')),
    
    -- 角色分类
    category VARCHAR(50),
    priority INTEGER DEFAULT 0,
    
    -- 角色层级
    parent_role_id UUID REFERENCES saas_roles(id),
    role_level INTEGER DEFAULT 1,
    
    -- 权限范围
    scope_type VARCHAR(20) DEFAULT 'global' CHECK (scope_type IN ('global', 'department', 'project', 'custom')),
    scope_value JSONB DEFAULT '{}',
    
    -- 角色约束
    max_users INTEGER,
    is_default BOOLEAN DEFAULT FALSE,
    is_system BOOLEAN DEFAULT FALSE,
    
    -- 角色属性
    attributes JSONB DEFAULT '{}',
    constraints JSONB DEFAULT '{}',
    
    -- 生效时间
    effective_from TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    effective_to TIMESTAMP,
    
    -- 状态管理
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'deleted')),
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束和索引
    UNIQUE(tenant_id, role_code)
);

-- 权限管理表
CREATE TABLE saas_permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES saas_tenants(id) ON DELETE CASCADE,
    permission_code VARCHAR(100) NOT NULL,
    permission_name VARCHAR(100) NOT NULL,
    
    -- 权限标识
    resource VARCHAR(100) NOT NULL,
    action VARCHAR(50) NOT NULL,
    permission_type VARCHAR(20) DEFAULT 'api' CHECK (permission_type IN ('api', 'ui', 'data', 'function')),
    
    -- 权限分类
    category VARCHAR(50),
    module VARCHAR(50),
    sub_module VARCHAR(50),
    
    -- 权限层级
    parent_permission_id UUID REFERENCES saas_permissions(id),
    permission_level INTEGER DEFAULT 1,
    
    -- 权限属性
    attributes JSONB DEFAULT '{}',
    constraints JSONB DEFAULT '{}',
    
    -- 权限约束
    is_system BOOLEAN DEFAULT FALSE,
    is_required BOOLEAN DEFAULT FALSE,
    
    -- 权限配置
    config JSONB DEFAULT '{}',
    metadata JSONB DEFAULT '{}',
    
    -- 状态管理
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'deleted')),
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束和索引
    UNIQUE(tenant_id, permission_code),
    UNIQUE(tenant_id, resource, action)
);

-- 用户角色关联表
CREATE TABLE saas_user_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES saas_tenants(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES saas_users(id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES saas_roles(id) ON DELETE CASCADE,
    
    -- 授权信息
    granted_by UUID REFERENCES saas_users(id),
    granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    granted_reason TEXT,
    
    -- 权限范围
    scope_type VARCHAR(20) DEFAULT 'global' CHECK (scope_type IN ('global', 'department', 'project', 'custom')),
    scope_value JSONB DEFAULT '{}',
    
    -- 时间限制
    effective_from TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    effective_to TIMESTAMP,
    
    -- 状态管理
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'expired')),
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束和索引
    UNIQUE(tenant_id, user_id, role_id, scope_type)
);

-- 角色权限关联表
CREATE TABLE saas_role_permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES saas_tenants(id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES saas_roles(id) ON DELETE CASCADE,
    permission_id UUID NOT NULL REFERENCES saas_permissions(id) ON DELETE CASCADE,
    
    -- 权限配置
    permission_config JSONB DEFAULT '{}',
    permission_constraints JSONB DEFAULT '{}',
    
    -- 权限约束
    is_inherited BOOLEAN DEFAULT FALSE,
    inherited_from UUID REFERENCES saas_role_permissions(id),
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束和索引
    UNIQUE(tenant_id, role_id, permission_id)
);

-- 2. 安全审计层

-- API密钥管理表
CREATE TABLE saas_api_keys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES saas_tenants(id) ON DELETE CASCADE,
    user_id UUID REFERENCES saas_users(id) ON DELETE CASCADE,
    key_name VARCHAR(100) NOT NULL,
    key_hash VARCHAR(255) NOT NULL,
    
    -- 密钥信息
    key_type VARCHAR(20) DEFAULT 'api' CHECK (key_type IN ('api', 'webhook', 'integration')),
    key_format VARCHAR(20) DEFAULT 'bearer' CHECK (key_format IN ('bearer', 'header', 'query')),
    
    -- 权限配置
    permissions JSONB DEFAULT '[]',
    scopes JSONB DEFAULT '[]',
    
    -- 限流配置
    rate_limit_per_minute INTEGER DEFAULT 1000,
    rate_limit_per_hour INTEGER DEFAULT 10000,
    rate_limit_per_day INTEGER DEFAULT 100000,
    
    -- 使用统计
    last_used_at TIMESTAMP,
    usage_count INTEGER DEFAULT 0,
    usage_metrics JSONB DEFAULT '{}',
    
    -- 状态管理
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'revoked')),
    expires_at TIMESTAMP,
    
    -- 安全配置
    ip_whitelist JSONB DEFAULT '[]',
    user_agent_whitelist JSONB DEFAULT '[]',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束和索引
    UNIQUE(tenant_id, key_hash)
);

-- 用户会话管理表
CREATE TABLE saas_user_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES saas_tenants(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES saas_users(id) ON DELETE CASCADE,
    
    -- 会话标识
    session_token VARCHAR(255) UNIQUE NOT NULL,
    refresh_token VARCHAR(255),
    session_type VARCHAR(20) DEFAULT 'web' CHECK (session_type IN ('web', 'mobile', 'api', 'cli')),
    
    -- 设备信息
    device_id VARCHAR(100),
    device_type VARCHAR(50),
    device_name VARCHAR(100),
    device_model VARCHAR(100),
    
    -- 登录信息
    login_ip INET,
    login_location JSONB DEFAULT '{}',
    user_agent TEXT,
    login_method VARCHAR(20) DEFAULT 'password' CHECK (login_method IN ('password', 'mfa', 'sso', 'api_key')),
    
    -- 会话状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'expired', 'revoked', 'suspended')),
    is_current BOOLEAN DEFAULT FALSE,
    
    -- 时间管理
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_activity_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    refresh_expires_at TIMESTAMP,
    
    -- 安全信息
    security_level VARCHAR(20) DEFAULT 'normal' CHECK (security_level IN ('low', 'normal', 'high', 'critical')),
    risk_score DECIMAL(5,2) DEFAULT 0,
    security_flags JSONB DEFAULT '[]',
    
    -- 会话数据
    session_data JSONB DEFAULT '{}',
    preferences JSONB DEFAULT '{}',
    
    -- 撤销信息
    revoked_at TIMESTAMP,
    revoked_by UUID REFERENCES saas_users(id),
    revoked_reason TEXT,
    
    -- 约束和索引
    CONSTRAINT idx_session_token UNIQUE (session_token)
);

-- 统一审计日志表
CREATE TABLE saas_unified_audit_logs (
    id UUID DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES saas_tenants(id) ON DELETE CASCADE,
    
    -- 基础信息
    log_type VARCHAR(20) NOT NULL CHECK (log_type IN ('operation', 'security', 'business', 'system')),
    module VARCHAR(50) NOT NULL,
    sub_module VARCHAR(50),
    
    -- 操作者信息
    operator_id UUID REFERENCES saas_users(id),
    operator_name VARCHAR(100),
    operator_ip INET,
    operator_user_agent TEXT,
    
    -- 操作详情
    operation VARCHAR(100) NOT NULL,
    operation_desc TEXT,
    operation_result VARCHAR(20) DEFAULT 'success' CHECK (operation_result IN ('success', 'failed', 'partial')),
    
    -- 变更数据 (JSON统一存储)
    before_data JSONB DEFAULT '{}',
    after_data JSONB DEFAULT '{}',
    changed_fields JSONB DEFAULT '[]',
    
    -- 执行结果
    error_code VARCHAR(50),
    error_message TEXT,
    execution_time_ms INTEGER,
    
    -- 环境信息
    request_id VARCHAR(100),
    trace_id VARCHAR(100),
    span_id VARCHAR(100),
    environment VARCHAR(20) DEFAULT 'production',
    
    -- 业务扩展
    business_id VARCHAR(100),
    business_type VARCHAR(50),
    business_data JSONB DEFAULT '{}',
    
    -- 时间信息
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 复合主键
    PRIMARY KEY(tenant_id, id, created_at),
    
    -- 索引设计
    CONSTRAINT idx_tenant_created UNIQUE (tenant_id, created_at)
) PARTITION BY RANGE (created_at);

-- 创建分区表
CREATE TABLE saas_unified_audit_logs_2024_01 PARTITION OF saas_unified_audit_logs
    FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE saas_unified_audit_logs_2024_02 PARTITION OF saas_unified_audit_logs
    FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

CREATE TABLE saas_unified_audit_logs_2024_03 PARTITION OF saas_unified_audit_logs
    FOR VALUES FROM ('2024-03-01') TO ('2024-04-01');

-- 登录尝试记录表
CREATE TABLE saas_login_attempts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID REFERENCES saas_tenants(id) ON DELETE CASCADE,
    
    -- 登录信息
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    login_method VARCHAR(20) DEFAULT 'password' CHECK (login_method IN ('password', 'mfa', 'sso', 'api_key')),
    
    -- 结果信息
    attempt_result VARCHAR(20) NOT NULL CHECK (attempt_result IN ('success', 'failed', 'blocked', 'suspended')),
    failure_reason VARCHAR(200),
    
    -- 环境信息
    ip_address INET NOT NULL,
    user_agent TEXT,
    device_fingerprint VARCHAR(255),
    location JSONB DEFAULT '{}',
    
    -- 安全信息
    risk_score DECIMAL(5,2) DEFAULT 0,
    is_suspicious BOOLEAN DEFAULT FALSE,
    blocked_until TIMESTAMP,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 索引设计
    CONSTRAINT idx_tenant_username UNIQUE (tenant_id, username),
    
    -- 外键约束
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE
);

-- 3. 配额计费层

-- 租户配额管理表
CREATE TABLE saas_tenant_quotas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES saas_tenants(id) ON DELETE CASCADE,
    
    -- 配额信息
    quota_type VARCHAR(50) NOT NULL,
    quota_name VARCHAR(100) NOT NULL,
    quota_description TEXT,
    
    -- 限制设置
    max_limit BIGINT DEFAULT 0,
    current_usage BIGINT DEFAULT 0,
    warning_threshold DECIMAL(5,2) DEFAULT 80,
    critical_threshold DECIMAL(5,2) DEFAULT 95,
    
    -- 计费设置
    billing_model VARCHAR(20) DEFAULT 'fixed' CHECK (billing_model IN ('fixed', 'usage', 'tiered')),
    unit_price DECIMAL(10,4) DEFAULT 0,
    currency VARCHAR(3) DEFAULT 'CNY',
    
    -- 状态管理
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'suspended', 'expired')),
    is_enforced BOOLEAN DEFAULT TRUE,
    
    -- 时间设置
    effective_from TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    effective_to TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束和索引
    UNIQUE(tenant_id, quota_type)
);

-- 使用统计表
CREATE TABLE saas_usage_statistics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES saas_tenants(id) ON DELETE CASCADE,
    
    -- 统计信息
    statistic_type VARCHAR(50) NOT NULL,
    statistic_name VARCHAR(100) NOT NULL,
    statistic_period VARCHAR(20) DEFAULT 'daily' CHECK (statistic_period IN ('hourly', 'daily', 'weekly', 'monthly')),
    
    -- 数值统计
    total_count BIGINT DEFAULT 0,
    success_count BIGINT DEFAULT 0,
    failure_count BIGINT DEFAULT 0,
    total_amount DECIMAL(15,4) DEFAULT 0,
    
    -- 时间统计
    period_start TIMESTAMP NOT NULL,
    period_end TIMESTAMP NOT NULL,
    
    -- 扩展数据
    metadata JSONB DEFAULT '{}',
    breakdown JSONB DEFAULT '{}',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 约束和索引
    UNIQUE(tenant_id, statistic_type, statistic_name, period_start)
);

-- 实时配额使用表
CREATE TABLE saas_real_time_quota_usage (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES saas_tenants(id) ON DELETE CASCADE,
    quota_type VARCHAR(50) NOT NULL,
    
    -- 使用统计
    current_usage BIGINT DEFAULT 0,
    peak_usage BIGINT DEFAULT 0,
    last_used_at TIMESTAMP,
    
    -- 限制信息
    max_limit BIGINT DEFAULT 0,
    warning_threshold BIGINT DEFAULT 0,
    critical_threshold BIGINT DEFAULT 0,
    
    -- 状态信息
    is_warning BOOLEAN DEFAULT FALSE,
    is_critical BOOLEAN DEFAULT FALSE,
    is_exceeded BOOLEAN DEFAULT FALSE,
    
    -- 时间信息
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 约束和索引
    UNIQUE(tenant_id, quota_type)
);

-- 4. 系统管理层

-- 统一配置管理表
CREATE TABLE saas_unified_configurations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID REFERENCES saas_tenants(id) ON DELETE CASCADE,
    
    -- 配置信息
    config_key VARCHAR(200) NOT NULL,
    config_value TEXT,
    config_type VARCHAR(20) DEFAULT 'string' CHECK (config_type IN ('string', 'number', 'boolean', 'json', 'yaml')),
    
    -- 配置分类
    category VARCHAR(50),
    sub_category VARCHAR(50),
    module VARCHAR(50),
    
    -- 配置属性
    is_system BOOLEAN DEFAULT FALSE,
    is_sensitive BOOLEAN DEFAULT FALSE,
    is_encrypted BOOLEAN DEFAULT FALSE,
    is_readonly BOOLEAN DEFAULT FALSE,
    
    -- 配置约束
    validation_rules JSONB DEFAULT '{}',
    default_value TEXT,
    allowed_values JSONB DEFAULT '[]',
    
    -- 配置描述
    description TEXT,
    help_text TEXT,
    
    -- 状态管理
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'deprecated')),
    
    -- 版本控制
    version INTEGER DEFAULT 1,
    previous_value TEXT,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束和索引
    UNIQUE(tenant_id, config_key)
);

-- 统一告警管理表
CREATE TABLE saas_unified_alerts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES saas_tenants(id) ON DELETE CASCADE,
    
    -- 告警信息
    alert_type VARCHAR(50) NOT NULL,
    alert_name VARCHAR(100) NOT NULL,
    alert_level VARCHAR(20) DEFAULT 'info' CHECK (alert_level IN ('info', 'warning', 'error', 'critical')),
    
    -- 告警内容
    title VARCHAR(200) NOT NULL,
    message TEXT,
    details JSONB DEFAULT '{}',
    
    -- 告警来源
    source_module VARCHAR(50),
    source_component VARCHAR(50),
    source_id VARCHAR(100),
    
    -- 告警状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'acknowledged', 'resolved', 'dismissed')),
    acknowledged_at TIMESTAMP,
    acknowledged_by UUID REFERENCES saas_users(id),
    resolved_at TIMESTAMP,
    resolved_by UUID REFERENCES saas_users(id),
    
    -- 时间信息
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    
    -- 约束和索引
    CONSTRAINT idx_tenant_status_alert UNIQUE (tenant_id, status)
);

-- 监控规则表
CREATE TABLE saas_monitoring_rules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES saas_tenants(id) ON DELETE CASCADE,
    
    -- 规则信息
    rule_name VARCHAR(100) NOT NULL,
    rule_type VARCHAR(50) NOT NULL,
    rule_description TEXT,
    
    -- 规则配置
    rule_config JSONB NOT NULL,
    threshold_config JSONB DEFAULT '{}',
    action_config JSONB DEFAULT '{}',
    
    -- 规则状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'draft')),
    is_enabled BOOLEAN DEFAULT TRUE,
    
    -- 执行信息
    last_executed_at TIMESTAMP,
    execution_count INTEGER DEFAULT 0,
    success_count INTEGER DEFAULT 0,
    failure_count INTEGER DEFAULT 0,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束和索引
    CONSTRAINT idx_tenant_rule UNIQUE (tenant_id, rule_type)
);

-- 系统指标表
CREATE TABLE saas_system_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID REFERENCES saas_tenants(id) ON DELETE CASCADE,
    
    -- 指标信息
    metric_name VARCHAR(100) NOT NULL,
    metric_type VARCHAR(50) NOT NULL,
    metric_value DECIMAL(15,4) NOT NULL,
    metric_unit VARCHAR(20),
    
    -- 指标标签
    labels JSONB DEFAULT '{}',
    tags JSONB DEFAULT '{}',
    
    -- 时间信息
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 约束和索引
    CONSTRAINT idx_tenant_metric UNIQUE (tenant_id, metric_name)
);

-- 健康检查表
CREATE TABLE saas_health_checks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID REFERENCES saas_tenants(id) ON DELETE CASCADE,
    
    -- 检查信息
    check_name VARCHAR(100) NOT NULL,
    check_type VARCHAR(50) NOT NULL,
    check_status VARCHAR(20) NOT NULL CHECK (check_status IN ('healthy', 'warning', 'critical', 'unknown')),
    
    -- 检查结果
    response_time_ms INTEGER,
    error_message TEXT,
    details JSONB DEFAULT '{}',
    
    -- 时间信息
    checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    next_check_at TIMESTAMP,
    
    -- 约束和索引
    CONSTRAINT idx_tenant_check UNIQUE (tenant_id, check_name)
);

-- 消息模板表
CREATE TABLE saas_message_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES saas_tenants(id) ON DELETE CASCADE,
    
    -- 模板信息
    template_code VARCHAR(100) NOT NULL,
    template_name VARCHAR(100) NOT NULL,
    template_type VARCHAR(20) DEFAULT 'email' CHECK (template_type IN ('email', 'sms', 'push', 'webhook', 'in_app')),
    
    -- 模板内容
    subject VARCHAR(200),
    content TEXT NOT NULL,
    content_type VARCHAR(20) DEFAULT 'text' CHECK (content_type IN ('text', 'html', 'markdown')),
    
    -- 模板配置
    variables JSONB DEFAULT '[]',
    conditions JSONB DEFAULT '{}',
    settings JSONB DEFAULT '{}',
    
    -- 状态管理
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'draft')),
    is_system BOOLEAN DEFAULT FALSE,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束和索引
    UNIQUE(tenant_id, template_code)
);

-- 站内通知表
CREATE TABLE saas_internal_notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES saas_tenants(id) ON DELETE CASCADE,
    
    -- 通知信息
    notification_type VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    content_type VARCHAR(20) DEFAULT 'text' CHECK (content_type IN ('text', 'html', 'markdown')),
    
    -- 接收者
    recipient_id UUID REFERENCES saas_users(id),
    recipient_type VARCHAR(20) DEFAULT 'user' CHECK (recipient_type IN ('user', 'role', 'department', 'all')),
    recipient_filter JSONB DEFAULT '{}',
    
    -- 通知状态
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'sent', 'delivered', 'read', 'failed')),
    priority VARCHAR(20) DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
    
    -- 发送信息
    sent_at TIMESTAMP,
    delivered_at TIMESTAMP,
    read_at TIMESTAMP,
    failed_at TIMESTAMP,
    failure_reason TEXT,
    
    -- 扩展数据
    metadata JSONB DEFAULT '{}',
    attachments JSONB DEFAULT '[]',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    
    -- 约束和索引
    CONSTRAINT idx_tenant_recipient UNIQUE (tenant_id, recipient_id)
);

-- 消息发送记录表
CREATE TABLE saas_message_sending_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES saas_tenants(id) ON DELETE CASCADE,
    
    -- 发送信息
    message_type VARCHAR(20) NOT NULL CHECK (message_type IN ('email', 'sms', 'push', 'webhook', 'in_app')),
    template_id UUID REFERENCES saas_message_templates(id),
    recipient_id UUID REFERENCES saas_users(id),
    
    -- 消息内容
    subject VARCHAR(200),
    content TEXT,
    content_type VARCHAR(20) DEFAULT 'text',
    
    -- 发送状态
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'sending', 'sent', 'delivered', 'failed')),
    retry_count INTEGER DEFAULT 0,
    max_retries INTEGER DEFAULT 3,
    
    -- 发送结果
    sent_at TIMESTAMP,
    delivered_at TIMESTAMP,
    failed_at TIMESTAMP,
    failure_reason TEXT,
    error_code VARCHAR(50),
    
    -- 发送配置
    sender_config JSONB DEFAULT '{}',
    delivery_config JSONB DEFAULT '{}',
    
    -- 扩展数据
    metadata JSONB DEFAULT '{}',
    tracking_data JSONB DEFAULT '{}',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    
    -- 约束和索引
    CONSTRAINT idx_tenant_status UNIQUE (tenant_id, status)
);

-- 文件存储表
CREATE TABLE saas_file_storage (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES saas_tenants(id) ON DELETE CASCADE,
    
    -- 文件信息
    file_name VARCHAR(255) NOT NULL,
    original_name VARCHAR(255),
    file_path TEXT NOT NULL,
    file_url TEXT,
    
    -- 文件属性
    file_size BIGINT NOT NULL,
    file_type VARCHAR(100),
    mime_type VARCHAR(100),
    file_hash VARCHAR(64),
    
    -- 存储信息
    storage_provider VARCHAR(20) DEFAULT 'local' CHECK (storage_provider IN ('local', 's3', 'oss', 'cos')),
    storage_bucket VARCHAR(100),
    storage_key VARCHAR(500),
    
    -- 文件状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'deleted', 'archived')),
    is_public BOOLEAN DEFAULT FALSE,
    
    -- 安全信息
    access_control JSONB DEFAULT '{}',
    encryption_info JSONB DEFAULT '{}',
    
    -- 扩展信息
    metadata JSONB DEFAULT '{}',
    tags JSONB DEFAULT '[]',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束和索引
    CONSTRAINT idx_tenant_file UNIQUE (tenant_id, file_name)
);

-- 文件分享表
CREATE TABLE saas_file_sharing (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES saas_tenants(id) ON DELETE CASCADE,
    file_id UUID NOT NULL REFERENCES saas_file_storage(id) ON DELETE CASCADE,
    
    -- 分享信息
    share_code VARCHAR(100) UNIQUE,
    share_name VARCHAR(100),
    share_description TEXT,
    
    -- 分享设置
    is_public BOOLEAN DEFAULT FALSE,
    password_protected BOOLEAN DEFAULT FALSE,
    password_hash VARCHAR(255),
    expires_at TIMESTAMP,
    
    -- 访问控制
    access_count INTEGER DEFAULT 0,
    max_access_count INTEGER,
    allowed_ips JSONB DEFAULT '[]',
    allowed_domains JSONB DEFAULT '[]',
    
    -- 分享状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'expired', 'revoked')),
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束和索引
    CONSTRAINT idx_share_code UNIQUE (share_code)
);

