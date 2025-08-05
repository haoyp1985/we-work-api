package com.wework.platform.message.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.wework.platform.message.entity.MessageTemplate;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

/**
 * 消息模板数据访问层
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Mapper
public interface MessageTemplateRepository extends BaseMapper<MessageTemplate> {

    /**
     * 根据模板编码查询模板
     *
     * @param tenantId 租户ID
     * @param templateCode 模板编码
     * @return 模板信息
     */
    @Select("SELECT * FROM message_templates WHERE tenant_id = #{tenantId} AND template_code = #{templateCode} AND deleted_at IS NULL")
    MessageTemplate findByTemplateCode(@Param("tenantId") String tenantId, @Param("templateCode") String templateCode);

    /**
     * 查询可用模板列表
     *
     * @param tenantId 租户ID
     * @param status 状态
     * @return 模板列表
     */
    @Select("SELECT * FROM message_templates WHERE tenant_id = #{tenantId} AND status = #{status} AND deleted_at IS NULL ORDER BY created_at DESC")
    List<MessageTemplate> findAvailableTemplates(@Param("tenantId") String tenantId, @Param("status") Integer status);

    /**
     * 查询系统模板列表
     *
     * @param templateType 模板类型
     * @param messageCategory 消息类别
     * @return 模板列表
     */
    @Select("<script>" +
            "SELECT * FROM message_templates " +
            "WHERE is_system = 1 AND status = 1 " +
            "<if test='templateType != null'>" +
            "  AND template_type = #{templateType} " +
            "</if>" +
            "<if test='messageCategory != null'>" +
            "  AND message_category = #{messageCategory} " +
            "</if>" +
            "AND deleted_at IS NULL " +
            "ORDER BY use_count DESC" +
            "</script>")
    List<MessageTemplate> findSystemTemplates(@Param("templateType") Integer templateType,
                                            @Param("messageCategory") Integer messageCategory);

    /**
     * 更新模板使用统计
     *
     * @param id 模板ID
     * @param success 是否成功
     * @return 更新数量
     */
    @Update("<script>" +
            "UPDATE message_templates SET " +
            "use_count = use_count + 1, " +
            "<if test='success'>" +
            "  success_count = success_count + 1, " +
            "</if>" +
            "<if test='!success'>" +
            "  fail_count = fail_count + 1, " +
            "</if>" +
            "updated_at = NOW() " +
            "WHERE id = #{id}" +
            "</script>")
    int updateTemplateUsageStats(@Param("id") String id, @Param("success") Boolean success);

    /**
     * 更新模板状态
     *
     * @param id 模板ID
     * @param status 状态
     * @return 更新数量
     */
    @Update("UPDATE message_templates SET status = #{status}, updated_at = NOW() WHERE id = #{id}")
    int updateTemplateStatus(@Param("id") String id, @Param("status") Integer status);

    /**
     * 更新模板审核状态
     *
     * @param id 模板ID
     * @param auditStatus 审核状态
     * @param auditorId 审核人ID
     * @param auditRemark 审核备注
     * @return 更新数量
     */
    @Update("UPDATE message_templates SET " +
            "audit_status = #{auditStatus}, " +
            "auditor_id = #{auditorId}, " +
            "audit_time = UNIX_TIMESTAMP(), " +
            "audit_remark = #{auditRemark}, " +
            "updated_at = NOW() " +
            "WHERE id = #{id}")
    int updateTemplateAuditStatus(@Param("id") String id,
                                 @Param("auditStatus") Integer auditStatus,
                                 @Param("auditorId") String auditorId,
                                 @Param("auditRemark") String auditRemark);

    /**
     * 统计租户模板数量
     *
     * @param tenantId 租户ID
     * @return 模板数量
     */
    @Select("SELECT COUNT(*) FROM message_templates WHERE tenant_id = #{tenantId} AND deleted_at IS NULL")
    Long countByTenantId(@Param("tenantId") String tenantId);

    /**
     * 获取热门模板
     *
     * @param tenantId 租户ID
     * @param limit 限制数量
     * @return 模板列表
     */
    @Select("SELECT * FROM message_templates " +
            "WHERE tenant_id = #{tenantId} AND status = 1 AND deleted_at IS NULL " +
            "ORDER BY use_count DESC, success_count DESC " +
            "LIMIT #{limit}")
    List<MessageTemplate> findHotTemplates(@Param("tenantId") String tenantId, @Param("limit") Integer limit);
}