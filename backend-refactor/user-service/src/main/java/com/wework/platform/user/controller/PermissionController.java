package com.wework.platform.user.controller;

import com.wework.platform.common.core.base.Result;
import com.wework.platform.common.security.UserContext;
import com.wework.platform.common.security.UserContextHolder;
import com.wework.platform.user.dto.PermissionDTO;
import com.wework.platform.user.service.PermissionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.constraints.NotBlank;
import java.util.List;

/**
 * 权限管理控制器
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@RestController
@RequestMapping("/permissions")
@RequiredArgsConstructor
@Tag(name = "权限管理", description = "权限管理相关接口")
public class PermissionController {

    private final PermissionService permissionService;

    @Operation(summary = "查询所有权限", description = "查询所有权限（平铺列表）")
    @GetMapping
    public Result<List<PermissionDTO>> getAllPermissions() {
        List<PermissionDTO> permissions = permissionService.getAllPermissions();
        return Result.success(permissions);
    }

    @Operation(summary = "查询权限树", description = "查询权限树结构")
    @GetMapping("/tree")
    public Result<List<PermissionDTO>> getPermissionTree() {
        List<PermissionDTO> permissionTree = permissionService.getPermissionTree();
        return Result.success(permissionTree);
    }

    @Operation(summary = "根据类型查询权限", description = "根据权限类型查询权限列表")
    @GetMapping("/type/{permissionType}")
    public Result<List<PermissionDTO>> getPermissionsByType(
            @Parameter(description = "权限类型") @PathVariable String permissionType) {
        List<PermissionDTO> permissions = permissionService.getPermissionsByType(permissionType);
        return Result.success(permissions);
    }

    @Operation(summary = "根据ID获取权限详情", description = "根据权限ID获取权限详细信息")
    @GetMapping("/{permissionId}")
    public Result<PermissionDTO> getPermissionById(@Parameter(description = "权限ID") @PathVariable String permissionId) {
        PermissionDTO permissionDTO = permissionService.getPermissionById(permissionId);
        return Result.success(permissionDTO);
    }

    @Operation(summary = "创建权限", description = "创建新权限")
    @PostMapping
    public Result<PermissionDTO> createPermission(
            @Parameter(description = "权限代码") @RequestParam @NotBlank String permissionCode,
            @Parameter(description = "权限名称") @RequestParam @NotBlank String permissionName,
            @Parameter(description = "权限类型") @RequestParam @NotBlank String permissionType,
            @Parameter(description = "父权限ID") @RequestParam(required = false) String parentId,
            @Parameter(description = "路径") @RequestParam(required = false) String path,
            @Parameter(description = "组件") @RequestParam(required = false) String component,
            @Parameter(description = "图标") @RequestParam(required = false) String icon,
            @Parameter(description = "排序") @RequestParam(required = false, defaultValue = "0") Integer sortOrder) {
        
        UserContext userContext = UserContextHolder.getContext();
        PermissionDTO permissionDTO = permissionService.createPermission(
                permissionCode, permissionName, permissionType, parentId,
                path, component, icon, sortOrder, userContext.getUserId());
        return Result.success(permissionDTO);
    }

    @Operation(summary = "更新权限", description = "更新权限信息")
    @PutMapping("/{permissionId}")
    public Result<PermissionDTO> updatePermission(
            @Parameter(description = "权限ID") @PathVariable String permissionId,
            @Parameter(description = "权限名称") @RequestParam(required = false) String permissionName,
            @Parameter(description = "权限类型") @RequestParam(required = false) String permissionType,
            @Parameter(description = "父权限ID") @RequestParam(required = false) String parentId,
            @Parameter(description = "路径") @RequestParam(required = false) String path,
            @Parameter(description = "组件") @RequestParam(required = false) String component,
            @Parameter(description = "图标") @RequestParam(required = false) String icon,
            @Parameter(description = "排序") @RequestParam(required = false) Integer sortOrder) {
        
        UserContext userContext = UserContextHolder.getContext();
        PermissionDTO permissionDTO = permissionService.updatePermission(
                permissionId, permissionName, permissionType, parentId,
                path, component, icon, sortOrder, userContext.getUserId());
        return Result.success(permissionDTO);
    }

    @Operation(summary = "删除权限", description = "删除指定权限")
    @DeleteMapping("/{permissionId}")
    public Result<Void> deletePermission(@Parameter(description = "权限ID") @PathVariable String permissionId) {
        UserContext userContext = UserContextHolder.getContext();
        permissionService.deletePermission(permissionId, userContext.getUserId());
        return Result.success();
    }

    @Operation(summary = "初始化默认权限", description = "初始化系统默认权限（仅系统管理员可用）")
    @PostMapping("/initialize")
    public Result<Void> initializeDefaultPermissions() {
        UserContext userContext = UserContextHolder.getContext();
        permissionService.initializeDefaultPermissions(userContext.getUserId());
        return Result.success();
    }
}