package com.wework.platform.user.controller;

import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.common.core.base.Result;
import com.wework.platform.common.security.UserContext;
import com.wework.platform.common.security.UserContextHolder;
import com.wework.platform.user.dto.RoleDTO;
import com.wework.platform.user.service.RoleService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import java.util.List;

/**
 * 角色管理控制器
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@RestController
@RequestMapping("/roles")
@RequiredArgsConstructor
@Tag(name = "角色管理", description = "角色管理相关接口")
public class RoleController {

    private final RoleService roleService;

    @Operation(summary = "分页查询角色列表", description = "根据条件分页查询角色列表")
    @GetMapping
    public Result<PageResult<RoleDTO>> getRoleList(
            @Parameter(description = "页码") @RequestParam(defaultValue = "1") Integer pageNum,
            @Parameter(description = "页大小") @RequestParam(defaultValue = "20") Integer pageSize,
            @Parameter(description = "关键词") @RequestParam(required = false) String keyword) {
        
        UserContext userContext = UserContextHolder.getContext();
        PageResult<RoleDTO> result = roleService.getRoleList(
                userContext.getTenantId(), pageNum, pageSize, keyword);
        return Result.success(result);
    }

    @Operation(summary = "查询所有角色", description = "查询所有角色（不分页）")
    @GetMapping("/all")
    public Result<List<RoleDTO>> getAllRoles() {
        UserContext userContext = UserContextHolder.getContext();
        List<RoleDTO> roles = roleService.getAllRoles(userContext.getTenantId());
        return Result.success(roles);
    }

    @Operation(summary = "根据ID获取角色详情", description = "根据角色ID获取角色详细信息")
    @GetMapping("/{roleId}")
    public Result<RoleDTO> getRoleById(@Parameter(description = "角色ID") @PathVariable String roleId) {
        UserContext userContext = UserContextHolder.getContext();
        RoleDTO roleDTO = roleService.getRoleById(roleId, userContext.getTenantId());
        return Result.success(roleDTO);
    }

    @Operation(summary = "创建角色", description = "创建新角色")
    @PostMapping
    public Result<RoleDTO> createRole(@Parameter(description = "角色代码") @RequestParam @NotBlank String roleCode,
                                     @Parameter(description = "角色名称") @RequestParam @NotBlank String roleName,
                                     @Parameter(description = "描述") @RequestParam(required = false) String description,
                                     @Parameter(description = "排序") @RequestParam(required = false, defaultValue = "0") Integer sortOrder) {
        UserContext userContext = UserContextHolder.getContext();
        RoleDTO roleDTO = roleService.createRole(
                roleCode, roleName, description, sortOrder, 
                userContext.getTenantId(), userContext.getUserId());
        return Result.success(roleDTO);
    }

    @Operation(summary = "更新角色", description = "更新角色信息")
    @PutMapping("/{roleId}")
    public Result<RoleDTO> updateRole(@Parameter(description = "角色ID") @PathVariable String roleId,
                                     @Parameter(description = "角色名称") @RequestParam(required = false) String roleName,
                                     @Parameter(description = "描述") @RequestParam(required = false) String description,
                                     @Parameter(description = "排序") @RequestParam(required = false) Integer sortOrder) {
        UserContext userContext = UserContextHolder.getContext();
        RoleDTO roleDTO = roleService.updateRole(
                roleId, roleName, description, sortOrder,
                userContext.getTenantId(), userContext.getUserId());
        return Result.success(roleDTO);
    }

    @Operation(summary = "删除角色", description = "删除指定角色")
    @DeleteMapping("/{roleId}")
    public Result<Void> deleteRole(@Parameter(description = "角色ID") @PathVariable String roleId) {
        UserContext userContext = UserContextHolder.getContext();
        roleService.deleteRole(roleId, userContext.getTenantId(), userContext.getUserId());
        return Result.success();
    }

    @Operation(summary = "分配角色权限", description = "为角色分配权限")
    @PostMapping("/{roleId}/permissions")
    public Result<Void> assignRolePermissions(@Parameter(description = "角色ID") @PathVariable String roleId,
                                             @Parameter(description = "权限ID列表") @RequestBody @NotEmpty List<String> permissionIds) {
        UserContext userContext = UserContextHolder.getContext();
        roleService.assignRolePermissions(
                roleId, permissionIds, userContext.getTenantId(), userContext.getUserId());
        return Result.success();
    }

    @Operation(summary = "获取角色权限", description = "获取指定角色的权限列表")
    @GetMapping("/{roleId}/permissions")
    public Result<List<String>> getRolePermissions(@Parameter(description = "角色ID") @PathVariable String roleId) {
        UserContext userContext = UserContextHolder.getContext();
        List<String> permissions = roleService.getRolePermissions(roleId, userContext.getTenantId());
        return Result.success(permissions);
    }
}