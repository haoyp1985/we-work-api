package com.wework.platform.agent.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.agent.entity.CallRecord;
import com.wework.platform.agent.enums.CallStatus;
import com.wework.platform.agent.enums.PlatformType;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 外部平台调用记录数据访问接口
 */
@Mapper
public interface CallRecordRepository extends BaseMapper<CallRecord> {

    /**
     * 分页查询调用记录列表
     *
     * @param page         分页参数
     * @param tenantId     租户ID
     * @param agentId      智能体ID
     * @param userId       用户ID
     * @param platformType 平台类型
     * @param callType     调用类型
     * @param callStatus   调用状态
     * @param startTime    开始时间
     * @param endTime      结束时间
     * @return 分页结果
     */
        IPage<CallRecord> selectPageByConditions(Page<CallRecord> page,
                                            @Param("tenantId") String tenantId,
                                            @Param("agentId") String agentId,
                                            @Param("userId") String userId,
                                            @Param("platformType") PlatformType platformType,
                                            @Param("callType") String callType,
                                            @Param("callStatus") CallStatus callStatus,
                                            @Param("startTime") LocalDateTime startTime,
                                            @Param("endTime") LocalDateTime endTime);

    /**
     * 根据会话ID查询调用记录
     *
     * @param tenantId       租户ID
     * @param conversationId 会话ID
     * @return 调用记录列表
     */
        List<CallRecord> selectByConversation(@Param("tenantId") String tenantId,
                                         @Param("conversationId") String conversationId);

    /**
     * 根据消息ID查询调用记录
     *
     * @param tenantId  租户ID
     * @param messageId 消息ID
     * @return 调用记录
     */
        CallRecord selectByMessage(@Param("tenantId") String tenantId,
                              @Param("messageId") String messageId);

    /**
     * 查询失败的调用记录
     *
     * @param tenantId 租户ID
     * @param limit    限制数量
     * @return 失败调用记录列表
     */
        List<CallRecord> selectFailedCalls(@Param("tenantId") String tenantId,
                                      @Param("limit") Integer limit);

    /**
     * 查询可重试的调用记录
     *
     * @param tenantId    租户ID
     * @param maxRetries  最大重试次数
     * @param limit       限制数量
     * @return 可重试调用记录列表
     */
        List<CallRecord> selectRetryableCalls(@Param("tenantId") String tenantId,
                                         @Param("maxRetries") Integer maxRetries,
                                         @Param("limit") Integer limit);

    /**
     * 更新调用状态
     *
     * @param tenantId   租户ID
     * @param id         记录ID
     * @param callStatus 调用状态
     * @return 更新记录数
     */
        int updateCallStatus(@Param("tenantId") String tenantId,
                        @Param("id") String id,
                        @Param("callStatus") CallStatus callStatus);

    /**
     * 更新调用结果
     *
     * @param tenantId        租户ID
     * @param id              记录ID
     * @param callStatus      调用状态
     * @param responseStatus  响应状态码
     * @param responseHeaders 响应头
     * @param responseBody    响应体
     * @param endTime         结束时间
     * @param durationMs      耗时
     * @param inputTokens     输入Token数
     * @param outputTokens    输出Token数
     * @param totalTokens     总Token数
     * @param cost            费用
     * @return 更新记录数
     */
        int updateCallResult(@Param("tenantId") String tenantId,
                        @Param("id") String id,
                        @Param("callStatus") CallStatus callStatus,
                        @Param("responseStatus") Integer responseStatus,
                        @Param("responseHeaders") String responseHeaders,
                        @Param("responseBody") String responseBody,
                        @Param("endTime") LocalDateTime endTime,
                        @Param("durationMs") Long durationMs,
                        @Param("inputTokens") Integer inputTokens,
                        @Param("outputTokens") Integer outputTokens,
                        @Param("totalTokens") Integer totalTokens,
                        @Param("cost") BigDecimal cost);

    /**
     * 更新调用错误信息
     *
     * @param tenantId     租户ID
     * @param id           记录ID
     * @param callStatus   调用状态
     * @param errorCode    错误码
     * @param errorMessage 错误信息
     * @param retryCount   重试次数
     * @return 更新记录数
     */
        int updateCallError(@Param("tenantId") String tenantId,
                       @Param("id") String id,
                       @Param("callStatus") CallStatus callStatus,
                       @Param("errorCode") String errorCode,
                       @Param("errorMessage") String errorMessage,
                       @Param("retryCount") Integer retryCount);

    /**
     * 统计调用记录
     *
     * @param tenantId      租户ID
     * @param agentId       智能体ID(可选)
     * @param platformType  平台类型(可选)
     * @param startTime     开始时间(可选)
     * @param endTime       结束时间(可选)
     * @return 调用统计信息
     */
        CallStatistics selectStatistics(@Param("tenantId") String tenantId,
                                   @Param("agentId") String agentId,
                                   @Param("platformType") PlatformType platformType,
                                   @Param("startTime") LocalDateTime startTime,
                                   @Param("endTime") LocalDateTime endTime);

    /**
     * 按平台类型统计调用记录
     *
     * @param tenantId  租户ID
     * @param startTime 开始时间(可选)
     * @param endTime   结束时间(可选)
     * @return 平台调用统计列表
     */
        List<PlatformCallStatistics> selectStatisticsByPlatform(@Param("tenantId") String tenantId,
                                                           @Param("startTime") LocalDateTime startTime,
                                                           @Param("endTime") LocalDateTime endTime);

    /**
     * 调用统计信息内部类
     */
    class CallStatistics {
        private Long totalCalls;
        private Long successCalls;
        private Long failedCalls;
        private Double avgDuration;
        private Long totalTokens;
        private BigDecimal totalCost;

        // getters and setters
        public Long getTotalCalls() { return totalCalls; }
        public void setTotalCalls(Long totalCalls) { this.totalCalls = totalCalls; }
        public Long getSuccessCalls() { return successCalls; }
        public void setSuccessCalls(Long successCalls) { this.successCalls = successCalls; }
        public Long getFailedCalls() { return failedCalls; }
        public void setFailedCalls(Long failedCalls) { this.failedCalls = failedCalls; }
        public Double getAvgDuration() { return avgDuration; }
        public void setAvgDuration(Double avgDuration) { this.avgDuration = avgDuration; }
        public Long getTotalTokens() { return totalTokens; }
        public void setTotalTokens(Long totalTokens) { this.totalTokens = totalTokens; }
        public BigDecimal getTotalCost() { return totalCost; }
        public void setTotalCost(BigDecimal totalCost) { this.totalCost = totalCost; }
    }

    /**
     * 平台调用统计内部类
     */
    class PlatformCallStatistics {
        private PlatformType platformType;
        private Long totalCalls;
        private Long successCalls;
        private Double avgDuration;
        private Long totalTokens;
        private BigDecimal totalCost;

        // getters and setters
        public PlatformType getPlatformType() { return platformType; }
        public void setPlatformType(PlatformType platformType) { this.platformType = platformType; }
        public Long getTotalCalls() { return totalCalls; }
        public void setTotalCalls(Long totalCalls) { this.totalCalls = totalCalls; }
        public Long getSuccessCalls() { return successCalls; }
        public void setSuccessCalls(Long successCalls) { this.successCalls = successCalls; }
        public Double getAvgDuration() { return avgDuration; }
        public void setAvgDuration(Double avgDuration) { this.avgDuration = avgDuration; }
        public Long getTotalTokens() { return totalTokens; }
        public void setTotalTokens(Long totalTokens) { this.totalTokens = totalTokens; }
        public BigDecimal getTotalCost() { return totalCost; }
        public void setTotalCost(BigDecimal totalCost) { this.totalCost = totalCost; }
    }
}