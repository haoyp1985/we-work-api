#!/bin/bash

# PostgreSQL数据初始化脚本

set -e

echo "🗄️  初始化PostgreSQL数据库..."

# 检查PostgreSQL容器是否运行
if ! docker ps | grep -q wework-postgresql; then
    echo "❌ PostgreSQL容器未运行，请先启动基础设施"
    exit 1
fi

echo "✅ PostgreSQL容器正在运行"

# 等待PostgreSQL完全启动
echo "⏳ 等待PostgreSQL服务就绪..."
sleep 10

# 执行数据库初始化脚本
echo "📊 执行数据库初始化脚本..."
docker exec wework-postgresql psql -U wework -d wework_platform -f /docker-entrypoint-initdb.d/01-init-databases.sql 2>/dev/null || {
    echo "⚠️  数据库可能已经初始化过"
}

# 执行SaaS统一核心数据库表结构
echo "🏗️  创建SaaS统一核心数据库表结构..."
docker exec wework-postgresql psql -U wework -d saas_unified_core -f /docker-entrypoint-initdb.d/02-saas-unified-core-tables.sql 2>/dev/null || {
    echo "⚠️  表结构可能已经创建过"
}

# 验证初始化结果
echo "🔍 验证初始化结果..."
echo "📋 数据库列表："
docker exec wework-postgresql psql -U wework -d wework_platform -c "\l"

echo "📊 SaaS统一核心数据库表数量："
docker exec wework-postgresql psql -U wework -d saas_unified_core -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';"

echo "✅ PostgreSQL数据初始化完成"
