package com.wework.platform.account.service;

import com.wework.platform.account.dto.AdminLoginRequest;
import com.wework.platform.account.dto.AdminLoginResponse;
import com.wework.platform.account.dto.UserInfo;

/**
 * 用户管理服务接口
 *
 * @author WeWork Platform Team
 */
public interface UserService {

    /**
     * 用户登录验证
     * 
     * @param loginRequest 登录请求信息
     * @return 登录响应结果
     */
    AdminLoginResponse authenticateUser(AdminLoginRequest loginRequest);

    /**
     * 根据用户名获取用户信息
     * 
     * @param username 用户名
     * @return 用户信息，如果不存在返回null
     */
    UserInfo getUserByUsername(String username);

    /**
     * 验证用户密码
     * 
     * @param username 用户名
     * @param rawPassword 原始密码
     * @return 验证结果
     */
    boolean validatePassword(String username, String rawPassword);

    /**
     * 更新用户最后登录时间
     * 
     * @param username 用户名
     */
    void updateLastLoginTime(String username);

    /**
     * 根据用户ID获取用户信息
     * 
     * @param userId 用户ID
     * @return 用户信息
     */
    UserInfo getUserById(String userId);
}