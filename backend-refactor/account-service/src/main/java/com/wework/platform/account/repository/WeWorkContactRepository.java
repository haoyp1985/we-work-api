package com.wework.platform.account.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.account.entity.WeWorkContact;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

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
    @Select("SELECT * FROM wework_contacts WHERE account_id = #{accountId} AND deleted_at IS NULL ORDER BY created_at DESC")
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
    @Select("<script>" +
            "SELECT * FROM wework_contacts " +
            "WHERE account_id = #{accountId} AND deleted_at IS NULL " +
            "<if test='contactType != null'>" +
            "  AND contact_type = #{contactType} " +
            "</if>" +
            "<if test='keyword != null and keyword != \"\"'>" +
            "  AND (contact_name LIKE CONCAT('%', #{keyword}, '%') OR nickname LIKE CONCAT('%', #{keyword}, '%')) " +
            "</if>" +
            "ORDER BY created_at DESC" +
            "</script>")
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
    @Select("SELECT * FROM wework_contacts WHERE account_id = #{accountId} AND contact_id = #{contactId} AND deleted_at IS NULL")
    WeWorkContact findByContactId(@Param("accountId") String accountId, @Param("contactId") String contactId);

    /**
     * 根据联系人类型统计数量
     * 
     * @param accountId 账号ID
     * @param contactType 联系人类型
     * @return 联系人数量
     */
    @Select("SELECT COUNT(*) FROM wework_contacts WHERE account_id = #{accountId} AND contact_type = #{contactType} AND deleted_at IS NULL")
    int countByContactType(@Param("accountId") String accountId, @Param("contactType") Integer contactType);

    /**
     * 查询账号的联系人统计信息
     * 
     * @param accountId 账号ID
     * @return 统计信息
     */
    @Select("SELECT " +
            "COUNT(*) as total, " +
            "SUM(CASE WHEN contact_type = 1 THEN 1 ELSE 0 END) as internal, " +
            "SUM(CASE WHEN contact_type = 2 THEN 1 ELSE 0 END) as external, " +
            "SUM(CASE WHEN contact_type = 3 THEN 1 ELSE 0 END) as groups " +
            "FROM wework_contacts WHERE account_id = #{accountId} AND deleted_at IS NULL")
    ContactStatistics getContactStatistics(@Param("accountId") String accountId);

    /**
     * 统计账号联系人总数
     *
     * @param accountId 账号ID
     * @return 联系人总数
     */
    @Select("SELECT COUNT(*) FROM wework_contacts WHERE account_id = #{accountId} AND deleted_at IS NULL")
    Long countByAccountId(@Param("accountId") String accountId);

    /**
     * 按账号ID和联系人类型统计
     *
     * @param accountId 账号ID
     * @param contactType 联系人类型
     * @return 联系人数量
     */
    @Select("SELECT COUNT(*) FROM wework_contacts WHERE account_id = #{accountId} AND contact_type = #{contactType} AND deleted_at IS NULL")
    Long countByAccountIdAndContactType(@Param("accountId") String accountId, @Param("contactType") Integer contactType);

    /**
     * 获取账号最近同步时间
     *
     * @param accountId 账号ID
     * @return 最近同步时间戳
     */
    @Select("SELECT MAX(UNIX_TIMESTAMP(updated_at)) FROM wework_contacts WHERE account_id = #{accountId}")
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