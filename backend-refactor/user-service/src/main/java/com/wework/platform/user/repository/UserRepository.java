package com.wework.platform.user.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.user.entity.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

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
    User findByUsername(@Param("username") String username);

    /**
     * 根据邮箱查询用户
     * 
     * @param email 邮箱
     * @return 用户信息
     */
    User findByEmail(@Param("email") String email);

    /**
     * 根据租户ID查询用户列表
     * 
     * @param tenantId 租户ID
     * @param page 分页参数
     * @return 用户列表
     */
    Page<User> findByTenantId(@Param("tenantId") String tenantId, Page<User> page);

    /**
     * 根据用户ID查询用户角色
     * 
     * @param userId 用户ID
     * @return 角色代码列表
     */
    List<String> findUserRoles(@Param("userId") String userId);

    /**
     * 根据用户ID查询用户权限
     * 
     * @param userId 用户ID
     * @return 权限代码列表
     */
    List<String> findUserPermissions(@Param("userId") String userId);

    /**
     * 检查用户名是否存在
     * 
     * @param username 用户名
     * @param tenantId 租户ID
     * @param excludeUserId 排除的用户ID（用于更新时检查）
     * @return 存在数量
     */
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
    int countByEmail(@Param("email") String email, 
                    @Param("tenantId") String tenantId, 
                    @Param("excludeUserId") String excludeUserId);
}