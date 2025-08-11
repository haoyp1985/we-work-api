-- 版本: V1.2.0
-- 描述: 创建 wework_provision_tasks 表（开通登录任务表）
-- 日期: 2025-08-10

CREATE TABLE IF NOT EXISTS wework_provision_tasks (
    id                  VARCHAR(64) PRIMARY KEY,
    tenant_id           VARCHAR(36) NOT NULL,
    operator_id         VARCHAR(36),

    corp_id             VARCHAR(64),
    corp_name           VARCHAR(200),
    agent_id            VARCHAR(64),
    secret              TEXT,
    contact_sync_secret TEXT,
    message_encrypt_key TEXT,
    auto_reconnect      BOOLEAN,
    remark              TEXT,

    provider_code       VARCHAR(32),
    notify_url          VARCHAR(512),
    bridge_id           VARCHAR(64),

    status              VARCHAR(32),
    account_id          VARCHAR(20),
    created_at          VARCHAR(32),
    updated_at          VARCHAR(32)
);

CREATE INDEX IF NOT EXISTS idx_wpt_tenant_id ON wework_provision_tasks (tenant_id);
CREATE INDEX IF NOT EXISTS idx_wpt_status ON wework_provision_tasks (status);

COMMENT ON TABLE wework_provision_tasks IS '开通登录任务表(第三方Provider引导的登录/创建任务)';

