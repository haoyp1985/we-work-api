package com.wework.platform.user.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.user.entity.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 用户数据访问层
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Mapper
public interface UserRepository extends BaseMapper<User> {

    /**
     * 根据用户名查询用户
     * 
     * @param username 用户名
     * @return 用户信息
     */
    @Select("SELECT * FROM users WHERE username = #{username} AND deleted_at IS NULL")
    User findByUsername(@Param("username") String username);

    /**
     * 根据邮箱查询用户
     * 
     * @param email 邮箱
     * @return 用户信息
     */
    @Select("SELECT * FROM users WHERE email = #{email} AND deleted_at IS NULL")
    User findByEmail(@Param("email") String email);

    /**
     * 根据租户ID查询用户列表
     * 
     * @param tenantId 租户ID
     * @param page 分页参数
     * @return 用户列表
     */
    @Select("SELECT * FROM users WHERE tenant_id = #{tenantId} AND deleted_at IS NULL ORDER BY created_at DESC")
    Page<User> findByTenantId(@Param("tenantId") String tenantId, Page<User> page);

    /**
     * 根据用户ID查询用户角色
     * 
     * @param userId 用户ID
     * @return 角色代码列表
     */
    @Select("""
        SELECT r.role_code FROM roles r 
        INNER JOIN user_roles ur ON r.id = ur.role_id 
        WHERE ur.user_id = #{userId} AND r.deleted_at IS NULL AND ur.deleted_at IS NULL
        """)
    List<String> findUserRoles(@Param("userId") String userId);

    /**
     * 根据用户ID查询用户权限
     * 
     * @param userId 用户ID
     * @return 权限代码列表
     */
    @Select("""
        SELECT DISTINCT p.permission_code FROM permissions p
        INNER JOIN role_permissions rp ON p.id = rp.permission_id
        INNER JOIN user_roles ur ON rp.role_id = ur.role_id
        WHERE ur.user_id = #{userId} 
        AND p.deleted_at IS NULL 
        AND rp.deleted_at IS NULL 
        AND ur.deleted_at IS NULL
        """)
    List<String> findUserPermissions(@Param("userId") String userId);

    /**
     * 检查用户名是否存在
     * 
     * @param username 用户名
     * @param tenantId 租户ID
     * @param excludeUserId 排除的用户ID（用于更新时检查）
     * @return 存在数量
     */
    @Select("""
        SELECT COUNT(*) FROM users 
        WHERE username = #{username} 
        AND tenant_id = #{tenantId} 
        AND deleted_at IS NULL
        ${excludeUserId != null ? 'AND id != #{excludeUserId}' : ''}
        """)
    int countByUsername(@Param("username") String username, 
                       @Param("tenantId") String tenantId, 
                       @Param("excludeUserId") String excludeUserId);

    /**
     * 检查邮箱是否存在
     * 
     * @param email 邮箱
     * @param tenantId 租户ID
     * @param excludeUserId 排除的用户ID（用于更新时检查）
     * @return 存在数量
     */
    @Select("""
        SELECT COUNT(*) FROM users 
        WHERE email = #{email} 
        AND tenant_id = #{tenantId} 
        AND deleted_at IS NULL
        ${excludeUserId != null ? 'AND id != #{excludeUserId}' : ''}
        """)
    int countByEmail(@Param("email") String email, 
                    @Param("tenantId") String tenantId, 
                    @Param("excludeUserId") String excludeUserId);
}