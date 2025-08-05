#!/bin/bash

# =================================================================
# AI智能体管理系统 - 快速验证脚本
# 版本: 1.0.0
# 作者: WeWork Platform Team
# 用途: 快速验证系统配置和组件完整性
# =================================================================

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 全局变量
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
VALIDATION_PASSED=0
VALIDATION_FAILED=0

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[✅ PASS]${NC} $*"
    VALIDATION_PASSED=$((VALIDATION_PASSED + 1))
}

log_warning() {
    echo -e "${YELLOW}[⚠️ WARN]${NC} $*"
}

log_error() {
    echo -e "${RED}[❌ FAIL]${NC} $*"
    VALIDATION_FAILED=$((VALIDATION_FAILED + 1))
}

# 验证项目结构
validate_project_structure() {
    log_info "验证项目结构..."
    
    local required_dirs=(
        "backend-refactor/ai-agent-service"
        "backend-refactor/gateway-service"
        "frontend/admin-web"
        "docs/08-开发工具"
    )
    
    for dir in "${required_dirs[@]}"; do
        if [[ -d "$PROJECT_ROOT/$dir" ]]; then
            log_success "目录存在: $dir"
        else
            log_error "目录缺失: $dir"
        fi
    done
}

# 验证后端配置
validate_backend_config() {
    log_info "验证后端配置..."
    
    # 检查AI智能体服务配置
    local ai_agent_config="$PROJECT_ROOT/backend-refactor/ai-agent-service/src/main/resources/application.yml"
    if [[ -f "$ai_agent_config" ]]; then
        log_success "AI智能体服务配置存在"
        
        # 检查关键配置项
        if grep -q "port.*18086" "$ai_agent_config"; then
            log_success "AI智能体服务端口配置正确 (18086)"
        else
            log_error "AI智能体服务端口配置错误"
        fi
        
        if grep -q "ai_agent_platform" "$ai_agent_config"; then
            log_success "数据库配置存在"
        else
            log_error "数据库配置缺失"
        fi
    else
        log_error "AI智能体服务配置文件缺失"
    fi
    
    # 检查网关服务配置
    local gateway_config="$PROJECT_ROOT/backend-refactor/gateway-service/src/main/resources/application.yml"
    if [[ -f "$gateway_config" ]]; then
        log_success "网关服务配置存在"
        
        # 检查端口配置
        if grep -q "port.*18080" "$gateway_config"; then
            log_success "网关服务端口配置正确 (18080)"
        else
            log_error "网关服务端口配置错误"
        fi
        
        # 检查AI智能体服务路由
        if grep -q "ai-agent-service" "$gateway_config"; then
            log_success "AI智能体服务路由配置存在"
        else
            log_error "AI智能体服务路由配置缺失"
        fi
    else
        log_error "网关服务配置文件缺失"
    fi
}

# 验证前端配置
validate_frontend_config() {
    log_info "验证前端配置..."
    
    local frontend_dir="$PROJECT_ROOT/frontend/admin-web"
    
    # 检查package.json
    if [[ -f "$frontend_dir/package.json" ]]; then
        log_success "前端package.json存在"
    else
        log_error "前端package.json缺失"
    fi
    
    # 检查Vite配置
    local vite_config="$frontend_dir/vite.config.ts"
    if [[ -f "$vite_config" ]]; then
        log_success "Vite配置存在"
        
        # 检查代理配置
        if grep -q "18080" "$vite_config"; then
            log_success "前端代理配置正确 (指向18080)"
        else
            log_error "前端代理配置错误"
        fi
    else
        log_error "Vite配置文件缺失"
    fi
    
    # 检查路由配置
    local routes_config="$frontend_dir/src/router/routes.ts"
    if [[ -f "$routes_config" ]]; then
        log_success "路由配置存在"
        
        # 检查AI智能体相关路由
        if grep -q "agent" "$routes_config"; then
            log_success "AI智能体路由配置存在"
        else
            log_error "AI智能体路由配置缺失"
        fi
    else
        log_error "路由配置文件缺失"
    fi
}

# 验证数据库脚本
validate_database_scripts() {
    log_info "验证数据库脚本..."
    
    local db_script="$PROJECT_ROOT/backend-refactor/ai-agent-service/sql/init-ai-agent-platform.sql"
    if [[ -f "$db_script" ]]; then
        log_success "数据库初始化脚本存在"
        
        # 检查关键表
        local tables=("agents" "platform_configs" "model_configs" "conversations" "messages" "call_records")
        for table in "${tables[@]}"; do
            if grep -q "CREATE TABLE $table" "$db_script"; then
                log_success "表结构存在: $table"
            else
                log_error "表结构缺失: $table"
            fi
        done
    else
        log_error "数据库初始化脚本缺失"
    fi
}

# 验证API接口
validate_api_interfaces() {
    log_info "验证API接口定义..."
    
    local api_file="$PROJECT_ROOT/frontend/admin-web/src/api/agent.ts"
    if [[ -f "$api_file" ]]; then
        log_success "API接口文件存在"
        
        # 检查关键API方法
        local apis=("queryAgents" "createAgent" "getPlatformConfigs" "getModelConfigs" "getConversations" "getCallRecords")
        for api in "${apis[@]}"; do
            if grep -q "$api" "$api_file"; then
                log_success "API方法存在: $api"
            else
                log_error "API方法缺失: $api"
            fi
        done
    else
        log_error "API接口文件缺失"
    fi
}

# 验证类型定义
validate_type_definitions() {
    log_info "验证TypeScript类型定义..."
    
    local types_file="$PROJECT_ROOT/frontend/admin-web/src/types/agent.ts"
    if [[ -f "$types_file" ]]; then
        log_success "类型定义文件存在"
        
        # 检查关键类型
        local types=("Agent" "PlatformConfig" "ModelConfig" "Conversation" "CallRecordDTO")
        for type in "${types[@]}"; do
            if grep -q "interface $type\|type $type" "$types_file"; then
                log_success "类型定义存在: $type"
            else
                log_error "类型定义缺失: $type"
            fi
        done
    else
        log_error "类型定义文件缺失"
    fi
}

# 验证页面组件
validate_page_components() {
    log_info "验证页面组件..."
    
    local pages_dir="$PROJECT_ROOT/frontend/admin-web/src/views/agent"
    if [[ -d "$pages_dir" ]]; then
        log_success "页面目录存在"
        
        # 检查关键页面
        local pages=("form.vue" "chat.vue" "model-config.vue" "monitoring.vue")
        for page in "${pages[@]}"; do
            if [[ -f "$pages_dir/$page" ]]; then
                log_success "页面组件存在: $page"
            else
                log_error "页面组件缺失: $page"
            fi
        done
    else
        log_error "页面目录缺失"
    fi
}

# 验证构建工具
validate_build_tools() {
    log_info "验证构建工具..."
    
    # 检查Maven配置
    local pom_files=(
        "backend-refactor/pom.xml"
        "backend-refactor/ai-agent-service/pom.xml"
        "backend-refactor/gateway-service/pom.xml"
    )
    
    for pom in "${pom_files[@]}"; do
        if [[ -f "$PROJECT_ROOT/$pom" ]]; then
            log_success "Maven配置存在: $pom"
        else
            log_error "Maven配置缺失: $pom"
        fi
    done
    
    # 检查前端构建配置
    local frontend_configs=(
        "frontend/admin-web/tsconfig.json"
        "frontend/admin-web/vite.config.ts"
    )
    
    for config in "${frontend_configs[@]}"; do
        if [[ -f "$PROJECT_ROOT/$config" ]]; then
            log_success "前端配置存在: $config"
        else
            log_error "前端配置缺失: $config"
        fi
    done
}

# 验证文档和脚本
validate_documentation() {
    log_info "验证文档和脚本..."
    
    local docs=(
        "docs/08-开发工具/system-integration-test-plan.md"
        "docs/08-开发工具/test-api-endpoints.sh"
        "docs/08-开发工具/start-system.sh"
    )
    
    for doc in "${docs[@]}"; do
        if [[ -f "$PROJECT_ROOT/$doc" ]]; then
            log_success "文档存在: $doc"
        else
            log_error "文档缺失: $doc"
        fi
    done
    
    # 检查脚本执行权限
    local scripts=(
        "docs/08-开发工具/test-api-endpoints.sh"
        "docs/08-开发工具/start-system.sh"
    )
    
    for script in "${scripts[@]}"; do
        if [[ -x "$PROJECT_ROOT/$script" ]]; then
            log_success "脚本可执行: $script"
        else
            log_error "脚本不可执行: $script"
        fi
    done
}

# 检查系统依赖
check_system_dependencies() {
    log_info "检查系统依赖..."
    
    local deps=("java" "mvn" "node" "npm" "curl" "lsof")
    
    for dep in "${deps[@]}"; do
        if command -v "$dep" &> /dev/null; then
            log_success "依赖存在: $dep"
        else
            log_error "依赖缺失: $dep"
        fi
    done
    
    # 检查Java版本
    if command -v java &> /dev/null; then
        local java_version
        java_version=$(java -version 2>&1 | head -1 | cut -d'"' -f2 | cut -d'.' -f1)
        if [[ $java_version -ge 17 ]]; then
            log_success "Java版本满足要求: $java_version"
        else
            log_error "Java版本过低: $java_version (需要17+)"
        fi
    fi
    
    # 检查Node.js版本
    if command -v node &> /dev/null; then
        local node_version
        node_version=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
        if [[ $node_version -ge 16 ]]; then
            log_success "Node.js版本满足要求: v$node_version"
        else
            log_error "Node.js版本过低: v$node_version (需要16+)"
        fi
    fi
}

# 显示验证结果
show_validation_results() {
    echo
    echo "=========================================="
    echo "📊 验证结果统计"
    echo "=========================================="
    echo "✅ 通过项: $VALIDATION_PASSED"
    echo "❌ 失败项: $VALIDATION_FAILED"
    echo "📊 总计项: $((VALIDATION_PASSED + VALIDATION_FAILED))"
    
    if [[ $VALIDATION_FAILED -eq 0 ]]; then
        echo -e "${GREEN}🎉 所有验证项通过！系统配置完整。${NC}"
        echo
        echo "🚀 下一步操作："
        echo "  1. 启动系统: ./docs/08-开发工具/start-system.sh start"
        echo "  2. 运行测试: ./docs/08-开发工具/test-api-endpoints.sh"
        echo "  3. 访问前端: http://localhost:3000"
        exit 0
    else
        local success_rate=$((VALIDATION_PASSED * 100 / (VALIDATION_PASSED + VALIDATION_FAILED)))
        echo -e "${RED}❌ 有 $VALIDATION_FAILED 个验证项失败（成功率: ${success_rate}%）${NC}"
        echo
        echo "🔧 修复建议："
        echo "  1. 检查上述失败项的具体错误"
        echo "  2. 补全缺失的文件和配置"
        echo "  3. 重新运行验证脚本"
        exit 1
    fi
}

# 主函数
main() {
    echo "🔍 AI智能体管理系统 - 快速验证"
    echo "验证时间: $(date)"
    echo "项目目录: $PROJECT_ROOT"
    echo "=========================================="
    
    # 执行各项验证
    validate_project_structure
    validate_backend_config
    validate_frontend_config
    validate_database_scripts
    validate_api_interfaces
    validate_type_definitions
    validate_page_components
    validate_build_tools
    validate_documentation
    check_system_dependencies
    
    # 显示验证结果
    show_validation_results
}

# 脚本入口
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi