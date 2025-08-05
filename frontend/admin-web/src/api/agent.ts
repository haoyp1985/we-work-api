import { http } from '@/utils/request'
import type { ApiResponse, PageResult } from '@/types'
import type { 
  AgentDTO,
  CreateAgentRequest,
  UpdateAgentRequest,
  AgentQueryRequest,
  AgentStatistics,
  ChatRequest,
  ChatResponse,
  ConversationDTO,
  MessageDTO,
  PlatformConfigDTO,
  ModelConfigDTO,
  CallRecordDTO,
  AgentStatus
} from '@/types/agent'

// 获取当前用户ID的临时实现
const getUserId = (): string => {
  // TODO: 从认证系统获取真实用户ID
  return 'current-user-id'
}

/**
 * AI智能体管理API
 */
export const agentApi = {
  
  // ==================== 智能体管理 ====================

  /**
   * 创建智能体
   */
  createAgent(data: CreateAgentRequest) {
    return http.post<AgentDTO>('/api/v1/agents', data)
  },

  /**
   * 更新智能体
   */
  updateAgent(agentId: string, data: UpdateAgentRequest) {
    return http.put<AgentDTO>(`/api/v1/agents/${agentId}`, data)
  },

  /**
   * 删除智能体
   */
  deleteAgent(agentId: string) {
    return http.delete<void>(`/api/v1/agents/${agentId}`)
  },

  /**
   * 获取智能体详情
   */
  getAgent(agentId: string) {
    return http.get<AgentDTO>(`/api/v1/agents/${agentId}`)
  },

  /**
   * 分页查询智能体
   */
  queryAgents(params: AgentQueryRequest) {
    return http.get<PageResult<AgentDTO>>('/api/v1/agents', params)
  },

  /**
   * 发布智能体
   */
  publishAgent(agentId: string) {
    return http.post<AgentDTO>(`/api/v1/agents/${agentId}/publish`)
  },

  /**
   * 下线智能体
   */
  unpublishAgent(agentId: string) {
    return http.post<AgentDTO>(`/api/v1/agents/${agentId}/unpublish`)
  },

  /**
   * 创建智能体新版本
   */
  createAgentVersion(agentId: string) {
    return http.post<AgentDTO>(`/api/v1/agents/${agentId}/version`)
  },

  /**
   * 获取已发布的智能体
   */
  getPublishedAgents() {
    return http.get<AgentDTO[]>('/api/v1/agents/published')
  },

  /**
   * 获取智能体统计信息
   */
  getAgentStatistics() {
    return http.get<AgentStatistics>('/api/v1/agents/statistics')
  },

  // ==================== 对话聊天 ====================

  /**
   * 发送聊天消息
   */
  sendMessage(data: ChatRequest) {
    return http.post<ChatResponse>('/api/v1/chat/message', data)
  },

  /**
   * 流式聊天
   */
  sendStreamMessage(data: ChatRequest) {
    return http.post<ChatResponse>('/api/v1/chat/stream', data)
  },

  /**
   * 获取会话列表
   */
  getConversations(params?: {
    agentId?: string
    status?: string
    pageNum?: number
    pageSize?: number
  }) {
    return http.get<PageResult<ConversationDTO>>('/api/v1/conversations', params)
  },



  /**
   * 获取会话消息列表
   */
  getMessages(conversationId: string, params?: {
    pageNum?: number
    pageSize?: number
    messageType?: string
  }) {
    return http.get<PageResult<MessageDTO>>(`/api/v1/messages/${conversationId}`, params)
  },

  /**
   * 删除消息
   */
  deleteMessage(messageId: string) {
    return http.delete<void>(`/api/v1/messages/${messageId}`)
  },

  // ==================== 平台配置管理 ====================

  /**
   * 获取平台配置列表
   */
  getPlatformConfigs(params?: {
    platformType?: string
    enabled?: boolean
    pageNum?: number
    pageSize?: number
  }) {
    return http.get<PageResult<PlatformConfigDTO>>('/api/v1/platform-configs', params)
  },

  /**
   * 获取平台配置详情
   */
  getPlatformConfig(configId: string) {
    return http.get<PlatformConfigDTO>(`/api/v1/platform-configs/${configId}`)
  },

  /**
   * 创建平台配置
   */
  createPlatformConfig(data: Omit<PlatformConfigDTO, 'id' | 'tenantId' | 'createdAt' | 'updatedAt'>) {
    return http.post<PlatformConfigDTO>('/api/v1/platform-configs', data)
  },

  /**
   * 更新平台配置
   */
  updatePlatformConfig(configId: string, data: Partial<PlatformConfigDTO>) {
    return http.put<PlatformConfigDTO>(`/api/v1/platform-configs/${configId}`, data)
  },

  /**
   * 删除平台配置
   */
  deletePlatformConfig(configId: string) {
    return http.delete<void>(`/api/v1/platform-configs/${configId}`)
  },

  /**
   * 测试平台配置连接
   */
  testPlatformConfig(configId: string) {
    return http.post<{
      success: boolean
      message: string
      responseTime?: number
      details?: any
    }>(`/api/v1/platform-configs/${configId}/test`)
  },

  // ==================== 模型配置管理 ====================

  /**
   * 获取模型配置列表
   */
  getModelConfigs(params?: {
    platformType?: string
    modelName?: string
    enabled?: boolean
    pageNum?: number
    pageSize?: number
  }) {
    return http.get<PageResult<ModelConfigDTO>>('/api/v1/model-configs', params)
  },

  /**
   * 获取模型配置详情
   */
  getModelConfig(configId: string) {
    return http.get<ModelConfigDTO>(`/api/v1/model-configs/${configId}`)
  },

  /**
   * 创建模型配置
   */
  createModelConfig(data: Omit<ModelConfigDTO, 'id' | 'tenantId' | 'createdAt' | 'updatedAt'>) {
    return http.post<ModelConfigDTO>('/api/v1/model-configs', data)
  },

  /**
   * 更新模型配置
   */
  updateModelConfig(configId: string, data: Partial<ModelConfigDTO>) {
    return http.put<ModelConfigDTO>(`/api/v1/model-configs/${configId}`, data)
  },

  /**
   * 删除模型配置
   */
  deleteModelConfig(configId: string) {
    return http.delete<void>(`/api/v1/model-configs/${configId}`)
  },

  /**
   * 测试模型配置
   */
  testModelConfig(configId: string, testMessage?: string) {
    return http.post<{
      success: boolean
      message: string
      response?: string
      responseTime?: number
      tokenUsage?: {
        promptTokens: number
        completionTokens: number
        totalTokens: number
      }
    }>(`/api/v1/model-configs/${configId}/test`, { 
      message: testMessage || 'Hello, this is a test message.' 
    })
  },

  // ==================== 调用记录和监控 ====================

  /**
   * 获取调用记录列表
   */
  getCallRecords(params?: {
    agentId?: string
    conversationId?: string
    platformType?: string
    callStatus?: string
    startTime?: string
    endTime?: string
    pageNum?: number
    pageSize?: number
  }) {
    return http.get<PageResult<CallRecordDTO>>('/api/v1/call-records', params)
  },

  /**
   * 获取调用记录详情
   */
  getCallRecord(recordId: string) {
    return http.get<CallRecordDTO>(`/api/v1/call-records/${recordId}`)
  },

  /**
   * 获取调用统计
   */
  getCallStatistics(params?: {
    agentId?: string
    platformType?: string
    startTime?: string
    endTime?: string
    granularity?: 'hour' | 'day' | 'week' | 'month'
  }) {
    return http.get<{
      totalCalls: number
      successCalls: number
      failedCalls: number
      successRate: number
      avgDuration: number
      totalTokens: number
      totalCost: number
      callTrend: Array<{
        timestamp: string
        totalCalls: number
        successCalls: number
        failedCalls: number
        avgDuration: number
      }>
      platformDistribution: Record<string, number>
      statusDistribution: Record<string, number>
      topErrorMessages: Array<{
        message: string
        count: number
      }>
    }>('/api/v1/call-records/statistics', params)
  },

  // ==================== 智能体使用分析 ====================

  /**
   * 获取智能体使用分析
   */
  getAgentAnalytics(agentId: string, params?: {
    startTime?: string
    endTime?: string
    granularity?: 'hour' | 'day' | 'week' | 'month'
  }) {
    return http.get<{
      totalConversations: number
      totalMessages: number
      activeUsers: number
      avgConversationLength: number
      avgResponseTime: number
      satisfactionScore?: number
      conversationTrend: Array<{
        timestamp: string
        conversations: number
        messages: number
        users: number
      }>
      userEngagement: Array<{
        userId: string
        userName?: string
        conversations: number
        messages: number
        lastActiveAt: string
      }>
      popularQuestions: Array<{
        question: string
        count: number
        avgSatisfaction?: number
      }>
      responseQuality: {
        avgTokens: number
        avgResponseTime: number
        successRate: number
      }
    }>(`/api/v1/agents/${agentId}/analytics`, params)
  },

  // ==================== 批量操作 ====================

  /**
   * 批量更新智能体状态
   */
  batchUpdateAgentStatus(agentIds: string[], status: AgentStatus) {
    return http.post<{
      success: number
      failed: number
      results: Array<{
        agentId: string
        success: boolean
        message: string
      }>
    }>('/api/v1/agents/batch/status', { agentIds, status })
  },

  /**
   * 批量删除智能体
   */
  batchDeleteAgents(agentIds: string[]) {
    return http.post<{
      success: number
      failed: number
      results: Array<{
        agentId: string
        success: boolean
        message: string
      }>
    }>('/api/v1/agents/batch/delete', { agentIds })
  },

  /**
   * 导入智能体配置
   */
  importAgents(file: File) {
    const formData = new FormData()
    formData.append('file', file)
    
    return http.upload<{
      total: number
      success: number
      failed: number
      errors: Array<{
        row: number
        message: string
      }>
    }>('/api/v1/agents/import', formData)
  },

  /**
   * 导出智能体配置
   */
  exportAgents(params?: {
    agentIds?: string[]
    status?: AgentStatus
    format?: 'JSON' | 'YAML' | 'EXCEL'
  }) {
    return http.get('/api/v1/agents/export', {
      params,
      responseType: 'blob'
    })
  },

  // ===== 聊天相关接口 =====
  
  /**
   * 发送聊天消息
   */
  sendChatMessage(data: ChatRequest): Promise<ApiResponse<ChatResponse>> {
    return http.post('/api/v1/chat/send', data)
  },

  /**
   * 在指定会话中发送消息
   */
  sendMessageToConversation(conversationId: string, data: ChatRequest): Promise<ApiResponse<ChatResponse>> {
    return http.post(`/api/v1/chat/conversations/${conversationId}/send`, data)
  },

  /**
   * 流式聊天
   */
  streamChat(data: ChatRequest): Promise<ApiResponse<ChatResponse>> {
    return http.post('/api/v1/chat/stream', data)
  },

  /**
   * 重新生成回复
   */
  regenerateResponse(data: ChatRequest): Promise<ApiResponse<ChatResponse>> {
    return http.post('/api/v1/chat/regenerate', data)
  },

  /**
   * 获取会话上下文
   */
  getConversationContext(conversationId: string, contextSize: number = 10): Promise<ApiResponse<ChatRequest>> {
    return http.get(`/api/v1/chat/conversations/${conversationId}/context`, {
      params: { contextSize },
      headers: {
        'X-User-Id': getUserId()
      }
    })
  },

  /**
   * 清空会话历史
   */
  clearConversationHistory(conversationId: string): Promise<ApiResponse<void>> {
    return http.post(`/api/v1/chat/conversations/${conversationId}/clear`)
  },

  // ===== 会话管理接口 =====

  /**
   * 创建会话
   */
  createConversation(agentId: string, title?: string): Promise<ApiResponse<ConversationDTO>> {
    return http.post('/api/v1/conversations', { agentId, title })
  },

  /**
   * 更新会话标题
   */
  updateConversationTitle(conversationId: string, title: string): Promise<ApiResponse<ConversationDTO>> {
    return http.put(`/api/v1/conversations/${conversationId}/title`, { title })
  },

  /**
   * 结束会话
   */
  endConversation(conversationId: string): Promise<ApiResponse<void>> {
    return http.post(`/api/v1/conversations/${conversationId}/end`)
  },

  /**
   * 删除会话
   */
  deleteConversation(conversationId: string): Promise<ApiResponse<void>> {
    return http.delete(`/api/v1/conversations/${conversationId}`)
  },

  /**
   * 获取会话详情
   */
  getConversation(conversationId: string): Promise<ApiResponse<ConversationDTO>> {
    return http.get(`/api/v1/conversations/${conversationId}`)
  },

  /**
   * 获取用户会话列表
   */
  getUserConversations(userId: string, pageNum: number = 1, pageSize: number = 20): Promise<ApiResponse<PageResult<ConversationDTO>>> {
    return http.get(`/api/v1/conversations/user/${userId}`, {
      params: { pageNum, pageSize }
    })
  },

  /**
   * 获取用户活跃会话
   */
  getActiveConversations(userId: string): Promise<ApiResponse<ConversationDTO[]>> {
    return http.get(`/api/v1/conversations/user/${userId}/active`)
  },

  /**
   * 获取会话统计信息
   */
  getConversationStatistics(): Promise<ApiResponse<Record<string, number>>> {
    return http.get('/api/v1/conversations/statistics')
  },

  // ===== 消息管理接口 =====

  /**
   * 获取消息详情
   */
  getMessage(messageId: string): Promise<ApiResponse<MessageDTO>> {
    return http.get(`/api/v1/messages/${messageId}`)
  },

  /**
   * 获取会话消息列表
   */
  getConversationMessages(conversationId: string, pageNum: number = 1, pageSize: number = 20): Promise<ApiResponse<PageResult<MessageDTO>>> {
    return http.get(`/api/v1/messages/conversation/${conversationId}`, {
      params: { pageNum, pageSize }
    })
  },

  /**
   * 获取会话最近消息
   */
  getRecentMessages(conversationId: string, limit: number = 10): Promise<ApiResponse<MessageDTO[]>> {
    return http.get(`/api/v1/messages/conversation/${conversationId}/recent`, {
      params: { limit }
    })
  },

  // ===== 调用记录和统计监控接口 =====

  /**
   * 获取调用记录列表
   */
  getCallRecords(params: {
    agentId?: string
    userId?: string
    platformType?: string
    callType?: string
    status?: string
    startTime?: string
    endTime?: string
    pageNum?: number
    pageSize?: number
  }): Promise<ApiResponse<PageResult<CallRecordDTO>>> {
    return http.get('/api/v1/call-records', { params })
  },

  /**
   * 获取调用记录详情
   */
  getCallRecord(recordId: string): Promise<ApiResponse<CallRecordDTO>> {
    return http.get(`/api/v1/call-records/${recordId}`)
  },

  /**
   * 获取调用统计数据
   */
  getCallStatistics(params?: {
    agentId?: string
    timeRange?: string // 'day' | 'week' | 'month' | 'quarter' | 'year'
    startTime?: string
    endTime?: string
  }): Promise<ApiResponse<{
    totalCalls: number
    successCalls: number
    failedCalls: number
    avgResponseTime: number
    totalTokens: number
    totalCost: number
    platformDistribution: Array<{
      platform: string
      count: number
      percentage: number
    }>
    timeSeriesData: Array<{
      date: string
      calls: number
      tokens: number
      cost: number
    }>
  }>> {
    return http.get('/api/v1/call-records/statistics', { params })
  },

  /**
   * 获取性能指标
   */
  getPerformanceMetrics(params?: {
    agentId?: string
    timeRange?: string
  }): Promise<ApiResponse<{
    avgResponseTime: number
    p95ResponseTime: number
    p99ResponseTime: number
    errorRate: number
    throughput: number
    concurrentUsers: number
  }>> {
    return http.get('/api/v1/call-records/performance', { params })
  },

  /**
   * 获取成本分析
   */
  getCostAnalysis(params?: {
    agentId?: string
    timeRange?: string
    groupBy?: 'platform' | 'agent' | 'user'
  }): Promise<ApiResponse<{
    totalCost: number
    costTrend: Array<{
      date: string
      cost: number
    }>
    costByPlatform: Array<{
      platform: string
      cost: number
      percentage: number
    }>
    costByAgent: Array<{
      agentId: string
      agentName: string
      cost: number
      percentage: number
    }>
  }>> {
    return http.get('/api/v1/call-records/cost-analysis', { params })
  }
}