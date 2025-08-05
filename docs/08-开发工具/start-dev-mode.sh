#!/bin/bash

# =================================================================
# AI智能体管理系统 - 开发模式启动脚本
# 版本: 1.0.0
# 作者: WeWork Platform Team
# 用途: 快速启动开发测试环境（Docker基础设施 + 本地Java服务）
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
DOCKER_DIR="$PROJECT_ROOT/infrastructure-refactor/docker"
BACKEND_DIR="$PROJECT_ROOT/backend-refactor"
FRONTEND_DIR="$PROJECT_ROOT/frontend/admin-web"

# 服务端口配置
GATEWAY_PORT=18080
AI_AGENT_PORT=18086
FRONTEND_PORT=3000

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

log_step() {
    echo -e "${PURPLE}[STEP]${NC} $(date '+%H:%M:%S') $*"
}

# 显示帮助信息
show_help() {
    cat << EOF
🚀 AI智能体管理系统 - 开发模式启动

用法: $(basename "$0") [命令] [选项]

命令:
  start         启动完整开发环境
  stop          停止所有服务
  restart       重启所有服务
  status        检查服务状态
  infrastructure 只启动基础设施(Docker)
  backend       只启动后端服务
  frontend      只启动前端服务
  logs          查看服务日志

选项:
  -h, --help    显示帮助信息
  -v, --verbose 详细输出
  -q, --quiet   静默模式

示例:
  $(basename "$0") start              # 启动完整环境
  $(basename "$0") infrastructure     # 只启动基础设施
  $(basename "$0") backend            # 只启动后端服务
  $(basename "$0") logs gateway       # 查看网关日志

EOF
}

# 检查Docker环境
check_docker() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker未安装，请先安装Docker"
        return 1
    fi
    
    if ! docker info &> /dev/null; then
        log_error "Docker未运行，请先启动Docker"
        return 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose未安装，请先安装Docker Compose"
        return 1
    fi
    
    log_success "Docker环境检查通过"
}

# 检查Java环境
check_java() {
    if ! command -v java &> /dev/null; then
        log_error "Java未安装，请先安装Java 17+"
        return 1
    fi
    
    if ! command -v mvn &> /dev/null; then
        log_error "Maven未安装，请先安装Maven"
        return 1
    fi
    
    # 检查Java版本
    java_version=$(java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}' | awk -F '.' '{print $1}')
    if [[ $java_version -lt 17 ]]; then
        log_error "Java版本过低，需要Java 17+，当前版本: $java_version"
        return 1
    fi
    
    log_success "Java环境检查通过 (Java $java_version)"
}

# 检查Node.js环境
check_nodejs() {
    if ! command -v node &> /dev/null; then
        log_error "Node.js未安装，请先安装Node.js 16+"
        return 1
    fi
    
    if ! command -v npm &> /dev/null; then
        log_error "npm未安装，请先安装npm"
        return 1
    fi
    
    # 检查Node.js版本
    node_version=$(node -v | sed 's/v//' | awk -F '.' '{print $1}')
    if [[ $node_version -lt 16 ]]; then
        log_error "Node.js版本过低，需要Node.js 16+，当前版本: v$node_version"
        return 1
    fi
    
    log_success "Node.js环境检查通过 ($(node -v))"
}

# 启动基础设施
start_infrastructure() {
    log_step "启动基础设施(Docker)..."
    
    cd "$DOCKER_DIR"
    
    # 创建必要的目录
    mkdir -p logs/{mysql,redis,nacos}
    
    # 启动基础设施服务
    log_info "启动MySQL、Redis、Nacos..."
    docker-compose up -d mysql redis nacos
    
    # 等待服务启动
    log_info "等待基础设施服务启动..."
    
    # 等待MySQL
    log_info "等待MySQL启动..."
    for i in {1..30}; do
        if docker-compose exec -T mysql mysqladmin ping -h localhost --silent; then
            log_success "MySQL启动成功"
            break
        fi
        sleep 2
        if [[ $i -eq 30 ]]; then
            log_error "MySQL启动超时"
            return 1
        fi
    done
    
    # 等待Redis
    log_info "等待Redis启动..."
    for i in {1..15}; do
        if docker-compose exec -T redis redis-cli ping | grep -q PONG; then
            log_success "Redis启动成功"
            break
        fi
        sleep 2
        if [[ $i -eq 15 ]]; then
            log_error "Redis启动超时"
            return 1
        fi
    done
    
    # 等待Nacos
    log_info "等待Nacos启动..."
    for i in {1..30}; do
        if curl -sf http://localhost:8848/nacos/v1/console/health/readiness > /dev/null; then
            log_success "Nacos启动成功"
            break
        fi
        sleep 2
        if [[ $i -eq 30 ]]; then
            log_error "Nacos启动超时"
            return 1
        fi
    done
    
    log_success "基础设施启动完成"
}

# 初始化数据库
init_database() {
    log_step "初始化数据库..."
    
    # 检查AI智能体数据库是否存在
    if docker-compose exec -T mysql mysql -uroot -pwework_root_2024 -e "USE ai_agent_platform;" 2>/dev/null; then
        log_info "AI智能体数据库已存在，跳过初始化"
        return 0
    fi
    
    log_info "创建AI智能体数据库..."
    
    # 复制SQL文件到Docker容器
    docker cp "$BACKEND_DIR/ai-agent-service/sql/init-ai-agent-platform.sql" wework-mysql:/tmp/
    
    # 执行SQL脚本
    if docker-compose exec -T mysql mysql -uroot -pwework_root_2024 < /tmp/init-ai-agent-platform.sql; then
        log_success "数据库初始化完成"
    else
        log_error "数据库初始化失败"
        return 1
    fi
}

# 构建后端服务
build_backend() {
    log_step "构建后端服务..."
    
    cd "$BACKEND_DIR"
    
    # 构建父项目
    log_info "构建项目依赖..."
    mvn clean install -DskipTests -q
    
    # 构建网关服务
    log_info "构建网关服务..."
    cd gateway-service
    mvn package -DskipTests -q
    cd ..
    
    # 构建AI智能体服务
    log_info "构建AI智能体服务..."
    cd ai-agent-service
    mvn package -DskipTests -q
    cd ..
    
    log_success "后端服务构建完成"
}

# 启动后端服务
start_backend() {
    log_step "启动后端服务..."
    
    # 启动网关服务
    log_info "启动网关服务..."
    cd "$BACKEND_DIR/gateway-service"
    nohup java -jar target/gateway-service.jar \
        --server.port=$GATEWAY_PORT \
        --spring.profiles.active=dev \
        > "/tmp/gateway-service.log" 2>&1 &
    
    echo $! > "/tmp/gateway-service.pid"
    
    # 启动AI智能体服务
    log_info "启动AI智能体服务..."
    cd "$BACKEND_DIR/ai-agent-service"
    nohup java -jar target/ai-agent-service.jar \
        --server.port=$AI_AGENT_PORT \
        --spring.profiles.active=dev \
        > "/tmp/ai-agent-service.log" 2>&1 &
    
    echo $! > "/tmp/ai-agent-service.pid"
    
    # 等待服务启动
    log_info "等待后端服务启动..."
    
    # 等待网关服务
    for i in {1..30}; do
        if curl -sf http://localhost:$GATEWAY_PORT/actuator/health > /dev/null; then
            log_success "网关服务启动成功 (端口: $GATEWAY_PORT)"
            break
        fi
        sleep 2
        if [[ $i -eq 30 ]]; then
            log_error "网关服务启动超时"
            return 1
        fi
    done
    
    # 等待AI智能体服务
    for i in {1..30}; do
        if curl -sf http://localhost:$AI_AGENT_PORT/actuator/health > /dev/null; then
            log_success "AI智能体服务启动成功 (端口: $AI_AGENT_PORT)"
            break
        fi
        sleep 2
        if [[ $i -eq 30 ]]; then
            log_error "AI智能体服务启动超时"
            return 1
        fi
    done
    
    log_success "后端服务启动完成"
}

# 安装前端依赖
install_frontend_deps() {
    log_info "检查前端依赖..."
    
    cd "$FRONTEND_DIR"
    
    if [[ ! -d "node_modules" ]]; then
        log_info "安装前端依赖..."
        npm install
        log_success "前端依赖安装完成"
    else
        log_info "前端依赖已存在"
    fi
}

# 启动前端服务
start_frontend() {
    log_step "启动前端服务..."
    
    cd "$FRONTEND_DIR"
    
    # 检查前端依赖
    install_frontend_deps
    
    # 启动前端开发服务器
    log_info "启动前端开发服务器..."
    nohup npm run dev > "/tmp/frontend.log" 2>&1 &
    echo $! > "/tmp/frontend.pid"
    
    # 等待前端服务启动
    log_info "等待前端服务启动..."
    for i in {1..20}; do
        if curl -sf http://localhost:$FRONTEND_PORT > /dev/null; then
            log_success "前端服务启动成功 (端口: $FRONTEND_PORT)"
            break
        fi
        sleep 3
        if [[ $i -eq 20 ]]; then
            log_error "前端服务启动超时"
            return 1
        fi
    done
    
    log_success "前端服务启动完成"
}

# 停止所有服务
stop_services() {
    log_step "停止所有服务..."
    
    # 停止前端服务
    if [[ -f "/tmp/frontend.pid" ]]; then
        local pid=$(cat "/tmp/frontend.pid")
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid"
            log_info "前端服务已停止"
        fi
        rm -f "/tmp/frontend.pid"
    fi
    
    # 停止后端服务
    for service in "gateway-service" "ai-agent-service"; do
        if [[ -f "/tmp/$service.pid" ]]; then
            local pid=$(cat "/tmp/$service.pid")
            if kill -0 "$pid" 2>/dev/null; then
                kill "$pid"
                log_info "$service已停止"
            fi
            rm -f "/tmp/$service.pid"
        fi
    done
    
    # 停止Docker服务
    cd "$DOCKER_DIR"
    docker-compose down
    
    log_success "所有服务已停止"
}

# 检查服务状态
check_status() {
    log_step "检查服务状态..."
    
    # 检查Docker基础设施
    echo
    log_info "基础设施状态:"
    cd "$DOCKER_DIR"
    
    if docker-compose ps mysql | grep -q "Up"; then
        log_success "MySQL: 运行中"
    else
        log_error "MySQL: 未运行"
    fi
    
    if docker-compose ps redis | grep -q "Up"; then
        log_success "Redis: 运行中"
    else
        log_error "Redis: 未运行"
    fi
    
    if docker-compose ps nacos | grep -q "Up"; then
        log_success "Nacos: 运行中"
    else
        log_error "Nacos: 未运行"
    fi
    
    # 检查后端服务
    echo
    log_info "后端服务状态:"
    
    if curl -sf http://localhost:$GATEWAY_PORT/actuator/health > /dev/null; then
        log_success "网关服务: 运行中 (http://localhost:$GATEWAY_PORT)"
    else
        log_error "网关服务: 未运行"
    fi
    
    if curl -sf http://localhost:$AI_AGENT_PORT/actuator/health > /dev/null; then
        log_success "AI智能体服务: 运行中 (http://localhost:$AI_AGENT_PORT)"
    else
        log_error "AI智能体服务: 未运行"
    fi
    
    # 检查前端服务
    echo
    log_info "前端服务状态:"
    
    if curl -sf http://localhost:$FRONTEND_PORT > /dev/null; then
        log_success "前端服务: 运行中 (http://localhost:$FRONTEND_PORT)"
    else
        log_error "前端服务: 未运行"
    fi
    
    echo
}

# 查看服务日志
show_logs() {
    local service=${1:-"all"}
    
    case $service in
        gateway)
            tail -f /tmp/gateway-service.log
            ;;
        ai-agent|agent)
            tail -f /tmp/ai-agent-service.log
            ;;
        frontend|web)
            tail -f /tmp/frontend.log
            ;;
        mysql)
            cd "$DOCKER_DIR"
            docker-compose logs -f mysql
            ;;
        redis)
            cd "$DOCKER_DIR"
            docker-compose logs -f redis
            ;;
        nacos)
            cd "$DOCKER_DIR"
            docker-compose logs -f nacos
            ;;
        all|*)
            log_info "可用的日志: gateway, ai-agent, frontend, mysql, redis, nacos"
            log_info "用法: $(basename "$0") logs [service-name]"
            ;;
    esac
}

# 完整启动流程
start_all() {
    log_step "🚀 启动AI智能体管理系统 - 开发模式"
    echo
    
    # 环境检查
    check_docker || exit 1
    check_java || exit 1
    check_nodejs || exit 1
    
    # 启动基础设施
    start_infrastructure || exit 1
    
    # 初始化数据库
    init_database || exit 1
    
    # 构建和启动后端
    build_backend || exit 1
    start_backend || exit 1
    
    # 启动前端
    start_frontend || exit 1
    
    echo
    log_success "🎉 系统启动完成！"
    echo
    log_info "服务访问地址:"
    log_info "  前端管理后台: http://localhost:$FRONTEND_PORT"
    log_info "  API网关:       http://localhost:$GATEWAY_PORT"
    log_info "  AI智能体服务:  http://localhost:$AI_AGENT_PORT"
    log_info "  Nacos控制台:   http://localhost:8848/nacos (admin/nacos)"
    echo
    log_info "快捷命令:"
    log_info "  查看状态: $(basename "$0") status"
    log_info "  查看日志: $(basename "$0") logs [service]"
    log_info "  停止服务: $(basename "$0") stop"
    echo
}

# 主函数
main() {
    local command=${1:-"start"}
    
    case $command in
        start)
            start_all
            ;;
        stop)
            stop_services
            ;;
        restart)
            stop_services
            sleep 2
            start_all
            ;;
        status)
            check_status
            ;;
        infrastructure|infra)
            check_docker || exit 1
            start_infrastructure
            ;;
        backend)
            check_java || exit 1
            build_backend || exit 1
            start_backend
            ;;
        frontend)
            check_nodejs || exit 1
            start_frontend
            ;;
        logs)
            show_logs ${2:-"all"}
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            log_error "未知命令: $command"
            show_help
            exit 1
            ;;
    esac
}

# 执行主函数
main "$@"