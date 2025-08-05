package com.wework.platform.user.service;

import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.user.dto.RoleDTO;
import com.wework.platform.user.entity.Role;

import java.util.List;

/**
 * 角色服务接口
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
public interface RoleService {

    /**
     * 分页查询角色列表
     * 
     * @param tenantId 租户ID
     * @param pageNum 页码
     * @param pageSize 页大小
     * @param keyword 关键词（角色代码、角色名称）
     * @return 角色列表
     */
    PageResult<RoleDTO> getRoleList(String tenantId, Integer pageNum, Integer pageSize, String keyword);

    /**
     * 查询所有角色（不分页）
     * 
     * @param tenantId 租户ID
     * @return 角色列表
     */
    List<RoleDTO> getAllRoles(String tenantId);

    /**
     * 根据ID获取角色详情
     * 
     * @param roleId 角色ID
     * @param tenantId 租户ID
     * @return 角色详情
     */
    RoleDTO getRoleById(String roleId, String tenantId);

    /**
     * 创建角色
     * 
     * @param roleCode 角色代码
     * @param roleName 角色名称
     * @param description 描述
     * @param sortOrder 排序
     * @param tenantId 租户ID
     * @param operatorId 操作人ID
     * @return 角色信息
     */
    RoleDTO createRole(String roleCode, String roleName, String description, Integer sortOrder, 
                      String tenantId, String operatorId);

    /**
     * 更新角色
     * 
     * @param roleId 角色ID
     * @param roleName 角色名称
     * @param description 描述
     * @param sortOrder 排序
     * @param tenantId 租户ID
     * @param operatorId 操作人ID
     * @return 角色信息
     */
    RoleDTO updateRole(String roleId, String roleName, String description, Integer sortOrder, 
                      String tenantId, String operatorId);

    /**
     * 删除角色
     * 
     * @param roleId 角色ID
     * @param tenantId 租户ID
     * @param operatorId 操作人ID
     */
    void deleteRole(String roleId, String tenantId, String operatorId);

    /**
     * 分配角色权限
     * 
     * @param roleId 角色ID
     * @param permissionIds 权限ID列表
     * @param tenantId 租户ID
     * @param operatorId 操作人ID
     */
    void assignRolePermissions(String roleId, List<String> permissionIds, String tenantId, String operatorId);

    /**
     * 获取角色权限
     * 
     * @param roleId 角色ID
     * @param tenantId 租户ID
     * @return 权限代码列表
     */
    List<String> getRolePermissions(String roleId, String tenantId);

    /**
     * 根据角色代码查找角色
     * 
     * @param roleCode 角色代码
     * @param tenantId 租户ID
     * @return 角色信息
     */
    Role findByRoleCode(String roleCode, String tenantId);
}