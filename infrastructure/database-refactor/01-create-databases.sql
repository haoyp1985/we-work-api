-- =================================================================
-- WeWork Platform - 数据库创建脚本
-- 版本: v2.0 (完全重构版)
-- 创建日期: 2025年1月
-- 说明: 创建三个核心数据库
-- =================================================================

-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS `saas_unified_core` 
DEFAULT CHARACTER SET utf8mb4 
DEFAULT COLLATE utf8mb4_unicode_ci
COMMENT '统一核心数据库 - 用户权限管理、系统配置';

CREATE DATABASE IF NOT EXISTS `wework_platform` 
DEFAULT CHARACTER SET utf8mb4 
DEFAULT COLLATE utf8mb4_unicode_ci
COMMENT '企微平台数据库 - 账号管理、消息发送';

CREATE DATABASE IF NOT EXISTS `monitor_analytics` 
DEFAULT CHARACTER SET utf8mb4 
DEFAULT COLLATE utf8mb4_unicode_ci
COMMENT '监控分析数据库 - 监控数据、性能分析';

-- 创建数据库用户（生产环境建议使用不同用户）
CREATE USER IF NOT EXISTS 'wework_app'@'%' IDENTIFIED BY 'WeWork@2025#Platform';

-- 授权
GRANT SELECT, INSERT, UPDATE, DELETE ON saas_unified_core.* TO 'wework_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON wework_platform.* TO 'wework_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON monitor_analytics.* TO 'wework_app'@'%';

-- 刷新权限
FLUSH PRIVILEGES;

-- 显示创建结果
SHOW DATABASES LIKE '%core%';
SHOW DATABASES LIKE '%wework%';
SHOW DATABASES LIKE '%monitor%';