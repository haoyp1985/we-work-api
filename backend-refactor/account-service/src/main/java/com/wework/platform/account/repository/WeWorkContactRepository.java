package com.wework.platform.account.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.account.entity.WeWorkContact;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 企微联系人数据访问层
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Mapper
public interface WeWorkContactRepository extends BaseMapper<WeWorkContact> {

    /**
     * 根据账号ID查询联系人列表
     * 
     * @param accountId 账号ID
     * @return 联系人列表
     */
        List<WeWorkContact> findByAccountId(@Param("accountId") String accountId);

    /**
     * 分页查询联系人列表
     * 
     * @param page 分页参数
     * @param accountId 账号ID
     * @param contactType 联系人类型
     * @param keyword 关键词
     * @return 分页结果
     */
        Page<WeWorkContact> findContactsPage(Page<WeWorkContact> page,
                                        @Param("accountId") String accountId,
                                        @Param("contactType") Integer contactType,
                                        @Param("keyword") String keyword);

    /**
     * 根据联系人ID查询联系人
     * 
     * @param accountId 账号ID
     * @param contactId 联系人ID
     * @return 联系人信息
     */
        WeWorkContact findByContactId(@Param("accountId") String accountId, @Param("contactId") String contactId);

    /**
     * 根据联系人类型统计数量
     * 
     * @param accountId 账号ID
     * @param contactType 联系人类型
     * @return 联系人数量
     */
        int countByContactType(@Param("accountId") String accountId, @Param("contactType") Integer contactType);

    /**
     * 查询账号的联系人统计信息
     * 
     * @param accountId 账号ID
     * @return 统计信息
     */
        ContactStatistics getContactStatistics(@Param("accountId") String accountId);

    /**
     * 统计账号联系人总数
     *
     * @param accountId 账号ID
     * @return 联系人总数
     */
        Long countByAccountId(@Param("accountId") String accountId);

    /**
     * 按账号ID和联系人类型统计
     *
     * @param accountId 账号ID
     * @param contactType 联系人类型
     * @return 联系人数量
     */
        Long countByAccountIdAndContactType(@Param("accountId") String accountId, @Param("contactType") Integer contactType);

    /**
     * 获取账号最近同步时间
     *
     * @param accountId 账号ID
     * @return 最近同步时间戳
     */
        Long getLastSyncTime(@Param("accountId") String accountId);

    /**
     * 批量插入联系人
     *
     * @param contacts 联系人列表
     * @return 插入数量
     */
    int batchInsert(@Param("contacts") List<WeWorkContact> contacts);

    /**
     * 联系人统计信息内部类
     */
    class ContactStatistics {
        private Integer total;
        private Integer internal;
        private Integer external;
        private Integer groups;

        // Getters and Setters
        public Integer getTotal() { return total; }
        public void setTotal(Integer total) { this.total = total; }
        public Integer getInternal() { return internal; }
        public void setInternal(Integer internal) { this.internal = internal; }
        public Integer getExternal() { return external; }
        public void setExternal(Integer external) { this.external = external; }
        public Integer getGroups() { return groups; }
        public void setGroups(Integer groups) { this.groups = groups; }
    }
}