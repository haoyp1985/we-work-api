<template>
  <div class="monitor-dashboard">
    <!-- 测试内容 - 确认组件正常加载 -->
    <div style="padding: 20px; background: #f0f9ff; border: 2px solid #0ea5e9; border-radius: 8px; margin-bottom: 20px;">
      <h2 style="color: #0ea5e9; margin: 0 0 10px 0;">🎉 监控模块加载成功！</h2>
      <p style="margin: 0; color: #0369a1;">如果你看到这个消息，说明监控模块的路由和组件都工作正常。</p>
    </div>

    <!-- 页面头部 -->
    <div class="dashboard-header">
      <div class="header-left">
        <h2 class="page-title">
          <el-icon><Monitor /></el-icon>
          企微监控中心
        </h2>
        <div class="header-info">
          <el-tag v-if="tenantStore.currentTenant" type="primary" size="small">
            {{ tenantStore.currentTenant.name }}
          </el-tag>
          <span class="update-time">
            {{ formatDateTime(lastUpdateTime, 'MM-DD HH:mm:ss') }} 更新
          </span>
        </div>
      </div>
      
      <div class="header-right">
        <TenantSwitcher @tenant-changed="handleTenantChange" />
        <RefreshControl
          :refreshing="loading"
          :auto-refresh="autoRefresh"
          :refresh-interval="refreshInterval"
          show-auto-refresh
          show-status
          @refresh="refreshAllData"
          @auto-refresh-change="handleAutoRefreshChange"
          @interval-change="handleIntervalChange"
        />
      </div>
    </div>

    <!-- 核心指标概览 -->
    <div class="overview-section">
      <el-row :gutter="16">
        <el-col :span="6" :xs="12" :sm="12" :md="6">
          <StatsCard
            title="账号总数"
            :value="monitorStats?.totalAccounts || 0"
            icon="User"
            variant="primary"
            :loading="loading"
            :show-trend="true"
            :trend-type="getTrendType(accountTrend)"
            :trend-value="accountTrend"
          >
            <template #subtitle>
              在线 {{ monitorStats?.onlineAccounts || 0 }} / 离线 {{ monitorStats?.offlineAccounts || 0 }}
            </template>
          </StatsCard>
        </el-col>
        
        <el-col :span="6" :xs="12" :sm="12" :md="6">
          <StatsCard
            title="在线率"
            :value="monitorStats?.onlineRate || 0"
            unit="%"
            icon="Connection"
            variant="success"
            :loading="loading"
            :show-progress="true"
            :progress-percentage="monitorStats?.onlineRate || 0"
            :progress-color="getOnlineRateColor(monitorStats?.onlineRate || 0)"
            progress-text="在线率"
          />
        </el-col>
        
        <el-col :span="6" :xs="12" :sm="12" :md="6">
          <StatsCard
            title="健康分数"
            :value="monitorStats?.avgHealthScore || 0"
            :precision="1"
            icon="TrendCharts"
            variant="warning"
            :loading="loading"
            :show-trend="true"
            :trend-type="getTrendType(healthTrend)"
            :trend-value="healthTrend"
          >
            <template #subtitle>
              {{ getHealthLevel(monitorStats?.avgHealthScore || 0) }}
            </template>
          </StatsCard>
        </el-col>
        
        <el-col :span="6" :xs="12" :sm="12" :md="6">
          <StatsCard
            title="活跃告警"
            :value="monitorStats?.activeAlerts || 0"
            icon="Bell"
            :variant="getAlertVariant(monitorStats?.criticalAlerts || 0)"
            :loading="loading"
            :show-trend="true"
            :trend-type="getTrendType(alertTrend)"
            :trend-value="alertTrend"
          >
            <template #subtitle>
              严重 {{ monitorStats?.criticalAlerts || 0 }} / 警告 {{ monitorStats?.warningAlerts || 0 }}
            </template>
            <template #actions>
              <el-button 
                type="primary" 
                link 
                size="small" 
                @click="$router.push('/monitor/alerts')"
              >
                查看详情
              </el-button>
            </template>
          </StatsCard>
        </el-col>
      </el-row>
    </div>

    <!-- 图表区域 -->
    <div class="charts-section">
      <el-row :gutter="16">
        <!-- 健康分数趋势 -->
        <el-col :span="12" :xs="24" :sm="24" :md="12">
          <el-card shadow="never" class="chart-card">
            <template #header>
              <div class="card-header">
                <span class="card-title">健康分数趋势</span>
                <el-button-group size="small">
                  <el-button 
                    v-for="period in timePeriods"
                    :key="period.value"
                    :type="selectedPeriod === period.value ? 'primary' : ''"
                    @click="selectedPeriod = period.value"
                  >
                    {{ period.label }}
                  </el-button>
                </el-button-group>
              </div>
            </template>
            
            <MonitorChart
              :data="healthTrendData"
              chart-type="area"
              height="300px"
              :loading="chartLoading"
              @chart-ready="handleChartReady"
            />
          </el-card>
        </el-col>
        
        <!-- 账号状态分布 -->
        <el-col :span="12" :xs="24" :sm="24" :md="12">
          <el-card shadow="never" class="chart-card">
            <template #header>
              <div class="card-header">
                <span class="card-title">账号状态分布</span>
                <el-tooltip content="点击查看详细信息" placement="top">
                  <el-button size="small" circle :icon="InfoFilled" />
                </el-tooltip>
              </div>
            </template>
            
            <MonitorChart
              :data="statusDistributionData"
              chart-type="pie"
              height="300px"
              :loading="chartLoading"
            />
          </el-card>
        </el-col>
      </el-row>
      
      <el-row :gutter="16" style="margin-top: 16px;">
        <!-- 告警统计 -->
        <el-col :span="12" :xs="24" :sm="24" :md="12">
          <el-card shadow="never" class="chart-card">
            <template #header>
              <div class="card-header">
                <span class="card-title">告警趋势</span>
                <el-dropdown @command="handleAlertTypeFilter">
                  <el-button size="small">
                    {{ selectedAlertType || '全部类型' }}
                    <el-icon class="el-icon--right"><ArrowDown /></el-icon>
                  </el-button>
                  <template #dropdown>
                    <el-dropdown-menu>
                      <el-dropdown-item command="">全部类型</el-dropdown-item>
                      <el-dropdown-item command="CRITICAL">严重</el-dropdown-item>
                      <el-dropdown-item command="WARNING">警告</el-dropdown-item>
                      <el-dropdown-item command="INFO">信息</el-dropdown-item>
                    </el-dropdown-menu>
                  </template>
                </el-dropdown>
              </div>
            </template>
            
            <MonitorChart
              :data="alertTrendData"
              chart-type="bar"
              height="300px"
              :loading="chartLoading"
            />
          </el-card>
        </el-col>
        
        <!-- API性能监控 -->
        <el-col :span="12" :xs="24" :sm="24" :md="12">
          <el-card shadow="never" class="chart-card">
            <template #header>
              <div class="card-header">
                <span class="card-title">API性能</span>
                <div class="performance-indicators">
                  <el-tag size="small" type="success">
                    成功率: {{ (monitorStats?.apiSuccessRate || 0).toFixed(1) }}%
                  </el-tag>
                  <el-tag size="small" type="info">
                    响应时间: {{ monitorStats?.avgApiResponseTime || 0 }}ms
                  </el-tag>
                </div>
              </div>
            </template>
            
            <MonitorChart
              :data="apiPerformanceData"
              chart-type="line"
              height="300px"
              :loading="chartLoading"
            />
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- 实时监控和告警列表 -->
    <div class="bottom-section">
      <el-row :gutter="16">
        <!-- 实时账号状态 -->
        <el-col :span="14" :xs="24" :sm="24" :md="14">
          <el-card shadow="never" class="table-card">
            <template #header>
              <div class="card-header">
                <span class="card-title">实时账号状态</span>
                <div class="header-actions">
                  <el-input
                    v-model="accountSearchKeyword"
                    placeholder="搜索账号"
                    size="small"
                    style="width: 200px;"
                    clearable
                    @input="handleAccountSearch"
                  >
                    <template #prefix>
                      <el-icon><Search /></el-icon>
                    </template>
                  </el-input>
                  <el-button 
                    size="small" 
                    @click="$router.push('/accounts')"
                  >
                    查看全部
                  </el-button>
                </div>
              </div>
            </template>
            
            <DataTable
              :data="realTimeAccounts"
              :columns="accountColumns"
              :loading="tableLoading"
              :show-pagination="false"
              :show-toolbar="false"
              :show-selection="false"
              :show-index="true"
              size="small"
              :max-height="400"
            />
          </el-card>
        </el-col>
        
        <!-- 最新告警 -->
        <el-col :span="10" :xs="24" :sm="24" :md="10">
          <el-card shadow="never" class="alert-card">
            <template #header>
              <div class="card-header">
                <span class="card-title">最新告警</span>
                <div class="header-actions">
                  <el-button 
                    size="small" 
                    type="primary"
                    @click="$router.push('/monitor/alerts')"
                  >
                    管理告警
                  </el-button>
                </div>
              </div>
            </template>
            
            <div class="alert-list" v-loading="alertLoading">
              <div 
                v-for="alert in latestAlerts" 
                :key="alert.id"
                class="alert-item"
                :class="`alert-item--${alert.alertLevel.toLowerCase()}`"
              >
                <div class="alert-header">
                  <StatusIndicator
                    mode="simple"
                    :type="getAlertLevelType(alert.alertLevel)"
                    :text="getAlertTypeText(alert.alertType)"
                  />
                  <span class="alert-time">
                    {{ formatRelativeTime(alert.firstOccurredAt) }}
                  </span>
                </div>
                <div class="alert-content">
                  <div class="alert-message">{{ alert.alertMessage }}</div>
                  <div class="alert-account">{{ alert.accountName }}</div>
                </div>
                <div class="alert-actions">
                  <el-button 
                    size="small" 
                    type="primary" 
                    link
                    @click="handleAlertOperation('acknowledge', alert.id)"
                  >
                    确认
                  </el-button>
                  <el-button 
                    size="small" 
                    type="success" 
                    link
                    @click="handleAlertOperation('resolve', alert.id)"
                  >
                    解决
                  </el-button>
                </div>
              </div>
              
              <div v-if="latestAlerts.length === 0" class="empty-alerts">
                <el-empty description="暂无告警" :image-size="60" />
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import {
  Monitor,
  User,
  Connection,
  TrendCharts,
  Bell,
  InfoFilled,
  ArrowDown,
  Search
} from '@element-plus/icons-vue'

// 组件导入
import { 
  StatsCard, 
  MonitorChart, 
  DataTable, 
  StatusIndicator,
  RefreshControl 
} from '@/components/ui'
import TenantSwitcher from '@/components/TenantSwitcher.vue'

// Stores和工具
import { useMonitorStore, useTenantStore, useAlertStore } from '@/stores'
import { formatDateTime, formatRelativeTime, formatHealthScore } from '@/utils/format'
import { 
  ACCOUNT_STATUS_CONFIG, 
  ALERT_LEVEL_CONFIG, 
  ALERT_TYPE_CONFIG,
  HEALTH_SCORE_LEVELS 
} from '@/constants/monitor'

// 路由
const router = useRouter()

// Stores
const monitorStore = useMonitorStore()
const tenantStore = useTenantStore()
const alertStore = useAlertStore()

// 响应式数据
const loading = ref(false)
const chartLoading = ref(false)
const tableLoading = ref(false)
const alertLoading = ref(false)
const autoRefresh = ref(true)
const refreshInterval = ref(30000)
const lastUpdateTime = ref<Date>(new Date())

// 搜索和过滤
const accountSearchKeyword = ref('')
const selectedPeriod = ref('24h')
const selectedAlertType = ref('')

// 趋势数据（模拟）
const accountTrend = ref(5.2)
const healthTrend = ref(-2.1)
const alertTrend = ref(12.5)

// 时间周期选项
const timePeriods = [
  { label: '1小时', value: '1h' },
  { label: '6小时', value: '6h' },
  { label: '24小时', value: '24h' },
  { label: '7天', value: '7d' }
]

// Computed
const monitorStats = computed(() => monitorStore.monitorStats)
const realTimeAccounts = computed(() => {
  let accounts = monitorStore.realTimeData
  
  if (accountSearchKeyword.value) {
    accounts = accounts.filter(account => 
      account.accountName.includes(accountSearchKeyword.value) ||
      account.weWorkGuid.includes(accountSearchKeyword.value)
    )
  }
  
  return accounts.slice(0, 10) // 只显示前10个
})

const latestAlerts = computed(() => {
  return alertStore.alertList
    .filter(alert => alert.status === 'ACTIVE' as AlertStatus)
    .sort((a, b) => new Date(b.firstOccurredAt).getTime() - new Date(a.firstOccurredAt).getTime())
    .slice(0, 5) // 只显示最新5个
})

// 表格列配置
const accountColumns = [
  {
    prop: 'accountName',
    label: '账号名称',
    minWidth: 120
  },
  {
    prop: 'status',
    label: '状态',
    width: 80,
    type: 'status' as const,
    statusMap: ACCOUNT_STATUS_CONFIG
  },
  {
    prop: 'healthScore',
    label: '健康分数',
    width: 100,
    formatter: (row: any) => row.healthScore ? `${row.healthScore}分` : '-'
  },
  {
    prop: 'lastHeartbeatTime',
    label: '最后心跳',
    width: 120,
    type: 'datetime' as const,
    format: 'HH:mm:ss'
  }
]

// 图表数据
const healthTrendData = computed(() => {
  return monitorStats.value?.healthScoreTrend || []
})

const statusDistributionData = computed(() => {
  const distribution = monitorStats.value?.statusDistribution || {}
  return Object.entries(distribution).map(([status, count]) => ({
    name: ACCOUNT_STATUS_CONFIG[status as keyof typeof ACCOUNT_STATUS_CONFIG]?.text || status,
    value: count
  }))
})

const alertTrendData = computed(() => {
  return monitorStats.value?.alertCountTrend || []
})

const apiPerformanceData = computed(() => {
  // 模拟API性能数据
  return Array.from({ length: 24 }, (_, i) => ({
    name: `${23 - i}:00`,
    value: Math.floor(Math.random() * 100) + 50
  }))
})

// Methods
const refreshAllData = async () => {
  try {
    loading.value = true
    lastUpdateTime.value = new Date()
    
    const currentTenantId = tenantStore.currentTenant?.id
    
    // 并行加载所有数据
    await Promise.all([
      monitorStore.loadMonitorStats(currentTenantId),
      monitorStore.loadRealTimeData(currentTenantId),
      alertStore.loadAlerts({ 
        tenantId: currentTenantId,
        status: 'ACTIVE' as AlertStatus as AlertStatus,
        page: 1,
        size: 20
      })
    ])
    
  } catch (error: any) {
    console.error('Refresh data error:', error)
    ElMessage.error(error.message || '刷新数据失败')
  } finally {
    loading.value = false
  }
}

const handleTenantChange = () => {
  refreshAllData()
}

const handleAutoRefreshChange = (enabled: boolean) => {
  autoRefresh.value = enabled
  if (enabled) {
    monitorStore.startAutoRefresh()
  } else {
    monitorStore.stopAutoRefresh()
  }
}

const handleIntervalChange = (interval: number) => {
  refreshInterval.value = interval
  monitorStore.setRefreshInterval(interval)
}

const handleAccountSearch = () => {
  // 搜索逻辑已在computed中处理
}

const handleAlertTypeFilter = (type: string) => {
  selectedAlertType.value = type
  // 重新加载告警数据
  alertStore.loadAlerts({
    level: (type as AlertLevel) || undefined,
    status: 'ACTIVE' as AlertStatus
  })
}

const handleAlertOperation = async (operation: string, alertId: string) => {
  try {
    if (operation === 'acknowledge') {
      await alertStore.acknowledgeAlert(alertId)
    } else if (operation === 'resolve') {
      await alertStore.resolveAlert(alertId)
    }
    
    // 刷新告警列表
    alertStore.loadAlerts({ status: 'ACTIVE' })
    
  } catch (error: any) {
    ElMessage.error(error.message || '操作失败')
  }
}

const handleChartReady = (chart: any) => {
  // 图表就绪处理
  console.log('Chart ready:', chart)
}

// 工具函数
const getTrendType = (value: number): 'up' | 'down' | 'flat' => {
  if (value > 0) return 'up'
  if (value < 0) return 'down'
  return 'flat'
}

const getOnlineRateColor = (rate: number): string => {
  if (rate >= 90) return '#67C23A'
  if (rate >= 70) return '#E6A23C'
  return '#F56C6C'
}

const getHealthLevel = (score: number): string => {
  return formatHealthScore(score).level
}

const getAlertVariant = (criticalCount: number): 'primary' | 'success' | 'warning' | 'danger' | 'info' | 'default' => {
  if (criticalCount > 0) return 'danger'
  return 'info'
}

const getAlertLevelType = (level: string): 'primary' | 'success' | 'warning' | 'danger' | 'info' | 'default' => {
  return ALERT_LEVEL_CONFIG[level as keyof typeof ALERT_LEVEL_CONFIG]?.type || 'info'
}

const getAlertTypeText = (type: string): string => {
  return ALERT_TYPE_CONFIG[type as keyof typeof ALERT_TYPE_CONFIG]?.text || type
}

// 生命周期
onMounted(() => {
  refreshAllData()
  
  // 启动自动刷新
  if (autoRefresh.value) {
    monitorStore.startAutoRefresh()
  }
})

onUnmounted(() => {
  monitorStore.stopAutoRefresh()
})
</script>

<style scoped lang="scss">
.monitor-dashboard {
  padding: 20px;
  background: var(--el-bg-color-page);
  
  .dashboard-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    padding: 20px;
    background: var(--el-bg-color);
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.06);
    
    .header-left {
      .page-title {
        display: flex;
        align-items: center;
        gap: 8px;
        margin: 0 0 8px 0;
        font-size: 24px;
        font-weight: 600;
        color: var(--el-text-color-primary);
      }
      
      .header-info {
        display: flex;
        align-items: center;
        gap: 12px;
        
        .update-time {
          font-size: 13px;
          color: var(--el-text-color-secondary);
        }
      }
    }
    
    .header-right {
      display: flex;
      align-items: center;
      gap: 16px;
    }
  }
  
  .overview-section {
    margin-bottom: 20px;
  }
  
  .charts-section {
    margin-bottom: 20px;
    
    .chart-card {
      border: none;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
      
      .card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        
        .card-title {
          font-weight: 500;
          color: var(--el-text-color-primary);
        }
        
        .performance-indicators {
          display: flex;
          gap: 8px;
        }
      }
    }
  }
  
  .bottom-section {
    .table-card,
    .alert-card {
      border: none;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
      
      .card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        
        .card-title {
          font-weight: 500;
          color: var(--el-text-color-primary);
        }
        
        .header-actions {
          display: flex;
          gap: 8px;
          align-items: center;
        }
      }
    }
    
    .alert-list {
      .alert-item {
        padding: 12px;
        border-bottom: 1px solid var(--el-border-color-lighter);
        transition: background-color 0.2s;
        
        &:hover {
          background: var(--el-bg-color-page);
        }
        
        &:last-child {
          border-bottom: none;
        }
        
        &.alert-item--critical {
          border-left: 3px solid #F56C6C;
        }
        
        &.alert-item--warning {
          border-left: 3px solid #E6A23C;
        }
        
        &.alert-item--info {
          border-left: 3px solid #409EFF;
        }
        
        .alert-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 8px;
          
          .alert-time {
            font-size: 12px;
            color: var(--el-text-color-secondary);
          }
        }
        
        .alert-content {
          margin-bottom: 8px;
          
          .alert-message {
            font-size: 14px;
            color: var(--el-text-color-primary);
            margin-bottom: 4px;
          }
          
          .alert-account {
            font-size: 12px;
            color: var(--el-text-color-secondary);
          }
        }
        
        .alert-actions {
          display: flex;
          gap: 8px;
        }
      }
      
      .empty-alerts {
        padding: 40px 20px;
        text-align: center;
      }
    }
  }
}

// 响应式布局
@media (max-width: 768px) {
  .monitor-dashboard {
    padding: 12px;
    
    .dashboard-header {
      flex-direction: column;
      gap: 16px;
      align-items: flex-start;
      
      .header-right {
        width: 100%;
        justify-content: space-between;
      }
    }
  }
}
</style>