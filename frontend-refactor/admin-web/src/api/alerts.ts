/**
 * 监控告警相关 API 服务
 */

import httpClient from '@/utils/request'
import type { 
  ApiResult,
  PageResult
} from '@/types/api'

// 告警级别
export type AlertLevel = 'INFO' | 'WARNING' | 'ERROR' | 'CRITICAL'

// 告警状态
export type AlertStatus = 'ACTIVE' | 'ACKNOWLEDGED' | 'RESOLVED' | 'SUPPRESSED'

// 告警规则状态
export type RuleStatus = 'ENABLED' | 'DISABLED' | 'TESTING'

// 通知渠道类型
export type NotificationChannel = 'EMAIL' | 'SMS' | 'WEBHOOK' | 'DINGTALK' | 'WEWORK' | 'SLACK'

// 告警信息
export interface Alert {
  id: string
  ruleId: string
  ruleName: string
  level: AlertLevel
  status: AlertStatus
  title: string
  message: string
  source: string
  sourceId?: string
  value: number
  threshold: number
  tags: Record<string, string>
  metadata: {
    triggeredAt: string
    acknowledgedAt?: string
    acknowledgedBy?: string
    resolvedAt?: string
    resolvedBy?: string
    suppressedUntil?: string
    notificationsSent: number
    lastNotificationAt?: string
  }
  assignee?: {
    userId: string
    userName: string
    assignedAt: string
    assignedBy: string
  }
}

// 告警规则
export interface AlertRule {
  id: string
  name: string
  description?: string
  status: RuleStatus
  level: AlertLevel
  source: string
  metric: string
  condition: {
    operator: 'GREATER_THAN' | 'LESS_THAN' | 'EQUALS' | 'NOT_EQUALS' | 'CONTAINS' | 'NOT_CONTAINS'
    value: number | string
    aggregation?: 'AVG' | 'SUM' | 'COUNT' | 'MIN' | 'MAX'
    duration?: number // 持续时间（秒）
  }
  filters?: Record<string, string>
  schedule: {
    enabled: boolean
    interval: number // 检查间隔（秒）
    timezone: string
    quietHours?: {
      start: string // HH:mm
      end: string // HH:mm
    }
  }
  notifications: {
    channels: NotificationChannel[]
    templates: {
      title: string
      message: string
    }
    escalation: Array<{
      delay: number // 延迟时间（分钟）
      channels: NotificationChannel[]
      recipients: string[]
    }>
    cooldown: number // 冷却时间（分钟）
  }
  actions: {
    autoResolve: boolean
    autoResolveDelay?: number // 自动解决延迟（分钟）
    webhook?: {
      url: string
      method: 'GET' | 'POST'
      headers?: Record<string, string>
      body?: string
    }
  }
  metadata: {
    createdBy: string
    createdAt: string
    updatedBy: string
    updatedAt: string
    lastTriggered?: string
    triggerCount: number
  }
  tags: string[]
}

// 通知渠道配置
export interface NotificationChannelConfig {
  id: string
  type: NotificationChannel
  name: string
  enabled: boolean
  config: {
    // Email
    smtp?: {
      host: string
      port: number
      username: string
      password: string
      secure: boolean
    }
    recipients?: string[]
    
    // SMS
    provider?: string
    apiKey?: string
    phones?: string[]
    
    // Webhook
    url?: string
    method?: 'GET' | 'POST'
    headers?: Record<string, string>
    
    // 企业通讯工具
    webhook?: string
    secret?: string
    chatId?: string
  }
  rateLimit: {
    maxPerHour: number
    maxPerDay: number
  }
  template: {
    title: string
    message: string
  }
}

// 告警统计
export interface AlertStats {
  total: number
  active: number
  resolved: number
  acknowledged: number
  suppressed: number
  byLevel: Record<AlertLevel, number>
  bySource: Array<{
    source: string
    count: number
  }>
  trends: Array<{
    date: string
    total: number
    byLevel: Record<AlertLevel, number>
  }>
  mttr: number // 平均修复时间（分钟）
  mtbd: number // 平均故障检测时间（分钟）
}

// ==================== 告警管理 ====================

/**
 * 获取告警列表
 */
export function getAlerts(params?: {
  current?: number
  size?: number
  level?: AlertLevel
  status?: AlertStatus
  source?: string
  keyword?: string
  startDate?: string
  endDate?: string
  assigneeId?: string
  ruleId?: string
}): Promise<ApiResult<PageResult<Alert>>> {
  return httpClient.get('/alerts', params)
}

/**
 * 获取告警详情
 */
export function getAlert(alertId: string): Promise<ApiResult<Alert & {
  rule: AlertRule
  history: Array<{
    id: string
    action: 'TRIGGERED' | 'ACKNOWLEDGED' | 'RESOLVED' | 'SUPPRESSED' | 'ASSIGNED'
    operator: string
    operatorName: string
    timestamp: string
    note?: string
  }>
  notifications: Array<{
    id: string
    channel: NotificationChannel
    recipient: string
    status: 'PENDING' | 'SENT' | 'FAILED'
    sentAt?: string
    error?: string
  }>
}>> {
  return httpClient.get(`/alerts/${alertId}`)
}

/**
 * 确认告警
 */
export function acknowledgeAlert(alertId: string, note?: string): Promise<ApiResult<void>> {
  return httpClient.post(`/alerts/${alertId}/acknowledge`, { note }, {
    showSuccessMessage: true
  })
}

/**
 * 批量确认告警
 */
export function batchAcknowledgeAlerts(alertIds: string[], note?: string): Promise<ApiResult<{
  success: number
  failed: number
}>> {
  return httpClient.post('/alerts/batch-acknowledge', { alertIds, note }, {
    showSuccessMessage: true
  })
}

/**
 * 解决告警
 */
export function resolveAlert(alertId: string, note?: string): Promise<ApiResult<void>> {
  return httpClient.post(`/alerts/${alertId}/resolve`, { note }, {
    showSuccessMessage: true
  })
}

/**
 * 批量解决告警
 */
export function batchResolveAlerts(alertIds: string[], note?: string): Promise<ApiResult<{
  success: number
  failed: number
}>> {
  return httpClient.post('/alerts/batch-resolve', { alertIds, note }, {
    showSuccessMessage: true
  })
}

/**
 * 抑制告警
 */
export function suppressAlert(alertId: string, duration: number, reason?: string): Promise<ApiResult<void>> {
  return httpClient.post(`/alerts/${alertId}/suppress`, { duration, reason }, {
    showSuccessMessage: true
  })
}

/**
 * 分配告警
 */
export function assignAlert(alertId: string, assigneeId: string, note?: string): Promise<ApiResult<void>> {
  return httpClient.post(`/alerts/${alertId}/assign`, { assigneeId, note }, {
    showSuccessMessage: true
  })
}

/**
 * 批量分配告警
 */
export function batchAssignAlerts(alertIds: string[], assigneeId: string, note?: string): Promise<ApiResult<{
  success: number
  failed: number
}>> {
  return httpClient.post('/alerts/batch-assign', { alertIds, assigneeId, note }, {
    showSuccessMessage: true
  })
}

/**
 * 重新发送通知
 */
export function resendNotification(alertId: string, channels?: NotificationChannel[]): Promise<ApiResult<void>> {
  return httpClient.post(`/alerts/${alertId}/resend-notification`, { channels }, {
    showSuccessMessage: true
  })
}

// ==================== 告警规则管理 ====================

/**
 * 获取告警规则列表
 */
export function getAlertRules(params?: {
  current?: number
  size?: number
  keyword?: string
  status?: RuleStatus
  level?: AlertLevel
  source?: string
}): Promise<ApiResult<PageResult<AlertRule>>> {
  return httpClient.get('/alert-rules', params)
}

/**
 * 获取告警规则详情
 */
export function getAlertRule(ruleId: string): Promise<ApiResult<AlertRule & {
  recentAlerts: Alert[]
  statistics: {
    triggerCount: number
    lastTriggered?: string
    avgResolutionTime: number
    successRate: number
  }
}>> {
  return httpClient.get(`/alert-rules/${ruleId}`)
}

/**
 * 创建告警规则
 */
export function createAlertRule(data: Omit<AlertRule, 'id' | 'metadata'>): Promise<ApiResult<{ ruleId: string }>> {
  return httpClient.post('/alert-rules', data, {
    showSuccessMessage: true
  })
}

/**
 * 更新告警规则
 */
export function updateAlertRule(ruleId: string, data: Partial<Omit<AlertRule, 'id' | 'metadata'>>): Promise<ApiResult<void>> {
  return httpClient.put(`/alert-rules/${ruleId}`, data, {
    showSuccessMessage: true
  })
}

/**
 * 删除告警规则
 */
export function deleteAlertRule(ruleId: string): Promise<ApiResult<void>> {
  return httpClient.delete(`/alert-rules/${ruleId}`, {
    showSuccessMessage: true
  })
}

/**
 * 测试告警规则
 */
export function testAlertRule(ruleId: string): Promise<ApiResult<{
  success: boolean
  message: string
  simulatedAlerts: Array<{
    level: AlertLevel
    title: string
    message: string
    value: number
    threshold: number
  }>
}>> {
  return httpClient.post(`/alert-rules/${ruleId}/test`, {})
}

/**
 * 启用/禁用告警规则
 */
export function toggleAlertRule(ruleId: string, enabled: boolean): Promise<ApiResult<void>> {
  return httpClient.post(`/alert-rules/${ruleId}/toggle`, { enabled }, {
    showSuccessMessage: true
  })
}

/**
 * 复制告警规则
 */
export function cloneAlertRule(ruleId: string, newName: string): Promise<ApiResult<{ ruleId: string }>> {
  return httpClient.post(`/alert-rules/${ruleId}/clone`, { name: newName }, {
    showSuccessMessage: true
  })
}

// ==================== 通知渠道管理 ====================

/**
 * 获取通知渠道列表
 */
export function getNotificationChannels(): Promise<ApiResult<NotificationChannelConfig[]>> {
  return httpClient.get('/notification-channels')
}

/**
 * 获取通知渠道详情
 */
export function getNotificationChannel(channelId: string): Promise<ApiResult<NotificationChannelConfig>> {
  return httpClient.get(`/notification-channels/${channelId}`)
}

/**
 * 创建通知渠道
 */
export function createNotificationChannel(data: Omit<NotificationChannelConfig, 'id'>): Promise<ApiResult<{ channelId: string }>> {
  return httpClient.post('/notification-channels', data, {
    showSuccessMessage: true
  })
}

/**
 * 更新通知渠道
 */
export function updateNotificationChannel(channelId: string, data: Partial<Omit<NotificationChannelConfig, 'id'>>): Promise<ApiResult<void>> {
  return httpClient.put(`/notification-channels/${channelId}`, data, {
    showSuccessMessage: true
  })
}

/**
 * 删除通知渠道
 */
export function deleteNotificationChannel(channelId: string): Promise<ApiResult<void>> {
  return httpClient.delete(`/notification-channels/${channelId}`, {
    showSuccessMessage: true
  })
}

/**
 * 测试通知渠道
 */
export function testNotificationChannel(channelId: string, testMessage?: string): Promise<ApiResult<{
  success: boolean
  message: string
  deliveryTime: number
}>> {
  return httpClient.post(`/notification-channels/${channelId}/test`, { message: testMessage })
}

// ==================== 告警统计分析 ====================

/**
 * 获取告警统计
 */
export function getAlertStatistics(timeRange?: {
  startDate: string
  endDate: string
}): Promise<ApiResult<AlertStats>> {
  return httpClient.get('/alerts/statistics', timeRange)
}

/**
 * 获取告警趋势分析
 */
export function getAlertTrends(params: {
  period: 'LAST_7_DAYS' | 'LAST_30_DAYS' | 'LAST_90_DAYS' | 'CUSTOM'
  startDate?: string
  endDate?: string
  groupBy: 'HOUR' | 'DAY' | 'WEEK'
  sources?: string[]
  levels?: AlertLevel[]
}): Promise<ApiResult<{
  timeline: Array<{
    timestamp: string
    total: number
    byLevel: Record<AlertLevel, number>
    bySource: Record<string, number>
  }>
  summary: {
    totalAlerts: number
    growthRate: number
    mostActiveSource: string
    mostCommonLevel: AlertLevel
    peakTime: string
  }
  insights: Array<{
    type: 'PEAK_HOURS' | 'FREQUENT_SOURCES' | 'ESCALATING_ISSUES' | 'RESOLUTION_TRENDS'
    title: string
    description: string
    severity: 'LOW' | 'MEDIUM' | 'HIGH'
    recommendation: string
  }>
}>> {
  return httpClient.get('/alerts/trends', params)
}

/**
 * 导出告警数据
 */
export function exportAlerts(params: {
  format: 'EXCEL' | 'CSV' | 'PDF'
  timeRange: {
    startDate: string
    endDate: string
  }
  filters?: {
    levels?: AlertLevel[]
    sources?: string[]
    statuses?: AlertStatus[]
  }
  includeHistory: boolean
}): Promise<ApiResult<{
  downloadUrl: string
  fileName: string
  fileSize: number
}>> {
  return httpClient.post('/alerts/export', params, {
    showSuccessMessage: true
  })
}

// ==================== 告警模板管理 ====================

/**
 * 获取告警模板
 */
export function getAlertTemplates(): Promise<ApiResult<Array<{
  id: string
  name: string
  description: string
  category: string
  level: AlertLevel
  source: string
  ruleTemplate: Partial<AlertRule>
  usageCount: number
  tags: string[]
}>>> {
  return httpClient.get('/alert-templates')
}

/**
 * 从模板创建规则
 */
export function createRuleFromTemplate(templateId: string, customizations: {
  name: string
  description?: string
  condition: Partial<AlertRule['condition']>
  notifications: Partial<AlertRule['notifications']>
}): Promise<ApiResult<{ ruleId: string }>> {
  return httpClient.post(`/alert-templates/${templateId}/create-rule`, customizations, {
    showSuccessMessage: true
  })
}