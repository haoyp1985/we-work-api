package com.wework.platform.message.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.wework.platform.message.entity.MessageTemplate;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

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
        MessageTemplate findByTemplateCode(@Param("tenantId") String tenantId, @Param("templateCode") String templateCode);

    /**
     * 查询可用模板列表
     *
     * @param tenantId 租户ID
     * @param status 状态
     * @return 模板列表
     */
        List<MessageTemplate> findAvailableTemplates(@Param("tenantId") String tenantId, @Param("status") Integer status);

    /**
     * 查询系统模板列表
     *
     * @param templateType 模板类型
     * @param messageCategory 消息类别
     * @return 模板列表
     */
        List<MessageTemplate> findSystemTemplates(@Param("templateType") Integer templateType,
                                            @Param("messageCategory") Integer messageCategory);

    /**
     * 更新模板使用统计
     *
     * @param id 模板ID
     * @param success 是否成功
     * @return 更新数量
     */
        int updateTemplateUsageStats(@Param("id") String id, @Param("success") Boolean success);

    /**
     * 更新模板状态
     *
     * @param id 模板ID
     * @param status 状态
     * @return 更新数量
     */
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
        Long countByTenantId(@Param("tenantId") String tenantId);

    /**
     * 获取热门模板
     *
     * @param tenantId 租户ID
     * @param limit 限制数量
     * @return 模板列表
     */
        List<MessageTemplate> findHotTemplates(@Param("tenantId") String tenantId, @Param("limit") Integer limit);
}