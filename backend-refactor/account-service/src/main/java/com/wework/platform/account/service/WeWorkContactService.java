package com.wework.platform.account.service;

import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.account.dto.WeWorkContactDTO;

import java.util.List;

/**
 * 企微联系人服务接口
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
public interface WeWorkContactService {

    /**
     * 分页查询联系人列表
     *
     * @param accountId 账号ID
     * @param pageNum 页码
     * @param pageSize 页大小
     * @param contactType 联系人类型
     * @param keyword 关键词
     * @return 分页结果
     */
    PageResult<WeWorkContactDTO> getContactList(String accountId, Integer pageNum, Integer pageSize, 
                                               Integer contactType, String keyword);

    /**
     * 根据ID获取联系人详情
     *
     * @param contactId 联系人ID
     * @return 联系人信息
     */
    WeWorkContactDTO getContactById(String contactId);

    /**
     * 根据账号ID获取联系人列表
     *
     * @param accountId 账号ID
     * @return 联系人列表
     */
    List<WeWorkContactDTO> getContactsByAccountId(String accountId);

    /**
     * 删除联系人
     *
     * @param contactId 联系人ID
     */
    void deleteContact(String contactId);

    /**
     * 批量删除联系人
     *
     * @param accountId 账号ID
     * @param contactIds 联系人ID列表
     */
    void batchDeleteContacts(String accountId, List<String> contactIds);

    /**
     * 同步账号联系人
     *
     * @param accountId 账号ID
     * @param fullSync 是否全量同步
     * @return 任务ID
     */
    String syncAccountContacts(String accountId, Boolean fullSync);

    /**
     * 获取联系人统计信息
     *
     * @param accountId 账号ID
     * @return 统计信息
     */
    ContactStatistics getContactStatistics(String accountId);

    /**
     * 搜索联系人
     *
     * @param accountId 账号ID
     * @param keyword 搜索关键词
     * @param contactType 联系人类型
     * @param limit 限制数量
     * @return 联系人列表
     */
    List<WeWorkContactDTO> searchContacts(String accountId, String keyword, Integer contactType, Integer limit);

    /**
     * 保存或更新联系人
     *
     * @param contactDTO 联系人信息
     * @return 联系人信息
     */
    WeWorkContactDTO saveOrUpdateContact(WeWorkContactDTO contactDTO);

    /**
     * 批量保存联系人
     *
     * @param contacts 联系人列表
     */
    void batchSaveContacts(List<WeWorkContactDTO> contacts);

    /**
     * 检查联系人是否存在
     *
     * @param accountId 账号ID
     * @param contactUserId 联系人用户ID
     * @return 是否存在
     */
    boolean isContactExists(String accountId, String contactUserId);

    /**
     * 联系人统计信息
     */
    class ContactStatistics {
        private Long totalCount;
        private Long internalCount;
        private Long externalCount;
        private Long departmentCount;
        private Long lastSyncTime;

        // Constructors
        public ContactStatistics() {}

        public ContactStatistics(Long totalCount, Long internalCount, Long externalCount, 
                               Long departmentCount, Long lastSyncTime) {
            this.totalCount = totalCount;
            this.internalCount = internalCount;
            this.externalCount = externalCount;
            this.departmentCount = departmentCount;
            this.lastSyncTime = lastSyncTime;
        }

        // Getters and Setters
        public Long getTotalCount() {
            return totalCount;
        }

        public void setTotalCount(Long totalCount) {
            this.totalCount = totalCount;
        }

        public Long getInternalCount() {
            return internalCount;
        }

        public void setInternalCount(Long internalCount) {
            this.internalCount = internalCount;
        }

        public Long getExternalCount() {
            return externalCount;
        }

        public void setExternalCount(Long externalCount) {
            this.externalCount = externalCount;
        }

        public Long getDepartmentCount() {
            return departmentCount;
        }

        public void setDepartmentCount(Long departmentCount) {
            this.departmentCount = departmentCount;
        }

        public Long getLastSyncTime() {
            return lastSyncTime;
        }

        public void setLastSyncTime(Long lastSyncTime) {
            this.lastSyncTime = lastSyncTime;
        }
    }
}