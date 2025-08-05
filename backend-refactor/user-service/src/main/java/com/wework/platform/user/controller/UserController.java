package com.wework.platform.user.controller;

import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.common.core.base.Result;
import com.wework.platform.common.security.UserContext;
import com.wework.platform.common.security.UserContextHolder;
import com.wework.platform.user.dto.CreateUserRequest;
import com.wework.platform.user.dto.UpdateUserRequest;
import com.wework.platform.user.dto.UserDTO;
import com.wework.platform.user.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 用户管理控制器
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
@Tag(name = "用户管理", description = "用户管理相关接口")
public class UserController {

    private final UserService userService;

    @Operation(summary = "分页查询用户列表", description = "根据条件分页查询用户列表")
    @GetMapping
    public Result<PageResult<UserDTO>> getUserList(
            @Parameter(description = "页码") @RequestParam(defaultValue = "1") Integer pageNum,
            @Parameter(description = "页大小") @RequestParam(defaultValue = "20") Integer pageSize,
            @Parameter(description = "关键词") @RequestParam(required = false) String keyword,
            @Parameter(description = "状态") @RequestParam(required = false) Integer status) {
        
        UserContext userContext = UserContextHolder.getContext();
        PageResult<UserDTO> result = userService.getUserList(
                userContext.getTenantId(), pageNum, pageSize, keyword, status);
        return Result.success(result);
    }

    @Operation(summary = "根据ID获取用户详情", description = "根据用户ID获取用户详细信息")
    @GetMapping("/{userId}")
    public Result<UserDTO> getUserById(@Parameter(description = "用户ID") @PathVariable String userId) {
        UserContext userContext = UserContextHolder.getContext();
        UserDTO userDTO = userService.getUserById(userId, userContext.getTenantId());
        return Result.success(userDTO);
    }

    @Operation(summary = "创建用户", description = "创建新用户")
    @PostMapping
    public Result<UserDTO> createUser(@Valid @RequestBody CreateUserRequest request) {
        UserContext userContext = UserContextHolder.getContext();
        UserDTO userDTO = userService.createUser(request, userContext.getTenantId(), userContext.getUserId());
        return Result.success(userDTO);
    }

    @Operation(summary = "更新用户", description = "更新用户信息")
    @PutMapping("/{userId}")
    public Result<UserDTO> updateUser(@Parameter(description = "用户ID") @PathVariable String userId,
                                     @Valid @RequestBody UpdateUserRequest request) {
        UserContext userContext = UserContextHolder.getContext();
        UserDTO userDTO = userService.updateUser(userId, request, userContext.getTenantId(), userContext.getUserId());
        return Result.success(userDTO);
    }

    @Operation(summary = "删除用户", description = "删除指定用户")
    @DeleteMapping("/{userId}")
    public Result<Void> deleteUser(@Parameter(description = "用户ID") @PathVariable String userId) {
        UserContext userContext = UserContextHolder.getContext();
        userService.deleteUser(userId, userContext.getTenantId(), userContext.getUserId());
        return Result.success();
    }

    @Operation(summary = "重置用户密码", description = "管理员重置用户密码")
    @PostMapping("/{userId}/reset-password")
    public Result<Void> resetPassword(@Parameter(description = "用户ID") @PathVariable String userId,
                                     @Parameter(description = "新密码") @RequestParam String newPassword) {
        UserContext userContext = UserContextHolder.getContext();
        userService.resetPassword(userId, newPassword, userContext.getTenantId(), userContext.getUserId());
        return Result.success();
    }

    @Operation(summary = "启用/禁用用户", description = "启用或禁用指定用户")
    @PostMapping("/{userId}/status")
    public Result<Void> updateUserStatus(@Parameter(description = "用户ID") @PathVariable String userId,
                                        @Parameter(description = "状态") @RequestParam Integer status) {
        UserContext userContext = UserContextHolder.getContext();
        userService.updateUserStatus(userId, status, userContext.getTenantId(), userContext.getUserId());
        return Result.success();
    }

    @Operation(summary = "分配用户角色", description = "为用户分配角色")
    @PostMapping("/{userId}/roles")
    public Result<Void> assignUserRoles(@Parameter(description = "用户ID") @PathVariable String userId,
                                       @Parameter(description = "角色ID列表") @RequestBody List<String> roleIds) {
        UserContext userContext = UserContextHolder.getContext();
        userService.assignUserRoles(userId, roleIds, userContext.getTenantId(), userContext.getUserId());
        return Result.success();
    }

    @Operation(summary = "获取用户权限", description = "获取指定用户的权限列表")
    @GetMapping("/{userId}/permissions")
    public Result<List<String>> getUserPermissions(@Parameter(description = "用户ID") @PathVariable String userId) {
        UserContext userContext = UserContextHolder.getContext();
        List<String> permissions = userService.getUserPermissions(userId, userContext.getTenantId());
        return Result.success(permissions);
    }

    @Operation(summary = "检查用户权限", description = "检查用户是否具有指定权限")
    @GetMapping("/{userId}/permissions/{permission}/check")
    public Result<Boolean> checkUserPermission(@Parameter(description = "用户ID") @PathVariable String userId,
                                              @Parameter(description = "权限代码") @PathVariable String permission) {
        UserContext userContext = UserContextHolder.getContext();
        boolean hasPermission = userService.hasPermission(userId, permission, userContext.getTenantId());
        return Result.success(hasPermission);
    }
}