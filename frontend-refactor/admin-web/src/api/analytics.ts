/**
 * 数据分析相关 API 服务
 */

import httpClient from '@/utils/request'
import type { 
  UsageStats,
  StatsPeriod,
  TimeSeriesData,
  AgentStats,
  PlatformStats,
  UserStats,
  ApiResult
} from '@/types/api'

// ==================== 总览统计 ====================

/**
 * 获取总览统计数据
 */
export function getOverviewStats(period: StatsPeriod = 'LAST_30_DAYS'): Promise<ApiResult<{
  totalUsers: number
  totalAgents: number
  totalConversations: number
  totalMessages: number
  totalCost: number
  totalTokens: number
  growth: {
    users: number
    agents: number
    conversations: number
    messages: number
    cost: number
    tokens: number
  }
}>> {
  return httpClient.get('/analytics/overview', { period })
}

/**
 * 获取实时统计数据
 */
export function getRealTimeStats(): Promise<ApiResult<{
  activeUsers: number
  activeConversations: number
  messagesPerMinute: number
  averageResponseTime: number
  platformStatus: Array<{
    platform: string
    status: 'online' | 'offline' | 'degraded'
    responseTime: number
  }>
  systemLoad: {
    cpu: number
    memory: number
    storage: number
  }
}>> {
  return httpClient.get('/analytics/realtime')
}

// ==================== 使用统计 ====================

/**
 * 获取用户使用统计
 */
export function getUserUsageStats(params?: {
  period?: StatsPeriod
  startDate?: string
  endDate?: string
  groupBy?: 'day' | 'week' | 'month'
  userId?: string
}): Promise<ApiResult<{
  totalUsers: number
  activeUsers: number
  newUsers: number
  userRetention: number
  timeSeriesData: TimeSeriesData[]
  topUsers: Array<{
    userId: string
    userName: string
    totalMessages: number
    totalCost: number
    lastActiveAt: string
  }>
  userGrowthTrend: Array<{
    date: string
    newUsers: number
    activeUsers: number
    totalUsers: number
  }>
}>> {
  return httpClient.get('/analytics/usage/users', params)
}

/**
 * 获取智能体使用统计
 */
export function getAgentUsageStats(params?: {
  period?: StatsPeriod
  startDate?: string
  endDate?: string
  agentId?: string
  groupBy?: 'day' | 'week' | 'month'
}): Promise<ApiResult<{
  totalAgents: number
  activeAgents: number
  totalConversations: number
  totalMessages: number
  averageConversationsPerAgent: number
  timeSeriesData: TimeSeriesData[]
  topAgents: Array<{
    agentId: string
    agentName: string
    conversationCount: number
    messageCount: number
    averageRating: number
    totalCost: number
    usageGrowth: number
  }>
  agentPerformance: Array<{
    agentId: string
    agentName: string
    averageResponseTime: number
    successRate: number
    userSatisfaction: number
  }>
}>> {
  return httpClient.get('/analytics/usage/agents', params)
}

/**
 * 获取对话统计
 */
export function getConversationStats(params?: {
  period?: StatsPeriod
  startDate?: string
  endDate?: string
  agentId?: string
  userId?: string
}): Promise<ApiResult<{
  totalConversations: number
  activeConversations: number
  completedConversations: number
  averageConversationLength: number
  averageConversationDuration: number
  timeSeriesData: TimeSeriesData[]
  conversationDistribution: Array<{
    agentId: string
    agentName: string
    count: number
    percentage: number
  }>
  hourlyDistribution: Array<{
    hour: number
    count: number
  }>
  weeklyDistribution: Array<{
    dayOfWeek: number
    count: number
  }>
}>> {
  return httpClient.get('/analytics/usage/conversations', params)
}

// ==================== 成本分析 ====================

/**
 * 获取成本分析数据
 */
export function getCostAnalysis(params?: {
  period?: StatsPeriod
  startDate?: string
  endDate?: string
  groupBy?: 'day' | 'week' | 'month'
  currency?: string
}): Promise<ApiResult<{
  totalCost: number
  currency: string
  period: {
    startDate: string
    endDate: string
  }
  costTrend: TimeSeriesData[]
  breakdown: {
    byPlatform: Array<{
      platform: string
      cost: number
      percentage: number
      growth: number
    }>
    byAgent: Array<{
      agentId: string
      agentName: string
      cost: number
      percentage: number
      tokenCount: number
      requestCount: number
    }>
    byUser: Array<{
      userId: string
      userName: string
      cost: number
      percentage: number
      messageCount: number
    }>
    byModel: Array<{
      modelName: string
      platform: string
      cost: number
      percentage: number
      avgCostPerToken: number
    }>
  }
  predictions: {
    nextMonth: number
    nextQuarter: number
    yearEnd: number
  }
  budget: {
    limit: number
    used: number
    remaining: number
    utilizationRate: number
  }
}>> {
  return httpClient.get('/analytics/cost', params)
}

/**
 * 获取成本优化建议
 */
export function getCostOptimizationSuggestions(): Promise<ApiResult<Array<{
  id: string
  type: 'PLATFORM_SWITCH' | 'MODEL_OPTIMIZATION' | 'USAGE_PATTERN' | 'CONFIG_TUNING'
  title: string
  description: string
  potentialSavings: number
  difficulty: 'EASY' | 'MEDIUM' | 'HARD'
  impact: 'LOW' | 'MEDIUM' | 'HIGH'
  actionItems: string[]
  estimatedImplementationTime: string
}>>> {
  return httpClient.get('/analytics/cost/optimization-suggestions')
}

// ==================== 性能监控 ====================

/**
 * 获取性能统计数据
 */
export function getPerformanceStats(params?: {
  period?: StatsPeriod
  startDate?: string
  endDate?: string
  agentId?: string
  platformId?: string
}): Promise<ApiResult<{
  averageResponseTime: number
  p95ResponseTime: number
  p99ResponseTime: number
  successRate: number
  errorRate: number
  timeSeriesData: Array<{
    timestamp: string
    responseTime: number
    successRate: number
    errorRate: number
    throughput: number
  }>
  performanceByAgent: Array<{
    agentId: string
    agentName: string
    averageResponseTime: number
    successRate: number
    totalRequests: number
  }>
  performanceByPlatform: Array<{
    platform: string
    averageResponseTime: number
    successRate: number
    availability: number
  }>
  errorDistribution: Array<{
    errorType: string
    count: number
    percentage: number
  }>
}>> {
  return httpClient.get('/analytics/performance', params)
}

/**
 * 获取系统健康状态
 */
export function getSystemHealth(): Promise<ApiResult<{
  overallStatus: 'HEALTHY' | 'WARNING' | 'CRITICAL'
  services: Array<{
    name: string
    status: 'HEALTHY' | 'WARNING' | 'CRITICAL' | 'DOWN'
    responseTime: number
    uptime: number
    lastCheckAt: string
  }>
  alerts: Array<{
    id: string
    level: 'INFO' | 'WARNING' | 'ERROR' | 'CRITICAL'
    title: string
    message: string
    createdAt: string
    resolved: boolean
  }>
  metrics: {
    cpu: number
    memory: number
    storage: number
    network: number
  }
}>> {
  return httpClient.get('/analytics/system/health')
}

// ==================== 用户行为分析 ====================

/**
 * 获取用户行为分析
 */
export function getUserBehaviorAnalysis(params?: {
  period?: StatsPeriod
  startDate?: string
  endDate?: string
  userId?: string
}): Promise<ApiResult<{
  userJourney: Array<{
    stage: string
    userCount: number
    conversionRate: number
    averageTime: number
  }>
  featureUsage: Array<{
    feature: string
    usageCount: number
    uniqueUsers: number
    averageSessionTime: number
  }>
  userSegments: Array<{
    segment: string
    userCount: number
    characteristics: Record<string, any>
    averageEngagement: number
  }>
  retentionAnalysis: {
    day1: number
    day7: number
    day30: number
    day90: number
  }
  sessionAnalysis: {
    averageSessionDuration: number
    bounceRate: number
    pagesPerSession: number
    returningUserRate: number
  }
}>> {
  return httpClient.get('/analytics/behavior', params)
}

// ==================== 报表生成 ====================

/**
 * 生成分析报告
 */
export function generateReport(params: {
  type: 'USAGE' | 'COST' | 'PERFORMANCE' | 'COMPREHENSIVE'
  period: StatsPeriod
  startDate?: string
  endDate?: string
  format: 'PDF' | 'EXCEL' | 'CSV'
  includeCharts: boolean
  filters?: {
    agentIds?: string[]
    userIds?: string[]
    platforms?: string[]
  }
}): Promise<ApiResult<{
  reportId: string
  downloadUrl: string
  expiresAt: string
}>> {
  return httpClient.post('/analytics/reports/generate', params, {
    showSuccessMessage: true
  })
}

/**
 * 获取报告列表
 */
export function getReports(params?: {
  current?: number
  size?: number
  type?: string
  status?: 'GENERATING' | 'COMPLETED' | 'FAILED'
  startDate?: string
  endDate?: string
}): Promise<ApiResult<{
  records: Array<{
    id: string
    type: string
    title: string
    status: 'GENERATING' | 'COMPLETED' | 'FAILED'
    format: string
    fileSize?: number
    downloadUrl?: string
    createdAt: string
    completedAt?: string
    expiresAt?: string
    createdBy: string
  }>
  total: number
  current: number
  size: number
}>> {
  return httpClient.get('/analytics/reports', params)
}

/**
 * 下载报告
 */
export function downloadReport(reportId: string): Promise<void> {
  return httpClient.download(`/analytics/reports/${reportId}/download`)
}

/**
 * 删除报告
 */
export function deleteReport(reportId: string): Promise<ApiResult<void>> {
  return httpClient.delete(`/analytics/reports/${reportId}`, {
    showSuccessMessage: true
  })
}

// ==================== 自定义分析 ====================

/**
 * 创建自定义分析查询
 */
export function createCustomQuery(params: {
  name: string
  description?: string
  query: {
    metrics: string[]
    dimensions: string[]
    filters: Record<string, any>
    timeRange: {
      start: string
      end: string
    }
    granularity: 'HOUR' | 'DAY' | 'WEEK' | 'MONTH'
  }
}): Promise<ApiResult<{
  queryId: string
  results: any
}>> {
  return httpClient.post('/analytics/custom-query', params, {
    showSuccessMessage: true
  })
}

/**
 * 执行保存的查询
 */
export function executeQuery(queryId: string, params?: {
  timeRange?: {
    start: string
    end: string
  }
  filters?: Record<string, any>
}): Promise<ApiResult<{
  results: any
  executedAt: string
  executionTime: number
}>> {
  return httpClient.post(`/analytics/custom-query/${queryId}/execute`, params)
}

/**
 * 获取分析维度和指标定义
 */
export function getAnalyticsSchema(): Promise<ApiResult<{
  metrics: Array<{
    name: string
    displayName: string
    description: string
    type: 'COUNT' | 'SUM' | 'AVERAGE' | 'PERCENTAGE'
    unit?: string
  }>
  dimensions: Array<{
    name: string
    displayName: string
    description: string
    type: 'STRING' | 'NUMBER' | 'DATE' | 'BOOLEAN'
    values?: string[]
  }>
  filters: Array<{
    name: string
    displayName: string
    type: 'TEXT' | 'SELECT' | 'DATE' | 'NUMBER'
    operators: string[]
  }>
}>> {
  return httpClient.get('/analytics/schema')
}

// ==================== 预警和通知 ====================

/**
 * 获取分析预警
 */
export function getAnalyticsAlerts(): Promise<ApiResult<Array<{
  id: string
  type: 'COST_THRESHOLD' | 'PERFORMANCE_DEGRADATION' | 'USAGE_ANOMALY' | 'ERROR_SPIKE'
  level: 'INFO' | 'WARNING' | 'CRITICAL'
  title: string
  message: string
  value: number
  threshold: number
  trend: 'INCREASING' | 'DECREASING' | 'STABLE'
  createdAt: string
  resolvedAt?: string
  actions: Array<{
    title: string
    url: string
  }>
}>>> {
  return httpClient.get('/analytics/alerts')
}

/**
 * 创建分析预警规则
 */
export function createAlertRule(params: {
  name: string
  description?: string
  metric: string
  operator: 'GREATER_THAN' | 'LESS_THAN' | 'EQUALS' | 'CHANGE_PERCENTAGE'
  threshold: number
  period: string
  enabled: boolean
  notifications: {
    email: boolean
    webhook?: string
  }
}): Promise<ApiResult<{
  ruleId: string
}>> {
  return httpClient.post('/analytics/alert-rules', params, {
    showSuccessMessage: true
  })
}