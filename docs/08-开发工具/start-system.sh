#!/bin/bash

# =================================================================
# AI智能体管理系统 - 系统启动脚本
# 版本: 1.0.0
# 作者: WeWork Platform Team
# 用途: 自动启动AI智能体管理系统的所有组件
# =================================================================

# 严格模式
set -euo pipefail

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 全局变量
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
LOG_DIR="$PROJECT_ROOT/logs"
PID_DIR="/tmp/wework-ai-agent"

# 服务配置
SERVICES=(
    "gateway-service:18080:backend-refactor/gateway-service"
    "ai-agent-service:18086:backend-refactor/ai-agent-service"
)

FRONTEND_PORT=3000
FRONTEND_DIR="$PROJECT_ROOT/frontend/admin-web"

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*"
}

log_step() {
    echo -e "${PURPLE}[STEP]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*"
}

# 错误处理
cleanup() {
    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        log_error "系统启动失败，正在清理..."
        stop_all_services
    fi
    exit $exit_code
}

trap cleanup EXIT

# 检查依赖
check_dependencies() {
    log_step "检查系统依赖..."
    
    local deps=("java" "mvn" "node" "npm" "mysql" "redis-server")
    local missing_deps=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done
    
    if [[ ${#missing_deps[@]} -ne 0 ]]; then
        log_error "缺少以下依赖: ${missing_deps[*]}"
        log_error "请安装缺少的依赖后重试"
        exit 1
    fi
    
    log_success "所有依赖检查通过"
}

# 检查Java版本
check_java_version() {
    log_info "检查Java版本..."
    
    local java_version
    java_version=$(java -version 2>&1 | head -1 | cut -d'"' -f2 | cut -d'.' -f1)
    
    if [[ $java_version -lt 17 ]]; then
        log_error "需要Java 17或更高版本，当前版本: $java_version"
        exit 1
    fi
    
    log_success "Java版本检查通过: $java_version"
}

# 检查Node.js版本
check_node_version() {
    log_info "检查Node.js版本..."
    
    local node_version
    node_version=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
    
    if [[ $node_version -lt 16 ]]; then
        log_error "需要Node.js 16或更高版本，当前版本: $node_version"
        exit 1
    fi
    
    log_success "Node.js版本检查通过: v$node_version"
}

# 创建必要目录
create_directories() {
    log_step "创建必要目录..."
    
    local dirs=("$LOG_DIR" "$PID_DIR")
    
    for dir in "${dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            mkdir -p "$dir"
            log_info "创建目录: $dir"
        fi
    done
    
    log_success "目录创建完成"
}

# 检查端口是否被占用
check_port() {
    local port=$1
    local service_name=$2
    
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        log_warning "端口 $port 已被占用 ($service_name)"
        local pid
        pid=$(lsof -ti:$port)
        log_warning "占用进程 PID: $pid"
        
        read -p "是否终止占用进程并继续? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            kill -9 "$pid" 2>/dev/null || true
            log_info "已终止进程 $pid"
        else
            log_error "端口被占用，无法启动服务"
            exit 1
        fi
    fi
}

# 检查数据库连接
check_database() {
    log_step "检查数据库连接..."
    
    local db_host="${DB_HOST:-localhost}"
    local db_port="${DB_PORT:-3306}"
    local db_name="${DB_NAME:-ai_agent_platform}"
    local db_user="${DB_USERNAME:-ai_agent_user}"
    local db_password="${DB_PASSWORD:-ai_agent_password}"
    
    # 检查MySQL服务是否运行
    if ! pgrep mysqld >/dev/null; then
        log_warning "MySQL服务未运行，尝试启动..."
        if command -v systemctl &> /dev/null; then
            sudo systemctl start mysql || true
        elif command -v service &> /dev/null; then
            sudo service mysql start || true
        fi
        
        # 等待MySQL启动
        sleep 5
    fi
    
    # 测试数据库连接
    if mysql -h"$db_host" -P"$db_port" -u"$db_user" -p"$db_password" -e "USE $db_name;" 2>/dev/null; then
        log_success "数据库连接正常"
    else
        log_error "数据库连接失败"
        log_error "请检查数据库配置: $db_host:$db_port/$db_name"
        exit 1
    fi
}

# 检查Redis连接
check_redis() {
    log_step "检查Redis连接..."
    
    local redis_host="${REDIS_HOST:-localhost}"
    local redis_port="${REDIS_PORT:-6379}"
    
    # 检查Redis服务是否运行
    if ! pgrep redis-server >/dev/null; then
        log_warning "Redis服务未运行，尝试启动..."
        if command -v systemctl &> /dev/null; then
            sudo systemctl start redis || true
        elif command -v service &> /dev/null; then
            sudo service redis start || true
        else
            redis-server --daemonize yes || true
        fi
        
        # 等待Redis启动
        sleep 3
    fi
    
    # 测试Redis连接
    if redis-cli -h "$redis_host" -p "$redis_port" ping >/dev/null 2>&1; then
        log_success "Redis连接正常"
    else
        log_error "Redis连接失败"
        log_error "请检查Redis配置: $redis_host:$redis_port"
        exit 1
    fi
}

# 构建后端服务
build_backend_service() {
    local service_info=$1
    IFS=':' read -r service_name port service_path <<< "$service_info"
    
    log_step "构建服务: $service_name"
    
    local full_path="$PROJECT_ROOT/$service_path"
    
    if [[ ! -d "$full_path" ]]; then
        log_error "服务目录不存在: $full_path"
        return 1
    fi
    
    cd "$full_path"
    
    # Maven构建
    log_info "执行Maven构建..."
    if mvn clean package -DskipTests -q; then
        log_success "✅ $service_name 构建成功"
    else
        log_error "❌ $service_name 构建失败"
        return 1
    fi
}

# 启动后端服务
start_backend_service() {
    local service_info=$1
    IFS=':' read -r service_name port service_path <<< "$service_info"
    
    log_step "启动服务: $service_name (端口: $port)"
    
    # 检查端口
    check_port "$port" "$service_name"
    
    local full_path="$PROJECT_ROOT/$service_path"
    local jar_file="$full_path/target/$service_name.jar"
    
    if [[ ! -f "$jar_file" ]]; then
        log_error "JAR文件不存在: $jar_file"
        return 1
    fi
    
    # 设置JVM参数
    local java_opts="-Xms512m -Xmx1024m -XX:+UseG1GC"
    java_opts="$java_opts -Dspring.profiles.active=${PROFILE:-dev}"
    java_opts="$java_opts -Dserver.port=$port"
    
    # 启动服务
    local log_file="$LOG_DIR/$service_name.log"
    local pid_file="$PID_DIR/$service_name.pid"
    
    cd "$full_path"
    nohup java $java_opts -jar "$jar_file" > "$log_file" 2>&1 &
    local pid=$!
    echo $pid > "$pid_file"
    
    log_info "$service_name 启动中，PID: $pid，日志: $log_file"
    
    # 等待服务启动
    local max_attempts=60
    local attempt=0
    
    while [[ $attempt -lt $max_attempts ]]; do
        if curl -sf "http://localhost:$port/actuator/health" >/dev/null 2>&1; then
            log_success "✅ $service_name 启动成功"
            return 0
        fi
        
        # 检查进程是否还在运行
        if ! kill -0 "$pid" 2>/dev/null; then
            log_error "❌ $service_name 进程异常退出"
            log_error "查看日志: tail -f $log_file"
            return 1
        fi
        
        ((attempt++))
        sleep 2
        echo -n "."
    done
    
    echo
    log_error "❌ $service_name 启动超时"
    return 1
}

# 安装前端依赖
install_frontend_deps() {
    log_step "安装前端依赖..."
    
    cd "$FRONTEND_DIR"
    
    if [[ ! -f "package.json" ]]; then
        log_error "前端目录中没有找到 package.json"
        exit 1
    fi
    
    # 检查是否需要安装依赖
    if [[ ! -d "node_modules" ]] || [[ "package.json" -nt "node_modules" ]]; then
        log_info "安装npm依赖..."
        if npm install; then
            log_success "前端依赖安装成功"
        else
            log_error "前端依赖安装失败"
            exit 1
        fi
    else
        log_info "前端依赖已是最新"
    fi
}

# 启动前端服务
start_frontend_service() {
    log_step "启动前端开发服务器..."
    
    # 检查端口
    check_port "$FRONTEND_PORT" "前端开发服务器"
    
    cd "$FRONTEND_DIR"
    
    local log_file="$LOG_DIR/frontend.log"
    local pid_file="$PID_DIR/frontend.pid"
    
    # 启动前端开发服务器
    nohup npm run dev > "$log_file" 2>&1 &
    local pid=$!
    echo $pid > "$pid_file"
    
    log_info "前端服务启动中，PID: $pid，日志: $log_file"
    
    # 等待前端服务启动
    local max_attempts=30
    local attempt=0
    
    while [[ $attempt -lt $max_attempts ]]; do
        if curl -sf "http://localhost:$FRONTEND_PORT" >/dev/null 2>&1; then
            log_success "✅ 前端服务启动成功"
            return 0
        fi
        
        # 检查进程是否还在运行
        if ! kill -0 "$pid" 2>/dev/null; then
            log_error "❌ 前端服务进程异常退出"
            log_error "查看日志: tail -f $log_file"
            return 1
        fi
        
        ((attempt++))
        sleep 2
        echo -n "."
    done
    
    echo
    log_error "❌ 前端服务启动超时"
    return 1
}

# 停止所有服务
stop_all_services() {
    log_step "停止所有服务..."
    
    # 停止后端服务
    for service_info in "${SERVICES[@]}"; do
        IFS=':' read -r service_name port service_path <<< "$service_info"
        local pid_file="$PID_DIR/$service_name.pid"
        
        if [[ -f "$pid_file" ]]; then
            local pid
            pid=$(cat "$pid_file")
            if kill -0 "$pid" 2>/dev/null; then
                log_info "停止服务: $service_name (PID: $pid)"
                kill "$pid"
                
                # 等待进程结束
                local max_attempts=10
                local attempt=0
                while [[ $attempt -lt $max_attempts ]]; do
                    if ! kill -0 "$pid" 2>/dev/null; then
                        break
                    fi
                    ((attempt++))
                    sleep 1
                done
                
                # 强制杀死
                if kill -0 "$pid" 2>/dev/null; then
                    kill -9 "$pid"
                fi
            fi
            rm -f "$pid_file"
        fi
    done
    
    # 停止前端服务
    local frontend_pid_file="$PID_DIR/frontend.pid"
    if [[ -f "$frontend_pid_file" ]]; then
        local pid
        pid=$(cat "$frontend_pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            log_info "停止前端服务 (PID: $pid)"
            kill "$pid"
        fi
        rm -f "$frontend_pid_file"
    fi
    
    log_success "所有服务已停止"
}

# 显示系统状态
show_system_status() {
    echo
    log_info "🎉 系统启动完成！"
    echo "=========================================="
    echo "📊 服务状态："
    
    for service_info in "${SERVICES[@]}"; do
        IFS=':' read -r service_name port service_path <<< "$service_info"
        local pid_file="$PID_DIR/$service_name.pid"
        
        if [[ -f "$pid_file" ]]; then
            local pid
            pid=$(cat "$pid_file")
            if kill -0 "$pid" 2>/dev/null; then
                echo "  ✅ $service_name: http://localhost:$port (PID: $pid)"
            else
                echo "  ❌ $service_name: 进程异常"
            fi
        else
            echo "  ❌ $service_name: 未启动"
        fi
    done
    
    # 前端服务状态
    local frontend_pid_file="$PID_DIR/frontend.pid"
    if [[ -f "$frontend_pid_file" ]]; then
        local pid
        pid=$(cat "$frontend_pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            echo "  ✅ 前端服务: http://localhost:$FRONTEND_PORT (PID: $pid)"
        else
            echo "  ❌ 前端服务: 进程异常"
        fi
    else
        echo "  ❌ 前端服务: 未启动"
    fi
    
    echo "=========================================="
    echo "🌐 访问地址："
    echo "  前端管理界面: http://localhost:$FRONTEND_PORT"
    echo "  API网关: http://localhost:18080"
    echo "  Swagger文档: http://localhost:18086/swagger-ui.html"
    echo "=========================================="
    echo "📁 日志目录: $LOG_DIR"
    echo "📝 PID目录: $PID_DIR"
    echo "=========================================="
    echo
    echo "💡 常用命令："
    echo "  查看日志: tail -f $LOG_DIR/<service>.log"
    echo "  停止系统: $0 stop"
    echo "  系统状态: $0 status"
    echo
}

# 检查系统状态
check_system_status() {
    echo "📊 系统状态检查"
    echo "=========================================="
    
    local all_running=true
    
    # 检查后端服务
    for service_info in "${SERVICES[@]}"; do
        IFS=':' read -r service_name port service_path <<< "$service_info"
        local pid_file="$PID_DIR/$service_name.pid"
        
        if [[ -f "$pid_file" ]]; then
            local pid
            pid=$(cat "$pid_file")
            if kill -0 "$pid" 2>/dev/null; then
                if curl -sf "http://localhost:$port/actuator/health" >/dev/null 2>&1; then
                    echo "  ✅ $service_name: 运行正常 (PID: $pid)"
                else
                    echo "  ⚠️ $service_name: 进程运行但健康检查失败 (PID: $pid)"
                    all_running=false
                fi
            else
                echo "  ❌ $service_name: 进程不存在"
                all_running=false
            fi
        else
            echo "  ❌ $service_name: 未启动"
            all_running=false
        fi
    done
    
    # 检查前端服务
    local frontend_pid_file="$PID_DIR/frontend.pid"
    if [[ -f "$frontend_pid_file" ]]; then
        local pid
        pid=$(cat "$frontend_pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            if curl -sf "http://localhost:$FRONTEND_PORT" >/dev/null 2>&1; then
                echo "  ✅ 前端服务: 运行正常 (PID: $pid)"
            else
                echo "  ⚠️ 前端服务: 进程运行但访问失败 (PID: $pid)"
                all_running=false
            fi
        else
            echo "  ❌ 前端服务: 进程不存在"
            all_running=false
        fi
    else
        echo "  ❌ 前端服务: 未启动"
        all_running=false
    fi
    
    echo "=========================================="
    
    if $all_running; then
        echo "🎉 所有服务运行正常"
        return 0
    else
        echo "⚠️ 部分服务存在问题"
        return 1
    fi
}

# 主函数
main() {
    local command="${1:-start}"
    
    case "$command" in
        start)
            echo "🚀 启动AI智能体管理系统"
            echo "启动时间: $(date)"
            echo "==============================================="
            
            # 检查依赖和环境
            check_dependencies
            check_java_version
            check_node_version
            create_directories
            
            # 检查基础设施
            check_database
            check_redis
            
            # 构建并启动后端服务
            for service_info in "${SERVICES[@]}"; do
                build_backend_service "$service_info"
                start_backend_service "$service_info"
            done
            
            # 启动前端服务
            install_frontend_deps
            start_frontend_service
            
            # 显示系统状态
            show_system_status
            ;;
        stop)
            stop_all_services
            ;;
        restart)
            stop_all_services
            sleep 3
            main start
            ;;
        status)
            check_system_status
            ;;
        *)
            echo "用法: $0 {start|stop|restart|status}"
            echo "  start   - 启动系统"
            echo "  stop    - 停止系统" 
            echo "  restart - 重启系统"
            echo "  status  - 检查状态"
            exit 1
            ;;
    esac
}

# 脚本入口
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi