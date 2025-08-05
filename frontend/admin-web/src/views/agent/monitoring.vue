<template>
  <div class="monitoring-dashboard">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="page-title">
        <h2>AI调用监控</h2>
        <p>实时监控AI智能体的调用情况、性能指标和成本分析</p>
      </div>
      
      <!-- 时间范围选择器 -->
      <div class="time-selector">
        <el-date-picker
          v-model="timeRange"
          type="datetimerange"
          range-separator="至"
          start-placeholder="开始时间"
          end-placeholder="结束时间"
          format="YYYY-MM-DD HH:mm"
          value-format="YYYY-MM-DD HH:mm:ss"
          @change="handleTimeRangeChange"
        />
        <el-select v-model="selectedTimeRange" @change="handlePresetTimeRange" style="margin-left: 12px;">
          <el-option label="今天" value="day" />
          <el-option label="本周" value="week" />
          <el-option label="本月" value="month" />
          <el-option label="本季度" value="quarter" />
          <el-option label="本年" value="year" />
        </el-select>
        <el-button type="primary" @click="refreshData" style="margin-left: 12px;">
          <el-icon><Refresh /></el-icon>
          刷新
        </el-button>
      </div>
    </div>

    <!-- 统计概览卡片 -->
    <div class="overview-cards">
      <el-row :gutter="20">
        <el-col :span="6">
          <div class="stat-card">
            <div class="stat-icon total">
              <el-icon><ChatDotRound /></el-icon>
            </div>
            <div class="stat-content">
              <div class="stat-value">{{ statistics.totalCalls.toLocaleString() }}</div>
              <div class="stat-label">总调用次数</div>
            </div>
          </div>
        </el-col>
        
        <el-col :span="6">
          <div class="stat-card">
            <div class="stat-icon success">
              <el-icon><CircleCheck /></el-icon>
            </div>
            <div class="stat-content">
              <div class="stat-value">{{ ((statistics.successCalls / statistics.totalCalls) * 100).toFixed(1) }}%</div>
              <div class="stat-label">成功率</div>
            </div>
          </div>
        </el-col>
        
        <el-col :span="6">
          <div class="stat-card">
            <div class="stat-icon response">
              <el-icon><Timer /></el-icon>
            </div>
            <div class="stat-content">
              <div class="stat-value">{{ statistics.avgResponseTime }}ms</div>
              <div class="stat-label">平均响应时间</div>
            </div>
          </div>
        </el-col>
        
        <el-col :span="6">
          <div class="stat-card">
            <div class="stat-icon cost">
              <el-icon><Money /></el-icon>
            </div>
            <div class="stat-content">
              <div class="stat-value">¥{{ statistics.totalCost.toFixed(2) }}</div>
              <div class="stat-label">总成本</div>
            </div>
          </div>
        </el-col>
      </el-row>
    </div>

    <!-- 图表区域 -->
    <el-row :gutter="20" style="margin-top: 20px;">
      <!-- 调用趋势图 -->
      <el-col :span="16">
        <el-card>
          <template #header>
            <div class="card-header">
              <span>调用趋势</span>
              <el-radio-group v-model="trendChartType" size="small">
                <el-radio-button label="calls">调用次数</el-radio-button>
                <el-radio-button label="tokens">Token消耗</el-radio-button>
                <el-radio-button label="cost">成本</el-radio-button>
              </el-radio-group>
            </div>
          </template>
          <div ref="trendChart" style="height: 300px;"></div>
        </el-card>
      </el-col>
      
      <!-- 平台分布图 -->
      <el-col :span="8">
        <el-card>
          <template #header>
            <span>平台分布</span>
          </template>
          <div ref="platformChart" style="height: 300px;"></div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 性能指标和成本分析 -->
    <el-row :gutter="20" style="margin-top: 20px;">
      <!-- 性能指标 -->
      <el-col :span="12">
        <el-card>
          <template #header>
            <span>性能指标</span>
          </template>
          <div class="performance-metrics">
            <div class="metric-item">
              <span class="metric-label">平均响应时间</span>
              <span class="metric-value">{{ performanceMetrics.avgResponseTime }}ms</span>
            </div>
            <div class="metric-item">
              <span class="metric-label">P95响应时间</span>
              <span class="metric-value">{{ performanceMetrics.p95ResponseTime }}ms</span>
            </div>
            <div class="metric-item">
              <span class="metric-label">P99响应时间</span>
              <span class="metric-value">{{ performanceMetrics.p99ResponseTime }}ms</span>
            </div>
            <div class="metric-item">
              <span class="metric-label">错误率</span>
              <span class="metric-value">{{ (performanceMetrics.errorRate * 100).toFixed(2) }}%</span>
            </div>
            <div class="metric-item">
              <span class="metric-label">吞吐量</span>
              <span class="metric-value">{{ performanceMetrics.throughput }}/秒</span>
            </div>
            <div class="metric-item">
              <span class="metric-label">并发用户</span>
              <span class="metric-value">{{ performanceMetrics.concurrentUsers }}</span>
            </div>
          </div>
        </el-card>
      </el-col>
      
      <!-- 成本分析 -->
      <el-col :span="12">
        <el-card>
          <template #header>
            <span>成本分析</span>
          </template>
          <div ref="costChart" style="height: 280px;"></div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 调用记录列表 -->
    <el-card style="margin-top: 20px;">
      <template #header>
        <div class="card-header">
          <span>调用记录</span>
          <div class="filter-actions">
            <el-select v-model="recordFilters.agentId" placeholder="选择智能体" clearable style="width: 200px;">
              <el-option
                v-for="agent in agents"
                :key="agent.id"
                :label="agent.name"
                :value="agent.id"
              />
            </el-select>
            <el-select v-model="recordFilters.platformType" placeholder="选择平台" clearable style="margin-left: 12px; width: 150px;">
              <el-option label="Dify" value="dify" />
              <el-option label="Coze" value="coze" />
              <el-option label="OpenAI" value="openai" />
            </el-select>
            <el-select v-model="recordFilters.status" placeholder="调用状态" clearable style="margin-left: 12px; width: 120px;">
              <el-option label="成功" value="success" />
              <el-option label="失败" value="failed" />
              <el-option label="超时" value="timeout" />
            </el-select>
            <el-button type="primary" @click="searchRecords" style="margin-left: 12px;">
              <el-icon><Search /></el-icon>
              查询
            </el-button>
          </div>
        </div>
      </template>
      
      <el-table
        :data="callRecords"
        :loading="recordsLoading"
        stripe
      >
        <el-table-column prop="id" label="记录ID" width="120" />
        <el-table-column prop="agentName" label="智能体" width="150" />
        <el-table-column prop="platformType" label="平台" width="100">
          <template #default="{ row }">
            <el-tag :type="getPlatformTagType(row.platformType)">
              {{ getPlatformName(row.platformType) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="callType" label="调用类型" width="120" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusTagType(row.status)">
              {{ getStatusText(row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="responseTime" label="响应时间" width="120">
          <template #default="{ row }">
            {{ row.responseTime }}ms
          </template>
        </el-table-column>
        <el-table-column prop="inputTokens" label="输入Token" width="120" />
        <el-table-column prop="outputTokens" label="输出Token" width="120" />
        <el-table-column prop="cost" label="成本" width="100">
          <template #default="{ row }">
            ¥{{ row.cost?.toFixed(4) }}
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="调用时间" width="160">
          <template #default="{ row }">
            {{ formatDate(row.createdAt) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120" fixed="right">
          <template #default="{ row }">
            <el-button size="small" type="primary" link @click="viewRecordDetail(row)">
              详情
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <!-- 分页 -->
      <div class="pagination-wrapper">
        <el-pagination
          v-model:current-page="recordPagination.pageNum"
          v-model:page-size="recordPagination.pageSize"
          :total="recordPagination.total"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handlePageSizeChange"
          @current-change="handlePageChange"
        />
      </div>
    </el-card>

    <!-- 调用记录详情对话框 -->
    <el-dialog
      v-model="recordDetailVisible"
      title="调用记录详情"
      width="60%"
      append-to-body
    >
      <CallRecordDetail
        v-if="recordDetailVisible && selectedRecord"
        :record="selectedRecord"
      />
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, nextTick } from 'vue'
import { ElMessage } from 'element-plus'
import { 
  Refresh, 
  ChatDotRound, 
  CircleCheck, 
  Timer, 
  Money, 
  Search 
} from '@element-plus/icons-vue'
import * as echarts from 'echarts'
import { agentApi } from '@/api/agent'
import CallRecordDetail from './components/CallRecordDetail.vue'
import type { 
  CallRecordDTO, 
  AgentDTO
} from '@/types/agent'

// ===== 响应式数据 =====
const timeRange = ref<[string, string]>(['', ''])
const selectedTimeRange = ref('week')
const trendChartType = ref('calls')

// 统计数据
const statistics = reactive({
  totalCalls: 0,
  successCalls: 0,
  failedCalls: 0,
  avgResponseTime: 0,
  totalTokens: 0,
  totalCost: 0,
  platformDistribution: [],
  timeSeriesData: []
})

// 性能指标
const performanceMetrics = reactive({
  avgResponseTime: 0,
  p95ResponseTime: 0,
  p99ResponseTime: 0,
  errorRate: 0,
  throughput: 0,
  concurrentUsers: 0
})

// 成本分析
const costAnalysis = reactive({
  totalCost: 0,
  costTrend: [],
  costByPlatform: [],
  costByAgent: []
})

// 调用记录
const callRecords = ref<CallRecordDTO[]>([])
const recordsLoading = ref(false)
const agents = ref<AgentDTO[]>([])

// 筛选条件
const recordFilters = reactive({
  agentId: '',
  platformType: '',
  status: ''
})

// 分页
const recordPagination = reactive({
  pageNum: 1,
  pageSize: 20,
  total: 0
})

// 对话框
const recordDetailVisible = ref(false)
const selectedRecord = ref<CallRecordDTO | null>(null)

// 图表引用
const trendChart = ref<HTMLElement>()
const platformChart = ref<HTMLElement>()
const costChart = ref<HTMLElement>()

// 图表实例
let trendChartInstance: echarts.ECharts | null = null
let platformChartInstance: echarts.ECharts | null = null
let costChartInstance: echarts.ECharts | null = null

// ===== 方法定义 =====

// 初始化默认时间范围（最近7天）
const initTimeRange = () => {
  const now = new Date()
  const endTime = now.toISOString().slice(0, 19).replace('T', ' ')
  const startTime = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000)
    .toISOString().slice(0, 19).replace('T', ' ')
  timeRange.value = [startTime, endTime]
}

// 处理时间范围变化
const handleTimeRangeChange = () => {
  refreshData()
}

// 处理预设时间范围
const handlePresetTimeRange = (range: string) => {
  const now = new Date()
  const endTime = now.toISOString().slice(0, 19).replace('T', ' ')
  let startTime = ''
  
  switch (range) {
    case 'day':
      startTime = new Date(now.getTime() - 24 * 60 * 60 * 1000)
        .toISOString().slice(0, 19).replace('T', ' ')
      break
    case 'week':
      startTime = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000)
        .toISOString().slice(0, 19).replace('T', ' ')
      break
    case 'month':
      startTime = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000)
        .toISOString().slice(0, 19).replace('T', ' ')
      break
    case 'quarter':
      startTime = new Date(now.getTime() - 90 * 24 * 60 * 60 * 1000)
        .toISOString().slice(0, 19).replace('T', ' ')
      break
    case 'year':
      startTime = new Date(now.getTime() - 365 * 24 * 60 * 60 * 1000)
        .toISOString().slice(0, 19).replace('T', ' ')
      break
  }
  
  timeRange.value = [startTime, endTime]
  refreshData()
}

// 刷新数据
const refreshData = async () => {
  await Promise.all([
    loadStatistics(),
    loadPerformanceMetrics(),
    loadCostAnalysis(),
    loadCallRecords()
  ])
  
  // 更新图表
  await nextTick()
  updateCharts()
}

// 加载统计数据
const loadStatistics = async () => {
  try {
    const params = {
      startTime: timeRange.value[0],
      endTime: timeRange.value[1]
    }
    const response = await agentApi.getCallStatistics(params)
    if (response.code === 200) {
      Object.assign(statistics, response.data)
    }
  } catch (error) {
    console.error('加载统计数据失败:', error)
  }
}

// 加载性能指标
const loadPerformanceMetrics = async () => {
  try {
    const params = {
      timeRange: selectedTimeRange.value
    }
    const response = await agentApi.getPerformanceMetrics(params)
    if (response.code === 200) {
      Object.assign(performanceMetrics, response.data)
    }
  } catch (error) {
    console.error('加载性能指标失败:', error)
  }
}

// 加载成本分析
const loadCostAnalysis = async () => {
  try {
    const params = {
      timeRange: selectedTimeRange.value,
      groupBy: 'platform'
    }
    const response = await agentApi.getCostAnalysis(params)
    if (response.code === 200) {
      Object.assign(costAnalysis, response.data)
    }
  } catch (error) {
    console.error('加载成本分析失败:', error)
  }
}

// 加载调用记录
const loadCallRecords = async () => {
  recordsLoading.value = true
  try {
    const params = {
      ...recordFilters,
      startTime: timeRange.value[0],
      endTime: timeRange.value[1],
      pageNum: recordPagination.pageNum,
      pageSize: recordPagination.pageSize
    }
    
    const response = await agentApi.getCallRecords(params)
    if (response.code === 200) {
      callRecords.value = response.data.records
      recordPagination.total = response.data.total
    }
  } catch (error) {
    console.error('加载调用记录失败:', error)
    ElMessage.error('加载调用记录失败')
  } finally {
    recordsLoading.value = false
  }
}

// 加载智能体列表
const loadAgents = async () => {
  try {
    const response = await agentApi.getAgentList({
      pageNum: 1,
      pageSize: 1000,
      status: 'ACTIVE'
    })
    if (response.code === 200) {
      agents.value = response.data.records
    }
  } catch (error) {
    console.error('加载智能体列表失败:', error)
  }
}

// 搜索记录
const searchRecords = () => {
  recordPagination.pageNum = 1
  loadCallRecords()
}

// 分页处理
const handlePageChange = (page: number) => {
  recordPagination.pageNum = page
  loadCallRecords()
}

const handlePageSizeChange = (size: number) => {
  recordPagination.pageSize = size
  recordPagination.pageNum = 1
  loadCallRecords()
}

// 查看记录详情
const viewRecordDetail = async (record: CallRecordDTO) => {
  try {
    const response = await agentApi.getCallRecord(record.id)
    if (response.code === 200) {
      selectedRecord.value = response.data
      recordDetailVisible.value = true
    }
  } catch (error) {
    console.error('加载记录详情失败:', error)
    ElMessage.error('加载记录详情失败')
  }
}

// 初始化图表
const initCharts = () => {
  if (trendChart.value) {
    trendChartInstance = echarts.init(trendChart.value)
  }
  if (platformChart.value) {
    platformChartInstance = echarts.init(platformChart.value)
  }
  if (costChart.value) {
    costChartInstance = echarts.init(costChart.value)
  }
}

// 更新图表
const updateCharts = () => {
  updateTrendChart()
  updatePlatformChart()
  updateCostChart()
}

// 更新趋势图
const updateTrendChart = () => {
  if (!trendChartInstance) return
  
  const dates = statistics.timeSeriesData.map(item => item.date)
  let seriesData: number[] = []
  let yAxisName = ''
  
  switch (trendChartType.value) {
    case 'calls':
      seriesData = statistics.timeSeriesData.map(item => item.calls)
      yAxisName = '调用次数'
      break
    case 'tokens':
      seriesData = statistics.timeSeriesData.map(item => item.tokens)
      yAxisName = 'Token数量'
      break
    case 'cost':
      seriesData = statistics.timeSeriesData.map(item => item.cost)
      yAxisName = '成本(元)'
      break
  }
  
  const option = {
    title: {
      text: '调用趋势'
    },
    tooltip: {
      trigger: 'axis'
    },
    xAxis: {
      type: 'category',
      data: dates
    },
    yAxis: {
      type: 'value',
      name: yAxisName
    },
    series: [{
      data: seriesData,
      type: 'line',
      smooth: true,
      areaStyle: {
        opacity: 0.3
      }
    }]
  }
  
  trendChartInstance.setOption(option)
}

// 更新平台分布图
const updatePlatformChart = () => {
  if (!platformChartInstance) return
  
  const data = statistics.platformDistribution.map(item => ({
    name: getPlatformName(item.platform),
    value: item.count
  }))
  
  const option = {
    tooltip: {
      trigger: 'item',
      formatter: '{a} <br/>{b}: {c} ({d}%)'
    },
    series: [{
      name: '平台分布',
      type: 'pie',
      radius: ['40%', '70%'],
      data: data,
      emphasis: {
        itemStyle: {
          shadowBlur: 10,
          shadowOffsetX: 0,
          shadowColor: 'rgba(0, 0, 0, 0.5)'
        }
      }
    }]
  }
  
  platformChartInstance.setOption(option)
}

// 更新成本图表
const updateCostChart = () => {
  if (!costChartInstance) return
  
  const data = costAnalysis.costByPlatform.map(item => ({
    name: getPlatformName(item.platform),
    value: item.cost
  }))
  
  const option = {
    tooltip: {
      trigger: 'item',
      formatter: '{a} <br/>{b}: ¥{c} ({d}%)'
    },
    series: [{
      name: '成本分布',
      type: 'pie',
      radius: '60%',
      data: data,
      emphasis: {
        itemStyle: {
          shadowBlur: 10,
          shadowOffsetX: 0,
          shadowColor: 'rgba(0, 0, 0, 0.5)'
        }
      }
    }]
  }
  
  costChartInstance.setOption(option)
}

// 工具函数
const getPlatformName = (platform: string) => {
  const platformMap: Record<string, string> = {
    dify: 'Dify',
    coze: 'Coze',
    openai: 'OpenAI',
    claude: 'Claude',
    gemini: 'Gemini'
  }
  return platformMap[platform] || platform
}

const getPlatformTagType = (platform: string) => {
  const typeMap: Record<string, string> = {
    dify: 'primary',
    coze: 'success',
    openai: 'warning',
    claude: 'info',
    gemini: 'danger'
  }
  return typeMap[platform] || ''
}

const getStatusText = (status: string) => {
  const statusMap: Record<string, string> = {
    success: '成功',
    failed: '失败',
    timeout: '超时',
    error: '错误'
  }
  return statusMap[status] || status
}

const getStatusTagType = (status: string) => {
  const typeMap: Record<string, string> = {
    success: 'success',
    failed: 'danger',
    timeout: 'warning',
    error: 'danger'
  }
  return typeMap[status] || ''
}

const formatDate = (dateStr: string) => {
  return new Date(dateStr).toLocaleString('zh-CN')
}

// ===== 生命周期 =====
onMounted(async () => {
  initTimeRange()
  await loadAgents()
  await refreshData()
  
  await nextTick()
  initCharts()
  updateCharts()
  
  // 监听窗口大小变化
  window.addEventListener('resize', () => {
    trendChartInstance?.resize()
    platformChartInstance?.resize()
    costChartInstance?.resize()
  })
})
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.monitoring-dashboard {
  padding: 20px;

  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 24px;

    .page-title {
      h2 {
        margin: 0 0 8px 0;
        color: $text-color-primary;
        font-size: 24px;
        font-weight: 600;
      }

      p {
        margin: 0;
        color: $text-color-secondary;
        font-size: 14px;
      }
    }

    .time-selector {
      display: flex;
      align-items: center;
    }
  }

  .overview-cards {
    .stat-card {
      display: flex;
      align-items: center;
      padding: 24px;
      background: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);

      .stat-icon {
        width: 48px;
        height: 48px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 16px;

        .el-icon {
          font-size: 24px;
          color: #fff;
        }

        &.total {
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        &.success {
          background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }

        &.response {
          background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
        }

        &.cost {
          background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
        }
      }

      .stat-content {
        .stat-value {
          font-size: 24px;
          font-weight: 600;
          color: $text-color-primary;
          margin-bottom: 4px;
        }

        .stat-label {
          font-size: 14px;
          color: $text-color-secondary;
        }
      }
    }
  }

  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;

    .filter-actions {
      display: flex;
      align-items: center;
    }
  }

  .performance-metrics {
    .metric-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 12px 0;
      border-bottom: 1px solid $border-color-lighter;

      &:last-child {
        border-bottom: none;
      }

      .metric-label {
        color: $text-color-secondary;
        font-size: 14px;
      }

      .metric-value {
        color: $text-color-primary;
        font-size: 16px;
        font-weight: 500;
      }
    }
  }

  .pagination-wrapper {
    display: flex;
    justify-content: center;
    margin-top: 24px;
  }
}
</style>