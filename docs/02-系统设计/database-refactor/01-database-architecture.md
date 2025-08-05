# 🏗️ 数据库架构重构设计

**文档版本**: v1.0  
**编写日期**: 2025年1月  
**负责人**: 技术团队  

---

## 📊 数据库分库策略

### 整体架构
```yaml
数据库分布策略:
  saas_unified_core:
    - 用途: 用户权限管理、系统配置
    - 特点: 读多写少，缓存友好
    - 表数: 12张表
    
  wework_platform:
    - 用途: 企微账号管理、消息发送
    - 特点: 核心业务，高并发
    - 表数: 18张表
    
  monitor_analytics:
    - 用途: 监控数据、性能分析
    - 特点: 时序数据，大数据量
    - 表数: 10张表
```

## 📋 表结构设计

### 1. saas_unified_core 数据库

#### 1.1 用户权限表
```sql
-- 租户表
CREATE TABLE tenants (
    id VARCHAR(36) PRIMARY KEY COMMENT '租户ID',
    tenant_name VARCHAR(100) NOT NULL COMMENT '租户名称',
    tenant_code VARCHAR(50) UNIQUE NOT NULL COMMENT '租户编码',
    contact_email VARCHAR(100) COMMENT '联系邮箱',
    contact_phone VARCHAR(20) COMMENT '联系电话',
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active' COMMENT '状态',
    quota_accounts INT DEFAULT 100 COMMENT '账号配额',
    quota_messages BIGINT DEFAULT 1000000 COMMENT '消息配额',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX idx_tenant_code (tenant_code),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='租户表';

-- 用户表
CREATE TABLE users (
    id VARCHAR(36) PRIMARY KEY COMMENT '用户ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '密码(加密)',
    real_name VARCHAR(50) COMMENT '真实姓名',
    email VARCHAR(100) COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '手机号',
    avatar_url VARCHAR(255) COMMENT '头像URL',
    status ENUM('active', 'inactive', 'locked') DEFAULT 'active' COMMENT '状态',
    last_login_at TIMESTAMP NULL COMMENT '最后登录时间',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY uk_tenant_username (tenant_id, username),
    INDEX idx_tenant_id (tenant_id),
    INDEX idx_email (email),
    INDEX idx_status (status),
    FOREIGN KEY (tenant_id) REFERENCES tenants(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 角色表
CREATE TABLE roles (
    id VARCHAR(36) PRIMARY KEY COMMENT '角色ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    role_name VARCHAR(50) NOT NULL COMMENT '角色名称',
    role_code VARCHAR(50) NOT NULL COMMENT '角色编码',
    description TEXT COMMENT '角色描述',
    is_system BOOLEAN DEFAULT FALSE COMMENT '是否系统角色',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY uk_tenant_role_code (tenant_id, role_code),
    INDEX idx_tenant_id (tenant_id),
    FOREIGN KEY (tenant_id) REFERENCES tenants(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

-- 权限表
CREATE TABLE permissions (
    id VARCHAR(36) PRIMARY KEY COMMENT '权限ID',
    permission_name VARCHAR(100) NOT NULL COMMENT '权限名称',
    permission_code VARCHAR(100) UNIQUE NOT NULL COMMENT '权限编码',
    resource_type VARCHAR(50) NOT NULL COMMENT '资源类型',
    action_type VARCHAR(50) NOT NULL COMMENT '操作类型',
    description TEXT COMMENT '权限描述',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX idx_permission_code (permission_code),
    INDEX idx_resource_type (resource_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='权限表';

-- 用户角色关联表
CREATE TABLE user_roles (
    id VARCHAR(36) PRIMARY KEY COMMENT 'ID',
    user_id VARCHAR(36) NOT NULL COMMENT '用户ID',
    role_id VARCHAR(36) NOT NULL COMMENT '角色ID',
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '分配时间',
    
    UNIQUE KEY uk_user_role (user_id, role_id),
    INDEX idx_user_id (user_id),
    INDEX idx_role_id (role_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户角色关联表';

-- 角色权限关联表
CREATE TABLE role_permissions (
    id VARCHAR(36) PRIMARY KEY COMMENT 'ID',
    role_id VARCHAR(36) NOT NULL COMMENT '角色ID',
    permission_id VARCHAR(36) NOT NULL COMMENT '权限ID',
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '分配时间',
    
    UNIQUE KEY uk_role_permission (role_id, permission_id),
    INDEX idx_role_id (role_id),
    INDEX idx_permission_id (permission_id),
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色权限关联表';
```

#### 1.2 系统配置表
```sql
-- 系统配置表
CREATE TABLE system_configs (
    id VARCHAR(36) PRIMARY KEY COMMENT '配置ID',
    config_key VARCHAR(100) UNIQUE NOT NULL COMMENT '配置键',
    config_value TEXT NOT NULL COMMENT '配置值',
    config_type ENUM('string', 'number', 'boolean', 'json') DEFAULT 'string' COMMENT '配置类型',
    description TEXT COMMENT '配置描述',
    is_encrypted BOOLEAN DEFAULT FALSE COMMENT '是否加密',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX idx_config_key (config_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统配置表';

-- 租户配置表
CREATE TABLE tenant_configs (
    id VARCHAR(36) PRIMARY KEY COMMENT '配置ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    config_key VARCHAR(100) NOT NULL COMMENT '配置键',
    config_value TEXT NOT NULL COMMENT '配置值',
    config_type ENUM('string', 'number', 'boolean', 'json') DEFAULT 'string' COMMENT '配置类型',
    description TEXT COMMENT '配置描述',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY uk_tenant_config_key (tenant_id, config_key),
    INDEX idx_tenant_id (tenant_id),
    FOREIGN KEY (tenant_id) REFERENCES tenants(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='租户配置表';

-- 操作日志表
CREATE TABLE operation_logs (
    id VARCHAR(36) PRIMARY KEY COMMENT '日志ID',
    tenant_id VARCHAR(36) COMMENT '租户ID',
    user_id VARCHAR(36) COMMENT '用户ID',
    operation_type VARCHAR(50) NOT NULL COMMENT '操作类型',
    resource_type VARCHAR(50) NOT NULL COMMENT '资源类型',
    resource_id VARCHAR(36) COMMENT '资源ID',
    operation_desc TEXT COMMENT '操作描述',
    request_data JSON COMMENT '请求数据',
    response_data JSON COMMENT '响应数据',
    ip_address VARCHAR(45) COMMENT 'IP地址',
    user_agent TEXT COMMENT '用户代理',
    status ENUM('success', 'failed') NOT NULL COMMENT '操作状态',
    error_message TEXT COMMENT '错误信息',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX idx_tenant_id (tenant_id),
    INDEX idx_user_id (user_id),
    INDEX idx_operation_type (operation_type),
    INDEX idx_created_at (created_at),
    FOREIGN KEY (tenant_id) REFERENCES tenants(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作日志表';

-- 租户配额使用表
CREATE TABLE tenant_quota_usage (
    id VARCHAR(36) PRIMARY KEY COMMENT 'ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    resource_type VARCHAR(50) NOT NULL COMMENT '资源类型',
    quota_limit BIGINT NOT NULL COMMENT '配额限制',
    quota_used BIGINT DEFAULT 0 COMMENT '已使用配额',
    period_type ENUM('day', 'month', 'year') NOT NULL COMMENT '周期类型',
    period_start DATE NOT NULL COMMENT '周期开始日期',
    period_end DATE NOT NULL COMMENT '周期结束日期',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY uk_tenant_resource_period (tenant_id, resource_type, period_start),
    INDEX idx_tenant_id (tenant_id),
    INDEX idx_period (period_start, period_end),
    FOREIGN KEY (tenant_id) REFERENCES tenants(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='租户配额使用表';

-- 字典表
CREATE TABLE dictionaries (
    id VARCHAR(36) PRIMARY KEY COMMENT '字典ID',
    dict_code VARCHAR(50) NOT NULL COMMENT '字典编码',
    dict_name VARCHAR(100) NOT NULL COMMENT '字典名称',
    parent_id VARCHAR(36) COMMENT '父级ID',
    dict_value VARCHAR(255) COMMENT '字典值',
    sort_order INT DEFAULT 0 COMMENT '排序',
    is_enabled BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    description TEXT COMMENT '描述',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX idx_dict_code (dict_code),
    INDEX idx_parent_id (parent_id),
    INDEX idx_sort_order (sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='字典表';
```

### 2. wework_platform 数据库

#### 2.1 企微账号管理
```sql
-- 企微账号表
CREATE TABLE wework_accounts (
    id VARCHAR(36) PRIMARY KEY COMMENT '账号ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    account_name VARCHAR(100) NOT NULL COMMENT '账号名称',
    wework_guid VARCHAR(100) UNIQUE NOT NULL COMMENT '企微GUID',
    wework_corp_id VARCHAR(100) COMMENT '企业ID',
    wework_secret VARCHAR(255) COMMENT '企业密钥',
    account_config JSON COMMENT '账号配置',
    status ENUM('created', 'initializing', 'waiting_qr', 'waiting_confirm', 'verifying', 'online', 'offline', 'error', 'recovering') DEFAULT 'created' COMMENT '账号状态',
    last_heartbeat_at TIMESTAMP NULL COMMENT '最后心跳时间',
    error_message TEXT COMMENT '错误信息',
    login_qr_code TEXT COMMENT '登录二维码',
    device_info JSON COMMENT '设备信息',
    proxy_config JSON COMMENT '代理配置',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX idx_tenant_id (tenant_id),
    INDEX idx_wework_guid (wework_guid),
    INDEX idx_status (status),
    INDEX idx_last_heartbeat (last_heartbeat_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='企微账号表';

-- 账号状态变更记录表
CREATE TABLE account_status_logs (
    id VARCHAR(36) PRIMARY KEY COMMENT '记录ID',
    account_id VARCHAR(36) NOT NULL COMMENT '账号ID',
    old_status VARCHAR(50) COMMENT '原状态',
    new_status VARCHAR(50) NOT NULL COMMENT '新状态',
    change_reason VARCHAR(255) COMMENT '变更原因',
    error_details TEXT COMMENT '错误详情',
    operator_id VARCHAR(36) COMMENT '操作人ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX idx_account_id (account_id),
    INDEX idx_new_status (new_status),
    INDEX idx_created_at (created_at),
    FOREIGN KEY (account_id) REFERENCES wework_accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='账号状态变更记录表';

-- 联系人表
CREATE TABLE contacts (
    id VARCHAR(36) PRIMARY KEY COMMENT '联系人ID',
    account_id VARCHAR(36) NOT NULL COMMENT '账号ID',
    contact_wework_id VARCHAR(100) NOT NULL COMMENT '企微联系人ID',
    contact_name VARCHAR(100) COMMENT '联系人姓名',
    contact_alias VARCHAR(100) COMMENT '联系人备注',
    contact_type ENUM('user', 'group', 'external') NOT NULL COMMENT '联系人类型',
    contact_avatar VARCHAR(255) COMMENT '头像URL',
    phone_number VARCHAR(20) COMMENT '手机号',
    email VARCHAR(100) COMMENT '邮箱',
    department VARCHAR(100) COMMENT '部门',
    is_friend BOOLEAN DEFAULT FALSE COMMENT '是否好友',
    is_blocked BOOLEAN DEFAULT FALSE COMMENT '是否被拉黑',
    tags JSON COMMENT '标签',
    last_active_at TIMESTAMP NULL COMMENT '最后活跃时间',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY uk_account_contact (account_id, contact_wework_id),
    INDEX idx_account_id (account_id),
    INDEX idx_contact_type (contact_type),
    INDEX idx_contact_name (contact_name),
    FOREIGN KEY (account_id) REFERENCES wework_accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='联系人表';

-- 群聊表
CREATE TABLE groups (
    id VARCHAR(36) PRIMARY KEY COMMENT '群聊ID',
    account_id VARCHAR(36) NOT NULL COMMENT '账号ID',
    group_wework_id VARCHAR(100) NOT NULL COMMENT '企微群ID',
    group_name VARCHAR(100) NOT NULL COMMENT '群名称',
    group_notice TEXT COMMENT '群公告',
    member_count INT DEFAULT 0 COMMENT '成员数量',
    is_owner BOOLEAN DEFAULT FALSE COMMENT '是否群主',
    is_admin BOOLEAN DEFAULT FALSE COMMENT '是否管理员',
    group_avatar VARCHAR(255) COMMENT '群头像',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY uk_account_group (account_id, group_wework_id),
    INDEX idx_account_id (account_id),
    INDEX idx_group_name (group_name),
    FOREIGN KEY (account_id) REFERENCES wework_accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='群聊表';
```

#### 2.2 消息管理
```sql
-- 消息模板表
CREATE TABLE message_templates (
    id VARCHAR(36) PRIMARY KEY COMMENT '模板ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    template_name VARCHAR(100) NOT NULL COMMENT '模板名称',
    template_type ENUM('text', 'image', 'file', 'video', 'card', 'link') NOT NULL COMMENT '模板类型',
    template_content JSON NOT NULL COMMENT '模板内容',
    variables JSON COMMENT '变量配置',
    tags JSON COMMENT '标签',
    is_active BOOLEAN DEFAULT TRUE COMMENT '是否激活',
    usage_count BIGINT DEFAULT 0 COMMENT '使用次数',
    created_by VARCHAR(36) COMMENT '创建者ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX idx_tenant_id (tenant_id),
    INDEX idx_template_type (template_type),
    INDEX idx_template_name (template_name),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='消息模板表';

-- 消息发送任务表
CREATE TABLE message_tasks (
    id VARCHAR(36) PRIMARY KEY COMMENT '任务ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    task_name VARCHAR(100) NOT NULL COMMENT '任务名称',
    task_type ENUM('single', 'batch', 'scheduled', 'recurring') NOT NULL COMMENT '任务类型',
    account_id VARCHAR(36) NOT NULL COMMENT '发送账号ID',
    template_id VARCHAR(36) COMMENT '消息模板ID',
    message_content JSON NOT NULL COMMENT '消息内容',
    recipients JSON NOT NULL COMMENT '收件人列表',
    send_config JSON COMMENT '发送配置',
    schedule_config JSON COMMENT '定时配置',
    status ENUM('pending', 'running', 'paused', 'completed', 'failed', 'cancelled') DEFAULT 'pending' COMMENT '任务状态',
    total_count INT DEFAULT 0 COMMENT '总发送数量',
    success_count INT DEFAULT 0 COMMENT '成功数量',
    failed_count INT DEFAULT 0 COMMENT '失败数量',
    progress_percentage DECIMAL(5,2) DEFAULT 0.00 COMMENT '完成进度',
    started_at TIMESTAMP NULL COMMENT '开始时间',
    completed_at TIMESTAMP NULL COMMENT '完成时间',
    error_message TEXT COMMENT '错误信息',
    created_by VARCHAR(36) COMMENT '创建者ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX idx_tenant_id (tenant_id),
    INDEX idx_account_id (account_id),
    INDEX idx_status (status),
    INDEX idx_task_type (task_type),
    INDEX idx_created_at (created_at),
    FOREIGN KEY (account_id) REFERENCES wework_accounts(id),
    FOREIGN KEY (template_id) REFERENCES message_templates(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='消息发送任务表';

-- 消息发送记录表
CREATE TABLE message_records (
    id VARCHAR(36) PRIMARY KEY COMMENT '记录ID',
    task_id VARCHAR(36) NOT NULL COMMENT '任务ID',
    account_id VARCHAR(36) NOT NULL COMMENT '发送账号ID',
    recipient_id VARCHAR(100) NOT NULL COMMENT '接收者ID',
    recipient_name VARCHAR(100) COMMENT '接收者姓名',
    recipient_type ENUM('user', 'group') NOT NULL COMMENT '接收者类型',
    message_type ENUM('text', 'image', 'file', 'video', 'card', 'link') NOT NULL COMMENT '消息类型',
    message_content JSON NOT NULL COMMENT '消息内容',
    wework_message_id VARCHAR(100) COMMENT '企微消息ID',
    send_status ENUM('pending', 'sending', 'sent', 'delivered', 'read', 'failed') DEFAULT 'pending' COMMENT '发送状态',
    failure_reason VARCHAR(255) COMMENT '失败原因',
    retry_count INT DEFAULT 0 COMMENT '重试次数',
    sent_at TIMESTAMP NULL COMMENT '发送时间',
    delivered_at TIMESTAMP NULL COMMENT '送达时间',
    read_at TIMESTAMP NULL COMMENT '阅读时间',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX idx_task_id (task_id),
    INDEX idx_account_id (account_id),
    INDEX idx_recipient_id (recipient_id),
    INDEX idx_send_status (send_status),
    INDEX idx_sent_at (sent_at),
    FOREIGN KEY (task_id) REFERENCES message_tasks(id) ON DELETE CASCADE,
    FOREIGN KEY (account_id) REFERENCES wework_accounts(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 
PARTITION BY RANGE (UNIX_TIMESTAMP(created_at)) (
    PARTITION p202401 VALUES LESS THAN (UNIX_TIMESTAMP('2024-02-01')),
    PARTITION p202402 VALUES LESS THAN (UNIX_TIMESTAMP('2024-03-01')),
    PARTITION p202403 VALUES LESS THAN (UNIX_TIMESTAMP('2024-04-01')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
) COMMENT='消息发送记录表';

-- 消息回调记录表
CREATE TABLE message_callbacks (
    id VARCHAR(36) PRIMARY KEY COMMENT '回调ID',
    message_record_id VARCHAR(36) NOT NULL COMMENT '消息记录ID',
    callback_type ENUM('delivery', 'read', 'click', 'reply') NOT NULL COMMENT '回调类型',
    callback_data JSON NOT NULL COMMENT '回调数据',
    callback_time TIMESTAMP NOT NULL COMMENT '回调时间',
    processed BOOLEAN DEFAULT FALSE COMMENT '是否已处理',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX idx_message_record_id (message_record_id),
    INDEX idx_callback_type (callback_type),
    INDEX idx_callback_time (callback_time),
    INDEX idx_processed (processed),
    FOREIGN KEY (message_record_id) REFERENCES message_records(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='消息回调记录表';
```

#### 2.3 文件管理
```sql
-- 文件资源表
CREATE TABLE file_resources (
    id VARCHAR(36) PRIMARY KEY COMMENT '文件ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    file_name VARCHAR(255) NOT NULL COMMENT '文件名',
    file_type ENUM('image', 'video', 'audio', 'document', 'other') NOT NULL COMMENT '文件类型',
    file_size BIGINT NOT NULL COMMENT '文件大小(字节)',
    file_path VARCHAR(500) NOT NULL COMMENT '文件路径',
    file_url VARCHAR(500) COMMENT '访问URL',
    file_hash VARCHAR(64) COMMENT '文件哈希',
    mime_type VARCHAR(100) COMMENT 'MIME类型',
    storage_type ENUM('local', 'oss', 'cos', 'oss') DEFAULT 'local' COMMENT '存储类型',
    usage_count BIGINT DEFAULT 0 COMMENT '使用次数',
    uploaded_by VARCHAR(36) COMMENT '上传者ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX idx_tenant_id (tenant_id),
    INDEX idx_file_type (file_type),
    INDEX idx_file_hash (file_hash),
    INDEX idx_uploaded_by (uploaded_by),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文件资源表';

-- 文件使用记录表
CREATE TABLE file_usage_records (
    id VARCHAR(36) PRIMARY KEY COMMENT '记录ID',
    file_id VARCHAR(36) NOT NULL COMMENT '文件ID',
    usage_type ENUM('message', 'template', 'avatar', 'other') NOT NULL COMMENT '使用类型',
    reference_id VARCHAR(36) COMMENT '关联ID',
    used_by VARCHAR(36) COMMENT '使用者ID',
    used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '使用时间',
    
    INDEX idx_file_id (file_id),
    INDEX idx_usage_type (usage_type),
    INDEX idx_reference_id (reference_id),
    INDEX idx_used_at (used_at),
    FOREIGN KEY (file_id) REFERENCES file_resources(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文件使用记录表';
```

### 3. monitor_analytics 数据库

#### 3.1 监控数据
```sql
-- 账号监控数据表
CREATE TABLE account_metrics (
    id VARCHAR(36) PRIMARY KEY COMMENT '指标ID',
    account_id VARCHAR(36) NOT NULL COMMENT '账号ID',
    metric_type VARCHAR(50) NOT NULL COMMENT '指标类型',
    metric_value DECIMAL(15,4) NOT NULL COMMENT '指标值',
    metric_unit VARCHAR(20) COMMENT '指标单位',
    tags JSON COMMENT '标签',
    recorded_at TIMESTAMP NOT NULL COMMENT '记录时间',
    
    INDEX idx_account_id (account_id),
    INDEX idx_metric_type (metric_type),
    INDEX idx_recorded_at (recorded_at),
    INDEX idx_account_metric_time (account_id, metric_type, recorded_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 
PARTITION BY RANGE (UNIX_TIMESTAMP(recorded_at)) (
    PARTITION p202401 VALUES LESS THAN (UNIX_TIMESTAMP('2024-02-01')),
    PARTITION p202402 VALUES LESS THAN (UNIX_TIMESTAMP('2024-03-01')),
    PARTITION p202403 VALUES LESS THAN (UNIX_TIMESTAMP('2024-04-01')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
) COMMENT='账号监控数据表';

-- 系统告警表
CREATE TABLE system_alerts (
    id VARCHAR(36) PRIMARY KEY COMMENT '告警ID',
    alert_type VARCHAR(50) NOT NULL COMMENT '告警类型',
    alert_level ENUM('info', 'warning', 'error', 'critical') NOT NULL COMMENT '告警级别',
    alert_title VARCHAR(200) NOT NULL COMMENT '告警标题',
    alert_content TEXT NOT NULL COMMENT '告警内容',
    resource_type VARCHAR(50) COMMENT '资源类型',
    resource_id VARCHAR(36) COMMENT '资源ID',
    tenant_id VARCHAR(36) COMMENT '租户ID',
    status ENUM('active', 'acknowledged', 'resolved', 'suppressed') DEFAULT 'active' COMMENT '告警状态',
    acknowledged_by VARCHAR(36) COMMENT '确认人',
    acknowledged_at TIMESTAMP NULL COMMENT '确认时间',
    resolved_at TIMESTAMP NULL COMMENT '解决时间',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX idx_alert_type (alert_type),
    INDEX idx_alert_level (alert_level),
    INDEX idx_status (status),
    INDEX idx_tenant_id (tenant_id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统告警表';

-- 性能统计表
CREATE TABLE performance_stats (
    id VARCHAR(36) PRIMARY KEY COMMENT '统计ID',
    stat_date DATE NOT NULL COMMENT '统计日期',
    tenant_id VARCHAR(36) COMMENT '租户ID',
    metric_name VARCHAR(100) NOT NULL COMMENT '指标名称',
    metric_value DECIMAL(15,4) NOT NULL COMMENT '指标值',
    metric_count BIGINT DEFAULT 1 COMMENT '指标次数',
    min_value DECIMAL(15,4) COMMENT '最小值',
    max_value DECIMAL(15,4) COMMENT '最大值',
    avg_value DECIMAL(15,4) COMMENT '平均值',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    UNIQUE KEY uk_date_tenant_metric (stat_date, tenant_id, metric_name),
    INDEX idx_stat_date (stat_date),
    INDEX idx_tenant_id (tenant_id),
    INDEX idx_metric_name (metric_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='性能统计表';
```

## 🔧 索引优化策略

### 高频查询索引
```sql
-- 复合索引优化
CREATE INDEX idx_tenant_status_created ON wework_accounts (tenant_id, status, created_at);
CREATE INDEX idx_account_status_sent ON message_records (account_id, send_status, sent_at);
CREATE INDEX idx_tenant_type_created ON message_tasks (tenant_id, task_type, created_at);
CREATE INDEX idx_account_metric_time ON account_metrics (account_id, metric_type, recorded_at);
```

### 分区表策略
- 消息记录表按月分区
- 监控数据表按月分区
- 操作日志表按季度分区

## 📊 数据迁移计划

### 迁移步骤
1. **创建新数据库结构**
2. **数据清理和转换**
3. **分批迁移数据**
4. **验证数据完整性**
5. **切换应用配置**

### 回滚方案
- 保留原数据库备份
- 准备回滚脚本
- 设置数据同步机制