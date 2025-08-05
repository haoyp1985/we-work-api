package com.wework.platform.user.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.wework.platform.user.entity.UserRole;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 用户角色关联数据访问层
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Mapper
public interface UserRoleRepository extends BaseMapper<UserRole> {

    /**
     * 根据用户ID查询用户角色关联
     * 
     * @param userId 用户ID
     * @return 用户角色关联列表
     */
    @Select("SELECT * FROM user_roles WHERE user_id = #{userId} AND deleted_at IS NULL")
    List<UserRole> findByUserId(@Param("userId") String userId);

    /**
     * 根据角色ID查询用户角色关联
     * 
     * @param roleId 角色ID
     * @return 用户角色关联列表
     */
    @Select("SELECT * FROM user_roles WHERE role_id = #{roleId} AND deleted_at IS NULL")
    List<UserRole> findByRoleId(@Param("roleId") String roleId);

    /**
     * 检查用户是否具有指定角色
     * 
     * @param userId 用户ID
     * @param roleId 角色ID
     * @return 存在数量
     */
    @Select("SELECT COUNT(*) FROM user_roles WHERE user_id = #{userId} AND role_id = #{roleId} AND deleted_at IS NULL")
    int countByUserIdAndRoleId(@Param("userId") String userId, @Param("roleId") String roleId);

    /**
     * 批量分配用户角色
     * 
     * @param userId 用户ID
     * @param roleIds 角色ID列表
     */
    @Insert("""
        <script>
        INSERT INTO user_roles (id, user_id, role_id, created_at, updated_at, created_by, updated_by) VALUES
        <foreach collection="roleIds" item="roleId" separator=",">
            (UUID(), #{userId}, #{roleId}, NOW(), NOW(), #{operatorId}, #{operatorId})
        </foreach>
        </script>
        """)
    void batchInsertUserRoles(@Param("userId") String userId, 
                             @Param("roleIds") List<String> roleIds, 
                             @Param("operatorId") String operatorId);

    /**
     * 删除用户的所有角色
     * 
     * @param userId 用户ID
     * @param operatorId 操作人ID
     */
    @Delete("""
        UPDATE user_roles SET deleted_at = NOW(), updated_by = #{operatorId} 
        WHERE user_id = #{userId} AND deleted_at IS NULL
        """)
    void deleteByUserId(@Param("userId") String userId, @Param("operatorId") String operatorId);

    /**
     * 删除角色的所有用户关联
     * 
     * @param roleId 角色ID
     * @param operatorId 操作人ID
     */
    @Delete("""
        UPDATE user_roles SET deleted_at = NOW(), updated_by = #{operatorId} 
        WHERE role_id = #{roleId} AND deleted_at IS NULL
        """)
    void deleteByRoleId(@Param("roleId") String roleId, @Param("operatorId") String operatorId);

    /**
     * 删除特定的用户角色关联
     * 
     * @param userId 用户ID
     * @param roleIds 角色ID列表
     * @param operatorId 操作人ID
     */
    @Delete("""
        <script>
        UPDATE user_roles SET deleted_at = NOW(), updated_by = #{operatorId} 
        WHERE user_id = #{userId} AND deleted_at IS NULL
        <if test="roleIds != null and roleIds.size() > 0">
            AND role_id IN
            <foreach collection="roleIds" item="roleId" open="(" separator="," close=")">
                #{roleId}
            </foreach>
        </if>
        </script>
        """)
    void deleteUserRoles(@Param("userId") String userId, 
                        @Param("roleIds") List<String> roleIds, 
                        @Param("operatorId") String operatorId);
}