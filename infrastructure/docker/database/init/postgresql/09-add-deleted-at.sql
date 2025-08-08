-- 为所有表添加deleted_at字段
ALTER TABLE saas_roles ADD COLUMN IF NOT EXISTS deleted_at timestamp without time zone;
ALTER TABLE saas_permissions ADD COLUMN IF NOT EXISTS deleted_at timestamp without time zone;
ALTER TABLE saas_role_permissions ADD COLUMN IF NOT EXISTS deleted_at timestamp without time zone;
ALTER TABLE saas_user_roles ADD COLUMN IF NOT EXISTS deleted_at timestamp without time zone;

-- 创建或替换更新updated_at的触发器函数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 为每个表创建更新updated_at的触发器
DO $$
DECLARE
    tables RECORD;
BEGIN
    FOR tables IN 
        SELECT tablename 
        FROM pg_tables 
        WHERE schemaname = 'public' 
        AND tablename LIKE 'saas_%'
    LOOP
        EXECUTE format('DROP TRIGGER IF EXISTS update_updated_at ON %I', tables.tablename);
        EXECUTE format('CREATE TRIGGER update_updated_at BEFORE UPDATE ON %I FOR EACH ROW EXECUTE FUNCTION update_updated_at_column()', tables.tablename);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- 创建索引以优化查询性能
CREATE INDEX IF NOT EXISTS idx_saas_roles_deleted_at ON saas_roles(deleted_at);
CREATE INDEX IF NOT EXISTS idx_saas_permissions_deleted_at ON saas_permissions(deleted_at);
CREATE INDEX IF NOT EXISTS idx_saas_role_permissions_deleted_at ON saas_role_permissions(deleted_at);
CREATE INDEX IF NOT EXISTS idx_saas_user_roles_deleted_at ON saas_user_roles(deleted_at);

-- 创建或替换软删除函数
CREATE OR REPLACE FUNCTION soft_delete_record()
RETURNS TRIGGER AS $$
BEGIN
    NEW.deleted_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 为每个表创建软删除触发器
DO $$
DECLARE
    tables RECORD;
BEGIN
    FOR tables IN 
        SELECT tablename 
        FROM pg_tables 
        WHERE schemaname = 'public' 
        AND tablename LIKE 'saas_%'
        AND EXISTS (
            SELECT 1 
            FROM information_schema.columns 
            WHERE table_name = tables.tablename 
            AND column_name = 'deleted_at'
        )
    LOOP
        EXECUTE format('DROP TRIGGER IF EXISTS soft_delete ON %I', tables.tablename);
        EXECUTE format('CREATE TRIGGER soft_delete BEFORE UPDATE OF deleted_at ON %I FOR EACH ROW EXECUTE FUNCTION soft_delete_record()', tables.tablename);
    END LOOP;
END;
$$ LANGUAGE plpgsql;
