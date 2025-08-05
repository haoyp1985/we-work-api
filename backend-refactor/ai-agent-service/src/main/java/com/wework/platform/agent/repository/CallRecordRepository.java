package com.wework.platform.agent.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.agent.entity.CallRecord;
import com.wework.platform.agent.enums.CallStatus;
import com.wework.platform.agent.enums.PlatformType;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

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
    @Select({
        "<script>",
        "SELECT * FROM call_records",
        "WHERE tenant_id = #{tenantId}",
        "AND deleted = 0",
        "<if test='agentId != null and agentId != \"\"'>",
        "AND agent_id = #{agentId}",
        "</if>",
        "<if test='userId != null and userId != \"\"'>",
        "AND user_id = #{userId}",
        "</if>",
        "<if test='platformType != null'>",
        "AND platform_type = #{platformType}",
        "</if>",
        "<if test='callType != null and callType != \"\"'>",
        "AND call_type = #{callType}",
        "</if>",
        "<if test='callStatus != null'>",
        "AND call_status = #{callStatus}",
        "</if>",
        "<if test='startTime != null'>",
        "AND start_time >= #{startTime}",
        "</if>",
        "<if test='endTime != null'>",
        "AND end_time <= #{endTime}",
        "</if>",
        "ORDER BY start_time DESC",
        "</script>"
    })
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
    @Select({
        "SELECT * FROM call_records",
        "WHERE tenant_id = #{tenantId} AND conversation_id = #{conversationId}",
        "AND deleted = 0",
        "ORDER BY start_time DESC"
    })
    List<CallRecord> selectByConversation(@Param("tenantId") String tenantId,
                                         @Param("conversationId") String conversationId);

    /**
     * 根据消息ID查询调用记录
     *
     * @param tenantId  租户ID
     * @param messageId 消息ID
     * @return 调用记录
     */
    @Select("SELECT * FROM call_records WHERE tenant_id = #{tenantId} AND message_id = #{messageId} AND deleted = 0")
    CallRecord selectByMessage(@Param("tenantId") String tenantId,
                              @Param("messageId") String messageId);

    /**
     * 查询失败的调用记录
     *
     * @param tenantId 租户ID
     * @param limit    限制数量
     * @return 失败调用记录列表
     */
    @Select({
        "SELECT * FROM call_records",
        "WHERE tenant_id = #{tenantId}",
        "AND call_status IN ('FAILED', 'TIMEOUT', 'AUTH_FAILED', 'SERVICE_UNAVAILABLE')",
        "AND deleted = 0",
        "ORDER BY start_time DESC",
        "LIMIT #{limit}"
    })
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
    @Select({
        "SELECT * FROM call_records",
        "WHERE tenant_id = #{tenantId}",
        "AND call_status IN ('FAILED', 'TIMEOUT', 'RATE_LIMITED', 'SERVICE_UNAVAILABLE')",
        "AND retry_count < #{maxRetries}",
        "AND deleted = 0",
        "ORDER BY start_time ASC",
        "LIMIT #{limit}"
    })
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
    @Update("UPDATE call_records SET call_status = #{callStatus}, updated_at = NOW() WHERE tenant_id = #{tenantId} AND id = #{id} AND deleted = 0")
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
    @Update({
        "UPDATE call_records SET",
        "call_status = #{callStatus},",
        "response_status = #{responseStatus},",
        "response_headers = #{responseHeaders},",
        "response_body = #{responseBody},",
        "end_time = #{endTime},",
        "duration_ms = #{durationMs},",
        "input_tokens = #{inputTokens},",
        "output_tokens = #{outputTokens},",
        "total_tokens = #{totalTokens},",
        "cost = #{cost},",
        "updated_at = NOW()",
        "WHERE tenant_id = #{tenantId} AND id = #{id} AND deleted = 0"
    })
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
    @Update({
        "UPDATE call_records SET",
        "call_status = #{callStatus},",
        "error_code = #{errorCode},",
        "error_message = #{errorMessage},",
        "retry_count = #{retryCount},",
        "end_time = NOW(),",
        "updated_at = NOW()",
        "WHERE tenant_id = #{tenantId} AND id = #{id} AND deleted = 0"
    })
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
    @Select({
        "<script>",
        "SELECT",
        "COUNT(*) as total_calls,",
        "SUM(CASE WHEN call_status = 'SUCCESS' THEN 1 ELSE 0 END) as success_calls,",
        "SUM(CASE WHEN call_status IN ('FAILED', 'TIMEOUT', 'AUTH_FAILED', 'QUOTA_EXCEEDED', 'SERVICE_UNAVAILABLE') THEN 1 ELSE 0 END) as failed_calls,",
        "AVG(duration_ms) as avg_duration,",
        "SUM(COALESCE(total_tokens, 0)) as total_tokens,",
        "SUM(COALESCE(cost, 0)) as total_cost",
        "FROM call_records",
        "WHERE tenant_id = #{tenantId}",
        "<if test='agentId != null and agentId != \"\"'>",
        "AND agent_id = #{agentId}",
        "</if>",
        "<if test='platformType != null'>",
        "AND platform_type = #{platformType}",
        "</if>",
        "<if test='startTime != null'>",
        "AND start_time >= #{startTime}",
        "</if>",
        "<if test='endTime != null'>",
        "AND end_time <= #{endTime}",
        "</if>",
        "AND deleted = 0",
        "</script>"
    })
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
    @Select({
        "<script>",
        "SELECT platform_type,",
        "COUNT(*) as total_calls,",
        "SUM(CASE WHEN call_status = 'SUCCESS' THEN 1 ELSE 0 END) as success_calls,",
        "AVG(duration_ms) as avg_duration,",
        "SUM(COALESCE(total_tokens, 0)) as total_tokens,",
        "SUM(COALESCE(cost, 0)) as total_cost",
        "FROM call_records",
        "WHERE tenant_id = #{tenantId}",
        "<if test='startTime != null'>",
        "AND start_time >= #{startTime}",
        "</if>",
        "<if test='endTime != null'>",
        "AND end_time <= #{endTime}",
        "</if>",
        "AND deleted = 0",
        "GROUP BY platform_type",
        "ORDER BY total_calls DESC",
        "</script>"
    })
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