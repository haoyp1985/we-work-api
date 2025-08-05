package com.wework.platform.account.controller;

import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.common.core.base.Result;
import com.wework.platform.account.dto.WeWorkContactDTO;
import com.wework.platform.account.service.WeWorkContactService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 企微联系人管理控制器
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@RestController
@RequestMapping("/contacts")
@RequiredArgsConstructor
@Tag(name = "企微联系人管理", description = "企微联系人管理相关接口")
public class WeWorkContactController {

    private final WeWorkContactService contactService;

    @Operation(summary = "分页查询联系人列表", description = "根据条件分页查询企微联系人列表")
    @GetMapping
    public Result<PageResult<WeWorkContactDTO>> getContactList(
            @Parameter(description = "账号ID") @RequestParam String accountId,
            @Parameter(description = "页码") @RequestParam(defaultValue = "1") Integer pageNum,
            @Parameter(description = "页大小") @RequestParam(defaultValue = "20") Integer pageSize,
            @Parameter(description = "联系人类型") @RequestParam(required = false) Integer contactType,
            @Parameter(description = "关键词") @RequestParam(required = false) String keyword) {
        
        PageResult<WeWorkContactDTO> result = contactService.getContactList(
                accountId, pageNum, pageSize, contactType, keyword);
        return Result.success(result);
    }

    @Operation(summary = "根据ID获取联系人详情", description = "根据联系人ID获取详细信息")
    @GetMapping("/{contactId}")
    public Result<WeWorkContactDTO> getContactById(@Parameter(description = "联系人ID") @PathVariable String contactId) {
        WeWorkContactDTO contactDTO = contactService.getContactById(contactId);
        return Result.success(contactDTO);
    }

    @Operation(summary = "根据账号ID获取联系人列表", description = "获取指定账号的所有联系人")
    @GetMapping("/account/{accountId}")
    public Result<List<WeWorkContactDTO>> getContactsByAccountId(@Parameter(description = "账号ID") @PathVariable String accountId) {
        List<WeWorkContactDTO> contacts = contactService.getContactsByAccountId(accountId);
        return Result.success(contacts);
    }

    @Operation(summary = "删除联系人", description = "删除指定的联系人")
    @DeleteMapping("/{contactId}")
    public Result<Void> deleteContact(@Parameter(description = "联系人ID") @PathVariable String contactId) {
        contactService.deleteContact(contactId);
        return Result.success();
    }

    @Operation(summary = "批量删除联系人", description = "批量删除指定账号的联系人")
    @DeleteMapping("/batch")
    public Result<Void> batchDeleteContacts(@Parameter(description = "账号ID") @RequestParam String accountId,
                                           @Parameter(description = "联系人ID列表") @RequestBody List<String> contactIds) {
        contactService.batchDeleteContacts(accountId, contactIds);
        return Result.success();
    }

    @Operation(summary = "同步账号联系人", description = "从企微API同步指定账号的联系人")
    @PostMapping("/sync/{accountId}")
    public Result<String> syncAccountContacts(@Parameter(description = "账号ID") @PathVariable String accountId,
                                             @Parameter(description = "是否全量同步") @RequestParam(defaultValue = "false") Boolean fullSync) {
        String taskId = contactService.syncAccountContacts(accountId, fullSync);
        return Result.success(taskId);
    }

    @Operation(summary = "获取联系人统计", description = "获取指定账号的联系人统计信息")
    @GetMapping("/statistics/{accountId}")
    public Result<WeWorkContactService.ContactStatistics> getContactStatistics(@Parameter(description = "账号ID") @PathVariable String accountId) {
        WeWorkContactService.ContactStatistics statistics = contactService.getContactStatistics(accountId);
        return Result.success(statistics);
    }

    @Operation(summary = "搜索联系人", description = "根据关键词搜索联系人")
    @GetMapping("/search")
    public Result<List<WeWorkContactDTO>> searchContacts(
            @Parameter(description = "账号ID") @RequestParam String accountId,
            @Parameter(description = "搜索关键词") @RequestParam String keyword,
            @Parameter(description = "联系人类型") @RequestParam(required = false) Integer contactType,
            @Parameter(description = "限制数量") @RequestParam(defaultValue = "50") Integer limit) {
        
        List<WeWorkContactDTO> contacts = contactService.searchContacts(accountId, keyword, contactType, limit);
        return Result.success(contacts);
    }
}