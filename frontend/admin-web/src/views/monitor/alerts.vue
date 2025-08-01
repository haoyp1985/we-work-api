<template>
  <div class="alerts-page">
    <!-- 测试内容 - 确认组件正常加载 -->
    <div style="padding: 20px; background: #f0fdf4; border: 2px solid #22c55e; border-radius: 8px; margin-bottom: 20px;">
      <h2 style="color: #22c55e; margin: 0 0 10px 0;">✅ 告警管理页面加载成功！</h2>
      <p style="margin: 0; color: #15803d;">告警管理模块正常工作。</p>
    </div>

    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-left">
        <h2 class="page-title">
          <el-icon><Bell /></el-icon>
          告警管理
        </h2>
        <div class="header-stats">
          <el-tag :type="getAlertLevelColor('CRITICAL')" size="small">
            严重: {{ alertStore.alertCount.critical }}
          </el-tag>
          <el-tag :type="getAlertLevelColor('WARNING')" size="small">
            警告: {{ alertStore.alertCount.warning }}
          </el-tag>
          <el-tag :type="getAlertLevelColor('INFO')" size="small">
            信息: {{ alertStore.alertCount.info }}
          </el-tag>
          <el-tag type="success" size="small">
            活跃: {{ alertStore.alertCount.active }}
          </el-tag>
        </div>
      </div>
      
      <div class="header-right">
        <RefreshControl
          :refreshing="loading"
          :auto-refresh="autoRefresh"
          :refresh-interval="refreshInterval"
          show-auto-refresh
          show-status
          @refresh="loadAlerts"
          @auto-refresh-change="handleAutoRefreshChange"
          @interval-change="handleIntervalChange"
        />
      </div>
    </div>

    <!-- 过滤器 -->
    <el-card shadow="never" class="filter-card">
      <div class="filter-container">
        <div class="filter-left">
          <el-input
            v-model="filters.keyword"
            placeholder="搜索告警信息、账号名称"
            style="width: 250px;"
            clearable
            @input="handleSearch"
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>
          
          <el-select
            v-model="filters.level"
            placeholder="告警级别"
            clearable
            style="width: 120px;"
            @change="handleFilterChange"
          >
            <el-option
              v-for="level in alertLevels"
              :key="level.value"
              :label="level.label"
              :value="level.value"
            />
          </el-select>
          
          <el-select
            v-model="filters.status"
            placeholder="告警状态"
            clearable
            style="width: 120px;"
            @change="handleFilterChange"
          >
            <el-option
              v-for="status in alertStatuses"
              :key="status.value"
              :label="status.label"
              :value="status.value"
            />
          </el-select>
          
          <el-select
            v-model="filters.type"
            placeholder="告警类型"
            clearable
            style="width: 140px;"
            @change="handleFilterChange"
          >
            <el-option
              v-for="type in alertTypes"
              :key="type.value"
              :label="type.label"
              :value="type.value"
            />
          </el-select>
          
          <el-date-picker
            v-model="dateRange"
            type="datetimerange"
            range-separator="至"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
            format="MM-DD HH:mm"
            value-format="YYYY-MM-DD HH:mm:ss"
            style="width: 350px;"
            @change="handleDateRangeChange"
          />
        </div>
        
        <div class="filter-right">
          <el-button @click="resetFilters">
            <el-icon><RefreshRight /></el-icon>
            重置
          </el-button>
          <el-button type="primary" @click="handleExport">
            <el-icon><Download /></el-icon>
            导出
          </el-button>
        </div>
      </div>
    </el-card>

    <!-- 告警表格 -->
    <el-card shadow="never" class="table-card">
      <DataTable
        ref="tableRef"
        :data="alertStore.alertList"
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
        @refresh="loadAlerts"
      />
    </el-card>

    <!-- 告警详情弹窗 -->
    <el-dialog
      v-model="detailDialogVisible"
      title="告警详情"
      width="800px"
      :close-on-click-modal="false"
    >
      <div v-if="selectedAlert" class="alert-detail">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="告警类型">
            <StatusIndicator
              mode="tag"
              :type="getAlertLevelType(selectedAlert.alertLevel)"
              :text="getAlertTypeText(selectedAlert.alertType)"
              tag-effect="plain"
            />
          </el-descriptions-item>
          
          <el-descriptions-item label="告警级别">
            <StatusIndicator
              mode="tag"
              :type="getAlertLevelType(selectedAlert.alertLevel)"
              :text="getAlertLevelText(selectedAlert.alertLevel)"
            />
          </el-descriptions-item>
          
          <el-descriptions-item label="告警状态">
            <StatusIndicator
              mode="tag"
              :type="getAlertStatusType(selectedAlert.status)"
              :text="getAlertStatusText(selectedAlert.status)"
            />
          </el-descriptions-item>
          
          <el-descriptions-item label="关联账号">
            {{ selectedAlert.accountName }}
          </el-descriptions-item>
          
          <el-descriptions-item label="首次发生">
            {{ formatDateTime(selectedAlert.firstOccurredAt) }}
          </el-descriptions-item>
          
          <el-descriptions-item label="最后发生">
            {{ formatDateTime(selectedAlert.lastOccurredAt) }}
          </el-descriptions-item>
          
          <el-descriptions-item label="发生次数">
            {{ selectedAlert.occurrenceCount }} 次
          </el-descriptions-item>
          
          <el-descriptions-item label="自动恢复尝试">
            {{ selectedAlert.autoRecoveryAttempts }} 次
          </el-descriptions-item>
          
          <el-descriptions-item label="告警消息" :span="2">
            <div class="alert-message">{{ selectedAlert.alertMessage }}</div>
          </el-descriptions-item>
          
          <el-descriptions-item 
            v-if="selectedAlert.resolution" 
            label="解决方案" 
            :span="2"
          >
            <div class="resolution-content">{{ selectedAlert.resolution }}</div>
          </el-descriptions-item>
        </el-descriptions>
        
        <!-- 告警建议 -->
        <div v-if="getAlertSuggestions(selectedAlert.alertType)" class="alert-suggestions">
          <h4>建议操作</h4>
          <el-tag
            v-for="suggestion in getAlertSuggestions(selectedAlert.alertType)"
            :key="suggestion"
            type="info"
            effect="plain"
            size="small"
            style="margin: 2px 4px 2px 0;"
          >
            {{ suggestion }}
          </el-tag>
        </div>
        
        <!-- 告警数据 -->
        <div v-if="selectedAlert.alertData" class="alert-data">
          <h4>详细数据</h4>
          <el-input
            type="textarea"
            :model-value="formatAlertData(selectedAlert.alertData)"
            :rows="6"
            readonly
          />
        </div>
      </div>
      
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="detailDialogVisible = false">关闭</el-button>
          <el-button
            v-if="selectedAlert && selectedAlert.status === 'ACTIVE'"
            type="warning"
            @click="handleAlertOperation('acknowledge')"
          >
            确认告警
          </el-button>
          <el-button
            v-if="selectedAlert && ['ACTIVE', 'ACKNOWLEDGED'].includes(selectedAlert.status)"
            type="success"
            @click="handleAlertOperation('resolve')"
          >
            解决告警
          </el-button>
          <el-button
            v-if="selectedAlert && selectedAlert.status === 'ACTIVE'"
            type="info"
            @click="showSuppressDialog = true"
          >
            抑制告警
          </el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 抑制告警弹窗 -->
    <el-dialog
      v-model="showSuppressDialog"
      title="抑制告警"
      width="400px"
      :close-on-click-modal="false"
    >
      <el-form :model="suppressForm" label-width="80px">
        <el-form-item label="抑制时长">
          <el-select v-model="suppressForm.minutes" style="width: 100%;">
            <el-option label="15分钟" :value="15" />
            <el-option label="30分钟" :value="30" />
            <el-option label="1小时" :value="60" />
            <el-option label="2小时" :value="120" />
            <el-option label="6小时" :value="360" />
            <el-option label="12小时" :value="720" />
            <el-option label="24小时" :value="1440" />
          </el-select>
        </el-form-item>
        <el-form-item label="抑制原因">
          <el-input
            v-model="suppressForm.reason"
            type="textarea"
            :rows="3"
            placeholder="请输入抑制原因..."
          />
        </el-form-item>
      </el-form>
      
      <template #footer>
        <el-button @click="showSuppressDialog = false">取消</el-button>
        <el-button type="primary" @click="handleSuppressConfirm">确定</el-button>
      </template>
    </el-dialog>

    <!-- 批量操作确认弹窗 -->
    <el-dialog
      v-model="showBatchDialog"
      :title="batchDialogTitle"
      width="500px"
      :close-on-click-modal="false"
    >
      <div class="batch-confirm">
        <el-alert
          :title="`确定要${batchDialogTitle}以下 ${selectedAlerts.length} 个告警吗？`"
          type="warning"
          :closable="false"
          show-icon
        />
        
        <div class="selected-alerts">
          <div
            v-for="alert in selectedAlerts.slice(0, 5)"
            :key="alert.id"
            class="alert-item"
          >
            <StatusIndicator
              mode="simple"
              :type="getAlertLevelType(alert.alertLevel)"
              :text="getAlertTypeText(alert.alertType)"
            />
            <span class="alert-account">{{ alert.accountName }}</span>
          </div>
          <div v-if="selectedAlerts.length > 5" class="more-alerts">
            还有 {{ selectedAlerts.length - 5 }} 个告警...
          </div>
        </div>
        
        <el-form v-if="batchOperation === 'suppress'" :model="batchForm" label-width="80px">
          <el-form-item label="抑制时长">
            <el-select v-model="batchForm.minutes" style="width: 100%;">
              <el-option label="1小时" :value="60" />
              <el-option label="6小时" :value="360" />
              <el-option label="24小时" :value="1440" />
            </el-select>
          </el-form-item>
        </el-form>
        
        <el-form v-if="batchOperation === 'resolve'" :model="batchForm" label-width="80px">
          <el-form-item label="解决原因">
            <el-input
              v-model="batchForm.reason"
              type="textarea"
              :rows="2"
              placeholder="请输入解决原因..."
            />
          </el-form-item>
        </el-form>
      </div>
      
      <template #footer>
        <el-button @click="showBatchDialog = false">取消</el-button>
        <el-button type="primary" @click="confirmBatchOperation">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted, reactive } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  Bell,
  Search,
  RefreshRight,
  Download
} from '@element-plus/icons-vue'
import dayjs from 'dayjs'

// 组件导入
import { DataTable, StatusIndicator, RefreshControl } from '@/components/ui'
import { useAlertStore, useTenantStore } from '@/stores'
import { formatDateTime } from '@/utils/format'
import { 
  ALERT_LEVEL_CONFIG, 
  ALERT_TYPE_CONFIG, 
  ALERT_STATUS_CONFIG,
  BATCH_OPERATIONS 
} from '@/constants/monitor'
import type { AlertInfo, AlertLevel, AlertStatus, AlertType } from '@/types'

// Store
const alertStore = useAlertStore()
const tenantStore = useTenantStore()

// 响应式数据
const loading = ref(false)
const autoRefresh = ref(true)
const refreshInterval = ref(30000)
const tableRef = ref()

// 分页
const pagination = computed(() => alertStore.pagination)

// 过滤器
const filters = reactive({
  keyword: '',
  level: '',
  status: '',
  type: '',
  tenantId: computed(() => tenantStore.currentTenant?.id)
})

const dateRange = ref<[string, string] | null>(null)

// 选择状态
const selectedAlerts = ref<AlertInfo[]>([])

// 弹窗状态
const detailDialogVisible = ref(false)
const showSuppressDialog = ref(false)
const showBatchDialog = ref(false)
const selectedAlert = ref<AlertInfo | null>(null)

// 批量操作
const batchOperation = ref('')
const batchDialogTitle = ref('')

// 表单数据
const suppressForm = reactive({
  minutes: 60,
  reason: ''
})

const batchForm = reactive({
  minutes: 60,
  reason: ''
})

// 配置数据
const alertLevels = Object.entries(ALERT_LEVEL_CONFIG).map(([key, config]) => ({
  value: key,
  label: config.text
}))

const alertStatuses = Object.entries(ALERT_STATUS_CONFIG).map(([key, config]) => ({
  value: key,
  label: config.text
}))

const alertTypes = Object.entries(ALERT_TYPE_CONFIG).map(([key, config]) => ({
  value: key,
  label: config.text
}))

const batchActions = BATCH_OPERATIONS.alerts

// 表格列配置
const tableColumns = [
  {
    prop: 'alertType',
    label: '告警类型',
    width: 140,
    formatter: (row: AlertInfo) => getAlertTypeText(row.alertType)
  },
  {
    prop: 'alertLevel',
    label: '级别',
    width: 80,
    type: 'status',
    statusMap: Object.fromEntries(
      Object.entries(ALERT_LEVEL_CONFIG).map(([key, config]) => [
        key,
        { text: config.text, type: config.type }
      ])
    )
  },
  {
    prop: 'status',
    label: '状态',
    width: 80,
    type: 'status',
    statusMap: Object.fromEntries(
      Object.entries(ALERT_STATUS_CONFIG).map(([key, config]) => [
        key,
        { text: config.text, type: config.type }
      ])
    )
  },
  {
    prop: 'accountName',
    label: '关联账号',
    minWidth: 120
  },
  {
    prop: 'alertMessage',
    label: '告警信息',
    minWidth: 200,
    showOverflowTooltip: true
  },
  {
    prop: 'occurrenceCount',
    label: '次数',
    width: 60,
    align: 'center'
  },
  {
    prop: 'firstOccurredAt',
    label: '首次发生',
    width: 160,
    type: 'datetime',
    format: 'MM-DD HH:mm:ss'
  },
  {
    prop: 'lastOccurredAt',
    label: '最后发生',
    width: 160,
    type: 'datetime',
    format: 'MM-DD HH:mm:ss'
  },
  {
    prop: 'actions',
    label: '操作',
    width: 200,
    fixed: 'right',
    type: 'actions',
    actions: [
      {
        key: 'detail',
        label: '详情',
        type: 'primary',
        icon: 'View'
      },
      {
        key: 'acknowledge',
        label: '确认',
        type: 'warning',
        icon: 'Check',
        hidden: (row: AlertInfo) => row.status !== 'ACTIVE'
      },
      {
        key: 'resolve',
        label: '解决',
        type: 'success',
        icon: 'CircleCheck',
        hidden: (row: AlertInfo) => !['ACTIVE', 'ACKNOWLEDGED'].includes(row.status)
      },
      {
        key: 'suppress',
        label: '抑制',
        type: 'info',
        icon: 'Mute',
        hidden: (row: AlertInfo) => row.status !== 'ACTIVE'
      }
    ]
  }
]

// Methods
const loadAlerts = async () => {
  try {
    loading.value = true
    
    const params = {
      ...filters,
      page: pagination.value.current,
      size: pagination.value.size,
      startTime: dateRange.value?.[0],
      endTime: dateRange.value?.[1]
    }
    
    await alertStore.loadAlerts(params)
    
  } catch (error: any) {
    ElMessage.error(error.message || '加载告警列表失败')
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  // 搜索时重置到第一页
  alertStore.setQueryParams({ page: 1 })
  loadAlerts()
}

const handleFilterChange = () => {
  alertStore.setQueryParams({ page: 1 })
  loadAlerts()
}

const handleDateRangeChange = () => {
  alertStore.setQueryParams({ page: 1 })
  loadAlerts()
}

const resetFilters = () => {
  Object.assign(filters, {
    keyword: '',
    level: '',
    status: '',
    type: ''
  })
  dateRange.value = null
  alertStore.resetQueryParams()
  loadAlerts()
}

const handlePageChange = (page: number) => {
  alertStore.setQueryParams({ page })
  loadAlerts()
}

const handleSizeChange = (size: number) => {
  alertStore.setQueryParams({ page: 1, size })
  loadAlerts()
}

const handleSelectionChange = (selection: AlertInfo[]) => {
  selectedAlerts.value = selection
}

const handleAction = async (action: any, row: AlertInfo) => {
  switch (action.key) {
    case 'detail':
      selectedAlert.value = row
      detailDialogVisible.value = true
      break
    case 'acknowledge':
      await alertStore.acknowledgeAlert(row.id)
      loadAlerts()
      break
    case 'resolve':
      await alertStore.resolveAlert(row.id)
      loadAlerts()
      break
    case 'suppress':
      selectedAlert.value = row
      showSuppressDialog.value = true
      break
  }
}

const handleBatchAction = (actionKey: string) => {
  if (selectedAlerts.value.length === 0) {
    ElMessage.warning('请选择要操作的告警')
    return
  }
  
  batchOperation.value = actionKey
  
  const actionMap: Record<string, string> = {
    acknowledge: '批量确认',
    resolve: '批量解决',
    suppress: '批量抑制'
  }
  
  batchDialogTitle.value = actionMap[actionKey] || actionKey
  showBatchDialog.value = true
}

const handleAlertOperation = async (operation: string) => {
  if (!selectedAlert.value) return
  
  try {
    switch (operation) {
      case 'acknowledge':
        await alertStore.acknowledgeAlert(selectedAlert.value.id)
        break
      case 'resolve':
        await alertStore.resolveAlert(selectedAlert.value.id, suppressForm.reason)
        break
    }
    
    detailDialogVisible.value = false
    loadAlerts()
    
  } catch (error: any) {
    ElMessage.error(error.message || '操作失败')
  }
}

const handleSuppressConfirm = async () => {
  if (!selectedAlert.value) return
  
  try {
    await alertStore.suppressAlert(selectedAlert.value.id, suppressForm.minutes)
    showSuppressDialog.value = false
    detailDialogVisible.value = false
    loadAlerts()
    
    // 重置表单
    suppressForm.reason = ''
    suppressForm.minutes = 60
    
  } catch (error: any) {
    ElMessage.error(error.message || '抑制告警失败')
  }
}

const confirmBatchOperation = async () => {
  try {
    const alertIds = selectedAlerts.value.map(alert => alert.id)
    
    await alertStore.batchOperateAlerts(
      batchOperation.value as any,
      alertIds,
      batchForm.reason,
      batchForm.minutes
    )
    
    showBatchDialog.value = false
    tableRef.value?.clearSelection()
    loadAlerts()
    
    // 重置表单
    batchForm.reason = ''
    batchForm.minutes = 60
    
  } catch (error: any) {
    ElMessage.error(error.message || '批量操作失败')
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
const getAlertLevelColor = (level: string): string => {
  return ALERT_LEVEL_CONFIG[level as AlertLevel]?.type || 'info'
}

const getAlertLevelType = (level: string): string => {
  return ALERT_LEVEL_CONFIG[level as AlertLevel]?.type || 'info'
}

const getAlertLevelText = (level: string): string => {
  return ALERT_LEVEL_CONFIG[level as AlertLevel]?.text || level
}

const getAlertStatusType = (status: string): string => {
  return ALERT_STATUS_CONFIG[status as AlertStatus]?.type || 'info'
}

const getAlertStatusText = (status: string): string => {
  return ALERT_STATUS_CONFIG[status as AlertStatus]?.text || status
}

const getAlertTypeText = (type: string): string => {
  return ALERT_TYPE_CONFIG[type as AlertType]?.text || type
}

const getAlertSuggestions = (type: string): string[] => {
  return ALERT_TYPE_CONFIG[type as AlertType]?.suggestedActions || []
}

const formatAlertData = (data: any): string => {
  if (typeof data === 'string') return data
  return JSON.stringify(data, null, 2)
}

// 生命周期
onMounted(() => {
  loadAlerts()
  
  // 启动自动刷新
  if (autoRefresh.value) {
    const timer = setInterval(() => {
      if (autoRefresh.value) {
        loadAlerts()
      }
    }, refreshInterval.value)
    
    onUnmounted(() => {
      clearInterval(timer)
    })
  }
})
</script>

<style scoped lang="scss">
.alerts-page {
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
        gap: 8px;
      }
    }
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
  
  .alert-detail {
    .alert-message {
      padding: 8px;
      background: var(--el-bg-color-page);
      border-radius: 4px;
      font-size: 14px;
      line-height: 1.5;
    }
    
    .resolution-content {
      padding: 8px;
      background: rgba(103, 194, 58, 0.1);
      border-radius: 4px;
      color: var(--el-color-success);
      font-size: 14px;
    }
    
    .alert-suggestions {
      margin-top: 20px;
      
      h4 {
        margin: 0 0 12px 0;
        font-size: 16px;
        color: var(--el-text-color-primary);
      }
    }
    
    .alert-data {
      margin-top: 20px;
      
      h4 {
        margin: 0 0 12px 0;
        font-size: 16px;
        color: var(--el-text-color-primary);
      }
    }
  }
  
  .batch-confirm {
    .selected-alerts {
      margin: 16px 0;
      max-height: 200px;
      overflow-y: auto;
      
      .alert-item {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 8px;
        border-bottom: 1px solid var(--el-border-color-lighter);
        
        &:last-child {
          border-bottom: none;
        }
        
        .alert-account {
          color: var(--el-text-color-regular);
          font-size: 14px;
        }
      }
      
      .more-alerts {
        text-align: center;
        color: var(--el-text-color-secondary);
        font-size: 12px;
        padding: 8px;
      }
    }
  }
}

// 响应式布局
@media (max-width: 768px) {
  .alerts-page {
    padding: 12px;
    
    .page-header {
      flex-direction: column;
      gap: 16px;
      align-items: flex-start;
    }
    
    .filter-container {
      .filter-left {
        width: 100%;
        
        .el-input,
        .el-select,
        .el-date-picker {
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