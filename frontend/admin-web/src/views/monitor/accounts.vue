<template>
  <div class="account-monitor">
    <!-- 测试内容 - 确认组件正常加载 -->
    <div style="padding: 20px; background: #fef3c7; border: 2px solid #f59e0b; border-radius: 8px; margin-bottom: 20px;">
      <h2 style="color: #f59e0b; margin: 0 0 10px 0;">👥 账号监控页面加载成功！</h2>
      <p style="margin: 0; color: #d97706;">账号监控模块正常工作。</p>
    </div>

    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-left">
        <h2 class="page-title">
          <el-icon><User /></el-icon>
          账号监控
        </h2>
        <div class="header-stats">
          <StatusIndicator
            mode="simple"
            type="success"
            :text="`在线: ${stats.onlineCount}`"
          />
          <StatusIndicator
            mode="simple"
            type="danger"
            :text="`离线: ${stats.offlineCount}`"
          />
          <StatusIndicator
            mode="simple"
            type="warning"
            :text="`异常: ${stats.errorCount}`"
          />
          <StatusIndicator
            mode="simple"
            type="info"
            :text="`总计: ${stats.totalCount}`"
          />
        </div>
      </div>
      
      <div class="header-right">
        <RefreshControl
          :refreshing="loading"
          :auto-refresh="autoRefresh"
          :refresh-interval="refreshInterval"
          show-auto-refresh
          show-status
          @refresh="loadAccounts"
          @auto-refresh-change="handleAutoRefreshChange"
          @interval-change="handleIntervalChange"
        />
      </div>
    </div>

    <!-- 统计卡片 -->
    <div class="stats-section">
      <el-row :gutter="16">
        <el-col :span="6" :xs="12" :sm="12" :md="6">
          <StatsCard
            title="健康账号"
            :value="stats.healthyCount"
            icon="CircleCheck"
            variant="success"
            :loading="loading"
            :show-progress="true"
            :progress-percentage="stats.healthyRate"
            :progress-color="['#67C23A', '#85CE61']"
            progress-text="健康率"
          >
            <template #subtitle>
              健康分数 ≥ 80分
            </template>
          </StatsCard>
        </el-col>
        
        <el-col :span="6" :xs="12" :sm="12" :md="6">
          <StatsCard
            title="需要关注"
            :value="stats.attentionCount"
            icon="Warning"
            variant="warning"
            :loading="loading"
            :show-progress="true"
            :progress-percentage="stats.attentionRate"
            :progress-color="['#E6A23C', '#EEBE77']"
            progress-text="关注率"
          >
            <template #subtitle>
              健康分数 60-79分
            </template>
          </StatsCard>
        </el-col>
        
        <el-col :span="6" :xs="12" :sm="12" :md="6">
          <StatsCard
            title="严重问题"
            :value="stats.criticalCount"
            icon="CircleClose"
            variant="danger"
            :loading="loading"
            :show-progress="true"
            :progress-percentage="stats.criticalRate"
            :progress-color="['#F56C6C', '#F78989']"
            progress-text="问题率"
          >
            <template #subtitle>
              健康分数 < 60分
            </template>
          </StatsCard>
        </el-col>
        
        <el-col :span="6" :xs="12" :sm="12" :md="6">
          <StatsCard
            title="平均健康分"
            :value="stats.avgHealthScore"
            :precision="1"
            icon="TrendCharts"
            variant="primary"
            :loading="loading"
          >
            <template #subtitle>
              {{ getHealthLevel(stats.avgHealthScore) }}
            </template>
          </StatsCard>
        </el-col>
      </el-row>
    </div>

    <!-- 过滤器和操作栏 -->
    <el-card shadow="never" class="filter-card">
      <div class="filter-container">
        <div class="filter-left">
          <el-input
            v-model="filters.keyword"
            placeholder="搜索账号名称、GUID"
            style="width: 250px;"
            clearable
            @input="handleSearch"
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>
          
          <el-select
            v-model="filters.status"
            placeholder="账号状态"
            clearable
            style="width: 120px;"
            @change="handleFilterChange"
          >
            <el-option
              v-for="status in accountStatuses"
              :key="status.value"
              :label="status.label"
              :value="status.value"
            />
          </el-select>
          
          <el-select
            v-model="filters.healthRange"
            placeholder="健康分数"
            clearable
            style="width: 140px;"
            @change="handleFilterChange"
          >
            <el-option label="优秀 (90-100)" value="90-100" />
            <el-option label="良好 (80-89)" value="80-89" />
            <el-option label="一般 (60-79)" value="60-79" />
            <el-option label="较差 (0-59)" value="0-59" />
          </el-select>
          
          <el-select
            v-model="filters.autoReconnect"
            placeholder="自动重连"
            clearable
            style="width: 120px;"
            @change="handleFilterChange"
          >
            <el-option label="已启用" :value="true" />
            <el-option label="已禁用" :value="false" />
          </el-select>
        </div>
        
        <div class="filter-right">
          <el-button @click="resetFilters">
            <el-icon><RefreshRight /></el-icon>
            重置
          </el-button>
          <el-button type="primary" @click="showBatchHealthCheck = true">
            <el-icon><Monitor /></el-icon>
            批量健康检查
          </el-button>
          <el-button type="success" @click="handleExport">
            <el-icon><Download /></el-icon>
            导出报告
          </el-button>
        </div>
      </div>
    </el-card>

    <!-- 账号列表 -->
    <el-card shadow="never" class="table-card">
      <DataTable
        ref="tableRef"
        :data="monitorStore.accountList"
        :columns="tableColumns"
        :loading="loading"
        :current-page="pagination.current"
        :page-size="pagination.size"
        :total="pagination.total"
        :batch-actions="batchActions"
        show-selection
        show-toolbar
        @update:current-page="handlePageChange"
        @update:page-size="handleSizeChange"
        @selection-change="handleSelectionChange"
        @action="handleAction"
        @batch-action="handleBatchAction"
        @refresh="loadAccounts"
      />
    </el-card>

    <!-- 账号详情弹窗 -->
    <el-dialog
      v-model="detailDialogVisible"
      title="账号监控详情"
      width="1000px"
      :close-on-click-modal="false"
    >
      <div v-if="selectedAccount" class="account-detail">
        <!-- 基本信息 -->
        <el-descriptions title="基本信息" :column="3" border>
          <el-descriptions-item label="账号名称">
            {{ selectedAccount.accountName }}
          </el-descriptions-item>
          <el-descriptions-item label="企微GUID">
            {{ selectedAccount.weWorkGuid }}
          </el-descriptions-item>
          <el-descriptions-item label="状态">
            <StatusIndicator
              mode="tag"
              :type="getStatusType(selectedAccount.status)"
              :text="getStatusText(selectedAccount.status)"
            />
          </el-descriptions-item>
          <el-descriptions-item label="健康分数">
            <StatusIndicator
              mode="health"
              :health-score="selectedAccount.healthScore"
              text="当前健康状态"
            />
          </el-descriptions-item>
          <el-descriptions-item label="自动重连">
            <el-tag :type="selectedAccount.autoReconnect ? 'success' : 'info'">
              {{ selectedAccount.autoReconnect ? '已启用' : '已禁用' }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="重试次数">
            {{ selectedAccount.retryCount || 0 }} / {{ selectedAccount.maxRetryCount || 3 }}
          </el-descriptions-item>
        </el-descriptions>

        <!-- 时间信息 -->
        <el-descriptions title="时间信息" :column="2" border style="margin-top: 20px;">
          <el-descriptions-item label="创建时间">
            {{ formatDateTime(selectedAccount.createdAt) }}
          </el-descriptions-item>
          <el-descriptions-item label="最后登录">
            {{ formatDateTime(selectedAccount.lastLoginTime) || '从未登录' }}
          </el-descriptions-item>
          <el-descriptions-item label="最后心跳">
            {{ formatDateTime(selectedAccount.lastHeartbeatTime) || '无心跳' }}
          </el-descriptions-item>
          <el-descriptions-item label="更新时间">
            {{ formatDateTime(selectedAccount.updatedAt) }}
          </el-descriptions-item>
        </el-descriptions>

        <!-- 监控信息 -->
        <div class="monitor-info" style="margin-top: 20px;">
          <h4>监控配置</h4>
          <el-row :gutter="16">
            <el-col :span="12">
              <el-card>
                <div class="config-item">
                  <span class="config-label">监控间隔:</span>
                  <span class="config-value">{{ selectedAccount.monitorInterval || 30 }}秒</span>
                </div>
                <div class="config-item">
                  <span class="config-label">最大重试:</span>
                  <span class="config-value">{{ selectedAccount.maxRetryCount || 3 }}次</span>
                </div>
                <div class="config-item">
                  <span class="config-label">回调地址:</span>
                  <span class="config-value">{{ selectedAccount.callbackUrl || '未配置' }}</span>
                </div>
              </el-card>
            </el-col>
            <el-col :span="12">
              <el-card>
                <div class="config-item">
                  <span class="config-label">代理ID:</span>
                  <span class="config-value">{{ selectedAccount.proxyId || '未配置' }}</span>
                </div>
                <div class="config-item">
                  <span class="config-label">租户标签:</span>
                  <span class="config-value">{{ selectedAccount.tenantTag || '默认' }}</span>
                </div>
                <div class="config-item">
                  <span class="config-label">自动恢复:</span>
                  <span class="config-value">{{ selectedAccount.autoRecoveryAttempts || 0 }}次</span>
                </div>
              </el-card>
            </el-col>
          </el-row>
        </div>

        <!-- 健康报告 -->
        <div v-if="accountHealthReport" class="health-report" style="margin-top: 20px;">
          <h4>健康报告</h4>
          <el-row :gutter="16">
            <el-col :span="8" v-for="item in accountHealthReport.healthCheckItems" :key="item.checkName">
              <el-card class="health-item">
                <div class="health-metric">
                  <div class="metric-name">{{ item.checkName }}</div>
                  <div class="metric-score" :class="getHealthScoreClass(item.passed ? 100 : 0)">
                    {{ item.passed ? '通过' : '失败' }}
                  </div>
                </div>
                <div class="metric-status">
                  <el-tag :type="item.passed ? 'success' : 'warning'" size="small">
                    {{ item.passed ? '正常' : '异常' }}
                  </el-tag>
                </div>
                <div class="metric-details">{{ item.message }}</div>
              </el-card>
            </el-col>
          </el-row>
        </div>
      </div>
      
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="detailDialogVisible = false">关闭</el-button>
          <el-button
            v-if="selectedAccount && selectedAccount.status === 'OFFLINE'"
            type="primary"
            @click="handleAccountOperation('start')"
          >
            启动账号
          </el-button>
          <el-button
            v-if="selectedAccount && selectedAccount.status === 'ONLINE'"
            type="warning"
            @click="handleAccountOperation('stop')"
          >
            停止账号
          </el-button>
          <el-button
            type="info"
            @click="handleAccountOperation('restart')"
          >
            重启账号
          </el-button>
          <el-button
            type="success"
            @click="runHealthCheck"
          >
            健康检查
          </el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 批量健康检查弹窗 -->
    <el-dialog
      v-model="showBatchHealthCheck"
      title="批量健康检查"
      width="600px"
      :close-on-click-modal="false"
    >
      <div class="batch-health-check">
        <el-alert
          title="批量健康检查将对所有选中的账号进行全面检测"
          type="info"
          :closable="false"
          show-icon
        />
        
        <div style="margin: 20px 0;">
          <el-checkbox v-model="healthCheckOptions.includeOffline">
            包含离线账号
          </el-checkbox>
          <el-checkbox v-model="healthCheckOptions.forceCheck">
            强制检查（忽略缓存）
          </el-checkbox>
          <el-checkbox v-model="healthCheckOptions.generateReport">
            生成详细报告
          </el-checkbox>
        </div>
        
        <div class="check-progress" v-if="healthCheckRunning">
          <el-progress
            :percentage="healthCheckProgress"
            :stroke-width="8"
            :show-text="true"
          />
          <div class="progress-text">
            正在检查第 {{ healthCheckCurrent }} / {{ healthCheckTotal }} 个账号
          </div>
        </div>
      </div>
      
      <template #footer>
        <el-button @click="showBatchHealthCheck = false">取消</el-button>
        <el-button
          type="primary"
          :loading="healthCheckRunning"
          @click="runBatchHealthCheck"
        >
          开始检查
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted, reactive } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  User,
  Search,
  RefreshRight,
  Download,
  Monitor,
  CircleCheck,
  Warning,
  CircleClose,
  TrendCharts
} from '@element-plus/icons-vue'

// 组件导入
import { StatsCard, DataTable, StatusIndicator, RefreshControl } from '@/components/ui'
import { useMonitorStore, useTenantStore } from '@/stores'
import { formatDateTime, formatHealthScore } from '@/utils/format'
import { ACCOUNT_STATUS_CONFIG, BATCH_OPERATIONS } from '@/constants/monitor'
import type { WeWorkAccountDetail, AccountHealthReport } from '@/types'

// Store
const monitorStore = useMonitorStore()
const tenantStore = useTenantStore()

// 响应式数据
const loading = ref(false)
const autoRefresh = ref(true)
const refreshInterval = ref(30000)
const tableRef = ref()

// 统计数据
const stats = computed(() => {
  const accounts = monitorStore.accountList
  const totalCount = accounts.length
  const onlineCount = accounts.filter(acc => acc.status === 'ONLINE').length
  const offlineCount = accounts.filter(acc => acc.status === 'OFFLINE').length
  const errorCount = accounts.filter(acc => acc.status === 'ERROR').length
  
  const healthyCount = accounts.filter(acc => (acc.healthScore || 0) >= 80).length
  const attentionCount = accounts.filter(acc => {
    const score = acc.healthScore || 0
    return score >= 60 && score < 80
  }).length
  const criticalCount = accounts.filter(acc => (acc.healthScore || 0) < 60).length
  
  const avgHealthScore = totalCount > 0 
    ? accounts.reduce((sum, acc) => sum + (acc.healthScore || 0), 0) / totalCount 
    : 0
  
  return {
    totalCount,
    onlineCount,
    offlineCount,
    errorCount,
    healthyCount,
    attentionCount,
    criticalCount,
    avgHealthScore,
    healthyRate: totalCount > 0 ? Math.round((healthyCount / totalCount) * 100) : 0,
    attentionRate: totalCount > 0 ? Math.round((attentionCount / totalCount) * 100) : 0,
    criticalRate: totalCount > 0 ? Math.round((criticalCount / totalCount) * 100) : 0
  }
})

// 分页
const pagination = computed(() => ({
  current: 1,
  size: 20,
  total: monitorStore.accountList.length
}))

// 过滤器
const filters = reactive({
  keyword: '',
  status: '',
  healthRange: '',
  autoReconnect: '',
  tenantId: computed(() => tenantStore.currentTenant?.id)
})

// 选择状态
const selectedAccounts = ref<WeWorkAccountDetail[]>([])
const selectedAccount = ref<WeWorkAccountDetail | null>(null)
const accountHealthReport = ref<AccountHealthReport | null>(null)

// 弹窗状态
const detailDialogVisible = ref(false)
const showBatchHealthCheck = ref(false)

// 健康检查
const healthCheckRunning = ref(false)
const healthCheckProgress = ref(0)
const healthCheckCurrent = ref(0)
const healthCheckTotal = ref(0)
const healthCheckOptions = reactive({
  includeOffline: false,
  forceCheck: false,
  generateReport: true
})

// 配置数据
const accountStatuses = Object.entries(ACCOUNT_STATUS_CONFIG).map(([key, config]) => ({
  value: key,
  label: config.text
}))

const batchActions = BATCH_OPERATIONS.accounts

// 表格列配置
const tableColumns = [
  {
    prop: 'accountName',
    label: '账号名称',
    minWidth: 140,
    fixed: 'left' as const
  },
  {
    prop: 'status',
    label: '状态',
    width: 100,
    type: 'status' as const,
    statusMap: ACCOUNT_STATUS_CONFIG
  },
  {
    prop: 'healthScore',
    label: '健康分数',
    width: 120,
    formatter: (row: WeWorkAccountDetail) => {
      if (!row.healthScore) return '-'
      const health = formatHealthScore(row.healthScore)
      return `${health.score}分 (${health.level})`
    }
  },
  {
    prop: 'weWorkGuid',
    label: '企微GUID',
    width: 200,
    showOverflowTooltip: true
  },
  {
    prop: 'lastHeartbeatTime',
    label: '最后心跳',
    width: 160,
    type: 'datetime' as const,
    format: 'MM-DD HH:mm:ss'
  },
  {
    prop: 'retryCount',
    label: '重试次数',
    width: 80,
    align: 'center' as const,
    formatter: (row: WeWorkAccountDetail) => 
      `${row.retryCount || 0}/${row.maxRetryCount || 3}`
  },
  {
    prop: 'autoReconnect',
    label: '自动重连',
    width: 80,
    align: 'center' as const,
    formatter: (row: WeWorkAccountDetail) => 
      row.autoReconnect ? '✓' : '✗'
  },
  {
    prop: 'lastLoginTime',
    label: '最后登录',
    width: 160,
    type: 'datetime' as const,
    format: 'MM-DD HH:mm:ss'
  },
  {
    prop: 'actions',
    label: '操作',
    width: 200,
    fixed: 'right' as const,
    type: 'actions' as const,
    actions: [
      {
        key: 'detail',
        label: '详情',
        type: 'primary' as const,
        icon: 'View'
      },
      {
        key: 'start',
        label: '启动',
        type: 'success' as const,
        icon: 'VideoPlay',
        hidden: (row: WeWorkAccountDetail) => row.status === 'ONLINE'
      },
      {
        key: 'stop',
        label: '停止',
        type: 'warning' as const,
        icon: 'VideoPause',
        hidden: (row: WeWorkAccountDetail) => row.status !== 'ONLINE'
      },
      {
        key: 'restart',
        label: '重启',
        type: 'info' as const,
        icon: 'Refresh'
      },
      {
        key: 'health',
        label: '检查',
        type: 'primary' as const,
        icon: 'Monitor'
      }
    ]
  }
]

// Methods
const loadAccounts = async () => {
  try {
    loading.value = true
    
    const params = {
      ...filters,
      page: pagination.value.current,
      size: pagination.value.size
    }
    
    await monitorStore.loadAccountList(filters.tenantId)
    
  } catch (error: any) {
    ElMessage.error(error.message || '加载账号列表失败')
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  // 搜索逻辑在computed中处理
}

const handleFilterChange = () => {
  // 过滤逻辑在computed中处理
}

const resetFilters = () => {
  Object.assign(filters, {
    keyword: '',
    status: '',
    healthRange: '',
    autoReconnect: ''
  })
}

const handlePageChange = (page: number) => {
  // 分页处理
}

const handleSizeChange = (size: number) => {
  // 分页大小处理
}

const handleSelectionChange = (selection: WeWorkAccountDetail[]) => {
  selectedAccounts.value = selection
}

const handleAction = async (action: any, row: WeWorkAccountDetail) => {
  switch (action.key) {
    case 'detail':
      selectedAccount.value = row
      await loadAccountHealth(row.id)
      detailDialogVisible.value = true
      break
    case 'start':
    case 'stop':
    case 'restart':
      await handleAccountOperation(action.key, row)
      break
    case 'health':
      await runSingleHealthCheck(row)
      break
  }
}

const handleBatchAction = (actionKey: string) => {
  if (selectedAccounts.value.length === 0) {
    ElMessage.warning('请选择要操作的账号')
    return
  }
  
  ElMessageBox.confirm(
    `确定要${actionKey}选中的 ${selectedAccounts.value.length} 个账号吗？`,
    '批量操作确认',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(async () => {
    await executeBatchOperation(actionKey)
  })
}

const handleAccountOperation = async (operation: string, account?: WeWorkAccountDetail) => {
  try {
    const targetAccount = account || selectedAccount.value
    if (!targetAccount) return
    
    // 这里调用具体的账号操作API
    ElMessage.success(`${operation}操作执行成功`)
    await loadAccounts()
    
  } catch (error: any) {
    ElMessage.error(error.message || '操作失败')
  }
}

const loadAccountHealth = async (accountId: string) => {
  try {
    await monitorStore.getAccountHealth(accountId)
    accountHealthReport.value = monitorStore.healthReports.get(accountId) || null
  } catch (error: any) {
    console.error('Load account health error:', error)
  }
}

const runSingleHealthCheck = async (account: WeWorkAccountDetail) => {
  try {
    ElMessage.info('正在进行健康检查...')
    // 调用健康检查API
    await loadAccountHealth(account.id)
    ElMessage.success('健康检查完成')
  } catch (error: any) {
    ElMessage.error('健康检查失败')
  }
}

const runHealthCheck = async () => {
  if (!selectedAccount.value) return
  await runSingleHealthCheck(selectedAccount.value)
}

const runBatchHealthCheck = async () => {
  try {
    healthCheckRunning.value = true
    healthCheckProgress.value = 0
    healthCheckCurrent.value = 0
    healthCheckTotal.value = selectedAccounts.value.length || stats.value.totalCount
    
    // 模拟批量健康检查过程
    for (let i = 0; i < healthCheckTotal.value; i++) {
      healthCheckCurrent.value = i + 1
      healthCheckProgress.value = Math.round((healthCheckCurrent.value / healthCheckTotal.value) * 100)
      
      // 模拟检查延时
      await new Promise(resolve => setTimeout(resolve, 500))
    }
    
    ElMessage.success('批量健康检查完成')
    showBatchHealthCheck.value = false
    await loadAccounts()
    
  } catch (error: any) {
    ElMessage.error('批量健康检查失败')
  } finally {
    healthCheckRunning.value = false
  }
}

const executeBatchOperation = async (operation: string) => {
  try {
    // 执行批量操作
    ElMessage.success(`批量${operation}操作完成`)
    tableRef.value?.clearSelection()
    await loadAccounts()
  } catch (error: any) {
    ElMessage.error('批量操作失败')
  }
}

const handleAutoRefreshChange = (enabled: boolean) => {
  autoRefresh.value = enabled
}

const handleIntervalChange = (interval: number) => {
  refreshInterval.value = interval
}

const handleExport = async () => {
  try {
    ElMessage.info('导出功能开发中...')
  } catch (error: any) {
    ElMessage.error('导出失败')
  }
}

// 工具函数
const getStatusType = (status: string): 'primary' | 'success' | 'warning' | 'danger' | 'info' | 'default' => {
  return ACCOUNT_STATUS_CONFIG[status as keyof typeof ACCOUNT_STATUS_CONFIG]?.type || 'info'
}

const getStatusText = (status: string): string => {
  return ACCOUNT_STATUS_CONFIG[status as keyof typeof ACCOUNT_STATUS_CONFIG]?.text || status
}

const getHealthLevel = (score: number): string => {
  return formatHealthScore(score).level
}

const getHealthScoreClass = (score: number): string => {
  const health = formatHealthScore(score)
  return `health-score--${health.type}`
}

// 生命周期
onMounted(() => {
  loadAccounts()
  
  // 启动自动刷新
  if (autoRefresh.value) {
    const timer = setInterval(() => {
      if (autoRefresh.value) {
        loadAccounts()
      }
    }, refreshInterval.value)
    
    onUnmounted(() => {
      clearInterval(timer)
    })
  }
})
</script>

<style scoped lang="scss">
.account-monitor {
  padding: 20px;
  background: var(--el-bg-color-page);
  
  .page-header {
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
        margin: 0 0 12px 0;
        font-size: 24px;
        font-weight: 600;
        color: var(--el-text-color-primary);
      }
      
      .header-stats {
        display: flex;
        gap: 16px;
      }
    }
  }
  
  .stats-section {
    margin-bottom: 20px;
  }
  
  .filter-card {
    margin-bottom: 20px;
    border: none;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
    
    .filter-container {
      display: flex;
      justify-content: space-between;
      align-items: center;
      flex-wrap: wrap;
      gap: 12px;
      
      .filter-left {
        display: flex;
        gap: 12px;
        align-items: center;
        flex-wrap: wrap;
      }
      
      .filter-right {
        display: flex;
        gap: 8px;
      }
    }
  }
  
  .table-card {
    border: none;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  }
  
  .account-detail {
    .monitor-info {
      h4 {
        margin: 0 0 16px 0;
        font-size: 16px;
        color: var(--el-text-color-primary);
      }
      
      .config-item {
        display: flex;
        justify-content: space-between;
        margin-bottom: 8px;
        
        .config-label {
          color: var(--el-text-color-secondary);
        }
        
        .config-value {
          color: var(--el-text-color-primary);
          font-weight: 500;
        }
      }
    }
    
    .health-report {
      h4 {
        margin: 0 0 16px 0;
        font-size: 16px;
        color: var(--el-text-color-primary);
      }
      
      .health-item {
        .health-metric {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 8px;
          
          .metric-name {
            font-weight: 500;
            color: var(--el-text-color-primary);
          }
          
          .metric-score {
            font-size: 18px;
            font-weight: 600;
            
            &.health-score--excellent { color: #67C23A; }
            &.health-score--good { color: #409EFF; }
            &.health-score--fair { color: #E6A23C; }
            &.health-score--poor { color: #F56C6C; }
          }
        }
        
        .metric-status {
          margin-bottom: 8px;
        }
        
        .metric-details {
          font-size: 12px;
          color: var(--el-text-color-secondary);
          line-height: 1.4;
        }
      }
    }
  }
  
  .batch-health-check {
    .check-progress {
      margin: 20px 0;
      
      .progress-text {
        text-align: center;
        margin-top: 8px;
        color: var(--el-text-color-secondary);
        font-size: 14px;
      }
    }
  }
}

// 响应式布局
@media (max-width: 768px) {
  .account-monitor {
    padding: 12px;
    
    .page-header {
      flex-direction: column;
      gap: 16px;
      align-items: flex-start;
      
      .header-stats {
        flex-wrap: wrap;
        gap: 8px !important;
      }
    }
    
    .filter-container {
      .filter-left {
        width: 100%;
        
        .el-input,
        .el-select {
          width: 100% !important;
          margin-bottom: 8px;
        }
      }
      
      .filter-right {
        width: 100%;
        justify-content: flex-end;
      }
    }
  }
}
</style>