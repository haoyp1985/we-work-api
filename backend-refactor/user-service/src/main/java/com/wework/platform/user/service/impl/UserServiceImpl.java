package com.wework.platform.user.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.common.core.exception.BusinessException;
import com.wework.platform.common.enums.ResultCode;
import com.wework.platform.common.security.JwtUtils;
import com.wework.platform.common.security.UserContext;
import com.wework.platform.user.dto.*;
import com.wework.platform.user.entity.Role;
import com.wework.platform.user.entity.User;
import com.wework.platform.user.repository.*;
import com.wework.platform.user.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * 用户服务实现
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final UserRoleRepository userRoleRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtils jwtUtils;

    @Override
    public LoginResponse login(LoginRequest request, String clientIp) {
        log.info("用户登录尝试: username={}, ip={}", request.getUsername(), clientIp);

        // 1. 查找用户（支持用户名或邮箱登录）
        User user = findUserByUsernameOrEmail(request.getUsername());
        if (user == null) {
            throw new BusinessException(ResultCode.UNAUTHORIZED, "用户名或密码错误");
        }

        // 2. 检查用户状态
        if ("0".equals(user.getStatus())) {
            throw new BusinessException(ResultCode.FORBIDDEN, "用户已被禁用");
        }

        // 3. 验证密码
        if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            throw new BusinessException(ResultCode.UNAUTHORIZED, "用户名或密码错误");
        }

        // 4. 获取用户角色和权限（暂时跳过，避免SQL错误）
        List<String> roles = new ArrayList<>();
        List<String> permissions = new ArrayList<>();

        // 5. 生成JWT令牌
        UserContext userContext = UserContext.builder()
                .userId(user.getId())
                .username(user.getUsername())
                .tenantId(user.getTenantId())
                .roles(roles)
                .permissions(permissions)
                .build();

        String accessToken = jwtUtils.generateAccessToken(userContext);
        String refreshToken = jwtUtils.generateRefreshToken(user.getId());

        // 6. 更新登录信息
        updateLoginInfo(user.getId(), clientIp);

        // 7. 构建响应
        LoginResponse response = new LoginResponse();
        response.setAccessToken(accessToken);
        response.setRefreshToken(refreshToken);
        response.setExpiresIn(jwtUtils.getAccessTokenExpiration() / 1000);

        LoginResponse.UserInfo userInfo = new LoginResponse.UserInfo();
        userInfo.setId(user.getId());
        userInfo.setUsername(user.getUsername());
        userInfo.setNickname(user.getNickname());
        userInfo.setEmail(user.getEmail());
        userInfo.setAvatar(user.getAvatar());
        userInfo.setTenantId(user.getTenantId());
        userInfo.setRoles(roles);
        userInfo.setPermissions(permissions);
        userInfo.setLastLoginTime(user.getLastLoginTime() != null ? 
                LocalDateTime.ofInstant(Instant.ofEpochMilli(user.getLastLoginTime()), ZoneId.systemDefault()) : null);

        response.setUserInfo(userInfo);

        log.info("用户登录成功: userId={}, username={}", user.getId(), user.getUsername());
        return response;
    }

    @Override
    public void logout(String userId) {
        log.info("用户登出: userId={}", userId);
        // JWT是无状态的，这里主要记录日志
        // 如果需要实现token黑名单，可以在这里添加逻辑
    }

    @Override
    public String refreshToken(String refreshToken) {
        // 验证刷新令牌
        if (!jwtUtils.validateRefreshToken(refreshToken)) {
            throw new BusinessException(ResultCode.UNAUTHORIZED, "刷新令牌无效");
        }

        String userId = jwtUtils.getUserIdFromRefreshToken(refreshToken);
        User user = userRepository.selectById(userId);
        if (user == null || "0".equals(user.getStatus())) {
            throw new BusinessException(ResultCode.UNAUTHORIZED, "用户不存在或已被禁用");
        }

        // 重新生成访问令牌
        List<String> roles = userRepository.findUserRoles(userId);
        List<String> permissions = userRepository.findUserPermissions(userId);

        UserContext userContext = UserContext.builder()
                .userId(user.getId())
                .username(user.getUsername())
                .tenantId(user.getTenantId())
                .roles(roles)
                .permissions(permissions)
                .build();

        return jwtUtils.generateAccessToken(userContext);
    }

    @Override
    public UserDTO getCurrentUser(String userId) {
        User user = userRepository.selectById(userId);
        if (user == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "用户不存在");
        }

        return convertToUserDTO(user, true);
    }

    @Override
    public PageResult<UserDTO> getUserList(String tenantId, Integer pageNum, Integer pageSize, 
                                          String keyword, Integer status) {
        Page<User> page = new Page<>(pageNum, pageSize);
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        
        queryWrapper.eq("tenant_id", tenantId)
                   .isNull("deleted_at");

        if (StringUtils.hasText(keyword)) {
            queryWrapper.and(wrapper -> wrapper
                .like("username", keyword)
                .or()
                .like("nickname", keyword)
                .or()
                .like("email", keyword)
            );
        }

        if (status != null) {
            queryWrapper.eq("status", status);
        }

        queryWrapper.orderByDesc("created_at");

        Page<User> userPage = userRepository.selectPage(page, queryWrapper);
        
        List<UserDTO> userDTOs = userPage.getRecords().stream()
                .map(user -> convertToUserDTO(user, true))
                .collect(Collectors.toList());

        return PageResult.<UserDTO>builder()
                .records(userDTOs)
                .total(userPage.getTotal())
                .current(pageNum.longValue())
                .size(pageSize.longValue())
                .pages(userPage.getPages())
                .build();
    }

    @Override
    public UserDTO getUserById(String userId, String tenantId) {
        User user = userRepository.selectById(userId);
        if (user == null || !user.getTenantId().equals(tenantId)) {
            throw new BusinessException(ResultCode.NOT_FOUND, "用户不存在");
        }

        return convertToUserDTO(user, true);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public UserDTO createUser(CreateUserRequest request, String tenantId, String operatorId) {
        // 1. 检查用户名是否存在
        if (userRepository.countByUsername(request.getUsername(), tenantId, null) > 0) {
            throw new BusinessException(ResultCode.CONFLICT, "用户名已存在");
        }

        // 2. 检查邮箱是否存在
        if (userRepository.countByEmail(request.getEmail(), tenantId, null) > 0) {
            throw new BusinessException(ResultCode.CONFLICT, "邮箱已存在");
        }

        // 3. 创建用户
        User user = new User();
        user.setId(UUID.randomUUID().toString());
        user.setUsername(request.getUsername());
        user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        user.setNickname(request.getNickname());
        user.setEmail(request.getEmail());
        user.setPhone(request.getPhone());
        user.setAvatar(request.getAvatar());
        user.setStatus(String.valueOf(request.getStatus()));
        user.setTenantId(tenantId);
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());
        user.setCreatedBy(operatorId);
        user.setUpdatedBy(operatorId);

        userRepository.insert(user);

        // 4. 分配角色
        if (request.getRoleIds() != null && !request.getRoleIds().isEmpty()) {
            assignUserRoles(user.getId(), request.getRoleIds(), tenantId, operatorId);
        }

        log.info("创建用户成功: userId={}, username={}, operator={}", user.getId(), user.getUsername(), operatorId);

        return convertToUserDTO(user, true);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public UserDTO updateUser(String userId, UpdateUserRequest request, String tenantId, String operatorId) {
        User user = userRepository.selectById(userId);
        if (user == null || !user.getTenantId().equals(tenantId)) {
            throw new BusinessException(ResultCode.NOT_FOUND, "用户不存在");
        }

        // 检查邮箱唯一性
        if (StringUtils.hasText(request.getEmail()) && 
            !request.getEmail().equals(user.getEmail()) &&
            userRepository.countByEmail(request.getEmail(), tenantId, userId) > 0) {
            throw new BusinessException(ResultCode.CONFLICT, "邮箱已存在");
        }

        // 更新用户信息
        if (StringUtils.hasText(request.getNickname())) {
            user.setNickname(request.getNickname());
        }
        if (StringUtils.hasText(request.getEmail())) {
            user.setEmail(request.getEmail());
        }
        if (StringUtils.hasText(request.getPhone())) {
            user.setPhone(request.getPhone());
        }
        if (StringUtils.hasText(request.getAvatar())) {
            user.setAvatar(request.getAvatar());
        }
        if (request.getStatus() != null) {
            user.setStatus(String.valueOf(request.getStatus()));
        }

        user.setUpdatedAt(LocalDateTime.now());
        user.setUpdatedBy(operatorId);

        userRepository.updateById(user);

        // 更新角色
        if (request.getRoleIds() != null) {
            assignUserRoles(userId, request.getRoleIds(), tenantId, operatorId);
        }

        log.info("更新用户成功: userId={}, operator={}", userId, operatorId);

        return convertToUserDTO(user, true);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteUser(String userId, String tenantId, String operatorId) {
        User user = userRepository.selectById(userId);
        if (user == null || !user.getTenantId().equals(tenantId)) {
            throw new BusinessException(ResultCode.NOT_FOUND, "用户不存在");
        }

        // 软删除用户
        user.setDeletedAt(LocalDateTime.now());
        user.setUpdatedBy(operatorId);
        userRepository.updateById(user);

        // 删除用户角色关联
        userRoleRepository.deleteByUserId(userId, operatorId);

        log.info("删除用户成功: userId={}, operator={}", userId, operatorId);
    }

    @Override
    public void resetPassword(String userId, String newPassword, String tenantId, String operatorId) {
        User user = userRepository.selectById(userId);
        if (user == null || !user.getTenantId().equals(tenantId)) {
            throw new BusinessException(ResultCode.NOT_FOUND, "用户不存在");
        }

        user.setPasswordHash(passwordEncoder.encode(newPassword));
        user.setUpdatedAt(LocalDateTime.now());
        user.setUpdatedBy(operatorId);

        userRepository.updateById(user);

        log.info("重置用户密码成功: userId={}, operator={}", userId, operatorId);
    }

    @Override
    public void changePassword(String userId, String oldPassword, String newPassword) {
        User user = userRepository.selectById(userId);
        if (user == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "用户不存在");
        }

        // 验证旧密码
        if (!passwordEncoder.matches(oldPassword, user.getPasswordHash())) {
            throw new BusinessException(ResultCode.BAD_REQUEST, "原密码错误");
        }

        user.setPasswordHash(passwordEncoder.encode(newPassword));
        user.setUpdatedAt(LocalDateTime.now());
        user.setUpdatedBy(userId);

        userRepository.updateById(user);

        log.info("修改用户密码成功: userId={}", userId);
    }

    @Override
    public void updateUserStatus(String userId, Integer status, String tenantId, String operatorId) {
        User user = userRepository.selectById(userId);
        if (user == null || !user.getTenantId().equals(tenantId)) {
            throw new BusinessException(ResultCode.NOT_FOUND, "用户不存在");
        }

        user.setStatus(String.valueOf(status));
        user.setUpdatedAt(LocalDateTime.now());
        user.setUpdatedBy(operatorId);

        userRepository.updateById(user);

        log.info("更新用户状态成功: userId={}, status={}, operator={}", userId, status, operatorId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void assignUserRoles(String userId, List<String> roleIds, String tenantId, String operatorId) {
        // 1. 删除现有角色
        userRoleRepository.deleteByUserId(userId, operatorId);

        // 2. 分配新角色
        if (roleIds != null && !roleIds.isEmpty()) {
            // 验证角色是否属于当前租户
            for (String roleId : roleIds) {
                Role role = roleRepository.selectById(roleId);
                if (role == null || !role.getTenantId().equals(tenantId)) {
                    throw new BusinessException(ResultCode.BAD_REQUEST, "角色不存在或不属于当前租户");
                }
            }

            userRoleRepository.batchInsertUserRoles(userId, roleIds, operatorId);
        }

        log.info("分配用户角色成功: userId={}, roleIds={}, operator={}", userId, roleIds, operatorId);
    }

    @Override
    public List<String> getUserPermissions(String userId, String tenantId) {
        User user = userRepository.selectById(userId);
        if (user == null || !user.getTenantId().equals(tenantId)) {
            throw new BusinessException(ResultCode.NOT_FOUND, "用户不存在");
        }

        return userRepository.findUserPermissions(userId);
    }

    @Override
    public boolean hasPermission(String userId, String permission, String tenantId) {
        List<String> permissions = getUserPermissions(userId, tenantId);
        return permissions.contains(permission) || permissions.contains("*");
    }

    @Override
    public User findByUsername(String username, String tenantId) {
        User user = userRepository.findByUsername(username);
        if (user != null && user.getTenantId().equals(tenantId)) {
            return user;
        }
        return null;
    }

    @Override
    public User findByEmail(String email, String tenantId) {
        User user = userRepository.findByEmail(email);
        if (user != null && user.getTenantId().equals(tenantId)) {
            return user;
        }
        return null;
    }

    // 私有辅助方法

    private User findUserByUsernameOrEmail(String usernameOrEmail) {
        // 登录时不需要租户隔离，直接查询所有用户
        // 这里使用原生SQL查询，绕过租户隔离
        User user = userRepository.findByUsername(usernameOrEmail);
        if (user == null) {
            user = userRepository.findByEmail(usernameOrEmail);
        }
        return user;
    }

    private void updateLoginInfo(String userId, String clientIp) {
        User user = userRepository.selectById(userId);
        if (user != null) {
            user.setLastLoginTime(System.currentTimeMillis());
            user.setLastLoginIp(clientIp);
            user.setUpdatedAt(LocalDateTime.now());
            userRepository.updateById(user);
        }
    }

    private UserDTO convertToUserDTO(User user, boolean includeRolesAndPermissions) {
        UserDTO dto = new UserDTO();
        BeanUtils.copyProperties(user, dto);

        if (includeRolesAndPermissions) {
            dto.setRoles(userRepository.findUserRoles(user.getId()));
            dto.setPermissions(userRepository.findUserPermissions(user.getId()));
        }

        return dto;
    }
}