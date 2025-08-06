/**
 * AI智能体相关 API 服务
 */

import httpClient from '@/utils/request'
import type { 
  Agent, 
  CreateAgentRequest, 
  UpdateAgentRequest,
  AgentQuery,
  PageResult,
  ApiResult,
  UsageStats
} from '@/types/api'

/**
 * 获取智能体列表
 */
export function getAgents(params: AgentQuery): Promise<ApiResult<PageResult<Agent>>> {
  return httpClient.get<PageResult<Agent>>('/agents', params)
}

/**
 * 获取智能体详情
 */
export function getAgent(id: string): Promise<ApiResult<Agent>> {
  return httpClient.get<Agent>(`/agents/${id}`)
}

/**
 * 创建智能体
 */
export function createAgent(data: CreateAgentRequest): Promise<ApiResult<Agent>> {
  return httpClient.post<Agent>('/agents', data, {
    showSuccessMessage: true
  })
}

/**
 * 更新智能体
 */
export function updateAgent(data: UpdateAgentRequest): Promise<ApiResult<Agent>> {
  return httpClient.put<Agent>(`/agents/${data.id}`, data, {
    showSuccessMessage: true
  })
}

/**
 * 删除智能体
 */
export function deleteAgent(id: string): Promise<ApiResult<void>> {
  return httpClient.delete<void>(`/agents/${id}`, {
    showSuccessMessage: true
  })
}

/**
 * 批量删除智能体
 */
export function batchDeleteAgents(ids: string[]): Promise<ApiResult<void>> {
  return httpClient.post<void>('/agents/batch-delete', { ids }, {
    showSuccessMessage: true
  })
}

/**
 * 启用/禁用智能体
 */
export function toggleAgentStatus(id: string, status: 'PUBLISHED' | 'DISABLED'): Promise<ApiResult<Agent>> {
  return httpClient.patch<Agent>(`/agents/${id}/status`, { status }, {
    showSuccessMessage: true
  })
}

/**
 * 复制智能体
 */
export function cloneAgent(id: string, name: string): Promise<ApiResult<Agent>> {
  return httpClient.post<Agent>(`/agents/${id}/clone`, { name }, {
    showSuccessMessage: true
  })
}

/**
 * 发布智能体
 */
export function publishAgent(id: string): Promise<ApiResult<Agent>> {
  return httpClient.post<Agent>(`/agents/${id}/publish`, {}, {
    showSuccessMessage: true
  })
}

/**
 * 下线智能体
 */
export function unpublishAgent(id: string): Promise<ApiResult<Agent>> {
  return httpClient.post<Agent>(`/agents/${id}/unpublish`, {}, {
    showSuccessMessage: true
  })
}

/**
 * 获取智能体统计信息
 */
export function getAgentStats(id: string, dateRange?: [string, string]): Promise<ApiResult<UsageStats>> {
  const params = dateRange ? {
    startDate: dateRange[0],
    endDate: dateRange[1]
  } : {}
  return httpClient.get<UsageStats>(`/agents/${id}/stats`, params)
}

/**
 * 获取智能体对话列表
 */
export function getAgentConversations(id: string, params?: {
  current?: number
  size?: number
  keyword?: string
  status?: string
}): Promise<ApiResult<PageResult<any>>> {
  return httpClient.get<PageResult<any>>(`/agents/${id}/conversations`, params)
}

/**
 * 导出智能体配置
 */
export function exportAgentConfig(id: string): Promise<void> {
  return httpClient.download(`/agents/${id}/export`, {}, `agent-${id}-config.json`)
}

/**
 * 导入智能体配置
 */
export function importAgentConfig(file: File): Promise<ApiResult<Agent>> {
  return httpClient.upload<Agent>('/agents/import', file, undefined, {
    showSuccessMessage: true
  })
}

/**
 * 测试智能体
 */
export function testAgent(id: string, message: string): Promise<ApiResult<{
  response: string
  tokens: number
  cost: number
  duration: number
}>> {
  return httpClient.post(`/agents/${id}/test`, { message })
}

/**
 * 获取智能体版本列表
 */
export function getAgentVersions(id: string): Promise<ApiResult<Array<{
  id: string
  version: string
  description: string
  createdAt: string
  isActive: boolean
}>>> {
  return httpClient.get(`/agents/${id}/versions`)
}

/**
 * 创建智能体版本
 */
export function createAgentVersion(id: string, data: {
  version: string
  description: string
}): Promise<ApiResult<void>> {
  return httpClient.post(`/agents/${id}/versions`, data, {
    showSuccessMessage: true
  })
}

/**
 * 回滚到指定版本
 */
export function rollbackToVersion(id: string, versionId: string): Promise<ApiResult<Agent>> {
  return httpClient.post(`/agents/${id}/versions/${versionId}/rollback`, {}, {
    showSuccessMessage: true
  })
}

/**
 * 获取智能体可用的模型列表
 */
export function getAvailableModels(platformType: string): Promise<ApiResult<Array<{
  name: string
  displayName: string
  description: string
  maxTokens: number
  pricing: {
    input: number
    output: number
  }
}>>> {
  return httpClient.get('/agents/available-models', { platformType })
}

/**
 * 验证智能体配置
 */
export function validateAgentConfig(data: Partial<CreateAgentRequest>): Promise<ApiResult<{
  valid: boolean
  errors: string[]
  warnings: string[]
}>> {
  return httpClient.post('/agents/validate', data)
}

/**
 * 获取智能体使用建议
 */
export function getAgentRecommendations(id: string): Promise<ApiResult<Array<{
  type: 'performance' | 'cost' | 'quality'
  title: string
  description: string
  impact: 'high' | 'medium' | 'low'
  action: string
}>>> {
  return httpClient.get(`/agents/${id}/recommendations`)
}

/**
 * 获取智能体标签建议
 */
export function getTagSuggestions(query: string): Promise<ApiResult<string[]>> {
  return httpClient.get('/agents/tag-suggestions', { query })
}

/**
 * 获取热门智能体模板
 */
export function getAgentTemplates(): Promise<ApiResult<Array<{
  id: string
  name: string
  description: string
  type: string
  category: string
  tags: string[]
  usageCount: number
  rating: number
  preview: any
}>>> {
  return httpClient.get('/agents/templates')
}

/**
 * 从模板创建智能体
 */
export function createFromTemplate(templateId: string, data: {
  name: string
  description?: string
}): Promise<ApiResult<Agent>> {
  return httpClient.post(`/agents/templates/${templateId}/create`, data, {
    showSuccessMessage: true
  })
}

/**
 * 分享智能体
 */
export function shareAgent(id: string, data: {
  shareType: 'public' | 'link' | 'users'
  users?: string[]
  expiresAt?: string
}): Promise<ApiResult<{
  shareId: string
  shareUrl: string
  expiresAt?: string
}>> {
  return httpClient.post(`/agents/${id}/share`, data, {
    showSuccessMessage: true
  })
}

/**
 * 取消分享智能体
 */
export function unshareAgent(id: string): Promise<ApiResult<void>> {
  return httpClient.delete(`/agents/${id}/share`, {
    showSuccessMessage: true
  })
}

/**
 * 收藏/取消收藏智能体
 */
export function toggleAgentFavorite(id: string, favorite: boolean): Promise<ApiResult<void>> {
  return httpClient.post(`/agents/${id}/favorite`, { favorite }, {
    showSuccessMessage: true
  })
}

/**
 * 获取我的收藏智能体
 */
export function getFavoriteAgents(params?: {
  current?: number
  size?: number
}): Promise<ApiResult<PageResult<Agent>>> {
  return httpClient.get<PageResult<Agent>>('/agents/favorites', params)
}

/**
 * 获取智能体访问日志
 */
export function getAgentAccessLogs(id: string, params?: {
  current?: number
  size?: number
  startDate?: string
  endDate?: string
}): Promise<ApiResult<PageResult<any>>> {
  return httpClient.get<PageResult<any>>(`/agents/${id}/access-logs`, params)
}