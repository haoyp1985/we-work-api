package com.wework.platform.user.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.wework.platform.user.entity.RolePermission;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 角色权限关联数据访问层
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Mapper
public interface RolePermissionRepository extends BaseMapper<RolePermission> {

    /**
     * 根据角色ID查询角色权限关联
     * 
     * @param roleId 角色ID
     * @return 角色权限关联列表
     */
    @Select("SELECT * FROM role_permissions WHERE role_id = #{roleId} AND deleted_at IS NULL")
    List<RolePermission> findByRoleId(@Param("roleId") String roleId);

    /**
     * 根据权限ID查询角色权限关联
     * 
     * @param permissionId 权限ID
     * @return 角色权限关联列表
     */
    @Select("SELECT * FROM role_permissions WHERE permission_id = #{permissionId} AND deleted_at IS NULL")
    List<RolePermission> findByPermissionId(@Param("permissionId") String permissionId);

    /**
     * 检查角色是否具有指定权限
     * 
     * @param roleId 角色ID
     * @param permissionId 权限ID
     * @return 存在数量
     */
    @Select("SELECT COUNT(*) FROM role_permissions WHERE role_id = #{roleId} AND permission_id = #{permissionId} AND deleted_at IS NULL")
    int countByRoleIdAndPermissionId(@Param("roleId") String roleId, @Param("permissionId") String permissionId);

    /**
     * 批量分配角色权限
     * 
     * @param roleId 角色ID
     * @param permissionIds 权限ID列表
     * @param operatorId 操作人ID
     */
    @Insert("""
        <script>
        INSERT INTO role_permissions (id, role_id, permission_id, created_at, updated_at, created_by, updated_by) VALUES
        <foreach collection="permissionIds" item="permissionId" separator=",">
            (UUID(), #{roleId}, #{permissionId}, NOW(), NOW(), #{operatorId}, #{operatorId})
        </foreach>
        </script>
        """)
    void batchInsertRolePermissions(@Param("roleId") String roleId, 
                                   @Param("permissionIds") List<String> permissionIds, 
                                   @Param("operatorId") String operatorId);

    /**
     * 删除角色的所有权限
     * 
     * @param roleId 角色ID
     * @param operatorId 操作人ID
     */
    @Delete("""
        UPDATE role_permissions SET deleted_at = NOW(), updated_by = #{operatorId} 
        WHERE role_id = #{roleId} AND deleted_at IS NULL
        """)
    void deleteByRoleId(@Param("roleId") String roleId, @Param("operatorId") String operatorId);

    /**
     * 删除权限的所有角色关联
     * 
     * @param permissionId 权限ID
     * @param operatorId 操作人ID
     */
    @Delete("""
        UPDATE role_permissions SET deleted_at = NOW(), updated_by = #{operatorId} 
        WHERE permission_id = #{permissionId} AND deleted_at IS NULL
        """)
    void deleteByPermissionId(@Param("permissionId") String permissionId, @Param("operatorId") String operatorId);

    /**
     * 删除特定的角色权限关联
     * 
     * @param roleId 角色ID
     * @param permissionIds 权限ID列表
     * @param operatorId 操作人ID
     */
    @Delete("""
        <script>
        UPDATE role_permissions SET deleted_at = NOW(), updated_by = #{operatorId} 
        WHERE role_id = #{roleId} AND deleted_at IS NULL
        <if test="permissionIds != null and permissionIds.size() > 0">
            AND permission_id IN
            <foreach collection="permissionIds" item="permissionId" open="(" separator="," close=")">
                #{permissionId}
            </foreach>
        </if>
        </script>
        """)
    void deleteRolePermissions(@Param("roleId") String roleId, 
                              @Param("permissionIds") List<String> permissionIds, 
                              @Param("operatorId") String operatorId);
}