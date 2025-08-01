package com.wework.platform.account.service.impl;

import com.wework.platform.account.dto.AdminLoginRequest;
import com.wework.platform.account.dto.AdminLoginResponse;
import com.wework.platform.account.dto.UserInfo;
import com.wework.platform.account.entity.User;
import com.wework.platform.account.repository.UserRepository;
import com.wework.platform.account.service.UserService;
import com.wework.platform.common.utils.JwtUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

/**
 * 用户管理服务实现
 *
 * @author WeWork Platform Team
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final JwtUtils jwtUtils;
    private final PasswordEncoder passwordEncoder;

    @Override
    public AdminLoginResponse authenticateUser(AdminLoginRequest loginRequest) {
        log.info("用户登录请求: {}", loginRequest.getUsername());

        // 从数据库查询用户
        log.debug("查询用户: {}", loginRequest.getUsername());
        User user = userRepository.findByUsername(loginRequest.getUsername());
        log.debug("查询结果: {}", user != null ? "找到用户" : "用户不存在");
        if (user == null) {
            log.warn("用户不存在: {}", loginRequest.getUsername());
            throw new RuntimeException("用户名或密码错误");
        }
        log.debug("用户信息: username={}, role={}, tenantId={}, enabled={}", 
                  user.getUsername(), user.getRole(), user.getTenantId(), user.isEnabled());

        // 验证密码
        if (!validatePassword(loginRequest.getUsername(), loginRequest.getPassword())) {
            log.warn("密码验证失败: {}", loginRequest.getUsername());
            throw new RuntimeException("用户名或密码错误");
        }

        // 检查用户状态
        if (!user.isEnabled()) {
            log.warn("用户已被禁用: {}", loginRequest.getUsername());
            throw new RuntimeException("账号已被禁用");
        }

        // 更新最后登录时间
        updateLastLoginTime(loginRequest.getUsername());

        // 转换为UserInfo
        UserInfo userInfo = convertToUserInfo(user);

        // 生成JWT Token
        String token = jwtUtils.generateToken(user.getUsername(), user.getRole(), user.getTenantId());
        String refreshToken = jwtUtils.generateToken(user.getUsername(), user.getRole(), user.getTenantId());

        // 构建响应
        AdminLoginResponse response = new AdminLoginResponse();
        response.setToken(token);
        response.setRefreshToken(refreshToken);
        response.setUser(userInfo);
        response.setExpiresIn(7200); // 2小时

        log.info("用户登录成功: {}, 租户: {}", user.getUsername(), user.getTenantId());
        return response;
    }

    @Override
    public UserInfo getUserByUsername(String username) {
        User user = userRepository.findByUsername(username);
        return user != null ? convertToUserInfo(user) : null;
    }

    @Override
    public boolean validatePassword(String username, String rawPassword) {
        log.debug("验证密码: username={}", username);
        User user = userRepository.findByUsername(username);
        if (user == null) {
            log.debug("验证密码时用户不存在");
            return false;
        }

        try {
            log.debug("原始密码: {}, 数据库hash: {}", rawPassword, user.getPassword());
            boolean matches = passwordEncoder.matches(rawPassword, user.getPassword());
            log.debug("密码验证结果: {}", matches ? "通过" : "失败");
            
            // 额外测试：生成新hash进行对比
            String newHash = passwordEncoder.encode(rawPassword);
            log.debug("新生成的hash: {}", newHash);
            
            return matches;
        } catch (Exception e) {
            log.error("密码验证异常: {}", e.getMessage(), e);
            return false;
        }
    }

    @Override
    public void updateLastLoginTime(String username) {
        try {
            LocalDateTime now = LocalDateTime.now();
            int updated = userRepository.updateLastLoginTime(username, now);
            if (updated > 0) {
                log.debug("更新用户最后登录时间成功: {}", username);
            } else {
                log.warn("更新用户最后登录时间失败: {}", username);
            }
        } catch (Exception e) {
            log.error("更新用户最后登录时间异常: {}", e.getMessage(), e);
        }
    }

    @Override
    public UserInfo getUserById(String userId) {
        User user = userRepository.findById(userId);
        return user != null ? convertToUserInfo(user) : null;
    }

    /**
     * 将User实体转换为UserInfo DTO
     * 
     * @param user 用户实体
     * @return UserInfo DTO
     */
    private UserInfo convertToUserInfo(User user) {
        UserInfo userInfo = new UserInfo();
        userInfo.setUserId(user.getId());
        userInfo.setUsername(user.getUsername());
        userInfo.setNickname(user.getDisplayName());
        userInfo.setEmail(user.getEmail());
        userInfo.setPhone(user.getPhone());
        userInfo.setRole(user.getRole().toUpperCase()); // 转换为大写以保持一致性
        userInfo.setTenantId(user.getTenantId());
        userInfo.setEnabled(user.isEnabled());
        userInfo.setCreateTime(user.getCreatedAt());
        userInfo.setLastLoginTime(user.getLastLoginTime());
        return userInfo;
    }
}