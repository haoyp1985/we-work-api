package com.wework.platform.account.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.account.entity.AccountStatusLog;
import com.wework.platform.account.service.AccountStatusLogService;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 账号状态日志数据访问层
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Mapper
public interface AccountStatusLogRepository extends BaseMapper<AccountStatusLog> {

    /**
     * 根据账号ID查询状态变更日志
     * 
     * @param accountId 账号ID
     * @return 状态日志列表
     */
    List<AccountStatusLog> findByAccountId(@Param("accountId") String accountId);

    /**
     * 分页查询状态变更日志
     * 
     * @param page 分页参数
     * @param accountId 账号ID
     * @param operationType 操作类型
     * @return 分页结果
     */
    Page<AccountStatusLog> findStatusLogsPage(Page<AccountStatusLog> page,
                                            @Param("accountId") String accountId,
                                            @Param("operationType") Integer operationType);

    /**
     * 查询最近的状态变更记录
     * 
     * @param accountId 账号ID
     * @param limit 限制数量
     * @return 状态日志列表
     */
    List<AccountStatusLog> findRecentStatusLogs(@Param("accountId") String accountId, @Param("limit") int limit);

    /**
     * 根据租户ID查询状态变更日志
     * 
     * @param tenantId 租户ID
     * @param days 多少天内
     * @return 状态日志列表
     */
    List<AccountStatusLog> findByTenantIdAndDays(@Param("tenantId") String tenantId, @Param("days") int days);

    /**
     * 统计某个时间段内的状态变更次数
     * 
     * @param accountId 账号ID
     * @param hours 多少小时内
     * @return 变更次数
     */
    int countStatusChangesInHours(@Param("accountId") String accountId, @Param("hours") int hours);

    /**
     * 获取状态变更统计
     * 
     * @param tenantId 租户ID
     * @param accountId 账号ID
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 统计信息
     */
    AccountStatusLogService.StatusChangeStatistics getStatusChangeStatistics(
            @Param("tenantId") String tenantId, 
            @Param("accountId") String accountId,
            @Param("startTime") Long startTime, 
            @Param("endTime") Long endTime);

    /**
     * 获取状态趋势
     * 
     * @param tenantId 租户ID
     * @param accountId 账号ID
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @param interval 时间间隔
     * @return 趋势数据
     */
    List<AccountStatusLogService.StatusTrend> getStatusTrends(
            @Param("tenantId") String tenantId,
            @Param("accountId") String accountId, 
            @Param("startTime") Long startTime,
            @Param("endTime") Long endTime, 
            @Param("interval") String interval);
}