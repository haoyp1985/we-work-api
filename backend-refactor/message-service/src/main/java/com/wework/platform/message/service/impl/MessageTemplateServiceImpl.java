package com.wework.platform.message.service.impl;

import com.alibaba.fastjson.JSON;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.common.core.exception.BusinessException;
import com.wework.platform.common.enums.ResultCode;
import com.wework.platform.message.dto.MessageTemplateDTO;
import com.wework.platform.message.dto.CreateTemplateRequest;
import com.wework.platform.message.dto.UpdateTemplateRequest;
import com.wework.platform.message.entity.MessageTemplate;
import com.wework.platform.message.repository.MessageTemplateRepository;
import com.wework.platform.message.service.MessageTemplateService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

/**
 * 消息模板服务实现
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class MessageTemplateServiceImpl implements MessageTemplateService {

    private final MessageTemplateRepository messageTemplateRepository;
    private static final Pattern VARIABLE_PATTERN = Pattern.compile("\\$\\{([^}]+)\\}");

    @Override
    @Transactional
    public MessageTemplateDTO createTemplate(String tenantId, CreateTemplateRequest request) {
        log.info("创建消息模板, tenantId: {}, templateName: {}", tenantId, request.getTemplateName());

        // 检查模板编码唯一性
        if (!checkTemplateCodeUnique(tenantId, request.getTemplateCode(), null)) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "模板编码已存在");
        }

        // 构建模板实体
        MessageTemplate template = new MessageTemplate();
        BeanUtils.copyProperties(request, template);
        template.setId(UUID.randomUUID().toString());
        template.setTenantId(tenantId);
        template.setStatus(0); // 草稿状态
        template.setUseCount(0);
        template.setSuccessCount(0);
        template.setFailCount(0);
        template.setIsSystem(false);
        template.setAuditStatus(0); // 待审核

        // 处理变量定义
        if (request.getVariables() != null) {
            template.setVariables(JSON.toJSONString(request.getVariables()));
        }

        // 提取模板中的变量
        extractVariables(template);

        messageTemplateRepository.insert(template);

        return convertToDTO(template);
    }

    @Override
    @Transactional
    public MessageTemplateDTO updateTemplate(String templateId, UpdateTemplateRequest request) {
        MessageTemplate template = messageTemplateRepository.selectById(templateId);
        if (template == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "模板不存在");
        }

        // 系统模板不能修改
        if (template.getIsSystem()) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "系统模板不能修改");
        }

        // 更新模板信息
        if (StringUtils.hasText(request.getTemplateName())) {
            template.setTemplateName(request.getTemplateName());
        }
        if (request.getTemplateType() != null) {
            template.setTemplateType(request.getTemplateType());
        }
        if (request.getMessageCategory() != null) {
            template.setMessageCategory(request.getMessageCategory());
        }
        if (request.getTitle() != null) {
            template.setTitle(request.getTitle());
        }
        if (request.getContent() != null) {
            template.setContent(request.getContent());
            // 重新提取变量
            extractVariables(template);
        }
        if (request.getVariables() != null) {
            template.setVariables(JSON.toJSONString(request.getVariables()));
        }
        if (request.getThumbUrl() != null) {
            template.setThumbUrl(request.getThumbUrl());
        }
        if (request.getLinkUrl() != null) {
            template.setLinkUrl(request.getLinkUrl());
        }
        if (request.getAppId() != null) {
            template.setAppId(request.getAppId());
        }
        if (request.getPagePath() != null) {
            template.setPagePath(request.getPagePath());
        }
        if (request.getScenario() != null) {
            template.setScenario(request.getScenario());
        }
        if (request.getStatus() != null) {
            template.setStatus(request.getStatus());
        }
        if (request.getRemark() != null) {
            template.setRemark(request.getRemark());
        }

        // 修改后需要重新审核
        if (request.getContent() != null || request.getTitle() != null) {
            template.setAuditStatus(0);
        }

        messageTemplateRepository.updateById(template);

        return convertToDTO(template);
    }

    @Override
    public PageResult<MessageTemplateDTO> getTemplateList(String tenantId, Integer templateType,
                                                        Integer messageCategory, Integer status,
                                                        String keyword, Integer pageNum, Integer pageSize) {
        Page<MessageTemplate> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<MessageTemplate> wrapper = new LambdaQueryWrapper<>();
        
        wrapper.eq(MessageTemplate::getTenantId, tenantId)
               .eq(templateType != null, MessageTemplate::getTemplateType, templateType)
               .eq(messageCategory != null, MessageTemplate::getMessageCategory, messageCategory)
               .eq(status != null, MessageTemplate::getStatus, status)
               .and(StringUtils.hasText(keyword), w -> w
                       .like(MessageTemplate::getTemplateName, keyword)
                       .or()
                       .like(MessageTemplate::getTemplateCode, keyword)
                       .or()
                       .like(MessageTemplate::getContent, keyword))
               .orderByDesc(MessageTemplate::getCreatedAt);

        IPage<MessageTemplate> result = messageTemplateRepository.selectPage(page, wrapper);
        
        List<MessageTemplateDTO> dtoList = result.getRecords().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());

        return PageResult.of(dtoList, result.getTotal(), pageNum.longValue(), pageSize.longValue());
    }

    @Override
    public MessageTemplateDTO getTemplateById(String templateId) {
        MessageTemplate template = messageTemplateRepository.selectById(templateId);
        if (template == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "模板不存在");
        }
        return convertToDTO(template);
    }

    @Override
    public MessageTemplateDTO getTemplateByCode(String tenantId, String templateCode) {
        MessageTemplate template = messageTemplateRepository.findByTemplateCode(tenantId, templateCode);
        if (template == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "模板不存在");
        }
        return convertToDTO(template);
    }

    @Override
    public List<MessageTemplateDTO> getAvailableTemplates(String tenantId) {
        List<MessageTemplate> templates = messageTemplateRepository.findAvailableTemplates(tenantId, 1);
        return templates.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<MessageTemplateDTO> getSystemTemplates(Integer templateType, Integer messageCategory) {
        List<MessageTemplate> templates = messageTemplateRepository.findSystemTemplates(templateType, messageCategory);
        return templates.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<MessageTemplateDTO> getHotTemplates(String tenantId, Integer limit) {
        List<MessageTemplate> templates = messageTemplateRepository.findHotTemplates(tenantId, limit);
        return templates.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public Boolean updateTemplateStatus(String templateId, Integer status) {
        MessageTemplate template = messageTemplateRepository.selectById(templateId);
        if (template == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "模板不存在");
        }

        // 启用模板需要审核通过
        if (status == 1 && template.getAuditStatus() != 1) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "模板未审核通过，不能启用");
        }

        return messageTemplateRepository.updateTemplateStatus(templateId, status) > 0;
    }

    @Override
    @Transactional
    public Boolean auditTemplate(String templateId, Integer auditStatus, String auditorId, String auditRemark) {
        MessageTemplate template = messageTemplateRepository.selectById(templateId);
        if (template == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "模板不存在");
        }

        return messageTemplateRepository.updateTemplateAuditStatus(templateId, auditStatus, auditorId, auditRemark) > 0;
    }

    @Override
    @Transactional
    public MessageTemplateDTO copyTemplate(String templateId, String newName, String newCode) {
        MessageTemplate sourceTemplate = messageTemplateRepository.selectById(templateId);
        if (sourceTemplate == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "源模板不存在");
        }

        // 检查新编码唯一性
        if (!checkTemplateCodeUnique(sourceTemplate.getTenantId(), newCode, null)) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "模板编码已存在");
        }

        // 复制模板
        MessageTemplate newTemplate = new MessageTemplate();
        BeanUtils.copyProperties(sourceTemplate, newTemplate);
        newTemplate.setId(UUID.randomUUID().toString());
        newTemplate.setTemplateName(newName);
        newTemplate.setTemplateCode(newCode);
        newTemplate.setStatus(0); // 草稿状态
        newTemplate.setUseCount(0);
        newTemplate.setSuccessCount(0);
        newTemplate.setFailCount(0);
        newTemplate.setIsSystem(false);
        newTemplate.setAuditStatus(0); // 待审核
        newTemplate.setCreatedAt(null);
        newTemplate.setUpdatedAt(null);

        messageTemplateRepository.insert(newTemplate);

        return convertToDTO(newTemplate);
    }

    @Override
    @Transactional
    public Boolean deleteTemplate(String templateId) {
        MessageTemplate template = messageTemplateRepository.selectById(templateId);
        if (template == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "模板不存在");
        }

        // 系统模板不能删除
        if (template.getIsSystem()) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "系统模板不能删除");
        }

        // 已启用的模板不能删除
        if (template.getStatus() == 1) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "已启用的模板不能删除");
        }

        return messageTemplateRepository.deleteById(templateId) > 0;
    }

    @Override
    @Transactional
    public Integer batchDeleteTemplates(List<String> templateIds) {
        // 检查是否有系统模板或已启用的模板
        LambdaQueryWrapper<MessageTemplate> wrapper = new LambdaQueryWrapper<>();
        wrapper.in(MessageTemplate::getId, templateIds)
               .and(w -> w.eq(MessageTemplate::getIsSystem, true)
                         .or()
                         .eq(MessageTemplate::getStatus, 1));
        
        Long count = messageTemplateRepository.selectCount(wrapper);
        if (count > 0) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "包含系统模板或已启用的模板，不能删除");
        }

        return messageTemplateRepository.deleteBatchIds(templateIds);
    }

    @Override
    public String previewTemplate(String templateId, Map<String, Object> params) {
        MessageTemplate template = messageTemplateRepository.selectById(templateId);
        if (template == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "模板不存在");
        }

        String content = template.getContent();
        if (params != null && !params.isEmpty()) {
            // 替换变量
            for (Map.Entry<String, Object> entry : params.entrySet()) {
                String variable = "${" + entry.getKey() + "}";
                content = content.replace(variable, String.valueOf(entry.getValue()));
            }
        }

        return content;
    }

    @Override
    public Boolean checkTemplateCodeUnique(String tenantId, String templateCode, String excludeId) {
        LambdaQueryWrapper<MessageTemplate> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(MessageTemplate::getTenantId, tenantId)
               .eq(MessageTemplate::getTemplateCode, templateCode)
               .ne(StringUtils.hasText(excludeId), MessageTemplate::getId, excludeId);
        
        return messageTemplateRepository.selectCount(wrapper) == 0;
    }

    /**
     * 提取模板中的变量
     */
    private void extractVariables(MessageTemplate template) {
        if (!StringUtils.hasText(template.getContent())) {
            return;
        }

        List<MessageTemplateDTO.TemplateVariable> variables = new ArrayList<>();
        Matcher matcher = VARIABLE_PATTERN.matcher(template.getContent());
        
        while (matcher.find()) {
            String variableName = matcher.group(1);
            MessageTemplateDTO.TemplateVariable variable = MessageTemplateDTO.TemplateVariable.builder()
                    .name(variableName)
                    .key(variableName)
                    .type("string")
                    .required(true)
                    .build();
            
            if (!variables.stream().anyMatch(v -> v.getKey().equals(variableName))) {
                variables.add(variable);
            }
        }

        if (!variables.isEmpty()) {
            template.setVariables(JSON.toJSONString(variables));
        }
    }

    /**
     * 转换为DTO
     */
    private MessageTemplateDTO convertToDTO(MessageTemplate template) {
        MessageTemplateDTO dto = new MessageTemplateDTO();
        BeanUtils.copyProperties(template, dto);
        
        // 转换时间戳
        dto.setAuditTime(template.getAuditTime());
        dto.setCreatedAt(template.getCreatedAt() != null ? 
                        template.getCreatedAt().toEpochSecond(java.time.ZoneOffset.ofHours(8)) * 1000 : null);
        dto.setUpdatedAt(template.getUpdatedAt() != null ? 
                        template.getUpdatedAt().toEpochSecond(java.time.ZoneOffset.ofHours(8)) * 1000 : null);
        
        // 设置类型名称
        dto.setTemplateTypeName(getTemplateTypeName(template.getTemplateType()));
        dto.setMessageCategoryName(getMessageCategoryName(template.getMessageCategory()));
        dto.setStatusName(getStatusName(template.getStatus()));
        dto.setAuditStatusName(getAuditStatusName(template.getAuditStatus()));
        
        // 计算成功率
        if (template.getUseCount() > 0) {
            dto.setSuccessRate((double) template.getSuccessCount() / template.getUseCount() * 100);
        } else {
            dto.setSuccessRate(0.0);
        }
        
        // 解析变量定义
        if (StringUtils.hasText(template.getVariables())) {
            List<MessageTemplateDTO.TemplateVariable> variables = JSON.parseArray(
                    template.getVariables(), MessageTemplateDTO.TemplateVariable.class);
            dto.setVariables(variables);
        }
        
        return dto;
    }

    private String getTemplateTypeName(Integer type) {
        if (type == null) return "";
        switch (type) {
            case 1: return "文本";
            case 2: return "图文";
            case 3: return "卡片";
            case 4: return "小程序";
            default: return "未知";
        }
    }

    private String getMessageCategoryName(Integer category) {
        if (category == null) return "";
        switch (category) {
            case 1: return "营销";
            case 2: return "通知";
            case 3: return "提醒";
            case 4: return "其他";
            default: return "未知";
        }
    }

    private String getStatusName(Integer status) {
        if (status == null) return "";
        switch (status) {
            case 0: return "草稿";
            case 1: return "启用";
            case 2: return "停用";
            default: return "未知";
        }
    }

    private String getAuditStatusName(Integer status) {
        if (status == null) return "";
        switch (status) {
            case 0: return "待审核";
            case 1: return "审核通过";
            case 2: return "审核拒绝";
            default: return "未知";
        }
    }
}