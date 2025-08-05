package com.wework.platform.message.service;

import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.message.dto.MessageTemplateDTO;
import com.wework.platform.message.dto.CreateTemplateRequest;
import com.wework.platform.message.dto.UpdateTemplateRequest;

import java.util.List;
import java.util.Map;

/**
 * 消息模板服务接口
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
public interface MessageTemplateService {

    /**
     * 创建模板
     *
     * @param tenantId 租户ID
     * @param request 创建请求
     * @return 模板信息
     */
    MessageTemplateDTO createTemplate(String tenantId, CreateTemplateRequest request);

    /**
     * 更新模板
     *
     * @param templateId 模板ID
     * @param request 更新请求
     * @return 模板信息
     */
    MessageTemplateDTO updateTemplate(String templateId, UpdateTemplateRequest request);

    /**
     * 分页查询模板列表
     *
     * @param tenantId 租户ID
     * @param templateType 模板类型
     * @param messageCategory 消息类别
     * @param status 状态
     * @param keyword 关键词
     * @param pageNum 页码
     * @param pageSize 页大小
     * @return 分页结果
     */
    PageResult<MessageTemplateDTO> getTemplateList(String tenantId, Integer templateType,
                                                  Integer messageCategory, Integer status,
                                                  String keyword, Integer pageNum, Integer pageSize);

    /**
     * 根据ID获取模板详情
     *
     * @param templateId 模板ID
     * @return 模板信息
     */
    MessageTemplateDTO getTemplateById(String templateId);

    /**
     * 根据编码获取模板
     *
     * @param tenantId 租户ID
     * @param templateCode 模板编码
     * @return 模板信息
     */
    MessageTemplateDTO getTemplateByCode(String tenantId, String templateCode);

    /**
     * 获取可用模板列表
     *
     * @param tenantId 租户ID
     * @return 模板列表
     */
    List<MessageTemplateDTO> getAvailableTemplates(String tenantId);

    /**
     * 获取系统模板列表
     *
     * @param templateType 模板类型
     * @param messageCategory 消息类别
     * @return 模板列表
     */
    List<MessageTemplateDTO> getSystemTemplates(Integer templateType, Integer messageCategory);

    /**
     * 获取热门模板
     *
     * @param tenantId 租户ID
     * @param limit 限制数量
     * @return 模板列表
     */
    List<MessageTemplateDTO> getHotTemplates(String tenantId, Integer limit);

    /**
     * 更新模板状态
     *
     * @param templateId 模板ID
     * @param status 状态
     * @return 是否成功
     */
    Boolean updateTemplateStatus(String templateId, Integer status);

    /**
     * 审核模板
     *
     * @param templateId 模板ID
     * @param auditStatus 审核状态
     * @param auditorId 审核人ID
     * @param auditRemark 审核备注
     * @return 是否成功
     */
    Boolean auditTemplate(String templateId, Integer auditStatus, String auditorId, String auditRemark);

    /**
     * 复制模板
     *
     * @param templateId 模板ID
     * @param newName 新模板名称
     * @param newCode 新模板编码
     * @return 新模板信息
     */
    MessageTemplateDTO copyTemplate(String templateId, String newName, String newCode);

    /**
     * 删除模板
     *
     * @param templateId 模板ID
     * @return 是否成功
     */
    Boolean deleteTemplate(String templateId);

    /**
     * 批量删除模板
     *
     * @param templateIds 模板ID列表
     * @return 删除数量
     */
    Integer batchDeleteTemplates(List<String> templateIds);

    /**
     * 预览模板
     *
     * @param templateId 模板ID
     * @param params 模板参数
     * @return 预览内容
     */
    String previewTemplate(String templateId, Map<String, Object> params);

    /**
     * 验证模板编码唯一性
     *
     * @param tenantId 租户ID
     * @param templateCode 模板编码
     * @param excludeId 排除的模板ID
     * @return 是否唯一
     */
    Boolean checkTemplateCodeUnique(String tenantId, String templateCode, String excludeId);
}