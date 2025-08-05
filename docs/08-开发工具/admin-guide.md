# 🔧 AI智能体管理系统 - 管理员指南

## 📋 管理员概述

本指南面向系统管理员，提供系统部署、配置、维护、监控和故障排除的详细说明。管理员负责确保系统的稳定运行、安全性和最佳性能。

## 🚀 系统部署

### 1. 环境准备

#### 硬件要求
```yaml
最低配置:
  CPU: 4核心
  内存: 8GB RAM
  存储: 100GB SSD
  网络: 100Mbps

推荐配置:
  CPU: 8核心+ 
  内存: 16GB+ RAM
  存储: 500GB+ SSD
  网络: 1Gbps
```

#### 软件要求
```yaml
操作系统: 
  - Ubuntu 20.04+ / CentOS 8+
  - macOS 12+ (开发环境)
  - Windows 11 (开发环境)

基础软件:
  - Docker 20.0+
  - Docker Compose 2.0+
  - Java 17+
  - Node.js 18+
  - MySQL 8.0+
  - Redis 7.0+
```

### 2. Docker部署

#### 生产环境部署
```bash
# 1. 克隆项目
git clone https://github.com/your-org/we-work-api.git
cd we-work-api

# 2. 配置环境变量
cp infrastructure/docker/env.example infrastructure/docker/.env
# 编辑.env文件，设置生产环境参数

# 3. 启动基础设施
cd infrastructure/docker
docker-compose up -d mysql redis nacos rocketmq influxdb

# 4. 等待服务就绪
./wait-for-services.sh

# 5. 初始化数据库
mysql -h127.0.0.1 -P23306 -uwework -pwework123456 < ../backend-refactor/ai-agent-service/sql/init-ai-agent-platform.sql

# 6. 启动应用服务
docker-compose up -d gateway-service ai-agent-service admin-web

# 7. 验证部署
./verify-deployment.sh
```

#### 开发环境部署
```bash
# 1. 启动基础设施
cd infrastructure/docker
docker-compose up -d mysql redis nacos

# 2. 启动后端服务
cd ../../backend-refactor/ai-agent-service
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev

# 3. 启动前端服务
cd ../../frontend/admin-web
npm install && npm run dev
```

### 3. Kubernetes部署

#### Helm Chart部署
```bash
# 1. 添加Helm仓库
helm repo add wework https://helm.your-company.com
helm repo update

# 2. 创建命名空间
kubectl create namespace wework-ai

# 3. 配置values.yaml
cat > values-prod.yaml << EOF
global:
  environment: production
  domain: ai-agent.your-company.com

mysql:
  enabled: true
  auth:
    rootPassword: "production-password"
    
redis:
  enabled: true
  auth:
    password: "production-password"

ai-agent-service:
  replicas: 3
  resources:
    requests:
      memory: "512Mi"
      cpu: "500m"
    limits:
      memory: "1Gi"
      cpu: "1000m"
EOF

# 4. 部署应用
helm install wework-ai wework/ai-agent-platform -f values-prod.yaml -n wework-ai

# 5. 验证部署
kubectl get pods -n wework-ai
```

## 👥 用户管理

### 1. 用户角色权限

#### 角色定义
```yaml
系统管理员 (SYSTEM_ADMIN):
  权限: 
    - 用户管理: 创建、编辑、删除、禁用用户
    - 系统配置: 修改系统参数、平台配置
    - 监控管理: 查看所有监控数据、导出报表
    - 数据管理: 备份、恢复、清理数据

租户管理员 (TENANT_ADMIN):
  权限:
    - 租户用户管理: 管理本租户用户
    - 智能体管理: 创建、配置、删除智能体
    - 平台配置: 配置AI平台连接
    - 使用监控: 查看本租户的使用统计

普通用户 (USER):
  权限:
    - 智能体使用: 与智能体对话
    - 会话管理: 创建、查看、删除自己的会话
    - 个人设置: 修改个人信息和偏好
```

#### 权限矩阵
```
功能模块            系统管理员  租户管理员  普通用户
用户管理               ✅        ⚠️       ❌
智能体管理             ✅        ✅       ⚠️
平台配置               ✅        ✅       ❌
对话交互               ✅        ✅       ✅
监控面板               ✅        ⚠️       ⚠️
系统设置               ✅        ❌       ❌

✅ 完全权限  ⚠️ 限制权限  ❌ 无权限
```

### 2. 用户操作

#### 创建用户
```bash
# 通过管理界面创建用户
POST /api/v1/users
{
  "username": "john.doe@company.com",
  "realName": "John Doe",
  "password": "TempPassword123!",
  "role": "USER",
  "tenantId": "tenant-001",
  "department": "Sales",
  "phone": "+86-138-0000-0000",
  "status": "ACTIVE"
}
```

#### 批量导入用户
```bash
# 使用CSV文件批量导入
# 格式: username,realName,role,tenantId,department,phone
curl -X POST http://localhost:18080/api/v1/users/batch-import \
  -H "Content-Type: multipart/form-data" \
  -F "file=@users.csv"
```

#### 重置用户密码
```bash
# 重置密码并发送邮件通知
POST /api/v1/users/{userId}/reset-password
{
  "notifyByEmail": true,
  "temporaryPassword": "NewTemp123!"
}
```

### 3. 租户管理

#### 创建租户
```yaml
租户信息:
  租户名称: "示例公司"
  租户代码: "example-corp"
  联系人: "张三"
  联系邮箱: "admin@example.com"
  
配额设置:
  最大用户数: 100
  最大智能体数: 50
  每日调用限额: 10000
  存储空间: 10GB
  
功能权限:
  Dify平台: 启用
  OpenAI平台: 启用
  Coze平台: 禁用
  文件上传: 启用
  API访问: 启用
```

#### 租户监控
```bash
# 查看租户使用情况
GET /api/v1/tenants/{tenantId}/usage
{
  "period": "month",
  "metrics": ["users", "agents", "calls", "costs"]
}

# 响应示例
{
  "users": {
    "current": 45,
    "limit": 100,
    "usage": "45%"
  },
  "calls": {
    "current": 7850,
    "limit": 10000,
    "usage": "78.5%"
  }
}
```

## ⚙️ 系统配置

### 1. 基础配置

#### 数据库配置
```yaml
# application-prod.yml
spring:
  datasource:
    url: jdbc:mysql://mysql-cluster:3306/ai_agent_platform
    username: ${MYSQL_USERNAME}
    password: ${MYSQL_PASSWORD}
    hikari:
      maximum-pool-size: 50
      minimum-idle: 10
      connection-timeout: 30000
      idle-timeout: 600000
      max-lifetime: 1800000
      leak-detection-threshold: 60000
```

#### Redis集群配置
```yaml
spring:
  redis:
    cluster:
      nodes:
        - redis-node1:6379
        - redis-node2:6379  
        - redis-node3:6379
      max-redirects: 3
    lettuce:
      pool:
        max-active: 20
        max-idle: 10
        min-idle: 5
        max-wait: 30000
```

#### 消息队列配置
```yaml
rocketmq:
  name-server: rocketmq-cluster:9876
  producer:
    group: ai-agent-producer
    send-message-timeout: 30000
    retry-times-when-send-failed: 3
  consumer:
    group: ai-agent-consumer
    consume-message-batch-max-size: 100
```

### 2. 安全配置

#### JWT配置
```yaml
app:
  jwt:
    secret-key: ${JWT_SECRET_KEY} # 256位密钥
    access-token-expiration: 7200000  # 2小时
    refresh-token-expiration: 604800000  # 7天
    issuer: ai-agent-platform
```

#### 跨域配置
```yaml
management:
  endpoints:
    web:
      cors:
        allowed-origins: 
          - https://ai-agent.your-company.com
          - https://admin.your-company.com
        allowed-methods: GET,POST,PUT,DELETE,PATCH,OPTIONS
        allowed-headers: "*"
        allow-credentials: true
```

#### 限流配置
```yaml
app:
  rate-limit:
    global:
      requests-per-minute: 1000
    api:
      requests-per-minute: 100
    user:
      requests-per-minute: 60
```

### 3. AI平台配置

#### 平台连接池配置
```yaml
app:
  ai:
    platforms:
      dify:
        connection-pool:
          max-connections: 50
          connection-timeout: 30000
          read-timeout: 60000
          keep-alive-duration: 300000
      openai:
        connection-pool:
          max-connections: 30
          connection-timeout: 30000
          read-timeout: 120000
          keep-alive-duration: 300000
```

#### 重试和熔断配置
```yaml
resilience4j:
  retry:
    instances:
      ai-platform:
        max-attempts: 3
        wait-duration: 1s
        exponential-backoff-multiplier: 2
  circuitbreaker:
    instances:
      ai-platform:
        failure-rate-threshold: 50
        wait-duration-in-open-state: 30s
        sliding-window-size: 10
```

## 📊 监控运维

### 1. 系统监控

#### 核心指标
```yaml
应用指标:
  - QPS (每秒请求数)
  - 响应时间 (P95, P99)
  - 错误率
  - 并发用户数
  - 内存使用率
  - CPU使用率

业务指标:
  - 智能体调用次数
  - 平台调用分布
  - 用户活跃度
  - 成本统计
  - 异常调用率
```

#### Prometheus监控配置
```yaml
# prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - "ai_agent_rules.yml"

scrape_configs:
  - job_name: 'ai-agent-service'
    static_configs:
      - targets: ['ai-agent-service:18086']
    metrics_path: '/actuator/prometheus'
    scrape_interval: 30s

  - job_name: 'gateway-service'
    static_configs:
      - targets: ['gateway-service:18080']
    metrics_path: '/actuator/prometheus'
    scrape_interval: 30s
```

#### 告警规则
```yaml
# ai_agent_rules.yml
groups:
  - name: ai_agent_alerts
    rules:
      # 高错误率告警
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.1
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "High error rate detected"
          
      # 响应时间过长告警
      - alert: HighResponseTime
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 2
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High response time detected"
          
      # 内存使用过高告警
      - alert: HighMemoryUsage
        expr: (process_resident_memory_bytes / 1024 / 1024) > 800
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High memory usage detected"
```

### 2. 日志管理

#### 日志配置
```yaml
# logback-spring.xml
<configuration>
  <springProfile name="prod">
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
      <encoder class="net.logstash.logback.encoder.LoggingEventCompositeJsonEncoder">
        <providers>
          <timestamp/>
          <logLevel/>
          <loggerName/>
          <mdc/>
          <message/>
          <stackTrace/>
        </providers>
      </encoder>
    </appender>
    
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
      <file>logs/ai-agent-service.log</file>
      <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
        <fileNamePattern>logs/ai-agent-service-%d{yyyy-MM-dd}.%i.log.gz</fileNamePattern>
        <maxFileSize>100MB</maxFileSize>
        <maxHistory>30</maxHistory>
        <totalSizeCap>10GB</totalSizeCap>
      </rollingPolicy>
    </appender>
  </springProfile>
</configuration>
```

#### 日志分析
```bash
# ELK Stack配置
# logstash配置
input {
  beats {
    port => 5044
  }
}

filter {
  if [fields][service] == "ai-agent-service" {
    json {
      source => "message"
    }
    date {
      match => [ "timestamp", "yyyy-MM-dd HH:mm:ss.SSS" ]
    }
  }
}

output {
  elasticsearch {
    hosts => ["elasticsearch:9200"]
    index => "ai-agent-logs-%{+YYYY.MM.dd}"
  }
}
```

### 3. 性能优化

#### JVM调优
```bash
# 生产环境JVM参数
JAVA_OPTS="
-Xms2g -Xmx4g
-XX:+UseG1GC
-XX:MaxGCPauseMillis=200
-XX:+UseStringDeduplication
-XX:+PrintGCDetails
-XX:+PrintGCTimeStamps
-Xloggc:logs/gc.log
-XX:+UseGCLogFileRotation
-XX:NumberOfGCLogFiles=10
-XX:GCLogFileSize=100M
-Dspring.profiles.active=prod
"
```

#### 数据库优化
```sql
-- 索引优化
CREATE INDEX idx_call_records_tenant_created 
ON call_records(tenant_id, created_at);

CREATE INDEX idx_conversations_agent_updated 
ON conversations(agent_id, updated_at);

-- 查询优化
-- 分页查询优化
SELECT * FROM call_records 
WHERE tenant_id = ? AND id > ? 
ORDER BY id LIMIT 20;

-- 统计查询优化
SELECT DATE(created_at) as date, COUNT(*) as count
FROM call_records 
WHERE tenant_id = ? 
  AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY DATE(created_at)
ORDER BY date;
```

#### 缓存优化
```java
// Redis缓存策略
@Cacheable(value = "agent-config", key = "#tenantId + ':' + #agentId", unless = "#result == null")
public AgentConfig getAgentConfig(String tenantId, String agentId) {
    return agentConfigRepository.findByTenantIdAndAgentId(tenantId, agentId);
}

// 缓存预热
@PostConstruct
public void warmupCache() {
    List<String> activeTenants = tenantService.getActiveTenantIds();
    activeTenants.parallelStream().forEach(tenantId -> {
        List<Agent> agents = agentService.getActiveAgents(tenantId);
        agents.forEach(agent -> {
            agentConfigService.getAgentConfig(tenantId, agent.getId());
        });
    });
}
```

## 🛠️ 维护操作

### 1. 备份恢复

#### 数据库备份
```bash
#!/bin/bash
# backup-database.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/data/backups/mysql"
MYSQL_HOST="mysql-cluster"
MYSQL_USER="backup_user"
MYSQL_PASS="backup_password"

# 全量备份
mysqldump \
  --host=$MYSQL_HOST \
  --user=$MYSQL_USER \
  --password=$MYSQL_PASS \
  --single-transaction \
  --routines \
  --triggers \
  --all-databases \
  --events \
  --flush-logs \
  --master-data=2 \
  | gzip > $BACKUP_DIR/full_backup_$DATE.sql.gz

# 验证备份
if [ $? -eq 0 ]; then
    echo "Backup completed successfully: full_backup_$DATE.sql.gz"
    # 删除7天前的备份
    find $BACKUP_DIR -name "full_backup_*.sql.gz" -mtime +7 -delete
else
    echo "Backup failed!"
    exit 1
fi
```

#### Redis备份
```bash
#!/bin/bash
# backup-redis.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/data/backups/redis"
REDIS_HOST="redis-cluster"

# 创建RDB快照
redis-cli -h $REDIS_HOST -p 6379 BGSAVE

# 等待备份完成
while [ $(redis-cli -h $REDIS_HOST -p 6379 LASTSAVE) -eq $(redis-cli -h $REDIS_HOST -p 6379 LASTSAVE) ]; do
    sleep 1
done

# 复制备份文件
cp /data/redis/dump.rdb $BACKUP_DIR/dump_$DATE.rdb

echo "Redis backup completed: dump_$DATE.rdb"
```

#### 恢复操作
```bash
# 数据库恢复
gunzip < /data/backups/mysql/full_backup_20240115_140000.sql.gz | \
mysql -h mysql-cluster -u root -p

# Redis恢复
# 1. 停止Redis服务
docker stop redis-container

# 2. 替换RDB文件
cp /data/backups/redis/dump_20240115_140000.rdb /data/redis/dump.rdb

# 3. 启动Redis服务
docker start redis-container
```

### 2. 系统升级

#### 滚动升级
```bash
#!/bin/bash
# rolling-update.sh

SERVICE_NAME="ai-agent-service"
NEW_VERSION="2.1.0"

# 1. 拉取新镜像
docker pull wework/$SERVICE_NAME:$NEW_VERSION

# 2. 滚动更新
kubectl set image deployment/$SERVICE_NAME \
    $SERVICE_NAME=wework/$SERVICE_NAME:$NEW_VERSION \
    -n wework-ai

# 3. 等待更新完成
kubectl rollout status deployment/$SERVICE_NAME -n wework-ai

# 4. 验证新版本
kubectl get pods -n wework-ai -l app=$SERVICE_NAME

# 5. 健康检查
for i in {1..10}; do
    if curl -f http://ai-agent-service:18086/actuator/health; then
        echo "Health check passed"
        break
    else
        echo "Health check failed, attempt $i"
        sleep 30
    fi
done
```

#### 回滚操作
```bash
# 快速回滚到上一版本
kubectl rollout undo deployment/ai-agent-service -n wework-ai

# 回滚到指定版本
kubectl rollout undo deployment/ai-agent-service --to-revision=3 -n wework-ai

# 查看回滚状态
kubectl rollout status deployment/ai-agent-service -n wework-ai
```

### 3. 数据清理

#### 定期清理脚本
```sql
-- cleanup-old-data.sql
-- 清理90天前的调用记录
DELETE FROM call_records 
WHERE created_at < DATE_SUB(NOW(), INTERVAL 90 DAY);

-- 清理30天前的会话记录
DELETE FROM conversations 
WHERE updated_at < DATE_SUB(NOW(), INTERVAL 30 DAY) 
  AND status = 'ARCHIVED';

-- 清理临时文件记录
DELETE FROM temp_files 
WHERE created_at < DATE_SUB(NOW(), INTERVAL 1 DAY);

-- 优化表空间
OPTIMIZE TABLE call_records;
OPTIMIZE TABLE conversations;
OPTIMIZE TABLE messages;
```

#### 自动化清理任务
```yaml
# k8s CronJob
apiVersion: batch/v1
kind: CronJob
metadata:
  name: data-cleanup
  namespace: wework-ai
spec:
  schedule: "0 2 * * 0"  # 每周日凌晨2点
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: cleanup
            image: mysql:8.0
            command:
            - /bin/bash
            - -c
            - |
              mysql -h mysql-service -u cleanup_user -p$MYSQL_PASSWORD ai_agent_platform < /sql/cleanup-old-data.sql
            env:
            - name: MYSQL_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysql-secret
                  key: cleanup-password
            volumeMounts:
            - name: sql-scripts
              mountPath: /sql
          volumes:
          - name: sql-scripts
            configMap:
              name: cleanup-scripts
          restartPolicy: OnFailure
```

## 🚨 故障排除

### 1. 常见问题

#### 服务启动失败
```bash
# 检查容器状态
docker ps -a | grep ai-agent-service

# 查看容器日志
docker logs ai-agent-service-container

# 检查端口占用
netstat -tulpn | grep 18086

# 检查配置文件
kubectl describe configmap ai-agent-config -n wework-ai
```

#### 数据库连接问题
```bash
# 测试数据库连接
mysql -h mysql-cluster -P 3306 -u wework -p ai_agent_platform

# 检查连接池状态
curl http://ai-agent-service:18086/actuator/metrics/hikaricp.connections

# 查看慢查询日志
mysql -h mysql-cluster -u root -p -e "
  SELECT * FROM mysql.slow_log 
  WHERE start_time > DATE_SUB(NOW(), INTERVAL 1 HOUR) 
  ORDER BY start_time DESC LIMIT 10;
"
```

#### 内存泄漏问题
```bash
# 生成内存快照
kubectl exec -it ai-agent-service-pod -n wework-ai -- \
  jcmd 1 GC.run_finalization
kubectl exec -it ai-agent-service-pod -n wework-ai -- \
  jcmd 1 VM.gc
kubectl exec -it ai-agent-service-pod -n wework-ai -- \
  jcmd 1 GC.heap_dump /tmp/heapdump.hprof

# 分析内存使用
kubectl exec -it ai-agent-service-pod -n wework-ai -- \
  jstat -gc 1 5s 10
```

### 2. 性能问题

#### 响应时间过长
```bash
# 分析请求分布
curl http://ai-agent-service:18086/actuator/metrics/http.server.requests | jq .

# 查看数据库慢查询
mysql -h mysql-cluster -u root -p -e "
  SHOW VARIABLES LIKE 'slow_query_log%';
  SHOW VARIABLES LIKE 'long_query_time';
  SELECT * FROM information_schema.processlist WHERE time > 10;
"

# 检查Redis性能
redis-cli -h redis-cluster --latency-history -i 1

# 检查线程池状态
curl http://ai-agent-service:18086/actuator/metrics/executor.pool.size
```

#### 高并发问题
```bash
# 压力测试
ab -n 1000 -c 50 http://ai-agent-service:18086/api/v1/agents

# 监控系统资源
kubectl top pods -n wework-ai
kubectl top nodes

# 检查限流配置
curl http://gateway-service:18080/actuator/metrics/resilience4j.ratelimiter
```

## 📞 支持联系

### 技术支持
- **内部支持**: DevOps团队 (ext: 8888)
- **供应商支持**: 
  - 阿里云: 95187
  - 腾讯云: 95716
  - AWS: 400-921-3388

### 紧急响应
```yaml
P0 (系统宕机): 
  - 响应时间: 15分钟内
  - 联系方式: 24x7热线 400-123-4567

P1 (核心功能异常):
  - 响应时间: 1小时内
  - 联系方式: 技术支持邮箱

P2 (一般问题):
  - 响应时间: 4小时内 (工作日)
  - 联系方式: 工单系统
```

### 升级路径
- **小版本升级**: 每月第二周
- **大版本升级**: 每季度末
- **安全补丁**: 发现后48小时内

---

⚠️ **重要提醒**: 生产环境操作前请务必在测试环境验证，并做好备份。遇到不确定的问题请及时联系技术支持团队。