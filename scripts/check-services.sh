#!/bin/bash

# 企业微信管理平台服务健康检查脚本

set -e

echo "🔍 检查企业微信管理平台服务状态..."

# 进入Docker配置目录
cd "$(dirname "$0")/../infrastructure/docker"

# 服务健康检查函数
check_service() {
    local service_name=$1
    local url=$2
    local expected_code=${3:-200}
    
    echo -n "检查 $service_name... "
    
    if curl -s -o /dev/null -w "%{http_code}" "$url" | grep -q "$expected_code"; then
        echo "✅ 正常"
        return 0
    else
        echo "❌ 异常"
        return 1
    fi
}

# 检查数据库连接
check_database() {
    echo -n "检查 MySQL... "
    if docker-compose exec -T mysql mysql -uwework -pwework123456 -e "SELECT 1" > /dev/null 2>&1; then
        echo "✅ 正常"
        return 0
    else
        echo "❌ 异常"
        return 1
    fi
}

check_redis() {
    echo -n "检查 Redis... "
    if docker-compose exec -T redis redis-cli ping | grep -q "PONG"; then
        echo "✅ 正常"
        return 0
    else
        echo "❌ 异常"
        return 1
    fi
}

echo ""
echo "📊 容器状态："
docker-compose ps

echo ""
echo "🔍 服务健康检查："

# 数据库检查
check_database
check_redis

# Web服务检查
check_service "RabbitMQ" "http://localhost:15672" "200"
check_service "InfluxDB" "http://localhost:8086/health" "200"
check_service "MinIO" "http://localhost:9000/minio/health/live" "200"
check_service "Nacos" "http://localhost:8848/nacos" "200"
check_service "Prometheus" "http://localhost:9090/-/healthy" "200"
check_service "Grafana" "http://localhost:3000/api/health" "200"
check_service "Elasticsearch" "http://localhost:9200/_cluster/health" "200"
check_service "Kibana" "http://localhost:5601/api/status" "200"
check_service "Jaeger" "http://localhost:16686/" "200"

echo ""
echo "📈 系统资源使用情况："
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"

echo ""
echo "💾 数据卷使用情况："
docker system df

echo ""
echo "✅ 健康检查完成"