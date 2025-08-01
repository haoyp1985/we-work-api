import { http } from '@/utils/request'
import type { SystemMetrics, ServiceHealth } from '@/types'

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