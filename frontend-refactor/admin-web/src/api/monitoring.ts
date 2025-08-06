/**
 * 系统监控相关 API 服务
 */

import httpClient from '@/utils/request'
import type { 
  SystemStatus,
  ServiceStatus,
  ServiceStatusInfo,
  ResourceUsage,
  PerformanceMetrics,
  ErrorStats,
  ErrorInfo,
  PageResult,
  ApiResult
} from '@/types/api'

// ==================== 系统状态监控 ====================

/**
 * 获取系统状态概览
 */
export function getSystemStatus(): Promise<ApiResult<SystemStatus>> {
  return httpClient.get('/monitoring/system/status')
}

/**
 * 获取服务状态列表
 */
export function getServicesStatus(): Promise<ApiResult<ServiceStatusInfo[]>> {
  return httpClient.get('/monitoring/services/status')
}

/**
 * 获取特定服务状态
 */
export function getServiceStatus(serviceName: string): Promise<ApiResult<ServiceStatusInfo>> {
  return httpClient.get(`/monitoring/services/${serviceName}/status`)
}

/**
 * 重启服务
 */
export function restartService(serviceName: string): Promise<ApiResult<{
  success: boolean
  message: string
  restartTime: string
}>> {
  return httpClient.post(`/monitoring/services/${serviceName}/restart`, {}, {
    showSuccessMessage: true
  })
}

/**
 * 停止服务
 */
export function stopService(serviceName: string): Promise<ApiResult<void>> {
  return httpClient.post(`/monitoring/services/${serviceName}/stop`, {}, {
    showSuccessMessage: true
  })
}

/**
 * 启动服务
 */
export function startService(serviceName: string): Promise<ApiResult<void>> {
  return httpClient.post(`/monitoring/services/${serviceName}/start`, {}, {
    showSuccessMessage: true
  })
}

// ==================== 性能监控 ====================

/**
 * 获取系统资源使用情况
 */
export function getResourceUsage(timeRange?: {
  start: string
  end: string
  interval?: 'minute' | 'hour' | 'day'
}): Promise<ApiResult<{
  current: ResourceUsage
  history: Array<ResourceUsage & { timestamp: string }>
  thresholds: {
    cpu: { warning: number; critical: number }
    memory: { warning: number; critical: number }
    storage: { warning: number; critical: number }
    network: { warning: number; critical: number }
  }
}>> {
  return httpClient.get('/monitoring/performance/resources', timeRange)
}

/**
 * 获取性能指标
 */
export function getPerformanceMetrics(params?: {
  startTime?: string
  endTime?: string
  interval?: 'minute' | 'hour' | 'day'
  services?: string[]
}): Promise<ApiResult<{
  overview: PerformanceMetrics
  services: Array<PerformanceMetrics & { serviceName: string }>
  trends: Array<{
    timestamp: string
    responseTime: number
    throughput: number
    errorRate: number
    cpuUsage: number
    memoryUsage: number
  }>
}>> {
  return httpClient.get('/monitoring/performance/metrics', params)
}

/**
 * 获取应用性能监控(APM)数据
 */
export function getAPMData(params?: {
  serviceName?: string
  startTime?: string
  endTime?: string
  operation?: string
}): Promise<ApiResult<{
  traces: Array<{
    traceId: string
    spanId: string
    operationName: string
    startTime: string
    duration: number
    status: 'success' | 'error'
    serviceName: string
    tags: Record<string, any>
    logs: Array<{
      timestamp: string
      level: 'info' | 'warn' | 'error'
      message: string
      fields: Record<string, any>
    }>
  }>
  summary: {
    totalTraces: number
    averageDuration: number
    errorRate: number
    p95Duration: number
    p99Duration: number
  }
}>> {
  return httpClient.get('/monitoring/apm', params)
}

/**
 * 获取数据库性能监控
 */
export function getDatabaseMetrics(params?: {
  database?: string
  startTime?: string
  endTime?: string
}): Promise<ApiResult<{
  connections: {
    active: number
    idle: number
    total: number
    maxConnections: number
  }
  performance: {
    queryCount: number
    averageQueryTime: number
    slowQueries: number
    lockWaitTime: number
  }
  slowQueries: Array<{
    id: string
    query: string
    duration: number
    timestamp: string
    database: string
    affectedRows: number
  }>
  topQueries: Array<{
    query: string
    count: number
    averageDuration: number
    totalDuration: number
  }>
}>> {
  return httpClient.get('/monitoring/database/metrics', params)
}

// ==================== 错误追踪 ====================

/**
 * 获取错误统计
 */
export function getErrorStats(params?: {
  startTime?: string
  endTime?: string
  service?: string
  level?: 'error' | 'warning' | 'info'
  groupBy?: 'service' | 'level' | 'hour' | 'day'
}): Promise<ApiResult<{
  overview: ErrorStats
  breakdown: Array<{
    category: string
    count: number
    percentage: number
    trend: number
  }>
  timeline: Array<{
    timestamp: string
    errorCount: number
    warningCount: number
    infoCount: number
  }>
  topErrors: Array<{
    id: string
    message: string
    count: number
    lastOccurred: string
    service: string
    level: string
  }>
}>> {
  return httpClient.get('/monitoring/errors/stats', params)
}

/**
 * 获取错误详情列表
 */
export function getErrors(params?: {
  current?: number
  size?: number
  startTime?: string
  endTime?: string
  service?: string
  level?: string
  keyword?: string
  resolved?: boolean
}): Promise<ApiResult<PageResult<ErrorInfo>>> {
  return httpClient.get('/monitoring/errors', params)
}

/**
 * 获取错误详情
 */
export function getErrorDetail(errorId: string): Promise<ApiResult<{
  error: ErrorInfo
  occurrences: Array<{
    id: string
    timestamp: string
    context: Record<string, any>
    stackTrace: string[]
    userAgent?: string
    userId?: string
    requestId?: string
  }>
  relatedErrors: Array<{
    id: string
    message: string
    count: number
    similarity: number
  }>
  timeline: Array<{
    timestamp: string
    count: number
  }>
}>> {
  return httpClient.get(`/monitoring/errors/${errorId}`)
}

/**
 * 标记错误为已解决
 */
export function resolveError(errorId: string, resolution?: {
  note?: string
  action?: string
}): Promise<ApiResult<void>> {
  return httpClient.post(`/monitoring/errors/${errorId}/resolve`, resolution, {
    showSuccessMessage: true
  })
}

/**
 * 忽略错误
 */
export function ignoreError(errorId: string, reason?: string): Promise<ApiResult<void>> {
  return httpClient.post(`/monitoring/errors/${errorId}/ignore`, { reason }, {
    showSuccessMessage: true
  })
}

// ==================== 日志管理 ====================

/**
 * 搜索日志
 */
export function searchLogs(params: {
  query?: string
  startTime?: string
  endTime?: string
  level?: 'debug' | 'info' | 'warn' | 'error'
  service?: string
  current?: number
  size?: number
  sortBy?: 'timestamp' | 'level' | 'service'
  sortOrder?: 'asc' | 'desc'
}): Promise<ApiResult<PageResult<{
  id: string
  timestamp: string
  level: string
  service: string
  message: string
  context: Record<string, any>
  traceId?: string
  userId?: string
  requestId?: string
}>>> {
  return httpClient.get('/monitoring/logs/search', params)
}

/**
 * 获取日志详情
 */
export function getLogDetail(logId: string): Promise<ApiResult<{
  log: {
    id: string
    timestamp: string
    level: string
    service: string
    message: string
    fullMessage: string
    context: Record<string, any>
    stackTrace?: string[]
    traceId?: string
    userId?: string
    requestId?: string
  }
  relatedLogs: Array<{
    id: string
    timestamp: string
    level: string
    message: string
    relation: 'trace' | 'user' | 'request'
  }>
}>> {
  return httpClient.get(`/monitoring/logs/${logId}`)
}

/**
 * 导出日志
 */
export function exportLogs(params: {
  query?: string
  startTime?: string
  endTime?: string
  level?: string
  service?: string
  format: 'json' | 'csv' | 'txt'
}): Promise<ApiResult<{
  downloadUrl: string
  fileSize: number
  expiresAt: string
}>> {
  return httpClient.post('/monitoring/logs/export', params, {
    showSuccessMessage: true
  })
}

/**
 * 获取日志统计
 */
export function getLogStats(params?: {
  startTime?: string
  endTime?: string
  groupBy?: 'service' | 'level' | 'hour' | 'day'
}): Promise<ApiResult<{
  totalLogs: number
  logsByLevel: Record<string, number>
  logsByService: Record<string, number>
  timeline: Array<{
    timestamp: string
    count: number
    levels: Record<string, number>
  }>
  topServices: Array<{
    service: string
    count: number
    errorRate: number
  }>
}>> {
  return httpClient.get('/monitoring/logs/stats', params)
}

// ==================== 告警系统 ====================

/**
 * 获取告警列表
 */
export function getAlerts(params?: {
  current?: number
  size?: number
  status?: 'active' | 'resolved' | 'suppressed'
  severity?: 'low' | 'medium' | 'high' | 'critical'
  service?: string
  startTime?: string
  endTime?: string
}): Promise<ApiResult<PageResult<{
  id: string
  title: string
  message: string
  severity: 'low' | 'medium' | 'high' | 'critical'
  status: 'active' | 'resolved' | 'suppressed'
  service: string
  metric: string
  value: number
  threshold: number
  createdAt: string
  resolvedAt?: string
  assignee?: string
  tags: string[]
}>>> {
  return httpClient.get('/monitoring/alerts', params)
}

/**
 * 获取告警详情
 */
export function getAlertDetail(alertId: string): Promise<ApiResult<{
  alert: {
    id: string
    title: string
    message: string
    description: string
    severity: string
    status: string
    service: string
    metric: string
    value: number
    threshold: number
    rule: {
      id: string
      name: string
      expression: string
      duration: string
    }
    createdAt: string
    resolvedAt?: string
    assignee?: string
    tags: string[]
  }
  timeline: Array<{
    timestamp: string
    action: string
    user?: string
    note?: string
  }>
  relatedAlerts: Array<{
    id: string
    title: string
    severity: string
    createdAt: string
  }>
  annotations: Array<{
    id: string
    content: string
    createdBy: string
    createdAt: string
  }>
}>> {
  return httpClient.get(`/monitoring/alerts/${alertId}`)
}

/**
 * 确认告警
 */
export function acknowledgeAlert(alertId: string, note?: string): Promise<ApiResult<void>> {
  return httpClient.post(`/monitoring/alerts/${alertId}/acknowledge`, { note }, {
    showSuccessMessage: true
  })
}

/**
 * 解决告警
 */
export function resolveAlert(alertId: string, resolution: {
  note: string
  rootCause?: string
  solution?: string
}): Promise<ApiResult<void>> {
  return httpClient.post(`/monitoring/alerts/${alertId}/resolve`, resolution, {
    showSuccessMessage: true
  })
}

/**
 * 抑制告警
 */
export function suppressAlert(alertId: string, params: {
  duration: number // minutes
  reason: string
}): Promise<ApiResult<void>> {
  return httpClient.post(`/monitoring/alerts/${alertId}/suppress`, params, {
    showSuccessMessage: true
  })
}

/**
 * 分配告警
 */
export function assignAlert(alertId: string, assigneeId: string): Promise<ApiResult<void>> {
  return httpClient.post(`/monitoring/alerts/${alertId}/assign`, { assigneeId }, {
    showSuccessMessage: true
  })
}

/**
 * 获取告警规则
 */
export function getAlertRules(params?: {
  current?: number
  size?: number
  enabled?: boolean
  service?: string
}): Promise<ApiResult<PageResult<{
  id: string
  name: string
  description: string
  enabled: boolean
  service: string
  metric: string
  condition: 'greater_than' | 'less_than' | 'equals' | 'not_equals'
  threshold: number
  duration: string
  severity: 'low' | 'medium' | 'high' | 'critical'
  notifications: {
    email: boolean
    slack: boolean
    webhook?: string
  }
  createdAt: string
  lastTriggered?: string
  triggerCount: number
}>>> {
  return httpClient.get('/monitoring/alert-rules', params)
}

/**
 * 创建告警规则
 */
export function createAlertRule(data: {
  name: string
  description?: string
  service: string
  metric: string
  condition: 'greater_than' | 'less_than' | 'equals' | 'not_equals'
  threshold: number
  duration: string
  severity: 'low' | 'medium' | 'high' | 'critical'
  enabled: boolean
  notifications: {
    email: boolean
    slack: boolean
    webhook?: string
    emailRecipients?: string[]
    slackChannel?: string
  }
  labels?: Record<string, string>
}): Promise<ApiResult<{ ruleId: string }>> {
  return httpClient.post('/monitoring/alert-rules', data, {
    showSuccessMessage: true
  })
}

/**
 * 更新告警规则
 */
export function updateAlertRule(ruleId: string, data: Partial<{
  name: string
  description: string
  threshold: number
  duration: string
  severity: string
  enabled: boolean
  notifications: any
}>): Promise<ApiResult<void>> {
  return httpClient.put(`/monitoring/alert-rules/${ruleId}`, data, {
    showSuccessMessage: true
  })
}

/**
 * 删除告警规则
 */
export function deleteAlertRule(ruleId: string): Promise<ApiResult<void>> {
  return httpClient.delete(`/monitoring/alert-rules/${ruleId}`, {
    showSuccessMessage: true
  })
}

/**
 * 测试告警规则
 */
export function testAlertRule(ruleId: string): Promise<ApiResult<{
  triggered: boolean
  currentValue: number
  threshold: number
  message: string
}>> {
  return httpClient.post(`/monitoring/alert-rules/${ruleId}/test`)
}

// ==================== 健康检查 ====================

/**
 * 获取健康检查结果
 */
export function getHealthChecks(): Promise<ApiResult<{
  overall: 'healthy' | 'degraded' | 'unhealthy'
  checks: Array<{
    name: string
    status: 'healthy' | 'degraded' | 'unhealthy'
    message?: string
    lastCheck: string
    duration: number
    details: Record<string, any>
  }>
  dependencies: Array<{
    name: string
    type: 'database' | 'cache' | 'external_api' | 'service'
    status: 'healthy' | 'degraded' | 'unhealthy'
    responseTime: number
    lastCheck: string
  }>
}>> {
  return httpClient.get('/monitoring/health')
}

/**
 * 执行健康检查
 */
export function runHealthCheck(checkName?: string): Promise<ApiResult<{
  status: 'healthy' | 'degraded' | 'unhealthy'
  checks: Array<{
    name: string
    status: string
    message?: string
    duration: number
  }>
}>> {
  const params = checkName ? { check: checkName } : {}
  return httpClient.post('/monitoring/health/run', params)
}

// ==================== 监控配置 ====================

/**
 * 获取监控配置
 */
export function getMonitoringConfig(): Promise<ApiResult<{
  alerting: {
    defaultSeverity: string
    escalationPolicy: any
    notificationChannels: Array<{
      id: string
      type: 'email' | 'slack' | 'webhook'
      name: string
      config: Record<string, any>
      enabled: boolean
    }>
  }
  retention: {
    logs: string // e.g., "30d"
    metrics: string // e.g., "90d"
    traces: string // e.g., "7d"
  }
  sampling: {
    traces: number // percentage
    logs: number // percentage
  }
  thresholds: {
    cpu: { warning: number; critical: number }
    memory: { warning: number; critical: number }
    storage: { warning: number; critical: number }
    responseTime: { warning: number; critical: number }
    errorRate: { warning: number; critical: number }
  }
}>> {
  return httpClient.get('/monitoring/config')
}

/**
 * 更新监控配置
 */
export function updateMonitoringConfig(config: {
  alerting?: any
  retention?: any
  sampling?: any
  thresholds?: any
}): Promise<ApiResult<void>> {
  return httpClient.put('/monitoring/config', config, {
    showSuccessMessage: true
  })
}

/**
 * 获取监控统计概览
 */
export function getMonitoringOverview(timeRange?: string): Promise<ApiResult<{
  services: {
    total: number
    healthy: number
    degraded: number
    unhealthy: number
  }
  alerts: {
    active: number
    resolved: number
    critical: number
    high: number
    medium: number
    low: number
  }
  errors: {
    total: number
    rate: number
    trend: number
  }
  performance: {
    averageResponseTime: number
    throughput: number
    availability: number
  }
  resources: {
    cpu: number
    memory: number
    storage: number
  }
}>> {
  const params = timeRange ? { timeRange } : {}
  return httpClient.get('/monitoring/overview', params)
}