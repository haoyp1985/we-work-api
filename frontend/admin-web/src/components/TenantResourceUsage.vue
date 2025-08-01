<template>
  <div class="tenant-resource-usage">
    <el-card shadow="never" class="usage-card">
      <template #header>
        <div class="card-header">
          <span class="title">
            <el-icon><DataBoard /></el-icon>
            资源使用情况
          </span>
          <el-button
            type="primary"
            link
            size="small"
            @click="refreshData"
            :loading="loading"
          >
            <el-icon><Refresh /></el-icon>
            刷新
          </el-button>
        </div>
      </template>

      <div v-loading="loading" class="usage-content">
        <div class="usage-grid">
          <!-- 账号使用量 -->
          <div class="usage-item">
            <div class="usage-header">
              <div class="usage-title">
                <el-icon class="icon-account"><User /></el-icon>
                企微账号
              </div>
              <div class="usage-value">
                {{ resourceStats?.accountUsage.current || 0 }} / 
                {{ resourceStats?.accountUsage.limit || 0 }}
              </div>
            </div>
            <el-progress
              :percentage="resourceStats?.accountUsage.percentage || 0"
              :color="getProgressColor(resourceStats?.accountUsage.percentage || 0)"
              :stroke-width="8"
              class="usage-progress"
            />
            <div class="usage-detail">
              <span class="detail-text">
                剩余: {{ (resourceStats?.accountUsage.limit || 0) - (resourceStats?.accountUsage.current || 0) }}
              </span>
            </div>
          </div>

          <!-- 消息使用量 -->
          <div class="usage-item">
            <div class="usage-header">
              <div class="usage-title">
                <el-icon class="icon-message"><ChatLineRound /></el-icon>
                每日消息
              </div>
              <div class="usage-value">
                {{ formatNumber(resourceStats?.messageUsage.current || 0) }} / 
                {{ formatNumber(resourceStats?.messageUsage.limit || 0) }}
              </div>
            </div>
            <el-progress
              :percentage="resourceStats?.messageUsage.percentage || 0"
              :color="getProgressColor(resourceStats?.messageUsage.percentage || 0)"
              :stroke-width="8"
              class="usage-progress"
            />
            <div class="usage-detail">
              <span class="detail-text">
                剩余: {{ formatNumber((resourceStats?.messageUsage.limit || 0) - (resourceStats?.messageUsage.current || 0)) }}
              </span>
            </div>
          </div>

          <!-- API调用量 -->
          <div class="usage-item">
            <div class="usage-header">
              <div class="usage-title">
                <el-icon class="icon-api"><Connection /></el-icon>
                API调用
              </div>
              <div class="usage-value">
                {{ formatNumber(resourceStats?.apiUsage.current || 0) }} / 
                {{ formatNumber(resourceStats?.apiUsage.limit || 0) }}
              </div>
            </div>
            <el-progress
              :percentage="resourceStats?.apiUsage.percentage || 0"
              :color="getProgressColor(resourceStats?.apiUsage.percentage || 0)"
              :stroke-width="8"
              class="usage-progress"
            />
            <div class="usage-detail">
              <span class="detail-text">
                剩余: {{ formatNumber((resourceStats?.apiUsage.limit || 0) - (resourceStats?.apiUsage.current || 0)) }}
              </span>
            </div>
          </div>

          <!-- 存储使用量 -->
          <div class="usage-item">
            <div class="usage-header">
              <div class="usage-title">
                <el-icon class="icon-storage"><FolderOpened /></el-icon>
                存储空间
              </div>
              <div class="usage-value">
                {{ formatStorage(resourceStats?.storageUsage.current || 0) }} / 
                {{ formatStorage(resourceStats?.storageUsage.limit || 0) }}
              </div>
            </div>
            <el-progress
              :percentage="resourceStats?.storageUsage.percentage || 0"
              :color="getProgressColor(resourceStats?.storageUsage.percentage || 0)"
              :stroke-width="8"
              class="usage-progress"
            />
            <div class="usage-detail">
              <span class="detail-text">
                剩余: {{ formatStorage((resourceStats?.storageUsage.limit || 0) - (resourceStats?.storageUsage.current || 0)) }}
              </span>
            </div>
          </div>

          <!-- 带宽使用量 -->
          <div class="usage-item">
            <div class="usage-header">
              <div class="usage-title">
                <el-icon class="icon-bandwidth"><Lightning /></el-icon>
                带宽
              </div>
              <div class="usage-value">
                {{ formatBandwidth(resourceStats?.bandwidthUsage.current || 0) }} / 
                {{ formatBandwidth(resourceStats?.bandwidthUsage.limit || 0) }}
              </div>
            </div>
            <el-progress
              :percentage="resourceStats?.bandwidthUsage.percentage || 0"
              :color="getProgressColor(resourceStats?.bandwidthUsage.percentage || 0)"
              :stroke-width="8"
              class="usage-progress"
            />
            <div class="usage-detail">
              <span class="detail-text">
                剩余: {{ formatBandwidth((resourceStats?.bandwidthUsage.limit || 0) - (resourceStats?.bandwidthUsage.current || 0)) }}
              </span>
            </div>
          </div>
        </div>

        <!-- 使用趋势图表 -->
        <div v-if="showTrend" class="usage-trend">
          <div class="trend-header">
            <h4>使用趋势 (最近7天)</h4>
            <el-button-group size="small">
              <el-button 
                v-for="item in trendOptions"
                :key="item.key"
                :type="selectedTrend === item.key ? 'primary' : ''"
                @click="selectedTrend = item.key"
              >
                {{ item.label }}
              </el-button>
            </el-button-group>
          </div>
          <div class="trend-chart" ref="chartRef"></div>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch, nextTick } from 'vue'
import { ElMessage } from 'element-plus'
import {
  DataBoard,
  Refresh,
  User,
  ChatLineRound,
  Connection,
  FolderOpened,
  Lightning
} from '@element-plus/icons-vue'
import * as echarts from 'echarts'
import { getTenantResourceStats } from '@/api/tenant'
import { useTenantStore } from '@/stores'

// Props
interface Props {
  tenantId?: string
  showTrend?: boolean
  autoRefresh?: boolean
  refreshInterval?: number
}

const props = withDefaults(defineProps<Props>(), {
  showTrend: true,
  autoRefresh: false,
  refreshInterval: 60000 // 1分钟
})

// Store
const tenantStore = useTenantStore()

// Refs
const chartRef = ref<HTMLElement>()
const chart = ref<echarts.ECharts>()

// Reactive Data
const loading = ref(false)
const resourceStats = ref<any>(null)
const selectedTrend = ref('accounts')

// Computed
const currentTenantId = computed(() => 
  props.tenantId || tenantStore.currentTenant?.id
)

const trendOptions = [
  { key: 'accounts', label: '账号' },
  { key: 'messages', label: '消息' },
  { key: 'apiCalls', label: 'API' },
  { key: 'storage', label: '存储' },
  { key: 'bandwidth', label: '带宽' }
]

// Methods
const loadResourceStats = async () => {
  if (!currentTenantId.value) {
    return
  }
  
  try {
    loading.value = true
    const response = await getTenantResourceStats(currentTenantId.value)
    resourceStats.value = response.data
    
    // 更新图表
    if (props.showTrend) {
      await nextTick()
      updateChart()
    }
    
  } catch (error: any) {
    console.error('Load resource stats error:', error)
    ElMessage.error(error.message || '获取资源统计失败')
  } finally {
    loading.value = false
  }
}

const refreshData = () => {
  loadResourceStats()
}

const getProgressColor = (percentage: number): string => {
  if (percentage < 70) return '#67c23a'
  if (percentage < 90) return '#e6a23c'
  return '#f56c6c'
}

const formatNumber = (num: number): string => {
  if (num >= 1000000) {
    return (num / 1000000).toFixed(1) + 'M'
  }
  if (num >= 1000) {
    return (num / 1000).toFixed(1) + 'K'
  }
  return num.toString()
}

const formatStorage = (gb: number): string => {
  if (gb >= 1024) {
    return (gb / 1024).toFixed(1) + 'TB'
  }
  return gb.toFixed(1) + 'GB'
}

const formatBandwidth = (mbps: number): string => {
  if (mbps >= 1000) {
    return (mbps / 1000).toFixed(1) + 'Gbps'
  }
  return mbps.toFixed(1) + 'Mbps'
}

const initChart = () => {
  if (!chartRef.value) return
  
  chart.value = echarts.init(chartRef.value)
  updateChart()
  
  // 响应式
  window.addEventListener('resize', () => {
    chart.value?.resize()
  })
}

const updateChart = () => {
  if (!chart.value || !resourceStats.value?.usageTrend) return
  
  const trendData = resourceStats.value.usageTrend
  const dates = trendData.map((item: any) => item.date)
  
  let seriesData: number[] = []
  let title = ''
  let unit = ''
  
  switch (selectedTrend.value) {
    case 'accounts':
      seriesData = trendData.map((item: any) => item.accounts)
      title = '账号数量'
      unit = '个'
      break
    case 'messages':
      seriesData = trendData.map((item: any) => item.messages)
      title = '消息数量'
      unit = '条'
      break
    case 'apiCalls':
      seriesData = trendData.map((item: any) => item.apiCalls)
      title = 'API调用'
      unit = '次'
      break
    case 'storage':
      seriesData = trendData.map((item: any) => item.storage)
      title = '存储使用'
      unit = 'GB'
      break
    case 'bandwidth':
      seriesData = trendData.map((item: any) => item.bandwidth)
      title = '带宽使用'
      unit = 'MB'
      break
  }
  
  const option = {
    title: {
      text: title,
      left: 'center',
      textStyle: {
        fontSize: 14,
        color: '#333'
      }
    },
    tooltip: {
      trigger: 'axis',
      formatter: (params: any) => {
        const data = params[0]
        return `${data.name}<br/>${data.seriesName}: ${data.value}${unit}`
      }
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '3%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: dates,
      axisLabel: {
        fontSize: 12
      }
    },
    yAxis: {
      type: 'value',
      axisLabel: {
        fontSize: 12,
        formatter: (value: number) => value + unit
      }
    },
    series: [
      {
        name: title,
        type: 'line',
        smooth: true,
        data: seriesData,
        itemStyle: {
          color: '#409EFF'
        },
        areaStyle: {
          color: {
            type: 'linear',
            x: 0,
            y: 0,
            x2: 0,
            y2: 1,
            colorStops: [
              {
                offset: 0,
                color: 'rgba(64, 158, 255, 0.2)'
              },
              {
                offset: 1,
                color: 'rgba(64, 158, 255, 0)'
              }
            ]
          }
        }
      }
    ]
  }
  
  chart.value.setOption(option)
}

// Watchers
watch(currentTenantId, () => {
  loadResourceStats()
})

watch(selectedTrend, () => {
  updateChart()
})

// Lifecycle
onMounted(() => {
  loadResourceStats()
  
  if (props.showTrend) {
    nextTick(() => {
      initChart()
    })
  }
  
  // 自动刷新
  if (props.autoRefresh) {
    setInterval(loadResourceStats, props.refreshInterval)
  }
})
</script>

<style scoped lang="scss">
.tenant-resource-usage {
  .usage-card {
    border: none;
    
    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      
      .title {
        display: flex;
        align-items: center;
        gap: 8px;
        font-weight: 500;
        color: var(--el-text-color-primary);
      }
    }
  }
  
  .usage-content {
    .usage-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 24px;
      margin-bottom: 32px;
      
      .usage-item {
        background: var(--el-bg-color-page);
        border: 1px solid var(--el-border-color-light);
        border-radius: 8px;
        padding: 20px;
        
        .usage-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 12px;
          
          .usage-title {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 500;
            color: var(--el-text-color-primary);
            
            .el-icon {
              &.icon-account { color: #409EFF; }
              &.icon-message { color: #67C23A; }
              &.icon-api { color: #E6A23C; }
              &.icon-storage { color: #F56C6C; }
              &.icon-bandwidth { color: #909399; }
            }
          }
          
          .usage-value {
            font-size: 16px;
            font-weight: 600;
            color: var(--el-text-color-primary);
          }
        }
        
        .usage-progress {
          margin-bottom: 8px;
        }
        
        .usage-detail {
          display: flex;
          justify-content: space-between;
          align-items: center;
          
          .detail-text {
            font-size: 12px;
            color: var(--el-text-color-secondary);
          }
        }
      }
    }
    
    .usage-trend {
      .trend-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 16px;
        
        h4 {
          margin: 0;
          font-size: 16px;
          font-weight: 500;
          color: var(--el-text-color-primary);
        }
      }
      
      .trend-chart {
        height: 300px;
        width: 100%;
      }
    }
  }
}
</style>