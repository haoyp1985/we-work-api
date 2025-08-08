#!/bin/bash

# PostgreSQL连接测试脚本

set -e

echo "🔍 测试PostgreSQL连接..."

# 检查PostgreSQL容器是否运行
if ! docker ps | grep -q wework-postgresql; then
    echo "❌ PostgreSQL容器未运行"
    exit 1
fi

echo "✅ PostgreSQL容器正在运行"

# 测试数据库连接
echo "📊 测试数据库连接..."
docker exec wework-postgresql psql -U wework -d wework_platform -c "SELECT version();" 2>/dev/null || {
    echo "❌ 无法连接到PostgreSQL数据库"
    exit 1
}

echo "✅ PostgreSQL连接成功"

# 列出所有数据库
echo "📋 列出所有数据库..."
docker exec wework-postgresql psql -U wework -d wework_platform -c "\l"

# 测试SaaS统一核心数据库
echo "🔍 测试SaaS统一核心数据库..."
docker exec wework-postgresql psql -U wework -d saas_unified_core -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" 2>/dev/null || {
    echo "⚠️  saas_unified_core数据库可能尚未初始化"
}

echo "✅ PostgreSQL测试完成"
