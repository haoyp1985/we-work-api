/**
 * 智能体版本管理相关 API 服务
 */

import httpClient from '@/utils/request'
import type { 
  Agent,
  ApiResult,
  PageResult
} from '@/types/api'

// 版本状态枚举
export type VersionStatus = 'DRAFT' | 'TESTING' | 'PUBLISHED' | 'ARCHIVED'
export type DeploymentStatus = 'PENDING' | 'DEPLOYING' | 'SUCCESS' | 'FAILED' | 'ROLLBACK'

// 版本信息接口
export interface AgentVersion {
  id: string
  agentId: string
  agentName: string
  version: string
  versionCode: number
  title: string
  description?: string
  status: VersionStatus
  deploymentStatus: DeploymentStatus
  configuration: {
    name: string
    description: string
    type: string
    platformType: string
    modelName: string
    systemPrompt: string
    temperature: number
    maxTokens: number
    topP: number
    frequencyPenalty: number
    presencePenalty: number
    features: string[]
    security: Record<string, any>
  }
  metadata: {
    createdBy: string
    createdByName: string
    createdAt: string
    publishedBy?: string
    publishedByName?: string
    publishedAt?: string
    rollbackFrom?: string
    rollbackReason?: string
  }
  statistics: {
    deploymentCount: number
    conversationCount: number
    messageCount: number
    errorCount: number
    averageResponseTime: number
    satisfactionScore: number
  }
  changeLog: string
  tags: string[]
}

// 版本比较结果
export interface VersionComparison {
  sourceVersion: AgentVersion
  targetVersion: AgentVersion
  differences: Array<{
    field: string
    fieldName: string
    sourceValue: any
    targetValue: any
    changeType: 'ADDED' | 'REMOVED' | 'MODIFIED'
    severity: 'LOW' | 'MEDIUM' | 'HIGH'
  }>
  summary: {
    totalChanges: number
    configChanges: number
    promptChanges: number
    parameterChanges: number
    featureChanges: number
  }
}

// 灰度发布配置
export interface GrayReleaseConfig {
  strategy: 'PERCENTAGE' | 'USER_LIST' | 'DEPARTMENT' | 'REGION'
  percentage?: number
  userIds?: string[]
  departmentIds?: string[]
  regions?: string[]
  duration: number // 灰度时长（小时）
  rollbackThreshold: {
    errorRate: number // 错误率阈值
    responseTime: number // 响应时间阈值
    satisfactionScore: number // 满意度阈值
  }
  autoRollback: boolean
}

// ==================== 版本管理 ====================

/**
 * 获取智能体版本列表
 */
export function getAgentVersions(agentId: string, params?: {
  current?: number
  size?: number
  status?: VersionStatus
  keyword?: string
}): Promise<ApiResult<PageResult<AgentVersion>>> {
  return httpClient.get(`/agents/${agentId}/versions`, params)
}

/**
 * 获取版本详情
 */
export function getAgentVersion(agentId: string, versionId: string): Promise<ApiResult<AgentVersion>> {
  return httpClient.get(`/agents/${agentId}/versions/${versionId}`)
}

/**
 * 创建新版本
 */
export function createAgentVersion(agentId: string, data: {
  title: string
  description?: string
  changeLog: string
  baseVersionId?: string
  configuration?: Partial<AgentVersion['configuration']>
}): Promise<ApiResult<{ versionId: string }>> {
  return httpClient.post(`/agents/${agentId}/versions`, data, {
    showSuccessMessage: true
  })
}

/**
 * 更新版本信息
 */
export function updateAgentVersion(agentId: string, versionId: string, data: {
  title?: string
  description?: string
  changeLog?: string
  configuration?: Partial<AgentVersion['configuration']>
  tags?: string[]
}): Promise<ApiResult<void>> {
  return httpClient.put(`/agents/${agentId}/versions/${versionId}`, data, {
    showSuccessMessage: true
  })
}

/**
 * 删除版本
 */
export function deleteAgentVersion(agentId: string, versionId: string): Promise<ApiResult<void>> {
  return httpClient.delete(`/agents/${agentId}/versions/${versionId}`, {
    showSuccessMessage: true
  })
}

/**
 * 复制版本
 */
export function cloneAgentVersion(agentId: string, versionId: string, data: {
  title: string
  description?: string
  changeLog: string
}): Promise<ApiResult<{ versionId: string }>> {
  return httpClient.post(`/agents/${agentId}/versions/${versionId}/clone`, data, {
    showSuccessMessage: true
  })
}

// ==================== 版本发布 ====================

/**
 * 发布版本到测试环境
 */
export function publishVersionToTest(agentId: string, versionId: string): Promise<ApiResult<{
  deploymentId: string
  status: DeploymentStatus
}>> {
  return httpClient.post(`/agents/${agentId}/versions/${versionId}/publish-test`, {}, {
    showSuccessMessage: true
  })
}

/**
 * 发布版本到生产环境
 */
export function publishVersionToProduction(agentId: string, versionId: string, config?: {
  immediate: boolean
  grayRelease?: GrayReleaseConfig
}): Promise<ApiResult<{
  deploymentId: string
  status: DeploymentStatus
}>> {
  return httpClient.post(`/agents/${agentId}/versions/${versionId}/publish-production`, config, {
    showSuccessMessage: true
  })
}

/**
 * 灰度发布
 */
export function startGrayRelease(agentId: string, versionId: string, config: GrayReleaseConfig): Promise<ApiResult<{
  releaseId: string
  estimatedCompletion: string
}>> {
  return httpClient.post(`/agents/${agentId}/versions/${versionId}/gray-release`, config, {
    showSuccessMessage: true
  })
}

/**
 * 停止灰度发布
 */
export function stopGrayRelease(agentId: string, versionId: string, releaseId: string): Promise<ApiResult<void>> {
  return httpClient.post(`/agents/${agentId}/versions/${versionId}/gray-release/${releaseId}/stop`, {}, {
    showSuccessMessage: true
  })
}

/**
 * 灰度发布全量上线
 */
export function promoteGrayRelease(agentId: string, versionId: string, releaseId: string): Promise<ApiResult<void>> {
  return httpClient.post(`/agents/${agentId}/versions/${versionId}/gray-release/${releaseId}/promote`, {}, {
    showSuccessMessage: true
  })
}

// ==================== 版本回滚 ====================

/**
 * 回滚到指定版本
 */
export function rollbackToVersion(agentId: string, targetVersionId: string, reason: string): Promise<ApiResult<{
  deploymentId: string
}>> {
  return httpClient.post(`/agents/${agentId}/versions/${targetVersionId}/rollback`, { reason }, {
    showSuccessMessage: true
  })
}

/**
 * 获取可回滚的版本列表
 */
export function getRollbackableVersions(agentId: string): Promise<ApiResult<AgentVersion[]>> {
  return httpClient.get(`/agents/${agentId}/versions/rollbackable`)
}

// ==================== 版本比较 ====================

/**
 * 比较两个版本的差异
 */
export function compareVersions(agentId: string, sourceVersionId: string, targetVersionId: string): Promise<ApiResult<VersionComparison>> {
  return httpClient.get(`/agents/${agentId}/versions/compare`, {
    source: sourceVersionId,
    target: targetVersionId
  })
}

/**
 * 获取版本变更历史
 */
export function getVersionChangeHistory(agentId: string, versionId: string): Promise<ApiResult<Array<{
  id: string
  action: 'CREATE' | 'UPDATE' | 'PUBLISH' | 'ROLLBACK' | 'DELETE'
  field?: string
  oldValue?: any
  newValue?: any
  operator: string
  operatorName: string
  timestamp: string
  reason?: string
}>>> {
  return httpClient.get(`/agents/${agentId}/versions/${versionId}/history`)
}

// ==================== 版本统计 ====================

/**
 * 获取版本性能统计
 */
export function getVersionStatistics(agentId: string, versionId: string, timeRange?: {
  startDate: string
  endDate: string
}): Promise<ApiResult<{
  basic: {
    deploymentCount: number
    conversationCount: number
    messageCount: number
    userCount: number
    avgSessionDuration: number
  }
  performance: {
    averageResponseTime: number
    p95ResponseTime: number
    p99ResponseTime: number
    successRate: number
    errorRate: number
    timeSeriesData: Array<{
      timestamp: string
      responseTime: number
      successRate: number
      errorCount: number
    }>
  }
  quality: {
    satisfactionScore: number
    positiveRate: number
    negativeRate: number
    feedbackCount: number
    commonIssues: Array<{
      issue: string
      count: number
      percentage: number
    }>
  }
  usage: {
    peakHours: Array<{
      hour: number
      count: number
    }>
    topUsers: Array<{
      userId: string
      userName: string
      messageCount: number
    }>
    popularFeatures: Array<{
      feature: string
      usageCount: number
    }>
  }
}>> {
  return httpClient.get(`/agents/${agentId}/versions/${versionId}/statistics`, timeRange)
}

/**
 * 获取版本对比分析
 */
export function getVersionAnalysis(agentId: string, versionIds: string[]): Promise<ApiResult<{
  versions: AgentVersion[]
  comparison: {
    performance: Array<{
      versionId: string
      version: string
      responseTime: number
      successRate: number
      satisfactionScore: number
    }>
    usage: Array<{
      versionId: string
      version: string
      conversationCount: number
      messageCount: number
      userCount: number
    }>
    trends: Array<{
      date: string
      metrics: Array<{
        versionId: string
        responseTime: number
        successRate: number
        messageCount: number
      }>
    }>
  }
  recommendations: Array<{
    type: 'PERFORMANCE' | 'QUALITY' | 'USAGE'
    title: string
    description: string
    priority: 'HIGH' | 'MEDIUM' | 'LOW'
    action: string
  }>
}>> {
  return httpClient.post('/agents/versions/analysis', { agentId, versionIds })
}

// ==================== 版本导入导出 ====================

/**
 * 导出版本配置
 */
export function exportVersionConfig(agentId: string, versionId: string): Promise<ApiResult<{
  downloadUrl: string
  fileName: string
}>> {
  return httpClient.get(`/agents/${agentId}/versions/${versionId}/export`)
}

/**
 * 导入版本配置
 */
export function importVersionConfig(agentId: string, file: File, options: {
  title: string
  description?: string
  overwriteExisting: boolean
}): Promise<ApiResult<{
  versionId: string
  warnings: string[]
}>> {
  const formData = new FormData()
  formData.append('file', file)
  formData.append('options', JSON.stringify(options))
  
  return httpClient.post(`/agents/${agentId}/versions/import`, formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    },
    showSuccessMessage: true
  })
}

// ==================== 版本模板 ====================

/**
 * 获取版本模板列表
 */
export function getVersionTemplates(): Promise<ApiResult<Array<{
  id: string
  name: string
  description: string
  category: string
  configuration: Partial<AgentVersion['configuration']>
  previewImage?: string
  usageCount: number
  rating: number
  tags: string[]
  createdAt: string
}>>> {
  return httpClient.get('/agents/version-templates')
}

/**
 * 从模板创建版本
 */
export function createVersionFromTemplate(agentId: string, templateId: string, data: {
  title: string
  description?: string
  changeLog: string
  customizations?: Record<string, any>
}): Promise<ApiResult<{ versionId: string }>> {
  return httpClient.post(`/agents/${agentId}/versions/from-template/${templateId}`, data, {
    showSuccessMessage: true
  })
}