# 完整业务模块层设计 - 保留原有复杂度

## ⚠️ 重要说明

**您提出的问题非常正确！** 在v3.0优化设计中，我错误地简化了业务模块层。企微平台和AI智能体平台的核心业务逻辑绝对不能简化，这些是系统的核心价值所在。

**生命周期闭环跟踪**和**智能体配置调度**是企业级系统的关键能力，必须完整保留！

---

## 🎯 业务模块层重新设计原则

### 1. 核心原则修正
1. **统一架构优化** ✅ - 身份、安全、配置、告警层统一
2. **业务复杂度保留** ✅ - 企微9种状态、AI调度策略、生命周期跟踪完整保留  
3. **性能优化保留** ✅ - 分区表、索引、视图、存储过程
4. **功能完整性** ✅ - 所有原有功能100%保留

### 2. 重新审视的业务需求

#### 🔄 **生命周期闭环跟踪需求**
- **企微账号**: 9种状态完整跟踪，状态变更历史，持续时间分析
- **AI智能体**: 版本管理，调度历史，性能统计，质量评估
- **消息流转**: 从创建→发送→送达→已读的完整链路跟踪
- **平台调度**: 负载均衡，故障转移，性能监控

#### 🤖 **智能体配置和调度需求**  
- **多平台管理**: dify、coze、fastgpt等平台统一管理
- **调度策略**: round_robin、least_connections、response_time、cost_optimized
- **配置管理**: 模型配置、提示词配置、工作流配置、资源配置
- **版本管理**: 智能体版本、配置版本、部署历史
- **性能监控**: 响应时间、成功率、Token使用、费用统计

---

## 🏗️ AI智能体平台完整设计 (20+张表)

### 3.1 平台管理层

```sql
-- 1. 平台管理表
CREATE TABLE ai_platforms (
    id VARCHAR(36) PRIMARY KEY COMMENT '平台ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    platform_name VARCHAR(50) NOT NULL COMMENT '平台名称',
    platform_type ENUM('dify', 'coze', 'fastgpt', 'custom') NOT NULL COMMENT '平台类型',
    base_url VARCHAR(500) NOT NULL COMMENT '平台基础URL',
    auth_type ENUM('bearer', 'apikey', 'custom') NOT NULL COMMENT '认证类型',
    auth_config JSON NOT NULL COMMENT '认证配置',
    
    -- 平台能力配置 (保留复杂度)
    capabilities JSON DEFAULT NULL COMMENT '平台能力配置',
    rate_limits JSON DEFAULT NULL COMMENT '限流配置',
    priority INT DEFAULT 100 COMMENT '优先级(数字越小优先级越高)',
    
    -- 状态管理
    status ENUM('active', 'inactive', 'maintenance') DEFAULT 'active' COMMENT '状态',
    health_check_url VARCHAR(500) DEFAULT NULL COMMENT '健康检查URL',
    health_check_interval INT DEFAULT 60 COMMENT '健康检查间隔(秒)',
    
    -- 性能统计 (生命周期跟踪)
    total_requests BIGINT DEFAULT 0 COMMENT '总请求数',
    successful_requests BIGINT DEFAULT 0 COMMENT '成功请求数',
    failed_requests BIGINT DEFAULT 0 COMMENT '失败请求数',
    avg_response_time DECIMAL(8,3) DEFAULT 0 COMMENT '平均响应时间',
    last_health_check_at TIMESTAMP NULL COMMENT '最后健康检查时间',
    last_error_at TIMESTAMP NULL COMMENT '最后错误时间',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX idx_tenant_type (tenant_id, platform_type),
    INDEX idx_status (status),
    INDEX idx_priority (priority),
    
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI平台管理表';
```

### 3.2 智能体管理层

```sql
-- 2. 智能体表 (完整保留)
CREATE TABLE ai_agents (
    id VARCHAR(36) PRIMARY KEY COMMENT '智能体ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    agent_name VARCHAR(100) NOT NULL COMMENT '智能体名称',
    description TEXT COMMENT '智能体描述',
    category VARCHAR(50) DEFAULT NULL COMMENT '分类',
    agent_type ENUM('chatbot', 'workflow', 'plugin') DEFAULT 'chatbot' COMMENT '类型',
    avatar_url VARCHAR(500) DEFAULT NULL COMMENT '头像URL',
    
    -- 智能体配置 (完整保留复杂度) 
    config JSON NOT NULL COMMENT '智能体基础配置',
    model_config JSON COMMENT '模型配置',
    prompt_config JSON COMMENT '提示词配置', 
    workflow_config JSON COMMENT '工作流配置',
    resource_config JSON COMMENT '资源配置',
    security_config JSON COMMENT '安全配置',
    
    -- 状态管理
    status ENUM('draft', 'testing', 'active', 'inactive', 'archived') DEFAULT 'draft' COMMENT '状态',
    version VARCHAR(20) DEFAULT '1.0.0' COMMENT '当前版本号',
    
    -- 使用统计 (生命周期跟踪)
    conversation_count BIGINT DEFAULT 0 COMMENT '对话总数',
    message_count BIGINT DEFAULT 0 COMMENT '消息总数',
    total_tokens BIGINT DEFAULT 0 COMMENT '总Token消耗',
    total_cost DECIMAL(10,4) DEFAULT 0 COMMENT '总费用',
    avg_response_time DECIMAL(8,3) DEFAULT 0 COMMENT '平均响应时间',
    success_rate DECIMAL(5,2) DEFAULT 0 COMMENT '成功率',
    satisfaction_score DECIMAL(3,2) DEFAULT 0 COMMENT '平均满意度',
    last_used_at TIMESTAMP NULL COMMENT '最后使用时间',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) NOT NULL COMMENT '创建者ID',
    
    INDEX idx_tenant_status (tenant_id, status),
    INDEX idx_category (category),
    INDEX idx_agent_type (agent_type),
    INDEX idx_created_by (created_by),
    INDEX idx_last_used (last_used_at),
    
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES saas_users(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI智能体表';

-- 3. 智能体版本表 (生命周期跟踪核心)
CREATE TABLE ai_agent_versions (
    id VARCHAR(36) PRIMARY KEY COMMENT '版本ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    agent_id VARCHAR(36) NOT NULL COMMENT '智能体ID',
    
    version VARCHAR(20) NOT NULL COMMENT '版本号',
    version_name VARCHAR(100) COMMENT '版本名称',
    changelog TEXT COMMENT '变更日志',
    is_current BOOLEAN DEFAULT FALSE COMMENT '是否当前版本',
    
    -- 版本配置 (完整保留复杂度)
    config JSON NOT NULL COMMENT '版本完整配置',
    model_config JSON COMMENT '模型配置',
    prompt_config JSON COMMENT '提示词配置',
    workflow_config JSON COMMENT '工作流配置',
    diff_from_previous JSON COMMENT '与上一版本的差异',
    
    -- 版本状态
    status ENUM('draft', 'testing', 'stable', 'deprecated', 'archived') DEFAULT 'draft' COMMENT '版本状态',
    test_results JSON COMMENT '测试结果',
    
    -- 部署统计 (生命周期跟踪)
    deploy_count INT DEFAULT 0 COMMENT '部署次数',
    rollback_count INT DEFAULT 0 COMMENT '回滚次数',
    conversation_count BIGINT DEFAULT 0 COMMENT '对话次数',
    success_rate DECIMAL(5,2) COMMENT '成功率',
    avg_response_time DECIMAL(8,3) COMMENT '平均响应时间',
    total_tokens BIGINT DEFAULT 0 COMMENT 'Token消耗',
    total_cost DECIMAL(10,4) DEFAULT 0 COMMENT '费用消耗',
    first_deployed_at TIMESTAMP NULL COMMENT '首次部署时间',
    last_deployed_at TIMESTAMP NULL COMMENT '最后部署时间',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    created_by VARCHAR(36) NOT NULL COMMENT '创建者ID',
    
    UNIQUE KEY uk_agent_version (agent_id, version),
    INDEX idx_tenant_agent (tenant_id, agent_id),
    INDEX idx_is_current (is_current),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (agent_id) REFERENCES ai_agents(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES saas_users(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='智能体版本表';
```

### 3.3 调度管理层 (核心)

```sql
-- 4. 平台智能体映射表 (调度核心)
CREATE TABLE ai_platform_agents (
    id VARCHAR(36) PRIMARY KEY COMMENT 'ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    agent_id VARCHAR(36) NOT NULL COMMENT '智能体ID',
    platform_id VARCHAR(36) NOT NULL COMMENT '平台ID',
    
    platform_agent_id VARCHAR(100) NOT NULL COMMENT '平台智能体ID',
    platform_config JSON DEFAULT NULL COMMENT '平台特定配置',
    
    -- 同步状态 (生命周期跟踪)
    sync_status ENUM('pending', 'syncing', 'success', 'failed', 'outdated') DEFAULT 'pending' COMMENT '同步状态',
    last_sync_at TIMESTAMP NULL COMMENT '最后同步时间',
    sync_error TEXT DEFAULT NULL COMMENT '同步错误信息',
    sync_attempt_count INT DEFAULT 0 COMMENT '同步尝试次数',
    sync_duration_ms INT COMMENT '同步耗时(毫秒)',
    
    -- 部署状态
    deployment_status ENUM('deployed', 'deploying', 'failed', 'stopped', 'updating') DEFAULT 'stopped' COMMENT '部署状态',
    is_enabled BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    deployment_config JSON COMMENT '部署配置',
    
    -- 性能统计 (调度决策依据)
    total_requests BIGINT DEFAULT 0 COMMENT '总请求数',
    successful_requests BIGINT DEFAULT 0 COMMENT '成功请求数',
    failed_requests BIGINT DEFAULT 0 COMMENT '失败请求数',
    avg_response_time DECIMAL(8,3) DEFAULT 0 COMMENT '平均响应时间',
    last_request_at TIMESTAMP NULL COMMENT '最后请求时间',
    current_load INT DEFAULT 0 COMMENT '当前负载',
    max_concurrent_requests INT DEFAULT 100 COMMENT '最大并发请求数',
    
    -- 质量评估 (调度决策依据)
    quality_score DECIMAL(3,2) DEFAULT 0 COMMENT '质量评分',
    stability_score DECIMAL(3,2) DEFAULT 0 COMMENT '稳定性评分',
    cost_efficiency DECIMAL(8,4) DEFAULT 0 COMMENT '成本效率',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY uk_agent_platform (agent_id, platform_id),
    INDEX idx_tenant_agent (tenant_id, agent_id),
    INDEX idx_platform_id (platform_id),
    INDEX idx_sync_status (sync_status),
    INDEX idx_deployment_status (deployment_status),
    INDEX idx_performance (avg_response_time, success_rate),
    
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (agent_id) REFERENCES ai_agents(id) ON DELETE CASCADE,
    FOREIGN KEY (platform_id) REFERENCES ai_platforms(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='平台智能体映射表';

-- 5. 调度策略表 (智能体调度核心)
CREATE TABLE ai_scheduling_strategies (
    id VARCHAR(36) PRIMARY KEY COMMENT '策略ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    agent_id VARCHAR(36) NOT NULL COMMENT '智能体ID',
    
    strategy_name VARCHAR(100) NOT NULL COMMENT '策略名称',
    strategy_type ENUM('round_robin', 'least_connections', 'response_time', 'cost_optimized', 'weighted', 'custom') DEFAULT 'response_time' COMMENT '调度策略类型',
    description TEXT COMMENT '策略描述',
    
    -- 调度配置 (完整保留复杂度)
    platform_weights JSON DEFAULT NULL COMMENT '平台权重配置',
    platform_priorities JSON DEFAULT NULL COMMENT '平台优先级配置',
    load_balance_config JSON DEFAULT NULL COMMENT '负载均衡配置',
    failover_config JSON DEFAULT NULL COMMENT '故障转移配置',
    health_check_config JSON DEFAULT NULL COMMENT '健康检查配置',
    routing_rules JSON DEFAULT NULL COMMENT '路由规则配置',
    cost_optimization_config JSON COMMENT '成本优化配置',
    
    -- 调度限制
    max_concurrent_requests INT DEFAULT 100 COMMENT '最大并发请求数',
    timeout_seconds INT DEFAULT 30 COMMENT '超时时间(秒)',
    retry_count INT DEFAULT 3 COMMENT '重试次数',
    retry_interval_ms INT DEFAULT 1000 COMMENT '重试间隔(毫秒)',
    circuit_breaker_config JSON COMMENT '熔断器配置',
    
    -- 调度统计 (生命周期跟踪)
    total_dispatches BIGINT DEFAULT 0 COMMENT '总调度次数',
    successful_dispatches BIGINT DEFAULT 0 COMMENT '成功调度次数',
    failed_dispatches BIGINT DEFAULT 0 COMMENT '失败调度次数',
    avg_dispatch_time DECIMAL(8,3) DEFAULT 0 COMMENT '平均调度时间(毫秒)',
    last_dispatch_at TIMESTAMP NULL COMMENT '最后调度时间',
    
    -- 平台使用统计 (调度效果分析)
    platform_usage_stats JSON COMMENT '各平台使用统计',
    performance_metrics JSON COMMENT '性能指标历史',
    cost_metrics JSON COMMENT '成本指标历史',
    
    -- 状态管理
    is_enabled BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY uk_agent_strategy (agent_id),
    INDEX idx_tenant_agent (tenant_id, agent_id),
    INDEX idx_strategy_type (strategy_type),
    INDEX idx_is_enabled (is_enabled),
    INDEX idx_performance (avg_dispatch_time, successful_dispatches),
    
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (agent_id) REFERENCES ai_agents(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='调度策略表';

-- 6. 调度历史表 (调度跟踪核心)
CREATE TABLE ai_dispatch_logs (
    id VARCHAR(36) PRIMARY KEY COMMENT '调度日志ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    request_id VARCHAR(64) NOT NULL COMMENT '请求ID',
    agent_id VARCHAR(36) NOT NULL COMMENT '智能体ID',
    strategy_id VARCHAR(36) COMMENT '使用的策略ID',
    
    -- 调度决策过程 (完整跟踪)
    available_platforms JSON NOT NULL COMMENT '可用平台列表',
    platform_scores JSON COMMENT '平台评分',
    selected_platform_id VARCHAR(36) COMMENT '选中的平台ID',
    selection_reason VARCHAR(500) COMMENT '选择原因',
    fallback_platforms JSON COMMENT '备用平台列表',
    
    -- 调度性能
    dispatch_time_ms DECIMAL(8,3) NOT NULL COMMENT '调度耗时(毫秒)',
    total_time_ms DECIMAL(8,3) COMMENT '总耗时(毫秒)',
    queue_wait_time_ms DECIMAL(8,3) COMMENT '队列等待时间',
    
    -- 调度结果
    dispatch_status ENUM('success', 'failed', 'timeout', 'no_available_platform') NOT NULL COMMENT '调度状态',
    response_status_code INT COMMENT '响应状态码',
    error_code VARCHAR(50) COMMENT '错误码',
    error_message TEXT COMMENT '错误信息',
    
    -- 重试信息
    retry_count INT DEFAULT 0 COMMENT '重试次数',
    retry_platforms JSON COMMENT '重试平台列表',
    final_platform_id VARCHAR(36) COMMENT '最终成功的平台ID',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    INDEX idx_tenant_agent (tenant_id, agent_id),
    INDEX idx_request_id (request_id),
    INDEX idx_selected_platform (selected_platform_id),
    INDEX idx_dispatch_status (dispatch_status),
    INDEX idx_created_at (created_at),
    INDEX idx_dispatch_time (dispatch_time_ms),
    
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (agent_id) REFERENCES ai_agents(id) ON DELETE CASCADE,
    FOREIGN KEY (strategy_id) REFERENCES ai_scheduling_strategies(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='调度历史表';
```

---

## 🔧 企微平台完整设计 (12+张表)

### 4.1 账号管理层

```sql
-- 1. 企微账号表 (完整保留9种状态)
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
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX idx_tenant_status (tenant_id, status),
    INDEX idx_tenant_name (tenant_id, account_name),
    INDEX idx_status_heartbeat (status, last_heartbeat_time),
    INDEX idx_health_score (health_score),
    INDEX idx_tenant_tag (tenant_id, tenant_tag),
    INDEX idx_wework_guid (wework_guid),
    INDEX idx_retry_count (retry_count),
    INDEX idx_performance (message_success_rate, uptime_percentage),
    
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企微账号表';

-- 2. 账号状态历史表 (生命周期闭环跟踪核心)
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
    
    FOREIGN KEY (tenant_id) REFERENCES saas_tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (account_id) REFERENCES wework_accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企微账号状态历史表';
```

---

## 🎯 总结

### ✅ **重新设计的核心价值**

1. **生命周期闭环跟踪** 
   - ✅ 企微账号9种状态完整跟踪
   - ✅ 智能体版本、部署、调度全链路跟踪  
   - ✅ 消息从创建到送达的完整生命周期
   - ✅ 平台性能、稳定性持续监控

2. **智能体配置和调度**
   - ✅ 多平台统一管理 (dify、coze、fastgpt、custom)
   - ✅ 灵活调度策略 (轮询、最少连接、响应时间、成本优化)
   - ✅ 完整配置管理 (模型、提示词、工作流、资源)  
   - ✅ 版本管理和发布控制
   - ✅ 实时性能监控和质量评估

3. **企业级监控运维**
   - ✅ 详细的监控规则配置
   - ✅ 多维度告警管理 (15种告警类型)
   - ✅ 自动恢复和故障转移
   - ✅ 完整的审计日志

### 🚀 **架构优势保持**
- **统一层优化** - 身份、安全、配置、告警统一管理  
- **业务层完整** - 所有原有业务复杂度100%保留
- **性能优化** - 分区表、索引、缓存策略
- **扩展性强** - JSON配置支持灵活扩展

这个重新设计真正做到了**既优化架构又保留复杂度**，完全满足企业级生命周期闭环跟踪和智能体配置调度的需求！

---

## 📁 完整数据库脚本

为了便于实际部署和管理，所有数据库设计已按模块拆分成独立的SQL脚本文件：

### 🗂️ 数据库脚本目录

```
docs/02-系统设计/database-scripts/
├── 01-saas-unified-core.sql      # 统一核心层 (24张表)
├── 02-ai-agent-platform.sql     # AI智能体平台 (20张表) 
├── 03-wework-platform.sql       # 企微平台 (15张表)
├── 04-health-management.sql     # 健康管理模块 (12张表)
└── README.md                     # 脚本使用说明
```

### 📊 脚本特性概览

| 脚本文件 | 数据库名 | 表数量 | 核心功能 | 预估数据量 |
|---------|----------|-------|----------|-----------|
| **01-saas-unified-core.sql** | `saas_unified_core` | 24张 | 身份管理、安全审计、配额计费、系统管理 | 10,000,000+ |
| **02-ai-agent-platform.sql** | `ai_agent_platform` | 20张 | 智能体管理、调度策略、知识库、工具 | 50,000,000+ |
| **03-wework-platform.sql** | `wework_platform` | 15张 | 企微账号、消息管理、联系人、群聊 | 100,000,000+ |
| **04-health-management.sql** | `health_management` | 12张 | 患者管理、健康记录、设备管理、告警 | 20,000,000+ |

### 🚀 部署使用

#### 快速部署
```bash
# 1. 按顺序执行脚本
mysql -u root -p < database-scripts/01-saas-unified-core.sql
mysql -u root -p < database-scripts/02-ai-agent-platform.sql
mysql -u root -p < database-scripts/03-wework-platform.sql
mysql -u root -p < database-scripts/04-health-management.sql

# 2. 验证部署
mysql -u root -p -e "SHOW DATABASES LIKE '%saas%' OR '%ai%' OR '%wework%' OR '%health%';"
```

#### 分模块部署
可根据业务需要选择性部署：
- **核心必须**：`01-saas-unified-core.sql` 
- **AI功能**：`02-ai-agent-platform.sql`
- **企微功能**：`03-wework-platform.sql`
- **健康功能**：`04-health-management.sql`

### 🔧 数据库设计亮点

#### 1. **统一核心层** (`01-saas-unified-core.sql`)
- ✅ **多租户权限模型**：支持租户隔离和细粒度权限控制
- ✅ **配额管理系统**：多维度资源配额和实时使用统计
- ✅ **统一审计日志**：跨模块操作审计 (分区表设计)
- ✅ **系统监控告警**：统一的监控规则和告警管理
- ✅ **消息通知系统**：模板化消息和多渠道通知

#### 2. **AI智能体平台** (`02-ai-agent-platform.sql`)
- ✅ **多平台支持**：dify、coze、fastgpt等平台统一管理
- ✅ **智能调度系统**：6种调度策略 + 自动故障转移
- ✅ **版本管理**：智能体版本控制和部署管理
- ✅ **知识库集成**：多类型知识库和工具生态
- ✅ **性能监控**：调用日志和平台指标 (分区表设计)

#### 3. **企微平台** (`03-wework-platform.sql`)  
- ✅ **9状态生命周期**：CREATED → INITIALIZING → ... → RECOVERING
- ✅ **实时监控系统**：心跳检查、健康评分、自动恢复
- ✅ **消息全链路**：从发送到送达的完整跟踪
- ✅ **联系人同步**：企微联系人和群聊实时同步
- ✅ **15种告警类型**：覆盖账号、消息、性能等全方位监控

#### 4. **健康管理模块** (`04-health-management.sql`)
- ✅ **患者全生命周期**：从注册到健康档案完整管理
- ✅ **多设备接入**：血压计、血糖仪、智能手表等设备支持
- ✅ **智能健康告警**：基于阈值、趋势、模式的告警规则
- ✅ **数据质量控制**：设备数据验证和质量评估
- ✅ **健康风险评估**：多维度健康风险分析和建议

### 📈 性能优化设计

#### 分区表策略
```sql
-- 示例：调用日志按月分区
PARTITION BY RANGE (UNIX_TIMESTAMP(created_at)) (
    PARTITION p202501 VALUES LESS THAN (UNIX_TIMESTAMP('2025-02-01 00:00:00')),
    PARTITION p202502 VALUES LESS THAN (UNIX_TIMESTAMP('2025-03-01 00:00:00')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);
```

#### 索引优化
- **联合索引**：根据业务查询模式设计
- **覆盖索引**：减少回表查询
- **JSON索引**：支持JSON字段高效查询

#### 存储过程优化
- **业务逻辑存储过程化**：减少应用层复杂度
- **统计分析自动化**：定时任务生成报表
- **数据清理自动化**：过期数据自动清理

### 🔗 相关文档链接

- 📋 **[数据库脚本说明](./database-scripts/README.md)** - 完整的部署和使用指南
- 🔄 **[生命周期闭环设计](./LIFECYCLE_CLOSED_LOOP_DESIGN.md)** - 业务闭环实现逻辑
- 🏗️ **[技术架构分析](./TECHNICAL_ARCHITECTURE_ANALYSIS.md)** - 整体技术架构
- 📐 **[统一数据模型设计](./ENTERPRISE_UNIFIED_DATA_MODEL.md)** - v2.0数据模型

### 💡 设计原则总结

1. **架构统一，业务独立**
   - 统一的身份、安全、配额、告警层
   - 独立的业务模块数据库，避免耦合

2. **复杂度保留，性能优化**
   - 保留原有业务逻辑的完整复杂度
   - 通过分区、索引、存储过程优化性能

3. **扩展性设计，维护友好**
   - 模块化数据库设计，便于扩展
   - 完整的部署脚本和维护工具

4. **生产就绪，企业级标准**
   - 分区表支持大数据量
   - 完整的监控、告警、审计体系
   - 自动化运维和数据清理

🎯 **这套数据库设计真正实现了企业级生产环境的要求，既保留了业务复杂度，又确保了系统的高可用性和可扩展性！**