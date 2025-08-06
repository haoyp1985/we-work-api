<template>
  <div class="base-chart">
    <div 
      ref="chartRef" 
      :style="{ width: width, height: height }"
      class="chart-container"
    />
    <div v-if="loading" class="chart-loading">
      <el-icon class="is-loading"><Loading /></el-icon>
      <span>{{ loadingText }}</span>
    </div>
    <div v-if="error" class="chart-error">
      <el-icon><Warning /></el-icon>
      <span>{{ error }}</span>
      <el-button size="small" @click="handleRetry">重试</el-button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, watch, nextTick } from 'vue'
import { Loading, Warning } from '@element-plus/icons-vue'
import * as echarts from 'echarts'
import type { ECharts, EChartsOption } from 'echarts'

interface Props {
  options: EChartsOption
  width?: string
  height?: string
  theme?: string
  loading?: boolean
  loadingText?: string
  error?: string
  autoResize?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  width: '100%',
  height: '400px',
  theme: 'default',
  loading: false,
  loadingText: '加载中...',
  error: '',
  autoResize: true
})

const emit = defineEmits<{
  chartReady: [chart: ECharts]
  chartClick: [params: any]
  chartDblClick: [params: any]
  chartMouseover: [params: any]
  chartMouseout: [params: any]
  retry: []
}>()

const chartRef = ref<HTMLDivElement>()
const chartInstance = ref<ECharts>()
const resizeObserver = ref<ResizeObserver>()

// 初始化图表
const initChart = async () => {
  if (!chartRef.value) return
  
  await nextTick()
  
  // 销毁旧实例
  if (chartInstance.value) {
    chartInstance.value.dispose()
  }
  
  // 创建新实例
  chartInstance.value = echarts.init(chartRef.value, props.theme)
  
  // 设置图表选项
  chartInstance.value.setOption(props.options, true)
  
  // 绑定事件
  chartInstance.value.on('click', (params) => {
    emit('chartClick', params)
  })
  
  chartInstance.value.on('dblclick', (params) => {
    emit('chartDblClick', params)
  })
  
  chartInstance.value.on('mouseover', (params) => {
    emit('chartMouseover', params)
  })
  
  chartInstance.value.on('mouseout', (params) => {
    emit('chartMouseout', params)
  })
  
  // 设置自动调整大小
  if (props.autoResize) {
    setupResize()
  }
  
  emit('chartReady', chartInstance.value)
}

// 设置自动调整大小
const setupResize = () => {
  if (!chartRef.value || !chartInstance.value) return
  
  // 使用 ResizeObserver 监听容器大小变化
  resizeObserver.value = new ResizeObserver(() => {
    if (chartInstance.value) {
      chartInstance.value.resize()
    }
  })
  
  resizeObserver.value.observe(chartRef.value)
  
  // 监听窗口大小变化
  window.addEventListener('resize', handleWindowResize)
}

// 处理窗口大小变化
const handleWindowResize = () => {
  if (chartInstance.value) {
    chartInstance.value.resize()
  }
}

// 重试处理
const handleRetry = () => {
  emit('retry')
}

// 监听配置变化
watch(
  () => props.options,
  (newOptions) => {
    if (chartInstance.value && newOptions) {
      chartInstance.value.setOption(newOptions, true)
    }
  },
  { deep: true }
)

// 监听主题变化
watch(
  () => props.theme,
  () => {
    initChart()
  }
)

// 监听加载状态
watch(
  () => props.loading,
  (loading) => {
    if (chartInstance.value) {
      if (loading) {
        chartInstance.value.showLoading('default', {
          text: props.loadingText,
          color: '#409eff',
          textColor: '#000',
          maskColor: 'rgba(255, 255, 255, 0.8)',
          zlevel: 0
        })
      } else {
        chartInstance.value.hideLoading()
      }
    }
  }
)

// 暴露方法
const resize = () => {
  if (chartInstance.value) {
    chartInstance.value.resize()
  }
}

const getDataURL = (options?: {
  type?: string
  pixelRatio?: number
  backgroundColor?: string
  excludeComponents?: string[]
}) => {
  if (chartInstance.value) {
    return chartInstance.value.getDataURL(options)
  }
  return ''
}

const getOption = () => {
  if (chartInstance.value) {
    return chartInstance.value.getOption()
  }
  return null
}

const clear = () => {
  if (chartInstance.value) {
    chartInstance.value.clear()
  }
}

defineExpose({
  chartInstance,
  resize,
  getDataURL,
  getOption,
  clear
})

// 生命周期
onMounted(() => {
  initChart()
})

onUnmounted(() => {
  // 清理资源
  if (chartInstance.value) {
    chartInstance.value.dispose()
    chartInstance.value = undefined
  }
  
  if (resizeObserver.value) {
    resizeObserver.value.disconnect()
  }
  
  window.removeEventListener('resize', handleWindowResize)
})
</script>

<style scoped lang="scss">
.base-chart {
  position: relative;
  width: 100%;
  height: 100%;

  .chart-container {
    width: 100%;
    height: 100%;
  }

  .chart-loading {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    background: rgba(255, 255, 255, 0.8);
    color: #666;
    font-size: 14px;
    z-index: 100;

    .el-icon {
      font-size: 24px;
      margin-bottom: 8px;
      color: #409eff;
    }
  }

  .chart-error {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    background: rgba(255, 255, 255, 0.95);
    color: #666;
    font-size: 14px;
    z-index: 100;

    .el-icon {
      font-size: 24px;
      margin-bottom: 8px;
      color: #f56c6c;
    }

    .el-button {
      margin-top: 12px;
    }
  }
}
</style>