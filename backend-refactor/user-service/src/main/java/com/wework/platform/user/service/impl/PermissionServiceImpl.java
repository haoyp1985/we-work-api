package com.wework.platform.user.service.impl;

import com.wework.platform.common.core.exception.BusinessException;
import com.wework.platform.common.enums.ResultCode;
import com.wework.platform.user.dto.PermissionDTO;
import com.wework.platform.user.entity.Permission;
import com.wework.platform.user.repository.PermissionRepository;
import com.wework.platform.user.repository.RolePermissionRepository;
import com.wework.platform.user.service.PermissionService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * 权限服务实现
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class PermissionServiceImpl implements PermissionService {

    private final PermissionRepository permissionRepository;
    private final RolePermissionRepository rolePermissionRepository;

    @Override
    public List<PermissionDTO> getAllPermissions() {
        List<Permission> permissions = permissionRepository.findAll();
        return permissions.stream()
                .map(this::convertToPermissionDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<PermissionDTO> getPermissionTree() {
        List<Permission> allPermissions = permissionRepository.findAll();
        return buildPermissionTree(allPermissions, null);
    }

    @Override
    public List<PermissionDTO> getPermissionsByType(String permissionType) {
        List<Permission> permissions = permissionRepository.findByPermissionType(permissionType);
        return permissions.stream()
                .map(this::convertToPermissionDTO)
                .collect(Collectors.toList());
    }

    @Override
    public PermissionDTO getPermissionById(String permissionId) {
        Permission permission = permissionRepository.selectById(permissionId);
        if (permission == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "权限不存在");
        }

        return convertToPermissionDTO(permission);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public PermissionDTO createPermission(String permissionCode, String permissionName, String permissionType,
                                         String parentId, String path, String component, String icon,
                                         Integer sortOrder, String operatorId) {
        // 检查权限代码是否存在
        if (permissionRepository.countByPermissionCode(permissionCode, null) > 0) {
            throw new BusinessException(ResultCode.CONFLICT, "权限代码已存在");
        }

        // 验证父权限是否存在
        if (StringUtils.hasText(parentId)) {
            Permission parentPermission = permissionRepository.selectById(parentId);
            if (parentPermission == null) {
                throw new BusinessException(ResultCode.BAD_REQUEST, "父权限不存在");
            }
        }

        Permission permission = new Permission();
        permission.setId(UUID.randomUUID().toString());
        permission.setPermissionCode(permissionCode);
        permission.setPermissionName(permissionName);
        permission.setPermissionType(permissionType);
        permission.setParentId(StringUtils.hasText(parentId) ? parentId : null);
        permission.setPath(path);
        permission.setComponent(component);
        permission.setIcon(icon);
        permission.setSortOrder(sortOrder != null ? sortOrder : 0);
        permission.setCreatedAt(LocalDateTime.now());
        permission.setUpdatedAt(LocalDateTime.now());
        permission.setCreatedBy(operatorId);
        permission.setUpdatedBy(operatorId);

        permissionRepository.insert(permission);

        log.info("创建权限成功: permissionId={}, permissionCode={}, operator={}", 
                permission.getId(), permissionCode, operatorId);

        return convertToPermissionDTO(permission);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public PermissionDTO updatePermission(String permissionId, String permissionName, String permissionType,
                                         String parentId, String path, String component, String icon,
                                         Integer sortOrder, String operatorId) {
        Permission permission = permissionRepository.selectById(permissionId);
        if (permission == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "权限不存在");
        }

        // 验证父权限是否存在（避免循环引用）
        if (StringUtils.hasText(parentId) && !parentId.equals(permissionId)) {
            Permission parentPermission = permissionRepository.selectById(parentId);
            if (parentPermission == null) {
                throw new BusinessException(ResultCode.BAD_REQUEST, "父权限不存在");
            }
            // 检查循环引用
            if (isCircularReference(permissionId, parentId)) {
                throw new BusinessException(ResultCode.BAD_REQUEST, "不能设置子权限为父权限");
            }
        }

        // 更新权限信息
        if (StringUtils.hasText(permissionName)) {
            permission.setPermissionName(permissionName);
        }
        if (StringUtils.hasText(permissionType)) {
            permission.setPermissionType(permissionType);
        }
        if (parentId != null) {
            permission.setParentId(StringUtils.hasText(parentId) ? parentId : null);
        }
        if (StringUtils.hasText(path)) {
            permission.setPath(path);
        }
        if (StringUtils.hasText(component)) {
            permission.setComponent(component);
        }
        if (StringUtils.hasText(icon)) {
            permission.setIcon(icon);
        }
        if (sortOrder != null) {
            permission.setSortOrder(sortOrder);
        }

        permission.setUpdatedAt(LocalDateTime.now());
        permission.setUpdatedBy(operatorId);

        permissionRepository.updateById(permission);

        log.info("更新权限成功: permissionId={}, operator={}", permissionId, operatorId);

        return convertToPermissionDTO(permission);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deletePermission(String permissionId, String operatorId) {
        Permission permission = permissionRepository.selectById(permissionId);
        if (permission == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "权限不存在");
        }

        // 检查是否有子权限
        List<Permission> children = permissionRepository.findByParentId(permissionId);
        if (!children.isEmpty()) {
            throw new BusinessException(ResultCode.CONFLICT, "该权限下还有子权限，无法删除");
        }

        // 检查是否有角色使用该权限
        int roleCount = permissionRepository.countPermissionRoles(permissionId);
        if (roleCount > 0) {
            throw new BusinessException(ResultCode.CONFLICT, "该权限还有角色在使用，无法删除");
        }

        // 软删除权限
        permission.setDeletedAt(LocalDateTime.now());
        permission.setUpdatedBy(operatorId);
        permissionRepository.updateById(permission);

        // 删除权限角色关联
        rolePermissionRepository.deleteByPermissionId(permissionId, operatorId);

        log.info("删除权限成功: permissionId={}, operator={}", permissionId, operatorId);
    }

    @Override
    public Permission findByPermissionCode(String permissionCode) {
        return permissionRepository.findByPermissionCode(permissionCode);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void initializeDefaultPermissions(String operatorId) {
        log.info("开始初始化系统默认权限...");

        // 定义默认权限结构
        List<PermissionData> defaultPermissions = getDefaultPermissions();

        for (PermissionData permissionData : defaultPermissions) {
            Permission existingPermission = findByPermissionCode(permissionData.getCode());
            if (existingPermission == null) {
                createPermission(
                        permissionData.getCode(),
                        permissionData.getName(),
                        permissionData.getType(),
                        permissionData.getParentCode() != null ? 
                            findByPermissionCode(permissionData.getParentCode()).getId() : null,
                        permissionData.getPath(),
                        permissionData.getComponent(),
                        permissionData.getIcon(),
                        permissionData.getSortOrder(),
                        operatorId
                );
                log.info("创建默认权限: {}", permissionData.getCode());
            }
        }

        log.info("系统默认权限初始化完成");
    }

    // 私有辅助方法

    private PermissionDTO convertToPermissionDTO(Permission permission) {
        PermissionDTO dto = new PermissionDTO();
        BeanUtils.copyProperties(permission, dto);

        // 获取角色数量
        dto.setRoleCount(permissionRepository.countPermissionRoles(permission.getId()));

        return dto;
    }

    private List<PermissionDTO> buildPermissionTree(List<Permission> allPermissions, String parentId) {
        List<PermissionDTO> result = new ArrayList<>();

        for (Permission permission : allPermissions) {
            if ((parentId == null && permission.getParentId() == null) ||
                (parentId != null && parentId.equals(permission.getParentId()))) {
                
                PermissionDTO dto = convertToPermissionDTO(permission);
                dto.setChildren(buildPermissionTree(allPermissions, permission.getId()));
                result.add(dto);
            }
        }

        return result;
    }

    private boolean isCircularReference(String permissionId, String parentId) {
        if (parentId == null || parentId.equals(permissionId)) {
            return false;
        }

        Permission parent = permissionRepository.selectById(parentId);
        if (parent == null) {
            return false;
        }

        // 递归检查是否存在循环引用
        return isCircularReference(permissionId, parent.getParentId());
    }

    private List<PermissionData> getDefaultPermissions() {
        List<PermissionData> permissions = new ArrayList<>();

        // 系统管理
        permissions.add(new PermissionData("system", "系统管理", "menu", null, "/system", null, "system", 1));
        permissions.add(new PermissionData("system:user", "用户管理", "menu", "system", "/system/user", "system/UserManagement", "user", 1));
        permissions.add(new PermissionData("system:role", "角色管理", "menu", "system", "/system/role", "system/RoleManagement", "role", 2));
        permissions.add(new PermissionData("system:permission", "权限管理", "menu", "system", "/system/permission", "system/PermissionManagement", "permission", 3));

        // 账号管理
        permissions.add(new PermissionData("account", "账号管理", "menu", null, "/account", null, "account", 2));
        permissions.add(new PermissionData("account:list", "账号列表", "menu", "account", "/account/list", "account/AccountList", "list", 1));
        permissions.add(new PermissionData("account:create", "创建账号", "button", "account", null, null, null, 2));
        permissions.add(new PermissionData("account:update", "更新账号", "button", "account", null, null, null, 3));
        permissions.add(new PermissionData("account:delete", "删除账号", "button", "account", null, null, null, 4));

        // 消息管理
        permissions.add(new PermissionData("message", "消息管理", "menu", null, "/message", null, "message", 3));
        permissions.add(new PermissionData("message:send", "发送消息", "menu", "message", "/message/send", "message/MessageSend", "send", 1));
        permissions.add(new PermissionData("message:template", "消息模板", "menu", "message", "/message/template", "message/MessageTemplate", "template", 2));
        permissions.add(new PermissionData("message:history", "发送记录", "menu", "message", "/message/history", "message/MessageHistory", "history", 3));

        // 系统监控
        permissions.add(new PermissionData("monitor", "系统监控", "menu", null, "/monitor", null, "monitor", 4));
        permissions.add(new PermissionData("monitor:performance", "性能监控", "menu", "monitor", "/monitor/performance", "monitor/Performance", "performance", 1));
        permissions.add(new PermissionData("monitor:alerts", "告警管理", "menu", "monitor", "/monitor/alerts", "monitor/Alerts", "alert", 2));
        permissions.add(new PermissionData("monitor:logs", "日志查看", "menu", "monitor", "/monitor/logs", "monitor/Logs", "log", 3));

        return permissions;
    }

    // 权限数据内部类
    private static class PermissionData {
        private String code;
        private String name;
        private String type;
        private String parentCode;
        private String path;
        private String component;
        private String icon;
        private Integer sortOrder;

        public PermissionData(String code, String name, String type, String parentCode, 
                             String path, String component, String icon, Integer sortOrder) {
            this.code = code;
            this.name = name;
            this.type = type;
            this.parentCode = parentCode;
            this.path = path;
            this.component = component;
            this.icon = icon;
            this.sortOrder = sortOrder;
        }

        // Getters
        public String getCode() { return code; }
        public String getName() { return name; }
        public String getType() { return type; }
        public String getParentCode() { return parentCode; }
        public String getPath() { return path; }
        public String getComponent() { return component; }
        public String getIcon() { return icon; }
        public Integer getSortOrder() { return sortOrder; }
    }
}