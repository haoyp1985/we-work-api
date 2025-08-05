#!/bin/bash

# =================================================================
# AI智能体管理系统 - API接口测试脚本
# 版本: 1.0.0
# 作者: WeWork Platform Team
# 用途: 自动化测试AI智能体管理系统的API接口
# =================================================================

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置变量
API_BASE_URL="http://localhost:18080"
AI_AGENT_DIRECT_URL="http://localhost:18086"  # 直连AI智能体服务
MYSQL_PORT=23306
REDIS_PORT=26379
NACOS_PORT=28848
TIMEOUT=30
TENANT_ID="tenant-001"
USER_ID="user-001"

# 测试结果统计
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $(date '+%H:%M:%S') $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $(date '+%H:%M:%S') $*"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $(date '+%H:%M:%S') $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $(date '+%H:%M:%S') $*"
}

# 测试函数
test_api() {
    local method="$1"
    local endpoint="$2"
    local data="$3"
    local expected_status="$4"
    local test_name="$5"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    log_info "测试: $test_name"
    log_info "请求: $method $endpoint"
    
    if [ -n "$data" ]; then
        response=$(curl -s -w "HTTPSTATUS:%{http_code}" \
                       -X "$method" \
                       -H "Content-Type: application/json" \
                       -H "X-Tenant-Id: $TENANT_ID" \
                       -H "X-User-Id: $USER_ID" \
                       --max-time $TIMEOUT \
                       -d "$data" \
                       "$API_BASE_URL$endpoint")
    else
        response=$(curl -s -w "HTTPSTATUS:%{http_code}" \
                       -X "$method" \
                       -H "Content-Type: application/json" \
                       -H "X-Tenant-Id: $TENANT_ID" \
                       -H "X-User-Id: $USER_ID" \
                       --max-time $TIMEOUT \
                       "$API_BASE_URL$endpoint")
    fi
    
    http_code=$(echo "$response" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')
    response_body=$(echo "$response" | sed -e 's/HTTPSTATUS:.*//g')
    
    if [ "$http_code" = "$expected_status" ]; then
        log_success "✅ $test_name - HTTP $http_code"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        return 0
    else
        log_error "❌ $test_name - 期望: HTTP $expected_status, 实际: HTTP $http_code"
        log_error "响应内容: $response_body"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        return 1
    fi
}

# 基础设施连接测试
test_infrastructure() {
    log_info "🔧 测试基础设施连接..."
    
    # 测试MySQL连接
    log_info "测试MySQL连接 (端口: $MYSQL_PORT)..."
    if command -v mysql >/dev/null 2>&1; then
        if mysql -h127.0.0.1 -P$MYSQL_PORT -uwework -pwework123456 -e "SELECT 1;" >/dev/null 2>&1; then
            log_success "✅ MySQL连接成功"
            ((PASSED_TESTS++))
        else
            log_error "❌ MySQL连接失败"
            ((FAILED_TESTS++))
        fi
    else
        log_warning "⚠️ MySQL客户端未安装，跳过连接测试"
    fi
    ((TOTAL_TESTS++))
    
    # 测试Redis连接
    log_info "测试Redis连接 (端口: $REDIS_PORT)..."
    if command -v redis-cli >/dev/null 2>&1; then
        if redis-cli -p $REDIS_PORT ping >/dev/null 2>&1; then
            log_success "✅ Redis连接成功"
            ((PASSED_TESTS++))
        else
            log_error "❌ Redis连接失败"
            ((FAILED_TESTS++))
        fi
    else
        log_warning "⚠️ Redis客户端未安装，跳过连接测试"
    fi
    ((TOTAL_TESTS++))
    
    # 测试Nacos连接
    log_info "测试Nacos连接 (端口: $NACOS_PORT)..."
    if curl -s --max-time 5 "http://localhost:$NACOS_PORT/nacos/actuator/health" >/dev/null 2>&1; then
        log_success "✅ Nacos连接成功"
        ((PASSED_TESTS++))
    else
        log_error "❌ Nacos连接失败"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
}

# 服务健康检查
check_service_health() {
    log_info "🔍 检查应用服务健康状态..."
    
    # 检查网关服务
    log_info "检查网关服务 ($API_BASE_URL)"
    if curl -s --max-time 10 "$API_BASE_URL/actuator/health" > /dev/null; then
        log_success "✅ 网关服务正常"
    else
        log_error "❌ 网关服务不可用"
        exit 1
    fi
    
    # 检查AI智能体服务直连
    log_info "检查AI智能体服务 ($AI_AGENT_DIRECT_URL)"
    if curl -s --max-time 10 "$AI_AGENT_DIRECT_URL/actuator/health" > /dev/null; then
        log_success "✅ AI智能体服务正常"
    else
        log_error "❌ AI智能体服务不可用"
        exit 1
    fi
}

# 智能体管理API测试
test_agent_apis() {
    log_info "🤖 开始测试智能体管理API..."
    
    # 1. 获取智能体列表
    test_api "GET" "/api/v1/agents" "" "200" "获取智能体列表"
    
    # 2. 创建智能体
    agent_data='{
        "name": "测试智能体",
        "description": "这是一个用于测试的智能体",
        "type": "CHAT_ASSISTANT",
        "config": {
            "maxTokens": 4096,
            "temperature": 0.7
        }
    }'
    test_api "POST" "/api/v1/agents" "$agent_data" "201" "创建智能体"
    
    # 3. 获取智能体详情 (使用示例ID)
    test_api "GET" "/api/v1/agents/agent-001" "" "200" "获取智能体详情"
    
    # 4. 更新智能体
    update_data='{
        "name": "更新后的智能体",
        "description": "这是一个更新后的智能体"
    }'
    test_api "PUT" "/api/v1/agents/agent-001" "$update_data" "200" "更新智能体"
    
    # 5. 获取智能体统计
    test_api "GET" "/api/v1/agents/statistics" "" "200" "获取智能体统计"
}

# 平台配置API测试
test_platform_apis() {
    log_info "🔧 开始测试平台配置API..."
    
    # 1. 获取平台配置列表
    test_api "GET" "/api/v1/platforms" "" "200" "获取平台配置列表"
    
    # 2. 创建平台配置
    platform_data='{
        "name": "测试平台配置",
        "platformType": "COZE",
        "config": {
            "apiKey": "test-api-key",
            "baseUrl": "https://api.test.com",
            "timeout": 60000
        }
    }'
    test_api "POST" "/api/v1/platforms" "$platform_data" "201" "创建平台配置"
    
    # 3. 获取平台配置详情
    test_api "GET" "/api/v1/platforms/platform-001" "" "200" "获取平台配置详情"
    
    # 4. 更新平台配置
    update_platform_data='{
        "name": "更新后的平台配置",
        "enabled": true
    }'
    test_api "PUT" "/api/v1/platforms/platform-001" "$update_platform_data" "200" "更新平台配置"
    
    # 5. 测试平台连接
    test_api "POST" "/api/v1/platforms/platform-001/test" "" "200" "测试平台连接"
}

# 模型配置API测试
test_model_apis() {
    log_info "🧠 开始测试模型配置API..."
    
    # 1. 获取模型配置列表
    test_api "GET" "/api/v1/models" "" "200" "获取模型配置列表"
    
    # 2. 创建模型配置
    model_data='{
        "name": "测试模型配置",
        "platformConfigId": "platform-001",
        "modelName": "gpt-3.5-turbo",
        "modelType": "CHAT",
        "config": {
            "maxTokens": 4096,
            "temperature": 0.7,
            "topP": 0.9
        }
    }'
    test_api "POST" "/api/v1/models" "$model_data" "201" "创建模型配置"
    
    # 3. 获取模型配置详情
    test_api "GET" "/api/v1/models/model-001" "" "200" "获取模型配置详情"
    
    # 4. 更新模型配置
    update_model_data='{
        "name": "更新后的模型配置",
        "config": {
            "maxTokens": 8192,
            "temperature": 0.8
        }
    }'
    test_api "PUT" "/api/v1/models/model-001" "$update_model_data" "200" "更新模型配置"
}

# 对话管理API测试
test_conversation_apis() {
    log_info "💬 开始测试对话管理API..."
    
    # 1. 获取对话列表
    test_api "GET" "/api/v1/conversations" "" "200" "获取对话列表"
    
    # 2. 创建对话
    conversation_data='{
        "agentId": "agent-001",
        "title": "测试对话"
    }'
    test_api "POST" "/api/v1/conversations" "$conversation_data" "201" "创建对话"
    
    # 3. 发送消息
    message_data='{
        "content": "你好，这是一条测试消息",
        "type": "TEXT"
    }'
    test_api "POST" "/api/v1/conversations/conv-001/messages" "$message_data" "201" "发送消息"
    
    # 4. 获取消息历史
    test_api "GET" "/api/v1/conversations/conv-001/messages" "" "200" "获取消息历史"
    
    # 5. 获取对话详情
    test_api "GET" "/api/v1/conversations/conv-001" "" "200" "获取对话详情"
}

# 调用记录API测试
test_call_record_apis() {
    log_info "📊 开始测试调用记录API..."
    
    # 1. 获取调用记录列表
    test_api "GET" "/api/v1/calls" "" "200" "获取调用记录列表"
    
    # 2. 获取调用统计
    test_api "GET" "/api/v1/calls/statistics" "" "200" "获取调用统计"
    
    # 3. 获取调用详情
    test_api "GET" "/api/v1/calls/call-001" "" "200" "获取调用详情"
    
    # 4. 获取平台调用统计
    test_api "GET" "/api/v1/calls/statistics/platforms" "" "200" "获取平台调用统计"
    
    # 5. 获取成本统计
    test_api "GET" "/api/v1/calls/statistics/costs" "" "200" "获取成本统计"
}

# 错误处理测试
test_error_handling() {
    log_info "⚠️ 开始测试错误处理..."
    
    # 1. 测试404错误
    test_api "GET" "/api/v1/agents/non-existent-id" "" "404" "测试404错误"
    
    # 2. 测试无效参数
    invalid_data='{"invalid": "data"}'
    test_api "POST" "/api/v1/agents" "$invalid_data" "400" "测试无效参数"
    
    # 3. 测试不支持的方法
    test_api "PATCH" "/api/v1/agents" "" "405" "测试不支持的方法"
}

# 显示测试结果
show_test_results() {
    echo
    log_info "📊 测试结果统计"
    echo "=================================="
    echo "总测试数: $TOTAL_TESTS"
    echo "通过数: $PASSED_TESTS"
    echo "失败数: $FAILED_TESTS"
    echo "通过率: $(echo "scale=2; $PASSED_TESTS * 100 / $TOTAL_TESTS" | bc)%"
    echo "=================================="
    
    if [ $FAILED_TESTS -eq 0 ]; then
        log_success "🎉 所有测试通过！"
        exit 0
    else
        log_error "❌ 有 $FAILED_TESTS 个测试失败"
        exit 1
    fi
}

# 主函数
main() {
    echo "🚀 AI智能体管理系统 - API接口测试"
    echo "测试开始时间: $(date)"
    echo "目标服务: $API_BASE_URL"
    echo "==============================================="
    
    # 测试基础设施连接
    test_infrastructure
    echo
    
    # 检查应用服务健康状态
    check_service_health
    echo
    
    # 执行各模块测试
    test_agent_apis
    test_platform_apis
    test_model_apis
    test_conversation_apis
    test_call_record_apis
    test_error_handling
    
    # 显示测试结果
    show_test_results
}

# 检查依赖
check_dependencies() {
    command -v curl >/dev/null 2>&1 || { 
        log_error "curl 未安装，请先安装 curl"
        exit 1
    }
    
    command -v bc >/dev/null 2>&1 || { 
        log_error "bc 未安装，请先安装 bc"
        exit 1
    }
}

# 脚本入口
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    check_dependencies
    main "$@"
fi