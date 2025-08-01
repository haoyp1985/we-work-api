# 🗄️ WeWork管理平台数据库详细设计
*WeWork Management Platform - Detailed Database Design Specification*

## 📋 设计概述

### 设计目标
- **高性能**: 支持高并发读写和大数据量处理
- **高可用**: 数据库集群和故障自动切换
- **数据一致性**: 保证数据的完整性和一致性
- **扩展性**: 支持水平扩展和分库分表
- **安全性**: 数据加密和访问控制

### 设计原则
- **范式化设计**: 遵循数据库范式，减少数据冗余
- **性能优先**: 在保证一致性的前提下优化查询性能
- **业务分离**: 按业务模块进行逻辑分库
- **读写分离**: 主从架构支持读写分离
- **分层存储**: 热数据和冷数据分层存储

### 技术规范
```yaml
数据库技术栈:
  主数据库:
    - MySQL 8.0+ (主要业务数据)
    - 存储引擎: InnoDB
    - 字符集: utf8mb4
    - 排序规则: utf8mb4_unicode_ci

  缓存数据库:
    - Redis 6.2+ (缓存和会话)
    - 集群模式: Redis Cluster
    - 持久化: RDB + AOF

  时序数据库:
    - InfluxDB 2.0+ (监控指标)
    - 数据保留: 热数据30天，冷数据1年

  搜索引擎:
    - Elasticsearch 8.0+ (日志和全文搜索)
    - 分片策略: 按时间分片

  文档数据库:
    - MongoDB 6.0+ (非结构化数据)
    - 副本集: 1主2从
```

## 🏗️ 数据库架构设计

### 整体架构
```yaml
数据库架构分层:
  1. 应用层 (Application Layer)
     - 应用服务连接
     - 连接池管理
     - 读写分离路由
     - 事务管理

  2. 代理层 (Proxy Layer)
     - MySQL Router
     - 负载均衡
     - 故障检测
     - 连接管理

  3. 数据库层 (Database Layer)
     - 主库 (Master)
     - 从库 (Slave)
     - 备库 (Backup)
     - 集群管理

  4. 存储层 (Storage Layer)
     - SSD存储
     - 数据文件
     - 日志文件
     - 备份文件
```

### 分库分表策略
```yaml
分库策略:
  用户相关库 (user_db):
    - 用户账号表
    - 角色权限表
    - 登录日志表

  实例管理库 (instance_db):
    - 企微实例表
    - 实例配置表
    - 实例监控表

  消息业务库 (message_db):
    - 消息记录表 (按月分表)
    - 消息任务表
    - 消息模板表

  联系人库 (contact_db):
    - 联系人表 (按实例分表)
    - 群聊表
    - 关系表

  监控日志库 (monitor_db):
    - 系统日志表 (按日分表)
    - 操作审计表
    - 告警记录表

分表策略:
  按时间分表:
    - 消息记录表: 按月分表
    - 日志表: 按日分表
    - 监控数据表: 按周分表

  按业务分表:
    - 联系人表: 按实例ID分表
    - 群聊表: 按实例ID分表
```

## 👥 用户认证相关表

### 用户表 (users)
```sql
CREATE TABLE users (
    id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    email VARCHAR(100) NOT NULL COMMENT '邮箱',
    phone VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    nickname VARCHAR(100) DEFAULT NULL COMMENT '昵称',
    avatar_url VARCHAR(500) DEFAULT NULL COMMENT '头像URL',
    password_hash VARCHAR(255) NOT NULL COMMENT '密码哈希',
    salt VARCHAR(32) NOT NULL COMMENT '密码盐值',
    status TINYINT(1) NOT NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-启用, 2-锁定',
    is_super_admin TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否超级管理员',
    last_login_time DATETIME DEFAULT NULL COMMENT '最后登录时间',
    last_login_ip VARCHAR(45) DEFAULT NULL COMMENT '最后登录IP',
    login_fail_count INT(11) NOT NULL DEFAULT 0 COMMENT '登录失败次数',
    locked_until DATETIME DEFAULT NULL COMMENT '锁定到期时间',
    email_verified TINYINT(1) NOT NULL DEFAULT 0 COMMENT '邮箱是否验证',
    phone_verified TINYINT(1) NOT NULL DEFAULT 0 COMMENT '手机是否验证',
    two_factor_enabled TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否启用双因子认证',
    two_factor_secret VARCHAR(32) DEFAULT NULL COMMENT '双因子认证密钥',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at DATETIME DEFAULT NULL COMMENT '删除时间',
    
    PRIMARY KEY (id),
    UNIQUE KEY uk_username (username),
    UNIQUE KEY uk_email (email),
    UNIQUE KEY uk_phone (phone),
    KEY idx_status (status),
    KEY idx_last_login (last_login_time),
    KEY idx_created (created_at),
    KEY idx_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';
```

### 角色表 (roles)
```sql
CREATE TABLE roles (
    id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '角色ID',
    name VARCHAR(50) NOT NULL COMMENT '角色标识',
    display_name VARCHAR(100) NOT NULL COMMENT '角色显示名',
    description TEXT DEFAULT NULL COMMENT '角色描述',
    is_system TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否系统角色',
    is_default TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否默认角色',
    sort_order INT(11) NOT NULL DEFAULT 0 COMMENT '排序',
    status TINYINT(1) NOT NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-启用',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at DATETIME DEFAULT NULL COMMENT '删除时间',
    
    PRIMARY KEY (id),
    UNIQUE KEY uk_name (name),
    KEY idx_status (status),
    KEY idx_sort (sort_order),
    KEY idx_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色表';
```

### 权限表 (permissions)
```sql
CREATE TABLE permissions (
    id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '权限ID',
    name VARCHAR(100) NOT NULL COMMENT '权限标识',
    display_name VARCHAR(100) NOT NULL COMMENT '权限显示名',
    description TEXT DEFAULT NULL COMMENT '权限描述',
    module VARCHAR(50) NOT NULL COMMENT '所属模块',
    resource VARCHAR(100) DEFAULT NULL COMMENT '资源',
    action VARCHAR(50) DEFAULT NULL COMMENT '操作',
    is_system TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否系统权限',
    sort_order INT(11) NOT NULL DEFAULT 0 COMMENT '排序',
    status TINYINT(1) NOT NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-启用',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    PRIMARY KEY (id),
    UNIQUE KEY uk_name (name),
    KEY idx_module (module),
    KEY idx_resource (resource),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='权限表';
```

### 用户角色关联表 (user_roles)
```sql
CREATE TABLE user_roles (
    id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
    user_id BIGINT(20) UNSIGNED NOT NULL COMMENT '用户ID',
    role_id BIGINT(20) UNSIGNED NOT NULL COMMENT '角色ID',
    granted_by BIGINT(20) UNSIGNED DEFAULT NULL COMMENT '授权人ID',
    expires_at DATETIME DEFAULT NULL COMMENT '过期时间',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    PRIMARY KEY (id),
    UNIQUE KEY uk_user_role (user_id, role_id),
    KEY idx_user (user_id),
    KEY idx_role (role_id),
    KEY idx_expires (expires_at),
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户角色关联表';
```

### 角色权限关联表 (role_permissions)
```sql
CREATE TABLE role_permissions (
    id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
    role_id BIGINT(20) UNSIGNED NOT NULL COMMENT '角色ID',
    permission_id BIGINT(20) UNSIGNED NOT NULL COMMENT '权限ID',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    PRIMARY KEY (id),
    UNIQUE KEY uk_role_permission (role_id, permission_id),
    KEY idx_role (role_id),
    KEY idx_permission (permission_id),
    
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色权限关联表';
```

### 用户会话表 (user_sessions)
```sql
CREATE TABLE user_sessions (
    id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '会话ID',
    session_id VARCHAR(128) NOT NULL COMMENT '会话标识',
    user_id BIGINT(20) UNSIGNED NOT NULL COMMENT '用户ID',
    access_token_hash VARCHAR(64) NOT NULL COMMENT 'AccessToken哈希',
    refresh_token_hash VARCHAR(64) NOT NULL COMMENT 'RefreshToken哈希',
    device_type VARCHAR(20) DEFAULT NULL COMMENT '设备类型',
    device_id VARCHAR(100) DEFAULT NULL COMMENT '设备ID',
    user_agent TEXT DEFAULT NULL COMMENT '用户代理',
    ip_address VARCHAR(45) NOT NULL COMMENT 'IP地址',
    location VARCHAR(200) DEFAULT NULL COMMENT '登录位置',
    expires_at DATETIME NOT NULL COMMENT '过期时间',
    last_activity DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最后活动时间',
    is_active TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否活跃',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    PRIMARY KEY (id),
    UNIQUE KEY uk_session (session_id),
    UNIQUE KEY uk_access_token (access_token_hash),
    UNIQUE KEY uk_refresh_token (refresh_token_hash),
    KEY idx_user (user_id),
    KEY idx_expires (expires_at),
    KEY idx_activity (last_activity),
    KEY idx_device (device_id),
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户会话表';
```

## 🏢 企业微信实例相关表

### 实例表 (wework_instances)
```sql
CREATE TABLE wework_instances (
    id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '实例ID',
    instance_uuid VARCHAR(36) NOT NULL COMMENT '实例UUID',
    name VARCHAR(100) NOT NULL COMMENT '实例名称',
    description TEXT DEFAULT NULL COMMENT '实例描述',
    version VARCHAR(20) DEFAULT NULL COMMENT '版本号',
    status TINYINT(1) NOT NULL DEFAULT 0 COMMENT '状态: 0-离线, 1-在线, 2-错误, 3-维护',
    api_url VARCHAR(500) DEFAULT NULL COMMENT 'API地址',
    webhook_url VARCHAR(500) DEFAULT NULL COMMENT '回调地址',
    proxy_host VARCHAR(100) DEFAULT NULL COMMENT '代理主机',
    proxy_port INT(11) DEFAULT NULL COMMENT '代理端口',
    proxy_username VARCHAR(100) DEFAULT NULL COMMENT '代理用户名',
    proxy_password_encrypted TEXT DEFAULT NULL COMMENT '代理密码(加密)',
    max_accounts INT(11) NOT NULL DEFAULT 10 COMMENT '最大账号数',
    current_accounts INT(11) NOT NULL DEFAULT 0 COMMENT '当前账号数',
    heartbeat_interval INT(11) NOT NULL DEFAULT 30 COMMENT '心跳间隔(秒)',
    last_heartbeat DATETIME DEFAULT NULL COMMENT '最后心跳时间',
    error_message TEXT DEFAULT NULL COMMENT '错误信息',
    restart_count INT(11) NOT NULL DEFAULT 0 COMMENT '重启次数',
    last_restart_time DATETIME DEFAULT NULL COMMENT '最后重启时间',
    total_messages BIGINT(20) NOT NULL DEFAULT 0 COMMENT '总消息数',
    today_messages INT(11) NOT NULL DEFAULT 0 COMMENT '今日消息数',
    created_by BIGINT(20) UNSIGNED NOT NULL COMMENT '创建人',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at DATETIME DEFAULT NULL COMMENT '删除时间',
    
    PRIMARY KEY (id),
    UNIQUE KEY uk_uuid (instance_uuid),
    KEY idx_name (name),
    KEY idx_status (status),
    KEY idx_heartbeat (last_heartbeat),
    KEY idx_created_by (created_by),
    KEY idx_deleted (deleted_at),
    
    FOREIGN KEY (created_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企微实例表';
```

### 实例配置表 (instance_configs)
```sql
CREATE TABLE instance_configs (
    id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '配置ID',
    instance_id BIGINT(20) UNSIGNED NOT NULL COMMENT '实例ID',
    config_key VARCHAR(100) NOT NULL COMMENT '配置键',
    config_value TEXT DEFAULT NULL COMMENT '配置值',
    config_type VARCHAR(20) NOT NULL DEFAULT 'string' COMMENT '配置类型: string, number, boolean, json',
    is_encrypted TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否加密',
    is_system TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否系统配置',
    description VARCHAR(500) DEFAULT NULL COMMENT '配置描述',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    PRIMARY KEY (id),
    UNIQUE KEY uk_instance_key (instance_id, config_key),
    KEY idx_key (config_key),
    KEY idx_type (config_type),
    
    FOREIGN KEY (instance_id) REFERENCES wework_instances(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='实例配置表';
```

### 实例监控表 (instance_monitors)
```sql
CREATE TABLE instance_monitors (
    id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '监控ID',
    instance_id BIGINT(20) UNSIGNED NOT NULL COMMENT '实例ID',
    metric_name VARCHAR(50) NOT NULL COMMENT '指标名称',
    metric_value DECIMAL(15,4) NOT NULL COMMENT '指标值',
    metric_unit VARCHAR(20) DEFAULT NULL COMMENT '指标单位',
    collected_at DATETIME NOT NULL COMMENT '采集时间',
    
    PRIMARY KEY (id),
    KEY idx_instance_metric (instance_id, metric_name),
    KEY idx_collected (collected_at),
    
    FOREIGN KEY (instance_id) REFERENCES wework_instances(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='实例监控表';

-- 分表: instance_monitors_YYYYMM
```

## 👤 账号管理相关表

### 企微账号表 (wework_accounts)
```sql
CREATE TABLE wework_accounts (
    id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '账号ID',
    instance_id BIGINT(20) UNSIGNED NOT NULL COMMENT '实例ID',
    wxid VARCHAR(100) NOT NULL COMMENT '微信ID',
    nickname VARCHAR(100) DEFAULT NULL COMMENT '昵称',
    avatar_url VARCHAR(500) DEFAULT NULL COMMENT '头像URL',
    phone VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    email VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    gender TINYINT(1) DEFAULT NULL COMMENT '性别: 0-未知, 1-男, 2-女',
    region VARCHAR(100) DEFAULT NULL COMMENT '地区',
    signature TEXT DEFAULT NULL COMMENT '个性签名',
    qr_code_url VARCHAR(500) DEFAULT NULL COMMENT '二维码URL',
    status TINYINT(1) NOT NULL DEFAULT 0 COMMENT '状态: 0-离线, 1-在线, 2-异常, 3-被封',
    is_logged_in TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否已登录',
    login_method VARCHAR(20) DEFAULT NULL COMMENT '登录方式: qrcode, phone',
    last_login_time DATETIME DEFAULT NULL COMMENT '最后登录时间',
    last_sync_time DATETIME DEFAULT NULL COMMENT '最后同步时间',
    contact_count INT(11) NOT NULL DEFAULT 0 COMMENT '联系人数量',
    group_count INT(11) NOT NULL DEFAULT 0 COMMENT '群聊数量',
    total_messages BIGINT(20) NOT NULL DEFAULT 0 COMMENT '总消息数',
    today_messages INT(11) NOT NULL DEFAULT 0 COMMENT '今日消息数',
    remark TEXT DEFAULT NULL COMMENT '备注',
    tags JSON DEFAULT NULL COMMENT '标签',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at DATETIME DEFAULT NULL COMMENT '删除时间',
    
    PRIMARY KEY (id),
    UNIQUE KEY uk_instance_wxid (instance_id, wxid),
    KEY idx_nickname (nickname),
    KEY idx_status (status),
    KEY idx_logged_in (is_logged_in),
    KEY idx_last_login (last_login_time),
    KEY idx_deleted (deleted_at),
    
    FOREIGN KEY (instance_id) REFERENCES wework_instances(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企微账号表';
```

### 联系人表 (contacts)
```sql
CREATE TABLE contacts (
    id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '联系人ID',
    account_id BIGINT(20) UNSIGNED NOT NULL COMMENT '账号ID',
    wxid VARCHAR(100) NOT NULL COMMENT '微信ID',
    nickname VARCHAR(100) DEFAULT NULL COMMENT '昵称',
    remark VARCHAR(100) DEFAULT NULL COMMENT '备注名',
    avatar_url VARCHAR(500) DEFAULT NULL COMMENT '头像URL',
    phone VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    gender TINYINT(1) DEFAULT NULL COMMENT '性别: 0-未知, 1-男, 2-女',
    region VARCHAR(100) DEFAULT NULL COMMENT '地区',
    signature TEXT DEFAULT NULL COMMENT '个性签名',
    contact_type TINYINT(1) NOT NULL DEFAULT 1 COMMENT '联系人类型: 1-好友, 2-群成员, 3-公众号',
    friend_status TINYINT(1) DEFAULT NULL COMMENT '好友状态: 1-正常, 2-被删除, 3-被拉黑',
    is_star TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否星标',
    is_top TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否置顶',
    is_blocked TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否拉黑',
    add_source VARCHAR(50) DEFAULT NULL COMMENT '添加来源',
    add_time DATETIME DEFAULT NULL COMMENT '添加时间',
    last_chat_time DATETIME DEFAULT NULL COMMENT '最后聊天时间',
    chat_count INT(11) NOT NULL DEFAULT 0 COMMENT '聊天次数',
    tags JSON DEFAULT NULL COMMENT '标签',
    custom_fields JSON DEFAULT NULL COMMENT '自定义字段',
    sync_status TINYINT(1) NOT NULL DEFAULT 0 COMMENT '同步状态: 0-未同步, 1-已同步',
    last_sync_time DATETIME DEFAULT NULL COMMENT '最后同步时间',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at DATETIME DEFAULT NULL COMMENT '删除时间',
    
    PRIMARY KEY (id),
    UNIQUE KEY uk_account_wxid (account_id, wxid),
    KEY idx_nickname (nickname),
    KEY idx_remark (remark),
    KEY idx_type (contact_type),
    KEY idx_friend_status (friend_status),
    KEY idx_last_chat (last_chat_time),
    KEY idx_sync_status (sync_status),
    KEY idx_deleted (deleted_at),
    
    FOREIGN KEY (account_id) REFERENCES wework_accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='联系人表';

-- 分表: contacts_{instance_id}
```

### 群聊表 (groups)
```sql
CREATE TABLE groups (
    id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '群聊ID',
    account_id BIGINT(20) UNSIGNED NOT NULL COMMENT '账号ID',
    group_wxid VARCHAR(100) NOT NULL COMMENT '群微信ID',
    group_name VARCHAR(200) DEFAULT NULL COMMENT '群名称',
    group_avatar_url VARCHAR(500) DEFAULT NULL COMMENT '群头像URL',
    group_notice TEXT DEFAULT NULL COMMENT '群公告',
    group_description TEXT DEFAULT NULL COMMENT '群描述',
    member_count INT(11) NOT NULL DEFAULT 0 COMMENT '成员数量',
    max_member_count INT(11) NOT NULL DEFAULT 500 COMMENT '最大成员数',
    owner_wxid VARCHAR(100) DEFAULT NULL COMMENT '群主微信ID',
    my_role TINYINT(1) NOT NULL DEFAULT 3 COMMENT '我的角色: 1-群主, 2-管理员, 3-成员',
    is_muted TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否被禁言',
    is_disturb_off TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否免打扰',
    join_time DATETIME DEFAULT NULL COMMENT '入群时间',
    last_message_time DATETIME DEFAULT NULL COMMENT '最后消息时间',
    message_count BIGINT(20) NOT NULL DEFAULT 0 COMMENT '消息数量',
    is_active TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否活跃',
    tags JSON DEFAULT NULL COMMENT '标签',
    custom_fields JSON DEFAULT NULL COMMENT '自定义字段',
    sync_status TINYINT(1) NOT NULL DEFAULT 0 COMMENT '同步状态: 0-未同步, 1-已同步',
    last_sync_time DATETIME DEFAULT NULL COMMENT '最后同步时间',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at DATETIME DEFAULT NULL COMMENT '删除时间',
    
    PRIMARY KEY (id),
    UNIQUE KEY uk_account_group (account_id, group_wxid),
    KEY idx_group_name (group_name),
    KEY idx_member_count (member_count),
    KEY idx_my_role (my_role),
    KEY idx_last_message (last_message_time),
    KEY idx_sync_status (sync_status),
    KEY idx_deleted (deleted_at),
    
    FOREIGN KEY (account_id) REFERENCES wework_accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='群聊表';

-- 分表: groups_{instance_id}
```

### 群成员表 (group_members)
```sql
CREATE TABLE group_members (
    id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '成员ID',
    group_id BIGINT(20) UNSIGNED NOT NULL COMMENT '群聊ID',
    member_wxid VARCHAR(100) NOT NULL COMMENT '成员微信ID',
    member_nickname VARCHAR(100) DEFAULT NULL COMMENT '成员昵称',
    group_nickname VARCHAR(100) DEFAULT NULL COMMENT '群内昵称',
    member_avatar_url VARCHAR(500) DEFAULT NULL COMMENT '成员头像URL',
    role TINYINT(1) NOT NULL DEFAULT 3 COMMENT '角色: 1-群主, 2-管理员, 3-成员',
    join_time DATETIME DEFAULT NULL COMMENT '入群时间',
    invite_by VARCHAR(100) DEFAULT NULL COMMENT '邀请人微信ID',
    is_muted TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否被禁言',
    mute_until DATETIME DEFAULT NULL COMMENT '禁言到期时间',
    last_speak_time DATETIME DEFAULT NULL COMMENT '最后发言时间',
    speak_count INT(11) NOT NULL DEFAULT 0 COMMENT '发言次数',
    is_active TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否活跃',
    tags JSON DEFAULT NULL COMMENT '标签',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    left_at DATETIME DEFAULT NULL COMMENT '退群时间',
    
    PRIMARY KEY (id),
    UNIQUE KEY uk_group_member (group_id, member_wxid),
    KEY idx_member_wxid (member_wxid),
    KEY idx_role (role),
    KEY idx_join_time (join_time),
    KEY idx_last_speak (last_speak_time),
    KEY idx_left_at (left_at),
    
    FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='群成员表';
```

## 💬 消息相关表

### 消息记录表 (messages)
```sql
CREATE TABLE messages (
    id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '消息ID',
    message_uuid VARCHAR(36) NOT NULL COMMENT '消息UUID',
    account_id BIGINT(20) UNSIGNED NOT NULL COMMENT '发送账号ID',
    chat_type TINYINT(1) NOT NULL COMMENT '聊天类型: 1-私聊, 2-群聊',
    chat_wxid VARCHAR(100) NOT NULL COMMENT '聊天对象微信ID',
    message_type VARCHAR(20) NOT NULL COMMENT '消息类型: text, image, video, file, link, card, location',
    message_content TEXT DEFAULT NULL COMMENT '消息内容',
    media_url VARCHAR(500) DEFAULT NULL COMMENT '媒体文件URL',
    media_size BIGINT(20) DEFAULT NULL COMMENT '媒体文件大小',
    media_duration INT(11) DEFAULT NULL COMMENT '媒体时长(秒)',
    thumbnail_url VARCHAR(500) DEFAULT NULL COMMENT '缩略图URL',
    file_name VARCHAR(255) DEFAULT NULL COMMENT '文件名',
    message_metadata JSON DEFAULT NULL COMMENT '消息元数据',
    send_status TINYINT(1) NOT NULL DEFAULT 0 COMMENT '发送状态: 0-待发送, 1-发送中, 2-成功, 3-失败',
    send_time DATETIME DEFAULT NULL COMMENT '发送时间',
    receive_time DATETIME DEFAULT NULL COMMENT '接收确认时间',
    error_code VARCHAR(50) DEFAULT NULL COMMENT '错误码',
    error_message TEXT DEFAULT NULL COMMENT '错误信息',
    retry_count INT(11) NOT NULL DEFAULT 0 COMMENT '重试次数',
    task_id BIGINT(20) UNSIGNED DEFAULT NULL COMMENT '任务ID',
    parent_message_id BIGINT(20) UNSIGNED DEFAULT NULL COMMENT '父消息ID(回复消息)',
    at_members JSON DEFAULT NULL COMMENT '@成员列表',
    is_scheduled TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否定时消息',
    scheduled_time DATETIME DEFAULT NULL COMMENT '定时发送时间',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    PRIMARY KEY (id),
    UNIQUE KEY uk_message_uuid (message_uuid),
    KEY idx_account_chat (account_id, chat_wxid),
    KEY idx_chat_type (chat_type),
    KEY idx_message_type (message_type),
    KEY idx_send_status (send_status),
    KEY idx_send_time (send_time),
    KEY idx_task_id (task_id),
    KEY idx_scheduled (is_scheduled, scheduled_time),
    KEY idx_created (created_at),
    
    FOREIGN KEY (account_id) REFERENCES wework_accounts(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息记录表';

-- 分表: messages_YYYYMM
```

### 消息任务表 (message_tasks)
```sql
CREATE TABLE message_tasks (
    id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '任务ID',
    task_uuid VARCHAR(36) NOT NULL COMMENT '任务UUID',
    task_name VARCHAR(200) DEFAULT NULL COMMENT '任务名称',
    task_type VARCHAR(20) NOT NULL COMMENT '任务类型: single, batch, broadcast',
    account_id BIGINT(20) UNSIGNED DEFAULT NULL COMMENT '发送账号ID',
    message_type VARCHAR(20) NOT NULL COMMENT '消息类型',
    message_content TEXT DEFAULT NULL COMMENT '消息内容',
    template_id BIGINT(20) UNSIGNED DEFAULT NULL COMMENT '模板ID',
    template_variables JSON DEFAULT NULL COMMENT '模板变量',
    target_count INT(11) NOT NULL DEFAULT 0 COMMENT '目标数量',
    success_count INT(11) NOT NULL DEFAULT 0 COMMENT '成功数量',
    fail_count INT(11) NOT NULL DEFAULT 0 COMMENT '失败数量',
    progress DECIMAL(5,2) NOT NULL DEFAULT 0 COMMENT '进度百分比',
    status TINYINT(1) NOT NULL DEFAULT 0 COMMENT '状态: 0-待执行, 1-执行中, 2-已完成, 3-失败, 4-已取消, 5-暂停',
    priority TINYINT(1) NOT NULL DEFAULT 2 COMMENT '优先级: 1-高, 2-中, 3-低',
    send_interval INT(11) NOT NULL DEFAULT 0 COMMENT '发送间隔(秒)',
    max_retry INT(11) NOT NULL DEFAULT 3 COMMENT '最大重试次数',
    scheduled_time DATETIME DEFAULT NULL COMMENT '定时执行时间',
    started_at DATETIME DEFAULT NULL COMMENT '开始时间',
    completed_at DATETIME DEFAULT NULL COMMENT '完成时间',
    error_message TEXT DEFAULT NULL COMMENT '错误信息',
    created_by BIGINT(20) UNSIGNED NOT NULL COMMENT '创建人',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    PRIMARY KEY (id),
    UNIQUE KEY uk_task_uuid (task_uuid),
    KEY idx_task_type (task_type),
    KEY idx_account_id (account_id),
    KEY idx_status (status),
    KEY idx_priority (priority),
    KEY idx_scheduled (scheduled_time),
    KEY idx_created_by (created_by),
    KEY idx_created (created_at),
    
    FOREIGN KEY (account_id) REFERENCES wework_accounts(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息任务表';
```

### 消息接收者表 (message_receivers)
```sql
CREATE TABLE message_receivers (
    id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
    task_id BIGINT(20) UNSIGNED NOT NULL COMMENT '任务ID',
    receiver_type TINYINT(1) NOT NULL COMMENT '接收者类型: 1-联系人, 2-群聊',
    receiver_wxid VARCHAR(100) NOT NULL COMMENT '接收者微信ID',
    receiver_name VARCHAR(100) DEFAULT NULL COMMENT '接收者名称',
    message_id BIGINT(20) UNSIGNED DEFAULT NULL COMMENT '消息ID',
    send_status TINYINT(1) NOT NULL DEFAULT 0 COMMENT '发送状态: 0-待发送, 1-发送中, 2-成功, 3-失败, 4-跳过',
    send_time DATETIME DEFAULT NULL COMMENT '发送时间',
    error_code VARCHAR(50) DEFAULT NULL COMMENT '错误码',
    error_message TEXT DEFAULT NULL COMMENT '错误信息',
    retry_count INT(11) NOT NULL DEFAULT 0 COMMENT '重试次数',
    variables JSON DEFAULT NULL COMMENT '个性化变量',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    PRIMARY KEY (id),
    KEY idx_task_receiver (task_id, receiver_wxid),
    KEY idx_send_status (send_status),
    KEY idx_send_time (send_time),
    KEY idx_message_id (message_id),
    
    FOREIGN KEY (task_id) REFERENCES message_tasks(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息接收者表';
```

### 消息模板表 (message_templates)
```sql
CREATE TABLE message_templates (
    id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '模板ID',
    template_uuid VARCHAR(36) NOT NULL COMMENT '模板UUID',
    name VARCHAR(200) NOT NULL COMMENT '模板名称',
    category VARCHAR(50) DEFAULT NULL COMMENT '模板分类',
    message_type VARCHAR(20) NOT NULL COMMENT '消息类型',
    content TEXT NOT NULL COMMENT '模板内容',
    variables JSON DEFAULT NULL COMMENT '变量定义',
    preview_content TEXT DEFAULT NULL COMMENT '预览内容',
    thumbnail_url VARCHAR(500) DEFAULT NULL COMMENT '缩略图URL',
    use_count INT(11) NOT NULL DEFAULT 0 COMMENT '使用次数',
    last_used_at DATETIME DEFAULT NULL COMMENT '最后使用时间',
    is_system TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否系统模板',
    is_public TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否公开模板',
    status TINYINT(1) NOT NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-启用',
    sort_order INT(11) NOT NULL DEFAULT 0 COMMENT '排序',
    tags JSON DEFAULT NULL COMMENT '标签',
    created_by BIGINT(20) UNSIGNED NOT NULL COMMENT '创建人',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at DATETIME DEFAULT NULL COMMENT '删除时间',
    
    PRIMARY KEY (id),
    UNIQUE KEY uk_template_uuid (template_uuid),
    KEY idx_name (name),
    KEY idx_category (category),
    KEY idx_message_type (message_type),
    KEY idx_status (status),
    KEY idx_created_by (created_by),
    KEY idx_use_count (use_count),
    KEY idx_deleted (deleted_at),
    
    FOREIGN KEY (created_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息模板表';
```

## 📊 监控日志相关表

### 系统日志表 (system_logs)
```sql
CREATE TABLE system_logs (
    id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '日志ID',
    log_uuid VARCHAR(36) NOT NULL COMMENT '日志UUID',
    level VARCHAR(10) NOT NULL COMMENT '日志级别: DEBUG, INFO, WARN, ERROR, FATAL',
    service VARCHAR(50) NOT NULL COMMENT '服务名称',
    module VARCHAR(50) DEFAULT NULL COMMENT '模块名称',
    action VARCHAR(100) DEFAULT NULL COMMENT '操作名称',
    message TEXT NOT NULL COMMENT '日志消息',
    context JSON DEFAULT NULL COMMENT '上下文信息',
    trace_id VARCHAR(64) DEFAULT NULL COMMENT '链路追踪ID',
    span_id VARCHAR(64) DEFAULT NULL COMMENT 'Span ID',
    user_id BIGINT(20) UNSIGNED DEFAULT NULL COMMENT '用户ID',
    instance_id BIGINT(20) UNSIGNED DEFAULT NULL COMMENT '实例ID',
    ip_address VARCHAR(45) DEFAULT NULL COMMENT 'IP地址',
    user_agent TEXT DEFAULT NULL COMMENT '用户代理',
    request_url VARCHAR(1000) DEFAULT NULL COMMENT '请求URL',
    request_method VARCHAR(10) DEFAULT NULL COMMENT '请求方法',
    response_code INT(11) DEFAULT NULL COMMENT '响应码',
    response_time INT(11) DEFAULT NULL COMMENT '响应时间(ms)',
    error_stack TEXT DEFAULT NULL COMMENT '错误堆栈',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    PRIMARY KEY (id),
    UNIQUE KEY uk_log_uuid (log_uuid),
    KEY idx_level (level),
    KEY idx_service (service),
    KEY idx_module (module),
    KEY idx_action (action),
    KEY idx_trace_id (trace_id),
    KEY idx_user_id (user_id),
    KEY idx_instance_id (instance_id),
    KEY idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统日志表';

-- 分表: system_logs_YYYYMMDD
```

### 操作审计表 (audit_logs)
```sql
CREATE TABLE audit_logs (
    id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '审计ID',
    audit_uuid VARCHAR(36) NOT NULL COMMENT '审计UUID',
    user_id BIGINT(20) UNSIGNED DEFAULT NULL COMMENT '用户ID',
    username VARCHAR(50) DEFAULT NULL COMMENT '用户名',
    operation VARCHAR(100) NOT NULL COMMENT '操作名称',
    resource_type VARCHAR(50) NOT NULL COMMENT '资源类型',
    resource_id VARCHAR(100) DEFAULT NULL COMMENT '资源ID',
    resource_name VARCHAR(200) DEFAULT NULL COMMENT '资源名称',
    operation_type VARCHAR(20) NOT NULL COMMENT '操作类型: CREATE, READ, UPDATE, DELETE',
    old_values JSON DEFAULT NULL COMMENT '修改前值',
    new_values JSON DEFAULT NULL COMMENT '修改后值',
    result VARCHAR(20) NOT NULL COMMENT '操作结果: SUCCESS, FAILURE',
    error_message TEXT DEFAULT NULL COMMENT '错误信息',
    ip_address VARCHAR(45) NOT NULL COMMENT 'IP地址',
    user_agent TEXT DEFAULT NULL COMMENT '用户代理',
    session_id VARCHAR(128) DEFAULT NULL COMMENT '会话ID',
    request_id VARCHAR(64) DEFAULT NULL COMMENT '请求ID',
    extra_info JSON DEFAULT NULL COMMENT '额外信息',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    PRIMARY KEY (id),
    UNIQUE KEY uk_audit_uuid (audit_uuid),
    KEY idx_user_id (user_id),
    KEY idx_username (username),
    KEY idx_operation (operation),
    KEY idx_resource (resource_type, resource_id),
    KEY idx_operation_type (operation_type),
    KEY idx_result (result),
    KEY idx_created (created_at),
    
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作审计表';
```

### 告警记录表 (alert_records)
```sql
CREATE TABLE alert_records (
    id BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '告警ID',
    alert_uuid VARCHAR(36) NOT NULL COMMENT '告警UUID',
    rule_name VARCHAR(100) NOT NULL COMMENT '告警规则名称',
    alert_level VARCHAR(20) NOT NULL COMMENT '告警级别: INFO, WARNING, ERROR, CRITICAL',
    alert_title VARCHAR(200) NOT NULL COMMENT '告警标题',
    alert_message TEXT NOT NULL COMMENT '告警内容',
    metric_name VARCHAR(50) DEFAULT NULL COMMENT '指标名称',
    metric_value DECIMAL(15,4) DEFAULT NULL COMMENT '指标值',
    threshold_value DECIMAL(15,4) DEFAULT NULL COMMENT '阈值',
    instance_id BIGINT(20) UNSIGNED DEFAULT NULL COMMENT '实例ID',
    source_type VARCHAR(50) NOT NULL COMMENT '告警源类型',
    source_id VARCHAR(100) DEFAULT NULL COMMENT '告警源ID',
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' COMMENT '状态: ACTIVE, ACKNOWLEDGED, RESOLVED',
    acknowledged_by BIGINT(20) UNSIGNED DEFAULT NULL COMMENT '确认人',
    acknowledged_at DATETIME DEFAULT NULL COMMENT '确认时间',
    acknowledged_comment TEXT DEFAULT NULL COMMENT '确认备注',
    resolved_by BIGINT(20) UNSIGNED DEFAULT NULL COMMENT '解决人',
    resolved_at DATETIME DEFAULT NULL COMMENT '解决时间',
    resolved_comment TEXT DEFAULT NULL COMMENT '解决备注',
    notification_sent TINYINT(1) NOT NULL DEFAULT