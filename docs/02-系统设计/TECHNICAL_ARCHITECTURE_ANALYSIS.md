# 企业微信管理平台 - 技术架构深度分析

## 📋 文档概述

本文档基于系统整体规划，对企业微信管理平台的技术架构进行全面分析，包括分层设计、微服务划分、服务交互、数据架构、安全架构以及MySQL与PostgreSQL的技术选型对比。

---

## 🏗️ 一、整体技术架构设计

### 1.1 六层架构模式

基于当前项目基础和规划目标，采用**六层架构模式**实现技术与业务的有效分离：

```mermaid
graph TB
    subgraph "用户接入层"
        A1[小程序]
        A2[App]
        A3[企微]
        A4[PC-WEB]
        A5[移动端App]
    end
    
    subgraph "API网关层"
        B1[Spring Cloud Gateway]
        B2[认证授权中心]
        B3[流量控制]
        B4[API管理]
    end
    
    subgraph "业务服务层"
        C1[账户服务<br/>account-service]
        C2[消息服务<br/>message-service]
        C3[营销服务<br/>marketing-service]
        C4[订单服务<br/>order-service]
        C5[商品服务<br/>product-service]
        C6[客户服务<br/>customer-service]
        C7[财务服务<br/>finance-service]
        C8[数据服务<br/>analytics-service]
    end
    
    subgraph "中台服务层"
        D1[企微协议服务<br/>wework-protocol-service]
        D2[通知服务<br/>notification-service]
        D3[配置服务<br/>config-service]
        D4[工作流服务<br/>workflow-service]
        D5[文件服务<br/>file-service]
    end
    
    subgraph "数据存储层"
        E1[(MySQL/PostgreSQL<br/>主数据库)]
        E2[(Redis缓存)]
        E3[(InfluxDB时序)]
        E4[(MinIO对象存储)]
        E5[(Elasticsearch搜索)]
    end
    
    subgraph "基础设施层"
        F1[RocketMQ消息队列]
        F2[Nacos服务发现]
        F3[Prometheus监控]
        F4[Jaeger链路追踪]
        F5[ELK日志分析]
    end
    
    A1 --> B1
    A2 --> B1
    A3 --> B1
    A4 --> B1
    A5 --> B1
    
    B1 --> C1
    B1 --> C2
    B1 --> C3
    B1 --> C4
    B1 --> C5
    B1 --> C6
    B1 --> C7
    B1 --> C8
    
    C1 --> E1
    C2 --> F1
    C3 --> E2
    C4 --> E1
    C5 --> E1
    C6 --> E5
    C7 --> E1
    C8 --> E3
    
    D1 --> C1
    D1 --> C2
    D2 --> F1
    D3 --> F2
    D4 --> C3
    D5 --> E4
```

### 1.2 架构分层职责

#### 🎯 用户接入层
- **多端统一接入**：支持小程序、App、企微、PC-WEB等多种客户端
- **协议适配**：HTTP/HTTPS、WebSocket、企微协议等多协议支持
- **负载均衡**：智能流量分发和容错处理

#### 🛡️ API网关层
- **Spring Cloud Gateway**：统一请求路由和协议转换
- **认证授权**：OAuth2 + JWT统一身份认证
- **流量控制**：限流、熔断、降级保护策略
- **API管理**：版本控制、文档管理、监控统计

#### 💼 业务服务层
- **领域驱动设计**：按业务域划分微服务边界
- **服务自治**：独立部署、独立扩展、独立数据存储
- **事务管理**：分布式事务和最终一致性保证

#### 🔧 中台服务层
- **共享能力沉淀**：通用功能服务化封装
- **业务赋能**：为上层业务服务提供技术支撑
- **标准化接口**：统一的服务调用规范

#### 🗄️ 数据存储层
- **多模存储架构**：针对不同数据特性选择最适合的存储方案
- **读写分离**：提升系统并发处理能力
- **数据分片**：支持海量数据水平扩展

#### ⚙️ 基础设施层
- **服务治理**：服务发现、配置管理、健康检查
- **可观测性**：监控、日志、链路追踪全覆盖
- **消息中间件**：解耦异步处理和事件驱动

---

## 🔧 二、微服务划分方案

### 2.1 服务域规划

```mermaid
graph LR
    subgraph "核心业务域"
        A1[账户服务<br/>account-service<br/>✓已实现]
        A2[消息服务<br/>message-service<br/>✓已实现]
        A3[营销服务<br/>marketing-service<br/>待开发]
        A4[订单服务<br/>order-service<br/>待开发]
        A5[商品服务<br/>product-service<br/>待开发]
    end
    
    subgraph "客户管理域"
        B1[客户服务<br/>customer-service]
        B2[标签服务<br/>tag-service]
        B3[分群服务<br/>segment-service]
        B4[行为服务<br/>behavior-service]
    end
    
    subgraph "数据分析域"
        C1[数据服务<br/>analytics-service]
        C2[报表服务<br/>report-service]
        C3[推荐服务<br/>recommendation-service]
        C4[AI服务<br/>ai-service]
    end
    
    subgraph "运营支撑域"
        D1[财务服务<br/>finance-service]
        D2[审计服务<br/>audit-service]
        D3[权限服务<br/>permission-service]
        D4[租户服务<br/>tenant-service]
    end
    
    subgraph "技术中台域"
        E1[企微协议服务<br/>wework-protocol-service]
        E2[通知服务<br/>notification-service]
        E3[文件服务<br/>file-service]
        E4[配置服务<br/>config-service]
        E5[工作流服务<br/>workflow-service]
    end
```

### 2.2 服务职责定义

#### 🏢 核心业务域
- **account-service**（✅已实现）
  - 企微账号生命周期管理
  - 登录登出流程控制
  - 账号状态实时监控
  - 多租户账号隔离

- **message-service**（✅已实现）
  - 消息发送接收处理
  - 企微协议回调管理
  - 消息模板和变量替换
  - 消息统计和监控

- **marketing-service**（待开发）
  - 营销活动策划执行
  - 渠道效果统计分析
  - 客户触达路径管理
  - A/B测试支持

- **order-service**（待开发）
  - 订单全生命周期管理
  - 支付集成和对账
  - 库存实时扣减
  - 订单状态流转

- **product-service**（待开发）
  - 商品信息管理
  - SKU和规格管理
  - 价格策略配置
  - 库存管理

#### 👥 客户管理域
- **customer-service**：客户档案、关系维护、生命周期管理
- **tag-service**：标签体系、动态标签、标签规则引擎
- **segment-service**：客户分群、精准定位、行为分析
- **behavior-service**：行为追踪、轨迹分析、偏好学习

#### 📊 数据分析域
- **analytics-service**：实时数据分析、指标计算、数据建模
- **report-service**：报表生成、数据可视化、导出功能
- **recommendation-service**：智能推荐、个性化服务、算法优化
- **ai-service**：机器学习、智能决策、预测分析

#### 🛠️ 运营支撑域
- **finance-service**：财务管理、结算对账、发票管理
- **audit-service**：操作审计、合规监控、风险预警
- **permission-service**：权限管理、RBAC控制、数据权限
- **tenant-service**：多租户管理、资源隔离、配额控制

#### 🔧 技术中台域
- **wework-protocol-service**：企微协议封装、API调用、错误处理
- **notification-service**：消息推送、通知管理、多渠道发送
- **file-service**：文件上传、存储管理、CDN分发
- **config-service**：配置管理、动态更新、版本控制
- **workflow-service**：业务流程、状态机、任务调度

---

## ⚡ 三、服务交互架构

### 3.1 服务交互时序图

```mermaid
sequenceDiagram
    participant Client as 客户端
    participant Gateway as API网关
    participant Auth as 认证服务
    participant Account as 账户服务
    participant Message as 消息服务
    participant WeWork as 企微协议服务
    participant MQ as 消息队列
    participant Cache as Redis缓存
    participant DB as 数据库
    
    Client->>Gateway: 1. 发送消息请求
    Gateway->>Auth: 2. 验证Token
    Auth-->>Gateway: 3. 返回用户信息
    Gateway->>Message: 4. 转发消息请求
    Message->>Cache: 5. 检查限流配置
    Cache-->>Message: 6. 返回限流状态
    Message->>Account: 7. 获取账户信息
    Account->>DB: 8. 查询账户状态
    DB-->>Account: 9. 返回账户数据
    Account-->>Message: 10. 返回账户信息
    Message->>WeWork: 11. 调用企微协议
    WeWork-->>Message: 12. 返回发送结果
    Message->>MQ: 13. 发送异步事件
    Message->>DB: 14. 保存消息记录
    Message-->>Gateway: 15. 返回发送结果
    Gateway-->>Client: 16. 返回响应
    
    Note over MQ: 异步事件处理
    MQ->>Analytics: 统计分析
    MQ->>Notification: 状态通知
    MQ->>Audit: 审计日志
```

### 3.2 服务交互模式

#### 🔄 同步调用模式
- **技术方案**：OpenFeign + Ribbon + Hystrix
- **适用场景**：实时性要求高的业务（认证、查询、核心交易）
- **超时策略**：设置合理的超时时间和重试机制
- **熔断保护**：防止级联故障

#### 📨 异步消息模式
- **技术方案**：RocketMQ消息队列
- **适用场景**：非实时性业务、批量处理、事件通知
- **消息可靠性**：支持事务消息和顺序消息
- **消费模式**：集群消费和广播消费

#### 🎯 事件驱动模式
- **技术方案**：领域事件 + 消息队列
- **适用场景**：业务解耦、状态变更通知、数据同步
- **事件存储**：支持事件溯源和重放
- **补偿机制**：最终一致性保证

#### 🔄 数据同步模式
- **技术方案**：CDC + Saga分布式事务
- **适用场景**：跨服务数据一致性、数据仓库同步
- **同步策略**：实时同步和批量同步
- **冲突解决**：版本控制和业务规则

---

## 🗄️ 四、数据架构设计

### 4.1 多模存储架构

```mermaid
graph TB
    subgraph "在线事务处理层 OLTP"
        A1[(MySQL/PostgreSQL<br/>主数据库)]
        A2[(读写分离<br/>从库集群)]
        A3[(Redis集群<br/>热点缓存)]
    end
    
    subgraph "数据湖层 Data Lake"
        B1[(MinIO<br/>原始数据)]
        B2[(InfluxDB<br/>时序数据)]
        B3[(Elasticsearch<br/>日志数据)]
    end
    
    subgraph "数据仓库层 Data Warehouse"
        C1[(ClickHouse<br/>OLAP分析)]
        C2[(Doris<br/>实时数仓)]
        C3[(Hive<br/>离线计算)]
    end
    
    subgraph "数据应用层 Data Apps"
        D1[实时大屏<br/>Grafana]
        D2[BI报表<br/>Superset]
        D3[ML平台<br/>MLflow]
        D4[推荐引擎<br/>TensorFlow]
    end
    
    subgraph "数据治理层"
        E1[数据质量<br/>DataX]
        E2[元数据管理<br/>Atlas]
        E3[数据血缘<br/>Lineage]
        E4[数据安全<br/>Ranger]
    end
    
    A1 --> B1
    A1 --> B2
    A3 --> B1
    B1 --> C1
    B2 --> C2
    B3 --> C1
    C1 --> D1
    C2 --> D2
    C1 --> D3
    C2 --> D4
    
    E1 --> C1
    E2 --> C2
    E3 --> D1
    E4 --> A1
```

### 4.2 存储技术选型

#### 📊 OLTP事务存储
- **MySQL/PostgreSQL集群**：主从架构，读写分离
- **分库分表策略**：按租户ID水平分片，支持千万级数据
- **事务保证**：ACID特性，强一致性
- **备份策略**：定时备份 + binlog增量备份

#### ⚡ 缓存存储层
- **Redis集群**：Sentinel高可用架构
- **缓存策略**：热点数据缓存、会话存储、分布式锁
- **过期策略**：LRU + TTL组合策略
- **持久化**：RDB + AOF双重保障

#### 📈 时序数据存储
- **InfluxDB**：高性能时序数据库
- **数据分片**：按时间窗口自动分片
- **压缩策略**：自动数据压缩和老化
- **查询优化**：连续查询和物化视图

#### 🔍 搜索引擎存储
- **Elasticsearch**：分布式搜索引擎
- **索引策略**：按日期滚动索引，热温冷数据分离
- **分片配置**：多副本高可用
- **性能优化**：合理的mapping设计和查询优化

#### 📁 对象存储
- **MinIO**：S3兼容对象存储
- **存储策略**：分级存储、自动备份
- **CDN加速**：静态资源全球分发
- **权限控制**：细粒度访问控制

---

## 🔒 五、安全架构设计

### 5.1 多层安全防护体系

```mermaid
graph TB
    subgraph "接入层安全"
        A1[WAF防火墙]
        A2[DDoS防护]
        A3[SSL/TLS加密]
        A4[API限流]
    end
    
    subgraph "认证授权"
        B1[OAuth2.0<br/>统一认证]
        B2[JWT Token<br/>无状态认证]
        B3[RBAC权限<br/>角色控制]
        B4[多因子认证<br/>MFA]
    end
    
    subgraph "数据安全"
        C1[字段加密<br/>AES-256]
        C2[数据脱敏<br/>敏感信息]
        C3[访问审计<br/>操作日志]
        C4[数据备份<br/>容灾恢复]
    end
    
    subgraph "网络安全"
        D1[VPC隔离<br/>网络分段]
        D2[Security Group<br/>访问控制]
        D3[堡垒机<br/>运维管控]
        D4[VPN隧道<br/>安全传输]
    end
    
    subgraph "应用安全"
        E1[代码扫描<br/>SAST/DAST]
        E2[依赖检查<br/>漏洞扫描]
        E3[运行时保护<br/>RASP]
        E4[容器安全<br/>镜像扫描]
    end
    
    subgraph "监控告警"
        F1[安全事件<br/>SIEM]
        F2[异常检测<br/>机器学习]
        F3[威胁情报<br/>IOC检测]
        F4[应急响应<br/>自动处置]
    end
    
    A1 --> B1
    A2 --> B2
    B1 --> C1
    B2 --> C2
    C1 --> D1
    C2 --> D2
    D1 --> E1
    D2 --> E2
    E1 --> F1
    E2 --> F2
```

### 5.2 安全策略详解

#### 🛡️ 网络边界安全
- **WAF + DDoS防护**：7层应用防火墙 + 3-4层流量清洗
- **SSL/TLS加密**：全站HTTPS，支持TLS 1.3
- **API网关限流**：令牌桶算法，支持用户级和IP级限流
- **地理位置限制**：基于GeoIP的访问控制

#### 🔐 身份认证安全
- **OAuth2.0统一认证**：标准化认证流程，支持多种授权模式
- **JWT无状态Token**：分布式友好，支持Claims自定义
- **RBAC权限模型**：基于角色的访问控制，支持数据权限
- **多因子认证**：短信验证码 + TOTP动态口令

#### 🗄️ 数据安全保护
- **AES-256字段加密**：敏感字段透明加密，密钥管理分离
- **动态数据脱敏**：非生产环境自动脱敏
- **操作审计日志**：完整的用户行为追踪
- **数据备份加密**：备份数据全程加密存储

#### 🔒 应用运行时安全
- **代码安全扫描**：集成SonarQube + Checkmarx
- **依赖漏洞检查**：OWASP Dependency-Check
- **容器安全扫描**：Trivy镜像漏洞扫描
- **RASP防护**：应用运行时自适应保护

---

## 💾 六、MySQL vs PostgreSQL 技术选型分析

### 6.1 技术对比架构图

```mermaid
graph TB
    subgraph "当前MySQL架构"
        A1[MySQL 8.0<br/>主数据库]
        A2[MyBatis Plus<br/>ORM框架]
        A3[JSON字段配置<br/>企微账号配置]
        A4[外键约束<br/>数据一致性]
        A5[Nacos配置中心<br/>依赖MySQL]
    end
    
    subgraph "PostgreSQL替换架构"
        B1[PostgreSQL 15<br/>主数据库]
        B2[MyBatis Plus<br/>保持不变]
        B3[JSONB字段<br/>增强JSON处理]
        B4[外键约束<br/>更严格约束]
        B5[Nacos配置<br/>需要适配]
    end
    
    subgraph "架构变化影响"
        C1[驱动变更<br/>mysql→postgresql]
        C2[连接配置<br/>URL和参数调整]
        C3[SQL语法<br/>部分差异调整]
        C4[监控工具<br/>适配调整]
        C5[部署脚本<br/>配置更新]
    end
    
    A1 --> B1
    A2 --> B2
    A3 --> B3
    A4 --> B4
    A5 --> B5
    
    B1 --> C1
    B2 --> C2
    B3 --> C3
    B4 --> C4
    B5 --> C5
```

### 6.2 PostgreSQL优势分析

#### 🚀 高级JSON支持
```sql
-- 当前MySQL JSON查询
SELECT * FROM wework_accounts 
WHERE JSON_EXTRACT(config_json, '$.autoReconnect') = true;

-- PostgreSQL JSONB查询（性能更优）
SELECT * FROM wework_accounts 
WHERE config_json->>'autoReconnect' = 'true';

-- 支持GIN索引，查询性能大幅提升
CREATE INDEX idx_config_auto_reconnect 
ON wework_accounts USING gin ((config_json->'autoReconnect'));
```

#### 🔄 强大的并发控制
- **MVCC（多版本并发控制）**：读不阻塞写，写不阻塞读
- **无死锁风险**：更智能的锁管理机制
- **更好的事务隔离**：支持SSI（Serializable Snapshot Isolation）

#### 📊 丰富的数据类型
```sql
-- PostgreSQL独有数据类型
CREATE TABLE enhanced_accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    coordinates POINT,              -- 地理坐标
    tags TEXT[],                    -- 数组类型
    config JSONB,                   -- 增强JSON
    ip_ranges INET[],               -- IP地址数组
    created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 🔍 内置全文搜索
```sql
-- PostgreSQL内置全文搜索
CREATE INDEX idx_fulltext_search ON message_records 
USING gin(to_tsvector('chinese', content::text));

SELECT * FROM message_records 
WHERE to_tsvector('chinese', content::text) @@ to_tsquery('企微');
```

### 6.3 迁移影响评估

#### ✅ 推荐替换的场景
1. **JSON数据处理较多**：当前项目大量使用JSON配置字段
2. **复杂查询需求**：租户统计、数据分析场景
3. **并发要求较高**：多租户同时访问场景
4. **数据一致性要求高**：金融级事务保证
5. **长期技术投资**：团队愿意投入学习成本

#### ❌ 替换风险点
1. **学习成本**：配置复杂度较高，SQL语法存在差异
2. **资源消耗**：内存使用通常比MySQL高20-30%
3. **生态系统**：第三方工具支持相对有限
4. **迁移成本**：数据迁移和应用适配工作量

### 6.4 迁移实施方案

#### 🎯 Phase 1: 准备阶段（1-2周）
- 评估SQL语法兼容性，识别需要调整的查询
- 搭建PostgreSQL测试环境，验证功能完整性
- 准备数据迁移脚本和回滚方案
- 调整应用配置和依赖包
- 执行性能基准测试对比

#### 🎯 Phase 2: 迁移执行（2-3天）
```bash
#!/bin/bash
# 数据库迁移脚本

# 1. 停止应用服务
docker-compose stop gateway-service account-service message-service

# 2. 备份MySQL数据
mysqldump -u wework -p wework_platform > backup_$(date +%Y%m%d).sql

# 3. 执行数据迁移
pgloader mysql://wework:wework123456@mysql:3306/wework_platform \
         postgresql://wework:wework123456@postgresql:5432/wework_platform

# 4. 验证数据完整性
python3 scripts/validate_migration.py

# 5. 启动PostgreSQL版本服务
docker-compose -f docker-compose.postgresql.yml up -d
```

#### 🎯 Phase 3: 监控和优化（1周）
- 性能监控配置和基准对比
- 查询性能优化和索引调整
- 应用代码优化和缓存策略调整
- 运维流程和监控告警适配

---

## 🚀 七、架构演进路线图

### 7.1 分阶段演进策略

```mermaid
gantt
    title 架构演进时间线
    dateFormat  YYYY-MM-DD
    section Phase 1: 基础完善
    完善现有服务    :done, phase1-1, 2024-01-01, 2024-02-15
    增加订单服务    :active, phase1-2, 2024-02-01, 2024-03-15
    增加商品服务    :phase1-3, 2024-03-01, 2024-04-15
    完善监控体系    :phase1-4, 2024-01-15, 2024-03-01
    
    section Phase 2: 业务扩展
    营销服务开发    :phase2-1, 2024-04-01, 2024-06-15
    客户管理服务    :phase2-2, 2024-05-01, 2024-07-15
    数据分析平台    :phase2-3, 2024-06-01, 2024-08-15
    AI能力集成      :phase2-4, 2024-07-01, 2024-09-15
    
    section Phase 3: 平台化
    开放API平台     :phase3-1, 2024-09-01, 2024-11-15
    插件生态系统    :phase3-2, 2024-10-01, 2024-12-15
    SaaS化改造      :phase3-3, 2024-11-01, 2025-01-15
    国际化支持      :phase3-4, 2024-12-01, 2025-02-15
```

### 7.2 演进目标和里程碑

#### 🎯 Phase 1: 基础完善（3-6个月）
**目标**：完善核心业务能力，建立稳固的技术基础
- ✅ **现有服务增强**：account-service和message-service功能完善
- 🆕 **核心服务开发**：order-service、product-service
- 🔧 **基础设施完善**：监控、日志、配置管理
- 📊 **性能优化**：数据库优化、缓存策略、接口性能

#### 🎯 Phase 2: 业务扩展（6-12个月）
**目标**：构建完整的业务闭环，提供端到端解决方案
- 🎯 **营销能力**：marketing-service、campaign管理
- 👥 **客户管理**：customer-service、CRM功能
- 📈 **数据能力**：analytics-service、BI报表
- 🤖 **智能化**：推荐算法、AI分析

#### 🎯 Phase 3: 平台化（12-18个月）
**目标**：打造开放生态，支持第三方集成和扩展
- 🌐 **开放平台**：API Gateway、开发者中心
- 🔌 **插件系统**：可扩展架构、第三方插件
- 🏢 **SaaS化**：多租户完全隔离、按需付费
- 🌍 **国际化**：多语言、多地区、合规支持

---

## 📋 八、总结与建议

### 8.1 架构优势

#### ✨ 技术优势
1. **渐进式演进**：基于现有基础，分阶段平滑升级
2. **技术栈统一**：Spring Cloud生态，学习成本低
3. **扩展性强**：微服务架构，支持独立扩展
4. **监控完善**：全链路监控，运维友好
5. **安全可靠**：多层防护，数据安全

#### 💼 业务优势
1. **多租户支持**：完善的租户隔离和资源控制
2. **高并发处理**：异步消息和缓存策略
3. **数据驱动**：完整的数据采集和分析能力
4. **智能化支持**：AI和推荐算法集成
5. **开放生态**：API开放和第三方集成

### 8.2 风险控制

#### ⚠️ 关键风险点
1. **服务治理复杂性**：微服务数量增加，治理难度上升
2. **数据一致性**：分布式事务处理复杂
3. **性能瓶颈**：网关和数据库可能成为瓶颈
4. **运维成本**：基础设施和人员投入增加

#### 🛡️ 风险缓解策略
1. **分阶段实施**：避免一次性大规模变更
2. **完善监控**：及时发现和解决问题
3. **自动化运维**：减少人工操作错误
4. **应急预案**：制定详细的回滚和恢复方案

### 8.3 实施建议

#### 🚀 即刻行动建议
1. **完善现有服务**：提升account-service和message-service的稳定性
2. **建立监控体系**：基于现有Prometheus + Grafana完善监控
3. **设计数据模型**：规划好租户数据隔离和分片策略
4. **制定开发规范**：统一API设计、错误处理、日志规范

#### 📚 长期规划建议
1. **团队能力建设**：提升微服务开发和运维能力
2. **技术债务管理**：定期重构和优化代码质量
3. **性能持续优化**：建立性能基准和优化流程
4. **安全体系完善**：定期安全评估和渗透测试

---

## 📖 附录

### A.1 技术选型对比表

| 维度 | MySQL | PostgreSQL | 推荐理由 |
|------|-------|------------|----------|
| JSON支持 | 基础JSON | 高级JSONB | PostgreSQL性能更优 |
| 并发控制 | 传统锁机制 | MVCC机制 | PostgreSQL无锁读取 |
| 扩展性 | 较好 | 优秀 | PostgreSQL插件丰富 |
| 运维成本 | 较低 | 较高 | 需要权衡学习成本 |
| 生态系统 | 丰富 | 良好 | MySQL工具更丰富 |

### A.2 服务端口规划

| 服务名称 | 内部端口 | 外部端口 | 协议 | 备注 |
|----------|----------|----------|------|------|
| gateway-service | 8080 | 18080 | HTTP | API网关 |
| account-service | 8081 | 18081 | HTTP | 账户服务 |
| message-service | 8082 | 18082 | HTTP | 消息服务 |
| MySQL/PostgreSQL | 3306/5432 | 23306/25432 | TCP | 数据库 |
| Redis | 6379 | 26379 | TCP | 缓存 |
| Nacos | 8848 | 28848 | HTTP | 服务发现 |

### A.3 监控指标体系

#### 业务指标
- 租户账号在线率
- 消息发送成功率
- API调用响应时间
- 用户活跃度统计

#### 技术指标
- 服务可用性（SLA）
- 数据库连接池使用率
- 内存和CPU使用率
- 网络延迟和吞吐量

#### 安全指标
- 登录失败次数
- 异常IP访问统计
- API调用频率异常
- 安全事件告警数量

---

*本文档版本：v1.0*  
*最后更新：2024年*  
*文档维护：WeWork Platform Team*