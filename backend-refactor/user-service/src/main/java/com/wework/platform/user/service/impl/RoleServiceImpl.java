package com.wework.platform.user.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.common.core.exception.BusinessException;
import com.wework.platform.common.enums.ResultCode;
import com.wework.platform.user.dto.RoleDTO;
import com.wework.platform.user.entity.Permission;
import com.wework.platform.user.entity.Role;
import com.wework.platform.user.repository.PermissionRepository;
import com.wework.platform.user.repository.RolePermissionRepository;
import com.wework.platform.user.repository.RoleRepository;
import com.wework.platform.user.service.RoleService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * 角色服务实现
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class RoleServiceImpl implements RoleService {

    private final RoleRepository roleRepository;
    private final PermissionRepository permissionRepository;
    private final RolePermissionRepository rolePermissionRepository;

    @Override
    public PageResult<RoleDTO> getRoleList(String tenantId, Integer pageNum, Integer pageSize, String keyword) {
        Page<Role> page = new Page<>(pageNum, pageSize);
        QueryWrapper<Role> queryWrapper = new QueryWrapper<>();
        
        queryWrapper.eq("tenant_id", tenantId)
                   .isNull("deleted_at");

        if (StringUtils.hasText(keyword)) {
            queryWrapper.and(wrapper -> wrapper
                .like("role_code", keyword)
                .or()
                .like("role_name", keyword)
            );
        }

        queryWrapper.orderByAsc("sort_order").orderByDesc("created_at");

        Page<Role> rolePage = roleRepository.selectPage(page, queryWrapper);
        
        List<RoleDTO> roleDTOs = rolePage.getRecords().stream()
                .map(this::convertToRoleDTO)
                .collect(Collectors.toList());

        return PageResult.<RoleDTO>builder()
                .records(roleDTOs)
                .total(rolePage.getTotal())
                .pageNum(pageNum)
                .pageSize(pageSize)
                .pages((int) rolePage.getPages())
                .build();
    }

    @Override
    public List<RoleDTO> getAllRoles(String tenantId) {
        List<Role> roles = roleRepository.findAllByTenantId(tenantId);
        return roles.stream()
                .map(this::convertToRoleDTO)
                .collect(Collectors.toList());
    }

    @Override
    public RoleDTO getRoleById(String roleId, String tenantId) {
        Role role = roleRepository.selectById(roleId);
        if (role == null || !role.getTenantId().equals(tenantId)) {
            throw new BusinessException(ResultCode.NOT_FOUND, "角色不存在");
        }

        return convertToRoleDTO(role);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public RoleDTO createRole(String roleCode, String roleName, String description, Integer sortOrder, 
                             String tenantId, String operatorId) {
        // 检查角色代码是否存在
        if (roleRepository.countByRoleCode(roleCode, tenantId, null) > 0) {
            throw new BusinessException(ResultCode.CONFLICT, "角色代码已存在");
        }

        Role role = new Role();
        role.setId(UUID.randomUUID().toString());
        role.setRoleCode(roleCode);
        role.setRoleName(roleName);
        role.setDescription(description);
        role.setSortOrder(sortOrder != null ? sortOrder : 0);
        role.setTenantId(tenantId);
        role.setCreatedAt(LocalDateTime.now());
        role.setUpdatedAt(LocalDateTime.now());
        role.setCreatedBy(operatorId);
        role.setUpdatedBy(operatorId);

        roleRepository.insert(role);

        log.info("创建角色成功: roleId={}, roleCode={}, operator={}", role.getId(), roleCode, operatorId);

        return convertToRoleDTO(role);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public RoleDTO updateRole(String roleId, String roleName, String description, Integer sortOrder, 
                             String tenantId, String operatorId) {
        Role role = roleRepository.selectById(roleId);
        if (role == null || !role.getTenantId().equals(tenantId)) {
            throw new BusinessException(ResultCode.NOT_FOUND, "角色不存在");
        }

        // 更新角色信息
        if (StringUtils.hasText(roleName)) {
            role.setRoleName(roleName);
        }
        if (StringUtils.hasText(description)) {
            role.setDescription(description);
        }
        if (sortOrder != null) {
            role.setSortOrder(sortOrder);
        }

        role.setUpdatedAt(LocalDateTime.now());
        role.setUpdatedBy(operatorId);

        roleRepository.updateById(role);

        log.info("更新角色成功: roleId={}, operator={}", roleId, operatorId);

        return convertToRoleDTO(role);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteRole(String roleId, String tenantId, String operatorId) {
        Role role = roleRepository.selectById(roleId);
        if (role == null || !role.getTenantId().equals(tenantId)) {
            throw new BusinessException(ResultCode.NOT_FOUND, "角色不存在");
        }

        // 检查是否有用户使用该角色
        int userCount = roleRepository.countRoleUsers(roleId);
        if (userCount > 0) {
            throw new BusinessException(ResultCode.CONFLICT, "该角色下还有用户，无法删除");
        }

        // 软删除角色
        role.setDeletedAt(LocalDateTime.now());
        role.setUpdatedBy(operatorId);
        roleRepository.updateById(role);

        // 删除角色权限关联
        rolePermissionRepository.deleteByRoleId(roleId, operatorId);

        log.info("删除角色成功: roleId={}, operator={}", roleId, operatorId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void assignRolePermissions(String roleId, List<String> permissionIds, String tenantId, String operatorId) {
        Role role = roleRepository.selectById(roleId);
        if (role == null || !role.getTenantId().equals(tenantId)) {
            throw new BusinessException(ResultCode.NOT_FOUND, "角色不存在");
        }

        // 1. 删除现有权限
        rolePermissionRepository.deleteByRoleId(roleId, operatorId);

        // 2. 分配新权限
        if (permissionIds != null && !permissionIds.isEmpty()) {
            // 验证权限是否存在
            for (String permissionId : permissionIds) {
                Permission permission = permissionRepository.selectById(permissionId);
                if (permission == null) {
                    throw new BusinessException(ResultCode.BAD_REQUEST, "权限不存在: " + permissionId);
                }
            }

            rolePermissionRepository.batchInsertRolePermissions(roleId, permissionIds, operatorId);
        }

        log.info("分配角色权限成功: roleId={}, permissionIds={}, operator={}", roleId, permissionIds, operatorId);
    }

    @Override
    public List<String> getRolePermissions(String roleId, String tenantId) {
        Role role = roleRepository.selectById(roleId);
        if (role == null || !role.getTenantId().equals(tenantId)) {
            throw new BusinessException(ResultCode.NOT_FOUND, "角色不存在");
        }

        return roleRepository.findRolePermissions(roleId);
    }

    @Override
    public Role findByRoleCode(String roleCode, String tenantId) {
        return roleRepository.findByRoleCode(roleCode, tenantId);
    }

    // 私有辅助方法

    private RoleDTO convertToRoleDTO(Role role) {
        RoleDTO dto = new RoleDTO();
        BeanUtils.copyProperties(role, dto);

        // 获取权限列表
        dto.setPermissions(roleRepository.findRolePermissions(role.getId()));

        // 获取用户数量
        dto.setUserCount(roleRepository.countRoleUsers(role.getId()));

        return dto;
    }
}