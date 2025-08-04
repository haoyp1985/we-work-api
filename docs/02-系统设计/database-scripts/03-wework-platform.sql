-- =====================================================
-- 企微平台数据库设计
-- 包含：账号管理、消息管理、联系人管理、群聊管理、监控告警
-- =====================================================

-- 创建企微平台数据库
CREATE DATABASE IF NOT EXISTS `wework_platform` 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `wework_platform`;

-- =====================================================
-- 1. 账号管理层
-- =====================================================

-- 企微账号表 (完整保留9种状态)
CREATE TABLE wework_accounts (
    id VARCHAR(36) PRIMARY KEY COMMENT '账号ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    account_name VARCHAR(100) NOT NULL COMMENT '账号名称',
    wework_guid VARCHAR(100) UNIQUE COMMENT '企微实例GUID',
    proxy_id VARCHAR(100) COMMENT '代理ID',
    phone VARCHAR(20) COMMENT '绑定手机号',
    callback_url VARCHAR(500) COMMENT '回调地址',
    
    -- 状态相关字段 (完整保留9种状态)
    status ENUM(
        'CREATED', 'INITIALIZING', 'WAITING_QR', 'WAITING_CONFIRM',
        'VERIFYING', 'ONLINE', 'OFFLINE', 'ERROR', 'RECOVERING'
    ) NOT NULL DEFAULT 'CREATED' COMMENT '账号状态',
    health_score INT DEFAULT 100 COMMENT '健康度评分 (0-100)',
    last_login_time TIMESTAMP NULL COMMENT '最后登录时间',
    last_heartbeat_time TIMESTAMP NULL COMMENT '最后心跳时间',
    
    -- 配置相关字段 (生命周期管理必需)
    auto_reconnect BOOLEAN DEFAULT TRUE COMMENT '是否自动重连',
    monitor_interval INT DEFAULT 30 COMMENT '监控间隔(秒)',
    max_retry_count INT DEFAULT 3 COMMENT '最大重试次数',
    retry_count INT DEFAULT 0 COMMENT '当前重试次数',
    config_json JSON COMMENT '账号配置(JSON格式)',
    tenant_tag VARCHAR(50) COMMENT '租户标签(用于分组管理)',
    
    -- 登录相关信息
    qr_code_url VARCHAR(500) COMMENT '二维码URL',
    qr_code_expires_at TIMESTAMP NULL COMMENT '二维码过期时间',
    login_token VARCHAR(255) COMMENT '登录令牌',
    device_info JSON COMMENT '设备信息',
    
    -- 企微实例信息
    wework_user_id VARCHAR(100) COMMENT '企微用户ID',
    wework_user_name VARCHAR(100) COMMENT '企微用户名',
    wework_corp_id VARCHAR(100) COMMENT '企业ID',
    wework_corp_name VARCHAR(200) COMMENT '企业名称',
    
    -- 统计信息 (生命周期跟踪)
    total_messages BIGINT DEFAULT 0 COMMENT '总消息数',
    successful_messages BIGINT DEFAULT 0 COMMENT '成功消息数',
    failed_messages BIGINT DEFAULT 0 COMMENT '失败消息数',
    online_duration_hours DECIMAL(10,2) DEFAULT 0 COMMENT '在线时长(小时)',
    offline_count INT DEFAULT 0 COMMENT '离线次数',
    error_count INT DEFAULT 0 COMMENT '错误次数',
    recovery_count INT DEFAULT 0 COMMENT '恢复次数',
    last_error_at TIMESTAMP NULL COMMENT '最后错误时间',
    last_recovery_at TIMESTAMP NULL COMMENT '最后恢复时间',
    
    -- 性能指标
    avg_message_response_time DECIMAL(8,3) DEFAULT 0 COMMENT '平均消息响应时间',
    message_success_rate DECIMAL(5,2) DEFAULT 0 COMMENT '消息成功率',
    uptime_percentage DECIMAL(5,2) DEFAULT 0 COMMENT '在线率',
    
    -- 限制配置
    daily_message_limit INT DEFAULT 1000 COMMENT '日消息限制',
    hourly_message_limit INT DEFAULT 100 COMMENT '小时消息限制',
    message_interval_ms INT DEFAULT 1000 COMMENT '消息间隔(毫秒)',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    
    INDEX idx_tenant_status (tenant_id, status),
    INDEX idx_tenant_name (tenant_id, account_name),
    INDEX idx_status_heartbeat (status, last_heartbeat_time),
    INDEX idx_health_score (health_score),
    INDEX idx_tenant_tag (tenant_id, tenant_tag),
    INDEX idx_wework_guid (wework_guid),
    INDEX idx_retry_count (retry_count),
    INDEX idx_performance (message_success_rate, uptime_percentage),
    INDEX idx_wework_user_id (wework_user_id),
    INDEX idx_wework_corp_id (wework_corp_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企微账号表';

-- 账号状态历史表 (生命周期闭环跟踪核心)
CREATE TABLE wework_account_status_history (
    id VARCHAR(36) PRIMARY KEY COMMENT '历史ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    account_id VARCHAR(36) NOT NULL COMMENT '账号ID',
    
    -- 状态变更信息 (生命周期跟踪核心)
    old_status ENUM(
        'CREATED', 'INITIALIZING', 'WAITING_QR', 'WAITING_CONFIRM',
        'VERIFYING', 'ONLINE', 'OFFLINE', 'ERROR', 'RECOVERING'
    ) COMMENT '旧状态',
    new_status ENUM(
        'CREATED', 'INITIALIZING', 'WAITING_QR', 'WAITING_CONFIRM',
        'VERIFYING', 'ONLINE', 'OFFLINE', 'ERROR', 'RECOVERING'
    ) NOT NULL COMMENT '新状态',
    change_reason VARCHAR(500) COMMENT '变更原因',
    trigger_type ENUM('MANUAL', 'AUTO', 'CALLBACK', 'MONITOR', 'SCHEDULED', 'SYSTEM', 'HEARTBEAT_TIMEOUT', 'ERROR_RECOVERY') 
        NOT NULL DEFAULT 'AUTO' COMMENT '触发类型',
    extra_data JSON COMMENT '额外数据(包含错误信息、恢复操作等)',
    
    -- 状态持续时间分析 (生命周期分析)
    duration_seconds INT COMMENT '在上一状态的持续时间(秒)',
    expected_duration_seconds INT COMMENT '预期持续时间',
    is_abnormal_duration BOOLEAN DEFAULT FALSE COMMENT '是否异常持续时间',
    
    -- 环境信息
    server_node VARCHAR(50) COMMENT '服务节点',
    client_version VARCHAR(20) COMMENT '客户端版本',
    network_quality VARCHAR(20) COMMENT '网络质量',
    
    -- 操作审计信息  
    operator_id VARCHAR(36) COMMENT '操作用户ID',
    operator_name VARCHAR(100) COMMENT '操作用户名',
    ip_address VARCHAR(45) COMMENT 'IP地址',
    user_agent VARCHAR(500) COMMENT '用户代理',
    
    -- 业务影响分析
    affected_conversations INT DEFAULT 0 COMMENT '影响的会话数',
    lost_messages INT DEFAULT 0 COMMENT '丢失的消息数',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX idx_tenant_account (tenant_id, account_id),
    INDEX idx_account_time (account_id, created_at),
    INDEX idx_status_change (old_status, new_status),
    INDEX idx_trigger_type (trigger_type),
    INDEX idx_operator (operator_id),
    INDEX idx_abnormal_duration (is_abnormal_duration),
    INDEX idx_duration (duration_seconds),
    
    FOREIGN KEY (account_id) REFERENCES wework_accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企微账号状态历史表';

-- 账号告警表
CREATE TABLE wework_account_alerts (
    id VARCHAR(36) PRIMARY KEY COMMENT '告警ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    account_id VARCHAR(36) NOT NULL COMMENT '账号ID',
    
    -- 告警基本信息
    alert_type ENUM(
        'heartbeat_timeout', 'login_failed', 'message_send_failed', 'auto_recovery_failed',
        'retry_limit_reached', 'abnormal_offline', 'performance_degraded', 'health_score_low',
        'network_error', 'callback_error', 'qr_code_expired', 'verification_timeout',
        'excessive_errors', 'resource_exhausted', 'custom'
    ) NOT NULL COMMENT '告警类型',
    alert_level ENUM('info', 'warning', 'error', 'critical') NOT NULL COMMENT '告警级别',
    alert_title VARCHAR(200) NOT NULL COMMENT '告警标题',
    alert_message TEXT NOT NULL COMMENT '告警消息',
    alert_data JSON COMMENT '告警详细数据',
    
    -- 状态管理
    status ENUM('open', 'acknowledged', 'resolved', 'suppressed') DEFAULT 'open' COMMENT '告警状态',
    
    -- 时间管理
    first_occurred_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '首次发生时间',
    last_occurred_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最后发生时间',
    occurrence_count INT DEFAULT 1 COMMENT '发生次数',
    
    -- 处理信息
    acknowledged_by VARCHAR(36) COMMENT '确认人ID',
    acknowledged_at TIMESTAMP NULL COMMENT '确认时间',
    resolved_by VARCHAR(36) COMMENT '解决人ID',
    resolved_at TIMESTAMP NULL COMMENT '解决时间',
    resolution_action VARCHAR(500) COMMENT '解决措施',
    
    -- 通知状态
    notification_sent BOOLEAN DEFAULT FALSE COMMENT '是否已发送通知',
    notification_channels JSON COMMENT '通知渠道',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX idx_tenant_account (tenant_id, account_id),
    INDEX idx_alert_type (alert_type, created_at),
    INDEX idx_alert_level (alert_level, status),
    INDEX idx_status (status, created_at),
    INDEX idx_occurrence_time (last_occurred_at),
    
    FOREIGN KEY (account_id) REFERENCES wework_accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企微账号告警表';

-- 账号监控规则表
CREATE TABLE wework_account_monitor_rules (
    id VARCHAR(36) PRIMARY KEY COMMENT '规则ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    account_id VARCHAR(36) COMMENT '账号ID - NULL表示全局规则',
    
    -- 规则基本信息
    rule_name VARCHAR(100) NOT NULL COMMENT '规则名称',
    rule_type ENUM(
        'heartbeat_check', 'message_success_rate', 'response_time', 'error_rate',
        'offline_duration', 'retry_count', 'health_score', 'message_volume',
        'login_frequency', 'performance_metrics', 'network_quality', 'custom_metric',
        'status_duration', 'qr_code_timeout'
    ) NOT NULL COMMENT '规则类型',
    description TEXT COMMENT '规则描述',
    
    -- 监控配置
    check_interval INT DEFAULT 60 COMMENT '检查间隔(秒)',
    threshold_config JSON NOT NULL COMMENT '阈值配置',
    trigger_condition VARCHAR(500) COMMENT '触发条件表达式',
    
    -- 告警配置
    alert_level ENUM('info', 'warning', 'error', 'critical') NOT NULL COMMENT '告警级别',
    alert_template VARCHAR(200) COMMENT '告警模板',
    notification_channels JSON COMMENT '通知渠道配置',
    
    -- 自动处理
    enable_auto_action BOOLEAN DEFAULT FALSE COMMENT '是否启用自动处理',
    auto_action_config JSON COMMENT '自动处理配置',
    
    -- 规则状态
    is_enabled BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    execution_count BIGINT DEFAULT 0 COMMENT '执行次数',
    trigger_count BIGINT DEFAULT 0 COMMENT '触发次数',
    last_executed_at TIMESTAMP NULL COMMENT '最后执行时间',
    last_triggered_at TIMESTAMP NULL COMMENT '最后触发时间',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    
    INDEX idx_tenant_account (tenant_id, account_id),
    INDEX idx_rule_type (rule_type),
    INDEX idx_is_enabled (is_enabled),
    INDEX idx_execution_stats (execution_count, trigger_count),
    
    FOREIGN KEY (account_id) REFERENCES wework_accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企微账号监控规则表';

-- =====================================================
-- 2. 消息管理层
-- =====================================================

-- 消息记录表 (分区表)
CREATE TABLE wework_message_records (
    id VARCHAR(36) NOT NULL COMMENT '消息ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    account_id VARCHAR(36) NOT NULL COMMENT '账号ID',
    
    -- 消息基本信息
    message_id VARCHAR(64) UNIQUE NOT NULL COMMENT '消息唯一标识',
    conversation_id VARCHAR(64) NOT NULL COMMENT '会话ID',
    direction ENUM('send', 'receive') NOT NULL COMMENT '消息方向',
    message_type ENUM('text', 'image', 'file', 'voice', 'video', 'location', 'card', 'system') NOT NULL COMMENT '消息类型',
    
    -- 发送者信息
    from_type ENUM('user', 'contact', 'group', 'system') NOT NULL COMMENT '发送者类型',
    from_id VARCHAR(100) NOT NULL COMMENT '发送者ID',
    from_name VARCHAR(200) COMMENT '发送者名称',
    
    -- 接收者信息
    to_type ENUM('user', 'contact', 'group', 'system') NOT NULL COMMENT '接收者类型',
    to_id VARCHAR(100) NOT NULL COMMENT '接收者ID',
    to_name VARCHAR(200) COMMENT '接收者名称',
    
    -- 消息内容
    content LONGTEXT NOT NULL COMMENT '消息内容',
    content_url VARCHAR(500) COMMENT '内容URL(图片、文件等)',
    media_info JSON COMMENT '媒体信息(尺寸、时长等)',
    raw_data JSON COMMENT '原始数据',
    
    -- 消息状态 (生命周期跟踪)
    send_status ENUM('pending', 'sending', 'sent', 'delivered', 'read', 'failed', 'recalled') DEFAULT 'pending' COMMENT '发送状态',
    error_code VARCHAR(50) COMMENT '错误代码',
    error_message TEXT COMMENT '错误信息',
    retry_count INT DEFAULT 0 COMMENT '重试次数',
    
    -- 时间信息
    scheduled_at TIMESTAMP NULL COMMENT '计划发送时间',
    sent_at TIMESTAMP NULL COMMENT '发送时间',
    delivered_at TIMESTAMP NULL COMMENT '送达时间',
    read_at TIMESTAMP NULL COMMENT '已读时间',
    recalled_at TIMESTAMP NULL COMMENT '撤回时间',
    
    -- 性能信息
    processing_time_ms INT COMMENT '处理时间(毫秒)',
    response_time_ms INT COMMENT '响应时间(毫秒)',
    
    -- 业务扩展
    template_id VARCHAR(36) COMMENT '消息模板ID',
    campaign_id VARCHAR(36) COMMENT '活动ID',
    tags JSON COMMENT '标签',
    priority ENUM('low', 'normal', 'high', 'urgent') DEFAULT 'normal' COMMENT '优先级',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    -- 复合主键，包含分区键
    PRIMARY KEY (id, created_at),
    
    INDEX idx_tenant_account (tenant_id, account_id),
    INDEX idx_message_id (message_id),
    INDEX idx_conversation_id (conversation_id),
    INDEX idx_direction_type (direction, message_type),
    INDEX idx_send_status (send_status, created_at),
    INDEX idx_from_to (from_id, to_id),
    INDEX idx_sent_at (sent_at),
    
    FOREIGN KEY (account_id) REFERENCES wework_accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企微消息记录表'
PARTITION BY RANGE (UNIX_TIMESTAMP(created_at)) (
    PARTITION p202501 VALUES LESS THAN (UNIX_TIMESTAMP('2025-02-01 00:00:00')),
    PARTITION p202502 VALUES LESS THAN (UNIX_TIMESTAMP('2025-03-01 00:00:00')),
    PARTITION p202503 VALUES LESS THAN (UNIX_TIMESTAMP('2025-04-01 00:00:00')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- 消息模板表
CREATE TABLE wework_message_templates (
    id VARCHAR(36) PRIMARY KEY COMMENT '模板ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 模板基本信息
    template_name VARCHAR(100) NOT NULL COMMENT '模板名称',
    template_code VARCHAR(50) NOT NULL COMMENT '模板编码',
    description TEXT COMMENT '模板描述',
    message_type ENUM('text', 'image', 'file', 'voice', 'video', 'card') NOT NULL COMMENT '消息类型',
    
    -- 模板内容
    content_template TEXT NOT NULL COMMENT '内容模板',
    variables JSON COMMENT '变量定义',
    default_values JSON COMMENT '默认值',
    
    -- 发送配置
    send_config JSON COMMENT '发送配置',
    rate_limit JSON COMMENT '限流配置',
    retry_config JSON COMMENT '重试配置',
    
    -- 模板分类
    category VARCHAR(50) COMMENT '模板分类',
    tags JSON COMMENT '标签',
    
    -- 状态统计
    is_active BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    usage_count BIGINT DEFAULT 0 COMMENT '使用次数',
    success_count BIGINT DEFAULT 0 COMMENT '成功次数',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    
    UNIQUE KEY uk_tenant_template_code (tenant_id, template_code),
    INDEX idx_message_type (message_type),
    INDEX idx_category (category),
    INDEX idx_is_active (is_active),
    INDEX idx_usage_stats (usage_count, success_count)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企微消息模板表';

-- =====================================================
-- 3. 联系人管理层
-- =====================================================

-- 联系人表
CREATE TABLE wework_contacts (
    id VARCHAR(36) PRIMARY KEY COMMENT '联系人ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    account_id VARCHAR(36) NOT NULL COMMENT '账号ID',
    
    -- 企微联系人信息
    wework_contact_id VARCHAR(100) NOT NULL COMMENT '企微联系人ID',
    contact_type ENUM('internal', 'external', 'customer') NOT NULL COMMENT '联系人类型',
    
    -- 基本信息
    contact_name VARCHAR(200) NOT NULL COMMENT '联系人姓名',
    alias VARCHAR(200) COMMENT '备注名',
    avatar_url VARCHAR(500) COMMENT '头像URL',
    gender ENUM('male', 'female', 'unknown') DEFAULT 'unknown' COMMENT '性别',
    
    -- 联系方式
    phone VARCHAR(20) COMMENT '手机号',
    email VARCHAR(100) COMMENT '邮箱',
    
    -- 企业信息(外部联系人)
    corp_name VARCHAR(200) COMMENT '企业名称',
    corp_full_name VARCHAR(500) COMMENT '企业全称',
    department VARCHAR(200) COMMENT '部门',
    position VARCHAR(100) COMMENT '职位',
    
    -- 标签信息
    tags JSON COMMENT '标签列表',
    custom_fields JSON COMMENT '自定义字段',
    
    -- 关系信息
    relation_type VARCHAR(50) COMMENT '关系类型',
    source VARCHAR(100) COMMENT '添加来源',
    remark TEXT COMMENT '备注',
    
    -- 状态信息
    status ENUM('normal', 'blocked', 'deleted', 'invalid') DEFAULT 'normal' COMMENT '状态',
    is_friend BOOLEAN DEFAULT FALSE COMMENT '是否好友',
    is_starred BOOLEAN DEFAULT FALSE COMMENT '是否星标',
    is_blacklisted BOOLEAN DEFAULT FALSE COMMENT '是否黑名单',
    
    -- 统计信息
    message_count BIGINT DEFAULT 0 COMMENT '消息数量',
    last_message_at TIMESTAMP NULL COMMENT '最后消息时间',
    last_contact_at TIMESTAMP NULL COMMENT '最后联系时间',
    
    -- 同步信息
    last_sync_at TIMESTAMP NULL COMMENT '最后同步时间',
    sync_status ENUM('pending', 'success', 'failed') DEFAULT 'pending' COMMENT '同步状态',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY uk_account_wework_contact (account_id, wework_contact_id),
    INDEX idx_tenant_account (tenant_id, account_id),
    INDEX idx_contact_name (contact_name),
    INDEX idx_contact_type (contact_type),
    INDEX idx_corp_name (corp_name),
    INDEX idx_status (status),
    INDEX idx_is_friend (is_friend),
    INDEX idx_last_message (last_message_at),
    
    FOREIGN KEY (account_id) REFERENCES wework_accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企微联系人表';

-- =====================================================
-- 4. 群聊管理层
-- =====================================================

-- 群聊表
CREATE TABLE wework_groups (
    id VARCHAR(36) PRIMARY KEY COMMENT '群聊ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    account_id VARCHAR(36) NOT NULL COMMENT '账号ID',
    
    -- 企微群聊信息
    wework_group_id VARCHAR(100) NOT NULL COMMENT '企微群聊ID',
    group_name VARCHAR(200) NOT NULL COMMENT '群聊名称',
    group_notice TEXT COMMENT '群公告',
    avatar_url VARCHAR(500) COMMENT '群头像URL',
    
    -- 群聊配置
    group_type ENUM('internal', 'external', 'customer') NOT NULL COMMENT '群聊类型',
    owner_id VARCHAR(100) COMMENT '群主ID',
    member_count INT DEFAULT 0 COMMENT '成员数量',
    max_member_count INT DEFAULT 500 COMMENT '最大成员数',
    
    -- 群聊状态
    status ENUM('active', 'disbanded', 'archived', 'muted') DEFAULT 'active' COMMENT '群聊状态',
    is_muted BOOLEAN DEFAULT FALSE COMMENT '是否免打扰',
    is_pinned BOOLEAN DEFAULT FALSE COMMENT '是否置顶',
    
    -- 管理配置
    invite_permission ENUM('owner', 'admin', 'member', 'none') DEFAULT 'member' COMMENT '邀请权限',
    message_permission ENUM('all', 'admin_only', 'muted') DEFAULT 'all' COMMENT '发言权限',
    
    -- 统计信息 (生命周期跟踪)
    message_count BIGINT DEFAULT 0 COMMENT '消息数量',
    last_message_at TIMESTAMP NULL COMMENT '最后消息时间',
    last_active_at TIMESTAMP NULL COMMENT '最后活跃时间',
    
    -- 同步信息
    last_sync_at TIMESTAMP NULL COMMENT '最后同步时间',
    sync_status ENUM('pending', 'success', 'failed') DEFAULT 'pending' COMMENT '同步状态',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY uk_account_wework_group (account_id, wework_group_id),
    INDEX idx_tenant_account (tenant_id, account_id),
    INDEX idx_group_name (group_name),
    INDEX idx_group_type (group_type),
    INDEX idx_status (status),
    INDEX idx_member_count (member_count),
    INDEX idx_last_message (last_message_at),
    
    FOREIGN KEY (account_id) REFERENCES wework_accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企微群聊表';

-- 群成员表
CREATE TABLE wework_group_members (
    id VARCHAR(36) PRIMARY KEY COMMENT '成员ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    group_id VARCHAR(36) NOT NULL COMMENT '群聊ID',
    
    -- 成员信息
    member_wework_id VARCHAR(100) NOT NULL COMMENT '成员企微ID',
    member_name VARCHAR(200) NOT NULL COMMENT '成员名称',
    nickname VARCHAR(200) COMMENT '群昵称',
    avatar_url VARCHAR(500) COMMENT '头像URL',
    
    -- 成员角色
    role ENUM('owner', 'admin', 'member') DEFAULT 'member' COMMENT '群内角色',
    join_type ENUM('invite', 'scan', 'search', 'share') COMMENT '加入方式',
    inviter_id VARCHAR(100) COMMENT '邀请人ID',
    
    -- 成员状态
    status ENUM('active', 'removed', 'left', 'kicked') DEFAULT 'active' COMMENT '成员状态',
    is_muted BOOLEAN DEFAULT FALSE COMMENT '是否禁言',
    mute_until TIMESTAMP NULL COMMENT '禁言到期时间',
    
    -- 时间信息
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
    left_at TIMESTAMP NULL COMMENT '离开时间',
    last_active_at TIMESTAMP NULL COMMENT '最后活跃时间',
    
    -- 统计信息
    message_count BIGINT DEFAULT 0 COMMENT '发言次数',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY uk_group_member (group_id, member_wework_id),
    INDEX idx_tenant_group (tenant_id, group_id),
    INDEX idx_member_wework_id (member_wework_id),
    INDEX idx_role (role),
    INDEX idx_status (status),
    INDEX idx_joined_at (joined_at),
    
    FOREIGN KEY (group_id) REFERENCES wework_groups(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企微群成员表';

-- =====================================================
-- 5. 会话管理层
-- =====================================================

-- 会话表
CREATE TABLE wework_conversations (
    id VARCHAR(36) PRIMARY KEY COMMENT '会话ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    account_id VARCHAR(36) NOT NULL COMMENT '账号ID',
    
    -- 会话基本信息
    conversation_id VARCHAR(64) UNIQUE NOT NULL COMMENT '会话唯一标识',
    conversation_type ENUM('contact', 'group', 'system') NOT NULL COMMENT '会话类型',
    target_id VARCHAR(100) NOT NULL COMMENT '目标ID(联系人ID或群聊ID)',
    target_name VARCHAR(200) NOT NULL COMMENT '目标名称',
    
    -- 会话状态
    status ENUM('active', 'archived', 'deleted', 'muted') DEFAULT 'active' COMMENT '会话状态',
    is_pinned BOOLEAN DEFAULT FALSE COMMENT '是否置顶',
    is_muted BOOLEAN DEFAULT FALSE COMMENT '是否免打扰',
    unread_count INT DEFAULT 0 COMMENT '未读消息数',
    
    -- 最新消息信息 (生命周期跟踪)
    last_message_id VARCHAR(36) COMMENT '最新消息ID',
    last_message_content TEXT COMMENT '最新消息内容',
    last_message_type ENUM('text', 'image', 'file', 'voice', 'video', 'location', 'card', 'system') COMMENT '最新消息类型',
    last_message_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '最新消息时间',
    
    -- 统计信息
    total_messages BIGINT DEFAULT 0 COMMENT '总消息数',
    sent_messages BIGINT DEFAULT 0 COMMENT '发送消息数',
    received_messages BIGINT DEFAULT 0 COMMENT '接收消息数',
    
    -- 时间信息
    first_message_at TIMESTAMP NULL COMMENT '首条消息时间',
    last_read_at TIMESTAMP NULL COMMENT '最后已读时间',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY uk_account_conversation (account_id, conversation_id),
    INDEX idx_tenant_account (tenant_id, account_id),
    INDEX idx_conversation_type (conversation_type),
    INDEX idx_target_id (target_id),
    INDEX idx_status (status),
    INDEX idx_last_message_at (last_message_at),
    INDEX idx_unread_count (unread_count),
    
    FOREIGN KEY (account_id) REFERENCES wework_accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企微会话表';

-- =====================================================
-- 6. 统计分析层
-- =====================================================

-- 租户使用统计表
CREATE TABLE wework_tenant_usage (
    id VARCHAR(36) PRIMARY KEY COMMENT '统计ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    stat_date DATE NOT NULL COMMENT '统计日期',
    
    -- 账号统计
    total_accounts INT DEFAULT 0 COMMENT '总账号数',
    online_accounts INT DEFAULT 0 COMMENT '在线账号数',
    active_accounts INT DEFAULT 0 COMMENT '活跃账号数',
    
    -- 消息统计
    total_messages BIGINT DEFAULT 0 COMMENT '总消息数',
    sent_messages BIGINT DEFAULT 0 COMMENT '发送消息数',
    received_messages BIGINT DEFAULT 0 COMMENT '接收消息数',
    failed_messages BIGINT DEFAULT 0 COMMENT '失败消息数',
    
    -- 联系人统计
    total_contacts INT DEFAULT 0 COMMENT '总联系人数',
    new_contacts INT DEFAULT 0 COMMENT '新增联系人数',
    active_contacts INT DEFAULT 0 COMMENT '活跃联系人数',
    
    -- 群聊统计
    total_groups INT DEFAULT 0 COMMENT '总群聊数',
    active_groups INT DEFAULT 0 COMMENT '活跃群聊数',
    group_messages BIGINT DEFAULT 0 COMMENT '群消息数',
    
    -- 性能统计
    avg_response_time DECIMAL(8,3) COMMENT '平均响应时间',
    message_success_rate DECIMAL(5,2) COMMENT '消息成功率',
    uptime_percentage DECIMAL(5,2) COMMENT '在线率',
    
    -- 告警统计
    total_alerts INT DEFAULT 0 COMMENT '总告警数',
    critical_alerts INT DEFAULT 0 COMMENT '严重告警数',
    resolved_alerts INT DEFAULT 0 COMMENT '已解决告警数',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY uk_tenant_date (tenant_id, stat_date),
    INDEX idx_stat_date (stat_date),
    INDEX idx_tenant_month (tenant_id, stat_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企微租户使用统计表';

-- =====================================================
-- 7. 回调日志表 (分区表)
-- =====================================================

CREATE TABLE wework_callback_logs (
    id VARCHAR(36) NOT NULL COMMENT '日志ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    account_id VARCHAR(36) COMMENT '账号ID',
    
    -- 回调基本信息
    callback_type ENUM('message', 'status', 'contact', 'group', 'system', 'error') NOT NULL COMMENT '回调类型',
    event_type VARCHAR(50) NOT NULL COMMENT '事件类型',
    callback_url VARCHAR(500) COMMENT '回调URL',
    
    -- 请求信息
    request_method VARCHAR(10) DEFAULT 'POST' COMMENT '请求方法',
    request_headers JSON COMMENT '请求头',
    request_body LONGTEXT COMMENT '请求体',
    
    -- 响应信息
    response_status INT COMMENT '响应状态码',
    response_headers JSON COMMENT '响应头',
    response_body TEXT COMMENT '响应体',
    response_time DECIMAL(8,3) COMMENT '响应时间(秒)',
    
    -- 处理结果
    processing_status ENUM('success', 'failed', 'timeout', 'ignored') NOT NULL COMMENT '处理状态',
    error_message TEXT COMMENT '错误信息',
    retry_count INT DEFAULT 0 COMMENT '重试次数',
    
    -- 业务数据
    business_data JSON COMMENT '业务数据',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    -- 复合主键，包含分区键
    PRIMARY KEY (id, created_at),
    
    INDEX idx_tenant_account (tenant_id, account_id),
    INDEX idx_callback_type (callback_type, created_at),
    INDEX idx_event_type (event_type),
    INDEX idx_processing_status (processing_status),
    INDEX idx_response_status (response_status),
    
    FOREIGN KEY (account_id) REFERENCES wework_accounts(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企微回调日志表'
PARTITION BY RANGE (UNIX_TIMESTAMP(created_at)) (
    PARTITION p202501 VALUES LESS THAN (UNIX_TIMESTAMP('2025-02-01 00:00:00')),
    PARTITION p202502 VALUES LESS THAN (UNIX_TIMESTAMP('2025-03-01 00:00:00')),
    PARTITION p202503 VALUES LESS THAN (UNIX_TIMESTAMP('2025-04-01 00:00:00')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- =====================================================
-- 8. 创建视图
-- =====================================================

-- 账号概览视图
CREATE VIEW v_wework_account_overview AS
SELECT 
    a.id,
    a.tenant_id,
    a.account_name,
    a.wework_guid,
    a.status,
    a.health_score,
    a.message_success_rate,
    a.uptime_percentage,
    a.total_messages,
    a.online_duration_hours,
    COUNT(DISTINCT c.id) as contact_count,
    COUNT(DISTINCT g.id) as group_count,
    COUNT(DISTINCT conv.id) as conversation_count,
    COALESCE(alert_stats.open_alerts, 0) as open_alerts,
    a.last_heartbeat_time,
    a.created_at
FROM wework_accounts a
LEFT JOIN wework_contacts c ON a.id = c.account_id AND c.status = 'normal'
LEFT JOIN wework_groups g ON a.id = g.account_id AND g.status = 'active'
LEFT JOIN wework_conversations conv ON a.id = conv.account_id AND conv.status = 'active'
LEFT JOIN (
    SELECT account_id, COUNT(*) as open_alerts
    FROM wework_account_alerts 
    WHERE status = 'open'
    GROUP BY account_id
) alert_stats ON a.id = alert_stats.account_id
GROUP BY a.id, a.tenant_id, a.account_name, a.wework_guid, a.status, 
         a.health_score, a.message_success_rate, a.uptime_percentage, 
         a.total_messages, a.online_duration_hours, alert_stats.open_alerts,
         a.last_heartbeat_time, a.created_at;

-- 消息统计视图
CREATE VIEW v_wework_message_stats AS
SELECT 
    tenant_id,
    account_id,
    DATE(created_at) as message_date,
    direction,
    message_type,
    send_status,
    COUNT(*) as message_count,
    AVG(processing_time_ms) as avg_processing_time,
    AVG(response_time_ms) as avg_response_time
FROM wework_message_records
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY tenant_id, account_id, DATE(created_at), direction, message_type, send_status;

-- =====================================================
-- 9. 创建存储过程
-- =====================================================

DELIMITER //

-- 更新账号统计信息
CREATE PROCEDURE sp_update_account_statistics(IN p_account_id VARCHAR(36))
BEGIN
    DECLARE v_total_messages BIGINT DEFAULT 0;
    DECLARE v_successful_messages BIGINT DEFAULT 0;
    DECLARE v_failed_messages BIGINT DEFAULT 0;
    DECLARE v_success_rate DECIMAL(5,2) DEFAULT 0;
    DECLARE v_avg_response_time DECIMAL(8,3) DEFAULT 0;
    
    -- 计算消息统计
    SELECT 
        COUNT(*),
        COUNT(CASE WHEN send_status IN ('sent', 'delivered', 'read') THEN 1 END),
        COUNT(CASE WHEN send_status = 'failed' THEN 1 END),
        AVG(CASE WHEN response_time_ms IS NOT NULL THEN response_time_ms/1000.0 END)
    INTO v_total_messages, v_successful_messages, v_failed_messages, v_avg_response_time
    FROM wework_message_records 
    WHERE account_id = p_account_id AND direction = 'send';
    
    -- 计算成功率
    IF v_total_messages > 0 THEN
        SET v_success_rate = (v_successful_messages * 100.0 / v_total_messages);
    END IF;
    
    -- 更新账号表
    UPDATE wework_accounts 
    SET 
        total_messages = v_total_messages,
        successful_messages = v_successful_messages,
        failed_messages = v_failed_messages,
        message_success_rate = v_success_rate,
        avg_message_response_time = v_avg_response_time,
        updated_at = NOW()
    WHERE id = p_account_id;
    
    SELECT '账号统计信息更新完成' as result;
END //

-- 健康评分计算
CREATE PROCEDURE sp_calculate_health_score(IN p_account_id VARCHAR(36))
BEGIN
    DECLARE v_health_score INT DEFAULT 100;
    DECLARE v_success_rate DECIMAL(5,2);
    DECLARE v_uptime_percentage DECIMAL(5,2);
    DECLARE v_error_count INT;
    DECLARE v_last_heartbeat TIMESTAMP;
    DECLARE v_heartbeat_minutes INT;
    
    -- 获取基础指标
    SELECT message_success_rate, uptime_percentage, error_count, last_heartbeat_time
    INTO v_success_rate, v_uptime_percentage, v_error_count, v_last_heartbeat
    FROM wework_accounts WHERE id = p_account_id;
    
    -- 计算心跳延迟分钟数
    SET v_heartbeat_minutes = TIMESTAMPDIFF(MINUTE, v_last_heartbeat, NOW());
    
    -- 基于消息成功率计算分数 (40%权重)
    IF v_success_rate < 90 THEN
        SET v_health_score = v_health_score - (90 - v_success_rate) * 0.4;
    END IF;
    
    -- 基于在线率计算分数 (30%权重)
    IF v_uptime_percentage < 95 THEN
        SET v_health_score = v_health_score - (95 - v_uptime_percentage) * 0.3;
    END IF;
    
    -- 基于错误次数计算分数 (20%权重)
    IF v_error_count > 0 THEN
        SET v_health_score = v_health_score - LEAST(v_error_count * 2, 20);
    END IF;
    
    -- 基于心跳延迟计算分数 (10%权重)
    IF v_heartbeat_minutes > 5 THEN
        SET v_health_score = v_health_score - LEAST(v_heartbeat_minutes, 10);
    END IF;
    
    -- 确保分数在0-100范围内
    SET v_health_score = GREATEST(0, LEAST(100, v_health_score));
    
    -- 更新健康评分
    UPDATE wework_accounts 
    SET health_score = v_health_score, updated_at = NOW()
    WHERE id = p_account_id;
    
    SELECT CONCAT('健康评分更新完成: ', v_health_score) as result;
END //

-- 自动状态检查
CREATE PROCEDURE sp_auto_status_check()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_account_id VARCHAR(36);
    DECLARE v_last_heartbeat TIMESTAMP;
    DECLARE cur CURSOR FOR 
        SELECT id, last_heartbeat_time 
        FROM wework_accounts 
        WHERE status = 'ONLINE' 
        AND last_heartbeat_time < DATE_SUB(NOW(), INTERVAL 2 MINUTE);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    check_loop: LOOP
        FETCH cur INTO v_account_id, v_last_heartbeat;
        IF done THEN
            LEAVE check_loop;
        END IF;
        
        -- 标记为离线
        UPDATE wework_accounts 
        SET status = 'OFFLINE', updated_at = NOW()
        WHERE id = v_account_id;
        
        -- 记录状态变更历史
        INSERT INTO wework_account_status_history (
            id, tenant_id, account_id, old_status, new_status, 
            change_reason, trigger_type, created_at
        ) 
        SELECT 
            UUID(), tenant_id, id, 'ONLINE', 'OFFLINE',
            '心跳超时自动离线', 'HEARTBEAT_TIMEOUT', NOW()
        FROM wework_accounts WHERE id = v_account_id;
        
    END LOOP;
    CLOSE cur;
    
    SELECT '自动状态检查完成' as result;
END //

-- 生成日报统计
CREATE PROCEDURE sp_generate_daily_stats(IN p_stat_date DATE)
BEGIN
    INSERT INTO wework_tenant_usage (
        id, tenant_id, stat_date,
        total_accounts, online_accounts, active_accounts,
        total_messages, sent_messages, received_messages, failed_messages,
        total_contacts, active_contacts,
        total_groups, active_groups, group_messages,
        avg_response_time, message_success_rate, uptime_percentage,
        total_alerts, critical_alerts, resolved_alerts
    )
    SELECT 
        UUID() as id,
        a.tenant_id,
        p_stat_date as stat_date,
        COUNT(DISTINCT a.id) as total_accounts,
        COUNT(DISTINCT CASE WHEN a.status = 'ONLINE' THEN a.id END) as online_accounts,
        COUNT(DISTINCT CASE WHEN a.last_heartbeat_time >= DATE_SUB(NOW(), INTERVAL 1 DAY) THEN a.id END) as active_accounts,
        COALESCE(msg_stats.total_messages, 0) as total_messages,
        COALESCE(msg_stats.sent_messages, 0) as sent_messages,
        COALESCE(msg_stats.received_messages, 0) as received_messages,
        COALESCE(msg_stats.failed_messages, 0) as failed_messages,
        COALESCE(contact_stats.total_contacts, 0) as total_contacts,
        COALESCE(contact_stats.active_contacts, 0) as active_contacts,
        COALESCE(group_stats.total_groups, 0) as total_groups,
        COALESCE(group_stats.active_groups, 0) as active_groups,
        COALESCE(group_stats.group_messages, 0) as group_messages,
        AVG(a.avg_message_response_time) as avg_response_time,
        AVG(a.message_success_rate) as message_success_rate,
        AVG(a.uptime_percentage) as uptime_percentage,
        COALESCE(alert_stats.total_alerts, 0) as total_alerts,
        COALESCE(alert_stats.critical_alerts, 0) as critical_alerts,
        COALESCE(alert_stats.resolved_alerts, 0) as resolved_alerts
    FROM wework_accounts a
    LEFT JOIN (
        SELECT 
            account_id,
            COUNT(*) as total_messages,
            COUNT(CASE WHEN direction = 'send' THEN 1 END) as sent_messages,
            COUNT(CASE WHEN direction = 'receive' THEN 1 END) as received_messages,
            COUNT(CASE WHEN send_status = 'failed' THEN 1 END) as failed_messages
        FROM wework_message_records 
        WHERE DATE(created_at) = p_stat_date
        GROUP BY account_id
    ) msg_stats ON a.id = msg_stats.account_id
    LEFT JOIN (
        SELECT 
            account_id, 
            COUNT(*) as total_contacts,
            COUNT(CASE WHEN last_message_at >= DATE_SUB(NOW(), INTERVAL 1 DAY) THEN 1 END) as active_contacts
        FROM wework_contacts 
        WHERE status = 'normal'
        GROUP BY account_id
    ) contact_stats ON a.id = contact_stats.account_id
    LEFT JOIN (
        SELECT 
            account_id,
            COUNT(*) as total_groups,
            COUNT(CASE WHEN last_message_at >= DATE_SUB(NOW(), INTERVAL 1 DAY) THEN 1 END) as active_groups,
            COALESCE(SUM(message_count), 0) as group_messages
        FROM wework_groups 
        WHERE status = 'active'
        GROUP BY account_id
    ) group_stats ON a.id = group_stats.account_id
    LEFT JOIN (
        SELECT 
            account_id,
            COUNT(*) as total_alerts,
            COUNT(CASE WHEN alert_level = 'critical' THEN 1 END) as critical_alerts,
            COUNT(CASE WHEN status = 'resolved' AND DATE(resolved_at) = p_stat_date THEN 1 END) as resolved_alerts
        FROM wework_account_alerts 
        WHERE DATE(created_at) = p_stat_date
        GROUP BY account_id
    ) alert_stats ON a.id = alert_stats.account_id
    GROUP BY a.tenant_id
    ON DUPLICATE KEY UPDATE
        total_accounts = VALUES(total_accounts),
        online_accounts = VALUES(online_accounts),
        active_accounts = VALUES(active_accounts),
        total_messages = VALUES(total_messages),
        sent_messages = VALUES(sent_messages),
        received_messages = VALUES(received_messages),
        failed_messages = VALUES(failed_messages),
        total_contacts = VALUES(total_contacts),
        active_contacts = VALUES(active_contacts),
        total_groups = VALUES(total_groups),
        active_groups = VALUES(active_groups),
        group_messages = VALUES(group_messages),
        avg_response_time = VALUES(avg_response_time),
        message_success_rate = VALUES(message_success_rate),
        uptime_percentage = VALUES(uptime_percentage),
        total_alerts = VALUES(total_alerts),
        critical_alerts = VALUES(critical_alerts),
        resolved_alerts = VALUES(resolved_alerts),
        updated_at = NOW();
    
    SELECT CONCAT('日报统计生成完成: ', p_stat_date) as result;
END //

DELIMITER ;

-- =====================================================
-- 10. 创建定时任务
-- =====================================================

-- 启用事件调度器
SET GLOBAL event_scheduler = ON;

-- 创建自动状态检查任务
CREATE EVENT IF NOT EXISTS auto_status_check
ON SCHEDULE EVERY 2 MINUTE
STARTS CURRENT_TIMESTAMP
DO
CALL sp_auto_status_check();

-- 创建健康评分更新任务
CREATE EVENT IF NOT EXISTS update_health_scores
ON SCHEDULE EVERY 10 MINUTE
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_account_id VARCHAR(36);
    DECLARE cur CURSOR FOR SELECT id FROM wework_accounts WHERE status IN ('ONLINE', 'OFFLINE');
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    health_loop: LOOP
        FETCH cur INTO v_account_id;
        IF done THEN
            LEAVE health_loop;
        END IF;
        
        CALL sp_calculate_health_score(v_account_id);
        
    END LOOP;
    CLOSE cur;
END;

-- 创建统计信息更新任务
CREATE EVENT IF NOT EXISTS update_account_statistics
ON SCHEDULE EVERY 1 HOUR
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_account_id VARCHAR(36);
    DECLARE cur CURSOR FOR SELECT id FROM wework_accounts WHERE status != 'CREATED';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    stats_loop: LOOP
        FETCH cur INTO v_account_id;
        IF done THEN
            LEAVE stats_loop;
        END IF;
        
        CALL sp_update_account_statistics(v_account_id);
        
    END LOOP;
    CLOSE cur;
END;

-- 创建日报生成任务
CREATE EVENT IF NOT EXISTS generate_daily_reports
ON SCHEDULE EVERY 1 DAY
STARTS DATE_ADD(DATE_ADD(CURDATE(), INTERVAL 1 DAY), INTERVAL 1 HOUR)
DO
CALL sp_generate_daily_stats(CURDATE() - INTERVAL 1 DAY);

-- =====================================================
-- 11. 插入初始数据
-- =====================================================

-- 插入默认消息模板
INSERT INTO wework_message_templates (id, tenant_id, template_name, template_code, message_type, content_template) VALUES
(UUID(), 'default-tenant', '欢迎消息', 'welcome', 'text', '欢迎加入我们！如有任何问题，请随时联系。'),
(UUID(), 'default-tenant', '自动回复', 'auto_reply', 'text', '您好，我已收到您的消息，稍后会为您处理。'),
(UUID(), 'default-tenant', '节日祝福', 'holiday_greeting', 'text', '祝您{{holiday_name}}快乐！');

-- 插入默认监控规则
INSERT INTO wework_account_monitor_rules (id, tenant_id, rule_name, rule_type, threshold_config, alert_level, description) VALUES
(UUID(), 'default-tenant', '心跳超时检查', 'heartbeat_check', '{"timeout_seconds": 120}', 'warning', '检查账号心跳超时'),
(UUID(), 'default-tenant', '消息成功率监控', 'message_success_rate', '{"min_rate": 90.0, "sample_count": 10}', 'error', '监控消息发送成功率'),
(UUID(), 'default-tenant', '健康评分监控', 'health_score', '{"min_score": 70}', 'warning', '监控账号健康评分'),
(UUID(), 'default-tenant', '错误次数监控', 'error_rate', '{"max_errors": 5, "time_window": 3600}', 'error', '监控账号错误次数');

-- =====================================================
-- 完成提示
-- =====================================================

SELECT '🚀 企微平台数据库初始化完成！' as message;
SELECT '📊 包含15+张表，完整的9状态生命周期跟踪' as features;
SELECT '🔧 已创建视图、存储过程和定时任务用于自动化管理' as additional_features;
SELECT '📈 分区表设计支持大量消息和日志数据' as performance_features;
SELECT '⚡ 自动状态检查、健康评分计算、统计报表生成' as automation_features;