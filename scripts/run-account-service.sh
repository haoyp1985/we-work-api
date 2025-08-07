#!/bin/bash

# 账号管理服务运行脚本

set -e

echo "🚀 启动账号管理服务..."

# 检查基础设施是否启动
echo "📋 检查基础设施状态..."

# 检查Docker容器
if ! docker ps | grep -q "wework-mysql"; then
    echo "❌ MySQL容器未运行，请先启动基础设施"
    echo "   执行: ./scripts/start-infrastructure.sh"
    exit 1
fi

if ! docker ps | grep -q "wework-redis"; then
    echo "❌ Redis容器未运行，请先启动基础设施"
    echo "   执行: ./scripts/start-infrastructure.sh"
    exit 1
fi

if ! docker ps | grep -q "wework-nacos"; then
    echo "❌ Nacos容器未运行，请先启动基础设施"
    echo "   执行: ./scripts/start-infrastructure.sh"
    exit 1
fi

echo "✅ 基础设施检查通过"

# 等待服务完全启动
echo "⏳ 等待基础设施完全启动..."
sleep 5

# 检查服务连接性
echo "🔗 检查服务连接性..."

# 检查MySQL连接
if ! nc -z localhost 3306; then
    echo "❌ MySQL连接失败 (localhost:3306)"
    exit 1
fi

# 检查Redis连接
if ! nc -z localhost 6379; then
    echo "❌ Redis连接失败 (localhost:6379)"
    exit 1
fi

# 检查Nacos连接
if ! nc -z localhost 8848; then
    echo "❌ Nacos连接失败 (localhost:8848)"
    exit 1
fi

echo "✅ 所有服务连接正常"

# 进入账号服务目录
cd "$(dirname "$0")/../backend-refactor/account-service"

# 检查jar文件是否存在
if [ ! -f "target/account-service.jar" ]; then
    echo "❌ 找不到构建产物，请先构建服务"
    echo "   执行: ./scripts/build-account-service.sh"
    exit 1
fi

echo "🎯 启动账号管理服务..."
echo "   服务地址: http://localhost:8081/account"
echo "   API文档: http://localhost:8081/account/swagger-ui.html"
echo "   健康检查: http://localhost:8081/account/api/health"
echo ""
echo "📝 使用 Ctrl+C 停止服务"
echo ""

# 启动服务
export SPRING_PROFILES_ACTIVE=dev
java -jar target/account-service.jar