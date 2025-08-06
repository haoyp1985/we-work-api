<template>
  <div class="analytics-dashboard">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-title">
        <h1>数据分析仪表板</h1>
        <p>AI系统使用情况、成本分析和性能监控的综合视图</p>
      </div>
      <div class="header-actions">
        <el-date-picker
          v-model="dateRange"
          type="daterange"
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          format="YYYY-MM-DD"
          value-format="YYYY-MM-DD"
          @change="handleDateChange"
          style="margin-right: 12px"
        />
        <el-select
          v-model="selectedPeriod"
          placeholder="选择时间范围"
          style="width: 150px; margin-right: 12px"
          @change="handlePeriodChange"
        >
          <el-option label="最近7天" value="LAST_7_DAYS" />
          <el-option label="最近30天" value="LAST_30_DAYS" />
          <el-option label="最近90天" value="LAST_90_DAYS" />
          <el-option label="自定义" value="CUSTOM" />
        </el-select>
        <el-button 
          type="primary" 
          :icon="Document"
          @click="handleGenerateReport"
        >
          生成报告
        </el-button>
        <el-button 
          :icon="Refresh"
          @click="handleRefresh"
          :loading="refreshing"
        >
          刷新
        </el-button>
      </div>
    </div>

    <!-- 总览统计卡片 -->
    <div class="overview-stats">
      <el-row :gutter="20">
        <el-col :span="6">
          <el-card class="stat-card">
            <div class="stat-content">
              <div class="stat-icon users">
                <el-icon><User /></el-icon>
              </div>
              <div class="stat-info">
                <div class="stat-value">
                  {{ formatNumber(overviewStats.totalUsers) }}
                  <span class="growth" :class="{ positive: overviewStats.growth.users > 0 }">
                    {{ overviewStats.growth.users > 0 ? '+' : '' }}{{ overviewStats.growth.users }}%
                  </span>
                </div>
                <div class="stat-label">总用户数</div>
              </div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="stat-card">
            <div class="stat-content">
              <div class="stat-icon agents">
                <el-icon><Robot /></el-icon>
              </div>
              <div class="stat-info">
                <div class="stat-value">
                  {{ formatNumber(overviewStats.totalAgents) }}
                  <span class="growth" :class="{ positive: overviewStats.growth.agents > 0 }">
                    {{ overviewStats.growth.agents > 0 ? '+' : '' }}{{ overviewStats.growth.agents }}%
                  </span>
                </div>
                <div class="stat-label">智能体数量</div>
              </div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="stat-card">
            <div class="stat-content">
              <div class="stat-icon conversations">
                <el-icon><ChatDotRound /></el-icon>
              </div>
              <div class="stat-info">
                <div class="stat-value">
                  {{ formatNumber(overviewStats.totalConversations) }}
                  <span class="growth" :class="{ positive: overviewStats.growth.conversations > 0 }">
                    {{ overviewStats.growth.conversations > 0 ? '+' : '' }}{{ overviewStats.growth.conversations }}%
                  </span>
                </div>
                <div class="stat-label">对话数量</div>
              </div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="stat-card">
            <div class="stat-content">
              <div class="stat-icon cost">
                <el-icon><Money /></el-icon>
              </div>
              <div class="stat-info">
                <div class="stat-value">
                  ¥{{ formatNumber(overviewStats.totalCost, 2) }}
                  <span class="growth" :class="{ positive: overviewStats.growth.cost < 0 }">
                    {{ overviewStats.growth.cost > 0 ? '+' : '' }}{{ overviewStats.growth.cost }}%
                  </span>
                </div>
                <div class="stat-label">总成本</div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- 实时状态监控 -->
    <el-card class="realtime-card" shadow="never">
      <template #header>
        <div class="card-header">
          <span>实时状态监控</span>
          <el-tag :type="systemStatusType" size="small">
            {{ systemStatusText }}
          </el-tag>
        </div>
      </template>
      
      <el-row :gutter="20">
        <el-col :span="6">
          <div class="realtime-metric">
            <div class="metric-label">活跃用户</div>
            <div class="metric-value">{{ realtimeStats.activeUsers }}</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="realtime-metric">
            <div class="metric-label">进行中对话</div>
            <div class="metric-value">{{ realtimeStats.activeConversations }}</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="realtime-metric">
            <div class="metric-label">每分钟消息数</div>
            <div class="metric-value">{{ realtimeStats.messagesPerMinute }}</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="realtime-metric">
            <div class="metric-label">平均响应时间</div>
            <div class="metric-value">{{ realtimeStats.averageResponseTime }}ms</div>
          </div>
        </el-col>
      </el-row>

      <!-- 平台状态 -->
      <div class="platform-status">
        <h4>平台状态</h4>
        <div class="status-grid">
          <div 
            v-for="platform in realtimeStats.platformStatus" 
            :key="platform.platform"
            class="platform-item"
          >
            <div class="platform-name">{{ platform.platform }}</div>
            <div class="platform-metrics">
              <el-tag 
                :type="getPlatformStatusType(platform.status)" 
                size="small"
              >
                {{ getPlatformStatusText(platform.status) }}
              </el-tag>
              <span class="response-time">{{ platform.responseTime }}ms</span>
            </div>
          </div>
        </div>
      </div>
    </el-card>

    <!-- 图表分析区域 -->
    <el-row :gutter="20" class="charts-row">
      <!-- 使用趋势图 -->
      <el-col :span="12">
        <el-card class="chart-card" shadow="never">
          <template #header>
            <div class="card-header">
              <span>使用趋势</span>
              <el-radio-group v-model="usageTrendType" size="small">
                <el-radio-button label="conversations">对话</el-radio-button>
                <el-radio-button label="messages">消息</el-radio-button>
                <el-radio-button label="users">用户</el-radio-button>
              </el-radio-group>
            </div>
          </template>
          
          <BaseChart
            :options="usageTrendChartOptions"
            height="350px"
            :loading="usageTrendLoading"
            @retry="loadUsageTrend"
          />
        </el-card>
      </el-col>

      <!-- 成本分析图 -->
      <el-col :span="12">
        <el-card class="chart-card" shadow="never">
          <template #header>
            <div class="card-header">
              <span>成本分析</span>
              <el-radio-group v-model="costAnalysisType" size="small">
                <el-radio-button label="trend">趋势</el-radio-button>
                <el-radio-button label="platform">平台</el-radio-button>
                <el-radio-button label="agent">智能体</el-radio-button>
              </el-radio-group>
            </div>
          </template>
          
          <BaseChart
            :options="costAnalysisChartOptions"
            height="350px"
            :loading="costAnalysisLoading"
            @retry="loadCostAnalysis"
          />
        </el-card>
      </el-col>
    </el-row>

    <!-- 性能监控和用户分析 -->
    <el-row :gutter="20" class="charts-row">
      <!-- 性能监控图 -->
      <el-col :span="12">
        <el-card class="chart-card" shadow="never">
          <template #header>
            <span>性能监控</span>
          </template>
          
          <BaseChart
            :options="performanceChartOptions"
            height="350px"
            :loading="performanceLoading"
            @retry="loadPerformanceStats"
          />
        </el-card>
      </el-col>

      <!-- 用户活跃度分析 -->
      <el-col :span="12">
        <el-card class="chart-card" shadow="never">
          <template #header>
            <span>用户活跃度</span>
          </template>
          
          <BaseChart
            :options="userActivityChartOptions"
            height="350px"
            :loading="userActivityLoading"
            @retry="loadUserActivity"
          />
        </el-card>
      </el-col>
    </el-row>

    <!-- 顶级智能体和用户 -->
    <el-row :gutter="20" class="tables-row">
      <!-- 热门智能体 -->
      <el-col :span="12">
        <el-card class="table-card" shadow="never">
          <template #header>
            <span>热门智能体</span>
          </template>
          
          <el-table 
            :data="topAgents" 
            style="width: 100%"
            :loading="topAgentsLoading"
          >
            <el-table-column label="智能体" min-width="120">
              <template #default="{ row }">
                <div class="agent-info">
                  <div class="agent-name">{{ row.agentName }}</div>
                  <div class="agent-id">{{ row.agentId }}</div>
                </div>
              </template>
            </el-table-column>
            <el-table-column label="对话数" prop="conversationCount" width="80" align="center" />
            <el-table-column label="消息数" prop="messageCount" width="80" align="center" />
            <el-table-column label="评分" width="80" align="center">
              <template #default="{ row }">
                <el-rate 
                  :model-value="row.averageRating" 
                  disabled 
                  size="small"
                  show-score
                />
              </template>
            </el-table-column>
            <el-table-column label="成本" width="100" align="right">
              <template #default="{ row }">
                ¥{{ row.totalCost.toFixed(2) }}
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>

      <!-- 活跃用户 -->
      <el-col :span="12">
        <el-card class="table-card" shadow="never">
          <template #header>
            <span>活跃用户</span>
          </template>
          
          <el-table 
            :data="topUsers" 
            style="width: 100%"
            :loading="topUsersLoading"
          >
            <el-table-column label="用户" min-width="120">
              <template #default="{ row }">
                <div class="user-info">
                  <div class="user-name">{{ row.userName }}</div>
                  <div class="user-id">{{ row.userId }}</div>
                </div>
              </template>
            </el-table-column>
            <el-table-column label="消息数" prop="totalMessages" width="80" align="center" />
            <el-table-column label="成本" width="100" align="right">
              <template #default="{ row }">
                ¥{{ row.totalCost.toFixed(2) }}
              </template>
            </el-table-column>
            <el-table-column label="最后活跃" width="120" align="center">
              <template #default="{ row }">
                {{ formatTime(row.lastActiveAt) }}
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>

    <!-- 生成报告对话框 -->
    <el-dialog
      v-model="reportDialogVisible"
      title="生成分析报告"
      width="500px"
    >
      <el-form
        ref="reportFormRef"
        :model="reportForm"
        :rules="reportFormRules"
        label-width="100px"
      >
        <el-form-item label="报告类型" prop="type">
          <el-select v-model="reportForm.type" placeholder="选择报告类型" style="width: 100%">
            <el-option label="使用统计报告" value="USAGE" />
            <el-option label="成本分析报告" value="COST" />
            <el-option label="性能监控报告" value="PERFORMANCE" />
            <el-option label="综合分析报告" value="COMPREHENSIVE" />
          </el-select>
        </el-form-item>

        <el-form-item label="时间范围" prop="period">
          <el-select v-model="reportForm.period" placeholder="选择时间范围" style="width: 100%">
            <el-option label="最近7天" value="LAST_7_DAYS" />
            <el-option label="最近30天" value="LAST_30_DAYS" />
            <el-option label="最近90天" value="LAST_90_DAYS" />
            <el-option label="自定义" value="CUSTOM" />
          </el-select>
        </el-form-item>

        <el-form-item 
          v-if="reportForm.period === 'CUSTOM'" 
          label="自定义日期"
          prop="customDateRange"
        >
          <el-date-picker
            v-model="reportForm.customDateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            style="width: 100%"
          />
        </el-form-item>

        <el-form-item label="导出格式" prop="format">
          <el-radio-group v-model="reportForm.format">
            <el-radio label="PDF">PDF</el-radio>
            <el-radio label="EXCEL">Excel</el-radio>
            <el-radio label="CSV">CSV</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="包含图表" prop="includeCharts">
          <el-switch v-model="reportForm.includeCharts" />
        </el-form-item>
      </el-form>

      <template #footer>
        <div class="dialog-footer">
          <el-button @click="reportDialogVisible = false">取消</el-button>
          <el-button 
            type="primary" 
            :loading="reportGenerating"
            @click="handleConfirmGenerateReport"
          >
            生成报告
          </el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { 
  Document, 
  Refresh, 
  User, 
  Robot, 
  ChatDotRound, 
  Money 
} from '@element-plus/icons-vue'
import BaseChart from '@/components/charts/BaseChart.vue'
import * as analyticsApi from '@/api/analytics'
import type { StatsPeriod } from '@/types/api'
import type { FormInstance, FormRules } from 'element-plus'
import type { EChartsOption } from 'echarts'

// 响应式数据
const refreshing = ref(false)
const selectedPeriod = ref<StatsPeriod>('LAST_30_DAYS')
const dateRange = ref<[string, string]>()

// 总览统计数据
const overviewStats = ref({
  totalUsers: 0,
  totalAgents: 0,
  totalConversations: 0,
  totalMessages: 0,
  totalCost: 0,
  totalTokens: 0,
  growth: {
    users: 0,
    agents: 0,
    conversations: 0,
    messages: 0,
    cost: 0,
    tokens: 0
  }
})

// 实时统计数据
const realtimeStats = ref({
  activeUsers: 0,
  activeConversations: 0,
  messagesPerMinute: 0,
  averageResponseTime: 0,
  platformStatus: [] as Array<{
    platform: string
    status: 'online' | 'offline' | 'degraded'
    responseTime: number
  }>,
  systemLoad: {
    cpu: 0,
    memory: 0,
    storage: 0
  }
})

// 图表数据
const usageTrendType = ref('conversations')
const usageTrendLoading = ref(false)
const usageTrendChartOptions = ref<EChartsOption>({})

const costAnalysisType = ref('trend')
const costAnalysisLoading = ref(false)
const costAnalysisChartOptions = ref<EChartsOption>({})

const performanceLoading = ref(false)
const performanceChartOptions = ref<EChartsOption>({})

const userActivityLoading = ref(false)
const userActivityChartOptions = ref<EChartsOption>({})

// 热门列表数据
const topAgents = ref([])
const topAgentsLoading = ref(false)
const topUsers = ref([])
const topUsersLoading = ref(false)

// 报告生成
const reportDialogVisible = ref(false)
const reportGenerating = ref(false)
const reportFormRef = ref<FormInstance>()
const reportForm = reactive({
  type: 'COMPREHENSIVE',
  period: 'LAST_30_DAYS' as StatsPeriod,
  customDateRange: undefined as [string, string] | undefined,
  format: 'PDF',
  includeCharts: true
})

const reportFormRules: FormRules = {
  type: [
    { required: true, message: '请选择报告类型', trigger: 'change' }
  ],
  period: [
    { required: true, message: '请选择时间范围', trigger: 'change' }
  ],
  customDateRange: [
    { required: true, message: '请选择自定义日期范围', trigger: 'change' }
  ],
  format: [
    { required: true, message: '请选择导出格式', trigger: 'change' }
  ]
}

// 计算属性
const systemStatusType = computed(() => {
  const { cpu, memory, storage } = realtimeStats.value.systemLoad
  const maxLoad = Math.max(cpu, memory, storage)
  
  if (maxLoad < 70) return 'success'
  if (maxLoad < 90) return 'warning'
  return 'danger'
})

const systemStatusText = computed(() => {
  const type = systemStatusType.value
  const statusMap = {
    'success': '系统正常',
    'warning': '系统警告',
    'danger': '系统异常'
  }
  return statusMap[type] || '未知状态'
})

// 格式化数字
const formatNumber = (num: number, decimals: number = 0): string => {
  if (num >= 1000000) {
    return (num / 1000000).toFixed(decimals) + 'M'
  } else if (num >= 1000) {
    return (num / 1000).toFixed(decimals) + 'K'
  }
  return num.toFixed(decimals)
}

// 格式化时间
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

// 获取平台状态类型
const getPlatformStatusType = (status: string): string => {
  const typeMap = {
    'online': 'success',
    'offline': 'danger',
    'degraded': 'warning'
  }
  return typeMap[status] || 'info'
}

// 获取平台状态文本
const getPlatformStatusText = (status: string): string => {
  const textMap = {
    'online': '在线',
    'offline': '离线',
    'degraded': '降级'
  }
  return textMap[status] || status
}

// 加载总览统计
const loadOverviewStats = async () => {
  try {
    const response = await analyticsApi.getOverviewStats(selectedPeriod.value)
    overviewStats.value = response.data
  } catch (error) {
    console.error('加载总览统计失败:', error)
    ElMessage.error('加载总览统计失败')
  }
}

// 加载实时统计
const loadRealtimeStats = async () => {
  try {
    const response = await analyticsApi.getRealTimeStats()
    realtimeStats.value = response.data
  } catch (error) {
    console.error('加载实时统计失败:', error)
  }
}

// 加载使用趋势
const loadUsageTrend = async () => {
  usageTrendLoading.value = true
  try {
    let response
    if (usageTrendType.value === 'conversations') {
      response = await analyticsApi.getConversationStats({
        period: selectedPeriod.value,
        startDate: dateRange.value?.[0],
        endDate: dateRange.value?.[1]
      })
    } else if (usageTrendType.value === 'users') {
      response = await analyticsApi.getUserUsageStats({
        period: selectedPeriod.value,
        startDate: dateRange.value?.[0],
        endDate: dateRange.value?.[1]
      })
    } else {
      response = await analyticsApi.getAgentUsageStats({
        period: selectedPeriod.value,
        startDate: dateRange.value?.[0],
        endDate: dateRange.value?.[1]
      })
    }
    
    // 构建图表配置
    const data = response.data.timeSeriesData || []
    usageTrendChartOptions.value = {
      title: {
        text: `${usageTrendType.value === 'conversations' ? '对话' : usageTrendType.value === 'users' ? '用户' : '消息'}趋势`,
        left: 'center'
      },
      tooltip: {
        trigger: 'axis'
      },
      xAxis: {
        type: 'category',
        data: data.map(item => item.date)
      },
      yAxis: {
        type: 'value'
      },
      series: [{
        data: data.map(item => item.value),
        type: 'line',
        smooth: true,
        areaStyle: {
          opacity: 0.3
        }
      }]
    }
  } catch (error) {
    console.error('加载使用趋势失败:', error)
  } finally {
    usageTrendLoading.value = false
  }
}

// 加载成本分析
const loadCostAnalysis = async () => {
  costAnalysisLoading.value = true
  try {
    const response = await analyticsApi.getCostAnalysis({
      period: selectedPeriod.value,
      startDate: dateRange.value?.[0],
      endDate: dateRange.value?.[1]
    })
    
    const costData = response.data
    
    if (costAnalysisType.value === 'trend') {
      costAnalysisChartOptions.value = {
        title: {
          text: '成本趋势',
          left: 'center'
        },
        tooltip: {
          trigger: 'axis',
          formatter: (params: any) => {
            return `${params[0].name}<br/>成本: ¥${params[0].value.toFixed(2)}`
          }
        },
        xAxis: {
          type: 'category',
          data: costData.costTrend.map(item => item.date)
        },
        yAxis: {
          type: 'value',
          axisLabel: {
            formatter: '¥{value}'
          }
        },
        series: [{
          data: costData.costTrend.map(item => item.value),
          type: 'line',
          smooth: true,
          itemStyle: {
            color: '#f56c6c'
          }
        }]
      }
    } else if (costAnalysisType.value === 'platform') {
      costAnalysisChartOptions.value = {
        title: {
          text: '平台成本分布',
          left: 'center'
        },
        tooltip: {
          trigger: 'item',
          formatter: '{b}: ¥{c} ({d}%)'
        },
        series: [{
          type: 'pie',
          radius: ['40%', '70%'],
          data: costData.breakdown.byPlatform.map(item => ({
            name: item.platform,
            value: item.cost
          }))
        }]
      }
    } else {
      costAnalysisChartOptions.value = {
        title: {
          text: '智能体成本排名',
          left: 'center'
        },
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          }
        },
        xAxis: {
          type: 'value',
          axisLabel: {
            formatter: '¥{value}'
          }
        },
        yAxis: {
          type: 'category',
          data: costData.breakdown.byAgent.slice(0, 10).map(item => item.agentName)
        },
        series: [{
          type: 'bar',
          data: costData.breakdown.byAgent.slice(0, 10).map(item => item.cost),
          itemStyle: {
            color: '#409eff'
          }
        }]
      }
    }
  } catch (error) {
    console.error('加载成本分析失败:', error)
  } finally {
    costAnalysisLoading.value = false
  }
}

// 加载性能统计
const loadPerformanceStats = async () => {
  performanceLoading.value = true
  try {
    const response = await analyticsApi.getPerformanceStats({
      period: selectedPeriod.value,
      startDate: dateRange.value?.[0],
      endDate: dateRange.value?.[1]
    })
    
    const perfData = response.data.timeSeriesData || []
    performanceChartOptions.value = {
      title: {
        text: '性能监控',
        left: 'center'
      },
      tooltip: {
        trigger: 'axis'
      },
      legend: {
        top: 30,
        data: ['响应时间', '成功率']
      },
      xAxis: {
        type: 'category',
        data: perfData.map(item => item.timestamp)
      },
      yAxis: [
        {
          type: 'value',
          name: '响应时间(ms)',
          position: 'left'
        },
        {
          type: 'value',
          name: '成功率(%)',
          position: 'right',
          min: 0,
          max: 100
        }
      ],
      series: [
        {
          name: '响应时间',
          type: 'line',
          yAxisIndex: 0,
          data: perfData.map(item => item.responseTime),
          itemStyle: {
            color: '#409eff'
          }
        },
        {
          name: '成功率',
          type: 'line',
          yAxisIndex: 1,
          data: perfData.map(item => item.successRate * 100),
          itemStyle: {
            color: '#67c23a'
          }
        }
      ]
    }
  } catch (error) {
    console.error('加载性能统计失败:', error)
  } finally {
    performanceLoading.value = false
  }
}

// 加载用户活跃度
const loadUserActivity = async () => {
  userActivityLoading.value = true
  try {
    const response = await analyticsApi.getUserUsageStats({
      period: selectedPeriod.value,
      startDate: dateRange.value?.[0],
      endDate: dateRange.value?.[1]
    })
    
    const userData = response.data.userGrowthTrend || []
    userActivityChartOptions.value = {
      title: {
        text: '用户增长趋势',
        left: 'center'
      },
      tooltip: {
        trigger: 'axis'
      },
      legend: {
        top: 30,
        data: ['新增用户', '活跃用户']
      },
      xAxis: {
        type: 'category',
        data: userData.map(item => item.date)
      },
      yAxis: {
        type: 'value'
      },
      series: [
        {
          name: '新增用户',
          type: 'bar',
          data: userData.map(item => item.newUsers),
          itemStyle: {
            color: '#409eff'
          }
        },
        {
          name: '活跃用户',
          type: 'line',
          data: userData.map(item => item.activeUsers),
          itemStyle: {
            color: '#67c23a'
          }
        }
      ]
    }
  } catch (error) {
    console.error('加载用户活跃度失败:', error)
  } finally {
    userActivityLoading.value = false
  }
}

// 加载热门智能体
const loadTopAgents = async () => {
  topAgentsLoading.value = true
  try {
    const response = await analyticsApi.getAgentUsageStats({
      period: selectedPeriod.value,
      startDate: dateRange.value?.[0],
      endDate: dateRange.value?.[1]
    })
    
    topAgents.value = response.data.topAgents?.slice(0, 5) || []
  } catch (error) {
    console.error('加载热门智能体失败:', error)
  } finally {
    topAgentsLoading.value = false
  }
}

// 加载活跃用户
const loadTopUsers = async () => {
  topUsersLoading.value = true
  try {
    const response = await analyticsApi.getUserUsageStats({
      period: selectedPeriod.value,
      startDate: dateRange.value?.[0],
      endDate: dateRange.value?.[1]
    })
    
    topUsers.value = response.data.topUsers?.slice(0, 5) || []
  } catch (error) {
    console.error('加载活跃用户失败:', error)
  } finally {
    topUsersLoading.value = false
  }
}

// 加载所有数据
const loadAllData = async () => {
  await Promise.all([
    loadOverviewStats(),
    loadRealtimeStats(),
    loadUsageTrend(),
    loadCostAnalysis(),
    loadPerformanceStats(),
    loadUserActivity(),
    loadTopAgents(),
    loadTopUsers()
  ])
}

// 事件处理
const handleDateChange = (dates: [string, string] | null) => {
  if (dates) {
    selectedPeriod.value = 'CUSTOM'
  }
  loadAllData()
}

const handlePeriodChange = () => {
  if (selectedPeriod.value !== 'CUSTOM') {
    dateRange.value = undefined
  }
  loadAllData()
}

const handleRefresh = async () => {
  refreshing.value = true
  try {
    await loadAllData()
  } finally {
    refreshing.value = false
  }
}

const handleGenerateReport = () => {
  reportDialogVisible.value = true
}

const handleConfirmGenerateReport = async () => {
  if (!reportFormRef.value) return
  
  try {
    await reportFormRef.value.validate()
    reportGenerating.value = true
    
    const params = {
      type: reportForm.type,
      period: reportForm.period,
      startDate: reportForm.customDateRange?.[0],
      endDate: reportForm.customDateRange?.[1],
      format: reportForm.format,
      includeCharts: reportForm.includeCharts
    }
    
    const response = await analyticsApi.generateReport(params)
    
    // 自动下载报告
    if (response.data.downloadUrl) {
      const link = document.createElement('a')
      link.href = response.data.downloadUrl
      link.click()
    }
    
    reportDialogVisible.value = false
    ElMessage.success('报告生成成功')
  } catch (error) {
    console.error('生成报告失败:', error)
    ElMessage.error('生成报告失败')
  } finally {
    reportGenerating.value = false
  }
}

// 监听图表类型变化
watch(usageTrendType, loadUsageTrend)
watch(costAnalysisType, loadCostAnalysis)

// 初始化
onMounted(() => {
  loadAllData()
  
  // 设置定时刷新实时数据
  setInterval(loadRealtimeStats, 30000) // 30秒刷新一次
})
</script>

<style scoped lang="scss">
.analytics-dashboard {
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
      align-items: center;
    }
  }

  .overview-stats {
    margin-bottom: 20px;

    .stat-card {
      border-radius: 8px;
      
      :deep(.el-card__body) {
        padding: 20px;
      }

      .stat-content {
        display: flex;
        align-items: center;
        gap: 16px;

        .stat-icon {
          width: 48px;
          height: 48px;
          border-radius: 8px;
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 24px;

          &.users {
            background: #e6f7ff;
            color: #1890ff;
          }

          &.agents {
            background: #f0f9f0;
            color: #52c41a;
          }

          &.conversations {
            background: #fff7e6;
            color: #fa8c16;
          }

          &.cost {
            background: #fff1f0;
            color: #f5222d;
          }
        }

        .stat-info {
          .stat-value {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 24px;
            font-weight: 600;
            color: #1f2329;
            margin-bottom: 4px;

            .growth {
              font-size: 12px;
              font-weight: normal;
              color: #f56c6c;

              &.positive {
                color: #67c23a;
              }
            }
          }

          .stat-label {
            font-size: 12px;
            color: #86909c;
          }
        }
      }
    }
  }

  .realtime-card {
    margin-bottom: 20px;
    border-radius: 8px;

    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-weight: 600;
      color: #1f2329;
    }

    .realtime-metric {
      text-align: center;
      padding: 12px;

      .metric-label {
        font-size: 12px;
        color: #86909c;
        margin-bottom: 8px;
      }

      .metric-value {
        font-size: 20px;
        font-weight: 600;
        color: #1f2329;
      }
    }

    .platform-status {
      margin-top: 20px;

      h4 {
        margin: 0 0 12px 0;
        font-size: 14px;
        font-weight: 600;
        color: #1f2329;
      }

      .status-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 12px;

        .platform-item {
          padding: 12px;
          border: 1px solid #e5e5e5;
          border-radius: 6px;
          background: #fafafa;

          .platform-name {
            font-weight: 500;
            margin-bottom: 8px;
          }

          .platform-metrics {
            display: flex;
            justify-content: space-between;
            align-items: center;

            .response-time {
              font-size: 12px;
              color: #86909c;
            }
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

    .agent-info, .user-info {
      .agent-name, .user-name {
        font-weight: 500;
        color: #1f2329;
      }

      .agent-id, .user-id {
        font-size: 12px;
        color: #86909c;
        margin-top: 2px;
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