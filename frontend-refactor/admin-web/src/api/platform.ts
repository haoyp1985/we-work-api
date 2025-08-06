/**
 * 平台集成相关 API 服务
 */

import httpClient from '@/utils/request'
import type { 
  PlatformConfig, 
  ModelConfig,
  PlatformType,
  PlatformConfigStatus,
  ModelConfigStatus,
  PageResult,
  ApiResult
} from '@/types/api'

// ==================== 平台配置相关 ====================

/**
 * 获取平台配置列表
 */
export function getPlatformConfigs(params?: {
  current?: number
  size?: number
  keyword?: string
  platformType?: PlatformType
  status?: PlatformConfigStatus
}): Promise<ApiResult<PageResult<PlatformConfig>>> {
  return httpClient.get<PageResult<PlatformConfig>>('/platform-configs', params)
}

/**
 * 获取平台配置详情
 */
export function getPlatformConfig(id: string): Promise<ApiResult<PlatformConfig>> {
  return httpClient.get<PlatformConfig>(`/platform-configs/${id}`)
}

/**
 * 创建平台配置
 */
export function createPlatformConfig(data: {
  name: string
  platformType: PlatformType
  description?: string
  config: {
    apiKey: string
    apiUrl?: string
    organizationId?: string
    region?: string
    model?: string
    maxRetries?: number
    timeout?: number
  }
}): Promise<ApiResult<PlatformConfig>> {
  return httpClient.post<PlatformConfig>('/platform-configs', data, {
    showSuccessMessage: true
  })
}

/**
 * 更新平台配置
 */
export function updatePlatformConfig(id: string, data: {
  name?: string
  description?: string
  config?: any
  status?: PlatformConfigStatus
}): Promise<ApiResult<PlatformConfig>> {
  return httpClient.put<PlatformConfig>(`/platform-configs/${id}`, data, {
    showSuccessMessage: true
  })
}

/**
 * 删除平台配置
 */
export function deletePlatformConfig(id: string): Promise<ApiResult<void>> {
  return httpClient.delete<void>(`/platform-configs/${id}`, {
    showSuccessMessage: true
  })
}

/**
 * 测试平台连接
 */
export function testPlatformConnection(id: string): Promise<ApiResult<{
  success: boolean
  message: string
  responseTime: number
  details?: any
}>> {
  return httpClient.post(`/platform-configs/${id}/test`)
}

/**
 * 设置默认平台配置
 */
export function setDefaultPlatformConfig(id: string): Promise<ApiResult<PlatformConfig>> {
  return httpClient.post<PlatformConfig>(`/platform-configs/${id}/set-default`, {}, {
    showSuccessMessage: true
  })
}

/**
 * 获取平台使用统计
 */
export function getPlatformUsageStats(id: string, dateRange?: [string, string]): Promise<ApiResult<{
  requestCount: number
  tokenCount: number
  cost: number
  errorRate: number
  avgResponseTime: number
  timeSeriesData: Array<{
    date: string
    requests: number
    tokens: number
    cost: number
    avgResponseTime: number
  }>
}>> {
  const params = dateRange ? {
    startDate: dateRange[0],
    endDate: dateRange[1]
  } : {}
  
  return httpClient.get(`/platform-configs/${id}/stats`, params)
}

// ==================== 模型配置相关 ====================

/**
 * 获取模型配置列表
 */
export function getModelConfigs(params?: {
  current?: number
  size?: number
  keyword?: string
  platformType?: PlatformType
  platformConfigId?: string
  status?: ModelConfigStatus
}): Promise<ApiResult<PageResult<ModelConfig>>> {
  return httpClient.get<PageResult<ModelConfig>>('/model-configs', params)
}

/**
 * 获取模型配置详情
 */
export function getModelConfig(id: string): Promise<ApiResult<ModelConfig>> {
  return httpClient.get<ModelConfig>(`/model-configs/${id}`)
}

/**
 * 创建模型配置
 */
export function createModelConfig(data: {
  name: string
  platformConfigId: string
  platformType: PlatformType
  modelName: string
  displayName: string
  description?: string
  parameters: {
    maxTokens: number
    temperature: number
    topP: number
    topK?: number
    frequencyPenalty: number
    presencePenalty: number
    stopSequences?: string[]
    streamMode: boolean
  }
  pricing: {
    inputTokenPrice: number
    outputTokenPrice: number
    currency: string
    billingUnit: string
  }
  capabilities: {
    maxContextLength: number
    supportsFunctionCalling: boolean
    supportsImageInput: boolean
    supportsAudioInput: boolean
    supportsVideoInput: boolean
    supportsFileUploads: boolean
    supportsWebSearch: boolean
    supportsCodeExecution: boolean
    languages: string[]
  }
}): Promise<ApiResult<ModelConfig>> {
  return httpClient.post<ModelConfig>('/model-configs', data, {
    showSuccessMessage: true
  })
}

/**
 * 更新模型配置
 */
export function updateModelConfig(id: string, data: Partial<{
  name: string
  displayName: string
  description: string
  parameters: any
  pricing: any
  capabilities: any
  status: ModelConfigStatus
  isDefault: boolean
}>): Promise<ApiResult<ModelConfig>> {
  return httpClient.put<ModelConfig>(`/model-configs/${id}`, data, {
    showSuccessMessage: true
  })
}

/**
 * 删除模型配置
 */
export function deleteModelConfig(id: string): Promise<ApiResult<void>> {
  return httpClient.delete<void>(`/model-configs/${id}`, {
    showSuccessMessage: true
  })
}

/**
 * 设置默认模型配置
 */
export function setDefaultModelConfig(id: string): Promise<ApiResult<ModelConfig>> {
  return httpClient.post<ModelConfig>(`/model-configs/${id}/set-default`, {}, {
    showSuccessMessage: true
  })
}

/**
 * 测试模型
 */
export function testModel(id: string, message: string): Promise<ApiResult<{
  response: string
  tokens: number
  cost: number
  responseTime: number
}>> {
  return httpClient.post(`/model-configs/${id}/test`, { message })
}

/**
 * 获取模型使用统计
 */
export function getModelUsageStats(id: string, dateRange?: [string, string]): Promise<ApiResult<{
  requestCount: number
  tokenCount: number
  cost: number
  avgResponseTime: number
  successRate: number
  timeSeriesData: Array<{
    date: string
    requests: number
    tokens: number
    cost: number
    avgResponseTime: number
    successRate: number
  }>
}>> {
  const params = dateRange ? {
    startDate: dateRange[0],
    endDate: dateRange[1]
  } : {}
  
  return httpClient.get(`/model-configs/${id}/stats`, params)
}

// ==================== 支持的平台和模型 ====================

/**
 * 获取支持的平台类型
 */
export function getSupportedPlatforms(): Promise<ApiResult<Array<{
  type: PlatformType
  name: string
  description: string
  logoUrl?: string
  documentUrl?: string
  features: string[]
  configFields: Array<{
    name: string
    label: string
    type: 'text' | 'password' | 'url' | 'select' | 'number'
    required: boolean
    placeholder?: string
    options?: Array<{ label: string; value: string }>
    validation?: {
      pattern?: string
      message?: string
    }
  }>
}>>> {
  return httpClient.get('/platform-configs/supported-platforms')
}

/**
 * 获取平台支持的模型列表
 */
export function getPlatformModels(platformType: PlatformType): Promise<ApiResult<Array<{
  name: string
  displayName: string
  description: string
  maxContextLength: number
  pricing: {
    inputTokenPrice: number
    outputTokenPrice: number
    currency: string
  }
  capabilities: {
    supportsFunctionCalling: boolean
    supportsImageInput: boolean
    supportsAudioInput: boolean
    supportsVideoInput: boolean
    supportsFileUploads: boolean
    supportsWebSearch: boolean
    supportsCodeExecution: boolean
    languages: string[]
  }
  deprecated?: boolean
}>>> {
  return httpClient.get(`/platform-configs/supported-models/${platformType}`)
}

/**
 * 验证平台配置
 */
export function validatePlatformConfig(data: {
  platformType: PlatformType
  config: any
}): Promise<ApiResult<{
  valid: boolean
  errors: string[]
  warnings: string[]
}>> {
  return httpClient.post('/platform-configs/validate', data)
}

/**
 * 获取平台配置模板
 */
export function getPlatformConfigTemplate(platformType: PlatformType): Promise<ApiResult<{
  name: string
  description: string
  config: any
  parameters: any
  capabilities: any
}>> {
  return httpClient.get(`/platform-configs/templates/${platformType}`)
}

// ==================== 密钥管理 ====================

/**
 * 生成新的API密钥
 */
export function generateApiKey(platformConfigId: string): Promise<ApiResult<{
  apiKey: string
  maskedKey: string
  expiresAt?: string
}>> {
  return httpClient.post(`/platform-configs/${platformConfigId}/generate-key`, {}, {
    showSuccessMessage: true
  })
}

/**
 * 轮换API密钥
 */
export function rotateApiKey(platformConfigId: string): Promise<ApiResult<{
  newApiKey: string
  maskedKey: string
  oldKeyExpiry: string
}>> {
  return httpClient.post(`/platform-configs/${platformConfigId}/rotate-key`, {}, {
    showSuccessMessage: true
  })
}

/**
 * 验证API密钥
 */
export function validateApiKey(platformConfigId: string): Promise<ApiResult<{
  valid: boolean
  expiresAt?: string
  quota?: {
    used: number
    limit: number
    remaining: number
  }
}>> {
  return httpClient.post(`/platform-configs/${platformConfigId}/validate-key`)
}

// ==================== 配额和计费 ====================

/**
 * 获取平台配额信息
 */
export function getPlatformQuota(platformConfigId: string): Promise<ApiResult<{
  quota: {
    requests: {
      used: number
      limit: number
      remaining: number
      resetAt: string
    }
    tokens: {
      used: number
      limit: number
      remaining: number
      resetAt: string
    }
    cost: {
      used: number
      limit: number
      remaining: number
      currency: string
    }
  }
  billing: {
    currentPeriod: {
      startDate: string
      endDate: string
      totalCost: number
      currency: string
    }
    usage: Array<{
      date: string
      requests: number
      tokens: number
      cost: number
    }>
  }
}>> {
  return httpClient.get(`/platform-configs/${platformConfigId}/quota`)
}

/**
 * 设置配额限制
 */
export function setQuotaLimits(platformConfigId: string, data: {
  requestLimit?: number
  tokenLimit?: number
  costLimit?: number
  currency?: string
}): Promise<ApiResult<void>> {
  return httpClient.put(`/platform-configs/${platformConfigId}/quota`, data, {
    showSuccessMessage: true
  })
}

/**
 * 获取成本分析
 */
export function getCostAnalysis(params?: {
  platformConfigId?: string
  startDate?: string
  endDate?: string
  groupBy?: 'day' | 'week' | 'month'
}): Promise<ApiResult<{
  totalCost: number
  currency: string
  period: {
    startDate: string
    endDate: string
  }
  breakdown: {
    byPlatform: Array<{
      platformType: PlatformType
      platformName: string
      cost: number
      percentage: number
    }>
    byModel: Array<{
      modelName: string
      cost: number
      percentage: number
    }>
    byUser: Array<{
      userId: string
      userName: string
      cost: number
      percentage: number
    }>
  }
  trend: Array<{
    date: string
    cost: number
    requests: number
    tokens: number
  }>
}>> {
  return httpClient.get('/platform-configs/cost-analysis', params)
}