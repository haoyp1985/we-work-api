-- =====================================================
-- SaaS统一核心层数据库设计
-- 包含：身份管理、安全审计、配额计费、系统管理
-- =====================================================

-- 创建核心数据库
CREATE DATABASE IF NOT EXISTS `saas_unified_core` 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `saas_unified_core`;

-- =====================================================
-- 1. 核心身份管理层
-- =====================================================

-- 租户主表
CREATE TABLE saas_tenants (
    id VARCHAR(36) PRIMARY KEY COMMENT '租户ID - UUID格式',
    tenant_code VARCHAR(50) UNIQUE NOT NULL COMMENT '租户编码 - 全局唯一',
    tenant_name VARCHAR(100) NOT NULL COMMENT '租户名称',
    tenant_type ENUM('enterprise', 'individual', 'trial', 'partner') DEFAULT 'enterprise' COMMENT '租户类型',
    
    -- 企业信息
    company_info JSON COMMENT '企业信息(统一社会信用代码、法人等)',
    contact_info JSON COMMENT '联系信息(联系人、邮箱、电话、地址)',
    business_info JSON COMMENT '业务信息(行业、规模、地区)',
    
    -- 订阅信息
    subscription_plan VARCHAR(50) DEFAULT 'basic' COMMENT '订阅计划',
    subscription_start_date DATE COMMENT '订阅开始日期',
    subscription_end_date DATE COMMENT '订阅结束日期',
    billing_cycle ENUM('monthly', 'quarterly', 'yearly') DEFAULT 'monthly' COMMENT '计费周期',
    
    -- 技术配置
    tenant_config JSON COMMENT '租户技术配置',
    custom_domain VARCHAR(100) COMMENT '自定义域名',
    logo_url VARCHAR(500) COMMENT '租户Logo URL',
    theme_config JSON COMMENT '主题配置',
    
    -- 集成配置
    integration_config JSON COMMENT '第三方集成配置',
    webhook_endpoints JSON COMMENT 'Webhook端点配置',
    api_rate_limits JSON COMMENT 'API限流配置',
    
    -- 状态管理
    status ENUM('active', 'suspended', 'expired', 'deleted', 'trial', 'beta') DEFAULT 'active' COMMENT '租户状态',
    suspension_reason VARCHAR(500) COMMENT '暂停原因',
    
    -- 功能开关
    enabled_modules JSON COMMENT '启用的模块列表',
    feature_flags JSON COMMENT '功能开关配置',
    
    -- 资源限制
    resource_limits JSON COMMENT '资源使用限制',
    storage_quota_gb DECIMAL(10,2) DEFAULT 10.00 COMMENT '存储配额(GB)',
    bandwidth_quota_gb DECIMAL(10,2) DEFAULT 100.00 COMMENT '带宽配额(GB)',
    
    -- 安全配置
    security_config JSON COMMENT '安全策略配置',
    ip_whitelist JSON COMMENT 'IP白名单',
    allowed_login_hours JSON COMMENT '允许登录时间段',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    updated_by VARCHAR(36) COMMENT '更新人ID',
    
    -- 索引设计
    INDEX idx_tenant_code (tenant_code),
    INDEX idx_status (status),
    INDEX idx_subscription_plan (subscription_plan),
    INDEX idx_subscription_end (subscription_end_date),
    INDEX idx_created_at (created_at),
    INDEX idx_tenant_type (tenant_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='SaaS租户主表';

-- 用户主表
CREATE TABLE saas_users (
    id VARCHAR(36) PRIMARY KEY COMMENT '用户ID - UUID格式',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 基本信息
    username VARCHAR(50) NOT NULL COMMENT '用户名 - 租户内唯一',
    email VARCHAR(100) COMMENT '邮箱地址',
    phone VARCHAR(20) COMMENT '手机号码',
    password_hash VARCHAR(255) NOT NULL COMMENT '密码哈希',
    
    -- 个人信息
    profile JSON COMMENT '个人信息(姓名、性别、生日、头像等)',
    department VARCHAR(100) COMMENT '部门',
    position VARCHAR(100) COMMENT '职位',
    employee_id VARCHAR(50) COMMENT '工号',
    
    -- 状态管理
    status ENUM('active', 'inactive', 'locked', 'deleted', 'pending_activation') DEFAULT 'active' COMMENT '用户状态',
    is_super_admin BOOLEAN DEFAULT FALSE COMMENT '是否超级管理员',
    is_tenant_admin BOOLEAN DEFAULT FALSE COMMENT '是否租户管理员',
    
    -- 验证状态
    email_verified BOOLEAN DEFAULT FALSE COMMENT '邮箱是否已验证',
    phone_verified BOOLEAN DEFAULT FALSE COMMENT '手机是否已验证',
    identity_verified BOOLEAN DEFAULT FALSE COMMENT '身份是否已验证',
    
    -- 登录信息
    last_login_at TIMESTAMP NULL COMMENT '最后登录时间',
    last_login_ip VARCHAR(45) COMMENT '最后登录IP',
    last_login_device VARCHAR(200) COMMENT '最后登录设备',
    login_failure_count INT DEFAULT 0 COMMENT '登录失败次数',
    locked_until TIMESTAMP NULL COMMENT '锁定到期时间',
    
    -- 密码策略
    password_changed_at TIMESTAMP NULL COMMENT '密码修改时间',
    must_change_password BOOLEAN DEFAULT FALSE COMMENT '是否必须修改密码',
    password_never_expires BOOLEAN DEFAULT FALSE COMMENT '密码是否永不过期',
    
    -- 多因子认证
    mfa_enabled BOOLEAN DEFAULT FALSE COMMENT '是否启用MFA',
    mfa_secret VARCHAR(255) COMMENT 'MFA密钥(加密存储)',
    mfa_backup_codes JSON COMMENT 'MFA备用码',
    
    -- 偏好设置
    preferences JSON COMMENT '用户偏好设置',
    notification_settings JSON COMMENT '通知设置',
    language VARCHAR(10) DEFAULT 'zh-CN' COMMENT '语言偏好',
    timezone VARCHAR(50) DEFAULT 'Asia/Shanghai' COMMENT '时区',
    
    -- 扩展信息
    custom_fields JSON COMMENT '自定义字段',
    tags JSON COMMENT '用户标签',
    
    -- 软删除
    deleted_at TIMESTAMP NULL COMMENT '删除时间',
    deleted_by VARCHAR(36) COMMENT '删除人ID',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    updated_by VARCHAR(36) COMMENT '更新人ID',
    
    -- 唯一约束
    UNIQUE KEY uk_tenant_username (tenant_id, username),
    UNIQUE KEY uk_tenant_email (tenant_id, email),
    UNIQUE KEY uk_tenant_phone (tenant_id, phone),
    UNIQUE KEY uk_tenant_employee_id (tenant_id, employee_id),
    
    -- 外键约束
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE,
    
    -- 索引设计
    INDEX idx_tenant_status (tenant_id, status),
    INDEX idx_email (email),
    INDEX idx_phone (phone),
    INDEX idx_last_login (last_login_at),
    INDEX idx_created_at (created_at),
    INDEX idx_department (department),
    INDEX idx_is_admin (is_super_admin, is_tenant_admin)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='SaaS用户主表';

-- 角色管理表
CREATE TABLE saas_roles (
    id VARCHAR(36) PRIMARY KEY COMMENT '角色ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 角色信息
    role_code VARCHAR(50) NOT NULL COMMENT '角色编码 - 租户内唯一',
    role_name VARCHAR(100) NOT NULL COMMENT '角色名称',
    role_description TEXT COMMENT '角色描述',
    
    -- 角色分类
    role_category ENUM('system', 'business', 'custom', 'inherited') DEFAULT 'custom' COMMENT '角色分类',
    role_source ENUM('builtin', 'template', 'custom') DEFAULT 'custom' COMMENT '角色来源',
    
    -- 角色层级
    role_level INT DEFAULT 0 COMMENT '角色层级',
    parent_role_id VARCHAR(36) COMMENT '父角色ID',
    role_path VARCHAR(1000) COMMENT '角色路径',
    
    -- 权限范围
    permission_scope ENUM('global', 'tenant', 'department', 'group', 'self') DEFAULT 'tenant' COMMENT '权限作用范围',
    data_scope JSON COMMENT '数据权限范围配置',
    
    -- 角色约束
    max_users INT COMMENT '最大用户数限制',
    role_constraints JSON COMMENT '角色约束条件',
    
    -- 角色属性
    is_system_role BOOLEAN DEFAULT FALSE COMMENT '是否系统角色',
    is_default_role BOOLEAN DEFAULT FALSE COMMENT '是否默认角色',
    is_assignable BOOLEAN DEFAULT TRUE COMMENT '是否可分配',
    auto_assign_rules JSON COMMENT '自动分配规则',
    
    -- 生效时间
    effective_start TIMESTAMP NULL COMMENT '生效开始时间',
    effective_end TIMESTAMP NULL COMMENT '生效结束时间',
    
    -- 状态管理
    status ENUM('active', 'inactive', 'deprecated', 'draft') DEFAULT 'active' COMMENT '角色状态',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    updated_by VARCHAR(36) COMMENT '更新人ID',
    
    -- 约束和索引
    UNIQUE KEY uk_tenant_role_code (tenant_id, role_code),
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_role_id) REFERENCES saas_roles(id) ON DELETE SET NULL,
    
    INDEX idx_tenant_status (tenant_id, status),
    INDEX idx_role_code (role_code),
    INDEX idx_role_category (role_category),
    INDEX idx_parent_role (parent_role_id),
    INDEX idx_role_level (role_level)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色管理表';

-- 权限管理表
CREATE TABLE saas_permissions (
    id VARCHAR(36) PRIMARY KEY COMMENT '权限ID',
    
    -- 权限标识
    permission_code VARCHAR(100) UNIQUE NOT NULL COMMENT '权限编码 - 全局唯一',
    permission_name VARCHAR(100) NOT NULL COMMENT '权限名称',
    permission_description TEXT COMMENT '权限描述',
    
    -- 权限分类
    module VARCHAR(50) NOT NULL COMMENT '所属模块',
    sub_module VARCHAR(50) COMMENT '子模块',
    resource VARCHAR(50) NOT NULL COMMENT '资源类型',
    action VARCHAR(50) NOT NULL COMMENT '操作类型',
    
    -- 权限层级
    permission_level INT DEFAULT 0 COMMENT '权限层级',
    parent_permission_id VARCHAR(36) COMMENT '父权限ID',
    permission_path VARCHAR(1000) COMMENT '权限路径',
    
    -- 权限属性
    is_system_permission BOOLEAN DEFAULT FALSE COMMENT '是否系统权限',
    is_menu_permission BOOLEAN DEFAULT FALSE COMMENT '是否菜单权限',
    is_button_permission BOOLEAN DEFAULT FALSE COMMENT '是否按钮权限',
    is_data_permission BOOLEAN DEFAULT FALSE COMMENT '是否数据权限',
    
    -- 权限约束
    requires_mfa BOOLEAN DEFAULT FALSE COMMENT '是否需要MFA验证',
    ip_restrictions JSON COMMENT 'IP访问限制',
    time_restrictions JSON COMMENT '时间访问限制',
    
    -- 权限配置
    permission_config JSON COMMENT '权限配置参数',
    menu_config JSON COMMENT '菜单配置(路由、图标等)',
    api_endpoints JSON COMMENT '关联的API端点',
    
    -- 状态管理
    status ENUM('active', 'inactive', 'deprecated') DEFAULT 'active' COMMENT '权限状态',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    -- 约束和索引
    FOREIGN KEY (parent_permission_id) REFERENCES saas_permissions(id) ON DELETE SET NULL,
    
    INDEX idx_permission_code (permission_code),
    INDEX idx_module_resource (module, resource),
    INDEX idx_module_action (module, action),
    INDEX idx_parent_permission (parent_permission_id),
    INDEX idx_permission_type (is_menu_permission, is_button_permission, is_data_permission)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='权限管理表';

-- 用户角色关联表
CREATE TABLE saas_user_roles (
    id VARCHAR(36) PRIMARY KEY COMMENT '关联ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    user_id VARCHAR(36) NOT NULL COMMENT '用户ID',
    role_id VARCHAR(36) NOT NULL COMMENT '角色ID',
    
    -- 授权信息
    granted_by VARCHAR(36) COMMENT '授权人ID',
    granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '授权时间',
    grant_reason VARCHAR(500) COMMENT '授权原因',
    
    -- 权限范围
    scope_type ENUM('global', 'department', 'group', 'project', 'custom') DEFAULT 'global' COMMENT '授权范围类型',
    scope_value JSON COMMENT '授权范围值',
    scope_description VARCHAR(500) COMMENT '授权范围描述',
    
    -- 时间限制
    effective_start TIMESTAMP NULL COMMENT '生效开始时间',
    effective_end TIMESTAMP NULL COMMENT '生效结束时间',
    expires_at TIMESTAMP NULL COMMENT '过期时间',
    
    -- 状态管理
    status ENUM('active', 'expired', 'revoked', 'suspended') DEFAULT 'active' COMMENT '状态',
    revoked_by VARCHAR(36) COMMENT '撤销人ID',
    revoked_at TIMESTAMP NULL COMMENT '撤销时间',
    revoke_reason VARCHAR(500) COMMENT '撤销原因',
    
    -- 约束和索引
    UNIQUE KEY uk_user_role_scope (user_id, role_id, scope_type, scope_value(100)),
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES saas_users(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES saas_roles(id) ON DELETE CASCADE,
    FOREIGN KEY (granted_by) REFERENCES saas_users(id) ON DELETE SET NULL,
    FOREIGN KEY (revoked_by) REFERENCES saas_users(id) ON DELETE SET NULL,
    
    INDEX idx_tenant_user (tenant_id, user_id),
    INDEX idx_user_role (user_id, role_id),
    INDEX idx_expires_at (expires_at),
    INDEX idx_status (status),
    INDEX idx_effective_period (effective_start, effective_end)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户角色关联表';

-- 角色权限关联表
CREATE TABLE saas_role_permissions (
    id VARCHAR(36) PRIMARY KEY COMMENT '关联ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    role_id VARCHAR(36) NOT NULL COMMENT '角色ID',
    permission_id VARCHAR(36) NOT NULL COMMENT '权限ID',
    
    -- 权限配置
    permission_type ENUM('allow', 'deny', 'inherit') DEFAULT 'allow' COMMENT '权限类型',
    permission_config JSON COMMENT '权限配置(如数据范围限制)',
    conditions JSON COMMENT '权限生效条件',
    
    -- 权限约束
    constraints JSON COMMENT '权限约束条件',
    data_filter JSON COMMENT '数据过滤规则',
    field_permissions JSON COMMENT '字段级权限',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    
    -- 约束和索引
    UNIQUE KEY uk_role_permission (role_id, permission_id),
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES saas_roles(id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES saas_permissions(id) ON DELETE CASCADE,
    
    INDEX idx_tenant_role (tenant_id, role_id),
    INDEX idx_role_permission (role_id, permission_id),
    INDEX idx_permission_type (permission_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色权限关联表';

-- =====================================================
-- 2. 安全审计层
-- =====================================================

-- API密钥管理表
CREATE TABLE saas_api_keys (
    id VARCHAR(36) PRIMARY KEY COMMENT 'API密钥ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    user_id VARCHAR(36) NOT NULL COMMENT '用户ID',
    
    -- 密钥信息
    key_name VARCHAR(100) NOT NULL COMMENT '密钥名称',
    key_description TEXT COMMENT '密钥描述',
    access_key VARCHAR(64) UNIQUE NOT NULL COMMENT '访问密钥',
    secret_key_hash VARCHAR(255) NOT NULL COMMENT '密钥哈希',
    
    -- 权限配置
    permissions JSON COMMENT 'API权限配置',
    scopes JSON COMMENT '权限作用域',
    allowed_ips JSON COMMENT 'IP白名单',
    allowed_domains JSON COMMENT '域名白名单',
    
    -- 限流配置
    rate_limit_config JSON COMMENT '限流配置',
    daily_request_limit BIGINT COMMENT '日请求限制',
    monthly_request_limit BIGINT COMMENT '月请求限制',
    concurrent_request_limit INT COMMENT '并发请求限制',
    
    -- 使用统计
    total_requests BIGINT DEFAULT 0 COMMENT '总请求数',
    successful_requests BIGINT DEFAULT 0 COMMENT '成功请求数',
    failed_requests BIGINT DEFAULT 0 COMMENT '失败请求数',
    last_used_at TIMESTAMP NULL COMMENT '最后使用时间',
    last_used_ip VARCHAR(45) COMMENT '最后使用IP',
    
    -- 状态管理
    status ENUM('active', 'inactive', 'expired', 'revoked', 'suspended') DEFAULT 'active' COMMENT '状态',
    expires_at TIMESTAMP NULL COMMENT '过期时间',
    auto_renew BOOLEAN DEFAULT FALSE COMMENT '是否自动续期',
    
    -- 安全配置
    require_https BOOLEAN DEFAULT TRUE COMMENT '是否要求HTTPS',
    webhook_signature_key VARCHAR(255) COMMENT 'Webhook签名密钥',
    encryption_config JSON COMMENT '加密配置',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    revoked_by VARCHAR(36) COMMENT '撤销人ID',
    revoked_at TIMESTAMP NULL COMMENT '撤销时间',
    
    -- 约束和索引
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES saas_users(id) ON DELETE CASCADE,
    
    INDEX idx_tenant_user (tenant_id, user_id),
    INDEX idx_access_key (access_key),
    INDEX idx_status (status),
    INDEX idx_expires_at (expires_at),
    INDEX idx_last_used (last_used_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='API密钥管理表';

-- 用户会话管理表
CREATE TABLE saas_user_sessions (
    id VARCHAR(36) PRIMARY KEY COMMENT '会话ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    user_id VARCHAR(36) NOT NULL COMMENT '用户ID',
    
    -- 会话标识
    session_token VARCHAR(255) UNIQUE NOT NULL COMMENT '会话令牌',
    refresh_token VARCHAR(255) COMMENT '刷新令牌',
    device_id VARCHAR(100) COMMENT '设备ID',
    
    -- 设备信息
    device_type ENUM('web', 'mobile', 'desktop', 'api', 'tablet') DEFAULT 'web' COMMENT '设备类型',
    device_name VARCHAR(200) COMMENT '设备名称',
    device_fingerprint VARCHAR(255) COMMENT '设备指纹',
    
    -- 登录信息
    login_ip VARCHAR(45) NOT NULL COMMENT '登录IP',
    login_location JSON COMMENT '登录地理位置',
    user_agent TEXT COMMENT '用户代理',
    login_method ENUM('password', 'mfa', 'sso', 'api_key', 'oauth') DEFAULT 'password' COMMENT '登录方式',
    
    -- 会话状态
    status ENUM('active', 'expired', 'revoked', 'suspicious', 'force_logout') DEFAULT 'active' COMMENT '会话状态',
    is_trusted_device BOOLEAN DEFAULT FALSE COMMENT '是否可信设备',
    concurrent_sessions_count INT DEFAULT 1 COMMENT '并发会话数',
    
    -- 时间管理
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    expires_at TIMESTAMP NOT NULL COMMENT '过期时间',
    last_activity_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '最后活动时间',
    last_refresh_at TIMESTAMP NULL COMMENT '最后刷新时间',
    
    -- 安全信息
    security_level ENUM('low', 'medium', 'high') DEFAULT 'medium' COMMENT '安全级别',
    risk_score DECIMAL(5,2) DEFAULT 0.00 COMMENT '风险评分',
    anomaly_flags JSON COMMENT '异常标记',
    
    -- 会话数据
    session_data JSON COMMENT '会话数据',
    permissions_cache JSON COMMENT '权限缓存',
    
    -- 撤销信息
    revoked_by VARCHAR(36) COMMENT '撤销人ID',
    revoked_at TIMESTAMP NULL COMMENT '撤销时间',
    revoke_reason VARCHAR(500) COMMENT '撤销原因',
    
    -- 约束和索引
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES saas_users(id) ON DELETE CASCADE,
    
    INDEX idx_tenant_user (tenant_id, user_id),
    INDEX idx_session_token (session_token),
    INDEX idx_user_status (user_id, status),
    INDEX idx_expires_at (expires_at),
    INDEX idx_last_activity (last_activity_at),
    INDEX idx_device_fingerprint (device_fingerprint),
    INDEX idx_login_ip (login_ip)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户会话管理表';

-- 统一审计日志表 (分区表)
CREATE TABLE saas_unified_audit_logs (
    id VARCHAR(36) NOT NULL COMMENT '日志ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 基础信息
    log_type ENUM('operation', 'security', 'business', 'system') NOT NULL COMMENT '日志类型',
    module VARCHAR(50) NOT NULL COMMENT '业务模块 (wework/ai/health/system)',
    sub_module VARCHAR(50) COMMENT '子模块',
    
    -- 操作者信息
    operator_id VARCHAR(36) COMMENT '操作者ID',
    operator_type ENUM('user', 'system', 'api', 'scheduled') DEFAULT 'user' COMMENT '操作者类型',
    session_id VARCHAR(36) COMMENT '会话ID',
    
    -- 操作详情
    action ENUM('create', 'read', 'update', 'delete', 'login', 'logout', 'status_change', 'config', 'alert') NOT NULL COMMENT '操作类型',
    target_type VARCHAR(50) COMMENT '目标类型 (account/agent/patient等)',
    target_id VARCHAR(36) COMMENT '目标ID',
    target_name VARCHAR(200) COMMENT '目标名称',
    
    -- 变更数据 (JSON统一存储)
    change_data JSON COMMENT '变更数据 {old_values, new_values, extra_info}',
    
    -- 执行结果
    status ENUM('success', 'failure', 'partial') DEFAULT 'success' COMMENT '执行状态',
    error_info JSON COMMENT '错误信息',
    execution_time_ms INT COMMENT '执行时间(毫秒)',
    
    -- 环境信息
    ip_address VARCHAR(45) COMMENT 'IP地址',
    user_agent TEXT COMMENT '用户代理',
    request_info JSON COMMENT '请求信息',
    
    -- 业务扩展
    business_context JSON COMMENT '业务上下文 (可存储模块特定信息)',
    tags JSON COMMENT '标签 (便于查询和分类)',
    
    -- 时间信息
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    -- 复合主键，包含分区键
    PRIMARY KEY (id, created_at),
    
    -- 索引设计
    INDEX idx_tenant_module (tenant_id, module),
    INDEX idx_operator (operator_id, created_at),
    INDEX idx_target (target_type, target_id),
    INDEX idx_log_type (log_type, created_at),
    INDEX idx_action (action, created_at),
    
    -- 外键约束
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (operator_id) REFERENCES saas_users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='统一审计日志表'
PARTITION BY RANGE (UNIX_TIMESTAMP(created_at)) (
    PARTITION p202501 VALUES LESS THAN (UNIX_TIMESTAMP('2025-02-01 00:00:00')),
    PARTITION p202502 VALUES LESS THAN (UNIX_TIMESTAMP('2025-03-01 00:00:00')),
    PARTITION p202503 VALUES LESS THAN (UNIX_TIMESTAMP('2025-04-01 00:00:00')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- 登录尝试记录表
CREATE TABLE saas_login_attempts (
    id VARCHAR(36) PRIMARY KEY COMMENT '记录ID',
    tenant_id VARCHAR(36) COMMENT '租户ID',
    
    -- 登录信息
    username VARCHAR(100) NOT NULL COMMENT '用户名',
    email VARCHAR(100) COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '手机号',
    login_method ENUM('password', 'mfa', 'sso', 'api_key') DEFAULT 'password' COMMENT '登录方式',
    
    -- 结果信息
    attempt_result ENUM('success', 'failed', 'blocked', 'suspended') NOT NULL COMMENT '尝试结果',
    failure_reason VARCHAR(200) COMMENT '失败原因',
    
    -- 环境信息
    ip_address VARCHAR(45) NOT NULL COMMENT 'IP地址',
    user_agent TEXT COMMENT '用户代理',
    device_fingerprint VARCHAR(255) COMMENT '设备指纹',
    location JSON COMMENT '地理位置',
    
    -- 安全信息
    risk_score DECIMAL(5,2) DEFAULT 0 COMMENT '风险评分',
    is_suspicious BOOLEAN DEFAULT FALSE COMMENT '是否可疑',
    blocked_until TIMESTAMP NULL COMMENT '阻止到期时间',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    -- 索引设计
    INDEX idx_tenant_username (tenant_id, username),
    INDEX idx_ip_address (ip_address, created_at),
    INDEX idx_attempt_result (attempt_result, created_at),
    INDEX idx_is_suspicious (is_suspicious, created_at),
    
    -- 外键约束
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='登录尝试记录表';

-- =====================================================
-- 3. 配额计费层
-- =====================================================

-- 租户配额管理表
CREATE TABLE saas_tenant_quotas (
    id VARCHAR(36) PRIMARY KEY COMMENT '配额ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    plan_id VARCHAR(36) COMMENT '订阅计划ID',
    
    -- 基础配额
    max_users INT DEFAULT 10 COMMENT '最大用户数',
    max_roles INT DEFAULT 50 COMMENT '最大角色数',
    max_api_keys INT DEFAULT 10 COMMENT '最大API密钥数',
    max_storage_gb DECIMAL(10,2) DEFAULT 10.00 COMMENT '最大存储空间(GB)',
    
    -- API调用配额
    max_api_calls_per_minute BIGINT DEFAULT 1000 COMMENT '每分钟最大API调用次数',
    max_api_calls_per_hour BIGINT DEFAULT 10000 COMMENT '每小时最大API调用次数',
    max_api_calls_per_day BIGINT DEFAULT 100000 COMMENT '每日最大API调用次数',
    max_api_calls_per_month BIGINT DEFAULT 1000000 COMMENT '每月最大API调用次数',
    
    -- 企微平台配额
    max_wework_accounts INT DEFAULT 5 COMMENT '最大企微账号数',
    max_online_wework_accounts INT DEFAULT 3 COMMENT '最大同时在线企微账号数',
    max_daily_wework_messages BIGINT DEFAULT 1000 COMMENT '每日最大企微消息数',
    max_monthly_wework_messages BIGINT DEFAULT 10000 COMMENT '每月最大企微消息数',
    max_wework_monitor_rules INT DEFAULT 20 COMMENT '最大企微监控规则数',
    max_wework_alerts_per_day INT DEFAULT 100 COMMENT '每日最大企微告警数',
    
    -- AI智能体配额
    max_ai_agents INT DEFAULT 3 COMMENT '最大AI智能体数',
    max_ai_platforms INT DEFAULT 5 COMMENT '最大AI平台数',
    max_ai_conversations_per_day BIGINT DEFAULT 100 COMMENT '每日最大AI对话数',
    max_ai_tokens_per_day BIGINT DEFAULT 100000 COMMENT '每日最大AI Token数',
    max_ai_knowledge_bases INT DEFAULT 5 COMMENT '最大知识库数',
    max_ai_tools INT DEFAULT 20 COMMENT '最大工具数',
    
    -- 健康管理配额
    max_health_patients INT DEFAULT 100 COMMENT '最大患者数',
    max_health_records_per_patient INT DEFAULT 1000 COMMENT '每患者最大健康记录数',
    max_health_devices INT DEFAULT 10 COMMENT '最大健康设备数',
    
    -- 系统资源配额
    max_file_size_mb DECIMAL(8,2) DEFAULT 100.00 COMMENT '最大单文件大小(MB)',
    max_batch_size INT DEFAULT 1000 COMMENT '最大批量操作数',
    max_export_records INT DEFAULT 10000 COMMENT '最大导出记录数',
    max_concurrent_sessions INT DEFAULT 5 COMMENT '最大并发会话数',
    
    -- 监控告警配额
    max_monitor_rules INT DEFAULT 50 COMMENT '最大监控规则数',
    max_alert_channels INT DEFAULT 10 COMMENT '最大告警渠道数',
    max_alerts_per_day INT DEFAULT 1000 COMMENT '每日最大告警数',
    
    -- 通知消息配额
    max_notifications_per_day INT DEFAULT 1000 COMMENT '每日最大站内通知数',
    max_email_per_day INT DEFAULT 100 COMMENT '每日最大邮件数',
    max_sms_per_day INT DEFAULT 50 COMMENT '每日最大短信数',
    
    -- 功能权限开关
    enable_wework_integration BOOLEAN DEFAULT TRUE COMMENT '是否启用企微集成',
    enable_wework_auto_recovery BOOLEAN DEFAULT TRUE COMMENT '是否启用企微自动恢复',
    enable_wework_custom_callback BOOLEAN DEFAULT TRUE COMMENT '是否启用企微自定义回调',
    enable_ai_module BOOLEAN DEFAULT FALSE COMMENT '是否启用AI模块',
    enable_ai_custom_models BOOLEAN DEFAULT FALSE COMMENT '是否启用AI自定义模型',
    enable_health_module BOOLEAN DEFAULT FALSE COMMENT '是否启用健康模块',
    enable_advanced_analytics BOOLEAN DEFAULT FALSE COMMENT '是否启用高级分析',
    enable_api_access BOOLEAN DEFAULT TRUE COMMENT '是否启用API访问',
    enable_webhook BOOLEAN DEFAULT TRUE COMMENT '是否启用Webhook',
    enable_sso BOOLEAN DEFAULT FALSE COMMENT '是否启用SSO',
    enable_mfa BOOLEAN DEFAULT TRUE COMMENT '是否启用MFA',
    enable_audit_logs BOOLEAN DEFAULT TRUE COMMENT '是否启用审计日志',
    enable_data_export BOOLEAN DEFAULT TRUE COMMENT '是否启用数据导出',
    enable_custom_branding BOOLEAN DEFAULT FALSE COMMENT '是否启用自定义品牌',
    
    -- 有效期管理
    effective_from DATE NOT NULL COMMENT '生效开始日期',
    effective_to DATE COMMENT '生效结束日期',
    auto_renew BOOLEAN DEFAULT FALSE COMMENT '是否自动续期',
    
    -- 超额策略
    overage_policy ENUM('block', 'allow_overage', 'auto_upgrade') DEFAULT 'block' COMMENT '超额策略',
    overage_rate DECIMAL(8,4) COMMENT '超额费率',
    warning_threshold DECIMAL(5,2) DEFAULT 80.00 COMMENT '告警阈值百分比',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    updated_by VARCHAR(36) COMMENT '更新人ID',
    
    -- 约束和索引
    UNIQUE KEY uk_tenant_quota (tenant_id),
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE,
    
    INDEX idx_effective_period (effective_from, effective_to),
    INDEX idx_plan_id (plan_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='租户配额管理表';

-- 使用统计表
CREATE TABLE saas_usage_statistics (
    id VARCHAR(36) PRIMARY KEY COMMENT '统计ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    usage_date DATE NOT NULL COMMENT '统计日期',
    
    -- 基础使用统计
    active_users INT DEFAULT 0 COMMENT '活跃用户数',
    api_calls BIGINT DEFAULT 0 COMMENT 'API调用次数',
    storage_used_gb DECIMAL(10,2) DEFAULT 0 COMMENT '已用存储(GB)',
    bandwidth_used_gb DECIMAL(10,2) DEFAULT 0 COMMENT '已用带宽(GB)',
    
    -- 企微使用统计
    wework_accounts_online INT DEFAULT 0 COMMENT '在线企微账号数',
    wework_messages_sent BIGINT DEFAULT 0 COMMENT '企微消息发送数',
    wework_alerts_triggered INT DEFAULT 0 COMMENT '企微告警触发数',
    
    -- AI使用统计
    ai_conversations BIGINT DEFAULT 0 COMMENT 'AI对话数',
    ai_tokens_consumed BIGINT DEFAULT 0 COMMENT 'AI Token消耗',
    ai_requests BIGINT DEFAULT 0 COMMENT 'AI请求数',
    ai_cost DECIMAL(10,4) DEFAULT 0 COMMENT 'AI费用',
    
    -- 健康管理统计
    health_records_created INT DEFAULT 0 COMMENT '创建的健康记录数',
    health_patients_active INT DEFAULT 0 COMMENT '活跃患者数',
    
    -- 系统统计
    notifications_sent INT DEFAULT 0 COMMENT '发送通知数',
    files_uploaded INT DEFAULT 0 COMMENT '上传文件数',
    exports_performed INT DEFAULT 0 COMMENT '执行导出数',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    -- 唯一约束和索引
    UNIQUE KEY uk_tenant_date (tenant_id, usage_date),
    INDEX idx_usage_date (usage_date),
    INDEX idx_tenant_month (tenant_id, usage_date),
    
    -- 外键约束
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='使用统计表';

-- 实时配额使用表
CREATE TABLE saas_quota_usage_realtime (
    id VARCHAR(36) PRIMARY KEY COMMENT 'ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    resource_type VARCHAR(50) NOT NULL COMMENT '资源类型',
    
    -- 实时使用量
    current_usage BIGINT DEFAULT 0 COMMENT '当前使用量',
    usage_limit BIGINT NOT NULL COMMENT '使用限制',
    usage_period ENUM('minute', 'hour', 'day', 'month') NOT NULL COMMENT '统计周期',
    
    -- 时间窗口
    window_start TIMESTAMP NOT NULL COMMENT '窗口开始时间',
    window_end TIMESTAMP NOT NULL COMMENT '窗口结束时间',
    
    -- 统计信息
    peak_usage BIGINT DEFAULT 0 COMMENT '峰值使用量',
    avg_usage DECIMAL(10,2) DEFAULT 0 COMMENT '平均使用量',
    last_reset_at TIMESTAMP NULL COMMENT '最后重置时间',
    
    -- 告警状态
    alert_triggered BOOLEAN DEFAULT FALSE COMMENT '是否已触发告警',
    usage_percentage DECIMAL(5,2) DEFAULT 0 COMMENT '使用百分比',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    -- 唯一约束和索引
    UNIQUE KEY uk_tenant_resource_period (tenant_id, resource_type, usage_period),
    INDEX idx_tenant_resource (tenant_id, resource_type),
    INDEX idx_usage_percentage (usage_percentage),
    INDEX idx_window_end (window_end),
    
    -- 外键约束
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='实时配额使用表';

-- =====================================================
-- 4. 系统管理层
-- =====================================================

-- 统一配置管理表
CREATE TABLE saas_unified_configs (
    id VARCHAR(36) PRIMARY KEY COMMENT '配置ID',
    tenant_id VARCHAR(36) COMMENT '租户ID - NULL表示全局配置',
    user_id VARCHAR(36) COMMENT '用户ID - NULL表示非用户级配置',
    
    -- 配置分类
    config_scope ENUM('global', 'tenant', 'user', 'module') NOT NULL COMMENT '配置作用域',
    config_category VARCHAR(50) NOT NULL COMMENT '配置分类 (system/business/ui/integration)',
    module VARCHAR(50) COMMENT '所属模块 (wework/ai/health等)',
    
    -- 配置标识
    config_key VARCHAR(100) NOT NULL COMMENT '配置键',
    config_name VARCHAR(100) COMMENT '配置名称',
    config_description TEXT COMMENT '配置描述',
    
    -- 配置值
    config_value JSON NOT NULL COMMENT '配置值',
    config_type ENUM('string', 'number', 'boolean', 'json', 'array', 'encrypted') DEFAULT 'string' COMMENT '值类型',
    default_value JSON COMMENT '默认值',
    
    -- 配置属性
    is_required BOOLEAN DEFAULT FALSE COMMENT '是否必需',
    is_encrypted BOOLEAN DEFAULT FALSE COMMENT '是否加密存储',
    is_public BOOLEAN DEFAULT FALSE COMMENT '是否前端可访问',
    is_readonly BOOLEAN DEFAULT FALSE COMMENT '是否只读',
    
    -- 验证规则
    validation_rules JSON COMMENT '验证规则 {min, max, pattern, options}',
    
    -- 版本管理
    version INT DEFAULT 1 COMMENT '配置版本',
    parent_config_id VARCHAR(36) COMMENT '父配置ID (支持配置继承)',
    
    -- 状态管理
    status ENUM('active', 'inactive', 'deprecated') DEFAULT 'active' COMMENT '配置状态',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    updated_by VARCHAR(36) COMMENT '更新人ID',
    
    -- 唯一约束
    UNIQUE KEY uk_global_config (config_key) WHERE tenant_id IS NULL AND user_id IS NULL,
    UNIQUE KEY uk_tenant_config (tenant_id, config_key) WHERE user_id IS NULL,
    UNIQUE KEY uk_user_config (tenant_id, user_id, config_key),
    
    -- 索引设计
    INDEX idx_scope_category (config_scope, config_category),
    INDEX idx_tenant_module (tenant_id, module),
    INDEX idx_config_key (config_key),
    INDEX idx_status (status),
    INDEX idx_parent_config (parent_config_id),
    
    -- 外键约束
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES saas_users(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_config_id) REFERENCES saas_unified_configs(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='统一配置管理表';

-- 统一告警管理表 (分区表)
CREATE TABLE saas_unified_alerts (
    id VARCHAR(36) NOT NULL COMMENT '告警ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 告警来源
    source_type ENUM('system', 'business', 'monitor', 'security') NOT NULL COMMENT '告警来源类型',
    source_module VARCHAR(50) NOT NULL COMMENT '来源模块 (wework/ai/health/system)',
    source_id VARCHAR(36) COMMENT '来源对象ID (account_id/agent_id等)',
    source_name VARCHAR(200) COMMENT '来源对象名称',
    
    -- 告警基本信息
    alert_code VARCHAR(50) NOT NULL COMMENT '告警编码 (用于去重和规则匹配)',
    alert_title VARCHAR(200) NOT NULL COMMENT '告警标题',
    alert_message TEXT NOT NULL COMMENT '告警消息',
    alert_level ENUM('info', 'warning', 'error', 'critical') NOT NULL COMMENT '告警级别',
    
    -- 告警分类
    alert_category ENUM(
        'heartbeat_timeout', 'api_failure', 'status_anomaly', 'login_failed',
        'auto_recovery_failed', 'retry_limit_reached', 'quota_exceeded', 
        'response_time_high', 'message_send_failed', 'resource_low',
        'network_error', 'database_error', 'cache_error', 'security_threat',
        'business_exception', 'custom'
    ) NOT NULL COMMENT '告警分类',
    
    -- 告警数据
    alert_data JSON COMMENT '告警详细数据',
    trigger_condition JSON COMMENT '触发条件',
    threshold_info JSON COMMENT '阈值信息',
    
    -- 状态管理
    status ENUM('open', 'acknowledged', 'resolved', 'suppressed', 'expired') DEFAULT 'open' COMMENT '告警状态',
    
    -- 时间管理
    first_occurred_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '首次发生时间',
    last_occurred_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最后发生时间',
    occurrence_count INT DEFAULT 1 COMMENT '发生次数',
    
    -- 处理信息
    acknowledged_by VARCHAR(36) COMMENT '确认人ID',
    acknowledged_at TIMESTAMP NULL COMMENT '确认时间',
    resolved_by VARCHAR(36) COMMENT '解决人ID',
    resolved_at TIMESTAMP NULL COMMENT '解决时间',
    resolution_info JSON COMMENT '解决信息 {action, description, auto_resolved}',
    
    -- 通知状态
    notification_status JSON COMMENT '通知发送状态',
    escalation_level INT DEFAULT 0 COMMENT '升级级别',
    
    -- 业务扩展
    business_impact ENUM('none', 'low', 'medium', 'high', 'critical') DEFAULT 'low' COMMENT '业务影响',
    tags JSON COMMENT '标签',
    related_alerts JSON COMMENT '关联告警ID列表',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    -- 复合主键，包含分区键
    PRIMARY KEY (id, created_at),
    
    -- 索引设计
    INDEX idx_tenant_level (tenant_id, alert_level),
    INDEX idx_source (source_type, source_module, source_id),
    INDEX idx_status_time (status, created_at),
    INDEX idx_alert_code (alert_code, created_at),
    INDEX idx_occurrence_time (last_occurred_at),
    INDEX idx_resolved_time (resolved_at),
    
    -- 外键约束
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (acknowledged_by) REFERENCES saas_users(id) ON DELETE SET NULL,
    FOREIGN KEY (resolved_by) REFERENCES saas_users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='统一告警管理表'
PARTITION BY RANGE (UNIX_TIMESTAMP(created_at)) (
    PARTITION p202501 VALUES LESS THAN (UNIX_TIMESTAMP('2025-02-01 00:00:00')),
    PARTITION p202502 VALUES LESS THAN (UNIX_TIMESTAMP('2025-03-01 00:00:00')),
    PARTITION p202503 VALUES LESS THAN (UNIX_TIMESTAMP('2025-04-01 00:00:00')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- 监控规则表
CREATE TABLE saas_monitor_rules (
    id VARCHAR(36) PRIMARY KEY COMMENT '规则ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 规则基本信息
    rule_name VARCHAR(100) NOT NULL COMMENT '规则名称',
    rule_description TEXT COMMENT '规则描述',
    rule_category ENUM('system', 'business', 'security', 'performance') NOT NULL COMMENT '规则分类',
    target_module VARCHAR(50) NOT NULL COMMENT '目标模块',
    
    -- 监控配置
    monitor_target JSON NOT NULL COMMENT '监控目标配置',
    check_conditions JSON NOT NULL COMMENT '检查条件',
    threshold_config JSON COMMENT '阈值配置',
    
    -- 执行配置
    check_interval INT DEFAULT 60 COMMENT '检查间隔(秒)',
    check_timeout INT DEFAULT 30 COMMENT '检查超时(秒)',
    retry_count INT DEFAULT 3 COMMENT '重试次数',
    
    -- 告警配置
    alert_level ENUM('info', 'warning', 'error', 'critical') NOT NULL COMMENT '告警级别',
    alert_template VARCHAR(200) COMMENT '告警模板',
    notification_channels JSON COMMENT '通知渠道配置',
    
    -- 自动处理
    enable_auto_handling BOOLEAN DEFAULT FALSE COMMENT '是否启用自动处理',
    auto_handling_config JSON COMMENT '自动处理配置',
    
    -- 状态统计
    is_enabled BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    execution_count BIGINT DEFAULT 0 COMMENT '执行次数',
    success_count BIGINT DEFAULT 0 COMMENT '成功次数',
    failure_count BIGINT DEFAULT 0 COMMENT '失败次数',
    last_executed_at TIMESTAMP NULL COMMENT '最后执行时间',
    last_triggered_at TIMESTAMP NULL COMMENT '最后触发时间',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    
    -- 索引设计
    INDEX idx_tenant_module (tenant_id, target_module),
    INDEX idx_rule_category (rule_category),
    INDEX idx_is_enabled (is_enabled),
    INDEX idx_execution_stats (execution_count, success_count),
    
    -- 外键约束
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES saas_users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='监控规则表';

-- 系统指标表
CREATE TABLE saas_system_metrics (
    id VARCHAR(36) PRIMARY KEY COMMENT '指标ID',
    tenant_id VARCHAR(36) COMMENT '租户ID - NULL表示全局指标',
    
    -- 指标基本信息
    metric_name VARCHAR(100) NOT NULL COMMENT '指标名称',
    metric_type ENUM('counter', 'gauge', 'histogram', 'timer') NOT NULL COMMENT '指标类型',
    metric_category VARCHAR(50) NOT NULL COMMENT '指标分类',
    metric_value DECIMAL(15,6) NOT NULL COMMENT '指标值',
    
    -- 指标标签
    labels JSON COMMENT '指标标签',
    tags JSON COMMENT '指标标签',
    
    -- 时间信息
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '记录时间',
    time_window ENUM('1m', '5m', '15m', '1h', '1d') DEFAULT '1m' COMMENT '时间窗口',
    
    -- 索引设计
    INDEX idx_tenant_metric (tenant_id, metric_name),
    INDEX idx_metric_category (metric_category, recorded_at),
    INDEX idx_recorded_at (recorded_at),
    
    -- 外键约束
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统指标表';

-- 健康检查表
CREATE TABLE saas_health_checks (
    id VARCHAR(36) PRIMARY KEY COMMENT '检查ID',
    tenant_id VARCHAR(36) COMMENT '租户ID',
    
    -- 检查配置
    check_name VARCHAR(100) NOT NULL COMMENT '检查名称',
    check_type ENUM('http', 'tcp', 'database', 'service', 'custom') NOT NULL COMMENT '检查类型',
    target_endpoint VARCHAR(500) NOT NULL COMMENT '检查目标',
    check_config JSON COMMENT '检查配置',
    
    -- 检查结果
    status ENUM('healthy', 'unhealthy', 'degraded', 'unknown') NOT NULL COMMENT '健康状态',
    response_time_ms INT COMMENT '响应时间(毫秒)',
    status_code INT COMMENT '状态码',
    error_message TEXT COMMENT '错误信息',
    
    -- 检查统计
    consecutive_failures INT DEFAULT 0 COMMENT '连续失败次数',
    total_checks BIGINT DEFAULT 0 COMMENT '总检查次数',
    successful_checks BIGINT DEFAULT 0 COMMENT '成功检查次数',
    
    -- 时间信息
    last_check_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '最后检查时间',
    next_check_at TIMESTAMP COMMENT '下次检查时间',
    
    -- 索引设计
    INDEX idx_tenant_status (tenant_id, status),
    INDEX idx_check_type (check_type, last_check_at),
    INDEX idx_next_check (next_check_at),
    
    -- 外键约束
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='健康检查表';

-- =====================================================
-- 5. 通知消息层
-- =====================================================

-- 消息模板表
CREATE TABLE saas_message_templates (
    id VARCHAR(36) PRIMARY KEY COMMENT '模板ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 模板基本信息
    template_name VARCHAR(100) NOT NULL COMMENT '模板名称',
    template_code VARCHAR(50) NOT NULL COMMENT '模板编码',
    template_type ENUM('email', 'sms', 'push', 'webhook', 'in_app') NOT NULL COMMENT '模板类型',
    template_category VARCHAR(50) NOT NULL COMMENT '模板分类',
    
    -- 模板内容
    subject VARCHAR(200) COMMENT '主题',
    content TEXT NOT NULL COMMENT '内容',
    content_format ENUM('text', 'html', 'markdown', 'json') DEFAULT 'text' COMMENT '内容格式',
    
    -- 变量配置
    variables JSON COMMENT '变量定义',
    default_values JSON COMMENT '默认值',
    
    -- 模板配置
    template_config JSON COMMENT '模板配置',
    priority ENUM('low', 'normal', 'high', 'urgent') DEFAULT 'normal' COMMENT '优先级',
    
    -- 状态管理
    is_active BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    version VARCHAR(20) DEFAULT '1.0' COMMENT '版本号',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    
    -- 约束和索引
    UNIQUE KEY uk_tenant_template_code (tenant_id, template_code),
    INDEX idx_template_type (template_type),
    INDEX idx_template_category (template_category),
    INDEX idx_is_active (is_active),
    
    -- 外键约束
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES saas_users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息模板表';

-- 站内通知表
CREATE TABLE saas_notifications (
    id VARCHAR(36) PRIMARY KEY COMMENT '通知ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 通知基本信息
    notification_type ENUM('system', 'business', 'alert', 'reminder', 'announcement') NOT NULL COMMENT '通知类型',
    title VARCHAR(200) NOT NULL COMMENT '通知标题',
    content TEXT NOT NULL COMMENT '通知内容',
    content_format ENUM('text', 'html', 'markdown') DEFAULT 'text' COMMENT '内容格式',
    
    -- 接收者信息
    recipient_type ENUM('user', 'role', 'department', 'all') NOT NULL COMMENT '接收者类型',
    recipient_ids JSON COMMENT '接收者ID列表',
    
    -- 通知配置
    priority ENUM('low', 'normal', 'high', 'urgent') DEFAULT 'normal' COMMENT '优先级',
    category VARCHAR(50) COMMENT '通知分类',
    tags JSON COMMENT '标签',
    
    -- 发送配置
    send_immediately BOOLEAN DEFAULT TRUE COMMENT '是否立即发送',
    scheduled_at TIMESTAMP NULL COMMENT '计划发送时间',
    expires_at TIMESTAMP NULL COMMENT '过期时间',
    
    -- 状态统计
    status ENUM('draft', 'scheduled', 'sending', 'sent', 'failed', 'cancelled') DEFAULT 'draft' COMMENT '状态',
    total_recipients INT DEFAULT 0 COMMENT '总接收者数',
    sent_count INT DEFAULT 0 COMMENT '已发送数',
    read_count INT DEFAULT 0 COMMENT '已读数',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    sent_at TIMESTAMP NULL COMMENT '发送时间',
    
    -- 索引设计
    INDEX idx_tenant_type (tenant_id, notification_type),
    INDEX idx_recipient_type (recipient_type),
    INDEX idx_status (status, created_at),
    INDEX idx_scheduled_at (scheduled_at),
    INDEX idx_expires_at (expires_at),
    
    -- 外键约束
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES saas_users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='站内通知表';

-- 消息发送记录表
CREATE TABLE saas_message_logs (
    id VARCHAR(36) PRIMARY KEY COMMENT '记录ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 消息基本信息
    message_type ENUM('email', 'sms', 'push', 'webhook', 'in_app') NOT NULL COMMENT '消息类型',
    template_id VARCHAR(36) COMMENT '模板ID',
    notification_id VARCHAR(36) COMMENT '通知ID',
    
    -- 接收者信息
    recipient_type ENUM('user', 'external') NOT NULL COMMENT '接收者类型',
    recipient_id VARCHAR(36) COMMENT '接收者ID',
    recipient_address VARCHAR(200) NOT NULL COMMENT '接收者地址(邮箱/手机等)',
    
    -- 消息内容
    subject VARCHAR(200) COMMENT '主题',
    content TEXT COMMENT '内容',
    variables_used JSON COMMENT '使用的变量',
    
    -- 发送状态
    status ENUM('pending', 'sending', 'sent', 'delivered', 'failed', 'bounced') NOT NULL COMMENT '发送状态',
    provider VARCHAR(50) COMMENT '发送服务商',
    external_id VARCHAR(100) COMMENT '外部ID',
    
    -- 结果信息
    sent_at TIMESTAMP NULL COMMENT '发送时间',
    delivered_at TIMESTAMP NULL COMMENT '送达时间',
    opened_at TIMESTAMP NULL COMMENT '打开时间',
    clicked_at TIMESTAMP NULL COMMENT '点击时间',
    
    -- 错误信息
    error_code VARCHAR(50) COMMENT '错误代码',
    error_message TEXT COMMENT '错误信息',
    retry_count INT DEFAULT 0 COMMENT '重试次数',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    -- 索引设计
    INDEX idx_tenant_type (tenant_id, message_type),
    INDEX idx_recipient (recipient_type, recipient_id),
    INDEX idx_status_time (status, created_at),
    INDEX idx_template_id (template_id),
    INDEX idx_notification_id (notification_id),
    
    -- 外键约束
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (template_id) REFERENCES saas_message_templates(id) ON DELETE SET NULL,
    FOREIGN KEY (notification_id) REFERENCES saas_notifications(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息发送记录表';

-- =====================================================
-- 6. 文件存储层
-- =====================================================

-- 文件存储表
CREATE TABLE saas_files (
    id VARCHAR(36) PRIMARY KEY COMMENT '文件ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    user_id VARCHAR(36) COMMENT '上传用户ID',
    
    -- 文件基本信息
    original_name VARCHAR(255) NOT NULL COMMENT '原始文件名',
    file_name VARCHAR(255) NOT NULL COMMENT '存储文件名',
    file_path VARCHAR(1000) NOT NULL COMMENT '文件路径',
    file_size BIGINT NOT NULL COMMENT '文件大小(字节)',
    file_type VARCHAR(100) COMMENT '文件类型',
    mime_type VARCHAR(100) COMMENT 'MIME类型',
    
    -- 文件分类
    file_category ENUM('document', 'image', 'video', 'audio', 'archive', 'other') DEFAULT 'other' COMMENT '文件分类',
    business_type VARCHAR(50) COMMENT '业务类型',
    business_id VARCHAR(36) COMMENT '业务ID',
    
    -- 存储配置
    storage_provider VARCHAR(50) DEFAULT 'local' COMMENT '存储提供商',
    storage_bucket VARCHAR(100) COMMENT '存储桶',
    storage_key VARCHAR(500) COMMENT '存储键',
    
    -- 文件属性
    is_public BOOLEAN DEFAULT FALSE COMMENT '是否公开',
    is_temporary BOOLEAN DEFAULT FALSE COMMENT '是否临时文件',
    expires_at TIMESTAMP NULL COMMENT '过期时间',
    
    -- 安全信息
    file_hash VARCHAR(64) COMMENT '文件哈希',
    encryption_method VARCHAR(50) COMMENT '加密方法',
    access_token VARCHAR(255) COMMENT '访问令牌',
    
    -- 统计信息
    download_count BIGINT DEFAULT 0 COMMENT '下载次数',
    last_accessed_at TIMESTAMP NULL COMMENT '最后访问时间',
    
    -- 软删除
    deleted_at TIMESTAMP NULL COMMENT '删除时间',
    deleted_by VARCHAR(36) COMMENT '删除人ID',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    -- 索引设计
    INDEX idx_tenant_user (tenant_id, user_id),
    INDEX idx_file_category (file_category, created_at),
    INDEX idx_business (business_type, business_id),
    INDEX idx_file_hash (file_hash),
    INDEX idx_expires_at (expires_at),
    INDEX idx_is_temporary (is_temporary, expires_at),
    
    -- 外键约束
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES saas_users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文件存储表';

-- 文件分享表
CREATE TABLE saas_file_shares (
    id VARCHAR(36) PRIMARY KEY COMMENT '分享ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    file_id VARCHAR(36) NOT NULL COMMENT '文件ID',
    
    -- 分享信息
    share_token VARCHAR(64) UNIQUE NOT NULL COMMENT '分享令牌',
    share_name VARCHAR(200) COMMENT '分享名称',
    share_description TEXT COMMENT '分享描述',
    
    -- 分享配置
    share_type ENUM('public', 'password', 'internal') DEFAULT 'password' COMMENT '分享类型',
    share_password VARCHAR(100) COMMENT '分享密码',
    allowed_users JSON COMMENT '允许访问的用户ID列表',
    
    -- 权限配置
    permissions JSON COMMENT '权限配置 {download, preview, edit}',
    max_downloads INT COMMENT '最大下载次数',
    
    -- 时间限制
    expires_at TIMESTAMP NULL COMMENT '过期时间',
    
    -- 统计信息
    access_count BIGINT DEFAULT 0 COMMENT '访问次数',
    download_count BIGINT DEFAULT 0 COMMENT '下载次数',
    last_accessed_at TIMESTAMP NULL COMMENT '最后访问时间',
    
    -- 状态管理
    is_active BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    
    -- 索引设计
    INDEX idx_tenant_file (tenant_id, file_id),
    INDEX idx_share_token (share_token),
    INDEX idx_expires_at (expires_at),
    INDEX idx_is_active (is_active),
    
    -- 外键约束
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (file_id) REFERENCES saas_files(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES saas_users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文件分享表';

-- =====================================================
-- 7. 创建视图
-- =====================================================

-- 租户概览视图
CREATE VIEW v_tenant_overview AS
SELECT 
    t.id,
    t.tenant_name,
    t.tenant_code,
    t.status,
    t.subscription_plan,
    COUNT(DISTINCT u.id) as user_count,
    COUNT(DISTINCT ur.role_id) as role_count,
    q.max_users,
    q.max_storage_gb,
    us.storage_used_gb,
    t.created_at
FROM saas_tenants t
LEFT JOIN saas_users u ON t.id = u.tenant_id AND u.deleted_at IS NULL
LEFT JOIN saas_user_roles ur ON u.id = ur.user_id AND ur.status = 'active'
LEFT JOIN saas_tenant_quotas q ON t.id = q.tenant_id
LEFT JOIN saas_usage_statistics us ON t.id = us.tenant_id AND us.usage_date = CURDATE()
GROUP BY t.id, t.tenant_name, t.tenant_code, t.status, t.subscription_plan, 
         q.max_users, q.max_storage_gb, us.storage_used_gb, t.created_at;

-- 用户权限视图
CREATE VIEW v_user_permissions AS
SELECT 
    u.id as user_id,
    u.tenant_id,
    u.username,
    r.role_code,
    p.permission_code,
    p.module,
    p.action,
    ur.scope_type,
    ur.status as role_status
FROM saas_users u
JOIN saas_user_roles ur ON u.id = ur.user_id AND ur.status = 'active'
JOIN saas_roles r ON ur.role_id = r.id AND r.status = 'active'
JOIN saas_role_permissions rp ON r.id = rp.role_id
JOIN saas_permissions p ON rp.permission_id = p.id AND p.status = 'active'
WHERE u.deleted_at IS NULL;

-- =====================================================
-- 8. 创建存储过程
-- =====================================================

DELIMITER //

-- 检查租户配额
CREATE PROCEDURE sp_check_tenant_quota(
    IN p_tenant_id VARCHAR(36),
    IN p_resource_type VARCHAR(50),
    IN p_requested_amount BIGINT,
    OUT p_allowed BOOLEAN,
    OUT p_current_usage BIGINT,
    OUT p_limit_value BIGINT
)
BEGIN
    DECLARE v_limit_value BIGINT DEFAULT 0;
    DECLARE v_current_usage BIGINT DEFAULT 0;
    
    -- 获取配额限制
    CASE p_resource_type
        WHEN 'users' THEN
            SELECT max_users INTO v_limit_value 
            FROM saas_tenant_quotas WHERE tenant_id = p_tenant_id;
            
            SELECT COUNT(*) INTO v_current_usage 
            FROM saas_users WHERE tenant_id = p_tenant_id AND deleted_at IS NULL;
            
        WHEN 'storage_gb' THEN
            SELECT max_storage_gb INTO v_limit_value 
            FROM saas_tenant_quotas WHERE tenant_id = p_tenant_id;
            
            SELECT COALESCE(storage_used_gb, 0) INTO v_current_usage 
            FROM saas_usage_statistics 
            WHERE tenant_id = p_tenant_id AND usage_date = CURDATE();
            
        ELSE
            SET v_limit_value = 0;
            SET v_current_usage = 0;
    END CASE;
    
    -- 检查是否允许
    SET p_current_usage = v_current_usage;
    SET p_limit_value = v_limit_value;
    SET p_allowed = (v_current_usage + p_requested_amount <= v_limit_value);
    
END //

-- 清理过期数据
CREATE PROCEDURE sp_cleanup_expired_data()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE cleanup_count INT DEFAULT 0;
    
    START TRANSACTION;
    
    -- 清理过期会话
    DELETE FROM saas_user_sessions 
    WHERE expires_at < NOW() AND status != 'active';
    SET cleanup_count = cleanup_count + ROW_COUNT();
    
    -- 清理过期文件分享
    UPDATE saas_file_shares 
    SET is_active = FALSE 
    WHERE expires_at < NOW() AND is_active = TRUE;
    SET cleanup_count = cleanup_count + ROW_COUNT();
    
    -- 清理临时文件
    DELETE FROM saas_files 
    WHERE is_temporary = TRUE AND expires_at < NOW();
    SET cleanup_count = cleanup_count + ROW_COUNT();
    
    -- 清理过期告警
    UPDATE saas_unified_alerts 
    SET status = 'expired' 
    WHERE created_at < DATE_SUB(NOW(), INTERVAL 30 DAY) 
    AND status = 'open';
    SET cleanup_count = cleanup_count + ROW_COUNT();
    
    COMMIT;
    
    SELECT CONCAT('清理完成，影响记录数: ', cleanup_count) as result;
    
END //

DELIMITER ;

-- =====================================================
-- 9. 插入初始数据
-- =====================================================

-- 插入系统权限
INSERT INTO saas_permissions (id, permission_code, permission_name, module, resource, action, description) VALUES
(UUID(), 'system:tenant:manage', '租户管理', 'system', 'tenant', 'manage', '管理租户信息'),
(UUID(), 'system:user:create', '创建用户', 'system', 'user', 'create', '创建新用户'),
(UUID(), 'system:user:read', '查看用户', 'system', 'user', 'read', '查看用户信息'),
(UUID(), 'system:user:update', '更新用户', 'system', 'user', 'update', '更新用户信息'),
(UUID(), 'system:user:delete', '删除用户', 'system', 'user', 'delete', '删除用户'),
(UUID(), 'system:role:manage', '角色管理', 'system', 'role', 'manage', '管理角色'),
(UUID(), 'system:config:read', '查看配置', 'system', 'config', 'read', '查看系统配置'),
(UUID(), 'system:config:write', '修改配置', 'system', 'config', 'write', '修改系统配置'),
(UUID(), 'wework:account:manage', '企微账号管理', 'wework', 'account', 'manage', '管理企微账号'),
(UUID(), 'ai:agent:manage', 'AI智能体管理', 'ai', 'agent', 'manage', '管理AI智能体'),
(UUID(), 'health:patient:manage', '患者管理', 'health', 'patient', 'manage', '管理患者信息');

-- 插入系统角色
INSERT INTO saas_roles (id, tenant_id, role_code, role_name, role_description, is_system_role) VALUES
(UUID(), 'system', 'super_admin', '超级管理员', '系统超级管理员', TRUE),
(UUID(), 'system', 'tenant_admin', '租户管理员', '租户管理员', TRUE),
(UUID(), 'system', 'operator', '操作员', '系统操作员', TRUE),
(UUID(), 'system', 'viewer', '查看者', '只读用户', TRUE);

-- 插入基础配置
INSERT INTO saas_unified_configs (id, config_scope, config_category, config_key, config_value, config_description) VALUES
(UUID(), 'global', 'system', 'system.name', '"企业级SaaS统一平台"', '系统名称'),
(UUID(), 'global', 'system', 'system.version', '"1.0.0"', '系统版本'),
(UUID(), 'global', 'security', 'password.min_length', '8', '密码最小长度'),
(UUID(), 'global', 'security', 'session.timeout', '7200', '会话超时时间(秒)'),
(UUID(), 'global', 'quota', 'default.max_users', '10', '默认最大用户数'),
(UUID(), 'global', 'quota', 'default.max_storage_gb', '10', '默认最大存储空间(GB)');

-- 创建默认租户
INSERT INTO saas_tenants (id, tenant_code, tenant_name, status, created_at) VALUES
('default-tenant', 'default', '默认租户', 'active', NOW());

-- 为默认租户创建配额
INSERT INTO saas_tenant_quotas (id, tenant_id, effective_from) VALUES
(UUID(), 'default-tenant', CURDATE());

-- =====================================================
-- 10. 启用事件调度器
-- =====================================================

SET GLOBAL event_scheduler = ON;

-- 创建定时清理任务
CREATE EVENT IF NOT EXISTS cleanup_expired_data
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
CALL sp_cleanup_expired_data();

-- =====================================================
-- 完成提示
-- =====================================================

SELECT '🎉 SaaS统一核心层数据库初始化完成！' as message;
SELECT '📊 包含身份管理、安全审计、配额计费、系统管理等核心功能' as features;
SELECT '🔧 已创建视图、存储过程和定时任务' as additional_features;