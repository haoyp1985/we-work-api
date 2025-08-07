#!/bin/bash

# =================================================================
# WeWork Platform - 统一服务管理脚本
# =================================================================

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 项目配置
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKEND_PATH="$PROJECT_ROOT/backend-refactor"
SCRIPTS_PATH="$PROJECT_ROOT/scripts"

# 服务配置 (使用简单数组，兼容性更好)
SERVICES="gateway:gateway-service:18080 account:account-service:18081 message:message-service:18082 monitor:monitor-service:18083 user:user-service:18084 task:task-service:18085"

# 获取服务信息的函数
get_service_info() {
    local service_key=$1
    for service_info in $SERVICES; do
        local key=$(echo "$service_info" | cut -d: -f1)
        if [ "$key" = "$service_key" ]; then
            echo "$service_info"
            return 0
        fi
    done
    return 1
}

# 获取所有服务键的函数
get_all_service_keys() {
    for service_info in $SERVICES; do
        echo "$service_info" | cut -d: -f1
    done
}

# 显示帮助信息
show_help() {
    echo -e "${BLUE}WeWork Platform 服务管理脚本${NC}"
    echo "========================================"
    echo -e "${CYAN}用法:${NC}"
    echo "  $0 [命令] [服务名称]"
    echo ""
    echo -e "${CYAN}命令:${NC}"
    echo "  build [service]    - 构建服务 (all 或 具体服务名)"
    echo "  start [service]    - 启动服务 (all 或 具体服务名)"
    echo "  stop [service]     - 停止服务 (all 或 具体服务名)"
    echo "  restart [service]  - 重启服务 (all 或 具体服务名)"
    echo "  status            - 检查所有服务状态"
    echo "  logs [service]     - 查看服务日志"
    echo "  health            - 检查服务健康状态"
    echo "  config            - 显示配置信息"
    echo ""
    echo -e "${CYAN}服务名称:${NC}"
    echo "  gateway   - 网关服务 (端口: 18080)"
    echo "  account   - 账号服务 (端口: 18081)"
    echo "  message   - 消息服务 (端口: 18082)"
    echo "  all       - 所有服务"
    echo ""
    echo -e "${CYAN}示例:${NC}"
    echo "  $0 build all       # 构建所有服务"
    echo "  $0 start gateway   # 启动网关服务"
    echo "  $0 status          # 检查服务状态"
    echo "  $0 restart all     # 重启所有服务"
}

# 检查基础设施
check_infrastructure() {
    echo -e "${YELLOW}🔍 检查基础设施状态...${NC}"
    
    local required_containers=("wework-mysql" "wework-redis" "wework-nacos" "wework-rocketmq-nameserver" "wework-rocketmq-broker")
    local missing_containers=()
    
    for container in "${required_containers[@]}"; do
        if ! docker ps | grep -q "$container.*Up"; then
            missing_containers+=("$container")
        fi
    done
    
    if [ ${#missing_containers[@]} -ne 0 ]; then
        echo -e "${RED}❌ 以下基础设施容器未运行:${NC}"
        for container in "${missing_containers[@]}"; do
            echo -e "   ${RED}• $container${NC}"
        done
        echo -e "${YELLOW}请先启动基础设施: ./scripts/start-infrastructure.sh${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ 基础设施检查通过${NC}"
    return 0
}

# 构建服务
build_service() {
    local service=$1
    if [ "$service" = "all" ]; then
        echo -e "${BLUE}🔨 构建所有服务...${NC}"
        for svc in $(get_all_service_keys); do
            build_single_service "$svc"
        done
    else
        build_single_service "$service"
    fi
}

build_single_service() {
    local service=$1
    local service_info
    service_info=$(get_service_info "$service")
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ 未知服务: $service${NC}"
        return 1
    fi
    
    local service_name=$(echo "$service_info" | cut -d: -f2)
    echo -e "${YELLOW}🔨 构建服务: $service_name${NC}"
    
    if [ -f "$SCRIPTS_PATH/build-$service_name.sh" ]; then
        bash "$SCRIPTS_PATH/build-$service_name.sh"
    else
        echo -e "${YELLOW}使用通用构建命令...${NC}"
        cd "$BACKEND_PATH"
        mvn clean package -pl "$service_name" -DskipTests spring-boot:repackage
    fi
}

# 启动服务
start_service() {
    local service=$1
    
    # if ! check_infrastructure; then
    #     return 1
    # fi
    
    if [ "$service" = "all" ]; then
        echo -e "${BLUE}🚀 启动所有服务...${NC}"
        # 按顺序启动: gateway -> account -> message
        start_single_service "gateway"
        sleep 5
        start_single_service "account"  
        sleep 5
        start_single_service "message"
    else
        start_single_service "$service"
    fi
}

start_single_service() {
    local service=$1
    local service_info
    service_info=$(get_service_info "$service")
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ 未知服务: $service${NC}"
        return 1
    fi
    
    local service_name=$(echo "$service_info" | cut -d: -f2)
    local port=$(echo "$service_info" | cut -d: -f3)
    
    # 检查服务是否已经在运行
    if check_service_running "$service_name" "$port"; then
        echo -e "${YELLOW}⚠️  服务 $service_name 已在运行 (端口: $port)${NC}"
        return 0
    fi
    
    echo -e "${YELLOW}🚀 启动服务: $service_name (端口: $port)${NC}"
    
    # 检查JAR文件是否存在
    local jar_path="$BACKEND_PATH/$service_name/target/$service_name.jar"
    if [ ! -f "$jar_path" ]; then
        echo -e "${RED}❌ JAR文件不存在: $jar_path${NC}"
        echo -e "${YELLOW}请先构建服务: $0 build $service${NC}"
        return 1
    fi
    
    # 启动服务 (后台运行)
    cd "$BACKEND_PATH/$service_name"
    nohup java -Xms512m -Xmx1024m \
        -Dspring.profiles.active=dev \
        -Dspring.cloud.nacos.config.server-addr=localhost:28848 \
        -Dspring.cloud.nacos.discovery.server-addr=localhost:28848 \
        -Dspring.cloud.nacos.config.username=nacos \
        -Dspring.cloud.nacos.config.password=nacos \
        -Dspring.cloud.nacos.discovery.username=nacos \
        -Dspring.cloud.nacos.discovery.password=nacos \
        -jar "target/$service_name.jar" > "logs/$service_name.log" 2>&1 &
    
    local pid=$!
    echo "$pid" > "logs/$service_name.pid"
    
    echo -e "${GREEN}✅ 服务 $service_name 启动成功 (PID: $pid)${NC}"
    echo -e "${CYAN}   服务地址: http://localhost:$port${NC}"
    echo -e "${CYAN}   日志文件: $BACKEND_PATH/$service_name/logs/$service_name.log${NC}"
}

# 停止服务
stop_service() {
    local service=$1
    
    if [ "$service" = "all" ]; then
        echo -e "${BLUE}🛑 停止所有服务...${NC}"
        for svc in $(get_all_service_keys); do
            stop_single_service "$svc"
        done
    else
        stop_single_service "$service"
    fi
}

stop_single_service() {
    local service=$1
    local service_info
    service_info=$(get_service_info "$service")
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ 未知服务: $service${NC}"
        return 1
    fi
    
    local service_name=$(echo "$service_info" | cut -d: -f2)
    local pid_file="$BACKEND_PATH/$service_name/logs/$service_name.pid"
    
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid"
            echo -e "${GREEN}✅ 服务 $service_name 已停止 (PID: $pid)${NC}"
        else
            echo -e "${YELLOW}⚠️  服务 $service_name 进程不存在${NC}"
        fi
        rm -f "$pid_file"
    else
        echo -e "${YELLOW}⚠️  未找到服务 $service_name 的PID文件${NC}"
        # 尝试通过进程名停止
        pkill -f "$service_name.jar" || true
    fi
}

# 检查服务是否运行
check_service_running() {
    local service_name=$1
    local port=$2
    
    # 检查是否有进程在监听指定端口（LISTEN状态）
    if lsof -i:"$port" | grep -q "LISTEN"; then
        return 0
    fi
    
    # 备用检查：通过netstat检查监听端口
    if command -v netstat >/dev/null 2>&1; then
        if netstat -an 2>/dev/null | grep -q ":$port.*LISTEN"; then
            return 0
        fi
    fi
    
    return 1
}

# 检查服务状态
check_status() {
    echo -e "${BLUE}📊 检查服务状态...${NC}"
    echo "========================================"
    
    for service in $(get_all_service_keys); do
        local service_info
        service_info=$(get_service_info "$service")
        local service_name=$(echo "$service_info" | cut -d: -f2)
        local port=$(echo "$service_info" | cut -d: -f3)
        
        if check_service_running "$service_name" "$port"; then
            echo -e "${GREEN}✅ $service_name${NC} - 运行中 (端口: $port)"
        else
            echo -e "${RED}❌ $service_name${NC} - 未运行 (端口: $port)"
        fi
    done
}

# 检查服务健康状态
check_health() {
    echo -e "${BLUE}🏥 检查服务健康状态...${NC}"
    echo "========================================"
    
    for service in $(get_all_service_keys); do
        local service_info
        service_info=$(get_service_info "$service")
        local service_name=$(echo "$service_info" | cut -d: -f2)
        local port=$(echo "$service_info" | cut -d: -f3)
        
        if check_service_running "$service_name" "$port"; then
            local health_url="http://localhost:$port/api/health"
            if curl -s "$health_url" >/dev/null 2>&1; then
                echo -e "${GREEN}✅ $service_name${NC} - 健康检查通过"
            else
                echo -e "${YELLOW}⚠️  $service_name${NC} - 健康检查失败"
            fi
        else
            echo -e "${RED}❌ $service_name${NC} - 服务未运行"
        fi
    done
}

# 查看日志
view_logs() {
    local service=$1
    
    if [ -z "$service" ]; then
        echo -e "${RED}❌ 请指定服务名称${NC}"
        return 1
    fi
    
    local service_info
    service_info=$(get_service_info "$service")
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ 未知服务: $service${NC}"
        return 1
    fi
    
    local service_name=$(echo "$service_info" | cut -d: -f2)
    local log_file="$BACKEND_PATH/$service_name/logs/$service_name.log"
    
    if [ -f "$log_file" ]; then
        echo -e "${CYAN}📝 查看服务日志: $service_name${NC}"
        tail -f "$log_file"
    else
        echo -e "${RED}❌ 日志文件不存在: $log_file${NC}"
    fi
}

# 显示配置信息
show_config() {
    echo -e "${BLUE}⚙️  配置信息${NC}"
    echo "========================================"
    echo -e "${CYAN}项目根目录:${NC} $PROJECT_ROOT"
    echo -e "${CYAN}后端路径:${NC} $BACKEND_PATH"
    echo -e "${CYAN}脚本路径:${NC} $SCRIPTS_PATH"
    echo ""
    echo -e "${CYAN}服务列表:${NC}"
    for service in $(get_all_service_keys); do
        local service_info
        service_info=$(get_service_info "$service")
        local service_name=$(echo "$service_info" | cut -d: -f2)
        local port=$(echo "$service_info" | cut -d: -f3)
        echo -e "  ${GREEN}$service${NC} ($service_name) - 端口: $port"
    done
    echo ""
    echo -e "${CYAN}Nacos配置:${NC}"
    echo "  服务地址: http://localhost:28848/nacos"
    echo "  用户名: nacos"
    echo "  密码: nacos"
    echo "  配置组: wework-platform"
}

# 创建必要目录
create_directories() {
    for service in $(get_all_service_keys); do
        local service_info
        service_info=$(get_service_info "$service")
        local service_name=$(echo "$service_info" | cut -d: -f2)
        local log_dir="$BACKEND_PATH/$service_name/logs"
        
        if [ ! -d "$log_dir" ]; then
            mkdir -p "$log_dir"
        fi
    done
}

# 主函数
main() {
    # 创建必要目录
    create_directories
    
    case "${1:-help}" in
        "build")
            build_service "${2:-all}"
            ;;
        "start")
            start_service "${2:-all}"
            ;;
        "stop")
            stop_service "${2:-all}"
            ;;
        "restart")
            stop_service "${2:-all}"
            sleep 2
            start_service "${2:-all}"
            ;;
        "status")
            check_status
            ;;
        "health")
            check_health
            ;;
        "logs")
            view_logs "$2"
            ;;
        "config")
            show_config
            ;;
        "help"|*)
            show_help
            ;;
    esac
}

# 运行主函数
main "$@"