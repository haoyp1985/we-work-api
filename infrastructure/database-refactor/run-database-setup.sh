#!/bin/bash

# =================================================================
# WeWork Platform - 数据库重构执行脚本
# 版本: v2.0
# 说明: 执行数据库完全重构
# =================================================================

# 严格模式
set -euo pipefail

# 全局变量
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
readonly LOG_FILE="/tmp/database-setup.log"

# 颜色输出
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# 数据库配置
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-3306}"
DB_ROOT_USER="${DB_ROOT_USER:-root}"
DB_ROOT_PASSWORD="${DB_ROOT_PASSWORD:-}"

# 日志函数
log_info() {
    echo -e "${GREEN}[INFO]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"
}

# 检查依赖
check_dependencies() {
    log_info "检查依赖..."
    
    if ! command -v mysql &> /dev/null; then
        log_error "MySQL客户端未安装"
        exit 1
    fi
    
    if ! command -v mysqladmin &> /dev/null; then
        log_error "mysqladmin命令未找到"
        exit 1
    fi
    
    log_info "✅ 依赖检查通过"
}

# 检查数据库连接
check_database_connection() {
    log_info "检查数据库连接..."
    
    if [[ -z "$DB_ROOT_PASSWORD" ]]; then
        read -s -p "请输入MySQL root密码: " DB_ROOT_PASSWORD
        echo
    fi
    
    if ! mysqladmin -h"$DB_HOST" -P"$DB_PORT" -u"$DB_ROOT_USER" -p"$DB_ROOT_PASSWORD" ping &>/dev/null; then
        log_error "无法连接到MySQL数据库"
        log_error "主机: $DB_HOST:$DB_PORT, 用户: $DB_ROOT_USER"
        exit 1
    fi
    
    log_info "✅ 数据库连接成功"
}

# 执行SQL文件
execute_sql_file() {
    local sql_file=$1
    local description=$2
    
    log_info "执行: $description"
    log_info "文件: $sql_file"
    
    if [[ ! -f "$sql_file" ]]; then
        log_error "SQL文件不存在: $sql_file"
        return 1
    fi
    
    if mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_ROOT_USER" -p"$DB_ROOT_PASSWORD" < "$sql_file" >> "$LOG_FILE" 2>&1; then
        log_info "✅ $description 执行成功"
    else
        log_error "❌ $description 执行失败"
        log_error "请查看日志文件: $LOG_FILE"
        return 1
    fi
}

# 备份现有数据库
backup_existing_databases() {
    log_info "🗄️ 备份现有数据库..."
    
    local backup_dir="/tmp/wework-db-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    # 检查数据库是否存在并备份
    local databases=("saas_unified_core" "wework_platform" "monitor_analytics")
    
    for db in "${databases[@]}"; do
        if mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_ROOT_USER" -p"$DB_ROOT_PASSWORD" -e "USE $db;" 2>/dev/null; then
            log_info "备份数据库: $db"
            mysqldump -h"$DB_HOST" -P"$DB_PORT" -u"$DB_ROOT_USER" -p"$DB_ROOT_PASSWORD" \
                     --single-transaction --routines --triggers \
                     "$db" > "$backup_dir/$db.sql" 2>/dev/null || true
        else
            log_info "数据库 $db 不存在，跳过备份"
        fi
    done
    
    log_info "✅ 备份完成，备份目录: $backup_dir"
}

# 删除现有数据库
drop_existing_databases() {
    log_info "🗑️ 删除现有数据库..."
    
    local databases=("saas_unified_core" "wework_platform" "monitor_analytics")
    
    for db in "${databases[@]}"; do
        if mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_ROOT_USER" -p"$DB_ROOT_PASSWORD" -e "USE $db;" 2>/dev/null; then
            log_warn "删除数据库: $db"
            mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_ROOT_USER" -p"$DB_ROOT_PASSWORD" \
                  -e "DROP DATABASE IF EXISTS $db;" 2>/dev/null || true
        fi
    done
    
    log_info "✅ 现有数据库已删除"
}

# 创建数据库和表结构
create_database_structure() {
    log_info "🏗️ 创建数据库结构..."
    
    # 1. 创建数据库
    execute_sql_file "$SCRIPT_DIR/01-create-databases.sql" "创建数据库"
    
    # 2. 创建核心数据库表
    execute_sql_file "$SCRIPT_DIR/02-saas-unified-core-tables.sql" "创建核心数据库表结构"
    
    # 3. 创建企微平台表
    execute_sql_file "$SCRIPT_DIR/03-wework-platform-tables.sql" "创建企微平台表结构"
    
    # 4. 创建监控分析表
    execute_sql_file "$SCRIPT_DIR/04-monitor-analytics-tables.sql" "创建监控分析表结构"
    
    # 5. 插入初始数据
    execute_sql_file "$SCRIPT_DIR/05-initial-data.sql" "插入初始化数据"
    
    log_info "✅ 数据库结构创建完成"
}

# 验证数据库结构
verify_database_structure() {
    log_info "🔍 验证数据库结构..."
    
    # 检查数据库是否存在
    local databases=("saas_unified_core" "wework_platform" "monitor_analytics")
    for db in "${databases[@]}"; do
        if mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_ROOT_USER" -p"$DB_ROOT_PASSWORD" -e "USE $db;" 2>/dev/null; then
            log_info "✅ 数据库 $db 创建成功"
        else
            log_error "❌ 数据库 $db 创建失败"
            return 1
        fi
    done
    
    # 检查核心表是否存在
    local core_tables=("tenants" "users" "roles" "permissions")
    for table in "${core_tables[@]}"; do
        if mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_ROOT_USER" -p"$DB_ROOT_PASSWORD" \
                 -e "SELECT 1 FROM saas_unified_core.$table LIMIT 1;" 2>/dev/null; then
            log_info "✅ 核心表 $table 创建成功"
        else
            log_error "❌ 核心表 $table 创建失败"
            return 1
        fi
    done
    
    # 检查企微平台表
    local wework_tables=("wework_accounts" "message_templates" "message_tasks")
    for table in "${wework_tables[@]}"; do
        if mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_ROOT_USER" -p"$DB_ROOT_PASSWORD" \
                 -e "SELECT 1 FROM wework_platform.$table LIMIT 1;" 2>/dev/null; then
            log_info "✅ 企微表 $table 创建成功"
        else
            log_error "❌ 企微表 $table 创建失败"
            return 1
        fi
    done
    
    # 检查初始数据
    local user_count
    user_count=$(mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_ROOT_USER" -p"$DB_ROOT_PASSWORD" \
                       -sN -e "SELECT COUNT(*) FROM saas_unified_core.users;" 2>/dev/null || echo "0")
    
    if [[ "$user_count" -gt 0 ]]; then
        log_info "✅ 初始数据插入成功，用户数量: $user_count"
    else
        log_error "❌ 初始数据插入失败"
        return 1
    fi
    
    log_info "✅ 数据库结构验证通过"
}

# 显示连接信息
show_connection_info() {
    log_info "📋 数据库连接信息:"
    echo
    echo -e "${BLUE}数据库连接信息:${NC}"
    echo "  主机: $DB_HOST:$DB_PORT"
    echo "  应用用户: wework_app"
    echo "  应用密码: WeWork@2025#Platform"
    echo
    echo -e "${BLUE}默认登录账号:${NC}"
    echo "  管理员: admin / WeWork@2025"
    echo "  演示用户: demo / WeWork@2025"
    echo
    echo -e "${BLUE}数据库列表:${NC}"
    echo "  - saas_unified_core: 用户权限管理"
    echo "  - wework_platform: 企微账号消息管理"
    echo "  - monitor_analytics: 监控分析数据"
    echo
}

# 显示帮助
show_help() {
    cat << EOF
使用方法: $(basename "$0") [选项]

选项:
  -h, --help          显示帮助信息
  --host HOST         数据库主机 (默认: localhost)
  --port PORT         数据库端口 (默认: 3306)
  --user USER         数据库用户 (默认: root)
  --password PASS     数据库密码
  --skip-backup       跳过备份步骤
  --force             强制执行，不询问确认

环境变量:
  DB_HOST             数据库主机
  DB_PORT             数据库端口
  DB_ROOT_USER        数据库用户
  DB_ROOT_PASSWORD    数据库密码

示例:
  $(basename "$0")                                # 使用默认配置
  $(basename "$0") --host 192.168.1.100          # 指定数据库主机
  $(basename "$0") --password mypassword --force  # 指定密码并强制执行

EOF
}

# 主函数
main() {
    log_info "🚀 开始数据库重构..."
    log_info "日志文件: $LOG_FILE"
    
    # 检查依赖
    check_dependencies
    
    # 检查数据库连接
    check_database_connection
    
    # 询问确认
    if [[ "${FORCE:-false}" != "true" ]]; then
        echo
        echo -e "${YELLOW}⚠️ 警告: 此操作将完全重构数据库，所有现有数据将被删除！${NC}"
        echo -e "${YELLOW}建议在执行前备份重要数据。${NC}"
        echo
        read -p "确定要继续吗? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "操作已取消"
            exit 0
        fi
    fi
    
    # 备份现有数据库
    if [[ "${SKIP_BACKUP:-false}" != "true" ]]; then
        backup_existing_databases
    fi
    
    # 删除现有数据库
    drop_existing_databases
    
    # 创建数据库结构
    create_database_structure
    
    # 验证数据库结构
    verify_database_structure
    
    # 显示连接信息
    show_connection_info
    
    log_info "🎉 数据库重构完成！"
}

# 参数解析
SKIP_BACKUP=false
FORCE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        --host)
            DB_HOST="$2"
            shift 2
            ;;
        --port)
            DB_PORT="$2"
            shift 2
            ;;
        --user)
            DB_ROOT_USER="$2"
            shift 2
            ;;
        --password)
            DB_ROOT_PASSWORD="$2"
            shift 2
            ;;
        --skip-backup)
            SKIP_BACKUP=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        *)
            log_error "未知参数: $1"
            show_help
            exit 1
            ;;
    esac
done

# 执行主函数
main "$@"