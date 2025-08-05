package com.wework.platform.user.service;

import com.wework.platform.user.dto.PermissionDTO;
import com.wework.platform.user.entity.Permission;

import java.util.List;

/**
 * 权限服务接口
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
public interface PermissionService {

    /**
     * 查询所有权限
     * 
     * @return 权限列表
     */
    List<PermissionDTO> getAllPermissions();

    /**
     * 查询权限树结构
     * 
     * @return 权限树列表
     */
    List<PermissionDTO> getPermissionTree();

    /**
     * 根据权限类型查询权限
     * 
     * @param permissionType 权限类型
     * @return 权限列表
     */
    List<PermissionDTO> getPermissionsByType(String permissionType);

    /**
     * 根据ID获取权限详情
     * 
     * @param permissionId 权限ID
     * @return 权限详情
     */
    PermissionDTO getPermissionById(String permissionId);

    /**
     * 创建权限
     * 
     * @param permissionCode 权限代码
     * @param permissionName 权限名称
     * @param permissionType 权限类型
     * @param parentId 父权限ID
     * @param path 路径
     * @param component 组件
     * @param icon 图标
     * @param sortOrder 排序
     * @param operatorId 操作人ID
     * @return 权限信息
     */
    PermissionDTO createPermission(String permissionCode, String permissionName, String permissionType,
                                  String parentId, String path, String component, String icon,
                                  Integer sortOrder, String operatorId);

    /**
     * 更新权限
     * 
     * @param permissionId 权限ID
     * @param permissionName 权限名称
     * @param permissionType 权限类型
     * @param parentId 父权限ID
     * @param path 路径
     * @param component 组件
     * @param icon 图标
     * @param sortOrder 排序
     * @param operatorId 操作人ID
     * @return 权限信息
     */
    PermissionDTO updatePermission(String permissionId, String permissionName, String permissionType,
                                  String parentId, String path, String component, String icon,
                                  Integer sortOrder, String operatorId);

    /**
     * 删除权限
     * 
     * @param permissionId 权限ID
     * @param operatorId 操作人ID
     */
    void deletePermission(String permissionId, String operatorId);

    /**
     * 根据权限代码查找权限
     * 
     * @param permissionCode 权限代码
     * @return 权限信息
     */
    Permission findByPermissionCode(String permissionCode);

    /**
     * 初始化系统默认权限
     * 
     * @param operatorId 操作人ID
     */
    void initializeDefaultPermissions(String operatorId);
}