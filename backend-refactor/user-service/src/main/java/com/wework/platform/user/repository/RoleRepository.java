package com.wework.platform.user.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.user.entity.Role;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 角色数据访问层
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Mapper
public interface RoleRepository extends BaseMapper<Role> {

    /**
     * 根据角色代码查询角色
     * 
     * @param roleCode 角色代码
     * @param tenantId 租户ID
     * @return 角色信息
     */
    @Select("SELECT * FROM roles WHERE role_code = #{roleCode} AND tenant_id = #{tenantId} AND deleted_at IS NULL")
    Role findByRoleCode(@Param("roleCode") String roleCode, @Param("tenantId") String tenantId);

    /**
     * 根据租户ID查询角色列表
     * 
     * @param tenantId 租户ID
     * @param page 分页参数
     * @return 角色列表
     */
    @Select("SELECT * FROM roles WHERE tenant_id = #{tenantId} AND deleted_at IS NULL ORDER BY created_at DESC")
    Page<Role> findByTenantId(@Param("tenantId") String tenantId, Page<Role> page);

    /**
     * 查询所有角色（不分页）
     * 
     * @param tenantId 租户ID
     * @return 角色列表
     */
    @Select("SELECT * FROM roles WHERE tenant_id = #{tenantId} AND deleted_at IS NULL ORDER BY sort_order ASC, created_at DESC")
    List<Role> findAllByTenantId(@Param("tenantId") String tenantId);

    /**
     * 根据角色ID查询角色权限
     * 
     * @param roleId 角色ID
     * @return 权限代码列表
     */
    @Select("""
        SELECT p.permission_code FROM permissions p
        INNER JOIN role_permissions rp ON p.id = rp.permission_id
        WHERE rp.role_id = #{roleId} 
        AND p.deleted_at IS NULL 
        AND rp.deleted_at IS NULL
        ORDER BY p.sort_order ASC
        """)
    List<String> findRolePermissions(@Param("roleId") String roleId);

    /**
     * 检查角色代码是否存在
     * 
     * @param roleCode 角色代码
     * @param tenantId 租户ID
     * @param excludeRoleId 排除的角色ID（用于更新时检查）
     * @return 存在数量
     */
    @Select("""
        SELECT COUNT(*) FROM roles 
        WHERE role_code = #{roleCode} 
        AND tenant_id = #{tenantId} 
        AND deleted_at IS NULL
        ${excludeRoleId != null ? 'AND id != #{excludeRoleId}' : ''}
        """)
    int countByRoleCode(@Param("roleCode") String roleCode, 
                       @Param("tenantId") String tenantId, 
                       @Param("excludeRoleId") String excludeRoleId);

    /**
     * 查询角色关联的用户数量
     * 
     * @param roleId 角色ID
     * @return 用户数量
     */
    @Select("""
        SELECT COUNT(*) FROM user_roles ur
        INNER JOIN users u ON ur.user_id = u.id
        WHERE ur.role_id = #{roleId} 
        AND ur.deleted_at IS NULL 
        AND u.deleted_at IS NULL
        """)
    int countRoleUsers(@Param("roleId") String roleId);
}