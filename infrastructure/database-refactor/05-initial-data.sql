-- =================================================================
-- WeWork Platform - 初始化数据脚本
-- 版本: v2.0
-- 说明: 插入系统初始化数据
-- =================================================================

-- ===== saas_unified_core 初始数据 =====
USE `saas_unified_core`;

-- 1. 系统权限数据
INSERT INTO `permissions` (`id`, `permission_name`, `permission_code`, `resource_type`, `action_type`, `description`) VALUES
-- 用户管理权限
('perm-001', '查看用户', 'user:read', 'user', 'read', '查看用户信息'),
('perm-002', '创建用户', 'user:create', 'user', 'create', '创建新用户'),
('perm-003', '更新用户', 'user:update', 'user', 'update', '更新用户信息'),
('perm-004', '删除用户', 'user:delete', 'user', 'delete', '删除用户'),

-- 角色管理权限  
('perm-005', '查看角色', 'role:read', 'role', 'read', '查看角色信息'),
('perm-006', '创建角色', 'role:create', 'role', 'create', '创建新角色'),
('perm-007', '更新角色', 'role:update', 'role', 'update', '更新角色信息'),
('perm-008', '删除角色', 'role:delete', 'role', 'delete', '删除角色'),

-- 企微账号权限
('perm-009', '查看账号', 'account:read', 'account', 'read', '查看企微账号'),
('perm-010', '创建账号', 'account:create', 'account', 'create', '创建企微账号'),
('perm-011', '更新账号', 'account:update', 'account', 'update', '更新账号信息'),
('perm-012', '删除账号', 'account:delete', 'account', 'delete', '删除账号'),
('perm-013', '控制账号', 'account:control', 'account', 'control', '控制账号状态'),

-- 消息管理权限
('perm-014', '查看消息', 'message:read', 'message', 'read', '查看消息记录'),
('perm-015', '发送消息', 'message:send', 'message', 'send', '发送消息'),
('perm-016', '管理模板', 'template:manage', 'template', 'manage', '管理消息模板'),

-- 监控权限
('perm-017', '查看监控', 'monitor:read', 'monitor', 'read', '查看监控数据'),
('perm-018', '管理告警', 'alert:manage', 'alert', 'manage', '管理系统告警'),

-- 系统管理权限
('perm-019', '系统配置', 'system:config', 'system', 'config', '系统配置管理'),
('perm-020', '超级管理员', 'system:admin', 'system', 'admin', '超级管理员权限');

-- 2. 默认租户
INSERT INTO `tenants` (`id`, `tenant_name`, `tenant_code`, `contact_email`, `status`, `quota_accounts`, `quota_messages`) VALUES
('tenant-demo', '演示租户', 'demo', 'demo@wework.com', 'active', 500, 10000000);

-- 3. 系统角色
INSERT INTO `roles` (`id`, `tenant_id`, `role_name`, `role_code`, `description`, `is_system`) VALUES
-- 系统级角色
('role-super-admin', 'tenant-demo', '超级管理员', 'super_admin', '系统超级管理员，拥有所有权限', TRUE),
('role-tenant-admin', 'tenant-demo', '租户管理员', 'tenant_admin', '租户管理员，管理租户内所有资源', TRUE),
('role-account-manager', 'tenant-demo', '账号管理员', 'account_manager', '企微账号管理员', FALSE),
('role-message-operator', 'tenant-demo', '消息操作员', 'message_operator', '消息发送操作员', FALSE),
('role-monitor-viewer', 'tenant-demo', '监控查看员', 'monitor_viewer', '监控数据查看员', FALSE);

-- 4. 角色权限关联
INSERT INTO `role_permissions` (`id`, `role_id`, `permission_id`) VALUES
-- 超级管理员 - 所有权限
('rp-001', 'role-super-admin', 'perm-020'),

-- 租户管理员 - 除超级管理员外的所有权限
('rp-002', 'role-tenant-admin', 'perm-001'),
('rp-003', 'role-tenant-admin', 'perm-002'),
('rp-004', 'role-tenant-admin', 'perm-003'),
('rp-005', 'role-tenant-admin', 'perm-004'),
('rp-006', 'role-tenant-admin', 'perm-005'),
('rp-007', 'role-tenant-admin', 'perm-006'),
('rp-008', 'role-tenant-admin', 'perm-007'),
('rp-009', 'role-tenant-admin', 'perm-008'),
('rp-010', 'role-tenant-admin', 'perm-009'),
('rp-011', 'role-tenant-admin', 'perm-010'),
('rp-012', 'role-tenant-admin', 'perm-011'),
('rp-013', 'role-tenant-admin', 'perm-012'),
('rp-014', 'role-tenant-admin', 'perm-013'),
('rp-015', 'role-tenant-admin', 'perm-014'),
('rp-016', 'role-tenant-admin', 'perm-015'),
('rp-017', 'role-tenant-admin', 'perm-016'),
('rp-018', 'role-tenant-admin', 'perm-017'),
('rp-019', 'role-tenant-admin', 'perm-018'),
('rp-020', 'role-tenant-admin', 'perm-019'),

-- 账号管理员 - 账号相关权限
('rp-021', 'role-account-manager', 'perm-009'),
('rp-022', 'role-account-manager', 'perm-010'),
('rp-023', 'role-account-manager', 'perm-011'),
('rp-024', 'role-account-manager', 'perm-012'),
('rp-025', 'role-account-manager', 'perm-013'),

-- 消息操作员 - 消息相关权限
('rp-026', 'role-message-operator', 'perm-009'),
('rp-027', 'role-message-operator', 'perm-014'),
('rp-028', 'role-message-operator', 'perm-015'),
('rp-029', 'role-message-operator', 'perm-016'),

-- 监控查看员 - 监控查看权限
('rp-030', 'role-monitor-viewer', 'perm-017');

-- 5. 默认用户（密码都是：WeWork@2025）
INSERT INTO `users` (`id`, `tenant_id`, `username`, `password`, `real_name`, `email`, `status`) VALUES
('user-admin', 'tenant-demo', 'admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iKXgHfNxvIVST6O0QPjj0iBNjOwe', '系统管理员', 'admin@wework.com', 'active'),
('user-demo', 'tenant-demo', 'demo', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iKXgHfNxvIVST6O0QPjj0iBNjOwe', '演示用户', 'demo@wework.com', 'active');

-- 6. 用户角色关联
INSERT INTO `user_roles` (`id`, `user_id`, `role_id`) VALUES
('ur-001', 'user-admin', 'role-super-admin'),
('ur-002', 'user-demo', 'role-tenant-admin');

-- 7. 系统配置
INSERT INTO `system_configs` (`id`, `config_key`, `config_value`, `config_type`, `description`) VALUES
('cfg-001', 'system.name', 'WeWork Management Platform', 'string', '系统名称'),
('cfg-002', 'system.version', '2.0.0', 'string', '系统版本'),
('cfg-003', 'system.timezone', 'Asia/Shanghai', 'string', '系统时区'),
('cfg-004', 'wework.api.base_url', 'https://qyapi.weixin.qq.com', 'string', '企微API基础URL'),
('cfg-005', 'message.max_batch_size', '1000', 'number', '批量消息最大数量'),
('cfg-006', 'message.retry_count', '3', 'number', '消息重试次数'),
('cfg-007', 'message.retry_interval', '5000', 'number', '消息重试间隔(毫秒)'),
('cfg-008', 'file.max_size', '100485760', 'number', '文件最大大小(100MB)'),
('cfg-009', 'file.allowed_types', '["jpg","jpeg","png","gif","pdf","doc","docx","xls","xlsx","ppt","pptx"]', 'json', '允许的文件类型'),
('cfg-010', 'security.jwt_secret', 'WeWork-JWT-Secret-Key-2025', 'string', 'JWT密钥'),
('cfg-011', 'security.jwt_expiration', '7200', 'number', 'JWT过期时间(秒)'),
('cfg-012', 'security.password_policy', '{"minLength":8,"requireNumbers":true,"requireSymbols":true}', 'json', '密码策略');

-- 8. 租户配置
INSERT INTO `tenant_configs` (`id`, `tenant_id`, `config_key`, `config_value`, `config_type`, `description`) VALUES
('tcfg-001', 'tenant-demo', 'account.auto_heartbeat', 'true', 'boolean', '自动心跳检测'),
('tcfg-002', 'tenant-demo', 'account.heartbeat_interval', '30', 'number', '心跳间隔(秒)'),
('tcfg-003', 'tenant-demo', 'message.enable_statistics', 'true', 'boolean', '启用消息统计'),
('tcfg-004', 'tenant-demo', 'notification.email_enabled', 'true', 'boolean', '启用邮件通知'),
('tcfg-005', 'tenant-demo', 'notification.email_smtp', '{"host":"smtp.qq.com","port":587,"secure":false}', 'json', '邮件SMTP配置');

-- 9. 字典数据
INSERT INTO `dictionaries` (`id`, `dict_code`, `dict_name`, `dict_value`, `sort_order`, `description`) VALUES
-- 账号状态字典
('dict-001', 'account_status', '账号状态', NULL, 0, '企微账号状态枚举'),
('dict-002', 'account_status', '已创建', 'created', 1, '账号已创建'),
('dict-003', 'account_status', '初始化中', 'initializing', 2, '正在初始化'),
('dict-004', 'account_status', '等待扫码', 'waiting_qr', 3, '等待扫码登录'),
('dict-005', 'account_status', '等待确认', 'waiting_confirm', 4, '等待确认登录'),
('dict-006', 'account_status', '验证中', 'verifying', 5, '正在验证'),
('dict-007', 'account_status', '在线', 'online', 6, '账号在线'),
('dict-008', 'account_status', '离线', 'offline', 7, '账号离线'),
('dict-009', 'account_status', '错误', 'error', 8, '账号异常'),
('dict-010', 'account_status', '恢复中', 'recovering', 9, '正在恢复'),

-- 消息类型字典
('dict-011', 'message_type', '消息类型', NULL, 0, '消息类型枚举'),
('dict-012', 'message_type', '文本消息', 'text', 1, '纯文本消息'),
('dict-013', 'message_type', '图片消息', 'image', 2, '图片消息'),
('dict-014', 'message_type', '文件消息', 'file', 3, '文件消息'),
('dict-015', 'message_type', '视频消息', 'video', 4, '视频消息'),
('dict-016', 'message_type', '卡片消息', 'card', 5, '卡片消息'),
('dict-017', 'message_type', '链接消息', 'link', 6, '链接消息');

-- 10. 配额使用初始化
INSERT INTO `tenant_quota_usage` (`id`, `tenant_id`, `resource_type`, `quota_limit`, `quota_used`, `period_type`, `period_start`, `period_end`) VALUES
('quota-001', 'tenant-demo', 'accounts', 500, 0, 'month', DATE_FORMAT(NOW(), '%Y-%m-01'), LAST_DAY(NOW())),
('quota-002', 'tenant-demo', 'messages', 10000000, 0, 'month', DATE_FORMAT(NOW(), '%Y-%m-01'), LAST_DAY(NOW())),
('quota-003', 'tenant-demo', 'storage', 107374182400, 0, 'month', DATE_FORMAT(NOW(), '%Y-%m-01'), LAST_DAY(NOW()));

-- ===== wework_platform 初始数据 =====
USE `wework_platform`;

-- 1. 消息模板示例
INSERT INTO `message_templates` (`id`, `tenant_id`, `template_name`, `template_type`, `template_content`, `variables`, `is_active`, `created_by`) VALUES
('tpl-001', 'tenant-demo', '欢迎消息模板', 'text', '{"content":"您好 {{name}}，欢迎使用企微管理平台！"}', '{"variables":[{"name":"name","type":"string","description":"用户姓名"}]}', TRUE, 'user-admin'),
('tpl-002', 'tenant-demo', '系统通知模板', 'text', '{"content":"系统通知：{{title}}\\n内容：{{content}}\\n时间：{{time}}"}', '{"variables":[{"name":"title","type":"string","description":"通知标题"},{"name":"content","type":"string","description":"通知内容"},{"name":"time","type":"datetime","description":"通知时间"}]}', TRUE, 'user-admin');

-- 2. 标签示例
INSERT INTO `tags` (`id`, `tenant_id`, `tag_name`, `tag_color`, `tag_type`, `description`, `created_by`) VALUES
('tag-001', 'tenant-demo', '重要客户', '#FF5722', 'contact', '标记重要客户', 'user-admin'),
('tag-002', 'tenant-demo', '技术支持', '#2196F3', 'contact', '技术支持人员', 'user-admin'),
('tag-003', 'tenant-demo', '销售团队', '#4CAF50', 'group', '销售团队群组', 'user-admin'),
('tag-004', 'tenant-demo', '紧急通知', '#F44336', 'message', '紧急通知消息', 'user-admin');

-- ===== monitor_analytics 初始数据 =====
USE `monitor_analytics`;

-- 1. 告警规则示例
INSERT INTO `alert_rules` (`id`, `rule_name`, `rule_type`, `metric_name`, `condition_type`, `threshold_value`, `alert_level`, `evaluation_interval`, `notification_config`, `is_enabled`, `created_by`) VALUES
('rule-001', '账号离线告警', 'account', 'account_offline_duration', '>', 300, 'warning', 60, '{"email":["admin@wework.com"],"webhook":null}', TRUE, 'user-admin'),
('rule-002', '消息发送失败率告警', 'message', 'message_failure_rate', '>', 10, 'error', 300, '{"email":["admin@wework.com"],"dingtalk":null}', TRUE, 'user-admin'),
('rule-003', '系统CPU使用率告警', 'system', 'cpu_usage_percent', '>', 80, 'warning', 60, '{"email":["admin@wework.com"]}', TRUE, 'user-admin'),
('rule-004', '系统内存使用率告警', 'system', 'memory_usage_percent', '>', 85, 'error', 60, '{"email":["admin@wework.com"]}', TRUE, 'user-admin'),
('rule-005', 'API响应时间告警', 'api', 'api_response_time_p95', '>', 2000, 'warning', 120, '{"email":["admin@wework.com"]}', TRUE, 'user-admin');

-- 2. 数据保留策略
INSERT INTO `data_retention_policies` (`id`, `table_name`, `retention_days`, `archive_enabled`, `compression_enabled`, `is_enabled`) VALUES
('policy-001', 'account_metrics', 90, FALSE, TRUE, TRUE),
('policy-002', 'system_metrics', 30, FALSE, TRUE, TRUE),
('policy-003', 'error_logs', 30, TRUE, TRUE, TRUE),
('policy-004', 'api_call_logs', 7, FALSE, TRUE, TRUE),
('policy-005', 'alert_notifications', 30, FALSE, FALSE, TRUE);