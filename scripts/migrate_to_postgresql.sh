#!/bin/bash

# PostgreSQL迁移脚本
set -e

# 配置变量
MYSQL_HOST="127.0.0.1"
MYSQL_PORT="23306"
MYSQL_USER="root"
MYSQL_PASSWORD="wework123456"
PG_HOST="localhost"
PG_PORT="5432"
PG_USER="postgres"
PG_PASSWORD="postgres"

# 数据库列表
DATABASES=(
    "wework_platform"
    "mission-center"
    "celina-wecom"
    "celina-behavior"
    "dtx-sport"
    "dtx-diet-prod"
    "digital-medical"
    "celina-data-center"
    "celina-health"
    "jianhaihug"
    "knowledge_test"
    "health-weight"
    "check_library"
    "celina-paas-test"
    "celina-paas-test-2"
)

log_info() {
    echo -e "\033[0;32m[INFO]\033[0m $1"
}

log_error() {
    echo -e "\033[0;31m[ERROR]\033[0m $1"
}

# 检查依赖工具
check_dependencies() {
    log_info "检查迁移工具..."
    
    if ! command -v pgloader &> /dev/null; then
        log_error "pgloader未安装，请运行: brew install pgloader"
        exit 1
    fi
    
    log_info "所有依赖工具已就绪"
}

# 创建PostgreSQL数据库
create_pg_databases() {
    log_info "创建PostgreSQL数据库..."
    
    for db in "${DATABASES[@]}"; do
        pg_name=$(echo $db | sed 's/-/_/g')
        log_info "创建数据库: $pg_name"
        
        PGPASSWORD=$PG_PASSWORD psql -h $PG_HOST -p $PG_PORT -U $PG_USER -d postgres -c "CREATE DATABASE $pg_name;" 2>/dev/null || log_info "数据库 $pg_name 可能已存在"
    done
}

# 生成pgloader配置文件
generate_pgloader_config() {
    log_info "生成pgloader配置文件..."
    
    mkdir -p scripts/pgloader_configs
    
    for db in "${DATABASES[@]}"; do
        pg_name=$(echo $db | sed 's/-/_/g')
        
        cat > "scripts/pgloader_configs/${db}.load" << EOF
LOAD DATABASE
    FROM mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@${MYSQL_HOST}:${MYSQL_PORT}/${db}
    INTO postgresql://${PG_USER}:${PG_PASSWORD}@${PG_HOST}:${PG_PORT}/${pg_name}

SET MySQL PARAMETERS
    net_read_timeout = '600',
    net_write_timeout = '600'

SET PostgreSQL PARAMETERS
    maintenance_work_mem to '128MB',
    work_mem to '12MB'

CAST
    type enum with extra using quote_ident,
    type json to jsonb using inline,
    type text to text,
    type datetime to timestamptz using zero-dates-to-null,
    type blob to bytea using hex-encode

INCLUDING ALL TABLES
EXCLUDING TABLE NAMES MATCHING 'mysql', 'information_schema', 'performance_schema'
RESET SEQUENCES
SET WORK_MEM TO '128MB'
SET MAINTENANCE_WORK_MEM TO '512 MB'
EOF
    done
}

# 执行迁移
migrate_database() {
    local db=$1
    local pg_name=$(echo $db | sed 's/-/_/g')
    
    log_info "开始迁移数据库: $db -> $pg_name"
    
    pgloader scripts/pgloader_configs/${db}.load
    
    if [ $? -eq 0 ]; then
        log_info "✅ 数据库 $db 迁移成功"
    else
        log_error "❌ 数据库 $db 迁移失败"
        return 1
    fi
}

# 主函数
main() {
    log_info "开始PostgreSQL迁移流程..."
    
    check_dependencies
    create_pg_databases
    generate_pgloader_config
    
    # 逐个迁移数据库
    for db in "${DATABASES[@]}"; do
        migrate_database $db
    done
    
    log_info "🎉 PostgreSQL迁移完成！"
}

main "$@" 