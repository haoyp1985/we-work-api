import { http } from '@/utils/request'
import type { 
  SystemMetrics, 
  ServiceHealth,
  MonitorStatistics,
  AccountHealthReport,
  WeWorkAccountDetail,
  PageResult,
  AlertInfo,
  AlertQueryParams,
  AlertOperationRequest,
  BatchAlertOperationRequest,
  MonitorRule,
  FaultDiagnosis,
  RecoveryStrategy,
  AutoOpsStatistics
} from '@/types'

/**
 * 获取系统指标
 */
export const getSystemMetrics = () => {
  return http.get<SystemMetrics>('/monitor/metrics')
}

/**
 * 获取服务健康状态
 */
export const getServiceHealth = () => {
  return http.get<ServiceHealth[]>('/monitor/health')
}

/**
 * 获取特定服务健康状态
 */
export const getServiceHealthDetail = (serviceName: string) => {
  return http.get<ServiceHealth>(`/monitor/health/${serviceName}`)
}

/**
 * 获取实时日志
 */
export const getRealtimeLogs = (params?: {
  level?: 'DEBUG' | 'INFO' | 'WARN' | 'ERROR'
  service?: string
  limit?: number
}) => {
  return http.get<Array<{
    timestamp: string
    level: string
    service: string
    message: string
    details?: any
  }>>('/monitor/logs', params)
}

/**
 * 获取错误统计
 */
export const getErrorStats = (params?: {
  startTime?: string
  endTime?: string
  service?: string
}) => {
  return http.get<{
    totalErrors: number
    errorRate: number
    topErrors: Array<{
      message: string
      count: number
      service: string
      lastOccurred: string
    }>
    dailyErrors: Array<{
      date: string
      errors: number
    }>
  }>('/monitor/errors', params)
}

/**
 * 获取性能指标
 */
export const getPerformanceMetrics = (params?: {
  startTime?: string
  endTime?: string
  service?: string
}) => {
  return http.get<{
    avgResponseTime: number
    throughput: number
    errorRate: number
    availability: number
    dailyMetrics: Array<{
      date: string
      avgResponseTime: number
      throughput: number
      errorRate: number
    }>
  }>('/monitor/performance', params)
}

/**
 * 获取网关统计
 */
export const getGatewayStats = () => {
  return http.get<{
    totalRequests: number
    successRequests: number
    failedRequests: number
    avgResponseTime: number
    topRoutes: Array<{
      path: string
      requests: number
      avgResponseTime: number
      errorRate: number
    }>
    statusCodeDistribution: Array<{
      code: number
      count: number
      percentage: number
    }>
  }>('/monitor/gateway')
}

// ==================== 企微账号监控相关API ====================

/**
 * 获取监控统计数据
 */
export const getMonitorStatistics = (tenantId?: string) => {
  return http.get<MonitorStatistics>('/monitor/statistics', { tenantId })
}

/**
 * 获取账号健康报告
 */
export const getAccountHealth = (accountId: string) => {
  return http.get<AccountHealthReport>(`/monitor/accounts/${accountId}/health`)
}

/**
 * 获取账号列表（支持多租户）
 */
export const getAccountList = (params?: {
  tenantId?: string
  status?: string
  healthScoreRange?: [number, number]
  page?: number
  size?: number
}) => {
  return http.get<PageResult<WeWorkAccountDetail>>('/monitor/accounts', params)
}

/**
 * 获取实时监控数据
 */
export const getRealTimeData = (tenantId?: string) => {
  return http.get<WeWorkAccountDetail[]>('/monitor/realtime', { tenantId })
}

/**
 * 批量检查账号健康状态
 */
export const batchCheckAccountHealth = (accountIds: string[]) => {
  return http.post<AccountHealthReport[]>('/monitor/accounts/batch-health', { accountIds })
}

// ==================== 告警管理相关API ====================

/**
 * 获取告警列表
 */
export const getAlerts = (params: AlertQueryParams) => {
  return http.get<PageResult<AlertInfo>>('/alerts', params)
}

/**
 * 处理单个告警
 */
export const handleAlert = (request: AlertOperationRequest) => {
  return http.post<void>('/alerts/handle', request)
}

/**
 * 批量处理告警
 */
export const batchHandleAlerts = (request: BatchAlertOperationRequest) => {
  return http.post<void>('/alerts/batch-handle', request)
}

/**
 * 获取告警详情
 */
export const getAlertDetail = (alertId: string) => {
  return http.get<AlertInfo>(`/alerts/${alertId}`)
}

/**
 * 获取告警统计信息
 */
export const getAlertStatistics = (params?: {
  tenantId?: string
  startTime?: string
  endTime?: string
}) => {
  return http.get<{
    totalAlerts: number
    activeAlerts: number
    resolvedAlerts: number
    alertsByLevel: Record<string, number>
    alertsByType: Record<string, number>
    resolutionTrend: Array<{
      date: string
      resolved: number
      created: number
    }>
  }>('/alerts/statistics', params)
}

// ==================== 监控规则相关API ====================

/**
 * 获取监控规则列表
 */
export const getMonitorRules = (params?: {
  tenantId?: string
  enabled?: boolean
  ruleType?: string
  page?: number
  size?: number
}) => {
  return http.get<PageResult<MonitorRule>>('/monitor/rules', params)
}

/**
 * 创建监控规则
 */
export const createMonitorRule = (rule: Omit<MonitorRule, 'id' | 'createdAt' | 'updatedAt'>) => {
  return http.post<MonitorRule>('/monitor/rules', rule)
}

/**
 * 更新监控规则
 */
export const updateMonitorRule = (ruleId: string, rule: Partial<MonitorRule>) => {
  return http.put<MonitorRule>(`/monitor/rules/${ruleId}`, rule)
}

/**
 * 删除监控规则
 */
export const deleteMonitorRule = (ruleId: string) => {
  return http.delete<void>(`/monitor/rules/${ruleId}`)
}

/**
 * 启用/禁用监控规则
 */
export const toggleMonitorRule = (ruleId: string, enabled: boolean) => {
  return http.patch<void>(`/monitor/rules/${ruleId}/toggle`, { enabled })
}

/**
 * 测试监控规则
 */
export const testMonitorRule = (ruleExpression: string, testData: any) => {
  return http.post<{
    passed: boolean
    result: any
    message: string
  }>('/monitor/rules/test', { ruleExpression, testData })
}

// ==================== 自动运维相关API ====================

/**
 * 故障诊断
 */
export const diagnoseFault = (accountId: string) => {
  return http.post<FaultDiagnosis>(`/auto-ops/diagnose/${accountId}`)
}

/**
 * 获取恢复策略
 */
export const getRecoveryStrategies = (faultType: string) => {
  return http.get<RecoveryStrategy[]>('/auto-ops/recovery-strategies', { faultType })
}

/**
 * 执行自动恢复
 */
export const executeAutoRecovery = (accountId: string, strategyId: string) => {
  return http.post<{
    success: boolean
    message: string
    recoveryId: string
  }>('/auto-ops/recover', { accountId, strategyId })
}

/**
 * 获取自动运维统计
 */
export const getAutoOpsStatistics = (params?: {
  tenantId?: string
  startTime?: string
  endTime?: string
}) => {
  return http.get<AutoOpsStatistics>('/auto-ops/statistics', params)
}

/**
 * 获取故障恢复历史
 */
export const getRecoveryHistory = (params?: {
  accountId?: string
  tenantId?: string
  page?: number
  size?: number
}) => {
  return http.get<PageResult<{
    id: string
    accountId: string
    accountName: string
    faultType: string
    strategyUsed: string
    success: boolean
    startTime: string
    endTime: string
    duration: number
    errorMessage?: string
  }>>('/auto-ops/recovery-history', params)
}