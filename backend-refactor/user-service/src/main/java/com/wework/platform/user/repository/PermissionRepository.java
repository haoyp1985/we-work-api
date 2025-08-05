package com.wework.platform.user.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.wework.platform.user.entity.Permission;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 权限数据访问层
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Mapper
public interface PermissionRepository extends BaseMapper<Permission> {

    /**
     * 根据权限代码查询权限
     * 
     * @param permissionCode 权限代码
     * @return 权限信息
     */
    @Select("SELECT * FROM permissions WHERE permission_code = #{permissionCode} AND deleted_at IS NULL")
    Permission findByPermissionCode(@Param("permissionCode") String permissionCode);

    /**
     * 查询所有权限
     * 
     * @return 权限列表
     */
    @Select("SELECT * FROM permissions WHERE deleted_at IS NULL ORDER BY sort_order ASC, created_at DESC")
    List<Permission> findAll();

    /**
     * 根据权限类型查询权限
     * 
     * @param permissionType 权限类型
     * @return 权限列表
     */
    @Select("SELECT * FROM permissions WHERE permission_type = #{permissionType} AND deleted_at IS NULL ORDER BY sort_order ASC")
    List<Permission> findByPermissionType(@Param("permissionType") String permissionType);

    /**
     * 根据父权限ID查询子权限
     * 
     * @param parentId 父权限ID
     * @return 子权限列表
     */
    @Select("SELECT * FROM permissions WHERE parent_id = #{parentId} AND deleted_at IS NULL ORDER BY sort_order ASC")
    List<Permission> findByParentId(@Param("parentId") String parentId);

    /**
     * 查询根权限（没有父权限的权限）
     * 
     * @return 根权限列表
     */
    @Select("SELECT * FROM permissions WHERE parent_id IS NULL AND deleted_at IS NULL ORDER BY sort_order ASC")
    List<Permission> findRootPermissions();

    /**
     * 构建权限树结构
     * 
     * @return 权限树列表
     */
    @Select("""
        WITH RECURSIVE permission_tree AS (
            -- 根节点
            SELECT id, permission_code, permission_name, permission_type, parent_id, 
                   path, component, icon, sort_order, created_at, updated_at,
                   0 as level, CAST(permission_code AS CHAR(1000)) as tree_path
            FROM permissions 
            WHERE parent_id IS NULL AND deleted_at IS NULL
            
            UNION ALL
            
            -- 递归查询子节点
            SELECT p.id, p.permission_code, p.permission_name, p.permission_type, p.parent_id,
                   p.path, p.component, p.icon, p.sort_order, p.created_at, p.updated_at,
                   pt.level + 1, CONCAT(pt.tree_path, '->', p.permission_code)
            FROM permissions p
            INNER JOIN permission_tree pt ON p.parent_id = pt.id
            WHERE p.deleted_at IS NULL
        )
        SELECT * FROM permission_tree ORDER BY tree_path, sort_order
        """)
    List<Permission> findPermissionTree();

    /**
     * 检查权限代码是否存在
     * 
     * @param permissionCode 权限代码
     * @param excludePermissionId 排除的权限ID（用于更新时检查）
     * @return 存在数量
     */
    @Select("""
        SELECT COUNT(*) FROM permissions 
        WHERE permission_code = #{permissionCode} 
        AND deleted_at IS NULL
        ${excludePermissionId != null ? 'AND id != #{excludePermissionId}' : ''}
        """)
    int countByPermissionCode(@Param("permissionCode") String permissionCode, 
                             @Param("excludePermissionId") String excludePermissionId);

    /**
     * 查询权限关联的角色数量
     * 
     * @param permissionId 权限ID
     * @return 角色数量
     */
    @Select("""
        SELECT COUNT(*) FROM role_permissions rp
        INNER JOIN roles r ON rp.role_id = r.id
        WHERE rp.permission_id = #{permissionId} 
        AND rp.deleted_at IS NULL 
        AND r.deleted_at IS NULL
        """)
    int countPermissionRoles(@Param("permissionId") String permissionId);
}