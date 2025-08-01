import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { 
  MonitorStatistics, 
  AccountHealthReport, 
  WeWorkAccountDetail,
  TrendPoint 
} from '@/types'
import { ElMessage } from 'element-plus'
import { useTenantStore } from './tenant'

export const useMonitorStore = defineStore('monitor', () => {
  // 状态
  const monitorStats = ref<MonitorStatistics | null>(null)
  const accountList = ref<WeWorkAccountDetail[]>([])
  const healthReports = ref<Map<string, AccountHealthReport>>(new Map())
  const realTimeData = ref<WeWorkAccountDetail[]>([])
  const loading = ref(false)
  const realTimeLoading = ref(false)
  
  // 监控数据自动刷新
  const autoRefresh = ref(true)
  const refreshInterval = ref(30000) // 30秒
  let refreshTimer: number | null = null

  // Getters
  const onlineRate = computed(() => {
    if (!monitorStats.value || monitorStats.value.totalAccounts === 0) return 0
    return Math.round((monitorStats.value.onlineAccounts / monitorStats.value.totalAccounts) * 100)
  })

  const avgHealthScore = computed(() => {
    return monitorStats.value?.avgHealthScore || 0
  })

  const alertSummary = computed(() => {
    if (!monitorStats.value) return { total: 0, critical: 0, warning: 0 }
    
    return {
      total: monitorStats.value.activeAlerts,
      critical: monitorStats.value.criticalAlerts,
      warning: monitorStats.value.warningAlerts
    }
  })

  const healthTrend = computed(() => {
    return monitorStats.value?.healthScoreTrend || []
  })

  const statusDistribution = computed(() => {
    return monitorStats.value?.statusDistribution || {}
  })

  // Actions
  const loadMonitorStats = async (tenantId?: string): Promise<void> => {
    try {
      loading.value = true
      
      // TODO: 调用后端API获取监控统计
      // const response = await monitorApi.getMonitorStatistics(tenantId)
      // monitorStats.value = response.data
      
      // 临时模拟数据
      monitorStats.value = {
        tenantId: tenantId || undefined,
        statisticsTime: new Date().toISOString(),
        periodSeconds: 300,
        totalAccounts: 25,
        onlineAccounts: 22,
        offlineAccounts: 2,
        errorAccounts: 1,
        recoveringAccounts: 0,
        onlineRate: 88,
        avgHealthScore: 85.6,
        healthyAccounts: 20,
        attentionNeededAccounts: 3,
        criticalAccounts: 2,
        activeAlerts: 8,
        criticalAlerts: 2,
        errorAlerts: 3,
        warningAlerts: 3,
        infoAlerts: 0,
        newAlerts: 2,
        resolvedAlerts: 15,
        alertResolutionRate: 85.2,
        avgResolutionTime: 12.5,
        avgApiResponseTime: 156,
        apiSuccessRate: 99.2,
        totalApiCalls: 15420,
        successfulApiCalls: 15297,
        failedApiCalls: 123,
        heartbeatNormalRate: 94.5,
        avgHeartbeatInterval: 30,
        healthScoreTrend: generateMockTrendData(),
        onlineRateTrend: generateMockTrendData(),
        alertCountTrend: generateMockAlertTrend(),
        statusDistribution: {
          'ONLINE': 22,
          'OFFLINE': 2,
          'ERROR': 1
        },
        healthScoreDistribution: {
          '90-100': 12,
          '80-89': 8,
          '70-79': 3,
          '60-69': 1,
          '0-59': 1
        },
        alertTypeDistribution: {
          'HEARTBEAT_TIMEOUT': 3,
          'ACCOUNT_OFFLINE': 2,
          'API_CALL_FAILED': 2,
          'CONNECTION_ERROR': 1
        }
      }
      
    } catch (error: any) {
      console.error('Load monitor stats error:', error)
      ElMessage.error(error.message || '获取监控统计失败')
    } finally {
      loading.value = false
    }
  }

  const loadAccountList = async (tenantId?: string): Promise<void> => {
    try {
      // TODO: 调用后端API获取账号列表
      // const response = await accountApi.getAccountList(tenantId)
      // accountList.value = response.data
      
      // 临时模拟数据
      accountList.value = generateMockAccountList()
      
    } catch (error: any) {
      console.error('Load account list error:', error)
      ElMessage.error(error.message || '获取账号列表失败')
    }
  }

  const getAccountHealth = async (accountId: string): Promise<AccountHealthReport | null> => {
    try {
      // 先从缓存获取
      if (healthReports.value.has(accountId)) {
        return healthReports.value.get(accountId)!
      }
      
      // TODO: 调用后端API获取账号健康报告
      // const response = await monitorApi.getAccountHealth(accountId)
      // const report = response.data
      
      // 临时模拟数据
      const report = generateMockHealthReport(accountId)
      
      // 缓存结果
      healthReports.value.set(accountId, report)
      
      return report
      
    } catch (error: any) {
      console.error('Get account health error:', error)
      ElMessage.error(error.message || '获取账号健康报告失败')
      return null
    }
  }

  const loadRealTimeData = async (tenantId?: string): Promise<void> => {
    try {
      realTimeLoading.value = true
      
      // TODO: 调用后端API获取实时数据
      // const response = await monitorApi.getRealTimeData(tenantId)
      // realTimeData.value = response.data
      
      // 临时模拟数据
      realTimeData.value = generateMockRealTimeData()
      
    } catch (error: any) {
      console.error('Load real time data error:', error)
      ElMessage.error(error.message || '获取实时数据失败')
    } finally {
      realTimeLoading.value = false
    }
  }

  const startAutoRefresh = (): void => {
    if (refreshTimer) {
      clearInterval(refreshTimer)
    }
    
    if (autoRefresh.value) {
      refreshTimer = window.setInterval(() => {
        refreshMonitorData()
      }, refreshInterval.value)
    }
  }

  const stopAutoRefresh = (): void => {
    if (refreshTimer) {
      clearInterval(refreshTimer)
      refreshTimer = null
    }
  }

  const refreshMonitorData = async (): Promise<void> => {
    const tenantStore = useTenantStore()
    const currentTenantId = tenantStore.currentTenant?.id
    
    // 并行刷新所有数据
    await Promise.all([
      loadMonitorStats(currentTenantId),
      loadRealTimeData(currentTenantId)
    ])
  }

  const setAutoRefresh = (enabled: boolean): void => {
    autoRefresh.value = enabled
    if (enabled) {
      startAutoRefresh()
    } else {
      stopAutoRefresh()
    }
  }

  const setRefreshInterval = (interval: number): void => {
    refreshInterval.value = interval
    if (autoRefresh.value) {
      startAutoRefresh() // 重新启动定时器
    }
  }

  const clearCache = (): void => {
    healthReports.value.clear()
  }

  const resetMonitorData = (): void => {
    monitorStats.value = null
    accountList.value = []
    healthReports.value.clear()
    realTimeData.value = []
    stopAutoRefresh()
  }

  // 私有辅助函数
  const generateMockTrendData = (): TrendPoint[] => {
    const data: TrendPoint[] = []
    const now = new Date()
    
    for (let i = 23; i >= 0; i--) {
      const timestamp = new Date(now.getTime() - i * 60 * 60 * 1000)
      data.push({
        timestamp: timestamp.toISOString(),
        value: Math.floor(Math.random() * 20) + 75, // 75-95之间的随机值
        label: timestamp.getHours().toString().padStart(2, '0') + ':00'
      })
    }
    
    return data
  }

  const generateMockAlertTrend = (): TrendPoint[] => {
    const data: TrendPoint[] = []
    const now = new Date()
    
    for (let i = 23; i >= 0; i--) {
      const timestamp = new Date(now.getTime() - i * 60 * 60 * 1000)
      data.push({
        timestamp: timestamp.toISOString(),
        value: Math.floor(Math.random() * 5), // 0-4之间的随机告警数
        label: timestamp.getHours().toString().padStart(2, '0') + ':00'
      })
    }
    
    return data
  }

  const generateMockAccountList = (): WeWorkAccountDetail[] => {
    const accounts: WeWorkAccountDetail[] = []
    const statuses = ['ONLINE', 'OFFLINE', 'ERROR', 'RECOVERING'] as const
    
    for (let i = 1; i <= 25; i++) {
      accounts.push({
        id: `account-${i}`,
        tenantId: 'tenant-1',
        name: `测试账号${i}`,
        wxid: `wxid_${i}`,
        accountName: `测试账号${i}`,
        weWorkGuid: `guid-${i}`,
        phone: `1380013800${i.toString().padStart(2, '0')}`,
        status: statuses[Math.floor(Math.random() * statuses.length)] as any,
        healthScore: Math.floor(Math.random() * 40) + 60, // 60-100之间
        isOnline: Math.random() > 0.2,
        lastHeartbeatTime: new Date(Date.now() - Math.random() * 300000).toISOString(),
        autoReconnect: true,
        monitorInterval: 30,
        maxRetryCount: 3,
        retryCount: Math.floor(Math.random() * 2),
        createTime: new Date(Date.now() - Math.random() * 86400000 * 30).toISOString(),
        updateTime: new Date().toISOString()
      })
    }
    
    return accounts
  }

  const generateMockHealthReport = (accountId: string): AccountHealthReport => {
    return {
      accountId,
      tenantId: 'tenant-1',
      accountName: `测试账号${accountId.split('-')[1]}`,
      status: 'ONLINE' as any,
      healthScore: Math.floor(Math.random() * 40) + 60,
      healthTrend: 'STABLE',
      lastHeartbeatTime: new Date(Date.now() - Math.random() * 60000).toISOString(),
      heartbeatInterval: 30,
      heartbeatNormal: Math.random() > 0.1,
      apiResponseTime: Math.floor(Math.random() * 200) + 50,
      apiSuccessRate: Math.random() * 10 + 90,
      retryCount: Math.floor(Math.random() * 3),
      maxRetryCount: 3,
      onlineDuration: Math.floor(Math.random() * 1440), // 最多24小时
      errorCount: Math.floor(Math.random() * 5),
      recoveryCount: Math.floor(Math.random() * 3),
      activeAlertCount: Math.floor(Math.random() * 3),
      healthCheckItems: [
        {
          checkName: '状态检查',
          checkType: 'STATUS',
          passed: true,
          result: '正常',
          message: '账号状态正常',
          severity: 'INFO'
        },
        {
          checkName: '心跳检查',
          checkType: 'HEARTBEAT',
          passed: Math.random() > 0.1,
          result: Math.random() > 0.1 ? '正常' : '异常',
          message: Math.random() > 0.1 ? '心跳正常' : '心跳超时',
          severity: Math.random() > 0.1 ? 'INFO' : 'WARNING'
        }
      ],
      recommendedActions: ['定期检查账号状态'],
      riskAssessment: '低风险：账号运行良好',
      checkTime: new Date().toISOString(),
      dataValidSeconds: 300
    }
  }

  const generateMockRealTimeData = (): WeWorkAccountDetail[] => {
    return generateMockAccountList().slice(0, 10) // 只显示前10个作为实时数据
  }

  return {
    // 状态
    monitorStats,
    accountList,
    healthReports,
    realTimeData,
    loading,
    realTimeLoading,
    autoRefresh,
    refreshInterval,
    
    // Getters
    onlineRate,
    avgHealthScore,
    alertSummary,
    healthTrend,
    statusDistribution,
    
    // Actions
    loadMonitorStats,
    loadAccountList,
    getAccountHealth,
    loadRealTimeData,
    startAutoRefresh,
    stopAutoRefresh,
    refreshMonitorData,
    setAutoRefresh,
    setRefreshInterval,
    clearCache,
    resetMonitorData
  }
})