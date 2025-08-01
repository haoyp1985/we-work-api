<template>
  <div class="monitor-chart">
    <div v-if="title || $slots.header" class="chart-header">
      <div class="chart-title">
        <slot name="header">
          <h4>{{ title }}</h4>
        </slot>
      </div>
      <div v-if="$slots.controls" class="chart-controls">
        <slot name="controls" />
      </div>
    </div>
    
    <div 
      ref="chartRef" 
      class="chart-container"
      :style="{ height: height }"
      v-loading="loading"
    ></div>
    
    <div v-if="$slots.footer" class="chart-footer">
      <slot name="footer" />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, watch, nextTick } from 'vue'
import * as echarts from 'echarts'

// Props
interface Props {
  title?: string
  height?: string
  loading?: boolean
  data?: any[]
  chartType?: 'line' | 'bar' | 'pie' | 'gauge' | 'scatter' | 'area'
  options?: any
  theme?: 'light' | 'dark' | 'auto'
  autoResize?: boolean
  animation?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  height: '300px',
  loading: false,
  chartType: 'line',
  theme: 'auto',
  autoResize: true,
  animation: true
})

// Emits
const emit = defineEmits<{
  chartReady: [chart: echarts.ECharts]
  chartClick: [params: any]
  chartHover: [params: any]
}>()

// Refs
const chartRef = ref<HTMLElement>()
const chart = ref<echarts.ECharts>()

// Methods
const initChart = async () => {
  if (!chartRef.value) return
  
  await nextTick()
  
  // 销毁已存在的图表
  if (chart.value) {
    chart.value.dispose()
  }
  
  // 创建新图表
  chart.value = echarts.init(
    chartRef.value,
    props.theme === 'auto' ? undefined : props.theme
  )
  
  // 设置图表配置
  updateChart()
  
  // 添加事件监听
  chart.value.on('click', (params) => {
    emit('chartClick', params)
  })
  
  chart.value.on('mouseover', (params) => {
    emit('chartHover', params)
  })
  
  // 发出就绪事件
  emit('chartReady', chart.value)
}

const updateChart = () => {
  if (!chart.value) return
  
  const option = props.options || generateDefaultOptions()
  
  chart.value.setOption(option, true)
}

const generateDefaultOptions = () => {
  if (!props.data || props.data.length === 0) {
    return getEmptyChartOption()
  }
  
  switch (props.chartType) {
    case 'line':
    case 'area':
      return generateLineChartOptions()
    case 'bar':
      return generateBarChartOptions()
    case 'pie':
      return generatePieChartOptions()
    case 'gauge':
      return generateGaugeChartOptions()
    case 'scatter':
      return generateScatterChartOptions()
    default:
      return generateLineChartOptions()
  }
}

const generateLineChartOptions = () => {
  const xAxisData = props.data?.map(item => item.name || item.label || item.x) || []
  const seriesData = props.data?.map(item => item.value || item.y) || []
  
  return {
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'cross'
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
      data: xAxisData,
      axisLabel: {
        fontSize: 12
      }
    },
    yAxis: {
      type: 'value',
      axisLabel: {
        fontSize: 12
      }
    },
    series: [
      {
        type: 'line',
        smooth: true,
        data: seriesData,
        itemStyle: {
          color: '#409EFF'
        },
        areaStyle: props.chartType === 'area' ? {
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
        } : undefined,
        animation: props.animation
      }
    ]
  }
}

const generateBarChartOptions = () => {
  const xAxisData = props.data?.map(item => item.name || item.label || item.x) || []
  const seriesData = props.data?.map(item => item.value || item.y) || []
  
  return {
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'shadow'
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
      data: xAxisData,
      axisLabel: {
        fontSize: 12
      }
    },
    yAxis: {
      type: 'value',
      axisLabel: {
        fontSize: 12
      }
    },
    series: [
      {
        type: 'bar',
        data: seriesData,
        itemStyle: {
          color: '#409EFF'
        },
        animation: props.animation
      }
    ]
  }
}

const generatePieChartOptions = () => {
  return {
    tooltip: {
      trigger: 'item',
      formatter: '{a} <br/>{b} : {c} ({d}%)'
    },
    legend: {
      orient: 'horizontal',
      bottom: '0',
      textStyle: {
        fontSize: 12
      }
    },
    series: [
      {
        name: props.title || 'Data',
        type: 'pie',
        radius: ['40%', '70%'],
        center: ['50%', '45%'],
        data: props.data || [],
        emphasis: {
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: 'rgba(0, 0, 0, 0.5)'
          }
        },
        animation: props.animation
      }
    ]
  }
}

const generateGaugeChartOptions = () => {
  const value = props.data?.[0]?.value || 0
  const max = props.data?.[0]?.max || 100
  
  return {
    series: [
      {
        name: props.title || 'Gauge',
        type: 'gauge',
        progress: {
          show: true
        },
        detail: {
          valueAnimation: props.animation,
          formatter: '{value}%'
        },
        data: [
          {
            value: value,
            name: props.title || 'Progress'
          }
        ],
        max: max,
        animation: props.animation
      }
    ]
  }
}

const generateScatterChartOptions = () => {
  return {
    tooltip: {
      trigger: 'item',
      formatter: '{a} <br/>{b} : ({c})'
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '3%',
      containLabel: true
    },
    xAxis: {
      type: 'value',
      axisLabel: {
        fontSize: 12
      }
    },
    yAxis: {
      type: 'value',
      axisLabel: {
        fontSize: 12
      }
    },
    series: [
      {
        name: props.title || 'Scatter',
        type: 'scatter',
        data: props.data?.map(item => [item.x, item.y]) || [],
        itemStyle: {
          color: '#409EFF'
        },
        animation: props.animation
      }
    ]
  }
}

const getEmptyChartOption = () => {
  return {
    title: {
      text: '暂无数据',
      left: 'center',
      top: 'center',
      textStyle: {
        color: '#999',
        fontSize: 14
      }
    }
  }
}

const resizeChart = () => {
  if (chart.value) {
    chart.value.resize()
  }
}

const refreshChart = () => {
  updateChart()
}

// 暴露方法
defineExpose({
  refreshChart,
  resizeChart,
  getChart: () => chart.value
})

// Watchers
watch(() => props.data, () => {
  updateChart()
}, { deep: true })

watch(() => props.options, () => {
  updateChart()
}, { deep: true })

watch(() => props.loading, (newVal) => {
  if (!newVal && !chart.value) {
    initChart()
  }
})

// Lifecycle
onMounted(() => {
  if (!props.loading) {
    initChart()
  }
  
  if (props.autoResize) {
    window.addEventListener('resize', resizeChart)
  }
})

onUnmounted(() => {
  if (chart.value) {
    chart.value.dispose()
  }
  
  if (props.autoResize) {
    window.removeEventListener('resize', resizeChart)
  }
})
</script>

<style scoped lang="scss">
.monitor-chart {
  .chart-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
    
    .chart-title {
      h4 {
        margin: 0;
        font-size: 16px;
        font-weight: 500;
        color: var(--el-text-color-primary);
      }
    }
    
    .chart-controls {
      display: flex;
      gap: 8px;
      align-items: center;
    }
  }
  
  .chart-container {
    width: 100%;
    min-height: 200px;
    border-radius: 4px;
  }
  
  .chart-footer {
    margin-top: 12px;
    padding-top: 12px;
    border-top: 1px solid var(--el-border-color-lighter);
    font-size: 12px;
    color: var(--el-text-color-secondary);
  }
}
</style>