# 数据库脚本总览

## 📋 脚本文件说明

本目录包含完整的企业级SaaS系统数据库设计脚本，按模块分库设计，确保数据隔离和性能优化。

### 🗂️ 脚本结构

```
database-scripts/
├── 01-saas-unified-core.sql      # 统一核心层 (24张表)
├── 02-ai-agent-platform.sql     # AI智能体平台 (20张表)
├── 03-wework-platform.sql       # 企微平台 (15张表)
├── 04-health-management.sql     # 健康管理模块 (12张表)
├── 05-core-business-platform.sql # 服务类核心业务平台 (18张表)
├── 06-customer-management.sql   # 客户管理平台 (15张表)
└── README.md                     # 本文档
```

---

## 🏗️ 数据库架构设计

### 架构特点
- **分库设计**：按业务模块分库，数据隔离，便于扩展
- **分区表优化**：日志类大数据表采用时间分区
- **完整索引**：针对查询场景优化索引设计
- **存储过程**：核心业务逻辑存储过程化
- **定时任务**：自动化数据清理和统计
- **视图支持**：常用查询视图化，提升性能

---

## 📊 01-saas-unified-core.sql

**数据库名称**：`saas_unified_core`

**功能描述**：SaaS平台统一核心层，包含身份管理、安全审计、配额计费、系统管理等核心功能。

### 表结构概览

| 分层 | 表名 | 描述 | 记录数预估 |
|------|------|------|-----------|
| **身份管理层** | | | |
| | `saas_tenants` | 租户主表 | 1,000+ |
| | `saas_users` | 用户主表 | 10,000+ |
| | `saas_roles` | 角色管理表 | 100+ |
| | `saas_permissions` | 权限管理表 | 500+ |
| | `saas_user_roles` | 用户角色关联表 | 20,000+ |
| | `saas_role_permissions` | 角色权限关联表 | 1,000+ |
| **安全审计层** | | | |
| | `saas_api_keys` | API密钥管理表 | 1,000+ |
| | `saas_user_sessions` | 用户会话管理表 | 10,000+ |
| | `saas_unified_audit_logs` | 统一审计日志表 (分区) | 1,000,000+ |
| | `saas_login_attempts` | 登录尝试记录表 | 100,000+ |
| **配额计费层** | | | |
| | `saas_tenant_quotas` | 租户配额管理表 | 1,000+ |
| | `saas_usage_statistics` | 使用统计表 | 365,000+ |
| | `saas_quota_usage_realtime` | 实时配额使用表 | 10,000+ |
| **系统管理层** | | | |
| | `saas_unified_configs` | 统一配置管理表 | 1,000+ |
| | `saas_unified_alerts` | 统一告警管理表 (分区) | 100,000+ |
| | `saas_monitor_rules` | 监控规则表 | 100+ |
| | `saas_system_metrics` | 系统指标表 | 1,000,000+ |
| | `saas_health_checks` | 健康检查表 | 1,000+ |
| **通知消息层** | | | |
| | `saas_message_templates` | 消息模板表 | 100+ |
| | `saas_notifications` | 站内通知表 | 10,000+ |
| | `saas_message_logs` | 消息发送记录表 | 100,000+ |
| **文件存储层** | | | |
| | `saas_files` | 文件存储表 | 100,000+ |
| | `saas_file_shares` | 文件分享表 | 10,000+ |

### 核心特性
- **多租户支持**：完整的租户隔离和权限控制
- **细粒度权限**：基于资源和操作的权限模型
- **配额管理**：多维度资源配额控制
- **审计日志**：统一的操作审计和安全日志
- **实时监控**：系统健康状况实时监控

---

## 🤖 02-ai-agent-platform.sql

**数据库名称**：`ai_agent_platform`

**功能描述**：AI智能体平台，包含平台管理、智能体管理、调度策略、知识库、工具、对话管理等。

### 表结构概览

| 分层 | 表名 | 描述 | 记录数预估 |
|------|------|------|-----------|
| **平台管理层** | | | |
| | `ai_platforms` | AI平台管理表 | 100+ |
| **智能体管理层** | | | |
| | `ai_agents` | AI智能体表 | 1,000+ |
| | `ai_agent_versions` | 智能体版本表 | 5,000+ |
| **调度管理层** | | | |
| | `ai_platform_agents` | 平台智能体映射表 | 5,000+ |
| | `ai_scheduling_strategies` | 调度策略表 | 1,000+ |
| | `ai_dispatch_logs` | 调度历史表 | 1,000,000+ |
| **知识库管理层** | | | |
| | `ai_knowledge_bases` | 知识库表 | 1,000+ |
| | `ai_knowledge_documents` | 知识文档表 | 100,000+ |
| | `ai_agent_knowledge_bases` | 智能体知识库关联表 | 5,000+ |
| **工具管理层** | | | |
| | `ai_tools` | 工具表 | 500+ |
| | `ai_agent_tools` | 智能体工具关联表 | 2,000+ |
| **对话管理层** | | | |
| | `ai_conversations` | 对话表 | 100,000+ |
| | `ai_messages` | 消息表 | 1,000,000+ |
| **监控分析层** | | | |
| | `ai_call_logs` | 调用日志表 (分区) | 10,000,000+ |
| | `ai_platform_metrics` | 平台指标表 (分区) | 1,000,000+ |

### 核心特性
- **多平台支持**：dify、coze、fastgpt等平台统一管理
- **智能调度**：6种调度策略，自动故障转移
- **版本管理**：智能体版本控制和发布管理
- **知识库集成**：多类型知识库支持
- **工具生态**：内置和自定义工具支持
- **性能监控**：实时调度性能分析

---

## 🚀 03-wework-platform.sql

**数据库名称**：`wework_platform`

**功能描述**：企微平台，包含账号管理、消息管理、联系人管理、群聊管理、监控告警等。

### 表结构概览

| 分层 | 表名 | 描述 | 记录数预估 |
|------|------|------|-----------|
| **账号管理层** | | | |
| | `wework_accounts` | 企微账号表 | 1,000+ |
| | `wework_account_status_history` | 账号状态历史表 | 100,000+ |
| | `wework_account_alerts` | 账号告警表 | 10,000+ |
| | `wework_account_monitor_rules` | 账号监控规则表 | 100+ |
| **消息管理层** | | | |
| | `wework_message_records` | 消息记录表 (分区) | 10,000,000+ |
| | `wework_message_templates` | 消息模板表 | 100+ |
| **联系人管理层** | | | |
| | `wework_contacts` | 联系人表 | 100,000+ |
| **群聊管理层** | | | |
| | `wework_groups` | 群聊表 | 10,000+ |
| | `wework_group_members` | 群成员表 | 1,000,000+ |
| **会话管理层** | | | |
| | `wework_conversations` | 会话表 | 100,000+ |
| **统计分析层** | | | |
| | `wework_tenant_usage` | 租户使用统计表 | 365+ |
| **回调日志层** | | | |
| | `wework_callback_logs` | 回调日志表 (分区) | 1,000,000+ |

### 核心特性
- **9状态生命周期**：完整的账号状态跟踪
- **实时监控**：自动状态检查和健康评分
- **消息管理**：完整的消息生命周期管理
- **联系人同步**：企微联系人和群聊同步
- **告警系统**：15种告警类型和自动处理
- **性能分析**：消息成功率和响应时间统计

---

## 🏥 04-health-management.sql

**数据库名称**：`health_management`

**功能描述**：健康管理模块，包含患者管理、健康记录、设备管理、健康告警、体检报告等。

### 表结构概览

| 分层 | 表名 | 描述 | 记录数预估 |
|------|------|------|-----------|
| **患者管理层** | | | |
| | `health_patients` | 患者基本信息表 | 10,000+ |
| **健康记录层** | | | |
| | `health_records` | 健康记录主表 | 1,000,000+ |
| | `health_vital_signs` | 生命体征记录表 | 5,000,000+ |
| **设备管理层** | | | |
| | `health_devices` | 健康设备表 | 1,000+ |
| | `health_device_logs` | 设备数据日志表 (分区) | 10,000,000+ |
| **健康告警层** | | | |
| | `health_alerts` | 健康告警表 | 100,000+ |
| | `health_alert_rules` | 告警规则表 | 100+ |
| **体检报告层** | | | |
| | `health_checkup_reports` | 体检报告表 | 100,000+ |
| **统计分析层** | | | |
| | `health_statistics` | 健康统计表 | 365+ |

### 核心特性
- **患者全生命周期管理**：从注册到健康档案管理
- **多设备支持**：血压计、血糖仪、体温计等设备接入
- **智能告警**：基于阈值和趋势的告警规则
- **数据质量控制**：设备数据验证和质量评估
- **健康分析**：风险评估和健康报告生成
- **设备监控**：设备状态监控和性能分析

---

## 🛒 05-core-business-platform.sql

**数据库名称**：`core_business_platform`

**功能描述**：服务类核心业务平台，包含服务管理、预约订单、营销管理、服务提供商管理等核心功能。

### 表结构概览

| 分层 | 表名 | 描述 | 记录数预估 |
|------|------|------|-----------|
| **服务管理层** | | | |
| | `service_categories` | 服务分类表 | 100+ |
| | `service_providers` | 服务提供商表 | 1,000+ |
| | `services` | 服务主表 | 5,000+ |
| | `service_variants` | 服务变体表 | 10,000+ |
| | `service_time_slots` | 服务时段管理表 | 100,000+ |
| | `service_capacity_logs` | 服务容量变动记录表 | 1,000,000+ |
| **订单管理层** | | | |
| | `service_orders` | 服务预约订单主表 | 100,000+ |
| | `service_order_items` | 服务订单项表 | 200,000+ |
| | `service_order_status_history` | 服务订单状态历史表 | 500,000+ |
| | `service_order_payments` | 服务订单支付记录表 | 100,000+ |
| **营销管理层** | | | |
| | `marketing_campaigns` | 营销活动表 | 500+ |
| | `marketing_coupons` | 优惠券表 | 10,000+ |
| | `marketing_participations` | 营销活动参与记录表 | 100,000+ |
| | `marketing_ab_tests` | A/B测试表 | 100+ |

### 核心特性
- **服务类商品支持**：完全适配服务类商品特点
- **预约管理**：完整的时间段预约和容量控制
- **提供商调度**：自动/手动分配服务人员
- **多地点服务**：在线、上门、混合等交付模式
- **灵活计费**：按小时、按次、按天、套餐等计费模式
- **改期取消**：完整的改期历史和取消政策
- **质量跟踪**：服务完成度、客户满意度评估
- **分账结算**：平台与服务提供商的收益分配
- **营销支持**：优惠券、活动、A/B测试等营销工具

---

## 👥 06-customer-management.sql

**数据库名称**：`customer_management`

**功能描述**：客户管理平台，包含客户档案、标签管理、分群分析、行为追踪等功能。

### 表结构概览

| 分层 | 表名 | 描述 | 记录数预估 |
|------|------|------|-----------|
| **客户档案层** | | | |
| | `customers` | 客户主表 | 100,000+ |
| | `customer_contacts` | 客户联系人表 | 50,000+ |
| | `customer_lifecycle_history` | 客户生命周期记录表 | 500,000+ |
| **标签管理层** | | | |
| | `customer_tag_definitions` | 标签定义表 | 1,000+ |
| | `customer_tags` | 客户标签关联表 | 500,000+ |
| | `tag_rule_execution_logs` | 标签规则执行日志表 | 100,000+ |
| **分群管理层** | | | |
| | `customer_segments` | 客户分群定义表 | 500+ |
| | `customer_segment_members` | 客户分群成员表 | 1,000,000+ |
| | `segment_calculation_history` | 分群计算历史表 | 10,000+ |
| **行为分析层** | | | |
| | `customer_behavior_definitions` | 客户行为定义表 | 100+ |
| | `customer_behavior_events` | 客户行为事件表 (分区) | 10,000,000+ |
| | `customer_behavior_statistics` | 客户行为统计表 | 1,000,000+ |
| | `customer_behavior_sequences` | 客户行为序列表 | 5,000,000+ |

### 核心特性
- **客户360度视图**：完整的客户档案和生命周期管理
- **智能标签系统**：自动标签分配和规则引擎
- **动态分群**：基于行为和属性的智能分群
- **行为追踪**：完整的客户行为路径分析
- **生命周期管理**：从潜在客户到忠诚客户的全流程
- **数据驱动**：基于大数据的客户洞察和分析
- **实时更新**：客户状态和行为实时更新
- **多维分析**：支持复杂的客户分析和报表

---

## 🛠️ 部署和使用

### 部署顺序
1. **先部署核心层**：`01-saas-unified-core.sql`
2. **再部署业务模块**：按需部署以下模块
   - `02-ai-agent-platform.sql` - AI智能体平台
   - `03-wework-platform.sql` - 企微平台
   - `04-health-management.sql` - 健康管理模块
   - `05-core-business-platform.sql` - 服务类核心业务平台
   - `06-customer-management.sql` - 客户管理平台
3. **配置跨库访问**：配置数据库间的访问权限

### 初始化脚本
```bash
# 1. 创建数据库用户
CREATE USER 'saas_admin'@'%' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON saas_unified_core.* TO 'saas_admin'@'%';
GRANT ALL PRIVILEGES ON ai_agent_platform.* TO 'saas_admin'@'%';
GRANT ALL PRIVILEGES ON wework_platform.* TO 'saas_admin'@'%';
GRANT ALL PRIVILEGES ON health_management.* TO 'saas_admin'@'%';
GRANT ALL PRIVILEGES ON core_business_platform.* TO 'saas_admin'@'%';
GRANT ALL PRIVILEGES ON customer_management.* TO 'saas_admin'@'%';

# 2. 执行脚本 (按顺序执行)
mysql -u saas_admin -p < 01-saas-unified-core.sql
mysql -u saas_admin -p < 02-ai-agent-platform.sql
mysql -u saas_admin -p < 03-wework-platform.sql
mysql -u saas_admin -p < 04-health-management.sql
mysql -u saas_admin -p < 05-core-business-platform.sql
mysql -u saas_admin -p < 06-customer-management.sql
```

### 配置要求
- **MySQL版本**：8.0+ (支持JSON、分区表、事件调度器)
- **存储引擎**：InnoDB
- **字符集**：utf8mb4_unicode_ci
- **时区设置**：Asia/Shanghai
- **事件调度器**：启用 (`SET GLOBAL event_scheduler = ON`)

---

## 📈 性能优化建议

### 索引优化
- **联合索引**：根据查询模式创建适当的联合索引
- **分区索引**：分区表的索引包含分区键
- **覆盖索引**：减少回表查询

### 分区策略
- **时间分区**：日志类表按月分区
- **分区裁剪**：查询时指定时间范围
- **分区维护**：定期清理旧分区

### 缓存策略
- **配置缓存**：系统配置表数据缓存
- **权限缓存**：用户权限信息缓存
- **热点数据**：频繁查询数据缓存

---

## 🔒 安全考虑

### 数据安全
- **敏感数据加密**：密码、API密钥等加密存储
- **字段级权限**：敏感字段访问控制
- **审计日志**：完整的操作审计

### 访问控制
- **最小权限原则**：数据库用户权限最小化
- **连接加密**：SSL/TLS连接
- **IP白名单**：限制数据库访问IP

---

## 📝 维护指南

### 日常维护
- **定期备份**：数据库全量和增量备份
- **性能监控**：查询性能和资源使用监控
- **日志清理**：定期清理旧的审计日志

### 扩展指南
- **水平扩展**：读写分离、分库分表
- **垂直扩展**：增加服务器资源
- **业务扩展**：新增业务模块数据库

---

## 🔗 相关文档

- [系统架构设计](../SYSTEM_DESIGN.md)
- [API接口设计](../API_INTERFACE_DESIGN.md)
- [完整业务模块设计](../COMPLETE_BUSINESS_MODULE_DESIGN.md)
- [生命周期闭环设计](../LIFECYCLE_CLOSED_LOOP_DESIGN.md)

---

## 📞 技术支持

如有数据库设计或部署问题，请参考相关文档或联系技术团队。

**总数据库数量**: 6个 (按业务模块分库)  
**总表数量**: 98张表  
**预估总数据量**: 150,000,000+ 条记录  
**分区表数量**: 7张 (支持大数据量)  
**存储过程**: 20+ 个  
**定时任务**: 15+ 个  
**视图**: 14+ 个  

### 📊 各模块表数量统计
- **01-saas-unified-core.sql**: 24张表 (统一核心层)
- **02-ai-agent-platform.sql**: 20张表 (AI智能体平台)  
- **03-wework-platform.sql**: 15张表 (企微平台)
- **04-health-management.sql**: 12张表 (健康管理模块)
- **05-core-business-platform.sql**: 14张表 (服务类核心业务平台)
- **06-customer-management.sql**: 13张表 (客户管理平台)

### 🚀 核心优势
- ✅ **完整的服务类商品支持** - 从传统实体商品转向服务类商品
- ✅ **企业级SaaS架构** - 多租户、权限、配额、审计完整体系
- ✅ **AI智能体平台** - 多平台统一管理和智能调度
- ✅ **企微深度集成** - 完整的企微生态对接
- ✅ **客户全生命周期管理** - 360度客户视图和行为分析
- ✅ **大数据支持** - 分区表设计支持海量数据处理
- ✅ **自动化运维** - 完善的监控、告警、定时任务体系

🎉 **企业级SaaS服务平台数据库设计完成！**