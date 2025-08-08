USE saas_unified_core;

-- 测试第一个表
CREATE TABLE saas_tenants (
    id VARCHAR(36) PRIMARY KEY COMMENT 'Tenant ID',
    tenant_code VARCHAR(50) NOT NULL COMMENT 'Tenant Code',
    tenant_name VARCHAR(200) NOT NULL COMMENT 'Tenant Name',
    status ENUM('active', 'inactive', 'suspended', 'deleted') DEFAULT 'active' COMMENT 'Tenant Status',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Created At'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='SaaS Tenants Table';

-- 测试第二个表
CREATE TABLE saas_users (
    id VARCHAR(36) PRIMARY KEY COMMENT 'User ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT 'Tenant ID',
    username VARCHAR(50) NOT NULL COMMENT 'Username',
    email VARCHAR(100) COMMENT 'Email',
    password_hash VARCHAR(255) NOT NULL COMMENT 'Password Hash',
    status ENUM('active', 'inactive', 'locked', 'deleted') DEFAULT 'active' COMMENT 'User Status',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Created At',
    UNIQUE KEY uk_tenant_username (tenant_id, username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Users Table';

-- 测试第三个表
CREATE TABLE saas_roles (
    id VARCHAR(36) PRIMARY KEY COMMENT 'Role ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT 'Tenant ID',
    role_name VARCHAR(100) NOT NULL COMMENT 'Role Name',
    role_code VARCHAR(50) NOT NULL COMMENT 'Role Code',
    description TEXT COMMENT 'Description',
    status ENUM('active', 'inactive', 'deleted') DEFAULT 'active' COMMENT 'Role Status',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Created At',
    UNIQUE KEY uk_tenant_role_code (tenant_id, role_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Roles Table';
