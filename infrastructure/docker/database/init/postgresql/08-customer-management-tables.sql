-- 客户管理数据库表结构
-- 连接到customer_management数据库

\c customer_management;

-- 1. 客户信息管理

-- 客户主表
CREATE TABLE customer_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    customer_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 客户基本信息
    customer_name VARCHAR(200) NOT NULL,
    customer_type VARCHAR(50) DEFAULT 'individual' CHECK (customer_type IN ('individual', 'company', 'organization')),
    industry VARCHAR(100),
    company_size VARCHAR(50),
    
    -- 联系信息
    contact_person VARCHAR(100),
    contact_phone VARCHAR(20),
    contact_email VARCHAR(100),
    website VARCHAR(200),
    
    -- 地址信息
    address_line1 VARCHAR(200),
    address_line2 VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    
    -- 客户状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'prospect', 'lead', 'archived')),
    customer_level VARCHAR(20) DEFAULT 'standard' CHECK (customer_level IN ('standard', 'premium', 'vip', 'enterprise')),
    
    -- 客户配置
    customer_config JSONB DEFAULT '{}',
    preferences JSONB DEFAULT '{}',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, customer_code)
);

-- 客户联系人表
CREATE TABLE customer_contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    customer_id UUID NOT NULL,
    
    -- 联系人信息
    contact_name VARCHAR(100) NOT NULL,
    contact_title VARCHAR(100),
    contact_type VARCHAR(50) DEFAULT 'primary' CHECK (contact_type IN ('primary', 'secondary', 'technical', 'billing', 'decision_maker')),
    
    -- 联系信息
    phone VARCHAR(20),
    mobile VARCHAR(20),
    email VARCHAR(100),
    wechat_id VARCHAR(100),
    
    -- 联系人状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'left')),
    is_primary BOOLEAN DEFAULT FALSE,
    
    -- 联系人配置
    contact_config JSONB DEFAULT '{}',
    communication_preferences JSONB DEFAULT '{}',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 2. 客户关系管理

-- 客户关系表
CREATE TABLE customer_relationships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    customer_id UUID NOT NULL,
    
    -- 关系信息
    relationship_type VARCHAR(50) DEFAULT 'customer' CHECK (relationship_type IN ('customer', 'partner', 'supplier', 'competitor', 'prospect')),
    relationship_status VARCHAR(20) DEFAULT 'active' CHECK (relationship_status IN ('active', 'inactive', 'suspended', 'terminated')),
    
    -- 关系详情
    relationship_start_date DATE,
    relationship_end_date DATE,
    relationship_score DECIMAL(3,2) DEFAULT 0,
    
    -- 关系配置
    relationship_config JSONB DEFAULT '{}',
    interaction_history JSONB DEFAULT '[]',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 客户互动记录表
CREATE TABLE customer_interactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    customer_id UUID NOT NULL,
    
    -- 互动信息
    interaction_type VARCHAR(50) NOT NULL CHECK (interaction_type IN ('call', 'email', 'meeting', 'visit', 'social_media', 'support', 'custom')),
    interaction_subject VARCHAR(200),
    interaction_content TEXT,
    
    -- 互动详情
    interaction_duration INTEGER, -- 分钟
    interaction_result VARCHAR(50),
    follow_up_required BOOLEAN DEFAULT FALSE,
    follow_up_date DATE,
    
    -- 互动状态
    status VARCHAR(20) DEFAULT 'completed' CHECK (status IN ('scheduled', 'in_progress', 'completed', 'cancelled')),
    
    -- 时间信息
    scheduled_at TIMESTAMP,
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 3. 客户服务管理

-- 客户服务请求表
CREATE TABLE customer_service_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    customer_id UUID NOT NULL,
    
    -- 请求信息
    request_title VARCHAR(200) NOT NULL,
    request_type VARCHAR(50) NOT NULL CHECK (request_type IN ('support', 'inquiry', 'complaint', 'suggestion', 'feature_request', 'custom')),
    request_priority VARCHAR(20) DEFAULT 'medium' CHECK (request_priority IN ('low', 'medium', 'high', 'urgent')),
    
    -- 请求详情
    request_description TEXT,
    request_category VARCHAR(100),
    request_tags JSONB DEFAULT '[]',
    
    -- 请求状态
    status VARCHAR(20) DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'pending', 'resolved', 'closed')),
    assigned_to UUID,
    
    -- 时间信息
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    due_date TIMESTAMP,
    resolved_at TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 服务请求回复表
CREATE TABLE customer_service_replies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    request_id UUID NOT NULL,
    
    -- 回复信息
    reply_content TEXT NOT NULL,
    reply_type VARCHAR(20) DEFAULT 'response' CHECK (reply_type IN ('response', 'internal_note', 'status_update')),
    
    -- 回复详情
    is_internal BOOLEAN DEFAULT FALSE,
    is_public BOOLEAN DEFAULT TRUE,
    
    -- 时间信息
    replied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 4. 客户满意度管理

-- 客户满意度调查表
CREATE TABLE customer_satisfaction_surveys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    customer_id UUID NOT NULL,
    
    -- 调查信息
    survey_title VARCHAR(200) NOT NULL,
    survey_type VARCHAR(50) DEFAULT 'satisfaction' CHECK (survey_type IN ('satisfaction', 'feedback', 'nps', 'custom')),
    survey_period VARCHAR(20) DEFAULT 'quarterly' CHECK (survey_period IN ('monthly', 'quarterly', 'yearly', 'on_demand')),
    
    -- 调查配置
    survey_config JSONB DEFAULT '{}',
    questions JSONB DEFAULT '[]',
    
    -- 调查状态
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'active', 'completed', 'archived')),
    response_rate DECIMAL(5,2) DEFAULT 0,
    
    -- 时间信息
    survey_start_date DATE,
    survey_end_date DATE,
    sent_at TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 客户满意度回复表
CREATE TABLE customer_satisfaction_responses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    survey_id UUID NOT NULL,
    customer_id UUID NOT NULL,
    
    -- 回复信息
    response_data JSONB DEFAULT '{}',
    overall_score INTEGER CHECK (overall_score >= 1 AND overall_score <= 10),
    nps_score INTEGER CHECK (nps_score >= 0 AND nps_score <= 10),
    
    -- 回复详情
    feedback_text TEXT,
    improvement_suggestions TEXT,
    
    -- 回复状态
    status VARCHAR(20) DEFAULT 'submitted' CHECK (status IN ('submitted', 'reviewed', 'processed')),
    
    -- 时间信息
    responded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_at TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 5. 客户分析管理

-- 客户分析表
CREATE TABLE customer_analytics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    customer_id UUID NOT NULL,
    
    -- 分析信息
    analysis_type VARCHAR(50) NOT NULL CHECK (analysis_type IN ('behavior', 'preference', 'satisfaction', 'lifetime_value', 'custom')),
    analysis_period VARCHAR(20) DEFAULT 'monthly' CHECK (analysis_period IN ('daily', 'weekly', 'monthly', 'quarterly', 'yearly')),
    
    -- 分析数据
    analysis_data JSONB DEFAULT '{}',
    metrics JSONB DEFAULT '{}',
    insights JSONB DEFAULT '[]',
    
    -- 分析状态
    status VARCHAR(20) DEFAULT 'generated' CHECK (status IN ('generated', 'reviewed', 'actioned')),
    
    -- 时间信息
    analysis_date DATE NOT NULL,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 客户行为分析表
CREATE TABLE customer_behavior_analysis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    customer_id UUID NOT NULL,
    
    -- 行为信息
    behavior_type VARCHAR(50) NOT NULL CHECK (behavior_type IN ('purchase', 'interaction', 'support', 'feedback', 'custom')),
    behavior_pattern VARCHAR(100),
    behavior_frequency INTEGER DEFAULT 0,
    
    -- 行为数据
    behavior_data JSONB DEFAULT '{}',
    context_data JSONB DEFAULT '{}',
    
    -- 行为状态
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'changed')),
    
    -- 时间信息
    first_occurrence TIMESTAMP,
    last_occurrence TIMESTAMP,
    analysis_date DATE,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 6. 客户营销管理

-- 客户营销活动表
CREATE TABLE customer_marketing_campaigns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    campaign_name VARCHAR(200) NOT NULL,
    campaign_code VARCHAR(50) UNIQUE NOT NULL,
    
    -- 活动信息
    description TEXT,
    campaign_type VARCHAR(50) NOT NULL CHECK (campaign_type IN ('email', 'sms', 'social_media', 'direct_mail', 'event', 'custom')),
    campaign_category VARCHAR(50),
    
    -- 活动配置
    campaign_config JSONB DEFAULT '{}',
    target_audience JSONB DEFAULT '{}',
    content_config JSONB DEFAULT '{}',
    
    -- 活动状态
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'active', 'paused', 'completed', 'cancelled')),
    is_scheduled BOOLEAN DEFAULT FALSE,
    
    -- 时间信息
    start_date DATE,
    end_date DATE,
    scheduled_at TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    
    -- 约束
    UNIQUE(tenant_id, campaign_code)
);

-- 客户营销活动执行表
CREATE TABLE customer_marketing_campaign_executions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    campaign_id UUID NOT NULL,
    customer_id UUID NOT NULL,
    
    -- 执行信息
    execution_type VARCHAR(50) DEFAULT 'send' CHECK (execution_type IN ('send', 'open', 'click', 'bounce', 'unsubscribe')),
    execution_status VARCHAR(20) DEFAULT 'pending' CHECK (execution_status IN ('pending', 'sent', 'delivered', 'failed', 'bounced')),
    
    -- 执行详情
    execution_data JSONB DEFAULT '{}',
    delivery_data JSONB DEFAULT '{}',
    error_message TEXT,
    
    -- 时间信息
    scheduled_at TIMESTAMP,
    sent_at TIMESTAMP,
    delivered_at TIMESTAMP,
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- 7. 客户统计管理

-- 客户使用统计表
CREATE TABLE customer_usage_statistics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    customer_id UUID NOT NULL,
    
    -- 统计信息
    statistic_type VARCHAR(50) NOT NULL,
    statistic_name VARCHAR(100) NOT NULL,
    statistic_period VARCHAR(20) DEFAULT 'daily' CHECK (statistic_period IN ('hourly', 'daily', 'weekly', 'monthly')),
    
    -- 数值统计
    total_count BIGINT DEFAULT 0,
    success_count BIGINT DEFAULT 0,
    failure_count BIGINT DEFAULT 0,
    total_value DECIMAL(15,4) DEFAULT 0,
    
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
    UNIQUE(tenant_id, customer_id, statistic_type, statistic_name, period_start)
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
CREATE TRIGGER update_customer_profiles_updated_at BEFORE UPDATE ON customer_profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_customer_contacts_updated_at BEFORE UPDATE ON customer_contacts FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_customer_relationships_updated_at BEFORE UPDATE ON customer_relationships FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_customer_interactions_updated_at BEFORE UPDATE ON customer_interactions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_customer_service_requests_updated_at BEFORE UPDATE ON customer_service_requests FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_customer_service_replies_updated_at BEFORE UPDATE ON customer_service_replies FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_customer_satisfaction_surveys_updated_at BEFORE UPDATE ON customer_satisfaction_surveys FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_customer_satisfaction_responses_updated_at BEFORE UPDATE ON customer_satisfaction_responses FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_customer_analytics_updated_at BEFORE UPDATE ON customer_analytics FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_customer_behavior_analysis_updated_at BEFORE UPDATE ON customer_behavior_analysis FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_customer_marketing_campaigns_updated_at BEFORE UPDATE ON customer_marketing_campaigns FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_customer_marketing_campaign_executions_updated_at BEFORE UPDATE ON customer_marketing_campaign_executions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_customer_usage_statistics_updated_at BEFORE UPDATE ON customer_usage_statistics FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
