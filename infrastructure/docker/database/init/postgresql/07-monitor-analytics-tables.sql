-- 监控分析数据库表结构
-- 连接到monitor_analytics数据库

\c monitor_analytics;

-- 1. 监控指标管理

-- 监控指标定义表
CREATE TABLE monitor_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    metric_name VARCHAR(100) NOT NULL,
    metric_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 指标信息
    description TEXT,
    metric_type VARCHAR(50) NOT NULL CHECK (metric_type IN ('counter', 'gauge', 'histogram', 'summary', 'custom')),
    category VARCHAR(50),
    
    -- 指标配置
    metric_config JSONB DEFAULT '{}',
    unit VARCHAR(20),
    data_type VARCHAR(20) DEFAULT 'numeric' CHECK (data_type IN ('numeric', 'string', 'boolean', 'timestamp')),
    
    -- 指标状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'deprecated')),
    is_enabled BOOLEAN DEFAULT TRUE,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, metric_code)
);

-- 监控指标数据表
CREATE TABLE monitor_metric_data (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    metric_id UUID NOT NULL,
    
    -- 指标数据
    metric_value DECIMAL(15,4) NOT NULL,
    metric_labels JSONB DEFAULT '{}',
    metric_tags JSONB DEFAULT '{}',
    
    -- 时间信息
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 2. 告警管理

-- 告警规则表
CREATE TABLE monitor_alert_rules (
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
    
    -- 规则状态
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
CREATE TABLE monitor_alert_events (
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

-- 3. 数据分析

-- 数据分析任务表
CREATE TABLE monitor_analysis_tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    task_name VARCHAR(100) NOT NULL,
    task_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 任务信息
    description TEXT,
    analysis_type VARCHAR(50) NOT NULL CHECK (analysis_type IN ('trend', 'correlation', 'anomaly', 'prediction', 'custom')),
    category VARCHAR(50),
    
    -- 任务配置
    task_config JSONB DEFAULT '{}',
    data_source_config JSONB DEFAULT '{}',
    algorithm_config JSONB DEFAULT '{}',
    
    -- 任务状态
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'running', 'completed', 'failed', 'cancelled')),
    progress_percentage DECIMAL(5,2) DEFAULT 0,
    
    -- 任务结果
    result_data JSONB DEFAULT '{}',
    error_message TEXT,
    analysis_log JSONB DEFAULT '[]',
    
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

-- 分析结果表
CREATE TABLE monitor_analysis_results (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    task_id UUID NOT NULL,
    
    -- 结果信息
    result_type VARCHAR(50) NOT NULL CHECK (result_type IN ('trend', 'correlation', 'anomaly', 'prediction', 'custom')),
    result_data JSONB DEFAULT '{}',
    confidence_score DECIMAL(3,2),
    
    -- 结果状态
    status VARCHAR(20) DEFAULT 'generated' CHECK (status IN ('generated', 'validated', 'archived')),
    is_alerted BOOLEAN DEFAULT FALSE,
    
    -- 时间信息
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    validated_at TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 4. 趋势分析

-- 趋势分析表
CREATE TABLE monitor_trend_analysis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    metric_id UUID NOT NULL,
    
    -- 趋势信息
    trend_type VARCHAR(50) NOT NULL CHECK (trend_type IN ('increasing', 'decreasing', 'stable', 'fluctuating')),
    trend_period VARCHAR(20) DEFAULT 'daily' CHECK (trend_period IN ('hourly', 'daily', 'weekly', 'monthly')),
    
    -- 趋势数据
    trend_data JSONB DEFAULT '{}',
    slope_value DECIMAL(10,4),
    correlation_coefficient DECIMAL(5,4),
    
    -- 预测信息
    prediction_data JSONB DEFAULT '{}',
    confidence_interval JSONB DEFAULT '{}',
    
    -- 时间信息
    analysis_start TIMESTAMP NOT NULL,
    analysis_end TIMESTAMP NOT NULL,
    next_analysis_at TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 5. 异常检测

-- 异常检测表
CREATE TABLE monitor_anomaly_detection (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    metric_id UUID NOT NULL,
    
    -- 异常信息
    anomaly_type VARCHAR(50) NOT NULL CHECK (anomaly_type IN ('spike', 'drop', 'trend_change', 'seasonal', 'custom')),
    anomaly_score DECIMAL(5,4) NOT NULL,
    severity_level VARCHAR(20) NOT NULL CHECK (severity_level IN ('low', 'medium', 'high', 'critical')),
    
    -- 异常详情
    anomaly_data JSONB DEFAULT '{}',
    baseline_data JSONB DEFAULT '{}',
    context_data JSONB DEFAULT '{}',
    
    -- 异常状态
    status VARCHAR(20) DEFAULT 'detected' CHECK (status IN ('detected', 'investigating', 'resolved', 'false_positive')),
    is_alerted BOOLEAN DEFAULT FALSE,
    
    -- 时间信息
    detected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 6. 性能基准

-- 性能基准表
CREATE TABLE monitor_performance_baselines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    metric_id UUID NOT NULL,
    
    -- 基准信息
    baseline_name VARCHAR(100) NOT NULL,
    baseline_type VARCHAR(50) NOT NULL CHECK (baseline_type IN ('average', 'percentile', 'custom')),
    baseline_period VARCHAR(20) DEFAULT 'daily' CHECK (baseline_period IN ('hourly', 'daily', 'weekly', 'monthly')),
    
    -- 基准值
    baseline_value DECIMAL(15,4) NOT NULL,
    min_value DECIMAL(15,4),
    max_value DECIMAL(15,4),
    standard_deviation DECIMAL(15,4),
    
    -- 基准配置
    baseline_config JSONB DEFAULT '{}',
    calculation_method VARCHAR(50) DEFAULT 'mean' CHECK (calculation_method IN ('mean', 'median', 'percentile', 'custom')),
    
    -- 基准状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'deprecated')),
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, metric_id, baseline_name)
);

-- 7. 监控仪表板

-- 仪表板定义表
CREATE TABLE monitor_dashboards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    dashboard_name VARCHAR(100) NOT NULL,
    dashboard_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 仪表板信息
    description TEXT,
    dashboard_type VARCHAR(50) DEFAULT 'operational' CHECK (dashboard_type IN ('operational', 'analytical', 'executive', 'custom')),
    category VARCHAR(50),
    
    -- 仪表板配置
    layout_config JSONB DEFAULT '{}',
    widget_config JSONB DEFAULT '[]',
    refresh_config JSONB DEFAULT '{}',
    
    -- 仪表板状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'draft', 'archived')),
    is_public BOOLEAN DEFAULT FALSE,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, dashboard_code)
);

-- 仪表板组件表
CREATE TABLE monitor_dashboard_widgets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    dashboard_id UUID NOT NULL,
    
    -- 组件信息
    widget_name VARCHAR(100) NOT NULL,
    widget_type VARCHAR(50) NOT NULL CHECK (widget_type IN ('chart', 'metric', 'table', 'alert', 'custom')),
    widget_position JSONB DEFAULT '{}',
    
    -- 组件配置
    widget_config JSONB DEFAULT '{}',
    data_source_config JSONB DEFAULT '{}',
    display_config JSONB DEFAULT '{}',
    
    -- 组件状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'hidden')),
    sort_order INTEGER DEFAULT 0,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 8. 监控报告

-- 监控报告表
CREATE TABLE monitor_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    report_name VARCHAR(100) NOT NULL,
    report_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 报告信息
    description TEXT,
    report_type VARCHAR(50) DEFAULT 'daily' CHECK (report_type IN ('hourly', 'daily', 'weekly', 'monthly', 'custom')),
    report_period VARCHAR(20) DEFAULT 'daily' CHECK (report_period IN ('hourly', 'daily', 'weekly', 'monthly')),
    
    -- 报告配置
    report_config JSONB DEFAULT '{}',
    template_config JSONB DEFAULT '{}',
    schedule_config JSONB DEFAULT '{}',
    
    -- 报告状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'draft', 'archived')),
    is_scheduled BOOLEAN DEFAULT FALSE,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, report_code)
);

-- 报告执行记录表
CREATE TABLE monitor_report_executions (
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

-- 9. 监控统计

-- 监控使用统计表
CREATE TABLE monitor_usage_statistics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    
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

-- 创建触发器函数来更新updated_at字段
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 为所有表添加updated_at触发器
CREATE TRIGGER update_monitor_metrics_updated_at BEFORE UPDATE ON monitor_metrics FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_monitor_metric_data_updated_at BEFORE UPDATE ON monitor_metric_data FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_monitor_alert_rules_updated_at BEFORE UPDATE ON monitor_alert_rules FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_monitor_alert_events_updated_at BEFORE UPDATE ON monitor_alert_events FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_monitor_analysis_tasks_updated_at BEFORE UPDATE ON monitor_analysis_tasks FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_monitor_analysis_results_updated_at BEFORE UPDATE ON monitor_analysis_results FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_monitor_trend_analysis_updated_at BEFORE UPDATE ON monitor_trend_analysis FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_monitor_anomaly_detection_updated_at BEFORE UPDATE ON monitor_anomaly_detection FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_monitor_performance_baselines_updated_at BEFORE UPDATE ON monitor_performance_baselines FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_monitor_dashboards_updated_at BEFORE UPDATE ON monitor_dashboards FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_monitor_dashboard_widgets_updated_at BEFORE UPDATE ON monitor_dashboard_widgets FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_monitor_reports_updated_at BEFORE UPDATE ON monitor_reports FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_monitor_report_executions_updated_at BEFORE UPDATE ON monitor_report_executions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_monitor_usage_statistics_updated_at BEFORE UPDATE ON monitor_usage_statistics FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
