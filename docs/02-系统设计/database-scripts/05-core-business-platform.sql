-- =====================================================
-- 核心业务平台数据库设计 (服务类商品)
-- 包含：营销服务、服务商品管理、订单服务、预约服务
-- =====================================================

-- 创建核心业务平台数据库
CREATE DATABASE IF NOT EXISTS `core_business_platform` 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `core_business_platform`;

-- =====================================================
-- 1. 服务商品管理层 (Service Product Management)
-- =====================================================

-- 服务分类表
CREATE TABLE service_categories (
    id VARCHAR(36) PRIMARY KEY COMMENT '分类ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 分类信息
    category_name VARCHAR(100) NOT NULL COMMENT '分类名称',
    category_code VARCHAR(50) NOT NULL COMMENT '分类编码',
    description TEXT COMMENT '分类描述',
    
    -- 层级结构
    parent_id VARCHAR(36) COMMENT '父分类ID',
    level INT DEFAULT 1 COMMENT '分类层级',
    category_path VARCHAR(1000) COMMENT '分类路径',
    
    -- 服务分类特性
    service_type ENUM('consultation', 'maintenance', 'training', 'support', 'custom') COMMENT '服务类型',
    requires_appointment BOOLEAN DEFAULT TRUE COMMENT '是否需要预约',
    max_concurrent_services INT DEFAULT 1 COMMENT '最大并发服务数',
    
    -- 显示配置
    sort_order INT DEFAULT 100 COMMENT '排序顺序',
    icon_url VARCHAR(500) COMMENT '分类图标URL',
    banner_url VARCHAR(500) COMMENT '分类横幅URL',
    
    -- 状态管理
    status ENUM('active', 'inactive', 'deleted') DEFAULT 'active' COMMENT '状态',
    
    -- 统计信息
    service_count INT DEFAULT 0 COMMENT '服务数量',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    
    -- 唯一约束
    UNIQUE KEY uk_tenant_category_code (tenant_id, category_code),
    
    -- 索引设计
    INDEX idx_parent_id (parent_id),
    INDEX idx_level (level),
    INDEX idx_status (status),
    INDEX idx_service_type (service_type),
    INDEX idx_sort_order (sort_order),
    
    FOREIGN KEY (parent_id) REFERENCES service_categories(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='服务分类表';

-- 服务提供商表
CREATE TABLE service_providers (
    id VARCHAR(36) PRIMARY KEY COMMENT '服务提供商ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 基本信息
    provider_code VARCHAR(50) NOT NULL COMMENT '提供商编码',
    provider_name VARCHAR(200) NOT NULL COMMENT '提供商名称',
    provider_type ENUM('individual', 'team', 'company', 'partner') DEFAULT 'individual' COMMENT '提供商类型',
    
    -- 联系信息
    contact_person VARCHAR(100) COMMENT '联系人',
    phone VARCHAR(20) COMMENT '联系电话',
    email VARCHAR(100) COMMENT '邮箱',
    address JSON COMMENT '地址信息',
    
    -- 服务能力
    service_areas JSON COMMENT '服务区域',
    specialties JSON COMMENT '专业领域',
    certifications JSON COMMENT '认证资质',
    languages JSON COMMENT '支持语言',
    
    -- 工作配置
    working_hours JSON COMMENT '工作时间配置',
    max_concurrent_services INT DEFAULT 1 COMMENT '最大并发服务数',
    advance_booking_days INT DEFAULT 7 COMMENT '提前预约天数',
    
    -- 评价统计
    rating_average DECIMAL(3,2) DEFAULT 0 COMMENT '平均评分',
    review_count INT DEFAULT 0 COMMENT '评价数量',
    service_count INT DEFAULT 0 COMMENT '服务次数',
    
    -- 状态管理
    status ENUM('active', 'inactive', 'suspended', 'deleted') DEFAULT 'active' COMMENT '状态',
    is_verified BOOLEAN DEFAULT FALSE COMMENT '是否已认证',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    
    -- 唯一约束
    UNIQUE KEY uk_tenant_provider_code (tenant_id, provider_code),
    
    -- 索引设计
    INDEX idx_provider_name (provider_name),
    INDEX idx_provider_type (provider_type),
    INDEX idx_status (status),
    INDEX idx_rating (rating_average),
    INDEX idx_is_verified (is_verified)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='服务提供商表';

-- 服务主表
CREATE TABLE services (
    id VARCHAR(36) PRIMARY KEY COMMENT '服务ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 基本信息
    service_code VARCHAR(50) NOT NULL COMMENT '服务编码',
    service_name VARCHAR(200) NOT NULL COMMENT '服务名称',
    service_title VARCHAR(500) COMMENT '服务标题',
    description LONGTEXT COMMENT '服务描述',
    short_description TEXT COMMENT '服务简述',
    
    -- 分类归属
    category_id VARCHAR(36) NOT NULL COMMENT '主分类ID',
    category_path VARCHAR(1000) COMMENT '分类路径',
    
    -- 服务特性
    service_type ENUM('consultation', 'maintenance', 'training', 'support', 'custom') NOT NULL COMMENT '服务类型',
    delivery_mode ENUM('online', 'onsite', 'hybrid', 'remote') NOT NULL COMMENT '交付方式',
    
    -- 价格信息
    base_price DECIMAL(10,2) NOT NULL COMMENT '基础价格',
    sale_price DECIMAL(10,2) COMMENT '销售价格',
    cost_price DECIMAL(10,2) COMMENT '成本价格',
    pricing_model ENUM('fixed', 'hourly', 'daily', 'package', 'custom') DEFAULT 'fixed' COMMENT '计费模式',
    
    -- 服务容量 (替代库存概念)
    max_concurrent_bookings INT DEFAULT 1 COMMENT '最大并发预约数',
    available_slots INT DEFAULT 0 COMMENT '可用时段数',
    booked_slots INT DEFAULT 0 COMMENT '已预约时段数',
    min_capacity_threshold INT DEFAULT 0 COMMENT '最小容量预警',
    
    -- 服务属性
    duration_minutes INT COMMENT '服务时长(分钟)',
    preparation_time_minutes INT DEFAULT 0 COMMENT '准备时间(分钟)',
    cleanup_time_minutes INT DEFAULT 0 COMMENT '清理时间(分钟)',
    
    -- 服务要求
    requirements JSON COMMENT '服务要求和前提条件',
    materials_needed JSON COMMENT '所需材料和工具',
    location_requirements JSON COMMENT '地点要求',
    
    -- 预约配置
    requires_appointment BOOLEAN DEFAULT TRUE COMMENT '是否需要预约',
    advance_booking_hours INT DEFAULT 24 COMMENT '提前预约小时数',
    cancellation_hours INT DEFAULT 2 COMMENT '取消服务小时数',
    reschedule_allowed BOOLEAN DEFAULT TRUE COMMENT '是否允许改期',
    
    -- 服务提供商
    default_provider_id VARCHAR(36) COMMENT '默认服务提供商ID',
    available_providers JSON COMMENT '可选服务提供商列表',
    auto_assign_provider BOOLEAN DEFAULT TRUE COMMENT '自动分配提供商',
    
    -- 媒体资源
    main_image_url VARCHAR(500) COMMENT '主图URL',
    image_urls JSON COMMENT '服务图片列表',
    video_urls JSON COMMENT '服务视频列表',
    detail_images JSON COMMENT '详情图片',
    
    -- 销售配置
    min_booking_quantity INT DEFAULT 1 COMMENT '最小预约数量',
    max_booking_quantity INT COMMENT '最大预约数量',
    group_service BOOLEAN DEFAULT FALSE COMMENT '是否群组服务',
    max_group_size INT COMMENT '最大群组人数',
    
    -- SEO配置
    seo_title VARCHAR(200) COMMENT 'SEO标题',
    seo_keywords VARCHAR(500) COMMENT 'SEO关键词',
    seo_description TEXT COMMENT 'SEO描述',
    
    -- 状态管理
    status ENUM('draft', 'pending_review', 'active', 'inactive', 'discontinued', 'fully_booked') DEFAULT 'draft' COMMENT '服务状态',
    is_featured BOOLEAN DEFAULT FALSE COMMENT '是否精选服务',
    is_new_service BOOLEAN DEFAULT FALSE COMMENT '是否新服务',
    is_on_promotion BOOLEAN DEFAULT FALSE COMMENT '是否促销服务',
    
    -- 销售统计 (生命周期跟踪)
    view_count BIGINT DEFAULT 0 COMMENT '浏览次数',
    booking_count INT DEFAULT 0 COMMENT '预约次数',
    completed_count INT DEFAULT 0 COMMENT '完成次数',
    revenue DECIMAL(15,2) DEFAULT 0 COMMENT '销售收入',
    rating_average DECIMAL(3,2) DEFAULT 0 COMMENT '平均评分',
    review_count INT DEFAULT 0 COMMENT '评价数量',
    
    -- 时间管理
    available_from TIMESTAMP NULL COMMENT '上架时间',
    available_to TIMESTAMP NULL COMMENT '下架时间',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    
    -- 唯一约束
    UNIQUE KEY uk_tenant_service_code (tenant_id, service_code),
    
    -- 索引设计
    INDEX idx_tenant_category (tenant_id, category_id),
    INDEX idx_service_name (service_name),
    INDEX idx_service_type (service_type),
    INDEX idx_delivery_mode (delivery_mode),
    INDEX idx_status (status),
    INDEX idx_pricing_model (pricing_model),
    INDEX idx_capacity (max_concurrent_bookings, available_slots),
    INDEX idx_booking_stats (booking_count, completed_count, revenue),
    INDEX idx_available_period (available_from, available_to),
    INDEX idx_default_provider (default_provider_id),
    
    FOREIGN KEY (category_id) REFERENCES service_categories(id) ON DELETE RESTRICT,
    FOREIGN KEY (default_provider_id) REFERENCES service_providers(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='服务主表';

-- 服务变体表 (Service Variants - 服务的不同配置)
CREATE TABLE service_variants (
    id VARCHAR(36) PRIMARY KEY COMMENT '服务变体ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    service_id VARCHAR(36) NOT NULL COMMENT '服务ID',
    
    -- 变体基本信息
    variant_code VARCHAR(100) NOT NULL COMMENT '变体编码',
    variant_name VARCHAR(200) COMMENT '变体名称',
    
    -- 服务变体属性 (替代传统SKU属性)
    attributes JSON NOT NULL COMMENT '服务属性 {duration, level, location, language等}',
    attribute_combination VARCHAR(500) COMMENT '属性组合字符串',
    
    -- 变体特性
    duration_minutes INT COMMENT '服务时长(分钟)',
    service_level ENUM('basic', 'standard', 'premium', 'enterprise') DEFAULT 'standard' COMMENT '服务等级',
    location_type ENUM('online', 'onsite', 'office', 'flexible') COMMENT '服务地点类型',
    group_size_min INT DEFAULT 1 COMMENT '最小服务人数',
    group_size_max INT DEFAULT 1 COMMENT '最大服务人数',
    
    -- 价格容量
    price DECIMAL(10,2) NOT NULL COMMENT '变体价格',
    cost_price DECIMAL(10,2) COMMENT '变体成本价',
    capacity INT DEFAULT 1 COMMENT '服务容量',
    booked_capacity INT DEFAULT 0 COMMENT '已预约容量',
    
    -- 变体配置
    provider_requirements JSON COMMENT '服务提供商要求',
    equipment_needed JSON COMMENT '所需设备',
    preparation_notes TEXT COMMENT '准备说明',
    
    -- 媒体资源
    image_url VARCHAR(500) COMMENT '变体图片',
    
    -- 状态管理
    status ENUM('active', 'inactive', 'fully_booked', 'suspended') DEFAULT 'active' COMMENT '状态',
    
    -- 销售统计
    booking_count INT DEFAULT 0 COMMENT '预约次数',
    completed_count INT DEFAULT 0 COMMENT '完成次数',
    revenue DECIMAL(15,2) DEFAULT 0 COMMENT '销售收入',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    -- 唯一约束
    UNIQUE KEY uk_tenant_variant_code (tenant_id, variant_code),
    UNIQUE KEY uk_service_attributes (service_id, attribute_combination),
    
    -- 索引设计
    INDEX idx_tenant_service (tenant_id, service_id),
    INDEX idx_status (status),
    INDEX idx_price (price),
    INDEX idx_capacity (capacity, booked_capacity),
    INDEX idx_service_level (service_level),
    INDEX idx_duration (duration_minutes),
    INDEX idx_booking_stats (booking_count, completed_count, revenue),
    
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='服务变体表';

-- 服务时段管理表
CREATE TABLE service_time_slots (
    id VARCHAR(36) PRIMARY KEY COMMENT '时段ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    service_id VARCHAR(36) NOT NULL COMMENT '服务ID',
    provider_id VARCHAR(36) COMMENT '服务提供商ID',
    
    -- 时段信息
    slot_date DATE NOT NULL COMMENT '服务日期',
    start_time TIME NOT NULL COMMENT '开始时间',
    end_time TIME NOT NULL COMMENT '结束时间',
    duration_minutes INT NOT NULL COMMENT '时段时长(分钟)',
    
    -- 容量管理
    max_bookings INT DEFAULT 1 COMMENT '最大预约数',
    current_bookings INT DEFAULT 0 COMMENT '当前预约数',
    available_capacity INT GENERATED ALWAYS AS (max_bookings - current_bookings) STORED COMMENT '可用容量',
    
    -- 时段配置
    slot_type ENUM('regular', 'special', 'emergency', 'maintenance') DEFAULT 'regular' COMMENT '时段类型',
    location JSON COMMENT '服务地点',
    special_requirements JSON COMMENT '特殊要求',
    
    -- 价格配置
    base_price DECIMAL(10,2) COMMENT '基础价格',
    surge_multiplier DECIMAL(3,2) DEFAULT 1.0 COMMENT '价格倍数',
    final_price DECIMAL(10,2) GENERATED ALWAYS AS (base_price * surge_multiplier) STORED COMMENT '最终价格',
    
    -- 状态管理
    status ENUM('available', 'booked', 'blocked', 'completed', 'cancelled') DEFAULT 'available' COMMENT '时段状态',
    is_recurring BOOLEAN DEFAULT FALSE COMMENT '是否循环时段',
    recurrence_pattern VARCHAR(100) COMMENT '循环模式',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    -- 索引设计
    INDEX idx_tenant_service (tenant_id, service_id),
    INDEX idx_service_date (service_id, slot_date),
    INDEX idx_provider_date (provider_id, slot_date),
    INDEX idx_datetime (slot_date, start_time, end_time),
    INDEX idx_status (status),
    INDEX idx_available_capacity (available_capacity),
    INDEX idx_slot_type (slot_type),
    
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE,
    FOREIGN KEY (provider_id) REFERENCES service_providers(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='服务时段管理表';

-- 服务容量变动记录表
CREATE TABLE service_capacity_logs (
    id VARCHAR(36) PRIMARY KEY COMMENT '记录ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 容量对象
    capacity_type ENUM('service', 'variant', 'time_slot') NOT NULL COMMENT '容量类型',
    capacity_id VARCHAR(36) NOT NULL COMMENT '容量对象ID',
    
    -- 变动信息
    change_type ENUM('book', 'cancel', 'complete', 'adjust', 'block', 'release') NOT NULL COMMENT '变动类型',
    change_quantity INT NOT NULL COMMENT '变动数量',
    before_capacity INT NOT NULL COMMENT '变动前容量',
    after_capacity INT NOT NULL COMMENT '变动后容量',
    
    -- 业务信息
    business_type ENUM('booking', 'cancellation', 'completion', 'adjustment', 'maintenance') COMMENT '业务类型',
    business_id VARCHAR(36) COMMENT '业务单据ID',
    booking_id VARCHAR(36) COMMENT '预约ID',
    reference_no VARCHAR(100) COMMENT '参考单号',
    
    -- 时间信息
    service_date DATE COMMENT '服务日期',
    service_time_start TIME COMMENT '服务开始时间',
    service_time_end TIME COMMENT '服务结束时间',
    
    -- 变动原因
    reason VARCHAR(500) COMMENT '变动原因',
    operator_id VARCHAR(36) COMMENT '操作人ID',
    customer_id VARCHAR(36) COMMENT '客户ID',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX idx_tenant_capacity (tenant_id, capacity_type, capacity_id),
    INDEX idx_change_type (change_type, created_at),
    INDEX idx_business (business_type, business_id),
    INDEX idx_booking_id (booking_id),
    INDEX idx_service_date (service_date),
    INDEX idx_customer_id (customer_id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='服务容量变动记录表';

-- =====================================================
-- 2. 服务预约订单管理层 (Service Booking & Order Management)
-- =====================================================

-- 服务预约订单主表
CREATE TABLE service_orders (
    id VARCHAR(36) PRIMARY KEY COMMENT '订单ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 订单基本信息
    order_no VARCHAR(50) NOT NULL COMMENT '订单号',
    external_order_no VARCHAR(100) COMMENT '外部订单号',
    order_source ENUM('web', 'app', 'wework', 'api', 'admin', 'phone') NOT NULL COMMENT '订单来源',
    order_type ENUM('immediate', 'scheduled', 'recurring', 'emergency') DEFAULT 'scheduled' COMMENT '订单类型',
    
    -- 客户信息
    customer_id VARCHAR(36) COMMENT '客户ID',
    customer_type ENUM('member', 'guest', 'enterprise') DEFAULT 'guest' COMMENT '客户类型',
    contact_info JSON COMMENT '联系信息',
    
    -- 服务预约信息
    service_date DATE NOT NULL COMMENT '服务日期',
    service_time_start TIME COMMENT '服务开始时间',
    service_time_end TIME COMMENT '服务结束时间',
    estimated_duration_minutes INT COMMENT '预计服务时长(分钟)',
    actual_duration_minutes INT COMMENT '实际服务时长(分钟)',
    
    -- 服务地点信息
    service_location_type ENUM('online', 'onsite', 'office', 'third_party') NOT NULL COMMENT '服务地点类型',
    service_address JSON COMMENT '服务地址',
    online_meeting_info JSON COMMENT '在线会议信息 {platform, room_id, password}',
    location_requirements TEXT COMMENT '地点要求',
    
    -- 服务提供商
    assigned_provider_id VARCHAR(36) COMMENT '分配的服务提供商ID',
    provider_assigned_at TIMESTAMP NULL COMMENT '提供商分配时间',
    provider_assignment_method ENUM('auto', 'manual', 'customer_choice') COMMENT '分配方式',
    
    -- 订单状态 (服务生命周期跟踪核心)
    order_status ENUM(
        'pending_payment', 'paid', 'confirmed', 'assigned', 'preparing', 
        'in_progress', 'completed', 'cancelled', 'refunded', 'rescheduled'
    ) NOT NULL DEFAULT 'pending_payment' COMMENT '订单状态',
    payment_status ENUM('unpaid', 'partial_paid', 'paid', 'refunded', 'partial_refunded') DEFAULT 'unpaid' COMMENT '支付状态',
    service_status ENUM('not_started', 'preparing', 'in_progress', 'paused', 'completed', 'cancelled') DEFAULT 'not_started' COMMENT '服务状态',
    
    -- 金额信息
    subtotal DECIMAL(12,2) NOT NULL COMMENT '服务小计',
    service_fee DECIMAL(10,2) DEFAULT 0 COMMENT '服务费',
    travel_fee DECIMAL(10,2) DEFAULT 0 COMMENT '上门费/交通费',
    material_fee DECIMAL(10,2) DEFAULT 0 COMMENT '材料费',
    discount_amount DECIMAL(10,2) DEFAULT 0 COMMENT '优惠金额',
    tax_amount DECIMAL(10,2) DEFAULT 0 COMMENT '税费',
    total_amount DECIMAL(12,2) NOT NULL COMMENT '订单总额',
    paid_amount DECIMAL(12,2) DEFAULT 0 COMMENT '已付金额',
    refund_amount DECIMAL(12,2) DEFAULT 0 COMMENT '退款金额',
    
    -- 优惠信息
    coupon_codes JSON COMMENT '使用的优惠券',
    promotion_ids JSON COMMENT '参与的促销活动',
    discount_details JSON COMMENT '优惠明细',
    
    -- 预约配置
    is_recurring BOOLEAN DEFAULT FALSE COMMENT '是否循环预约',
    recurrence_pattern JSON COMMENT '循环模式配置',
    parent_order_id VARCHAR(36) COMMENT '父订单ID (循环预约)',
    
    -- 服务要求
    service_requirements JSON COMMENT '服务要求',
    special_instructions TEXT COMMENT '特殊说明',
    materials_provided JSON COMMENT '客户提供的材料',
    access_instructions TEXT COMMENT '入场说明',
    
    -- 发票信息
    invoice_type ENUM('none', 'personal', 'company') DEFAULT 'none' COMMENT '发票类型',
    invoice_info JSON COMMENT '发票信息',
    
    -- 时间管理 (服务生命周期跟踪)
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间',
    payment_time TIMESTAMP NULL COMMENT '支付时间',
    confirm_time TIMESTAMP NULL COMMENT '确认时间',
    assigned_time TIMESTAMP NULL COMMENT '分配时间',
    service_start_time TIMESTAMP NULL COMMENT '服务开始时间',
    service_end_time TIMESTAMP NULL COMMENT '服务结束时间',
    complete_time TIMESTAMP NULL COMMENT '完成时间',
    cancel_time TIMESTAMP NULL COMMENT '取消时间',
    
    -- 改期信息
    rescheduled_from_date DATE COMMENT '原服务日期',
    rescheduled_from_time TIME COMMENT '原服务时间',
    reschedule_reason VARCHAR(500) COMMENT '改期原因',
    reschedule_count INT DEFAULT 0 COMMENT '改期次数',
    
    -- 取消信息
    cancellation_reason VARCHAR(500) COMMENT '取消原因',
    cancelled_by ENUM('customer', 'provider', 'admin', 'system') COMMENT '取消发起方',
    cancellation_fee DECIMAL(10,2) DEFAULT 0 COMMENT '取消费用',
    
    -- 业务扩展
    notes TEXT COMMENT '订单备注',
    internal_notes TEXT COMMENT '内部备注',
    tags JSON COMMENT '订单标签',
    
    -- 风控信息
    risk_level ENUM('low', 'medium', 'high') DEFAULT 'low' COMMENT '风险等级',
    risk_score DECIMAL(5,2) DEFAULT 0 COMMENT '风险评分',
    is_suspicious BOOLEAN DEFAULT FALSE COMMENT '是否可疑订单',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    
    -- 唯一约束
    UNIQUE KEY uk_tenant_order_no (tenant_id, order_no),
    
    -- 索引设计
    INDEX idx_tenant_customer (tenant_id, customer_id),
    INDEX idx_order_status (order_status, order_time),
    INDEX idx_payment_status (payment_status),
    INDEX idx_service_status (service_status),
    INDEX idx_service_date (service_date),
    INDEX idx_provider_id (assigned_provider_id),
    INDEX idx_order_time (order_time),
    INDEX idx_total_amount (total_amount),
    INDEX idx_external_order_no (external_order_no),
    INDEX idx_parent_order (parent_order_id),
    INDEX idx_service_location_type (service_location_type),
    
    FOREIGN KEY (assigned_provider_id) REFERENCES service_providers(id) ON DELETE SET NULL,
    FOREIGN KEY (parent_order_id) REFERENCES service_orders(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='服务预约订单主表';

-- 服务订单项表
CREATE TABLE service_order_items (
    id VARCHAR(36) PRIMARY KEY COMMENT '订单项ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    order_id VARCHAR(36) NOT NULL COMMENT '订单ID',
    
    -- 服务信息
    service_id VARCHAR(36) NOT NULL COMMENT '服务ID',
    variant_id VARCHAR(36) COMMENT '服务变体ID',
    time_slot_id VARCHAR(36) COMMENT '时段ID',
    service_name VARCHAR(200) NOT NULL COMMENT '服务名称',
    variant_name VARCHAR(200) COMMENT '变体名称',
    service_image VARCHAR(500) COMMENT '服务图片',
    
    -- 服务属性
    service_attributes JSON COMMENT '服务属性快照',
    service_level ENUM('basic', 'standard', 'premium', 'enterprise') COMMENT '服务等级',
    duration_minutes INT COMMENT '服务时长(分钟)',
    
    -- 价格数量
    unit_price DECIMAL(10,2) NOT NULL COMMENT '单价',
    quantity INT NOT NULL DEFAULT 1 COMMENT '数量/人次',
    subtotal DECIMAL(12,2) NOT NULL COMMENT '小计',
    
    -- 服务费用明细
    base_service_fee DECIMAL(10,2) DEFAULT 0 COMMENT '基础服务费',
    travel_fee DECIMAL(10,2) DEFAULT 0 COMMENT '交通费',
    material_fee DECIMAL(10,2) DEFAULT 0 COMMENT '材料费',
    overtime_fee DECIMAL(10,2) DEFAULT 0 COMMENT '超时费',
    
    -- 优惠信息
    discount_amount DECIMAL(10,2) DEFAULT 0 COMMENT '优惠金额',
    final_price DECIMAL(12,2) NOT NULL COMMENT '最终价格',
    
    -- 服务快照 (防止服务信息变更影响订单)
    service_snapshot JSON COMMENT '服务信息快照',
    
    -- 服务执行状态
    service_status ENUM('pending', 'confirmed', 'preparing', 'in_progress', 'completed', 'cancelled', 'rescheduled') DEFAULT 'pending' COMMENT '服务状态',
    
    -- 服务质量评估
    completion_rate DECIMAL(5,2) DEFAULT 0 COMMENT '完成度百分比',
    quality_score DECIMAL(3,2) DEFAULT 0 COMMENT '质量评分',
    customer_satisfaction ENUM('very_satisfied', 'satisfied', 'neutral', 'dissatisfied', 'very_dissatisfied') COMMENT '客户满意度',
    
    -- 服务记录
    actual_start_time TIMESTAMP NULL COMMENT '实际开始时间',
    actual_end_time TIMESTAMP NULL COMMENT '实际结束时间',
    actual_duration_minutes INT COMMENT '实际服务时长',
    service_notes TEXT COMMENT '服务记录',
    issues_encountered JSON COMMENT '遇到的问题',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX idx_tenant_order (tenant_id, order_id),
    INDEX idx_service_id (service_id),
    INDEX idx_variant_id (variant_id),
    INDEX idx_time_slot_id (time_slot_id),
    INDEX idx_service_status (service_status),
    INDEX idx_customer_satisfaction (customer_satisfaction),
    
    FOREIGN KEY (order_id) REFERENCES service_orders(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE RESTRICT,
    FOREIGN KEY (variant_id) REFERENCES service_variants(id) ON DELETE SET NULL,
    FOREIGN KEY (time_slot_id) REFERENCES service_time_slots(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='服务订单项表';

-- 服务订单状态历史表 (生命周期跟踪核心)
CREATE TABLE service_order_status_history (
    id VARCHAR(36) PRIMARY KEY COMMENT '历史ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    order_id VARCHAR(36) NOT NULL COMMENT '订单ID',
    
    -- 状态变更信息
    old_status ENUM(
        'pending_payment', 'paid', 'confirmed', 'assigned', 'preparing', 
        'in_progress', 'completed', 'cancelled', 'refunded', 'rescheduled'
    ) COMMENT '旧状态',
    new_status ENUM(
        'pending_payment', 'paid', 'confirmed', 'assigned', 'preparing', 
        'in_progress', 'completed', 'cancelled', 'refunded', 'rescheduled'
    ) NOT NULL COMMENT '新状态',
    
    -- 变更信息
    change_reason VARCHAR(500) COMMENT '变更原因',
    operator_type ENUM('customer', 'admin', 'system', 'payment_gateway', 'provider', 'auto_scheduler') COMMENT '操作者类型',
    operator_id VARCHAR(36) COMMENT '操作者ID',
    
    -- 服务相关信息
    provider_id VARCHAR(36) COMMENT '相关服务提供商ID',
    service_date DATE COMMENT '服务日期',
    service_time TIME COMMENT '服务时间',
    
    -- 变更位置信息
    location_info JSON COMMENT '位置信息',
    device_info JSON COMMENT '设备信息',
    
    -- 扩展信息
    extra_data JSON COMMENT '额外数据',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX idx_tenant_order (tenant_id, order_id),
    INDEX idx_order_time (order_id, created_at),
    INDEX idx_status_change (old_status, new_status),
    INDEX idx_operator (operator_type, operator_id),
    INDEX idx_provider_id (provider_id),
    INDEX idx_service_date (service_date),
    
    FOREIGN KEY (order_id) REFERENCES service_orders(id) ON DELETE CASCADE,
    FOREIGN KEY (provider_id) REFERENCES service_providers(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='服务订单状态历史表';

-- 服务订单支付记录表
CREATE TABLE service_order_payments (
    id VARCHAR(36) PRIMARY KEY COMMENT '支付记录ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    order_id VARCHAR(36) NOT NULL COMMENT '订单ID',
    
    -- 支付基本信息
    payment_no VARCHAR(50) NOT NULL COMMENT '支付单号',
    payment_method ENUM('alipay', 'wechat', 'bank_transfer', 'credit_card', 'cash', 'corporate_account', 'points') NOT NULL COMMENT '支付方式',
    payment_channel VARCHAR(50) COMMENT '支付渠道',
    payment_type ENUM('full', 'deposit', 'final', 'installment') DEFAULT 'full' COMMENT '支付类型',
    
    -- 金额信息
    payment_amount DECIMAL(12,2) NOT NULL COMMENT '支付金额',
    currency VARCHAR(10) DEFAULT 'CNY' COMMENT '货币类型',
    
    -- 服务支付相关
    is_advance_payment BOOLEAN DEFAULT FALSE COMMENT '是否预付款',
    advance_payment_percentage DECIMAL(5,2) COMMENT '预付款比例',
    
    -- 支付状态
    payment_status ENUM('pending', 'processing', 'success', 'failed', 'cancelled', 'refunded', 'partial_refunded') NOT NULL COMMENT '支付状态',
    
    -- 第三方信息
    gateway_order_no VARCHAR(100) COMMENT '网关订单号',
    gateway_transaction_no VARCHAR(100) COMMENT '网关交易号',
    gateway_response JSON COMMENT '网关响应数据',
    
    -- 时间信息
    payment_time TIMESTAMP NULL COMMENT '支付时间',
    notify_time TIMESTAMP NULL COMMENT '通知时间',
    
    -- 退款信息
    refund_amount DECIMAL(12,2) DEFAULT 0 COMMENT '退款金额',
    refund_time TIMESTAMP NULL COMMENT '退款时间',
    refund_reason VARCHAR(500) COMMENT '退款原因',
    refund_type ENUM('full', 'partial', 'cancellation_fee') COMMENT '退款类型',
    
    -- 分账信息 (服务提供商分成)
    settlement_amount DECIMAL(12,2) DEFAULT 0 COMMENT '结算金额',
    platform_fee DECIMAL(10,2) DEFAULT 0 COMMENT '平台费用',
    provider_amount DECIMAL(12,2) DEFAULT 0 COMMENT '服务商分成',
    settlement_status ENUM('pending', 'processed', 'completed') DEFAULT 'pending' COMMENT '结算状态',
    settlement_time TIMESTAMP NULL COMMENT '结算时间',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX idx_tenant_order (tenant_id, order_id),
    INDEX idx_payment_no (payment_no),
    INDEX idx_payment_status (payment_status),
    INDEX idx_payment_method (payment_method),
    INDEX idx_payment_type (payment_type),
    INDEX idx_gateway_transaction_no (gateway_transaction_no),
    INDEX idx_settlement_status (settlement_status),
    INDEX idx_payment_time (payment_time),
    
    FOREIGN KEY (order_id) REFERENCES service_orders(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='服务订单支付记录表';

-- =====================================================
-- 3. 营销管理层 (Marketing Service)  
-- =====================================================

-- 营销活动表
CREATE TABLE marketing_campaigns (
    id VARCHAR(36) PRIMARY KEY COMMENT '活动ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 活动基本信息
    campaign_name VARCHAR(200) NOT NULL COMMENT '活动名称',
    campaign_code VARCHAR(50) NOT NULL COMMENT '活动编码',
    campaign_type ENUM('discount', 'coupon', 'flash_sale', 'group_buy', 'lottery', 'points_exchange') NOT NULL COMMENT '活动类型',
    description TEXT COMMENT '活动描述',
    
    -- 活动规则
    rule_config JSON NOT NULL COMMENT '活动规则配置',
    discount_config JSON COMMENT '优惠配置',
    target_config JSON COMMENT '目标客户配置',
    trigger_config JSON COMMENT '触发条件配置',
    
    -- 活动范围
    applicable_products JSON COMMENT '适用商品',
    applicable_categories JSON COMMENT '适用分类',
    exclude_products JSON COMMENT '排除商品',
    
    -- 活动限制
    usage_limit_per_user INT COMMENT '每用户使用限制',
    total_usage_limit INT COMMENT '总使用限制',
    min_order_amount DECIMAL(10,2) COMMENT '最小订单金额',
    max_discount_amount DECIMAL(10,2) COMMENT '最大优惠金额',
    
    -- 时间管理
    start_time TIMESTAMP NOT NULL COMMENT '开始时间',
    end_time TIMESTAMP NOT NULL COMMENT '结束时间',
    is_time_limited BOOLEAN DEFAULT TRUE COMMENT '是否限时',
    
    -- 状态管理
    status ENUM('draft', 'pending_review', 'approved', 'active', 'paused', 'ended', 'cancelled') DEFAULT 'draft' COMMENT '活动状态',
    
    -- 统计信息 (生命周期跟踪)
    total_participants INT DEFAULT 0 COMMENT '参与人数',
    total_orders INT DEFAULT 0 COMMENT '订单数量',
    total_revenue DECIMAL(15,2) DEFAULT 0 COMMENT '总收入',
    total_discount DECIMAL(15,2) DEFAULT 0 COMMENT '总优惠金额',
    conversion_rate DECIMAL(5,2) DEFAULT 0 COMMENT '转化率',
    
    -- 审核信息
    reviewed_by VARCHAR(36) COMMENT '审核人ID',
    reviewed_at TIMESTAMP NULL COMMENT '审核时间',
    review_notes TEXT COMMENT '审核备注',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    
    -- 唯一约束
    UNIQUE KEY uk_tenant_campaign_code (tenant_id, campaign_code),
    
    -- 索引设计
    INDEX idx_tenant_type (tenant_id, campaign_type),
    INDEX idx_status (status),
    INDEX idx_time_range (start_time, end_time),
    INDEX idx_stats (total_participants, total_revenue),
    
    CONSTRAINT chk_time_range CHECK (end_time > start_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='营销活动表';

-- 优惠券表
CREATE TABLE marketing_coupons (
    id VARCHAR(36) PRIMARY KEY COMMENT '优惠券ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    campaign_id VARCHAR(36) COMMENT '所属活动ID',
    
    -- 优惠券基本信息
    coupon_code VARCHAR(50) NOT NULL COMMENT '优惠券码',
    coupon_name VARCHAR(200) NOT NULL COMMENT '优惠券名称',
    coupon_type ENUM('fixed_amount', 'percentage', 'free_shipping', 'gift') NOT NULL COMMENT '优惠券类型',
    
    -- 优惠信息
    discount_value DECIMAL(10,2) NOT NULL COMMENT '优惠值',
    min_order_amount DECIMAL(10,2) DEFAULT 0 COMMENT '最小订单金额',
    max_discount_amount DECIMAL(10,2) COMMENT '最大优惠金额',
    
    -- 使用限制
    usage_limit INT DEFAULT 1 COMMENT '使用次数限制',
    used_count INT DEFAULT 0 COMMENT '已使用次数',
    is_transferable BOOLEAN DEFAULT FALSE COMMENT '是否可转赠',
    
    -- 适用范围
    applicable_products JSON COMMENT '适用商品',
    applicable_categories JSON COMMENT '适用分类',
    
    -- 时间管理
    start_time TIMESTAMP NOT NULL COMMENT '生效时间',
    end_time TIMESTAMP NOT NULL COMMENT '失效时间',
    
    -- 状态管理
    status ENUM('active', 'used', 'expired', 'disabled') DEFAULT 'active' COMMENT '状态',
    
    -- 用户信息
    issued_to_user VARCHAR(36) COMMENT '发放给用户ID',
    used_by_user VARCHAR(36) COMMENT '使用者ID',
    used_order_id VARCHAR(36) COMMENT '使用订单ID',
    used_at TIMESTAMP NULL COMMENT '使用时间',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    -- 唯一约束
    UNIQUE KEY uk_coupon_code (coupon_code),
    
    -- 索引设计
    INDEX idx_tenant_campaign (tenant_id, campaign_id),
    INDEX idx_coupon_type (coupon_type),
    INDEX idx_status (status),
    INDEX idx_issued_to_user (issued_to_user),
    INDEX idx_used_by_user (used_by_user),
    INDEX idx_time_range (start_time, end_time),
    
    FOREIGN KEY (campaign_id) REFERENCES marketing_campaigns(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='优惠券表';

-- 营销活动参与记录表
CREATE TABLE marketing_participations (
    id VARCHAR(36) PRIMARY KEY COMMENT '参与记录ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    campaign_id VARCHAR(36) NOT NULL COMMENT '活动ID',
    
    -- 参与者信息
    participant_type ENUM('customer', 'guest', 'member') NOT NULL COMMENT '参与者类型',
    participant_id VARCHAR(36) COMMENT '参与者ID',
    participant_info JSON COMMENT '参与者信息快照',
    
    -- 参与信息
    participation_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '参与时间',
    participation_source ENUM('web', 'app', 'wework', 'sms', 'email') COMMENT '参与来源',
    participation_channel VARCHAR(50) COMMENT '参与渠道',
    
    -- 参与结果
    participation_result ENUM('success', 'failed', 'pending') DEFAULT 'pending' COMMENT '参与结果',
    result_data JSON COMMENT '结果数据',
    rewards JSON COMMENT '获得奖励',
    
    -- 后续行为
    has_placed_order BOOLEAN DEFAULT FALSE COMMENT '是否下单',
    order_id VARCHAR(36) COMMENT '关联订单ID',
    order_amount DECIMAL(12,2) COMMENT '订单金额',
    
    -- 客户端信息
    user_agent TEXT COMMENT '用户代理',
    ip_address VARCHAR(45) COMMENT 'IP地址',
    device_info JSON COMMENT '设备信息',
    
    INDEX idx_tenant_campaign (tenant_id, campaign_id),
    INDEX idx_participant (participant_type, participant_id),
    INDEX idx_participation_time (participation_time),
    INDEX idx_order_id (order_id),
    INDEX idx_has_placed_order (has_placed_order),
    
    FOREIGN KEY (campaign_id) REFERENCES marketing_campaigns(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='营销活动参与记录表';

-- A/B测试表
CREATE TABLE marketing_ab_tests (
    id VARCHAR(36) PRIMARY KEY COMMENT '测试ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 测试基本信息
    test_name VARCHAR(200) NOT NULL COMMENT '测试名称',
    test_description TEXT COMMENT '测试描述',
    test_type ENUM('campaign', 'ui', 'pricing', 'content') NOT NULL COMMENT '测试类型',
    
    -- 测试配置
    test_config JSON NOT NULL COMMENT '测试配置',
    variant_configs JSON NOT NULL COMMENT '变体配置',
    traffic_allocation JSON NOT NULL COMMENT '流量分配',
    
    -- 测试目标
    primary_metric VARCHAR(100) NOT NULL COMMENT '主要指标',
    secondary_metrics JSON COMMENT '次要指标',
    success_criteria JSON COMMENT '成功标准',
    
    -- 时间管理
    start_time TIMESTAMP NOT NULL COMMENT '开始时间',
    end_time TIMESTAMP NOT NULL COMMENT '结束时间',
    
    -- 状态管理
    status ENUM('draft', 'running', 'paused', 'completed', 'cancelled') DEFAULT 'draft' COMMENT '测试状态',
    
    -- 统计信息
    total_participants INT DEFAULT 0 COMMENT '参与者总数',
    variant_stats JSON COMMENT '变体统计数据',
    test_results JSON COMMENT '测试结果',
    winner_variant VARCHAR(50) COMMENT '获胜变体',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    
    INDEX idx_tenant_type (tenant_id, test_type),
    INDEX idx_status (status),
    INDEX idx_time_range (start_time, end_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='A/B测试表';

-- =====================================================
-- 4. 创建视图
-- =====================================================

-- 服务销售概览视图
CREATE VIEW v_service_sales_overview AS
SELECT 
    s.id,
    s.tenant_id,
    s.service_code,
    s.service_name,
    s.service_type,
    s.delivery_mode,
    s.category_id,
    c.category_name,
    s.base_price,
    s.sale_price,
    s.pricing_model,
    s.max_concurrent_bookings,
    s.available_slots,
    s.booked_slots,
    s.booking_count,
    s.completed_count,
    s.revenue,
    s.rating_average,
    s.review_count,
    COUNT(DISTINCT sv.id) as variant_count,
    MIN(sv.price) as min_variant_price,
    MAX(sv.price) as max_variant_price,
    SUM(sv.capacity) as total_variant_capacity,
    sp.provider_name as default_provider_name,
    s.status,
    s.created_at
FROM services s
LEFT JOIN service_categories c ON s.category_id = c.id
LEFT JOIN service_variants sv ON s.id = sv.service_id AND sv.status = 'active'
LEFT JOIN service_providers sp ON s.default_provider_id = sp.id
WHERE s.status != 'discontinued'
GROUP BY s.id, s.tenant_id, s.service_code, s.service_name, s.service_type,
         s.delivery_mode, s.category_id, c.category_name, s.base_price, 
         s.sale_price, s.pricing_model, s.max_concurrent_bookings, 
         s.available_slots, s.booked_slots, s.booking_count, s.completed_count,
         s.revenue, s.rating_average, s.review_count, sp.provider_name,
         s.status, s.created_at;

-- 服务订单概览视图
CREATE VIEW v_service_order_overview AS
SELECT 
    o.id,
    o.tenant_id,
    o.order_no,
    o.customer_id,
    o.order_type,
    o.order_status,
    o.payment_status,
    o.service_status,
    o.service_location_type,
    o.service_date,
    o.service_time_start,
    o.service_time_end,
    o.estimated_duration_minutes,
    o.actual_duration_minutes,
    o.total_amount,
    o.paid_amount,
    o.assigned_provider_id,
    sp.provider_name,
    COUNT(DISTINCT oi.id) as service_item_count,
    SUM(oi.quantity) as total_service_quantity,
    AVG(oi.quality_score) as avg_quality_score,
    o.order_time,
    o.payment_time,
    o.assigned_time,
    o.service_start_time,
    o.service_end_time,
    o.complete_time,
    TIMESTAMPDIFF(HOUR, o.order_time, o.payment_time) as payment_duration_hours,
    TIMESTAMPDIFF(HOUR, o.payment_time, o.service_start_time) as preparation_duration_hours,
    TIMESTAMPDIFF(MINUTE, o.service_start_time, o.service_end_time) as actual_service_duration_minutes,
    o.reschedule_count,
    o.created_at
FROM service_orders o
LEFT JOIN service_order_items oi ON o.id = oi.order_id
LEFT JOIN service_providers sp ON o.assigned_provider_id = sp.id
GROUP BY o.id, o.tenant_id, o.order_no, o.customer_id, o.order_type, o.order_status,
         o.payment_status, o.service_status, o.service_location_type, o.service_date,
         o.service_time_start, o.service_time_end, o.estimated_duration_minutes, 
         o.actual_duration_minutes, o.total_amount, o.paid_amount, o.assigned_provider_id,
         sp.provider_name, o.order_time, o.payment_time, o.assigned_time, 
         o.service_start_time, o.service_end_time, o.complete_time, o.reschedule_count, o.created_at;

-- 营销活动效果视图
CREATE VIEW v_campaign_performance AS
SELECT 
    c.id,
    c.tenant_id,
    c.campaign_name,
    c.campaign_type,
    c.status,
    c.start_time,
    c.end_time,
    c.total_participants,
    c.total_orders,
    c.total_revenue,
    c.total_discount,
    c.conversion_rate,
    CASE 
        WHEN c.total_participants > 0 THEN (c.total_orders * 100.0 / c.total_participants)
        ELSE 0 
    END as actual_conversion_rate,
    CASE 
        WHEN c.total_discount > 0 THEN (c.total_revenue / c.total_discount)
        ELSE 0 
    END as roi,
    DATEDIFF(c.end_time, c.start_time) as campaign_duration_days,
    COUNT(DISTINCT coup.id) as coupon_count,
    COUNT(DISTINCT ab.id) as ab_test_count
FROM marketing_campaigns c
LEFT JOIN marketing_coupons coup ON c.id = coup.campaign_id
LEFT JOIN marketing_ab_tests ab ON c.tenant_id = ab.tenant_id
WHERE c.status != 'draft'
GROUP BY c.id, c.tenant_id, c.campaign_name, c.campaign_type, c.status,
         c.start_time, c.end_time, c.total_participants, c.total_orders,
         c.total_revenue, c.total_discount, c.conversion_rate;

-- =====================================================
-- 5. 创建存储过程
-- =====================================================

DELIMITER //

-- 更新服务容量
CREATE PROCEDURE sp_update_service_capacity(
    IN p_capacity_type ENUM('service', 'variant', 'time_slot'),
    IN p_capacity_id VARCHAR(36),
    IN p_change_type ENUM('book', 'cancel', 'complete', 'adjust', 'block', 'release'),
    IN p_change_quantity INT,
    IN p_business_type ENUM('booking', 'cancellation', 'completion', 'adjustment', 'maintenance'),
    IN p_business_id VARCHAR(36),
    IN p_booking_id VARCHAR(36),
    IN p_reason VARCHAR(500),
    IN p_operator_id VARCHAR(36),
    IN p_customer_id VARCHAR(36)
)
BEGIN
    DECLARE v_tenant_id VARCHAR(36);
    DECLARE v_before_capacity INT;
    DECLARE v_after_capacity INT;
    DECLARE v_service_date DATE;
    DECLARE v_service_time_start TIME;
    DECLARE v_service_time_end TIME;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
    
    START TRANSACTION;
    
    -- 获取当前容量
    IF p_capacity_type = 'service' THEN
        SELECT tenant_id, available_slots 
        INTO v_tenant_id, v_before_capacity
        FROM services WHERE id = p_capacity_id FOR UPDATE;
        
        -- 计算变更后容量
        SET v_after_capacity = v_before_capacity + 
            CASE 
                WHEN p_change_type IN ('cancel', 'release') THEN p_change_quantity
                WHEN p_change_type IN ('book', 'block') THEN -p_change_quantity
                ELSE p_change_quantity  -- adjust, complete
            END;
        
        -- 检查容量不能为负
        IF v_after_capacity < 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '服务容量不足';
        END IF;
        
        -- 更新服务容量
        UPDATE services 
        SET available_slots = v_after_capacity,
            booked_slots = CASE 
                WHEN p_change_type = 'book' THEN booked_slots + p_change_quantity
                WHEN p_change_type IN ('cancel', 'complete') THEN booked_slots - p_change_quantity
                ELSE booked_slots
            END,
            updated_at = NOW()
        WHERE id = p_capacity_id;
        
    ELSEIF p_capacity_type = 'variant' THEN
        SELECT s.tenant_id, sv.capacity 
        INTO v_tenant_id, v_before_capacity
        FROM service_variants sv 
        JOIN services s ON sv.service_id = s.id
        WHERE sv.id = p_capacity_id FOR UPDATE;
        
        -- 计算变更后容量
        SET v_after_capacity = v_before_capacity + 
            CASE 
                WHEN p_change_type IN ('cancel', 'release') THEN p_change_quantity
                WHEN p_change_type IN ('book', 'block') THEN -p_change_quantity
                ELSE p_change_quantity
            END;
        
        -- 检查容量不能为负
        IF v_after_capacity < 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '服务变体容量不足';
        END IF;
        
        -- 更新变体容量
        UPDATE service_variants 
        SET capacity = v_after_capacity,
            booked_capacity = CASE 
                WHEN p_change_type = 'book' THEN booked_capacity + p_change_quantity
                WHEN p_change_type IN ('cancel', 'complete') THEN booked_capacity - p_change_quantity
                ELSE booked_capacity
            END,
            updated_at = NOW()
        WHERE id = p_capacity_id;
        
    ELSE  -- time_slot
        SELECT s.tenant_id, sts.available_capacity, sts.slot_date, sts.start_time, sts.end_time
        INTO v_tenant_id, v_before_capacity, v_service_date, v_service_time_start, v_service_time_end
        FROM service_time_slots sts 
        JOIN services s ON sts.service_id = s.id
        WHERE sts.id = p_capacity_id FOR UPDATE;
        
        -- 计算变更后容量
        SET v_after_capacity = v_before_capacity + 
            CASE 
                WHEN p_change_type IN ('cancel', 'release') THEN p_change_quantity
                WHEN p_change_type IN ('book', 'block') THEN -p_change_quantity
                ELSE p_change_quantity
            END;
        
        -- 检查容量不能为负
        IF v_after_capacity < 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '时段容量不足';
        END IF;
        
        -- 更新时段容量
        UPDATE service_time_slots 
        SET current_bookings = CASE 
                WHEN p_change_type = 'book' THEN current_bookings + p_change_quantity
                WHEN p_change_type IN ('cancel', 'complete') THEN current_bookings - p_change_quantity
                ELSE current_bookings
            END,
            status = CASE 
                WHEN p_change_type = 'book' AND (current_bookings + p_change_quantity) >= max_bookings THEN 'booked'
                WHEN p_change_type IN ('cancel', 'complete') AND current_bookings > 0 THEN 'available'
                WHEN p_change_type = 'block' THEN 'blocked'
                WHEN p_change_type = 'complete' THEN 'completed'
                ELSE status
            END,
            updated_at = NOW()
        WHERE id = p_capacity_id;
    END IF;
    
    -- 记录服务容量变动日志
    INSERT INTO service_capacity_logs (
        id, tenant_id, capacity_type, capacity_id, change_type, 
        change_quantity, before_capacity, after_capacity,
        business_type, business_id, booking_id, reason, operator_id, customer_id,
        service_date, service_time_start, service_time_end
    ) VALUES (
        UUID(), v_tenant_id, p_capacity_type, p_capacity_id, p_change_type,
        p_change_quantity, v_before_capacity, v_after_capacity,
        p_business_type, p_business_id, p_booking_id, p_reason, p_operator_id, p_customer_id,
        v_service_date, v_service_time_start, v_service_time_end
    );
    
    COMMIT;
    
    SELECT '服务容量更新成功' as result;
END //

-- 创建服务订单
CREATE PROCEDURE sp_create_service_order(
    IN p_tenant_id VARCHAR(36),
    IN p_order_no VARCHAR(50),
    IN p_customer_id VARCHAR(36),
    IN p_service_date DATE,
    IN p_service_time_start TIME,
    IN p_service_time_end TIME,
    IN p_service_location_type ENUM('online', 'onsite', 'office', 'third_party'),
    IN p_service_address JSON,
    IN p_order_items JSON,
    IN p_coupon_codes JSON,
    OUT p_order_id VARCHAR(36),
    OUT p_total_amount DECIMAL(12,2)
)
BEGIN
    DECLARE v_subtotal DECIMAL(12,2) DEFAULT 0;
    DECLARE v_discount_amount DECIMAL(12,2) DEFAULT 0;
    DECLARE v_service_fee DECIMAL(12,2) DEFAULT 0;
    DECLARE v_travel_fee DECIMAL(12,2) DEFAULT 0;
    DECLARE v_total_amount DECIMAL(12,2);
    DECLARE v_item JSON;
    DECLARE v_i INT DEFAULT 0;
    DECLARE v_item_count INT;
    DECLARE v_estimated_duration INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
    
    START TRANSACTION;
    
    -- 生成订单ID
    SET p_order_id = UUID();
    
    -- 获取订单项数量
    SET v_item_count = JSON_LENGTH(p_order_items);
    
    -- 计算服务小计和总时长
    WHILE v_i < v_item_count DO
        SET v_item = JSON_EXTRACT(p_order_items, CONCAT('$[', v_i, ']'));
        SET v_subtotal = v_subtotal + 
            (JSON_UNQUOTE(JSON_EXTRACT(v_item, '$.unit_price')) * 
             JSON_UNQUOTE(JSON_EXTRACT(v_item, '$.quantity')));
        SET v_estimated_duration = v_estimated_duration + 
            IFNULL(JSON_UNQUOTE(JSON_EXTRACT(v_item, '$.duration_minutes')), 60);
        SET v_i = v_i + 1;
    END WHILE;
    
    -- 计算优惠金额 (简化处理)
    SET v_discount_amount = 0;
    
    -- 计算服务费 (简化处理)
    SET v_service_fee = 0;
    
    -- 计算上门费/交通费 (如果是上门服务)
    SET v_travel_fee = CASE WHEN p_service_location_type = 'onsite' THEN 50 ELSE 0 END;
    
    -- 计算总金额
    SET v_total_amount = v_subtotal + v_service_fee + v_travel_fee - v_discount_amount;
    SET p_total_amount = v_total_amount;
    
    -- 创建服务订单
    INSERT INTO service_orders (
        id, tenant_id, order_no, customer_id, order_source, order_type,
        service_date, service_time_start, service_time_end, estimated_duration_minutes,
        service_location_type, service_address,
        subtotal, service_fee, travel_fee, discount_amount, total_amount,
        coupon_codes, order_time
    ) VALUES (
        p_order_id, p_tenant_id, p_order_no, p_customer_id, 'api', 'scheduled',
        p_service_date, p_service_time_start, p_service_time_end, v_estimated_duration,
        p_service_location_type, p_service_address,
        v_subtotal, v_service_fee, v_travel_fee, v_discount_amount, v_total_amount,
        p_coupon_codes, NOW()
    );
    
    -- 创建服务订单项
    SET v_i = 0;
    WHILE v_i < v_item_count DO
        SET v_item = JSON_EXTRACT(p_order_items, CONCAT('$[', v_i, ']'));
        
        INSERT INTO service_order_items (
            id, tenant_id, order_id, service_id, variant_id,
            service_name, unit_price, quantity, subtotal, final_price,
            duration_minutes, travel_fee
        ) VALUES (
            UUID(), p_tenant_id, p_order_id,
            JSON_UNQUOTE(JSON_EXTRACT(v_item, '$.service_id')),
            JSON_UNQUOTE(JSON_EXTRACT(v_item, '$.variant_id')),
            JSON_UNQUOTE(JSON_EXTRACT(v_item, '$.service_name')),
            JSON_UNQUOTE(JSON_EXTRACT(v_item, '$.unit_price')),
            JSON_UNQUOTE(JSON_EXTRACT(v_item, '$.quantity')),
            JSON_UNQUOTE(JSON_EXTRACT(v_item, '$.unit_price')) * 
            JSON_UNQUOTE(JSON_EXTRACT(v_item, '$.quantity')),
            JSON_UNQUOTE(JSON_EXTRACT(v_item, '$.unit_price')) * 
            JSON_UNQUOTE(JSON_EXTRACT(v_item, '$.quantity')),
            JSON_UNQUOTE(JSON_EXTRACT(v_item, '$.duration_minutes')),
            CASE WHEN p_service_location_type = 'onsite' THEN v_travel_fee / v_item_count ELSE 0 END
        );
        
        SET v_i = v_i + 1;
    END WHILE;
    
    -- 记录订单状态历史
    INSERT INTO service_order_status_history (
        id, tenant_id, order_id, old_status, new_status,
        change_reason, operator_type, service_date, service_time
    ) VALUES (
        UUID(), p_tenant_id, p_order_id, NULL, 'pending_payment',
        '服务订单创建', 'customer', p_service_date, p_service_time_start
    );
    
    COMMIT;
    
END //

-- 更新服务订单状态
CREATE PROCEDURE sp_update_service_order_status(
    IN p_order_id VARCHAR(36),
    IN p_new_status ENUM('pending_payment', 'paid', 'confirmed', 'assigned', 'preparing', 'in_progress', 'completed', 'cancelled', 'refunded', 'rescheduled'),
    IN p_change_reason VARCHAR(500),
    IN p_operator_type ENUM('customer', 'admin', 'system', 'payment_gateway', 'provider', 'auto_scheduler'),
    IN p_operator_id VARCHAR(36),
    IN p_provider_id VARCHAR(36)
)
BEGIN
    DECLARE v_tenant_id VARCHAR(36);
    DECLARE v_old_status ENUM('pending_payment', 'paid', 'confirmed', 'assigned', 'preparing', 'in_progress', 'completed', 'cancelled', 'refunded', 'rescheduled');
    DECLARE v_service_date DATE;
    DECLARE v_service_time TIME;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
    
    START TRANSACTION;
    
    -- 获取当前状态和服务信息
    SELECT tenant_id, order_status, service_date, service_time_start
    INTO v_tenant_id, v_old_status, v_service_date, v_service_time
    FROM service_orders WHERE id = p_order_id FOR UPDATE;
    
    -- 更新服务订单状态
    UPDATE service_orders 
    SET order_status = p_new_status,
        payment_time = CASE WHEN p_new_status = 'paid' THEN NOW() ELSE payment_time END,
        confirm_time = CASE WHEN p_new_status = 'confirmed' THEN NOW() ELSE confirm_time END,
        assigned_time = CASE WHEN p_new_status = 'assigned' THEN NOW() ELSE assigned_time END,
        service_start_time = CASE WHEN p_new_status = 'in_progress' THEN NOW() ELSE service_start_time END,
        service_end_time = CASE WHEN p_new_status = 'completed' THEN NOW() ELSE service_end_time END,
        complete_time = CASE WHEN p_new_status = 'completed' THEN NOW() ELSE complete_time END,
        cancel_time = CASE WHEN p_new_status = 'cancelled' THEN NOW() ELSE cancel_time END,
        assigned_provider_id = CASE WHEN p_new_status = 'assigned' AND p_provider_id IS NOT NULL THEN p_provider_id ELSE assigned_provider_id END,
        provider_assigned_at = CASE WHEN p_new_status = 'assigned' AND p_provider_id IS NOT NULL THEN NOW() ELSE provider_assigned_at END,
        actual_duration_minutes = CASE 
            WHEN p_new_status = 'completed' AND service_start_time IS NOT NULL THEN 
                TIMESTAMPDIFF(MINUTE, service_start_time, NOW())
            ELSE actual_duration_minutes 
        END,
        updated_at = NOW()
    WHERE id = p_order_id;
    
    -- 更新服务状态
    UPDATE service_orders 
    SET service_status = CASE 
        WHEN p_new_status = 'preparing' THEN 'preparing'
        WHEN p_new_status = 'in_progress' THEN 'in_progress'
        WHEN p_new_status = 'completed' THEN 'completed'
        WHEN p_new_status = 'cancelled' THEN 'cancelled'
        ELSE service_status
    END
    WHERE id = p_order_id;
    
    -- 记录状态变更历史
    INSERT INTO service_order_status_history (
        id, tenant_id, order_id, old_status, new_status,
        change_reason, operator_type, operator_id, provider_id,
        service_date, service_time
    ) VALUES (
        UUID(), v_tenant_id, p_order_id, v_old_status, p_new_status,
        p_change_reason, p_operator_type, p_operator_id, p_provider_id,
        v_service_date, v_service_time
    );
    
    COMMIT;
    
    SELECT '服务订单状态更新成功' as result;
END //

DELIMITER ;

-- =====================================================
-- 6. 创建定时任务
-- =====================================================

-- 启用事件调度器
SET GLOBAL event_scheduler = ON;

-- 创建服务容量预警检查任务
CREATE EVENT IF NOT EXISTS check_low_capacity_services
ON SCHEDULE EVERY 1 HOUR
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    -- 检查服务容量预警
    INSERT INTO service_capacity_logs (
        id, tenant_id, capacity_type, capacity_id, change_type,
        change_quantity, before_capacity, after_capacity,
        business_type, reason
    )
    SELECT 
        UUID(), tenant_id, 'service', id, 'adjust',
        0, available_slots, available_slots,
        'adjustment', CONCAT('容量预警: 当前可用时段 ', available_slots, ', 预警阈值 ', min_capacity_threshold)
    FROM services 
    WHERE available_slots <= min_capacity_threshold 
    AND min_capacity_threshold > 0
    AND status = 'active';
END;

-- 创建过期优惠券清理任务
CREATE EVENT IF NOT EXISTS cleanup_expired_coupons
ON SCHEDULE EVERY 1 DAY
STARTS DATE_ADD(CURDATE(), INTERVAL 2 HOUR)
DO
BEGIN
    UPDATE marketing_coupons 
    SET status = 'expired'
    WHERE status = 'active' 
    AND end_time < NOW();
END;

-- 创建服务订单超时处理任务
CREATE EVENT IF NOT EXISTS handle_timeout_service_orders
ON SCHEDULE EVERY 10 MINUTE
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    -- 处理超时未支付的服务订单
    UPDATE service_orders 
    SET order_status = 'cancelled',
        cancel_time = NOW(),
        cancellation_reason = '订单支付超时自动取消',
        cancelled_by = 'system',
        updated_at = NOW()
    WHERE order_status = 'pending_payment' 
    AND order_time < DATE_SUB(NOW(), INTERVAL 30 MINUTE);
    
    -- 记录服务订单状态变更历史
    INSERT INTO service_order_status_history (
        id, tenant_id, order_id, old_status, new_status,
        change_reason, operator_type
    )
    SELECT 
        UUID(), tenant_id, id, 'pending_payment', 'cancelled',
        '服务订单支付超时自动取消', 'system'
    FROM service_orders 
    WHERE order_status = 'cancelled'
    AND cancel_time = updated_at
    AND cancelled_by = 'system';
    
    -- 处理过期的服务时段
    UPDATE service_time_slots 
    SET status = 'completed'
    WHERE status IN ('available', 'booked')
    AND TIMESTAMP(slot_date, end_time) < NOW();
END;

-- =====================================================
-- 7. 插入初始数据
-- =====================================================

-- 插入默认服务分类
INSERT INTO service_categories (id, tenant_id, category_name, category_code, description, service_type, requires_appointment, level) VALUES
(UUID(), 'default-tenant', '企业咨询服务', 'consultation', '企业管理、战略规划等咨询服务', 'consultation', TRUE, 1),
(UUID(), 'default-tenant', '技术维护服务', 'maintenance', 'IT设备、系统维护等技术服务', 'maintenance', TRUE, 1),
(UUID(), 'default-tenant', '培训教育服务', 'training', '企业培训、技能提升等教育服务', 'training', TRUE, 1),
(UUID(), 'default-tenant', '客户支持服务', 'support', '售后支持、客户服务等支持服务', 'support', FALSE, 1),
(UUID(), 'default-tenant', '定制开发服务', 'custom', '软件开发、定制解决方案等服务', 'custom', TRUE, 1);

-- 插入默认服务提供商
INSERT INTO service_providers (id, tenant_id, provider_code, provider_name, provider_type, contact_person, phone, email, specialties, working_hours, max_concurrent_services) VALUES
(UUID(), 'default-tenant', 'PROVIDER001', '高级咨询师张三', 'individual', '张三', '13800138001', 'zhangsan@example.com', '["企业管理", "战略规划", "组织架构"]', '{"monday": {"start": "09:00", "end": "18:00"}, "tuesday": {"start": "09:00", "end": "18:00"}}', 2),
(UUID(), 'default-tenant', 'PROVIDER002', '技术专家李四', 'individual', '李四', '13800138002', 'lisi@example.com', '["系统维护", "网络安全", "数据库管理"]', '{"monday": {"start": "08:00", "end": "20:00"}, "tuesday": {"start": "08:00", "end": "20:00"}}', 3);

-- 插入示例服务
INSERT INTO services (id, tenant_id, service_code, service_name, category_id, service_type, delivery_mode, base_price, sale_price, pricing_model, max_concurrent_bookings, available_slots, duration_minutes, requires_appointment, advance_booking_hours, default_provider_id, description) 
SELECT 
    UUID(), 'default-tenant', 'SVC001', '企业管理咨询服务', 
    c.id, 'consultation', 'hybrid', 500.00, 450.00, 'hourly', 2, 20, 120, TRUE, 48,
    p.id, '专业的企业管理咨询服务，包括组织架构优化、流程梳理等'
FROM service_categories c, service_providers p 
WHERE c.category_code = 'consultation' AND p.provider_code = 'PROVIDER001' LIMIT 1;

INSERT INTO services (id, tenant_id, service_code, service_name, category_id, service_type, delivery_mode, base_price, sale_price, pricing_model, max_concurrent_bookings, available_slots, duration_minutes, requires_appointment, advance_booking_hours, default_provider_id, description) 
SELECT 
    UUID(), 'default-tenant', 'SVC002', '系统维护服务', 
    c.id, 'maintenance', 'onsite', 200.00, 180.00, 'fixed', 1, 10, 240, TRUE, 24,
    p.id, '专业的IT系统维护服务，包括硬件检修、软件更新等'
FROM service_categories c, service_providers p 
WHERE c.category_code = 'maintenance' AND p.provider_code = 'PROVIDER002' LIMIT 1;

-- 插入默认营销活动
INSERT INTO marketing_campaigns (id, tenant_id, campaign_name, campaign_code, campaign_type, rule_config, start_time, end_time, status) VALUES
(UUID(), 'default-tenant', '新用户专享', 'new_user_discount', 'discount', '{"discount_type": "percentage", "discount_value": 10}', NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 'active'),
(UUID(), 'default-tenant', '满额免运费', 'free_shipping', 'discount', '{"free_shipping": true, "min_amount": 99}', NOW(), DATE_ADD(NOW(), INTERVAL 60 DAY), 'active');

-- =====================================================
-- 完成提示
-- =====================================================

SELECT '🛒 服务类核心业务平台数据库初始化完成！' as message;
SELECT '📊 包含服务管理、预约订单、营销管理、服务提供商管理等核心功能' as features;
SELECT '🔧 已创建视图、存储过程和定时任务用于服务业务自动化' as additional_features;
SELECT '📈 支持完整的服务生命周期、预约管理和订单流转' as business_features;
SELECT '🎯 营销活动、优惠券、A/B测试全面支持服务类商品' as marketing_features;
SELECT '⏰ 服务时段管理、容量控制、提供商调度等服务特色功能' as service_features;
SELECT '📋 支持在线、上门、混合等多种服务交付模式' as delivery_features;