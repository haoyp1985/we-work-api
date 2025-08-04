# 🏗️ 基础设施部署和配置规则

## 📐 基础设施架构规范

### 1. Docker编排配置
```yaml
# ✅ 标准docker-compose.yml结构
version: '3.8'

services:
  # 数据库层
  mysql:
    image: mysql:8.0
    container_name: wework-mysql
    restart: unless-stopped
    deploy:
      resources:
        limits:
          memory: 512M
        reservations:
          memory: 256M
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: wework_platform
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    ports:
      - "23306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
      - ./database/init:/docker-entrypoint-initdb.d
      - ./database/conf/my.cnf:/etc/mysql/conf.d/my.cnf
    command: --default-authentication-plugin=mysql_native_password
    networks:
      - wework-network
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      timeout: 20s
      retries: 10

  # 缓存层
  redis:
    image: redis:7.0-alpine
    container_name: wework-redis
    restart: unless-stopped
    deploy:
      resources:
        limits:
          memory: 256M
        reservations:
          memory: 128M
    ports:
      - "26379:6379"
    volumes:
      - redis_data:/data
      - ./database/conf/redis.conf:/usr/local/etc/redis/redis.conf
    command: redis-server /usr/local/etc/redis/redis.conf
    networks:
      - wework-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 30s
      timeout: 3s
      retries: 5
```

### 2. 服务配置规范
```yaml
# ✅ 微服务标准配置
services:
  gateway-service:
    image: wework/gateway-service:${VERSION:-latest}
    container_name: wework-gateway
    restart: unless-stopped
    ports:
      - "18080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=${PROFILE:-dev}
      - NACOS_SERVER=${NACOS_SERVER:-nacos:8848}
      - NACOS_NAMESPACE=${NACOS_NAMESPACE:-dev}
      - REDIS_HOST=${REDIS_HOST:-redis}
      - REDIS_PORT=${REDIS_PORT:-6379}
    depends_on:
      - nacos
      - redis
    networks:
      - wework-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/actuator/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s
```

## 🔧 容器化部署规范

### 1. Dockerfile标准
```dockerfile
# ✅ 多阶段构建标准模板
# 构建阶段
FROM maven:3.9-openjdk-17-slim as builder

WORKDIR /app

# 复制依赖文件
COPY pom.xml ./
COPY src ./src

# 构建应用
RUN mvn clean package -DskipTests -Dmaven.compile.fork=true

# 运行阶段
FROM openjdk:17-jre-slim

# 创建应用用户
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# 安装必要工具
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 复制应用
COPY --from=builder /app/target/*.jar app.jar

# 设置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 创建日志目录
RUN mkdir -p /app/logs && chown -R appuser:appgroup /app

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

# 切换用户
USER appuser

EXPOSE 8080

# JVM参数优化
ENV JAVA_OPTS="-Xms512m -Xmx1024m -XX:+UseG1GC -XX:+UseContainerSupport \
               -XX:MaxRAMPercentage=75 -XX:+HeapDumpOnOutOfMemoryError \
               -XX:HeapDumpPath=/app/logs/ -Djava.security.egd=file:/dev/./urandom"

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
```

### 2. 镜像管理规范
```bash
# ✅ 镜像标签规范
# 格式: {registry}/{namespace}/{service}:{version}-{env}
docker build -t registry.internal/wework/account-service:1.0.0-dev .
docker build -t registry.internal/wework/account-service:1.0.0-prod .

# ✅ 镜像推送规范
docker push registry.internal/wework/account-service:1.0.0-dev
docker tag registry.internal/wework/account-service:1.0.0-dev \
           registry.internal/wework/account-service:latest-dev

# ✅ 镜像清理规范
# 定期清理未使用的镜像
docker image prune -af --filter "until=24h"
```

## 📊 监控体系配置

### 1. Prometheus配置
```yaml
# ✅ prometheus.yml配置
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - "alert_rules.yml"

scrape_configs:
  # Spring Boot应用监控
  - job_name: 'spring-boot-apps'
    metrics_path: '/actuator/prometheus'
    static_configs:
      - targets: ['gateway-service:8080', 'account-service:8080', 'message-service:8080']
    scrape_interval: 10s

  # MySQL监控
  - job_name: 'mysql'
    static_configs:
      - targets: ['mysql-exporter:9104']

  # Redis监控  
  - job_name: 'redis'
    static_configs:
      - targets: ['redis-exporter:9121']

  # 容器监控
  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']

  # 节点监控
  - job_name: 'node'
    static_configs:
      - targets: ['node-exporter:9100']

alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - alertmanager:9093
```

### 2. Grafana Dashboard配置
```json
// ✅ 应用监控Dashboard配置
{
  "dashboard": {
    "title": "WeWork Platform 应用监控",
    "tags": ["wework", "spring-boot"],
    "time": {
      "from": "now-1h",
      "to": "now"
    },
    "refresh": "30s",
    "panels": [
      {
        "title": "应用健康状态",
        "type": "stat",
        "targets": [
          {
            "expr": "up{job=\"spring-boot-apps\"}",
            "legendFormat": "{{instance}}"
          }
        ]
      },
      {
        "title": "JVM内存使用率",
        "type": "timeseries",
        "targets": [
          {
            "expr": "jvm_memory_used_bytes{job=\"spring-boot-apps\"} / jvm_memory_max_bytes{job=\"spring-boot-apps\"} * 100",
            "legendFormat": "{{instance}} - {{area}}"
          }
        ]
      },
      {
        "title": "HTTP请求QPS",
        "type": "timeseries",
        "targets": [
          {
            "expr": "rate(http_server_requests_seconds_count{job=\"spring-boot-apps\"}[1m])",
            "legendFormat": "{{instance}} - {{method}} {{uri}}"
          }
        ]
      }
    ]
  }
}
```

### 3. 告警规则配置
```yaml
# ✅ alert_rules.yml告警规则
groups:
  - name: wework-platform-alerts
    rules:
      # 服务可用性告警
      - alert: ServiceDown
        expr: up{job="spring-boot-apps"} == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "服务 {{ $labels.instance }} 不可用"
          description: "{{ $labels.instance }} 服务已停止超过1分钟"

      # JVM内存告警
      - alert: HighMemoryUsage
        expr: (jvm_memory_used_bytes{job="spring-boot-apps"} / jvm_memory_max_bytes{job="spring-boot-apps"}) * 100 > 85
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "{{ $labels.instance }} 内存使用率过高"
          description: "JVM内存使用率: {{ $value }}%"

      # HTTP错误率告警
      - alert: HighErrorRate
        expr: rate(http_server_requests_seconds_count{job="spring-boot-apps",status=~"5.."}[5m]) / rate(http_server_requests_seconds_count{job="spring-boot-apps"}[5m]) * 100 > 5
        for: 3m
        labels:
          severity: warning
        annotations:
          summary: "{{ $labels.instance }} HTTP错误率过高"
          description: "5xx错误率: {{ $value }}%"

      # 数据库连接告警
      - alert: DatabaseConnectionHigh
        expr: hikaricp_connections_active{job="spring-boot-apps"} / hikaricp_connections_max{job="spring-boot-apps"} * 100 > 80
        for: 2m
        labels:
          severity: warning
        annotations:
          summary: "{{ $labels.instance }} 数据库连接使用率过高"
          description: "连接池使用率: {{ $value }}%"
```

## 🗄️ 数据库部署规范

### 1. MySQL配置优化
```ini
# ✅ my.cnf生产环境配置
[mysqld]
# 基础配置
port = 3306
socket = /var/run/mysqld/mysqld.sock
pid-file = /var/run/mysqld/mysqld.pid
datadir = /var/lib/mysql

# 字符集配置
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
init_connect = 'SET NAMES utf8mb4'

# 连接配置
max_connections = 200
max_connect_errors = 1000
wait_timeout = 28800
interactive_timeout = 28800

# 缓存配置
innodb_buffer_pool_size = 512M
innodb_log_file_size = 128M
innodb_log_buffer_size = 16M
innodb_flush_log_at_trx_commit = 1
innodb_flush_method = O_DIRECT

# 查询缓存
query_cache_type = 1
query_cache_size = 64M
query_cache_limit = 2M

# 慢查询日志
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow.log
long_query_time = 2
log_queries_not_using_indexes = 1

# 二进制日志
log-bin = mysql-bin
binlog_format = ROW
expire_logs_days = 7
max_binlog_size = 100M

# 错误日志
log-error = /var/log/mysql/error.log

# 安全配置
local-infile = 0
skip-symbolic-links
```

### 2. Redis配置优化
```ini
# ✅ redis.conf生产环境配置
# 基础配置
port 6379
bind 0.0.0.0
protected-mode yes
requirepass wework_redis_2024

# 内存配置
maxmemory 256mb
maxmemory-policy allkeys-lru

# 持久化配置
save 900 1
save 300 10
save 60 10000
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename dump.rdb

# AOF配置
appendonly yes
appendfilename "appendonly.aof"
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb

# 日志配置
loglevel notice
logfile /var/log/redis/redis-server.log
syslog-enabled yes
syslog-ident redis

# 网络配置
timeout 300
tcp-keepalive 300
tcp-backlog 511

# 客户端配置
maxclients 10000
```

## 📦 中间件部署规范

### 1. RocketMQ配置
```properties
# ✅ broker.conf配置
# 集群名称
brokerClusterName = DefaultCluster
brokerName = broker-a
brokerId = 0

# 网络配置
listenPort = 10911
namesrvAddr = rocketmq-nameserver:9876

# 存储配置
storePathRootDir = /opt/store
storePathCommitLog = /opt/store/commitlog
storePathConsumeQueue = /opt/store/consumequeue
storePathIndex = /opt/store/index

# 性能配置
defaultTopicQueueNums = 4
autoCreateTopicEnable = true
autoCreateSubscriptionGroup = true

# 清理配置
fileReservedTime = 72
deleteWhen = 04
diskMaxUsedSpaceRatio = 88

# 网络配置
brokerIP1 = 0.0.0.0
```

### 2. Nacos配置
```yaml
# ✅ nacos配置
server:
  port: 8848

spring:
  datasource:
    platform: mysql
    db:
      num: 1
      url:
        0: jdbc:mysql://mysql:3306/nacos_config?characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useUnicode=true&useSSL=false&serverTimezone=Asia/Shanghai
      username:
        0: nacos
      password:
        0: nacos123456

nacos:
  security:
    ignore:
      urls: /,/error,/**/*.css,/**/*.js,/**/*.html,/**/*.map,/**/*.svg,/**/*.png,/**/*.ico,/console-ui/public/**,/v1/auth/**,/v1/console/health/**,/actuator/**,/v1/console/server/**
  core:
    auth:
      system:
        type: nacos
        token:
          secret:
            key: VGhpc0lzTXlDdXN0b21TZWNyZXRLZXkwMTIzNDU2Nzg5QUJDREVGMDEyMzQ1Njc4OUFCQ0RFRg==
      enabled: true
      enable:
        userAgentAuthWhite: false
      plugin:
        nacos:
          token:
            expire:
              seconds: 18000
  istio:
    mcp:
      server:
        enabled: false
```

## 🔍 环境管理规范

### 1. 环境配置
```bash
# ✅ 环境变量配置
# 开发环境 (.env.dev)
PROFILE=dev
MYSQL_ROOT_PASSWORD=dev123456
MYSQL_USER=wework_dev
MYSQL_PASSWORD=dev123456
REDIS_PASSWORD=dev_redis_2024
NACOS_SERVER=localhost:8848
NACOS_NAMESPACE=dev

# 测试环境 (.env.test)
PROFILE=test
MYSQL_ROOT_PASSWORD=test123456
MYSQL_USER=wework_test
MYSQL_PASSWORD=test123456
REDIS_PASSWORD=test_redis_2024
NACOS_SERVER=nacos-test:8848
NACOS_NAMESPACE=test

# 生产环境 (.env.prod)
PROFILE=prod
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
MYSQL_USER=wework_prod
MYSQL_PASSWORD=${MYSQL_PASSWORD}
REDIS_PASSWORD=${REDIS_PASSWORD}
NACOS_SERVER=nacos-cluster:8848
NACOS_NAMESPACE=prod
```

### 2. 资源限制配置
```yaml
# ✅ 资源限制标准
deploy:
  resources:
    # 网关服务
    gateway-service:
      limits:
        memory: 1Gi
        cpu: 1000m
      reservations:
        memory: 512Mi
        cpu: 500m
    
    # 业务服务
    account-service:
      limits:
        memory: 800Mi
        cpu: 800m
      reservations:
        memory: 400Mi
        cpu: 400m
    
    # 数据库
    mysql:
      limits:
        memory: 1Gi
        cpu: 1000m
      reservations:
        memory: 512Mi
        cpu: 500m
    
    # 缓存
    redis:
      limits:
        memory: 256Mi
        cpu: 200m
      reservations:
        memory: 128Mi
        cpu: 100m
```

**规则总结**:
- 使用Docker Compose统一编排所有基础设施
- 配置完整的监控体系(Prometheus + Grafana + 告警)
- 数据库和中间件必须优化配置参数
- 实现多环境配置管理和资源限制
- 所有服务必须配置健康检查和日志收集