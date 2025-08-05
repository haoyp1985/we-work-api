package com.wework.platform.message.controller;

import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.common.core.base.Result;
import com.wework.platform.common.security.UserContext;
import com.wework.platform.common.security.UserContextHolder;
import com.wework.platform.message.dto.MessageTemplateDTO;
import com.wework.platform.message.dto.CreateTemplateRequest;
import com.wework.platform.message.dto.UpdateTemplateRequest;
import com.wework.platform.message.service.MessageTemplateService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 消息模板管理控制器
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@RestController
@RequestMapping("/templates")
@RequiredArgsConstructor
@Tag(name = "消息模板管理", description = "消息模板创建、编辑和管理相关接口")
public class MessageTemplateController {

    private final MessageTemplateService messageTemplateService;

    @Operation(summary = "分页查询模板列表", description = "根据条件分页查询消息模板列表")
    @GetMapping
    public Result<PageResult<MessageTemplateDTO>> getTemplateList(
            @Parameter(description = "模板类型") @RequestParam(required = false) Integer templateType,
            @Parameter(description = "消息类别") @RequestParam(required = false) Integer messageCategory,
            @Parameter(description = "状态") @RequestParam(required = false) Integer status,
            @Parameter(description = "关键词") @RequestParam(required = false) String keyword,
            @Parameter(description = "页码", example = "1") @RequestParam(defaultValue = "1") Integer pageNum,
            @Parameter(description = "页大小", example = "10") @RequestParam(defaultValue = "10") Integer pageSize) {
        
        UserContext userContext = UserContextHolder.getUserContext();
        String tenantId = userContext.getTenantId();
        
        PageResult<MessageTemplateDTO> result = messageTemplateService.getTemplateList(
                tenantId, templateType, messageCategory, status, keyword, pageNum, pageSize);
        return Result.success(result);
    }

    @Operation(summary = "根据ID获取模板详情", description = "根据模板ID获取模板详细信息")
    @GetMapping("/{templateId}")
    public Result<MessageTemplateDTO> getTemplateById(
            @Parameter(description = "模板ID", required = true) @PathVariable String templateId) {
        MessageTemplateDTO template = messageTemplateService.getTemplateById(templateId);
        return Result.success(template);
    }

    @Operation(summary = "根据编码获取模板", description = "根据模板编码获取模板信息")
    @GetMapping("/code/{templateCode}")
    public Result<MessageTemplateDTO> getTemplateByCode(
            @Parameter(description = "模板编码", required = true) @PathVariable String templateCode) {
        UserContext userContext = UserContextHolder.getUserContext();
        String tenantId = userContext.getTenantId();
        
        MessageTemplateDTO template = messageTemplateService.getTemplateByCode(tenantId, templateCode);
        return Result.success(template);
    }

    @Operation(summary = "创建消息模板", description = "创建新的消息模板")
    @PostMapping
    public Result<MessageTemplateDTO> createTemplate(@Validated @RequestBody CreateTemplateRequest request) {
        UserContext userContext = UserContextHolder.getUserContext();
        String tenantId = userContext.getTenantId();
        
        MessageTemplateDTO template = messageTemplateService.createTemplate(tenantId, request);
        return Result.success(template);
    }

    @Operation(summary = "更新消息模板", description = "更新指定的消息模板")
    @PutMapping("/{templateId}")
    public Result<MessageTemplateDTO> updateTemplate(
            @Parameter(description = "模板ID", required = true) @PathVariable String templateId,
            @Validated @RequestBody UpdateTemplateRequest request) {
        MessageTemplateDTO template = messageTemplateService.updateTemplate(templateId, request);
        return Result.success(template);
    }

    @Operation(summary = "删除消息模板", description = "删除指定的消息模板")
    @DeleteMapping("/{templateId}")
    public Result<Boolean> deleteTemplate(
            @Parameter(description = "模板ID", required = true) @PathVariable String templateId) {
        Boolean success = messageTemplateService.deleteTemplate(templateId);
        return Result.success(success);
    }

    @Operation(summary = "批量删除模板", description = "批量删除指定的消息模板")
    @DeleteMapping("/batch")
    public Result<Integer> batchDeleteTemplates(@RequestBody List<String> templateIds) {
        Integer count = messageTemplateService.batchDeleteTemplates(templateIds);
        return Result.success(count);
    }

    @Operation(summary = "更新模板状态", description = "更新指定模板的状态")
    @PostMapping("/{templateId}/status")
    public Result<Boolean> updateTemplateStatus(
            @Parameter(description = "模板ID", required = true) @PathVariable String templateId,
            @Parameter(description = "状态", required = true) @RequestParam Integer status) {
        Boolean success = messageTemplateService.updateTemplateStatus(templateId, status);
        return Result.success(success);
    }

    @Operation(summary = "预览模板内容", description = "根据模板ID和参数预览渲染后的内容")
    @PostMapping("/{templateId}/preview")
    public Result<String> previewTemplate(
            @Parameter(description = "模板ID", required = true) @PathVariable String templateId,
            @RequestBody Map<String, Object> params) {
        String content = messageTemplateService.previewTemplate(templateId, params);
        return Result.success(content);
    }

    @Operation(summary = "审核模板", description = "审核指定的消息模板")
    @PostMapping("/{templateId}/audit")
    public Result<Boolean> auditTemplate(
            @Parameter(description = "模板ID", required = true) @PathVariable String templateId,
            @Parameter(description = "审核状态", required = true) @RequestParam Integer auditStatus,
            @Parameter(description = "审核备注") @RequestParam(required = false) String auditRemark) {
        
        UserContext userContext = UserContextHolder.getUserContext();
        String auditorId = userContext.getUserId();
        
        Boolean success = messageTemplateService.auditTemplate(templateId, auditStatus, auditorId, auditRemark);
        return Result.success(success);
    }

    @Operation(summary = "复制模板", description = "复制指定的消息模板")
    @PostMapping("/{templateId}/copy")
    public Result<MessageTemplateDTO> copyTemplate(
            @Parameter(description = "模板ID", required = true) @PathVariable String templateId,
            @Parameter(description = "新模板名称") @RequestParam String newName,
            @Parameter(description = "新模板编码") @RequestParam String newCode) {
        
        MessageTemplateDTO template = messageTemplateService.copyTemplate(templateId, newName, newCode);
        return Result.success(template);
    }

    @Operation(summary = "获取可用模板列表", description = "获取当前租户的可用模板列表")
    @GetMapping("/available")
    public Result<List<MessageTemplateDTO>> getAvailableTemplates() {
        UserContext userContext = UserContextHolder.getUserContext();
        String tenantId = userContext.getTenantId();
        
        List<MessageTemplateDTO> templates = messageTemplateService.getAvailableTemplates(tenantId);
        return Result.success(templates);
    }

    @Operation(summary = "获取系统模板列表", description = "获取系统预定义的模板列表")
    @GetMapping("/system")
    public Result<List<MessageTemplateDTO>> getSystemTemplates(
            @Parameter(description = "模板类型") @RequestParam(required = false) Integer templateType,
            @Parameter(description = "消息类别") @RequestParam(required = false) Integer messageCategory) {
        
        List<MessageTemplateDTO> templates = messageTemplateService.getSystemTemplates(templateType, messageCategory);
        return Result.success(templates);
    }

    @Operation(summary = "获取热门模板", description = "获取热门使用的模板列表")
    @GetMapping("/hot")
    public Result<List<MessageTemplateDTO>> getHotTemplates(
            @Parameter(description = "限制数量", example = "10") 
            @RequestParam(defaultValue = "10") Integer limit) {
        
        UserContext userContext = UserContextHolder.getUserContext();
        String tenantId = userContext.getTenantId();
        
        List<MessageTemplateDTO> templates = messageTemplateService.getHotTemplates(tenantId, limit);
        return Result.success(templates);
    }

    @Operation(summary = "检查模板编码唯一性", description = "检查模板编码是否已存在")
    @GetMapping("/check-code")
    public Result<Boolean> checkTemplateCodeUnique(
            @Parameter(description = "模板编码", required = true) @RequestParam String templateCode,
            @Parameter(description = "排除的模板ID") @RequestParam(required = false) String excludeId) {
        
        UserContext userContext = UserContextHolder.getUserContext();
        String tenantId = userContext.getTenantId();
        
        Boolean unique = messageTemplateService.checkTemplateCodeUnique(tenantId, templateCode, excludeId);
        return Result.success(unique);
    }
}