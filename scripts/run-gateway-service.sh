#!/bin/bash

# =================================================================
# WeWork Platform - 网关服务运行脚本
# =================================================================

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目配置
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVICE_NAME="gateway-service"
SERVICE_PATH="$PROJECT_ROOT/backend/$SERVICE_NAME"
JAR_NAME="gateway-service-1.0.0.jar"
JAR_PATH="$SERVICE_PATH/target/$JAR_NAME"

echo -e "${BLUE}🚀 启动 $SERVICE_NAME${NC}"
echo "========================================"
echo "项目根目录: $PROJECT_ROOT"
echo "服务路径: $SERVICE_PATH"
echo "JAR文件: $JAR_PATH"
echo "启动时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================"

# 检查JAR文件
if [ ! -f "$JAR_PATH" ]; then
    echo -e "${RED}❌ JAR文件不存在: $JAR_PATH${NC}"
    echo -e "${YELLOW}请先运行构建脚本: ./scripts/build-gateway-service.sh${NC}"
    exit 1
fi

# 检查基础设施依赖
echo -e "${YELLOW}🔍 检查基础设施状态...${NC}"

# 检查MySQL
if ! docker ps | grep -q "wework-mysql.*Up"; then
    echo -e "${RED}❌ MySQL容器未运行${NC}"
    echo -e "${YELLOW}请先启动基础设施: cd infrastructure/docker && docker-compose up -d mysql${NC}"
    exit 1
fi

# 检查Redis
if ! docker ps | grep -q "wework-redis.*Up"; then
    echo -e "${RED}❌ Redis容器未运行${NC}"
    echo -e "${YELLOW}请先启动基础设施: cd infrastructure/docker && docker-compose up -d redis${NC}"
    exit 1
fi

# 检查Nacos
if ! docker ps | grep -q "wework-nacos.*Up"; then
    echo -e "${RED}❌ Nacos容器未运行${NC}"
    echo -e "${YELLOW}请先启动基础设施: cd infrastructure/docker && docker-compose up -d nacos${NC}"
    exit 1
fi

echo -e "${GREEN}✅ 基础设施检查通过${NC}"

# 等待基础设施就绪
echo -e "${YELLOW}⏳ 等待基础设施就绪...${NC}"

# 等待MySQL就绪
echo -n "等待MySQL就绪..."
while ! docker exec wework-mysql mysqladmin ping -h localhost -u root -proot123 --silent > /dev/null 2>&1; do
    echo -n "."
    sleep 2
done
echo -e " ${GREEN}✅${NC}"

# 等待Redis就绪
echo -n "等待Redis就绪..."
while ! docker exec wework-redis redis-cli ping > /dev/null 2>&1; do
    echo -n "."
    sleep 2
done
echo -e " ${GREEN}✅${NC}"

# 等待Nacos就绪
echo -n "等待Nacos就绪..."
while ! curl -s http://localhost:8848/nacos/v1/ns/operator/servers > /dev/null 2>&1; do
    echo -n "."
    sleep 2
done
echo -e " ${GREEN}✅${NC}"

echo -e "${GREEN}🎯 所有依赖服务已就绪${NC}"

# 设置环境变量
export SPRING_PROFILES_ACTIVE=dev
export NACOS_SERVER_ADDR=localhost:8848
export REDIS_HOST=localhost
export REDIS_PORT=6379

# 启动服务
echo -e "${BLUE}🔥 启动网关服务...${NC}"
echo "========================================"
echo "服务端口: 8080"
echo "配置文件: application-dev.yml"
echo "JVM参数: -Xms512m -Xmx1024m"
echo "========================================"

cd "$SERVICE_PATH"

# JVM参数优化
JAVA_OPTS="-Xms512m -Xmx1024m"
JAVA_OPTS="$JAVA_OPTS -XX:+UseG1GC"
JAVA_OPTS="$JAVA_OPTS -XX:G1HeapRegionSize=16m"
JAVA_OPTS="$JAVA_OPTS -XX:+UseStringDeduplication"
JAVA_OPTS="$JAVA_OPTS -Dspring.profiles.active=dev"

# 启动应用
echo -e "${GREEN}🚀 网关服务启动中...${NC}"
echo "访问地址:"
echo "  - 健康检查: http://localhost:8080/health/all"
echo "  - 服务状态: http://localhost:8080/actuator/health"
echo "  - 监控指标: http://localhost:8080/actuator/prometheus"
echo ""
echo -e "${YELLOW}按 Ctrl+C 停止服务${NC}"
echo "========================================"

# 启动JAR
java $JAVA_OPTS -jar "$JAR_PATH"