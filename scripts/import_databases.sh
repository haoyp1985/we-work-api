#!/bin/bash

# 数据库导入脚本
# 用于批量导入ex_database中的SQL脚本

MYSQL_HOST="127.0.0.1"
MYSQL_PORT="23306"
MYSQL_USER="root"
MYSQL_PASSWORD="wework123456"
SQL_DIR="infrastructure/ex_database"

echo "🚀 开始导入数据库脚本..."

# 设置MySQL参数
mysql -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD --protocol=TCP -e "
SET GLOBAL sql_mode = 'NO_ENGINE_SUBSTITUTION';
SET GLOBAL log_bin_trust_function_creators = 1;
SET GLOBAL innodb_default_row_format = DYNAMIC;
" 2>/dev/null

# 定义数据库和对应的SQL文件
declare -A databases=(
    ["mission-center"]="mission-center.sql"
    ["celina-wecom"]="celina-wecom.sql"
    ["celina-behavior"]="celina-behavior.sql"
    ["dtx-sport"]="dtx-sport.sql"
    ["dtx-diet-prod"]="dtx-diet-prod.sql"
    ["digital-medical"]="digital-medical.sql"
    ["celina-data-center"]="celina-data-center.sql"
    ["knowledge_test"]="knowledge_test.sql"
    ["check_library"]="check_library.sql"
)

# 执行导入
for db_name in "${!databases[@]}"; do
    sql_file="${databases[$db_name]}"
    echo "📦 导入 $db_name 数据库..."
    
    if mysql -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD --protocol=TCP \
        --init-command="SET sql_mode='NO_ENGINE_SUBSTITUTION';" \
        "$db_name" < "$SQL_DIR/$sql_file" 2>/dev/null; then
        echo "✅ $db_name 导入成功"
        
        # 显示表数量
        table_count=$(mysql -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD --protocol=TCP -s -e "USE \`$db_name\`; SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '$db_name';")
        echo "   📊 表数量: $table_count"
    else
        echo "❌ $db_name 导入失败"
    fi
done

echo ""
echo "🎉 数据库导入完成！"
echo ""
echo "📋 已导入的数据库:"
mysql -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD --protocol=TCP -e "
SELECT SCHEMA_NAME as '数据库名称', 
       COUNT(*) as '表数量'
FROM information_schema.SCHEMATA s
LEFT JOIN information_schema.tables t ON s.SCHEMA_NAME = t.table_schema
WHERE SCHEMA_NAME IN ('mission-center', 'celina-wecom', 'celina-behavior', 'dtx-sport', 'dtx-diet-prod', 'digital-medical', 'celina-data-center', 'knowledge_test', 'check_library')
GROUP BY SCHEMA_NAME
ORDER BY SCHEMA_NAME;
" 2>/dev/null 

