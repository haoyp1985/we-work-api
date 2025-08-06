<template>
  <div class="alert-center">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-title">
        <h1>告警中心</h1>
        <p>实时监控系统告警、管理告警规则和通知渠道</p>
      </div>
      <div class="header-actions">
        <el-button 
          type="primary" 
          :icon="Plus"
          @click="handleCreateRule"
        >
          创建告警规则
        </el-button>
        <el-button 
          :icon="Setting"
          @click="handleManageChannels"
        >
          通知渠道
        </el-button>
        <el-button 
          :icon="Download"
          @click="handleExportAlerts"
        >
          导出告警
        </el-button>
      </div>
    </div>

    <!-- 告警统计概览 -->
    <el-row :gutter="20" class="stats-row">
      <el-col :span="6">
        <el-card class="stat-card critical">
          <div class="stat-content">
            <div class="stat-icon">
              <el-icon><Warning /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ alertStats.active }}</div>
              <div class="stat-label">活跃告警</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon">
              <el-icon><CircleCheck /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ alertStats.resolved }}</div>
              <div class="stat-label">已解决</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon">
              <el-icon><Clock /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ alertStats.mttr }}分钟</div>
              <div class="stat-label">平均修复时间</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon">
              <el-icon><Document /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ alertStats.total }}</div>
              <div class="stat-label">总告警数</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 告警级别分布 -->
    <el-card class="chart-card" shadow="never">
      <template #header>
        <div class="card-header">
          <span>告警级别分布</span>
          <el-radio-group v-model="chartTimeRange" size="small">
            <el-radio-button label="7d">最近7天</el-radio-button>
            <el-radio-button label="30d">最近30天</el-radio-button>
            <el-radio-button label="90d">最近90天</el-radio-button>
          </el-radio-group>
        </div>
      </template>
      
      <div class="level-distribution">
        <div class="level-item critical">
          <div class="level-count">{{ alertStats.byLevel.CRITICAL || 0 }}</div>
          <div class="level-label">严重</div>
        </div>
        <div class="level-item error">
          <div class="level-count">{{ alertStats.byLevel.ERROR || 0 }}</div>
          <div class="level-label">错误</div>
        </div>
        <div class="level-item warning">
          <div class="level-count">{{ alertStats.byLevel.WARNING || 0 }}</div>
          <div class="level-label">警告</div>
        </div>
        <div class="level-item info">
          <div class="level-count">{{ alertStats.byLevel.INFO || 0 }}</div>
          <div class="level-label">信息</div>
        </div>
      </div>
    </el-card>

    <!-- 告警列表 -->
    <el-card class="table-card" shadow="never">
      <template #header>
        <div class="table-header">
          <div class="header-title">
            <span>告警列表</span>
            <el-tag type="info" size="small">共 {{ pagination.total }} 条</el-tag>
          </div>
          <div class="header-filters">
            <el-select 
              v-model="searchForm.level" 
              placeholder="告警级别" 
              clearable
              style="width: 120px; margin-right: 12px"
            >
              <el-option label="严重" value="CRITICAL" />
              <el-option label="错误" value="ERROR" />
              <el-option label="警告" value="WARNING" />
              <el-option label="信息" value="INFO" />
            </el-select>
            <el-select 
              v-model="searchForm.status" 
              placeholder="告警状态" 
              clearable
              style="width: 120px; margin-right: 12px"
            >
              <el-option label="活跃" value="ACTIVE" />
              <el-option label="已确认" value="ACKNOWLEDGED" />
              <el-option label="已解决" value="RESOLVED" />
              <el-option label="已抑制" value="SUPPRESSED" />
            </el-select>
            <el-input
              v-model="searchForm.keyword"
              placeholder="搜索告警标题"
              :prefix-icon="Search"
              clearable
              style="width: 200px; margin-right: 12px"
              @keyup.enter="handleSearch"
            />
            <el-button type="primary" :icon="Search" @click="handleSearch">
              搜索
            </el-button>
          </div>
        </div>
      </template>

      <!-- 批量操作栏 -->
      <div v-if="selectedAlerts.length > 0" class="batch-actions">
        <span class="selection-info">已选择 {{ selectedAlerts.length }} 项</span>
        <div class="actions">
          <el-button size="small" @click="handleBatchAcknowledge">
            批量确认
          </el-button>
          <el-button size="small" @click="handleBatchResolve">
            批量解决
          </el-button>
          <el-button size="small" @click="handleBatchAssign">
            批量分配
          </el-button>
        </div>
      </div>

      <el-table 
        :data="alertList" 
        :loading="loading"
        @selection-change="handleSelectionChange"
        style="width: 100%"
      >
        <el-table-column type="selection" width="50" />
        
        <el-table-column label="告警信息" min-width="300">
          <template #default="{ row }">
            <div class="alert-info">
              <div class="alert-title">
                <el-tag 
                  :type="getAlertLevelType(row.level)" 
                  size="small"
                  style="margin-right: 8px"
                >
                  {{ getAlertLevelText(row.level) }}
                </el-tag>
                <span class="title">{{ row.title }}</span>
              </div>
              <div class="alert-message">{{ row.message }}</div>
              <div class="alert-meta">
                <span class="meta-item">
                  <el-icon><DataBoard /></el-icon>
                  {{ row.source }}
                </span>
                <span class="meta-item">
                  <el-icon><Timer /></el-icon>
                  {{ formatTime(row.metadata.triggeredAt) }}
                </span>
              </div>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column label="状态" width="100" align="center">
          <template #default="{ row }">
            <el-tag 
              :type="getAlertStatusType(row.status)" 
              size="small"
            >
              {{ getAlertStatusText(row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        
        <el-table-column label="阈值" width="120" align="center">
          <template #default="{ row }">
            <div class="threshold-info">
              <div class="current-value">{{ row.value }}</div>
              <div class="threshold-value">阈值: {{ row.threshold }}</div>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column label="分配人" width="120">
          <template #default="{ row }">
            <div v-if="row.assignee" class="assignee-info">
              <div class="assignee-name">{{ row.assignee.userName }}</div>
              <div class="assign-time">{{ formatTime(row.assignee.assignedAt) }}</div>
            </div>
            <span v-else class="no-assignee">未分配</span>
          </template>
        </el-table-column>
        
        <el-table-column label="持续时间" width="120" align="center">
          <template #default="{ row }">
            {{ getDuration(row.metadata.triggeredAt, row.metadata.resolvedAt) }}
          </template>
        </el-table-column>
        
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <div class="action-buttons">
              <el-button 
                type="primary" 
                size="small" 
                link
                @click="handleViewAlert(row)"
              >
                详情
              </el-button>
              <el-dropdown @command="(command) => handleAlertAction(command, row)">
                <el-button size="small" link>
                  更多 <el-icon><ArrowDown /></el-icon>
                </el-button>
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item 
                      v-if="row.status === 'ACTIVE'"
                      command="acknowledge" 
                      :icon="Check"
                    >
                      确认
                    </el-dropdown-item>
                    <el-dropdown-item 
                      v-if="row.status !== 'RESOLVED'"
                      command="resolve" 
                      :icon="CircleCheck"
                    >
                      解决
                    </el-dropdown-item>
                    <el-dropdown-item 
                      v-if="row.status === 'ACTIVE'"
                      command="suppress" 
                      :icon="Mute"
                    >
                      抑制
                    </el-dropdown-item>
                    <el-dropdown-item command="assign" :icon="User">
                      分配
                    </el-dropdown-item>
                    <el-dropdown-item command="resend" :icon="Promotion">
                      重新通知
                    </el-dropdown-item>
                  </el-dropdown-menu>
                </template>
              </el-dropdown>
            </div>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination-wrapper">
        <el-pagination
          v-model:current-page="pagination.current"
          v-model:page-size="pagination.size"
          :total="pagination.total"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handlePageChange"
        />
      </div>
    </el-card>

    <!-- 告警详情对话框 -->
    <AlertDetail
      v-model="alertDetailVisible"
      :alert-id="currentAlertId"
    />

    <!-- 告警规则管理对话框 -->
    <AlertRuleManager
      v-model="ruleManagerVisible"
      @success="handleRuleSuccess"
    />

    <!-- 通知渠道管理对话框 -->
    <NotificationChannelManager
      v-model="channelManagerVisible"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { 
  Plus,
  Setting,
  Download,
  Warning,
  CircleCheck,
  Clock,
  Document,
  Search,
  ArrowDown,
  Check,
  Mute,
  User,
  Promotion,
  DataBoard,
  Timer
} from '@element-plus/icons-vue'
import * as alertsApi from '@/api/alerts'
import type { Alert, AlertLevel, AlertStatus, AlertStats } from '@/api/alerts'
import AlertDetail from './components/AlertDetail.vue'
import AlertRuleManager from './components/AlertRuleManager.vue'
import NotificationChannelManager from './components/NotificationChannelManager.vue'

// 响应式数据
const loading = ref(false)
const alertList = ref<Alert[]>([])
const selectedAlerts = ref<Alert[]>([])
const alertStats = ref<AlertStats>({
  total: 0,
  active: 0,
  resolved: 0,
  acknowledged: 0,
  suppressed: 0,
  byLevel: {} as Record<AlertLevel, number>,
  bySource: [],
  trends: [],
  mttr: 0,
  mtbd: 0
})

// 搜索表单
const searchForm = reactive({
  keyword: '',
  level: '' as AlertLevel | '',
  status: '' as AlertStatus | '',
  source: ''
})

// 分页信息
const pagination = reactive({
  current: 1,
  size: 20,
  total: 0
})

// 图表时间范围
const chartTimeRange = ref('30d')

// 对话框状态
const alertDetailVisible = ref(false)
const ruleManagerVisible = ref(false)
const channelManagerVisible = ref(false)
const currentAlertId = ref('')

// 工具函数
const getAlertLevelType = (level: AlertLevel): string => {
  const typeMap = {
    'CRITICAL': 'danger',
    'ERROR': 'danger',
    'WARNING': 'warning',
    'INFO': 'info'
  }
  return typeMap[level] || 'info'
}

const getAlertLevelText = (level: AlertLevel): string => {
  const textMap = {
    'CRITICAL': '严重',
    'ERROR': '错误',
    'WARNING': '警告',
    'INFO': '信息'
  }
  return textMap[level] || level
}

const getAlertStatusType = (status: AlertStatus): string => {
  const typeMap = {
    'ACTIVE': 'danger',
    'ACKNOWLEDGED': 'warning',
    'RESOLVED': 'success',
    'SUPPRESSED': 'info'
  }
  return typeMap[status] || 'info'
}

const getAlertStatusText = (status: AlertStatus): string => {
  const textMap = {
    'ACTIVE': '活跃',
    'ACKNOWLEDGED': '已确认',
    'RESOLVED': '已解决',
    'SUPPRESSED': '已抑制'
  }
  return textMap[status] || status
}

const formatTime = (timeStr: string): string => {
  if (!timeStr) return '-'
  
  const time = new Date(timeStr)
  const now = new Date()
  const diff = now.getTime() - time.getTime()
  
  const minute = 60 * 1000
  const hour = 60 * minute
  const day = 24 * hour
  
  if (diff < minute) {
    return '刚刚'
  } else if (diff < hour) {
    return `${Math.floor(diff / minute)}分钟前`
  } else if (diff < day) {
    return `${Math.floor(diff / hour)}小时前`
  } else {
    return time.toLocaleDateString()
  }
}

const getDuration = (startTime: string, endTime?: string): string => {
  if (!startTime) return '-'
  
  const start = new Date(startTime)
  const end = endTime ? new Date(endTime) : new Date()
  const diff = end.getTime() - start.getTime()
  
  const hours = Math.floor(diff / (1000 * 60 * 60))
  const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60))
  
  if (hours > 0) {
    return `${hours}小时${minutes}分钟`
  } else {
    return `${minutes}分钟`
  }
}

// API调用函数
const loadAlertStats = async () => {
  try {
    const response = await alertsApi.getAlertStatistics()
    alertStats.value = response.data
  } catch (error) {
    console.error('加载告警统计失败:', error)
  }
}

const loadAlerts = async () => {
  loading.value = true
  try {
    const params = {
      current: pagination.current,
      size: pagination.size,
      keyword: searchForm.keyword || undefined,
      level: searchForm.level || undefined,
      status: searchForm.status || undefined,
      source: searchForm.source || undefined
    }
    
    const response = await alertsApi.getAlerts(params)
    alertList.value = response.data.records
    pagination.total = response.data.total
  } catch (error) {
    console.error('加载告警列表失败:', error)
    ElMessage.error('加载告警列表失败')
  } finally {
    loading.value = false
  }
}

// 事件处理函数
const handleSearch = () => {
  pagination.current = 1
  loadAlerts()
}

const handlePageChange = () => {
  loadAlerts()
}

const handleSizeChange = () => {
  pagination.current = 1
  loadAlerts()
}

const handleSelectionChange = (selection: Alert[]) => {
  selectedAlerts.value = selection
}

const handleCreateRule = () => {
  ruleManagerVisible.value = true
}

const handleManageChannels = () => {
  channelManagerVisible.value = true
}

const handleExportAlerts = () => {
  ElMessage.info('导出告警功能开发中...')
}

const handleViewAlert = (alert: Alert) => {
  currentAlertId.value = alert.id
  alertDetailVisible.value = true
}

const handleAlertAction = async (command: string, alert: Alert) => {
  try {
    switch (command) {
      case 'acknowledge':
        await alertsApi.acknowledgeAlert(alert.id)
        await loadAlerts()
        break
        
      case 'resolve':
        await alertsApi.resolveAlert(alert.id)
        await loadAlerts()
        break
        
      case 'suppress':
        await ElMessageBox.prompt(
          '请输入抑制时长（小时）',
          '抑制告警',
          { inputPattern: /^\d+$/, inputErrorMessage: '请输入有效的数字' }
        ).then(async ({ value }) => {
          await alertsApi.suppressAlert(alert.id, parseInt(value) * 60)
          await loadAlerts()
        })
        break
        
      case 'assign':
        ElMessage.info('分配告警功能开发中...')
        break
        
      case 'resend':
        await alertsApi.resendNotification(alert.id)
        break
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('告警操作失败:', error)
      ElMessage.error('操作失败')
    }
  }
}

const handleBatchAcknowledge = async () => {
  try {
    const alertIds = selectedAlerts.value.map(alert => alert.id)
    await alertsApi.batchAcknowledgeAlerts(alertIds)
    await loadAlerts()
    selectedAlerts.value = []
  } catch (error) {
    console.error('批量确认失败:', error)
    ElMessage.error('批量确认失败')
  }
}

const handleBatchResolve = async () => {
  try {
    const alertIds = selectedAlerts.value.map(alert => alert.id)
    await alertsApi.batchResolveAlerts(alertIds)
    await loadAlerts()
    selectedAlerts.value = []
  } catch (error) {
    console.error('批量解决失败:', error)
    ElMessage.error('批量解决失败')
  }
}

const handleBatchAssign = () => {
  ElMessage.info('批量分配功能开发中...')
}

const handleRuleSuccess = () => {
  ruleManagerVisible.value = false
  loadAlertStats()
}

// 初始化
onMounted(() => {
  loadAlertStats()
  loadAlerts()
})
</script>

<style scoped lang="scss">
.alert-center {
  padding: 20px;

  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;

    .header-title {
      h1 {
        margin: 0 0 8px 0;
        color: #1f2329;
        font-size: 24px;
        font-weight: 600;
      }

      p {
        margin: 0;
        color: #86909c;
        font-size: 14px;
      }
    }

    .header-actions {
      display: flex;
      gap: 12px;
    }
  }

  .stats-row {
    margin-bottom: 20px;

    .stat-card {
      border-radius: 8px;

      &.critical {
        background: linear-gradient(135deg, #ff7875 0%, #ff4d4f 100%);
        color: white;

        .stat-icon {
          background: rgba(255, 255, 255, 0.2);
        }
      }

      .stat-content {
        display: flex;
        align-items: center;
        gap: 16px;
        padding: 20px;

        .stat-icon {
          width: 48px;
          height: 48px;
          border-radius: 8px;
          background: rgba(64, 158, 255, 0.1);
          color: #409eff;
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 24px;
        }

        .stat-info {
          .stat-value {
            font-size: 24px;
            font-weight: 600;
            color: #1f2329;
            margin-bottom: 4px;

            .critical & {
              color: white;
            }
          }

          .stat-label {
            font-size: 12px;
            color: #86909c;

            .critical & {
              color: rgba(255, 255, 255, 0.8);
            }
          }
        }
      }
    }
  }

  .chart-card {
    margin-bottom: 20px;
    border-radius: 8px;

    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-weight: 600;
      color: #1f2329;
    }

    .level-distribution {
      display: flex;
      justify-content: space-around;
      padding: 20px;

      .level-item {
        text-align: center;
        padding: 20px;
        border-radius: 8px;
        min-width: 120px;

        &.critical {
          background: linear-gradient(135deg, #ff7875 0%, #ff4d4f 100%);
          color: white;
        }

        &.error {
          background: linear-gradient(135deg, #ff9c6e 0%, #ff7a45 100%);
          color: white;
        }

        &.warning {
          background: linear-gradient(135deg, #ffd666 0%, #faad14 100%);
          color: white;
        }

        &.info {
          background: linear-gradient(135deg, #91d5ff 0%, #1890ff 100%);
          color: white;
        }

        .level-count {
          font-size: 28px;
          font-weight: 600;
          margin-bottom: 8px;
        }

        .level-label {
          font-size: 14px;
          opacity: 0.9;
        }
      }
    }
  }

  .table-card {
    border-radius: 8px;

    .table-header {
      display: flex;
      justify-content: space-between;
      align-items: center;

      .header-title {
        display: flex;
        align-items: center;
        gap: 12px;
        font-weight: 600;
        color: #1f2329;
      }

      .header-filters {
        display: flex;
        align-items: center;
      }
    }

    .batch-actions {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 12px 20px;
      background: #f0f9f0;
      border-bottom: 1px solid #e5e5e5;

      .selection-info {
        color: #67c23a;
        font-weight: 500;
      }

      .actions {
        display: flex;
        gap: 8px;
      }
    }

    .alert-info {
      .alert-title {
        display: flex;
        align-items: center;
        margin-bottom: 4px;

        .title {
          font-weight: 500;
          color: #1f2329;
        }
      }

      .alert-message {
        color: #86909c;
        font-size: 12px;
        margin-bottom: 8px;
        line-height: 1.4;
      }

      .alert-meta {
        display: flex;
        gap: 16px;

        .meta-item {
          display: flex;
          align-items: center;
          gap: 4px;
          color: #86909c;
          font-size: 11px;

          .el-icon {
            font-size: 11px;
          }
        }
      }
    }

    .threshold-info {
      text-align: center;

      .current-value {
        font-weight: 600;
        color: #1f2329;
        font-size: 16px;
      }

      .threshold-value {
        font-size: 11px;
        color: #86909c;
        margin-top: 2px;
      }
    }

    .assignee-info {
      .assignee-name {
        color: #1f2329;
        font-weight: 500;
        margin-bottom: 2px;
      }

      .assign-time {
        font-size: 11px;
        color: #86909c;
      }
    }

    .no-assignee {
      color: #c0c4cc;
      font-size: 12px;
    }

    .action-buttons {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .pagination-wrapper {
      display: flex;
      justify-content: center;
      margin-top: 20px;
    }
  }
}
</style>