package com.wework.platform.agent.service;

import com.wework.platform.agent.dto.AgentDTO;
import com.wework.platform.agent.dto.request.AgentQueryRequest;
import com.wework.platform.agent.dto.request.CreateAgentRequest;
import com.wework.platform.agent.dto.request.UpdateAgentRequest;
import com.wework.platform.agent.dto.response.PageResult;
import com.wework.platform.agent.enums.AgentStatus;

import java.util.List;

/**
 * 智能体服务接口
 */
public interface AgentService {

    /**
     * 创建智能体
     *
     * @param tenantId 租户ID
     * @param request  创建请求
     * @return 智能体信息
     */
    AgentDTO createAgent(String tenantId, CreateAgentRequest request);

    /**
     * 更新智能体
     *
     * @param tenantId 租户ID
     * @param agentId  智能体ID
     * @param request  更新请求
     * @return 智能体信息
     */
    AgentDTO updateAgent(String tenantId, String agentId, UpdateAgentRequest request);

    /**
     * 删除智能体
     *
     * @param tenantId 租户ID
     * @param agentId  智能体ID
     */
    void deleteAgent(String tenantId, String agentId);

    /**
     * 获取智能体详情
     *
     * @param tenantId 租户ID
     * @param agentId  智能体ID
     * @return 智能体信息
     */
    AgentDTO getAgent(String tenantId, String agentId);

    /**
     * 分页查询智能体列表
     *
     * @param tenantId 租户ID
     * @param request  查询请求
     * @return 分页结果
     */
    PageResult<AgentDTO> getAgentList(String tenantId, AgentQueryRequest request);

    /**
     * 获取用户可访问的智能体列表
     *
     * @param tenantId 租户ID
     * @param userId   用户ID
     * @return 智能体列表
     */
    List<AgentDTO> getUserAccessibleAgents(String tenantId, String userId);

    /**
     * 发布智能体
     *
     * @param tenantId 租户ID
     * @param agentId  智能体ID
     * @return 智能体信息
     */
    AgentDTO publishAgent(String tenantId, String agentId);

    /**
     * 下线智能体
     *
     * @param tenantId 租户ID
     * @param agentId  智能体ID
     * @return 智能体信息
     */
    AgentDTO unpublishAgent(String tenantId, String agentId);

    /**
     * 更新智能体状态
     *
     * @param tenantId 租户ID
     * @param agentId  智能体ID
     * @param status   新状态
     * @return 智能体信息
     */
    AgentDTO updateAgentStatus(String tenantId, String agentId, AgentStatus status);

    /**
     * 复制智能体
     *
     * @param tenantId      租户ID
     * @param sourceAgentId 源智能体ID
     * @param newName       新智能体名称
     * @return 新智能体信息
     */
    AgentDTO copyAgent(String tenantId, String sourceAgentId, String newName);

    /**
     * 测试智能体配置
     *
     * @param tenantId  租户ID
     * @param agentId   智能体ID
     * @param testInput 测试输入
     * @return 测试结果
     */
    String testAgent(String tenantId, String agentId, String testInput);

    /**
     * 获取智能体使用统计
     *
     * @param tenantId 租户ID
     * @param agentId  智能体ID
     * @return 统计信息
     */
    AgentUsageStats getAgentUsageStats(String tenantId, String agentId);

    /**
     * 智能体使用统计
     */
    class AgentUsageStats {
        private Long totalConversations;
        private Long totalMessages;
        private Long totalTokens;
        private Double avgResponseTime;
        private Double successRate;
        private java.time.LocalDateTime lastUsedAt;

        // Getter和Setter方法
        public Long getTotalConversations() { return totalConversations; }
        public void setTotalConversations(Long totalConversations) { this.totalConversations = totalConversations; }
        
        public Long getTotalMessages() { return totalMessages; }
        public void setTotalMessages(Long totalMessages) { this.totalMessages = totalMessages; }
        
        public Long getTotalTokens() { return totalTokens; }
        public void setTotalTokens(Long totalTokens) { this.totalTokens = totalTokens; }
        
        public Double getAvgResponseTime() { return avgResponseTime; }
        public void setAvgResponseTime(Double avgResponseTime) { this.avgResponseTime = avgResponseTime; }
        
        public Double getSuccessRate() { return successRate; }
        public void setSuccessRate(Double successRate) { this.successRate = successRate; }
        
        public java.time.LocalDateTime getLastUsedAt() { return lastUsedAt; }
        public void setLastUsedAt(java.time.LocalDateTime lastUsedAt) { this.lastUsedAt = lastUsedAt; }
    }
}