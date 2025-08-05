package com.wework.platform.account.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.common.core.exception.BusinessException;
import com.wework.platform.common.enums.ResultCode;
import com.wework.platform.account.dto.WeWorkContactDTO;
import com.wework.platform.account.entity.WeWorkContact;
import com.wework.platform.account.repository.WeWorkContactRepository;
import com.wework.platform.account.service.WeWorkContactService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * 企微联系人服务实现
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class WeWorkContactServiceImpl implements WeWorkContactService {

    private final WeWorkContactRepository contactRepository;

    @Override
    public PageResult<WeWorkContactDTO> getContactList(String accountId, Integer pageNum, Integer pageSize, 
                                                      Integer contactType, String keyword) {
        Page<WeWorkContact> page = new Page<>(pageNum, pageSize);
        
        LambdaQueryWrapper<WeWorkContact> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(WeWorkContact::getAccountId, accountId);
        
        if (contactType != null) {
            wrapper.eq(WeWorkContact::getContactType, contactType);
        }
        
        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w.like(WeWorkContact::getContactName, keyword)
                    .or().like(WeWorkContact::getNickname, keyword)
                    .or().like(WeWorkContact::getUserId, keyword));
        }
        
        wrapper.orderByDesc(WeWorkContact::getCreatedAt);
        
        IPage<WeWorkContact> result = contactRepository.selectPage(page, wrapper);
        
        List<WeWorkContactDTO> dtoList = result.getRecords().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        
        return PageResult.of(dtoList, result.getTotal(), pageNum.longValue(), pageSize.longValue());
    }

    @Override
    public WeWorkContactDTO getContactById(String contactId) {
        WeWorkContact contact = contactRepository.selectById(contactId);
        if (contact == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "联系人不存在");
        }
        return convertToDTO(contact);
    }

    @Override
    public List<WeWorkContactDTO> getContactsByAccountId(String accountId) {
        LambdaQueryWrapper<WeWorkContact> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(WeWorkContact::getAccountId, accountId)
                .orderByDesc(WeWorkContact::getCreatedAt);
        
        List<WeWorkContact> contacts = contactRepository.selectList(wrapper);
        return contacts.stream().map(this::convertToDTO).collect(Collectors.toList());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteContact(String contactId) {
        WeWorkContact contact = contactRepository.selectById(contactId);
        if (contact == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "联系人不存在");
        }
        
        contactRepository.deleteById(contactId);
        log.info("删除联系人成功, contactId: {}", contactId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void batchDeleteContacts(String accountId, List<String> contactIds) {
        if (contactIds == null || contactIds.isEmpty()) {
            return;
        }
        
        LambdaQueryWrapper<WeWorkContact> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(WeWorkContact::getAccountId, accountId)
                .in(WeWorkContact::getId, contactIds);
        
        int deletedCount = contactRepository.delete(wrapper);
        log.info("批量删除联系人成功, accountId: {}, deletedCount: {}", accountId, deletedCount);
    }

    @Override
    public String syncAccountContacts(String accountId, Boolean fullSync) {
        String taskId = UUID.randomUUID().toString();
        
        // TODO: 实现异步同步逻辑
        // 1. 创建同步任务记录
        // 2. 调用企微API获取联系人列表
        // 3. 比较本地联系人，进行增量或全量更新
        // 4. 更新同步任务状态
        
        log.info("开始同步账号联系人, accountId: {}, fullSync: {}, taskId: {}", 
                accountId, fullSync, taskId);
        
        return taskId;
    }

    @Override
    public ContactStatistics getContactStatistics(String accountId) {
        // 总数
        Long totalCount = contactRepository.countByAccountId(accountId);
        
        // 内部联系人数量 (contactType = 1)
        Long internalCount = contactRepository.countByAccountIdAndContactType(accountId, 1);
        
        // 外部联系人数量 (contactType = 2) 
        Long externalCount = contactRepository.countByAccountIdAndContactType(accountId, 2);
        
        // 部门数量 (contactType = 3)
        Long departmentCount = contactRepository.countByAccountIdAndContactType(accountId, 3);
        
        // 最近同步时间
        Long lastSyncTime = contactRepository.getLastSyncTime(accountId);
        
        return new ContactStatistics(totalCount, internalCount, externalCount, 
                                   departmentCount, lastSyncTime);
    }

    @Override
    public List<WeWorkContactDTO> searchContacts(String accountId, String keyword, Integer contactType, Integer limit) {
        LambdaQueryWrapper<WeWorkContact> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(WeWorkContact::getAccountId, accountId);
        
        if (contactType != null) {
            wrapper.eq(WeWorkContact::getContactType, contactType);
        }
        
        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w.like(WeWorkContact::getContactName, keyword)
                    .or().like(WeWorkContact::getNickname, keyword)
                    .or().like(WeWorkContact::getUserId, keyword));
        }
        
        wrapper.orderByDesc(WeWorkContact::getCreatedAt)
                .last("LIMIT " + limit);
        
        List<WeWorkContact> contacts = contactRepository.selectList(wrapper);
        return contacts.stream().map(this::convertToDTO).collect(Collectors.toList());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public WeWorkContactDTO saveOrUpdateContact(WeWorkContactDTO contactDTO) {
        WeWorkContact contact = convertToEntity(contactDTO);
        
        if (StringUtils.hasText(contact.getId())) {
            // 更新
            contact.setUpdatedAt(LocalDateTime.now());
            contactRepository.updateById(contact);
        } else {
            // 新增
            contact.setId(UUID.randomUUID().toString());
            contact.setCreatedAt(LocalDateTime.now());
            contact.setUpdatedAt(LocalDateTime.now());
            contactRepository.insert(contact);
        }
        
        return convertToDTO(contact);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void batchSaveContacts(List<WeWorkContactDTO> contacts) {
        if (contacts == null || contacts.isEmpty()) {
            return;
        }
        
        List<WeWorkContact> entities = contacts.stream()
                .map(this::convertToEntity)
                .collect(Collectors.toList());
        
        LocalDateTime now = LocalDateTime.now();
        entities.forEach(entity -> {
            if (!StringUtils.hasText(entity.getId())) {
                entity.setId(UUID.randomUUID().toString());
                entity.setCreatedAt(now);
            }
            entity.setUpdatedAt(now);
        });
        
        contactRepository.batchInsert(entities);
        log.info("批量保存联系人成功, count: {}", entities.size());
    }

    @Override
    public boolean isContactExists(String accountId, String contactUserId) {
        LambdaQueryWrapper<WeWorkContact> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(WeWorkContact::getAccountId, accountId)
                .eq(WeWorkContact::getUserId, contactUserId);
        
        return contactRepository.selectCount(wrapper) > 0;
    }

    /**
     * 实体转DTO
     */
    private WeWorkContactDTO convertToDTO(WeWorkContact entity) {
        if (entity == null) {
            return null;
        }
        
        WeWorkContactDTO dto = new WeWorkContactDTO();
        BeanUtils.copyProperties(entity, dto);
        return dto;
    }

    /**
     * DTO转实体
     */
    private WeWorkContact convertToEntity(WeWorkContactDTO dto) {
        if (dto == null) {
            return null;
        }
        
        WeWorkContact entity = new WeWorkContact();
        BeanUtils.copyProperties(dto, entity);
        return entity;
    }
}