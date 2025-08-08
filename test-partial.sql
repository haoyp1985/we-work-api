USE saas_unified_core;

-- 测试前几个表
CREATE TABLE saas_tenants (
    id VARCHAR(36) PRIMARY KEY COMMENT 'Tenant ID',
    tenant_code VARCHAR(50) NOT NULL COMMENT 'Tenant Code',
    tenant_name VARCHAR(200) NOT NULL COMMENT 'Tenant Name',
    status ENUM('active', 'inactive', 'suspended', 'deleted') DEFAULT 'active' COMMENT 'Tenant Status',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Created At'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='SaaS Tenants Table';

CREATE TABLE saas_users (
    id VARCHAR(36) PRIMARY KEY COMMENT 'User ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT 'Tenant ID',
    username VARCHAR(50) NOT NULL COMMENT 'Username',
    email VARCHAR(100) COMMENT 'Email',
    password_hash VARCHAR(255) NOT NULL COMMENT 'Password Hash',
    status ENUM('active', 'inactive', 'locked', 'deleted') DEFAULT 'active' COMMENT 'User Status',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Created At',
    UNIQUE KEY uk_tenant_username (tenant_id, username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='SaaS Users Table';

CREATE TABLE saas_roles (
    id VARCHAR(36) PRIMARY KEY COMMENT 'Role ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT 'Tenant ID',
    role_name VARCHAR(100) NOT NULL COMMENT 'Role Name',
    role_code VARCHAR(50) NOT NULL COMMENT 'Role Code',
    description TEXT COMMENT 'Description',
    status ENUM('active', 'inactive', 'deleted') DEFAULT 'active' COMMENT 'Role Status',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Created At',
    UNIQUE KEY uk_tenant_role_code (tenant_id, role_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Roles Management Table';

CREATE TABLE saas_permissions (
    id VARCHAR(36) PRIMARY KEY COMMENT 'Permission ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT 'Tenant ID',
    permission_name VARCHAR(100) NOT NULL COMMENT 'Permission Name',
    permission_code VARCHAR(50) NOT NULL COMMENT 'Permission Code',
    description TEXT COMMENT 'Description',
    status ENUM('active', 'inactive', 'deleted') DEFAULT 'active' COMMENT 'Permission Status',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Created At',
    UNIQUE KEY uk_tenant_permission_code (tenant_id, permission_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Permissions Management Table';

CREATE TABLE saas_user_roles (
    id VARCHAR(36) PRIMARY KEY COMMENT 'User Role ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT 'Tenant ID',
    user_id VARCHAR(36) NOT NULL COMMENT 'User ID',
    role_id VARCHAR(36) NOT NULL COMMENT 'Role ID',
    status ENUM('active', 'inactive', 'deleted') DEFAULT 'active' COMMENT 'Status',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Created At',
    UNIQUE KEY uk_user_role (user_id, role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='User Roles Association Table';

CREATE TABLE saas_role_permissions (
    id VARCHAR(36) PRIMARY KEY COMMENT 'Role Permission ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT 'Tenant ID',
    role_id VARCHAR(36) NOT NULL COMMENT 'Role ID',
    permission_id VARCHAR(36) NOT NULL COMMENT 'Permission ID',
    status ENUM('active', 'inactive', 'deleted') DEFAULT 'active' COMMENT 'Status',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Created At',
    UNIQUE KEY uk_role_permission (role_id, permission_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Role Permissions Association Table';

CREATE TABLE saas_api_keys (
    id VARCHAR(36) PRIMARY KEY COMMENT 'API Key ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT 'Tenant ID',
    user_id VARCHAR(36) NOT NULL COMMENT 'User ID',
    api_key VARCHAR(255) NOT NULL COMMENT 'API Key',
    api_secret VARCHAR(255) NOT NULL COMMENT 'API Secret',
    name VARCHAR(100) NOT NULL COMMENT 'Name',
    description TEXT COMMENT 'Description',
    permissions JSON COMMENT 'Permissions',
    status ENUM('active', 'inactive', 'deleted') DEFAULT 'active' COMMENT 'Status',
    expires_at TIMESTAMP NULL COMMENT 'Expires At',
    last_used_at TIMESTAMP NULL COMMENT 'Last Used At',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Created At',
    UNIQUE KEY uk_api_key (api_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='API Keys Management Table';

CREATE TABLE saas_user_sessions (
    id VARCHAR(36) PRIMARY KEY COMMENT 'Session ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT 'Tenant ID',
    user_id VARCHAR(36) NOT NULL COMMENT 'User ID',
    session_token VARCHAR(255) NOT NULL COMMENT 'Session Token',
    status ENUM('active', 'expired', 'revoked') DEFAULT 'active' COMMENT 'Status',
    expires_at TIMESTAMP NOT NULL COMMENT 'Expires At',
    last_activity_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last Activity At',
    device_fingerprint VARCHAR(255) COMMENT 'Device Fingerprint',
    login_ip VARCHAR(45) COMMENT 'Login IP',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Created At',
    UNIQUE KEY uk_session_token (session_token),
    INDEX idx_tenant_user (tenant_id, user_id),
    INDEX idx_session_token (session_token),
    INDEX idx_user_status (user_id, status),
    INDEX idx_expires_at (expires_at),
    INDEX idx_last_activity (last_activity_at),
    INDEX idx_device_fingerprint (device_fingerprint),
    INDEX idx_login_ip (login_ip)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='User Sessions Management Table';
