package com.wework.platform.account.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.wework.platform.account.entity.User;
import org.apache.ibatis.annotations.*;

import java.time.LocalDateTime;

/**
 * 用户数据访问层
 *
 * @author WeWork Platform Team
 */
@Mapper
public interface UserRepository extends BaseMapper<User> {

    /**
     * 根据用户名查询用户
     * 
     * @param username 用户名
     * @return 用户信息
     */
    @Select("SELECT * FROM users WHERE username = #{username} AND status = 'active'")
    User findByUsername(@Param("username") String username);

    /**
     * 根据用户名和租户ID查询用户
     * 
     * @param username 用户名
     * @param tenantId 租户ID
     * @return 用户信息
     */
    @Select("SELECT * FROM users WHERE username = #{username} AND tenant_id = #{tenantId} AND status = 'active'")
    User findByUsernameAndTenantId(@Param("username") String username, @Param("tenantId") String tenantId);

    /**
     * 更新用户最后登录时间
     * 
     * @param username 用户名
     * @param lastLoginTime 最后登录时间
     * @return 更新行数
     */
    @Update("UPDATE users SET last_login_time = #{lastLoginTime}, updated_at = #{lastLoginTime} WHERE username = #{username}")
    int updateLastLoginTime(@Param("username") String username, @Param("lastLoginTime") LocalDateTime lastLoginTime);

    /**
     * 根据用户ID查询用户
     * 
     * @param userId 用户ID
     * @return 用户信息
     */
    @Select("SELECT * FROM users WHERE id = #{userId} AND status = 'active'")
    User findById(@Param("userId") String userId);

    /**
     * 根据租户ID查询用户列表
     * 
     * @param tenantId 租户ID
     * @return 用户列表
     */
    @Select("SELECT * FROM users WHERE tenant_id = #{tenantId} AND status = 'active' ORDER BY created_at DESC")
    java.util.List<User> findByTenantId(@Param("tenantId") String tenantId);

    /**
     * 检查用户名是否存在
     * 
     * @param username 用户名
     * @return 用户数量
     */
    @Select("SELECT COUNT(*) FROM users WHERE username = #{username}")
    int countByUsername(@Param("username") String username);
}