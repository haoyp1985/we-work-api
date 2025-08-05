package com.wework.platform.account.service;

import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.account.dto.AccountStatusLogDTO;

import java.util.List;

/**
 * 账号状态日志服务接口
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
public interface AccountStatusLogService {

    /**
     * 分页查询状态日志
     *
     * @param tenantId 租户ID
     * @param accountId 账号ID
     * @param fromStatus 原状态
     * @param toStatus 目标状态
     * @param pageNum 页码
     * @param pageSize 页大小
     * @return 分页结果
     */
    PageResult<AccountStatusLogDTO> getStatusLogList(String tenantId, String accountId, Integer fromStatus, 
                                                    Integer toStatus, Integer pageNum, Integer pageSize);

    /**
     * 根据账号ID查询状态日志
     *
     * @param accountId 账号ID
     * @param limit 限制数量
     * @return 状态日志列表
     */
    List<AccountStatusLogDTO> getStatusLogsByAccountId(String accountId, Integer limit);

    /**
     * 根据ID获取状态日志详情
     *
     * @param logId 日志ID
     * @return 状态日志信息
     */
    AccountStatusLogDTO getStatusLogById(String logId);

    /**
     * 记录状态变更日志
     *
     * @param accountId 账号ID
     * @param fromStatus 原状态
     * @param toStatus 目标状态
     * @param changeReason 变更原因
     * @param operatorId 操作人ID
     * @return 日志ID
     */
    String recordStatusChange(String accountId, Integer fromStatus, Integer toStatus, 
                            String changeReason, String operatorId);

    /**
     * 获取状态变更统计
     *
     * @param tenantId 租户ID
     * @param accountId 账号ID
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 统计信息
     */
    StatusChangeStatistics getStatusChangeStatistics(String tenantId, String accountId, Long startTime, Long endTime);

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
    List<StatusTrend> getStatusTrends(String tenantId, String accountId, Long startTime, Long endTime, String interval);

    /**
     * 清理历史日志
     *
     * @param tenantId 租户ID
     * @param keepDays 保留天数
     * @return 删除数量
     */
    int cleanupOldLogs(String tenantId, Integer keepDays);

    /**
     * 状态变更统计
     */
    class StatusChangeStatistics {
        private Long totalChanges;
        private Long loginCount;
        private Long logoutCount;
        private Long errorCount;
        private Long recoverCount;
        private Double averageOnlineTime;

        // Constructors
        public StatusChangeStatistics() {}

        public StatusChangeStatistics(Long totalChanges, Long loginCount, Long logoutCount, 
                                    Long errorCount, Long recoverCount, Double averageOnlineTime) {
            this.totalChanges = totalChanges;
            this.loginCount = loginCount;
            this.logoutCount = logoutCount;
            this.errorCount = errorCount;
            this.recoverCount = recoverCount;
            this.averageOnlineTime = averageOnlineTime;
        }

        // Getters and Setters
        public Long getTotalChanges() {
            return totalChanges;
        }

        public void setTotalChanges(Long totalChanges) {
            this.totalChanges = totalChanges;
        }

        public Long getLoginCount() {
            return loginCount;
        }

        public void setLoginCount(Long loginCount) {
            this.loginCount = loginCount;
        }

        public Long getLogoutCount() {
            return logoutCount;
        }

        public void setLogoutCount(Long logoutCount) {
            this.logoutCount = logoutCount;
        }

        public Long getErrorCount() {
            return errorCount;
        }

        public void setErrorCount(Long errorCount) {
            this.errorCount = errorCount;
        }

        public Long getRecoverCount() {
            return recoverCount;
        }

        public void setRecoverCount(Long recoverCount) {
            this.recoverCount = recoverCount;
        }

        public Double getAverageOnlineTime() {
            return averageOnlineTime;
        }

        public void setAverageOnlineTime(Double averageOnlineTime) {
            this.averageOnlineTime = averageOnlineTime;
        }
    }

    /**
     * 状态趋势
     */
    class StatusTrend {
        private String timePoint;
        private Integer status;
        private Long count;
        private Long timestamp;

        // Constructors
        public StatusTrend() {}

        public StatusTrend(String timePoint, Integer status, Long count, Long timestamp) {
            this.timePoint = timePoint;
            this.status = status;
            this.count = count;
            this.timestamp = timestamp;
        }

        // Getters and Setters
        public String getTimePoint() {
            return timePoint;
        }

        public void setTimePoint(String timePoint) {
            this.timePoint = timePoint;
        }

        public Integer getStatus() {
            return status;
        }

        public void setStatus(Integer status) {
            this.status = status;
        }

        public Long getCount() {
            return count;
        }

        public void setCount(Long count) {
            this.count = count;
        }

        public Long getTimestamp() {
            return timestamp;
        }

        public void setTimestamp(Long timestamp) {
            this.timestamp = timestamp;
        }
    }
}