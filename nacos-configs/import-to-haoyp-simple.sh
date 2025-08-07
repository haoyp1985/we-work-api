#!/bin/bash

# =================================================================
# WeWork Platform - 导入配置到haoyp命名空间
# =================================================================

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Nacos配置
NACOS_SERVER="localhost:28848"
NACOS_USERNAME="nacos"
NACOS_PASSWORD="nacos"
NAMESPACE_ID="2e42fb0d-3ea7-47b9-8680-c7c615eb95f0"  # haoyp命名空间ID
GROUP="DEFAULT_GROUP"

echo -e "${BLUE}🚀 开始导入配置到Nacos haoyp命名空间...${NC}"
echo "========================================"

# 获取项目根目录
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# 检查Nacos是否可用
echo -e "${YELLOW}🔍 检查Nacos连接...${NC}"
if ! curl -s "http://$NACOS_SERVER/nacos/v1/ns/operator/servers" >/dev/null 2>&1; then
    echo -e "${RED}❌ Nacos服务不可用 (http://$NACOS_SERVER)${NC}"
    echo -e "${YELLOW}请确保Nacos容器正在运行${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Nacos连接正常${NC}"

# 发布配置到Nacos的函数
publish_config() {
    local data_id=$1
    local config_content=$2
    
    echo -e "${YELLOW}📝 发布配置: $data_id${NC}"
    
    # 使用curl发布配置到Nacos（带命名空间）
    response=$(curl -s -X POST "http://$NACOS_SERVER/nacos/v1/cs/configs" \
        --data-urlencode "dataId=$data_id" \
        --data-urlencode "group=$GROUP" \
        --data-urlencode "tenant=$NAMESPACE_ID" \
        --data-urlencode "content=$config_content" \
        --data-urlencode "username=$NACOS_USERNAME" \
        --data-urlencode "password=$NACOS_PASSWORD")
    
    if [ "$response" = "true" ]; then
        echo -e "${GREEN}✅ $data_id 发布成功${NC}"
        return 0
    else
        echo -e "${RED}❌ $data_id 发布失败: $response${NC}"
        return 1
    fi
}

# 1. 基础共享配置
echo -e "${BLUE}📦 发布基础共享配置...${NC}"

# basic-config-dev.yml
basic_config=$(cat << 'EOF'
# =================================================================
# WeWork Platform - 基础配置 (开发环境)
# Data ID: basic-config-dev.yml
# Group: DEFAULT_GROUP
# =================================================================

# 日志配置
logging:
  level:
    com.wework.platform: DEBUG
    com.alibaba.nacos: INFO
    org.springframework.cloud: INFO
  pattern:
    console: "%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n"
    file: "%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n"
  file:
    name: logs/${spring.application.name}.log

# 管理端点配置
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
  endpoint:
    health:
      show-details: always
      show-components: always
  health:
    defaults:
      enabled: true

# 应用信息
info:
  app:
    name: ${spring.application.name}
    version: 2.0.0-SNAPSHOT
    description: WeWork Platform Service
    java:
      version: ${java.version}
    spring-boot:
      version: ${spring-boot.version}
EOF
)

publish_config "basic-config-dev.yml" "$basic_config"

# redis-config-dev.yml
redis_config=$(cat redis-config-dev.yml)
publish_config "redis-config-dev.yml" "$redis_config"

# database-config-dev.yml  
database_config=$(cat database-config-dev.yml)
publish_config "database-config-dev.yml" "$database_config"

# common-config-dev.yml
common_config=$(cat common-config-dev.yml)
publish_config "common-config-dev.yml" "$common_config"
BASIC_CONFIG='# JWT配置
jwt:
  secret: ${JWT_SECRET:wework-platform-secret-key-for-jwt-token-generation}
  expiration: 86400000  # 24小时
  refresh-expiration: 604800000  # 7天

# 加密配置
encryption:
  password:
    salt: ${PASSWORD_SALT:wework-platform-password-salt}
    iterations: 10000

# 监控配置
monitoring:
  metrics:
    enabled: true
    export:
      prometheus:
        enabled: true
  health:
    check-interval: 30000
    failure-threshold: 3

# 日志配置
logging:
  level:
    root: info
    com.wework.platform: debug'

publish_config "basic-config-dev.yml" "$BASIC_CONFIG"

# data-config-dev.yml
DATA_CONFIG='# 数据源配置
spring:
  datasource:
    # 主数据源 - 统一核心数据库
    primary:
      url: ${DB_URL:jdbc:mysql://localhost:23306/saas_unified_core?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true}
      username: ${DB_USERNAME:wework}
      password: ${DB_PASSWORD:wework123456}
      driver-class-name: com.mysql.cj.jdbc.Driver
      hikari:
        pool-name: primary-hikari-pool
        maximum-pool-size: 20
        minimum-idle: 5
        connection-timeout: 30000
        idle-timeout: 600000
        max-lifetime: 1800000

# Redis配置
redis:
  host: ${REDIS_HOST:localhost}
  port: ${REDIS_PORT:26379}
  password: ${REDIS_PASSWORD:wework123456}
  database: 0
  timeout: 3000
  lettuce:
    pool:
      max-active: 8
      max-idle: 8
      min-idle: 2
      max-wait: -1ms'

publish_config "data-config-dev.yml" "$DATA_CONFIG"

# 2. 网关服务配置
echo -e "${BLUE}📦 发布网关服务配置...${NC}"

GATEWAY_CONFIG='spring:
  application:
    name: gateway-service
  cloud:
    gateway:
      routes:
        # 账户服务路由
        - id: account-service
          uri: lb://account-service
          predicates:
            - Path=/api/v1/accounts/**
          filters:
            - StripPrefix=2
        # 消息服务路由
        - id: message-service
          uri: lb://message-service
          predicates:
            - Path=/api/v1/messages/**
          filters:
            - StripPrefix=2
        # 监控服务路由
        - id: monitor-service
          uri: lb://monitor-service
          predicates:
            - Path=/api/v1/monitor/**
          filters:
            - StripPrefix=2
        # 任务服务路由
        - id: task-service
          uri: lb://task-service
          predicates:
            - Path=/api/v1/tasks/**
          filters:
            - StripPrefix=2
        # 用户服务路由
        - id: user-service
          uri: lb://user-service
          predicates:
            - Path=/api/v1/users/**
          filters:
            - StripPrefix=2
        # AI智能体服务路由
        - id: ai-agent-service
          uri: lb://ai-agent-service
          predicates:
            - Path=/api/v1/agents/**
          filters:
            - StripPrefix=2

server:
  port: ${SERVER_PORT:18080}

  # 导入共享配置
  config:
    import:
      - nacos:basic-config-dev.yml
      - nacos:data-config-dev.yml'

publish_config "gateway-service-dev.yml" "$GATEWAY_CONFIG"

# 3. 账户服务配置
echo -e "${BLUE}📦 发布账户服务配置...${NC}"

ACCOUNT_CONFIG='spring:
  application:
    name: account-service
  datasource:
    url: ${DB_URL:jdbc:mysql://localhost:23306/wework_platform?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true}
    username: ${DB_USERNAME:wework}
    password: ${DB_PASSWORD:wework123456}
    driver-class-name: com.mysql.cj.jdbc.Driver
  # 导入共享配置
  config:
    import:
      - nacos:basic-config-dev.yml
      - nacos:data-config-dev.yml

server:
  port: ${SERVER_PORT:18081}

# 企微API配置
wework:
  api:
    base-url: ${WEWORK_API_URL:http://localhost:8080}
    timeout: 30000'

publish_config "account-service-dev.yml" "$ACCOUNT_CONFIG"

# 4. 消息服务配置
echo -e "${BLUE}📦 发布消息服务配置...${NC}"

MESSAGE_CONFIG='spring:
  application:
    name: message-service
  datasource:
    url: ${DB_URL:jdbc:mysql://localhost:23306/wework_platform?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true}
    username: ${DB_USERNAME:wework}
    password: ${DB_PASSWORD:wework123456}
    driver-class-name: com.mysql.cj.jdbc.Driver

server:
  port: ${SERVER_PORT:18082}

# 消息推送配置
message:
  push:
    max-retry-count: 3
    retry-interval: 5000
    batch-size: 100
    thread-pool-size: 10

  # 导入共享配置
  config:
    import:
      - nacos:basic-config-dev.yml
      - nacos:data-config-dev.yml'

publish_config "message-service-dev.yml" "$MESSAGE_CONFIG"

# 5. 监控服务配置
echo -e "${BLUE}📦 发布监控服务配置...${NC}"

MONITOR_CONFIG='spring:
  application:
    name: monitor-service
  datasource:
    url: ${DB_URL:jdbc:mysql://localhost:23306/saas_unified_core?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true}
    username: ${DB_USERNAME:wework}
    password: ${DB_PASSWORD:wework123456}
    driver-class-name: com.mysql.cj.jdbc.Driver

server:
  port: ${SERVER_PORT:18083}

# 监控配置
monitor:
  alert:
    enabled: true
    check-interval: 60000
  metrics:
    retention-days: 30

  # 导入共享配置
  config:
    import:
      - nacos:basic-config-dev.yml
      - nacos:data-config-dev.yml'

publish_config "monitor-service-dev.yml" "$MONITOR_CONFIG"

# 6. 任务服务配置
echo -e "${BLUE}📦 发布任务服务配置...${NC}"

TASK_CONFIG='spring:
  application:
    name: task-service
  datasource:
    url: ${DB_URL:jdbc:mysql://localhost:23306/ai_agent_platform?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true}
    username: ${DB_USERNAME:wework}
    password: ${DB_PASSWORD:wework123456}
    driver-class-name: com.mysql.cj.jdbc.Driver

server:
  port: ${SERVER_PORT:18084}

# 任务调度配置
task:
  scheduler:
    pool-size: 10
    queue-capacity: 100
  execution:
    timeout: 300000

  # 导入共享配置
  config:
    import:
      - nacos:basic-config-dev.yml
      - nacos:data-config-dev.yml'

publish_config "task-service-dev.yml" "$TASK_CONFIG"

# 7. 用户服务配置
echo -e "${BLUE}📦 发布用户服务配置...${NC}"

USER_CONFIG='spring:
  application:
    name: user-service
  datasource:
    url: ${DB_URL:jdbc:mysql://localhost:23306/saas_unified_core?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true}
    username: ${DB_USERNAME:wework}
    password: ${DB_PASSWORD:wework123456}
    driver-class-name: com.mysql.cj.jdbc.Driver

server:
  port: ${SERVER_PORT:18085}

# 用户认证配置
user:
  auth:
    token-expiration: 86400
    refresh-token-expiration: 604800

  # 导入共享配置
  config:
    import:
      - nacos:basic-config-dev.yml
      - nacos:data-config-dev.yml'

publish_config "user-service-dev.yml" "$USER_CONFIG"

echo ""
echo -e "${GREEN}🎉 所有配置已成功发布到Nacos haoyp命名空间！${NC}"
echo "========================================"
echo -e "${CYAN}📋 已发布的配置：${NC}"
echo "  - basic-config-dev.yml (基础共享配置)"
echo "  - data-config-dev.yml (数据源配置)"
echo "  - gateway-service-dev.yml"
echo "  - account-service-dev.yml"
echo "  - message-service-dev.yml"
echo "  - monitor-service-dev.yml"
echo "  - task-service-dev.yml"
echo "  - user-service-dev.yml"
echo ""
echo -e "${YELLOW}🔄 下一步：修改服务的bootstrap.yml文件以使用haoyp命名空间${NC}"