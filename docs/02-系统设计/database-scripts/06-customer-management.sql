-- =====================================================
-- 客户管理平台数据库设计
-- 包含：客户服务、标签服务、分群服务、行为服务
-- =====================================================

-- 创建客户管理平台数据库
CREATE DATABASE IF NOT EXISTS `customer_management` 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `customer_management`;

-- =====================================================
-- 1. 客户档案层 (Customer Service)
-- =====================================================

-- 客户主表
CREATE TABLE customers (
    id VARCHAR(36) PRIMARY KEY COMMENT '客户ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 客户基本信息
    customer_code VARCHAR(50) NOT NULL COMMENT '客户编码',
    customer_type ENUM('individual', 'enterprise', 'vip', 'potential', 'partner') DEFAULT 'individual' COMMENT '客户类型',
    
    -- 身份信息
    name VARCHAR(100) NOT NULL COMMENT '客户姓名/企业名称',
    nickname VARCHAR(100) COMMENT '昵称',
    avatar_url VARCHAR(500) COMMENT '头像URL',
    gender ENUM('male', 'female', 'unknown') DEFAULT 'unknown' COMMENT '性别',
    birth_date DATE COMMENT '出生日期',
    age INT GENERATED ALWAYS AS (TIMESTAMPDIFF(YEAR, birth_date, CURDATE())) STORED COMMENT '年龄',
    
    -- 联系方式
    phone VARCHAR(20) COMMENT '手机号',
    email VARCHAR(100) COMMENT '邮箱',
    wechat_id VARCHAR(100) COMMENT '微信号',
    wework_external_id VARCHAR(100) COMMENT '企微外部联系人ID',
    qq VARCHAR(20) COMMENT 'QQ号',
    
    -- 地址信息
    address JSON COMMENT '地址信息 {province, city, district, detail, postal_code}',
    location JSON COMMENT '地理位置 {latitude, longitude}',
    
    -- 企业信息 (企业客户)
    company_name VARCHAR(200) COMMENT '公司名称',
    company_size ENUM('startup', 'small', 'medium', 'large', 'enterprise') COMMENT '公司规模',
    industry VARCHAR(100) COMMENT '所属行业',
    position VARCHAR(100) COMMENT '职位',
    company_address JSON COMMENT '公司地址',
    
    -- 客户来源
    source_channel ENUM('wework', 'website', 'app', 'referral', 'advertising', 'offline', 'import') NOT NULL COMMENT '来源渠道',
    source_detail VARCHAR(200) COMMENT '来源详情',
    referrer_id VARCHAR(36) COMMENT '推荐人ID',
    utm_source VARCHAR(100) COMMENT 'UTM来源',
    utm_medium VARCHAR(100) COMMENT 'UTM媒介',
    utm_campaign VARCHAR(100) COMMENT 'UTM活动',
    
    -- 客户状态
    status ENUM('active', 'inactive', 'potential', 'lost', 'blacklist') DEFAULT 'potential' COMMENT '客户状态',
    lifecycle_stage ENUM('lead', 'prospect', 'customer', 'advocate', 'inactive') DEFAULT 'lead' COMMENT '生命周期阶段',
    
    -- 客户等级
    level ENUM('bronze', 'silver', 'gold', 'platinum', 'diamond') DEFAULT 'bronze' COMMENT '客户等级',
    vip_level INT DEFAULT 0 COMMENT 'VIP等级',
    credit_score INT DEFAULT 0 COMMENT '信用评分',
    
    -- 偏好设置
    communication_preferences JSON COMMENT '沟通偏好 {email, sms, phone, wework}',
    product_preferences JSON COMMENT '产品偏好',
    service_preferences JSON COMMENT '服务偏好',
    
    -- 关系管理
    assigned_sales_id VARCHAR(36) COMMENT '分配销售ID',
    assigned_service_id VARCHAR(36) COMMENT '分配客服ID',
    relationship_level ENUM('stranger', 'acquaintance', 'friend', 'partner', 'advocate') DEFAULT 'stranger' COMMENT '关系等级',
    
    -- 统计信息 (生命周期跟踪)
    total_orders INT DEFAULT 0 COMMENT '总订单数',
    total_amount DECIMAL(15,2) DEFAULT 0 COMMENT '总消费金额',
    avg_order_amount DECIMAL(10,2) DEFAULT 0 COMMENT '平均订单金额',
    last_order_amount DECIMAL(10,2) DEFAULT 0 COMMENT '最后订单金额',
    first_order_date DATE COMMENT '首次下单日期',
    last_order_date DATE COMMENT '最后下单日期',
    
    -- 行为统计
    total_visits INT DEFAULT 0 COMMENT '总访问次数',
    total_page_views INT DEFAULT 0 COMMENT '总页面浏览量',
    last_visit_date DATE COMMENT '最后访问日期',
    interaction_count INT DEFAULT 0 COMMENT '互动次数',
    last_interaction_date DATE COMMENT '最后互动日期',
    
    -- 满意度评价
    satisfaction_score DECIMAL(3,2) DEFAULT 0 COMMENT '满意度评分',
    nps_score INT COMMENT 'NPS评分',
    
    -- 时间管理
    first_contact_date TIMESTAMP COMMENT '首次接触时间',
    last_contact_date TIMESTAMP COMMENT '最后接触时间',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    
    -- 唯一约束
    UNIQUE KEY uk_tenant_customer_code (tenant_id, customer_code),
    UNIQUE KEY uk_tenant_phone (tenant_id, phone),
    UNIQUE KEY uk_tenant_email (tenant_id, email),
    
    -- 索引设计
    INDEX idx_customer_type (customer_type),
    INDEX idx_name (name),
    INDEX idx_phone (phone),
    INDEX idx_email (email),
    INDEX idx_source_channel (source_channel),
    INDEX idx_status (status),
    INDEX idx_lifecycle_stage (lifecycle_stage),
    INDEX idx_level (level),
    INDEX idx_assigned_sales (assigned_sales_id),
    INDEX idx_total_amount (total_amount),
    INDEX idx_last_order_date (last_order_date),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客户主表';

-- 客户联系人表 (企业客户的多个联系人)
CREATE TABLE customer_contacts (
    id VARCHAR(36) PRIMARY KEY COMMENT '联系人ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    customer_id VARCHAR(36) NOT NULL COMMENT '客户ID',
    
    -- 联系人信息
    contact_name VARCHAR(100) NOT NULL COMMENT '联系人姓名',
    position VARCHAR(100) COMMENT '职位',
    department VARCHAR(100) COMMENT '部门',
    phone VARCHAR(20) COMMENT '手机号',
    email VARCHAR(100) COMMENT '邮箱',
    
    -- 联系人类型
    contact_type ENUM('primary', 'decision_maker', 'influencer', 'user', 'other') DEFAULT 'other' COMMENT '联系人类型',
    is_primary BOOLEAN DEFAULT FALSE COMMENT '是否主要联系人',
    
    -- 状态管理
    status ENUM('active', 'inactive', 'left') DEFAULT 'active' COMMENT '状态',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX idx_tenant_customer (tenant_id, customer_id),
    INDEX idx_contact_type (contact_type),
    INDEX idx_is_primary (is_primary),
    INDEX idx_phone (phone),
    INDEX idx_email (email),
    
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客户联系人表';

-- 客户生命周期记录表
CREATE TABLE customer_lifecycle_history (
    id VARCHAR(36) PRIMARY KEY COMMENT '记录ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    customer_id VARCHAR(36) NOT NULL COMMENT '客户ID',
    
    -- 生命周期变更
    old_stage ENUM('lead', 'prospect', 'customer', 'advocate', 'inactive') COMMENT '旧阶段',
    new_stage ENUM('lead', 'prospect', 'customer', 'advocate', 'inactive') NOT NULL COMMENT '新阶段',
    change_reason VARCHAR(500) COMMENT '变更原因',
    trigger_event VARCHAR(200) COMMENT '触发事件',
    
    -- 阶段数据
    stage_data JSON COMMENT '阶段数据',
    stage_duration_days INT COMMENT '在上一阶段的天数',
    
    -- 变更信息
    operator_id VARCHAR(36) COMMENT '操作人ID',
    operator_type ENUM('system', 'manual', 'rule', 'event') DEFAULT 'system' COMMENT '操作类型',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX idx_tenant_customer (tenant_id, customer_id),
    INDEX idx_customer_time (customer_id, created_at),
    INDEX idx_stage_change (old_stage, new_stage),
    INDEX idx_trigger_event (trigger_event),
    
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客户生命周期记录表';

-- =====================================================
-- 2. 标签管理层 (Tag Service)
-- =====================================================

-- 标签定义表
CREATE TABLE customer_tag_definitions (
    id VARCHAR(36) PRIMARY KEY COMMENT '标签ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 标签基本信息
    tag_name VARCHAR(100) NOT NULL COMMENT '标签名称',
    tag_code VARCHAR(50) NOT NULL COMMENT '标签编码',
    tag_description TEXT COMMENT '标签描述',
    
    -- 标签分类
    category VARCHAR(50) NOT NULL COMMENT '标签分类',
    tag_type ENUM('manual', 'auto', 'system', 'behavioral', 'demographic', 'transactional') NOT NULL COMMENT '标签类型',
    
    -- 标签规则 (自动标签)
    rule_config JSON COMMENT '标签规则配置',
    rule_expression VARCHAR(1000) COMMENT '规则表达式',
    
    -- 标签属性
    value_type ENUM('boolean', 'numeric', 'string', 'date', 'json') DEFAULT 'boolean' COMMENT '值类型',
    default_value VARCHAR(500) COMMENT '默认值',
    possible_values JSON COMMENT '可选值列表',
    
    -- 标签权重
    weight DECIMAL(5,2) DEFAULT 1.0 COMMENT '标签权重',
    priority INT DEFAULT 100 COMMENT '优先级',
    
    -- 标签颜色和图标
    color VARCHAR(10) COMMENT '标签颜色',
    icon VARCHAR(50) COMMENT '标签图标',
    
    -- 生效配置
    is_active BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    auto_assign BOOLEAN DEFAULT FALSE COMMENT '是否自动分配',
    auto_remove BOOLEAN DEFAULT FALSE COMMENT '是否自动移除',
    
    -- 统计信息
    customer_count INT DEFAULT 0 COMMENT '客户数量',
    last_calculated_at TIMESTAMP NULL COMMENT '最后计算时间',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    
    -- 唯一约束
    UNIQUE KEY uk_tenant_tag_code (tenant_id, tag_code),
    
    -- 索引设计
    INDEX idx_tenant_category (tenant_id, category),
    INDEX idx_tag_type (tag_type),
    INDEX idx_is_active (is_active),
    INDEX idx_auto_assign (auto_assign),
    INDEX idx_priority (priority)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签定义表';

-- 客户标签关联表
CREATE TABLE customer_tags (
    id VARCHAR(36) PRIMARY KEY COMMENT '关联ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    customer_id VARCHAR(36) NOT NULL COMMENT '客户ID',
    tag_id VARCHAR(36) NOT NULL COMMENT '标签ID',
    
    -- 标签值
    tag_value VARCHAR(500) COMMENT '标签值',
    tag_score DECIMAL(5,2) DEFAULT 1.0 COMMENT '标签得分',
    confidence DECIMAL(5,2) DEFAULT 1.0 COMMENT '置信度',
    
    -- 分配信息
    assign_type ENUM('manual', 'auto', 'import', 'rule') NOT NULL COMMENT '分配类型',
    assign_reason VARCHAR(500) COMMENT '分配原因',
    assigned_by VARCHAR(36) COMMENT '分配人ID',
    
    -- 时间管理
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '分配时间',
    expires_at TIMESTAMP NULL COMMENT '过期时间',
    last_verified_at TIMESTAMP NULL COMMENT '最后验证时间',
    
    -- 状态管理
    status ENUM('active', 'expired', 'removed') DEFAULT 'active' COMMENT '状态',
    
    -- 约束和索引
    UNIQUE KEY uk_customer_tag (customer_id, tag_id),
    INDEX idx_tenant_customer (tenant_id, customer_id),
    INDEX idx_tenant_tag (tenant_id, tag_id),
    INDEX idx_assign_type (assign_type),
    INDEX idx_expires_at (expires_at),
    INDEX idx_status (status),
    
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES customer_tag_definitions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客户标签关联表';

-- 标签规则执行日志表
CREATE TABLE tag_rule_execution_logs (
    id VARCHAR(36) PRIMARY KEY COMMENT '日志ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    tag_id VARCHAR(36) NOT NULL COMMENT '标签ID',
    
    -- 执行信息
    execution_type ENUM('scheduled', 'triggered', 'manual') NOT NULL COMMENT '执行类型',
    trigger_event VARCHAR(200) COMMENT '触发事件',
    
    -- 执行结果
    execution_status ENUM('success', 'failed', 'partial') NOT NULL COMMENT '执行状态',
    processed_customers INT DEFAULT 0 COMMENT '处理的客户数',
    added_tags INT DEFAULT 0 COMMENT '新增标签数',
    removed_tags INT DEFAULT 0 COMMENT '移除标签数',
    
    -- 执行详情
    execution_time_ms INT COMMENT '执行时间(毫秒)',
    error_message TEXT COMMENT '错误信息',
    execution_details JSON COMMENT '执行详情',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX idx_tenant_tag (tenant_id, tag_id),
    INDEX idx_execution_type (execution_type),
    INDEX idx_execution_status (execution_status),
    INDEX idx_created_at (created_at),
    
    FOREIGN KEY (tag_id) REFERENCES customer_tag_definitions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签规则执行日志表';

-- =====================================================
-- 3. 客户分群层 (Segment Service)
-- =====================================================

-- 客户分群定义表
CREATE TABLE customer_segments (
    id VARCHAR(36) PRIMARY KEY COMMENT '分群ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 分群基本信息
    segment_name VARCHAR(200) NOT NULL COMMENT '分群名称',
    segment_code VARCHAR(50) NOT NULL COMMENT '分群编码',
    segment_description TEXT COMMENT '分群描述',
    
    -- 分群类型
    segment_type ENUM('static', 'dynamic', 'manual', 'imported') NOT NULL COMMENT '分群类型',
    segment_category VARCHAR(50) COMMENT '分群分类',
    
    -- 分群规则 (动态分群)
    rule_config JSON COMMENT '分群规则配置',
    rule_expression TEXT COMMENT '规则表达式',
    filter_conditions JSON COMMENT '筛选条件',
    
    -- 分群属性
    is_active BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    is_public BOOLEAN DEFAULT FALSE COMMENT '是否公开',
    auto_refresh BOOLEAN DEFAULT TRUE COMMENT '是否自动刷新',
    refresh_frequency ENUM('realtime', 'hourly', 'daily', 'weekly', 'monthly') DEFAULT 'daily' COMMENT '刷新频率',
    
    -- 统计信息
    customer_count INT DEFAULT 0 COMMENT '客户数量',
    last_calculated_at TIMESTAMP NULL COMMENT '最后计算时间',
    calculation_duration_ms INT COMMENT '计算耗时(毫秒)',
    
    -- 分群价值分析
    avg_order_amount DECIMAL(10,2) DEFAULT 0 COMMENT '平均订单金额',
    total_revenue DECIMAL(15,2) DEFAULT 0 COMMENT '总收入',
    conversion_rate DECIMAL(5,2) DEFAULT 0 COMMENT '转化率',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    
    -- 唯一约束
    UNIQUE KEY uk_tenant_segment_code (tenant_id, segment_code),
    
    -- 索引设计
    INDEX idx_tenant_type (tenant_id, segment_type),
    INDEX idx_segment_category (segment_category),
    INDEX idx_is_active (is_active),
    INDEX idx_auto_refresh (auto_refresh),
    INDEX idx_last_calculated (last_calculated_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客户分群定义表';

-- 客户分群成员表
CREATE TABLE customer_segment_members (
    id VARCHAR(36) PRIMARY KEY COMMENT '成员ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    segment_id VARCHAR(36) NOT NULL COMMENT '分群ID',
    customer_id VARCHAR(36) NOT NULL COMMENT '客户ID',
    
    -- 成员信息
    join_type ENUM('auto', 'manual', 'import', 'rule') NOT NULL COMMENT '加入类型',
    join_reason VARCHAR(500) COMMENT '加入原因',
    match_score DECIMAL(5,2) DEFAULT 1.0 COMMENT '匹配得分',
    
    -- 时间管理
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
    last_matched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '最后匹配时间',
    
    -- 状态管理
    status ENUM('active', 'inactive', 'removed') DEFAULT 'active' COMMENT '状态',
    
    -- 约束和索引
    UNIQUE KEY uk_segment_customer (segment_id, customer_id),
    INDEX idx_tenant_segment (tenant_id, segment_id),
    INDEX idx_tenant_customer (tenant_id, customer_id),
    INDEX idx_join_type (join_type),
    INDEX idx_joined_at (joined_at),
    INDEX idx_status (status),
    
    FOREIGN KEY (segment_id) REFERENCES customer_segments(id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客户分群成员表';

-- 分群计算历史表
CREATE TABLE segment_calculation_history (
    id VARCHAR(36) PRIMARY KEY COMMENT '计算ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    segment_id VARCHAR(36) NOT NULL COMMENT '分群ID',
    
    -- 计算信息
    calculation_type ENUM('full', 'incremental', 'manual') NOT NULL COMMENT '计算类型',
    trigger_type ENUM('scheduled', 'event', 'manual') NOT NULL COMMENT '触发类型',
    
    -- 计算结果
    calculation_status ENUM('running', 'success', 'failed', 'cancelled') NOT NULL COMMENT '计算状态',
    total_customers INT DEFAULT 0 COMMENT '总客户数',
    added_customers INT DEFAULT 0 COMMENT '新增客户数',
    removed_customers INT DEFAULT 0 COMMENT '移除客户数',
    final_count INT DEFAULT 0 COMMENT '最终客户数',
    
    -- 计算性能
    calculation_time_ms INT COMMENT '计算时间(毫秒)',
    error_message TEXT COMMENT '错误信息',
    
    -- 时间管理
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '开始时间',
    completed_at TIMESTAMP NULL COMMENT '完成时间',
    
    INDEX idx_tenant_segment (tenant_id, segment_id),
    INDEX idx_calculation_status (calculation_status),
    INDEX idx_started_at (started_at),
    INDEX idx_trigger_type (trigger_type),
    
    FOREIGN KEY (segment_id) REFERENCES customer_segments(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分群计算历史表';

-- =====================================================
-- 4. 行为分析层 (Behavior Service)
-- =====================================================

-- 客户行为定义表
CREATE TABLE customer_behavior_definitions (
    id VARCHAR(36) PRIMARY KEY COMMENT '行为ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 行为基本信息
    behavior_name VARCHAR(100) NOT NULL COMMENT '行为名称',
    behavior_code VARCHAR(50) NOT NULL COMMENT '行为编码',
    behavior_description TEXT COMMENT '行为描述',
    
    -- 行为分类
    behavior_category ENUM('visit', 'purchase', 'interaction', 'social', 'support', 'engagement') NOT NULL COMMENT '行为分类',
    behavior_type ENUM('event', 'duration', 'frequency', 'sequence') NOT NULL COMMENT '行为类型',
    
    -- 行为属性
    is_positive BOOLEAN DEFAULT TRUE COMMENT '是否正向行为',
    weight DECIMAL(5,2) DEFAULT 1.0 COMMENT '行为权重',
    score_impact DECIMAL(5,2) DEFAULT 0 COMMENT '评分影响',
    
    -- 数据配置
    event_schema JSON COMMENT '事件模式定义',
    required_fields JSON COMMENT '必需字段',
    optional_fields JSON COMMENT '可选字段',
    
    -- 统计配置
    enable_statistics BOOLEAN DEFAULT TRUE COMMENT '是否启用统计',
    retention_days INT DEFAULT 365 COMMENT '数据保留天数',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    
    -- 唯一约束
    UNIQUE KEY uk_tenant_behavior_code (tenant_id, behavior_code),
    
    -- 索引设计
    INDEX idx_tenant_category (tenant_id, behavior_category),
    INDEX idx_behavior_type (behavior_type),
    INDEX idx_is_positive (is_positive)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客户行为定义表';

-- 客户行为事件表 (分区表)
CREATE TABLE customer_behavior_events (
    id VARCHAR(36) NOT NULL COMMENT '事件ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    customer_id VARCHAR(36) NOT NULL COMMENT '客户ID',
    behavior_id VARCHAR(36) NOT NULL COMMENT '行为ID',
    
    -- 事件基本信息
    event_name VARCHAR(100) NOT NULL COMMENT '事件名称',
    event_source ENUM('web', 'app', 'wework', 'api', 'offline', 'system') NOT NULL COMMENT '事件来源',
    session_id VARCHAR(100) COMMENT '会话ID',
    
    -- 事件数据
    event_data JSON COMMENT '事件数据',
    event_value DECIMAL(10,2) COMMENT '事件价值',
    duration_seconds INT COMMENT '持续时间(秒)',
    
    -- 上下文信息
    page_url VARCHAR(1000) COMMENT '页面URL',
    referrer_url VARCHAR(1000) COMMENT '来源URL',
    user_agent TEXT COMMENT '用户代理',
    ip_address VARCHAR(45) COMMENT 'IP地址',
    device_info JSON COMMENT '设备信息',
    location_info JSON COMMENT '位置信息',
    
    -- 业务关联
    related_object_type VARCHAR(50) COMMENT '关联对象类型',
    related_object_id VARCHAR(36) COMMENT '关联对象ID',
    business_context JSON COMMENT '业务上下文',
    
    -- 时间信息
    event_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '事件时间',
    processed_at TIMESTAMP NULL COMMENT '处理时间',
    
    -- 复合主键，包含分区键
    PRIMARY KEY (id, event_time),
    
    -- 索引设计
    INDEX idx_tenant_customer (tenant_id, customer_id),
    INDEX idx_tenant_behavior (tenant_id, behavior_id),
    INDEX idx_customer_time (customer_id, event_time),
    INDEX idx_event_source (event_source),
    INDEX idx_session_id (session_id),
    INDEX idx_related_object (related_object_type, related_object_id),
    
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    FOREIGN KEY (behavior_id) REFERENCES customer_behavior_definitions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客户行为事件表'
PARTITION BY RANGE (UNIX_TIMESTAMP(event_time)) (
    PARTITION p202501 VALUES LESS THAN (UNIX_TIMESTAMP('2025-02-01 00:00:00')),
    PARTITION p202502 VALUES LESS THAN (UNIX_TIMESTAMP('2025-03-01 00:00:00')),
    PARTITION p202503 VALUES LESS THAN (UNIX_TIMESTAMP('2025-04-01 00:00:00')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- 客户行为统计表
CREATE TABLE customer_behavior_statistics (
    id VARCHAR(36) PRIMARY KEY COMMENT '统计ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    customer_id VARCHAR(36) NOT NULL COMMENT '客户ID',
    behavior_id VARCHAR(36) NOT NULL COMMENT '行为ID',
    
    -- 统计维度
    stat_period ENUM('day', 'week', 'month', 'quarter', 'year', 'all_time') NOT NULL COMMENT '统计周期',
    stat_date DATE NOT NULL COMMENT '统计日期',
    
    -- 统计数据
    event_count INT DEFAULT 0 COMMENT '事件次数',
    total_value DECIMAL(15,2) DEFAULT 0 COMMENT '总价值',
    avg_value DECIMAL(10,2) DEFAULT 0 COMMENT '平均价值',
    max_value DECIMAL(10,2) DEFAULT 0 COMMENT '最大价值',
    total_duration_seconds BIGINT DEFAULT 0 COMMENT '总持续时间',
    avg_duration_seconds INT DEFAULT 0 COMMENT '平均持续时间',
    
    -- 趋势数据
    trend_direction ENUM('up', 'down', 'stable') COMMENT '趋势方向',
    growth_rate DECIMAL(5,2) COMMENT '增长率',
    
    -- 时间管理
    first_event_time TIMESTAMP NULL COMMENT '首次事件时间',
    last_event_time TIMESTAMP NULL COMMENT '最后事件时间',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    -- 唯一约束
    UNIQUE KEY uk_customer_behavior_period_date (customer_id, behavior_id, stat_period, stat_date),
    
    -- 索引设计
    INDEX idx_tenant_behavior (tenant_id, behavior_id),
    INDEX idx_customer_period (customer_id, stat_period),
    INDEX idx_stat_date (stat_date),
    INDEX idx_event_count (event_count),
    
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    FOREIGN KEY (behavior_id) REFERENCES customer_behavior_definitions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客户行为统计表';

-- 客户行为序列表 (行为路径分析)
CREATE TABLE customer_behavior_sequences (
    id VARCHAR(36) PRIMARY KEY COMMENT '序列ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    customer_id VARCHAR(36) NOT NULL COMMENT '客户ID',
    session_id VARCHAR(100) NOT NULL COMMENT '会话ID',
    
    -- 序列信息
    sequence_number INT NOT NULL COMMENT '序列号',
    behavior_id VARCHAR(36) NOT NULL COMMENT '行为ID',
    event_id VARCHAR(36) NOT NULL COMMENT '事件ID',
    
    -- 路径信息
    path_context JSON COMMENT '路径上下文',
    transition_time_seconds INT COMMENT '转换时间(秒)',
    
    -- 时间信息
    event_time TIMESTAMP NOT NULL COMMENT '事件时间',
    
    INDEX idx_tenant_customer (tenant_id, customer_id),
    INDEX idx_session_sequence (session_id, sequence_number),
    INDEX idx_behavior_id (behavior_id),
    INDEX idx_event_time (event_time),
    
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    FOREIGN KEY (behavior_id) REFERENCES customer_behavior_definitions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客户行为序列表';

-- =====================================================
-- 5. 创建视图
-- =====================================================

-- 客户360度视图
CREATE VIEW v_customer_360 AS
SELECT 
    c.id,
    c.tenant_id,
    c.customer_code,
    c.name,
    c.customer_type,
    c.phone,
    c.email,
    c.status,
    c.lifecycle_stage,
    c.level,
    c.source_channel,
    c.total_orders,
    c.total_amount,
    c.avg_order_amount,
    c.last_order_date,
    c.satisfaction_score,
    COUNT(DISTINCT ct.tag_id) as tag_count,
    COUNT(DISTINCT csm.segment_id) as segment_count,
    GROUP_CONCAT(DISTINCT ctd.tag_name) as tags,
    c.created_at,
    c.last_contact_date
FROM customers c
LEFT JOIN customer_tags ct ON c.id = ct.customer_id AND ct.status = 'active'
LEFT JOIN customer_tag_definitions ctd ON ct.tag_id = ctd.id
LEFT JOIN customer_segment_members csm ON c.id = csm.customer_id AND csm.status = 'active'
GROUP BY c.id, c.tenant_id, c.customer_code, c.name, c.customer_type, 
         c.phone, c.email, c.status, c.lifecycle_stage, c.level, 
         c.source_channel, c.total_orders, c.total_amount, c.avg_order_amount,
         c.last_order_date, c.satisfaction_score, c.created_at, c.last_contact_date;

-- 分群统计视图
CREATE VIEW v_segment_statistics AS
SELECT 
    s.id,
    s.tenant_id,
    s.segment_name,
    s.segment_type,
    s.customer_count,
    s.avg_order_amount,
    s.total_revenue,
    s.conversion_rate,
    COUNT(DISTINCT csm.customer_id) as actual_member_count,
    AVG(c.total_amount) as actual_avg_amount,
    SUM(c.total_amount) as actual_total_revenue,
    s.last_calculated_at,
    s.created_at
FROM customer_segments s
LEFT JOIN customer_segment_members csm ON s.id = csm.segment_id AND csm.status = 'active'
LEFT JOIN customers c ON csm.customer_id = c.id
WHERE s.is_active = TRUE
GROUP BY s.id, s.tenant_id, s.segment_name, s.segment_type, s.customer_count,
         s.avg_order_amount, s.total_revenue, s.conversion_rate, 
         s.last_calculated_at, s.created_at;

-- 行为热点分析视图
CREATE VIEW v_behavior_heatmap AS
SELECT 
    cbd.tenant_id,
    cbd.behavior_name,
    cbd.behavior_category,
    COUNT(DISTINCT cbe.customer_id) as unique_customers,
    COUNT(*) as total_events,
    AVG(cbe.event_value) as avg_event_value,
    SUM(cbe.event_value) as total_event_value,
    DATE(cbe.event_time) as event_date,
    HOUR(cbe.event_time) as event_hour
FROM customer_behavior_definitions cbd
JOIN customer_behavior_events cbe ON cbd.id = cbe.behavior_id
WHERE cbe.event_time >= DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY cbd.tenant_id, cbd.behavior_name, cbd.behavior_category,
         DATE(cbe.event_time), HOUR(cbe.event_time);

-- =====================================================
-- 6. 创建存储过程
-- =====================================================

DELIMITER //

-- 计算客户生命周期价值 (CLV)
CREATE PROCEDURE sp_calculate_customer_clv(
    IN p_customer_id VARCHAR(36),
    OUT p_clv DECIMAL(15,2),
    OUT p_prediction_period_months INT
)
BEGIN
    DECLARE v_avg_order_amount DECIMAL(10,2);
    DECLARE v_order_frequency DECIMAL(8,4);
    DECLARE v_customer_lifespan_months INT;
    DECLARE v_total_orders INT;
    DECLARE v_first_order_date DATE;
    DECLARE v_last_order_date DATE;
    
    -- 获取客户统计数据
    SELECT 
        total_orders,
        avg_order_amount,
        first_order_date,
        last_order_date
    INTO v_total_orders, v_avg_order_amount, v_first_order_date, v_last_order_date
    FROM customers WHERE id = p_customer_id;
    
    -- 计算客户生命周期 (月)
    IF v_first_order_date IS NOT NULL AND v_last_order_date IS NOT NULL THEN
        SET v_customer_lifespan_months = TIMESTAMPDIFF(MONTH, v_first_order_date, v_last_order_date);
        IF v_customer_lifespan_months = 0 THEN
            SET v_customer_lifespan_months = 1;
        END IF;
    ELSE
        SET v_customer_lifespan_months = 1;
    END IF;
    
    -- 计算订单频率 (每月订单数)
    IF v_total_orders > 0 AND v_customer_lifespan_months > 0 THEN
        SET v_order_frequency = v_total_orders / v_customer_lifespan_months;
    ELSE
        SET v_order_frequency = 0;
    END IF;
    
    -- 预测未来期间 (基于历史数据推断)
    SET p_prediction_period_months = GREATEST(v_customer_lifespan_months * 2, 12);
    
    -- 计算CLV = 平均订单金额 × 订单频率 × 预测期间
    SET p_clv = v_avg_order_amount * v_order_frequency * p_prediction_period_months;
    
    SELECT 
        p_customer_id as customer_id,
        p_clv as clv,
        v_avg_order_amount as avg_order_amount,
        v_order_frequency as order_frequency,
        v_customer_lifespan_months as lifespan_months,
        p_prediction_period_months as prediction_months;
END //

-- 自动分配客户标签
CREATE PROCEDURE sp_auto_assign_customer_tags(
    IN p_tenant_id VARCHAR(36),
    IN p_customer_id VARCHAR(36)
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_tag_id VARCHAR(36);
    DECLARE v_rule_config JSON;
    DECLARE v_rule_expression VARCHAR(1000);
    DECLARE v_tag_assigned BOOLEAN DEFAULT FALSE;
    
    DECLARE tag_cursor CURSOR FOR 
        SELECT id, rule_config, rule_expression
        FROM customer_tag_definitions 
        WHERE tenant_id = p_tenant_id 
        AND tag_type = 'auto' 
        AND is_active = TRUE 
        AND auto_assign = TRUE;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN tag_cursor;
    tag_loop: LOOP
        FETCH tag_cursor INTO v_tag_id, v_rule_config, v_rule_expression;
        IF done THEN
            LEAVE tag_loop;
        END IF;
        
        -- 这里应该根据规则表达式评估客户是否符合标签条件
        -- 简化实现，实际需要根据具体规则引擎
        SET v_tag_assigned = FALSE;
        
        -- 示例：高价值客户标签 (总消费金额 > 10000)
        IF v_rule_expression LIKE '%total_amount > 10000%' THEN
            SELECT COUNT(*) > 0 INTO v_tag_assigned
            FROM customers 
            WHERE id = p_customer_id AND total_amount > 10000;
        END IF;
        
        -- 如果符合条件且未分配，则分配标签
        IF v_tag_assigned = TRUE THEN
            INSERT IGNORE INTO customer_tags (
                id, tenant_id, customer_id, tag_id, assign_type, assign_reason
            ) VALUES (
                UUID(), p_tenant_id, p_customer_id, v_tag_id, 'auto', '自动规则分配'
            );
        END IF;
        
    END LOOP;
    CLOSE tag_cursor;
    
    SELECT '自动标签分配完成' as result;
END //

-- 更新分群成员
CREATE PROCEDURE sp_update_segment_members(
    IN p_segment_id VARCHAR(36)
)
BEGIN
    DECLARE v_tenant_id VARCHAR(36);
    DECLARE v_segment_type ENUM('static', 'dynamic', 'manual', 'imported');
    DECLARE v_rule_config JSON;
    DECLARE v_filter_conditions JSON;
    DECLARE v_customer_count INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
    
    START TRANSACTION;
    
    -- 获取分群信息
    SELECT tenant_id, segment_type, rule_config, filter_conditions
    INTO v_tenant_id, v_segment_type, v_rule_config, v_filter_conditions
    FROM customer_segments WHERE id = p_segment_id;
    
    -- 只处理动态分群
    IF v_segment_type = 'dynamic' THEN
        
        -- 记录计算开始
        INSERT INTO segment_calculation_history (
            id, tenant_id, segment_id, calculation_type, trigger_type, calculation_status
        ) VALUES (
            UUID(), v_tenant_id, p_segment_id, 'full', 'manual', 'running'
        );
        
        -- 清除现有成员 (动态分群重新计算)
        DELETE FROM customer_segment_members WHERE segment_id = p_segment_id;
        
        -- 根据规则添加符合条件的客户
        -- 这里需要根据实际的规则引擎实现
        -- 简化示例：活跃客户分群
        INSERT INTO customer_segment_members (
            id, tenant_id, segment_id, customer_id, join_type, join_reason
        )
        SELECT 
            UUID(), v_tenant_id, p_segment_id, c.id, 'auto', '动态规则匹配'
        FROM customers c
        WHERE c.tenant_id = v_tenant_id
        AND c.status = 'active'
        AND c.last_order_date >= DATE_SUB(NOW(), INTERVAL 90 DAY);
        
        -- 获取更新后的客户数量
        SELECT COUNT(*) INTO v_customer_count
        FROM customer_segment_members WHERE segment_id = p_segment_id;
        
        -- 更新分群统计
        UPDATE customer_segments 
        SET customer_count = v_customer_count,
            last_calculated_at = NOW()
        WHERE id = p_segment_id;
        
        -- 更新计算历史
        UPDATE segment_calculation_history 
        SET calculation_status = 'success',
            final_count = v_customer_count,
            completed_at = NOW()
        WHERE segment_id = p_segment_id 
        AND calculation_status = 'running'
        ORDER BY started_at DESC LIMIT 1;
        
    END IF;
    
    COMMIT;
    
    SELECT CONCAT('分群更新完成，客户数量: ', v_customer_count) as result;
END //

DELIMITER ;

-- =====================================================
-- 7. 创建定时任务
-- =====================================================

-- 启用事件调度器
SET GLOBAL event_scheduler = ON;

-- 创建客户生命周期更新任务
CREATE EVENT IF NOT EXISTS update_customer_lifecycle
ON SCHEDULE EVERY 1 DAY
STARTS DATE_ADD(CURDATE(), INTERVAL 3 HOUR)
DO
BEGIN
    -- 更新客户生命周期阶段
    UPDATE customers c
    SET lifecycle_stage = 
        CASE 
            WHEN c.total_orders = 0 THEN 'lead'
            WHEN c.total_orders = 1 AND c.first_order_date >= DATE_SUB(NOW(), INTERVAL 30 DAY) THEN 'prospect'
            WHEN c.total_orders >= 2 AND c.last_order_date >= DATE_SUB(NOW(), INTERVAL 90 DAY) THEN 'customer'
            WHEN c.total_orders >= 5 AND c.total_amount >= 5000 THEN 'advocate'
            WHEN c.last_order_date < DATE_SUB(NOW(), INTERVAL 180 DAY) THEN 'inactive'
            ELSE c.lifecycle_stage
        END,
        updated_at = NOW()
    WHERE status = 'active';
END;

-- 创建自动标签分配任务
CREATE EVENT IF NOT EXISTS auto_assign_tags
ON SCHEDULE EVERY 6 HOUR
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_tenant_id VARCHAR(36);
    DECLARE v_customer_id VARCHAR(36);
    
    DECLARE customer_cursor CURSOR FOR 
        SELECT DISTINCT tenant_id, id FROM customers WHERE status = 'active';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN customer_cursor;
    customer_loop: LOOP
        FETCH customer_cursor INTO v_tenant_id, v_customer_id;
        IF done THEN
            LEAVE customer_loop;
        END IF;
        
        CALL sp_auto_assign_customer_tags(v_tenant_id, v_customer_id);
        
    END LOOP;
    CLOSE customer_cursor;
END;

-- 创建动态分群更新任务
CREATE EVENT IF NOT EXISTS update_dynamic_segments
ON SCHEDULE EVERY 12 HOUR
STARTS DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 1 HOUR)
DO
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_segment_id VARCHAR(36);
    
    DECLARE segment_cursor CURSOR FOR 
        SELECT id FROM customer_segments 
        WHERE segment_type = 'dynamic' 
        AND is_active = TRUE 
        AND auto_refresh = TRUE;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN segment_cursor;
    segment_loop: LOOP
        FETCH segment_cursor INTO v_segment_id;
        IF done THEN
            LEAVE segment_loop;
        END IF;
        
        CALL sp_update_segment_members(v_segment_id);
        
    END LOOP;
    CLOSE segment_cursor;
END;

-- =====================================================
-- 8. 插入初始数据
-- =====================================================

-- 插入默认行为定义
INSERT INTO customer_behavior_definitions (id, tenant_id, behavior_name, behavior_code, behavior_category, behavior_type, is_positive, weight) VALUES
(UUID(), 'default-tenant', '页面访问', 'page_view', 'visit', 'event', TRUE, 1.0),
(UUID(), 'default-tenant', '商品浏览', 'product_view', 'visit', 'event', TRUE, 2.0),
(UUID(), 'default-tenant', '加入购物车', 'add_to_cart', 'purchase', 'event', TRUE, 5.0),
(UUID(), 'default-tenant', '完成购买', 'purchase', 'purchase', 'event', TRUE, 10.0),
(UUID(), 'default-tenant', '客服咨询', 'contact_support', 'support', 'event', TRUE, 3.0),
(UUID(), 'default-tenant', '分享推荐', 'share_product', 'social', 'event', TRUE, 4.0);

-- 插入默认标签定义
INSERT INTO customer_tag_definitions (id, tenant_id, tag_name, tag_code, category, tag_type, is_active, color) VALUES
(UUID(), 'default-tenant', '高价值客户', 'high_value', '价值分层', 'auto', TRUE, '#ff6b6b'),
(UUID(), 'default-tenant', '活跃用户', 'active_user', '活跃度', 'auto', TRUE, '#51cf66'),
(UUID(), 'default-tenant', '新客户', 'new_customer', '生命周期', 'auto', TRUE, '#339af0'),
(UUID(), 'default-tenant', '流失风险', 'churn_risk', '风险等级', 'auto', TRUE, '#ffd43b'),
(UUID(), 'default-tenant', '忠诚客户', 'loyal_customer', '忠诚度', 'auto', TRUE, '#9775fa'),
(UUID(), 'default-tenant', 'VIP客户', 'vip_customer', 'VIP等级', 'manual', TRUE, '#e599f7');

-- 插入默认分群定义
INSERT INTO customer_segments (id, tenant_id, segment_name, segment_code, segment_type, segment_category, is_active, auto_refresh) VALUES
(UUID(), 'default-tenant', '活跃客户群', 'active_customers', 'dynamic', '活跃度分群', TRUE, TRUE),
(UUID(), 'default-tenant', '高价值客户群', 'high_value_customers', 'dynamic', '价值分群', TRUE, TRUE),
(UUID(), 'default-tenant', '新客户群', 'new_customers', 'dynamic', '生命周期分群', TRUE, TRUE),
(UUID(), 'default-tenant', '流失风险客户群', 'churn_risk_customers', 'dynamic', '风险分群', TRUE, TRUE);

-- =====================================================
-- 完成提示
-- =====================================================

SELECT '👥 客户管理平台数据库初始化完成！' as message;
SELECT '📊 包含客户档案、标签管理、分群分析、行为追踪等功能' as features;
SELECT '🔧 已创建视图、存储过程和定时任务用于客户分析自动化' as additional_features;
SELECT '📈 分区表设计支持大量行为事件数据存储' as performance_features;
SELECT '🎯 支持客户360度视图和智能分群分析' as analytics_features;