package com.wework.platform.user.service;

import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.user.dto.*;
import com.wework.platform.user.entity.User;

/**
 * 用户服务接口
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
public interface UserService {

    /**
     * 用户登录
     * 
     * @param request 登录请求
     * @param clientIp 客户端IP
     * @return 登录响应
     */
    LoginResponse login(LoginRequest request, String clientIp);

    /**
     * 用户登出
     * 
     * @param userId 用户ID
     */
    void logout(String userId);

    /**
     * 刷新令牌
     * 
     * @param refreshToken 刷新令牌
     * @return 新的访问令牌
     */
    String refreshToken(String refreshToken);

    /**
     * 获取当前用户信息
     * 
     * @param userId 用户ID
     * @return 用户信息
     */
    UserDTO getCurrentUser(String userId);

    /**
     * 分页查询用户列表
     * 
     * @param tenantId 租户ID
     * @param pageNum 页码
     * @param pageSize 页大小
     * @param keyword 关键词（用户名、昵称、邮箱）
     * @param status 状态
     * @return 用户列表
     */
    PageResult<UserDTO> getUserList(String tenantId, Integer pageNum, Integer pageSize, String keyword, Integer status);

    /**
     * 根据ID获取用户详情
     * 
     * @param userId 用户ID
     * @param tenantId 租户ID
     * @return 用户详情
     */
    UserDTO getUserById(String userId, String tenantId);

    /**
     * 创建用户
     * 
     * @param request 创建用户请求
     * @param tenantId 租户ID
     * @param operatorId 操作人ID
     * @return 用户信息
     */
    UserDTO createUser(CreateUserRequest request, String tenantId, String operatorId);

    /**
     * 更新用户
     * 
     * @param userId 用户ID
     * @param request 更新用户请求
     * @param tenantId 租户ID
     * @param operatorId 操作人ID
     * @return 用户信息
     */
    UserDTO updateUser(String userId, UpdateUserRequest request, String tenantId, String operatorId);

    /**
     * 删除用户
     * 
     * @param userId 用户ID
     * @param tenantId 租户ID
     * @param operatorId 操作人ID
     */
    void deleteUser(String userId, String tenantId, String operatorId);

    /**
     * 重置用户密码
     * 
     * @param userId 用户ID
     * @param newPassword 新密码
     * @param tenantId 租户ID
     * @param operatorId 操作人ID
     */
    void resetPassword(String userId, String newPassword, String tenantId, String operatorId);

    /**
     * 修改用户密码
     * 
     * @param userId 用户ID
     * @param oldPassword 旧密码
     * @param newPassword 新密码
     */
    void changePassword(String userId, String oldPassword, String newPassword);

    /**
     * 启用/禁用用户
     * 
     * @param userId 用户ID
     * @param status 状态
     * @param tenantId 租户ID
     * @param operatorId 操作人ID
     */
    void updateUserStatus(String userId, Integer status, String tenantId, String operatorId);

    /**
     * 分配用户角色
     * 
     * @param userId 用户ID
     * @param roleIds 角色ID列表
     * @param tenantId 租户ID
     * @param operatorId 操作人ID
     */
    void assignUserRoles(String userId, java.util.List<String> roleIds, String tenantId, String operatorId);

    /**
     * 获取用户权限
     * 
     * @param userId 用户ID
     * @param tenantId 租户ID
     * @return 权限列表
     */
    java.util.List<String> getUserPermissions(String userId, String tenantId);

    /**
     * 检查用户是否具有指定权限
     * 
     * @param userId 用户ID
     * @param permission 权限代码
     * @param tenantId 租户ID
     * @return 是否具有权限
     */
    boolean hasPermission(String userId, String permission, String tenantId);

    /**
     * 根据用户名查找用户
     * 
     * @param username 用户名
     * @param tenantId 租户ID
     * @return 用户信息
     */
    User findByUsername(String username, String tenantId);

    /**
     * 根据邮箱查找用户
     * 
     * @param email 邮箱
     * @param tenantId 租户ID
     * @return 用户信息
     */
    User findByEmail(String email, String tenantId);
}