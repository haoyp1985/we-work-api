-- 健康管理数据库表结构
-- 连接到health_management数据库

\c health_management;

-- 1. 健康检查管理

-- 健康检查配置表
CREATE TABLE health_check_configs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    check_name VARCHAR(100) NOT NULL,
    check_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 检查信息
    description TEXT,
    check_type VARCHAR(50) NOT NULL CHECK (check_type IN ('http', 'tcp', 'ping', 'database', 'redis', 'custom')),
    category VARCHAR(50),
    
    -- 检查配置
    check_config JSONB DEFAULT '{}',
    endpoint_url TEXT,
    timeout_seconds INTEGER DEFAULT 30,
    retry_count INTEGER DEFAULT 3,
    
    -- 阈值配置
    warning_threshold INTEGER DEFAULT 1000,
    critical_threshold INTEGER DEFAULT 5000,
    success_threshold INTEGER DEFAULT 200,
    
    -- 状态管理
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'maintenance')),
    is_enabled BOOLEAN DEFAULT TRUE,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, check_code)
);

-- 健康检查结果表
CREATE TABLE health_check_results (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    check_id UUID NOT NULL,
    
    -- 检查结果
    check_status VARCHAR(20) NOT NULL CHECK (check_status IN ('healthy', 'warning', 'critical', 'unknown')),
    response_time_ms INTEGER,
    status_code INTEGER,
    error_message TEXT,
    
    -- 结果详情
    result_data JSONB DEFAULT '{}',
    metrics JSONB DEFAULT '{}',
    
    -- 时间信息
    checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    next_check_at TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 2. 服务监控

-- 服务监控配置表
CREATE TABLE service_monitor_configs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    service_name VARCHAR(100) NOT NULL,
    service_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 服务信息
    description TEXT,
    service_type VARCHAR(50) NOT NULL CHECK (service_type IN ('api', 'database', 'cache', 'queue', 'storage', 'custom')),
    category VARCHAR(50),
    
    -- 监控配置
    monitor_config JSONB DEFAULT '{}',
    health_check_url TEXT,
    metrics_endpoint TEXT,
    
    -- 告警配置
    alert_config JSONB DEFAULT '{}',
    notification_channels JSONB DEFAULT '[]',
    
    -- 状态管理
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'maintenance')),
    is_enabled BOOLEAN DEFAULT TRUE,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, service_code)
);

-- 服务监控指标表
CREATE TABLE service_monitor_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    service_id UUID NOT NULL,
    
    -- 指标信息
    metric_name VARCHAR(100) NOT NULL,
    metric_type VARCHAR(50) NOT NULL CHECK (metric_type IN ('cpu', 'memory', 'disk', 'network', 'response_time', 'throughput', 'error_rate', 'custom')),
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

-- 3. 告警管理

-- 告警规则表
CREATE TABLE alert_rules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    rule_name VARCHAR(100) NOT NULL,
    rule_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 规则信息
    description TEXT,
    rule_type VARCHAR(50) NOT NULL CHECK (rule_type IN ('threshold', 'trend', 'anomaly', 'custom')),
    category VARCHAR(50),
    
    -- 规则配置
    rule_config JSONB DEFAULT '{}',
    condition_config JSONB DEFAULT '{}',
    action_config JSONB DEFAULT '{}',
    
    -- 阈值配置
    warning_threshold DECIMAL(15,4),
    critical_threshold DECIMAL(15,4),
    duration_minutes INTEGER DEFAULT 5,
    
    -- 状态管理
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'draft')),
    is_enabled BOOLEAN DEFAULT TRUE,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, rule_code)
);

-- 告警事件表
CREATE TABLE alert_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    rule_id UUID NOT NULL,
    
    -- 事件信息
    event_type VARCHAR(50) NOT NULL CHECK (event_type IN ('warning', 'critical', 'resolved', 'acknowledged')),
    alert_level VARCHAR(20) NOT NULL CHECK (alert_level IN ('info', 'warning', 'error', 'critical')),
    
    -- 事件内容
    title VARCHAR(200) NOT NULL,
    message TEXT,
    details JSONB DEFAULT '{}',
    
    -- 事件状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'acknowledged', 'resolved', 'dismissed')),
    acknowledged_at TIMESTAMP,
    acknowledged_by UUID,
    resolved_at TIMESTAMP,
    resolved_by UUID,
    
    -- 时间信息
    triggered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 4. 日志管理

-- 系统日志表
CREATE TABLE system_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    
    -- 日志信息
    log_level VARCHAR(20) NOT NULL CHECK (log_level IN ('debug', 'info', 'warning', 'error', 'critical')),
    log_source VARCHAR(100) NOT NULL,
    log_message TEXT NOT NULL,
    
    -- 日志详情
    log_data JSONB DEFAULT '{}',
    stack_trace TEXT,
    context_data JSONB DEFAULT '{}',
    
    -- 环境信息
    host_name VARCHAR(100),
    process_id INTEGER,
    thread_id VARCHAR(50),
    request_id VARCHAR(100),
    
    -- 时间信息
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 应用日志表
CREATE TABLE application_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    
    -- 日志信息
    log_level VARCHAR(20) NOT NULL CHECK (log_level IN ('debug', 'info', 'warning', 'error', 'critical')),
    logger_name VARCHAR(200) NOT NULL,
    log_message TEXT NOT NULL,
    
    -- 日志详情
    log_data JSONB DEFAULT '{}',
    exception_info JSONB DEFAULT '{}',
    context_data JSONB DEFAULT '{}',
    
    -- 应用信息
    application_name VARCHAR(100),
    service_name VARCHAR(100),
    version VARCHAR(20),
    
    -- 用户信息
    user_id UUID,
    session_id VARCHAR(100),
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

-- 5. 性能监控

-- 性能指标表
CREATE TABLE performance_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    
    -- 指标信息
    metric_name VARCHAR(100) NOT NULL,
    metric_type VARCHAR(50) NOT NULL CHECK (metric_type IN ('cpu', 'memory', 'disk', 'network', 'response_time', 'throughput', 'error_rate', 'custom')),
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

-- 性能基准表
CREATE TABLE performance_baselines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    
    -- 基准信息
    baseline_name VARCHAR(100) NOT NULL,
    metric_name VARCHAR(100) NOT NULL,
    baseline_type VARCHAR(50) NOT NULL CHECK (baseline_type IN ('average', 'percentile', 'custom')),
    
    -- 基准值
    baseline_value DECIMAL(15,4) NOT NULL,
    min_value DECIMAL(15,4),
    max_value DECIMAL(15,4),
    
    -- 基准配置
    baseline_config JSONB DEFAULT '{}',
    calculation_period VARCHAR(20) DEFAULT 'daily' CHECK (calculation_period IN ('hourly', 'daily', 'weekly', 'monthly')),
    
    -- 状态管理
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'deprecated')),
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, baseline_name, metric_name)
);

-- 6. 资源监控

-- 资源使用统计表
CREATE TABLE resource_usage_statistics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    
    -- 统计信息
    resource_type VARCHAR(50) NOT NULL CHECK (resource_type IN ('cpu', 'memory', 'disk', 'network', 'database', 'cache', 'custom')),
    statistic_name VARCHAR(100) NOT NULL,
    statistic_period VARCHAR(20) DEFAULT 'daily' CHECK (statistic_period IN ('hourly', 'daily', 'weekly', 'monthly')),
    
    -- 数值统计
    total_usage DECIMAL(15,4) DEFAULT 0,
    peak_usage DECIMAL(15,4) DEFAULT 0,
    average_usage DECIMAL(15,4) DEFAULT 0,
    usage_count INTEGER DEFAULT 0,
    
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
    UNIQUE(tenant_id, resource_type, statistic_name, period_start)
);

-- 资源告警表
CREATE TABLE resource_alerts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    
    -- 告警信息
    resource_type VARCHAR(50) NOT NULL,
    alert_type VARCHAR(50) NOT NULL CHECK (alert_type IN ('usage_high', 'usage_critical', 'performance_degraded', 'custom')),
    alert_level VARCHAR(20) NOT NULL CHECK (alert_level IN ('info', 'warning', 'error', 'critical')),
    
    -- 告警内容
    title VARCHAR(200) NOT NULL,
    message TEXT,
    details JSONB DEFAULT '{}',
    
    -- 告警状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'acknowledged', 'resolved', 'dismissed')),
    acknowledged_at TIMESTAMP,
    acknowledged_by UUID,
    resolved_at TIMESTAMP,
    resolved_by UUID,
    
    -- 时间信息
    triggered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 7. 健康报告

-- 健康报告表
CREATE TABLE health_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    
    -- 报告信息
    report_name VARCHAR(100) NOT NULL,
    report_type VARCHAR(50) NOT NULL CHECK (report_type IN ('daily', 'weekly', 'monthly', 'custom')),
    report_period VARCHAR(20) DEFAULT 'daily' CHECK (report_period IN ('hourly', 'daily', 'weekly', 'monthly')),
    
    -- 报告内容
    summary JSONB DEFAULT '{}',
    details JSONB DEFAULT '{}',
    recommendations JSONB DEFAULT '[]',
    
    -- 报告状态
    status VARCHAR(20) DEFAULT 'generated' CHECK (status IN ('generating', 'generated', 'sent', 'archived')),
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sent_at TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, report_name, report_period, generated_at)
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
CREATE TRIGGER update_health_check_configs_updated_at BEFORE UPDATE ON health_check_configs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_health_check_results_updated_at BEFORE UPDATE ON health_check_results FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_service_monitor_configs_updated_at BEFORE UPDATE ON service_monitor_configs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_service_monitor_metrics_updated_at BEFORE UPDATE ON service_monitor_metrics FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_alert_rules_updated_at BEFORE UPDATE ON alert_rules FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_alert_events_updated_at BEFORE UPDATE ON alert_events FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_system_logs_updated_at BEFORE UPDATE ON system_logs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_application_logs_updated_at BEFORE UPDATE ON application_logs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_performance_metrics_updated_at BEFORE UPDATE ON performance_metrics FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_performance_baselines_updated_at BEFORE UPDATE ON performance_baselines FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_resource_usage_statistics_updated_at BEFORE UPDATE ON resource_usage_statistics FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_resource_alerts_updated_at BEFORE UPDATE ON resource_alerts FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_health_reports_updated_at BEFORE UPDATE ON health_reports FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
