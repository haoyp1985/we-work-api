import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { 
  AlertInfo, 
  AlertQueryParams, 
  AlertOperationRequest,
  BatchAlertOperationRequest,
  PageResult
} from '@/types'
import { 
  AlertLevel, 
  AlertStatus, 
  AlertType 
} from '@/types'
import { ElMessage } from 'element-plus'
import { useTenantStore } from './tenant'

export const useAlertStore = defineStore('alert', () => {
  // 状态
  const alertList = ref<AlertInfo[]>([])
  const alertCount = ref({
    total: 0,
    active: 0,
    critical: 0,
    error: 0,
    warning: 0,
    info: 0
  })
  const loading = ref(false)
  const selectedAlerts = ref<string[]>([])
  
  // 分页状态
  const pagination = ref({
    current: 1,
    size: 20,
    total: 0
  })
  
  // 查询参数
  const queryParams = ref<AlertQueryParams>({
    page: 1,
    size: 20
  })

  // Getters
  const activeAlerts = computed(() => {
    return alertList.value.filter(alert => alert.status === AlertStatus.ACTIVE)
  })

  const criticalAlerts = computed(() => {
    return alertList.value.filter(alert => 
      alert.level === AlertLevel.CRITICAL && alert.status === AlertStatus.ACTIVE
    )
  })

  const hasSelectedAlerts = computed(() => {
    return selectedAlerts.value.length > 0
  })

  const alertSummary = computed(() => {
    const summary = {
      total: alertList.value.length,
      active: 0,
      critical: 0,
      error: 0,
      warning: 0,
      info: 0
    }
    
    alertList.value.forEach(alert => {
      if (alert.status === AlertStatus.ACTIVE) {
        summary.active++
        switch (alert.level) {
          case AlertLevel.CRITICAL:
            summary.critical++
            break
          case AlertLevel.ERROR:
            summary.error++
            break
          case AlertLevel.WARNING:
            summary.warning++
            break
          case AlertLevel.INFO:
            summary.info++
            break
        }
      }
    })
    
    return summary
  })

  // Actions
  const loadAlerts = async (params?: Partial<AlertQueryParams>): Promise<void> => {
    try {
      loading.value = true
      
      // 合并查询参数
      const finalParams = { ...queryParams.value, ...params }
      queryParams.value = finalParams
      
      // TODO: 调用后端API获取告警列表
      // const response = await alertApi.getAlerts(finalParams)
      // const result: PageResult<AlertInfo> = response.data
      
      // 临时模拟数据
      const result = generateMockAlertList(finalParams)
      
      alertList.value = result.records
      pagination.value = {
        current: result.current,
        size: result.size,
        total: result.total
      }
      
      // 更新告警统计
      updateAlertCount()
      
    } catch (error: any) {
      console.error('Load alerts error:', error)
      ElMessage.error(error.message || '获取告警列表失败')
    } finally {
      loading.value = false
    }
  }

  const acknowledgeAlert = async (alertId: string, reason?: string): Promise<boolean> => {
    try {
      const request: AlertOperationRequest = {
        alertId,
        operation: 'acknowledge',
        userId: 'current-user', // TODO: 从用户store获取
        reason
      }
      
      // TODO: 调用后端API确认告警
      // await alertApi.handleAlert(request)
      
      // 更新本地状态
      const alert = alertList.value.find(a => a.id === alertId)
      if (alert) {
        alert.status = AlertStatus.ACKNOWLEDGED
        alert.acknowledgedBy = 'current-user'
        alert.acknowledgedAt = new Date().toISOString()
      }
      
      ElMessage.success('告警已确认')
      return true
      
    } catch (error: any) {
      console.error('Acknowledge alert error:', error)
      ElMessage.error(error.message || '确认告警失败')
      return false
    }
  }

  const resolveAlert = async (alertId: string, resolution?: string): Promise<boolean> => {
    try {
      const request: AlertOperationRequest = {
        alertId,
        operation: 'resolve',
        userId: 'current-user', // TODO: 从用户store获取
        reason: resolution
      }
      
      // TODO: 调用后端API解决告警
      // await alertApi.handleAlert(request)
      
      // 更新本地状态
      const alert = alertList.value.find(a => a.id === alertId)
      if (alert) {
        alert.status = AlertStatus.RESOLVED
        alert.resolvedBy = 'current-user'
        alert.resolvedAt = new Date().toISOString()
        alert.resolution = resolution
      }
      
      ElMessage.success('告警已解决')
      return true
      
    } catch (error: any) {
      console.error('Resolve alert error:', error)
      ElMessage.error(error.message || '解决告警失败')
      return false
    }
  }

  const suppressAlert = async (alertId: string, minutes: number = 60): Promise<boolean> => {
    try {
      const request: AlertOperationRequest = {
        alertId,
        operation: 'suppress',
        userId: 'current-user', // TODO: 从用户store获取
        suppressMinutes: minutes
      }
      
      // TODO: 调用后端API抑制告警
      // await alertApi.handleAlert(request)
      
      // 更新本地状态
      const alert = alertList.value.find(a => a.id === alertId)
      if (alert) {
        alert.status = AlertStatus.SUPPRESSED
      }
      
      ElMessage.success(`告警已抑制${minutes}分钟`)
      return true
      
    } catch (error: any) {
      console.error('Suppress alert error:', error)
      ElMessage.error(error.message || '抑制告警失败')
      return false
    }
  }

  const batchOperateAlerts = async (
    operation: 'acknowledge' | 'resolve' | 'suppress',
    alertIds?: string[],
    reason?: string,
    suppressMinutes?: number
  ): Promise<boolean> => {
    try {
      const targetIds = alertIds || selectedAlerts.value
      if (targetIds.length === 0) {
        ElMessage.warning('请选择要操作的告警')
        return false
      }
      
      const request: BatchAlertOperationRequest = {
        alertIds: targetIds,
        operation,
        userId: 'current-user', // TODO: 从用户store获取
        reason,
        suppressMinutes
      }
      
      // TODO: 调用后端API批量操作
      // await alertApi.batchHandleAlerts(request)
      
      // 更新本地状态
      const now = new Date().toISOString()
      targetIds.forEach(alertId => {
        const alert = alertList.value.find(a => a.id === alertId)
        if (alert) {
          switch (operation) {
            case 'acknowledge':
              alert.status = AlertStatus.ACKNOWLEDGED
              alert.acknowledgedBy = 'current-user'
              alert.acknowledgedAt = now
              break
            case 'resolve':
              alert.status = AlertStatus.RESOLVED
              alert.resolvedBy = 'current-user'
              alert.resolvedAt = now
              alert.resolution = reason
              break
            case 'suppress':
              alert.status = AlertStatus.SUPPRESSED
              break
          }
        }
      })
      
      // 清空选择
      selectedAlerts.value = []
      
      const operationText = {
        acknowledge: '确认',
        resolve: '解决', 
        suppress: '抑制'
      }[operation]
      
      ElMessage.success(`批量${operationText}告警成功`)
      return true
      
    } catch (error: any) {
      console.error('Batch operate alerts error:', error)
      ElMessage.error(error.message || '批量操作失败')
      return false
    }
  }

  const toggleSelectAlert = (alertId: string): void => {
    const index = selectedAlerts.value.indexOf(alertId)
    if (index > -1) {
      selectedAlerts.value.splice(index, 1)
    } else {
      selectedAlerts.value.push(alertId)
    }
  }

  const selectAllAlerts = (): void => {
    selectedAlerts.value = alertList.value.map(alert => alert.id)
  }

  const clearSelection = (): void => {
    selectedAlerts.value = []
  }

  const setQueryParams = (params: Partial<AlertQueryParams>): void => {
    queryParams.value = { ...queryParams.value, ...params }
  }

  const resetQueryParams = (): void => {
    queryParams.value = {
      page: 1,
      size: 20
    }
  }

  const updateAlertCount = (): void => {
    const summary = alertSummary.value
    alertCount.value = summary
  }

  const getAlertLevelText = (level: AlertLevel): string => {
    return {
      [AlertLevel.CRITICAL]: '严重',
      [AlertLevel.ERROR]: '错误',
      [AlertLevel.WARNING]: '警告',
      [AlertLevel.INFO]: '信息'
    }[level]
  }

  const getAlertLevelColor = (level: AlertLevel): string => {
    return {
      [AlertLevel.CRITICAL]: 'danger',
      [AlertLevel.ERROR]: 'danger',
      [AlertLevel.WARNING]: 'warning',
      [AlertLevel.INFO]: 'info'
    }[level]
  }

  const getAlertStatusText = (status: AlertStatus): string => {
    return {
      [AlertStatus.ACTIVE]: '活跃',
      [AlertStatus.ACKNOWLEDGED]: '已确认',
      [AlertStatus.RESOLVED]: '已解决',
      [AlertStatus.SUPPRESSED]: '已抑制',
      [AlertStatus.EXPIRED]: '已过期'
    }[status]
  }

  const getAlertStatusColor = (status: AlertStatus): string => {
    return {
      [AlertStatus.ACTIVE]: 'danger',
      [AlertStatus.ACKNOWLEDGED]: 'warning',
      [AlertStatus.RESOLVED]: 'success',
      [AlertStatus.SUPPRESSED]: 'info',
      [AlertStatus.EXPIRED]: 'info'
    }[status]
  }

  const getAlertTypeText = (type: AlertType): string => {
    const typeMap: Record<AlertType, string> = {
      [AlertType.ACCOUNT_OFFLINE]: '账号离线',
      [AlertType.HEARTBEAT_TIMEOUT]: '心跳超时',
      [AlertType.CONNECTION_ERROR]: '连接错误',
      [AlertType.API_CALL_FAILED]: 'API调用失败',
      [AlertType.STATUS_MISMATCH]: '状态不匹配',
      [AlertType.LOGIN_FAILED]: '登录失败',
      [AlertType.AUTO_RECOVER_FAILED]: '自动恢复失败',
      [AlertType.RETRY_LIMIT_REACHED]: '重试次数超限',
      [AlertType.QUOTA_EXCEEDED]: '配额超限',
      [AlertType.RESPONSE_TIME_HIGH]: '响应时间过高',
      [AlertType.MESSAGE_SEND_FAILED]: '消息发送失败',
      [AlertType.SYSTEM_RESOURCE_LOW]: '系统资源不足',
      [AlertType.NETWORK_ERROR]: '网络错误',
      [AlertType.CALLBACK_ERROR]: '回调错误',
      [AlertType.DATABASE_ERROR]: '数据库错误',
      [AlertType.CACHE_ERROR]: '缓存错误',
      [AlertType.QUEUE_BACKLOG]: '队列积压'
    }
    return typeMap[type] || type
  }

  const resetAlertData = (): void => {
    alertList.value = []
    alertCount.value = {
      total: 0,
      active: 0,
      critical: 0,
      error: 0,
      warning: 0,
      info: 0
    }
    selectedAlerts.value = []
    resetQueryParams()
  }

  // 私有辅助函数
  const generateMockAlertList = (params: AlertQueryParams): PageResult<AlertInfo> => {
    const mockAlerts: AlertInfo[] = []
    const alertTypes = Object.values(AlertType)
    const alertLevels = Object.values(AlertLevel)
    const alertStatuses = Object.values(AlertStatus)
    
    // 生成模拟数据
    for (let i = 1; i <= 50; i++) {
      const level = alertLevels[Math.floor(Math.random() * alertLevels.length)]
      const type = alertTypes[Math.floor(Math.random() * alertTypes.length)]
      const status = alertStatuses[Math.floor(Math.random() * alertStatuses.length)]
      const firstOccurred = new Date(Date.now() - Math.random() * 86400000 * 7) // 7天内
      
      mockAlerts.push({
        id: `alert-${i}`,
        tenantId: 'tenant-1',
        accountId: `account-${Math.floor(Math.random() * 25) + 1}`,
        alertType: type,
        alertLevel: level,
        alertMessage: `模拟告警消息 ${i}: ${getAlertTypeText(type)}`,
        status,
        firstOccurredAt: firstOccurred.toISOString(),
        lastOccurredAt: new Date(firstOccurred.getTime() + Math.random() * 3600000).toISOString(),
        occurrenceCount: Math.floor(Math.random() * 10) + 1,
        autoRecoveryAttempts: Math.floor(Math.random() * 3),
        accountName: `测试账号${Math.floor(Math.random() * 25) + 1}`,
        levelText: getAlertLevelText(level),
        typeText: getAlertTypeText(type),
        statusText: getAlertStatusText(status)
      })
    }
    
    // 应用过滤条件
    let filteredAlerts = mockAlerts
    
    if (params.level) {
      filteredAlerts = filteredAlerts.filter(alert => alert.alertLevel === params.level)
    }
    if (params.status) {
      filteredAlerts = filteredAlerts.filter(alert => alert.status === params.status)
    }
    if (params.type) {
      filteredAlerts = filteredAlerts.filter(alert => alert.alertType === params.type)
    }
    if (params.keyword) {
      filteredAlerts = filteredAlerts.filter(alert => 
        alert.alertMessage.includes(params.keyword!) ||
        alert.accountName?.includes(params.keyword!)
      )
    }
    
    // 分页
    const total = filteredAlerts.length
    const start = (params.page - 1) * params.size
    const end = start + params.size
    const records = filteredAlerts.slice(start, end)
    
    return {
      records,
      total,
      current: params.page,
      size: params.size,
      pages: Math.ceil(total / params.size)
    }
  }

  return {
    // 状态
    alertList,
    alertCount,
    loading,
    selectedAlerts,
    pagination,
    queryParams,
    
    // Getters
    activeAlerts,
    criticalAlerts,
    hasSelectedAlerts,
    alertSummary,
    
    // Actions
    loadAlerts,
    acknowledgeAlert,
    resolveAlert,
    suppressAlert,
    batchOperateAlerts,
    toggleSelectAlert,
    selectAllAlerts,
    clearSelection,
    setQueryParams,
    resetQueryParams,
    getAlertLevelText,
    getAlertLevelColor,
    getAlertStatusText,
    getAlertStatusColor,
    getAlertTypeText,
    resetAlertData
  }
})