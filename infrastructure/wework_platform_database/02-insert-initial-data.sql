-- 插入初始数据
USE `wework_platform`;

-- 插入默认租户
INSERT INTO `tenants` (`id`, `tenant_name`, `tenant_code`, `max_accounts`, `max_daily_messages`, `status`) VALUES
('default-tenant-id-001', '默认租户', 'default', 100, 100000, 'active'),
('demo-tenant-id-002', '演示租户', 'demo', 10, 10000, 'active');

-- 插入默认管理员用户 (密码: admin123，使用BCrypt加密)
INSERT INTO `users` (`id`, `tenant_id`, `username`, `password`, `email`, `real_name`, `role`, `status`) VALUES
('admin-user-id-001', 'default-tenant-id-001', 'admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iKXISiUBUtIaUZhK9NVM3JvvY/ga', 'admin@wework.com', '系统管理员', 'admin', 'active'),
('demo-user-id-002', 'demo-tenant-id-002', 'demo', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iKXISiUBUtIaUZhK9NVM3JvvY/ga', 'demo@wework.com', '演示用户', 'operator', 'active');

-- 插入默认系统配置
INSERT INTO `system_configs` (`id`, `config_key`, `config_value`, `config_type`, `description`, `is_public`) VALUES
('config-001', 'system.name', '企业微信管理平台', 'string', '系统名称', TRUE),
('config-002', 'system.version', '1.0.0', 'string', '系统版本', TRUE),
('config-003', 'wework.api.base_url', 'http://192.168.3.122:23456', 'string', '企微API基础地址', FALSE),
('config-004', 'wework.callback.base_url', 'http://localhost:8080/callback', 'string', '回调基础地址', FALSE),
('config-005', 'message.batch.max_size', '100', 'number', '批量消息最大数量', FALSE),
('config-006', 'message.retry.max_times', '3', 'number', '消息重试最大次数', FALSE),
('config-007', 'account.heartbeat.interval', '30', 'number', '账号心跳间隔(秒)', FALSE),
('config-008', 'monitor.alert.enabled', 'true', 'boolean', '是否启用监控告警', FALSE),
('config-009', 'tenant.default.max_accounts', '10', 'number', '租户默认最大账号数', FALSE),
('config-010', 'tenant.default.max_daily_messages', '10000', 'number', '租户默认日最大消息数', FALSE);

-- 插入默认消息模板
INSERT INTO `message_templates` (`id`, `tenant_id`, `template_name`, `template_type`, `template_content`, `variables`) VALUES
('template-001', 'default-tenant-id-001', '欢迎消息', 'welcome', 
 '{"text": "您好 {{name}}，欢迎使用企业微信管理平台！"}', 
 '{"name": {"type": "string", "description": "用户姓名", "required": true}}'),
 
('template-002', 'default-tenant-id-001', '系统通知', 'notification', 
 '{"text": "【系统通知】{{title}}\\n\\n{{content}}\\n\\n时间：{{datetime}}"}', 
 '{"title": {"type": "string", "description": "通知标题", "required": true}, "content": {"type": "string", "description": "通知内容", "required": true}, "datetime": {"type": "string", "description": "通知时间", "required": false}}'),

('template-003', 'default-tenant-id-001', '账号异常告警', 'alert', 
 '{"text": "⚠️ 账号异常告警\\n\\n账号：{{account_name}}\\n状态：{{status}}\\n异常原因：{{reason}}\\n时间：{{datetime}}"}', 
 '{"account_name": {"type": "string", "description": "账号名称", "required": true}, "status": {"type": "string", "description": "账号状态", "required": true}, "reason": {"type": "string", "description": "异常原因", "required": true}, "datetime": {"type": "string", "description": "异常时间", "required": true}}');

-- 初始化Nacos配置数据库
USE `nacos_config`;

-- 给wework用户授权访问nacos_config数据库
GRANT ALL PRIVILEGES ON `nacos_config`.* TO 'wework'@'%';
FLUSH PRIVILEGES;

-- -- Nacos配置表结构 (简化版本，Nacos启动时会自动创建完整表结构)
-- CREATE TABLE IF NOT EXISTS `config_info` (
--   `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
--   `data_id` VARCHAR(255) NOT NULL COMMENT 'data_id',
--   `group_id` VARCHAR(255) DEFAULT NULL,
--   `content` LONGTEXT NOT NULL COMMENT 'content',
--   `md5` VARCHAR(32) DEFAULT NULL COMMENT 'md5',
--   `gmt_create` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
--   `gmt_modified` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
--   `src_user` TEXT COMMENT 'source user',
--   `src_ip` VARCHAR(50) DEFAULT NULL COMMENT 'source ip',
--   `app_name` VARCHAR(128) DEFAULT NULL,
--   `tenant_id` VARCHAR(128) DEFAULT '' COMMENT '租户字段',
--   `c_desc` VARCHAR(256) DEFAULT NULL,
--   `c_use` VARCHAR(64) DEFAULT NULL,
--   `effect` VARCHAR(64) DEFAULT NULL,
--   `type` VARCHAR(64) DEFAULT NULL,
--   `c_schema` TEXT,
--   `encrypted_data_key` TEXT NOT NULL COMMENT '秘钥',
--   PRIMARY KEY (`id`),
--   UNIQUE KEY `uk_configinfo_datagrouptenant` (`data_id`,`group_id`,`tenant_id`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_info';