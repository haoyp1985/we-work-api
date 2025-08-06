<template>
  <div class="monitoring-dashboard">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-title">
        <h1>系统监控中心</h1>
        <p>实时监控系统性能、服务状态和告警信息</p>
      </div>
      <div class="header-actions">
        <el-button 
          :icon="Refresh"
          @click="handleRefresh"
          :loading="refreshing"
        >
          刷新
        </el-button>
        <el-button 
          type="primary"
          :icon="Setting"
          @click="handleSettings"
        >
          监控设置
        </el-button>
      </div>
    </div>

    <!-- 系统状态总览 -->
    <div class="status-overview">
      <el-row :gutter="20">
        <el-col :span="6">
          <el-card class="status-card" :class="getOverallStatusClass()">
            <div class="status-content">
              <div class="status-icon">
                <el-icon :size="32">
                  <component :is="getOverallStatusIcon()" />
                </el-icon>
              </div>
              <div class="status-info">
                <div class="status-title">系统状态</div>
                <div class="status-value">{{ getOverallStatusText() }}</div>
              </div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="status-card">
            <div class="status-content">
              <div class="status-icon services">
                <el-icon :size="32"><Monitor /></el-icon>
              </div>
              <div class="status-info">
                <div class="status-title">在线服务</div>
                <div class="status-value">
                  {{ overview.services.healthy }}/{{ overview.services.total }}
                </div>
              </div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="status-card">
            <div class="status-content">
              <div class="status-icon alerts">
                <el-icon :size="32"><Warning /></el-icon>
              </div>
              <div class="status-info">
                <div class="status-title">活跃告警</div>
                <div class="status-value">{{ overview.alerts.active }}</div>
              </div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="status-card">
            <div class="status-content">
              <div class="status-icon errors">
                <el-icon :size="32"><Close /></el-icon>
              </div>
              <div class="status-info">
                <div class="status-title">错误率</div>
                <div class="status-value">{{ (overview.errors.rate * 100).toFixed(2) }}%</div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- 资源使用监控 -->
    <el-row :gutter="20" class="charts-row">
      <el-col :span="12">
        <el-card class="chart-card" shadow="never">
          <template #header>
            <div class="card-header">
              <span>系统资源使用</span>
              <el-radio-group v-model="resourceTimeRange" size="small">
                <el-radio-button label="1h">1小时</el-radio-button>
                <el-radio-button label="6h">6小时</el-radio-button>
                <el-radio-button label="24h">24小时</el-radio-button>
              </el-radio-group>
            </div>
          </template>
          
          <div class="resource-metrics">
            <div class="metric-item">
              <div class="metric-header">
                <span class="metric-name">CPU使用率</span>
                <span class="metric-value" :class="{ warning: resourceUsage.cpu > 70, critical: resourceUsage.cpu > 90 }">
                  {{ resourceUsage.cpu.toFixed(1) }}%
                </span>
              </div>
              <el-progress 
                :percentage="resourceUsage.cpu" 
                :status="resourceUsage.cpu > 90 ? 'exception' : resourceUsage.cpu > 70 ? 'warning' : 'success'"
                :show-text="false"
              />
            </div>
            
            <div class="metric-item">
              <div class="metric-header">
                <span class="metric-name">内存使用率</span>
                <span class="metric-value" :class="{ warning: resourceUsage.memory > 70, critical: resourceUsage.memory > 90 }">
                  {{ resourceUsage.memory.toFixed(1) }}%
                </span>
              </div>
              <el-progress 
                :percentage="resourceUsage.memory" 
                :status="resourceUsage.memory > 90 ? 'exception' : resourceUsage.memory > 70 ? 'warning' : 'success'"
                :show-text="false"
              />
            </div>
            
            <div class="metric-item">
              <div class="metric-header">
                <span class="metric-name">磁盘使用率</span>
                <span class="metric-value" :class="{ warning: resourceUsage.storage > 70, critical: resourceUsage.storage > 90 }">
                  {{ resourceUsage.storage.toFixed(1) }}%
                </span>
              </div>
              <el-progress 
                :percentage="resourceUsage.storage" 
                :status="resourceUsage.storage > 90 ? 'exception' : resourceUsage.storage > 70 ? 'warning' : 'success'"
                :show-text="false"
              />
            </div>
            
            <div class="metric-item">
              <div class="metric-header">
                <span class="metric-name">网络IO</span>
                <span class="metric-value">{{ formatBytes(resourceUsage.network) }}/s</span>
              </div>
              <el-progress 
                :percentage="Math.min(resourceUsage.network / 1000000 * 100, 100)" 
                :show-text="false"
              />
            </div>
          </div>
          
          <BaseChart
            :options="resourceChartOptions"
            height="200px"
            :loading="resourceLoading"
            @retry="loadResourceUsage"
          />
        </el-card>
      </el-col>

      <el-col :span="12">
        <el-card class="chart-card" shadow="never">
          <template #header>
            <div class="card-header">
              <span>服务性能监控</span>
              <el-select v-model="selectedService" size="small" style="width: 120px">
                <el-option label="全部服务" value="" />
                <el-option 
                  v-for="service in serviceList" 
                  :key="service" 
                  :label="service" 
                  :value="service" 
                />
              </el-select>
            </div>
          </template>
          
          <BaseChart
            :options="performanceChartOptions"
            height="300px"
            :loading="performanceLoading"
            @retry="loadPerformanceMetrics"
          />
        </el-card>
      </el-col>
    </el-row>

    <!-- 服务状态和告警 -->
    <el-row :gutter="20" class="tables-row">
      <el-col :span="12">
        <el-card class="table-card" shadow="never">
          <template #header>
            <div class="card-header">
              <span>服务状态</span>
              <el-button 
                size="small" 
                :icon="Refresh"
                @click="loadServicesStatus"
                :loading="servicesLoading"
              >
                刷新
              </el-button>
            </div>
          </template>
          
          <el-table 
            :data="servicesStatus" 
            style="width: 100%"
            :loading="servicesLoading"
          >
            <el-table-column label="服务名称" prop="name" min-width="120" />
            <el-table-column label="状态" width="100" align="center">
              <template #default="{ row }">
                <el-tag 
                  :type="getServiceStatusType(row.status)" 
                  size="small"
                >
                  {{ getServiceStatusText(row.status) }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="响应时间" width="100" align="center">
              <template #default="{ row }">
                {{ row.responseTime }}ms
              </template>
            </el-table-column>
            <el-table-column label="运行时间" width="120" align="center">
              <template #default="{ row }">
                {{ formatUptime(row.uptime) }}
              </template>
            </el-table-column>
            <el-table-column label="操作" width="150" align="center">
              <template #default="{ row }">
                <el-dropdown @command="(command) => handleServiceAction(command, row)">
                  <el-button size="small" :icon="Setting" />
                  <template #dropdown>
                    <el-dropdown-menu>
                      <el-dropdown-item command="restart" :icon="Refresh">
                        重启
                      </el-dropdown-item>
                      <el-dropdown-item 
                        :command="row.status === 'HEALTHY' ? 'stop' : 'start'" 
                        :icon="row.status === 'HEALTHY' ? Close : Check"
                      >
                        {{ row.status === 'HEALTHY' ? '停止' : '启动' }}
                      </el-dropdown-item>
                      <el-dropdown-item command="logs" :icon="Document">
                        查看日志
                      </el-dropdown-item>
                    </el-dropdown-menu>
                  </template>
                </el-dropdown>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>

      <el-col :span="12">
        <el-card class="table-card" shadow="never">
          <template #header>
            <div class="card-header">
              <span>最近告警</span>
              <el-button 
                size="small"
                type="primary"
                @click="viewAllAlerts"
              >
                查看全部
              </el-button>
            </div>
          </template>
          
          <el-table 
            :data="recentAlerts" 
            style="width: 100%"
            :loading="alertsLoading"
          >
            <el-table-column label="告警信息" min-width="180">
              <template #default="{ row }">
                <div class="alert-info">
                  <div class="alert-title">{{ row.title }}</div>
                  <div class="alert-service">{{ row.service }}</div>
                </div>
              </template>
            </el-table-column>
            <el-table-column label="严重程度" width="100" align="center">
              <template #default="{ row }">
                <el-tag 
                  :type="getSeverityTagType(row.severity)" 
                  size="small"
                >
                  {{ getSeverityText(row.severity) }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="状态" width="80" align="center">
              <template #default="{ row }">
                <el-tag 
                  :type="getAlertStatusType(row.status)" 
                  size="small"
                >
                  {{ getAlertStatusText(row.status) }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="时间" width="120" align="center">
              <template #default="{ row }">
                {{ formatTime(row.createdAt) }}
              </template>
            </el-table-column>
            <el-table-column label="操作" width="100" align="center">
              <template #default="{ row }">
                <el-button 
                  size="small" 
                  type="primary" 
                  link
                  @click="viewAlertDetail(row.id)"
                >
                  查看
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>

    <!-- 错误统计 -->
    <el-row :gutter="20" class="charts-row">
      <el-col :span="24">
        <el-card class="chart-card" shadow="never">
          <template #header>
            <div class="card-header">
              <span>错误统计趋势</span>
              <div>
                <el-select v-model="errorTimeRange" size="small" style="width: 120px; margin-right: 12px">
                  <el-option label="最近1小时" value="1h" />
                  <el-option label="最近6小时" value="6h" />
                  <el-option label="最近24小时" value="24h" />
                  <el-option label="最近7天" value="7d" />
                </el-select>
                <el-button 
                  size="small"
                  type="primary"
                  @click="viewErrorDetails"
                >
                  错误详情
                </el-button>
              </div>
            </div>
          </template>
          
          <BaseChart
            :options="errorChartOptions"
            height="350px"
            :loading="errorLoading"
            @retry="loadErrorStats"
          />
        </el-card>
      </el-col>
    </el-row>

    <!-- 监控设置对话框 -->
    <el-dialog
      v-model="settingsDialogVisible"
      title="监控设置"
      width="800px"
    >
      <el-tabs v-model="activeSettingsTab">
        <el-tab-pane label="告警阈值" name="thresholds">
          <div class="settings-content">
            <el-form :model="monitoringConfig" label-width="120px">
              <el-form-item label="CPU告警阈值">
                <el-row :gutter="12">
                  <el-col :span="12">
                    <el-input-number 
                      v-model="monitoringConfig.thresholds.cpu.warning"
                      :min="0" 
                      :max="100" 
                      placeholder="警告阈值"
                    />
                    <span class="threshold-label">警告阈值 (%)</span>
                  </el-col>
                  <el-col :span="12">
                    <el-input-number 
                      v-model="monitoringConfig.thresholds.cpu.critical"
                      :min="0" 
                      :max="100" 
                      placeholder="严重阈值"
                    />
                    <span class="threshold-label">严重阈值 (%)</span>
                  </el-col>
                </el-row>
              </el-form-item>
              
              <el-form-item label="内存告警阈值">
                <el-row :gutter="12">
                  <el-col :span="12">
                    <el-input-number 
                      v-model="monitoringConfig.thresholds.memory.warning"
                      :min="0" 
                      :max="100" 
                      placeholder="警告阈值"
                    />
                    <span class="threshold-label">警告阈值 (%)</span>
                  </el-col>
                  <el-col :span="12">
                    <el-input-number 
                      v-model="monitoringConfig.thresholds.memory.critical"
                      :min="0" 
                      :max="100" 
                      placeholder="严重阈值"
                    />
                    <span class="threshold-label">严重阈值 (%)</span>
                  </el-col>
                </el-row>
              </el-form-item>
              
              <el-form-item label="响应时间阈值">
                <el-row :gutter="12">
                  <el-col :span="12">
                    <el-input-number 
                      v-model="monitoringConfig.thresholds.responseTime.warning"
                      :min="0" 
                      placeholder="警告阈值"
                    />
                    <span class="threshold-label">警告阈值 (ms)</span>
                  </el-col>
                  <el-col :span="12">
                    <el-input-number 
                      v-model="monitoringConfig.thresholds.responseTime.critical"
                      :min="0" 
                      placeholder="严重阈值"
                    />
                    <span class="threshold-label">严重阈值 (ms)</span>
                  </el-col>
                </el-row>
              </el-form-item>
            </el-form>
          </div>
        </el-tab-pane>
        
        <el-tab-pane label="通知设置" name="notifications">
          <div class="settings-content">
            <el-form :model="monitoringConfig" label-width="120px">
              <div 
                v-for="channel in monitoringConfig.alerting.notificationChannels" 
                :key="channel.id"
                class="notification-channel"
              >
                <div class="channel-header">
                  <span class="channel-name">{{ channel.name }}</span>
                  <el-switch v-model="channel.enabled" />
                </div>
                <div class="channel-config">
                  <el-input 
                    v-if="channel.type === 'webhook'"
                    v-model="channel.config.url"
                    placeholder="Webhook URL"
                  />
                  <el-input 
                    v-if="channel.type === 'email'"
                    v-model="channel.config.recipients"
                    placeholder="邮件接收人，多个用逗号分隔"
                  />
                  <el-input 
                    v-if="channel.type === 'slack'"
                    v-model="channel.config.channel"
                    placeholder="Slack频道"
                  />
                </div>
              </div>
            </el-form>
          </div>
        </el-tab-pane>
      </el-tabs>

      <template #footer>
        <div class="dialog-footer">
          <el-button @click="settingsDialogVisible = false">取消</el-button>
          <el-button 
            type="primary" 
            :loading="settingsSaving"
            @click="saveSettings"
          >
            保存设置
          </el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, onUnmounted, computed, watch } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { 
  Refresh, 
  Setting, 
  Monitor, 
  Warning, 
  Close, 
  Check, 
  Document,
  CircleCheck,
  WarningFilled,
  CircleClose
} from '@element-plus/icons-vue'
import BaseChart from '@/components/charts/BaseChart.vue'
import * as monitoringApi from '@/api/monitoring'
import type { EChartsOption } from 'echarts'

const router = useRouter()

// 响应式数据
const refreshing = ref(false)
const overview = ref({
  services: { total: 0, healthy: 0, degraded: 0, unhealthy: 0 },
  alerts: { active: 0, resolved: 0, critical: 0, high: 0, medium: 0, low: 0 },
  errors: { total: 0, rate: 0, trend: 0 },
  performance: { averageResponseTime: 0, throughput: 0, availability: 0 },
  resources: { cpu: 0, memory: 0, storage: 0 }
})

// 资源使用监控
const resourceTimeRange = ref('1h')
const resourceLoading = ref(false)
const resourceUsage = ref({
  cpu: 0,
  memory: 0,
  storage: 0,
  network: 0
})
const resourceChartOptions = ref<EChartsOption>({})

// 性能监控
const selectedService = ref('')
const serviceList = ref<string[]>([])
const performanceLoading = ref(false)
const performanceChartOptions = ref<EChartsOption>({})

// 服务状态
const servicesLoading = ref(false)
const servicesStatus = ref([])

// 告警
const alertsLoading = ref(false)
const recentAlerts = ref([])

// 错误统计
const errorTimeRange = ref('6h')
const errorLoading = ref(false)
const errorChartOptions = ref<EChartsOption>({})

// 监控设置
const settingsDialogVisible = ref(false)
const settingsSaving = ref(false)
const activeSettingsTab = ref('thresholds')
const monitoringConfig = reactive({
  thresholds: {
    cpu: { warning: 70, critical: 90 },
    memory: { warning: 80, critical: 95 },
    storage: { warning: 85, critical: 95 },
    responseTime: { warning: 1000, critical: 3000 },
    errorRate: { warning: 0.05, critical: 0.1 }
  },
  alerting: {
    notificationChannels: [] as any[]
  }
})

// 计算属性
const getOverallStatusClass = () => {
  const { healthy, total } = overview.value.services
  const healthRatio = total > 0 ? healthy / total : 0
  
  if (healthRatio >= 0.9) return 'healthy'
  if (healthRatio >= 0.7) return 'warning'
  return 'critical'
}

const getOverallStatusIcon = () => {
  const statusClass = getOverallStatusClass()
  return {
    'healthy': CircleCheck,
    'warning': WarningFilled,
    'critical': CircleClose
  }[statusClass] || CircleCheck
}

const getOverallStatusText = () => {
  const statusClass = getOverallStatusClass()
  return {
    'healthy': '正常',
    'warning': '警告',
    'critical': '异常'
  }[statusClass] || '未知'
}

// 工具函数
const formatBytes = (bytes: number): string => {
  if (bytes === 0) return '0 B'
  const k = 1024
  const sizes = ['B', 'KB', 'MB', 'GB', 'TB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
}

const formatUptime = (seconds: number): string => {
  const days = Math.floor(seconds / 86400)
  const hours = Math.floor((seconds % 86400) / 3600)
  const minutes = Math.floor((seconds % 3600) / 60)
  
  if (days > 0) return `${days}天 ${hours}小时`
  if (hours > 0) return `${hours}小时 ${minutes}分钟`
  return `${minutes}分钟`
}

const formatTime = (timeStr: string): string => {
  if (!timeStr) return '-'
  
  const time = new Date(timeStr)
  const now = new Date()
  const diff = now.getTime() - time.getTime()
  
  const minute = 60 * 1000
  const hour = 60 * minute
  
  if (diff < minute) {
    return '刚刚'
  } else if (diff < hour) {
    return `${Math.floor(diff / minute)}分钟前`
  } else {
    return time.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
  }
}

const getServiceStatusType = (status: string): string => {
  const typeMap = {
    'HEALTHY': 'success',
    'DEGRADED': 'warning',
    'UNHEALTHY': 'danger'
  }
  return typeMap[status] || 'info'
}

const getServiceStatusText = (status: string): string => {
  const textMap = {
    'HEALTHY': '正常',
    'DEGRADED': '降级',
    'UNHEALTHY': '异常'
  }
  return textMap[status] || status
}

const getSeverityTagType = (severity: string): string => {
  const typeMap = {
    'low': 'info',
    'medium': 'warning',
    'high': 'danger',
    'critical': 'danger'
  }
  return typeMap[severity] || 'info'
}

const getSeverityText = (severity: string): string => {
  const textMap = {
    'low': '低',
    'medium': '中',
    'high': '高',
    'critical': '严重'
  }
  return textMap[severity] || severity
}

const getAlertStatusType = (status: string): string => {
  const typeMap = {
    'active': 'danger',
    'resolved': 'success',
    'suppressed': 'warning'
  }
  return typeMap[status] || 'info'
}

const getAlertStatusText = (status: string): string => {
  const textMap = {
    'active': '活跃',
    'resolved': '已解决',
    'suppressed': '已抑制'
  }
  return textMap[status] || status
}

// API调用函数
const loadOverview = async () => {
  try {
    const response = await monitoringApi.getMonitoringOverview()
    overview.value = response.data
  } catch (error) {
    console.error('加载监控概览失败:', error)
  }
}

const loadResourceUsage = async () => {
  resourceLoading.value = true
  try {
    const response = await monitoringApi.getResourceUsage()
    resourceUsage.value = response.data.current
    
    // 构建资源使用图表
    const history = response.data.history
    resourceChartOptions.value = {
      tooltip: {
        trigger: 'axis'
      },
      legend: {
        data: ['CPU', '内存', '磁盘']
      },
      xAxis: {
        type: 'category',
        data: history.map(item => new Date(item.timestamp).toLocaleTimeString())
      },
      yAxis: {
        type: 'value',
        max: 100,
        axisLabel: {
          formatter: '{value}%'
        }
      },
      series: [
        {
          name: 'CPU',
          type: 'line',
          data: history.map(item => item.cpu),
          itemStyle: { color: '#409eff' }
        },
        {
          name: '内存',
          type: 'line',
          data: history.map(item => item.memory),
          itemStyle: { color: '#67c23a' }
        },
        {
          name: '磁盘',
          type: 'line',
          data: history.map(item => item.storage),
          itemStyle: { color: '#e6a23c' }
        }
      ]
    }
  } catch (error) {
    console.error('加载资源使用情况失败:', error)
  } finally {
    resourceLoading.value = false
  }
}

const loadPerformanceMetrics = async () => {
  performanceLoading.value = true
  try {
    const response = await monitoringApi.getPerformanceMetrics({
      services: selectedService.value ? [selectedService.value] : undefined
    })
    
    const trends = response.data.trends
    performanceChartOptions.value = {
      tooltip: {
        trigger: 'axis'
      },
      legend: {
        data: ['响应时间', '吞吐量', '错误率']
      },
      xAxis: {
        type: 'category',
        data: trends.map(item => new Date(item.timestamp).toLocaleTimeString())
      },
      yAxis: [
        {
          type: 'value',
          name: '响应时间(ms)',
          position: 'left'
        },
        {
          type: 'value',
          name: '吞吐量/错误率',
          position: 'right'
        }
      ],
      series: [
        {
          name: '响应时间',
          type: 'line',
          yAxisIndex: 0,
          data: trends.map(item => item.responseTime),
          itemStyle: { color: '#409eff' }
        },
        {
          name: '吞吐量',
          type: 'line',
          yAxisIndex: 1,
          data: trends.map(item => item.throughput),
          itemStyle: { color: '#67c23a' }
        },
        {
          name: '错误率',
          type: 'line',
          yAxisIndex: 1,
          data: trends.map(item => item.errorRate * 100),
          itemStyle: { color: '#f56c6c' }
        }
      ]
    }
  } catch (error) {
    console.error('加载性能指标失败:', error)
  } finally {
    performanceLoading.value = false
  }
}

const loadServicesStatus = async () => {
  servicesLoading.value = true
  try {
    const response = await monitoringApi.getServicesStatus()
    servicesStatus.value = response.data
    
    // 提取服务名称列表
    serviceList.value = response.data.map(service => service.name)
  } catch (error) {
    console.error('加载服务状态失败:', error)
  } finally {
    servicesLoading.value = false
  }
}

const loadRecentAlerts = async () => {
  alertsLoading.value = true
  try {
    const response = await monitoringApi.getAlerts({
      current: 1,
      size: 5,
      status: 'active'
    })
    recentAlerts.value = response.data.records
  } catch (error) {
    console.error('加载最近告警失败:', error)
  } finally {
    alertsLoading.value = false
  }
}

const loadErrorStats = async () => {
  errorLoading.value = true
  try {
    const response = await monitoringApi.getErrorStats({
      groupBy: 'hour'
    })
    
    const timeline = response.data.timeline
    errorChartOptions.value = {
      tooltip: {
        trigger: 'axis'
      },
      legend: {
        data: ['错误', '警告', '信息']
      },
      xAxis: {
        type: 'category',
        data: timeline.map(item => new Date(item.timestamp).toLocaleTimeString())
      },
      yAxis: {
        type: 'value'
      },
      series: [
        {
          name: '错误',
          type: 'bar',
          stack: 'total',
          data: timeline.map(item => item.errorCount),
          itemStyle: { color: '#f56c6c' }
        },
        {
          name: '警告',
          type: 'bar',
          stack: 'total',
          data: timeline.map(item => item.warningCount),
          itemStyle: { color: '#e6a23c' }
        },
        {
          name: '信息',
          type: 'bar',
          stack: 'total',
          data: timeline.map(item => item.infoCount),
          itemStyle: { color: '#409eff' }
        }
      ]
    }
  } catch (error) {
    console.error('加载错误统计失败:', error)
  } finally {
    errorLoading.value = false
  }
}

const loadMonitoringConfig = async () => {
  try {
    const response = await monitoringApi.getMonitoringConfig()
    Object.assign(monitoringConfig, response.data)
  } catch (error) {
    console.error('加载监控配置失败:', error)
  }
}

// 事件处理
const handleRefresh = async () => {
  refreshing.value = true
  try {
    await Promise.all([
      loadOverview(),
      loadResourceUsage(),
      loadPerformanceMetrics(),
      loadServicesStatus(),
      loadRecentAlerts(),
      loadErrorStats()
    ])
  } finally {
    refreshing.value = false
  }
}

const handleSettings = () => {
  settingsDialogVisible.value = true
  loadMonitoringConfig()
}

const handleServiceAction = async (command: string, service: any) => {
  try {
    switch (command) {
      case 'restart':
        await ElMessageBox.confirm(`确认重启服务 ${service.name}？`, '确认操作', {
          type: 'warning'
        })
        await monitoringApi.restartService(service.name)
        await loadServicesStatus()
        break
        
      case 'start':
        await monitoringApi.startService(service.name)
        await loadServicesStatus()
        break
        
      case 'stop':
        await ElMessageBox.confirm(`确认停止服务 ${service.name}？`, '确认操作', {
          type: 'warning'
        })
        await monitoringApi.stopService(service.name)
        await loadServicesStatus()
        break
        
      case 'logs':
        router.push({
          path: '/monitoring/logs',
          query: { service: service.name }
        })
        break
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('服务操作失败:', error)
      ElMessage.error('操作失败')
    }
  }
}

const viewAllAlerts = () => {
  router.push('/monitoring/alerts')
}

const viewAlertDetail = (alertId: string) => {
  router.push(`/monitoring/alerts/${alertId}`)
}

const viewErrorDetails = () => {
  router.push('/monitoring/errors')
}

const saveSettings = async () => {
  settingsSaving.value = true
  try {
    await monitoringApi.updateMonitoringConfig(monitoringConfig)
    settingsDialogVisible.value = false
    ElMessage.success('监控设置保存成功')
  } catch (error) {
    console.error('保存监控设置失败:', error)
    ElMessage.error('保存设置失败')
  } finally {
    settingsSaving.value = false
  }
}

// 监听变化
watch(resourceTimeRange, loadResourceUsage)
watch(selectedService, loadPerformanceMetrics)
watch(errorTimeRange, loadErrorStats)

// 生命周期
onMounted(() => {
  handleRefresh()
  
  // 设置定时刷新
  const interval = setInterval(() => {
    loadOverview()
    loadResourceUsage()
  }, 30000) // 30秒刷新一次
  
  onUnmounted(() => {
    clearInterval(interval)
  })
})
</script>

<style scoped lang="scss">
.monitoring-dashboard {
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

  .status-overview {
    margin-bottom: 20px;

    .status-card {
      border-radius: 8px;
      
      :deep(.el-card__body) {
        padding: 20px;
      }

      &.healthy {
        border-left: 4px solid #67c23a;
      }

      &.warning {
        border-left: 4px solid #e6a23c;
      }

      &.critical {
        border-left: 4px solid #f56c6c;
      }

      .status-content {
        display: flex;
        align-items: center;
        gap: 16px;

        .status-icon {
          width: 48px;
          height: 48px;
          border-radius: 8px;
          display: flex;
          align-items: center;
          justify-content: center;
          background: #f0f0f0;
          color: #86909c;

          &.services {
            background: #e6f7ff;
            color: #1890ff;
          }

          &.alerts {
            background: #fff7e6;
            color: #fa8c16;
          }

          &.errors {
            background: #fff1f0;
            color: #f5222d;
          }
        }

        .status-info {
          .status-title {
            font-size: 12px;
            color: #86909c;
            margin-bottom: 4px;
          }

          .status-value {
            font-size: 24px;
            font-weight: 600;
            color: #1f2329;
          }
        }
      }
    }
  }

  .charts-row {
    margin-bottom: 20px;
  }

  .tables-row {
    margin-bottom: 20px;
  }

  .chart-card, .table-card {
    border-radius: 8px;

    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-weight: 600;
      color: #1f2329;
    }

    .resource-metrics {
      margin-bottom: 20px;

      .metric-item {
        margin-bottom: 16px;

        .metric-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 8px;

          .metric-name {
            font-size: 14px;
            color: #1f2329;
          }

          .metric-value {
            font-size: 14px;
            font-weight: 600;
            color: #67c23a;

            &.warning {
              color: #e6a23c;
            }

            &.critical {
              color: #f56c6c;
            }
          }
        }
      }
    }

    .alert-info {
      .alert-title {
        font-weight: 500;
        color: #1f2329;
        margin-bottom: 2px;
      }

      .alert-service {
        font-size: 12px;
        color: #86909c;
      }
    }
  }

  .settings-content {
    .threshold-label {
      font-size: 12px;
      color: #86909c;
      margin-left: 8px;
    }

    .notification-channel {
      padding: 16px;
      border: 1px solid #e5e5e5;
      border-radius: 6px;
      margin-bottom: 16px;

      .channel-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 12px;

        .channel-name {
          font-weight: 500;
          color: #1f2329;
        }
      }

      .channel-config {
        .el-input {
          width: 100%;
        }
      }
    }
  }

  .dialog-footer {
    display: flex;
    justify-content: flex-end;
    gap: 12px;
  }
}
</style>