<template>
  <div class="message-chart">
    <div v-if="loading" class="chart-loading">
      <el-skeleton animated>
        <template #template>
          <el-skeleton-item variant="rect" style="width: 100%; height: 300px;" />
        </template>
      </el-skeleton>
    </div>
    
    <div v-else class="chart-container">
      <v-chart 
        ref="chartRef"
        class="chart"
        :option="chartOption"
        autoresize
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { use } from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { LineChart, BarChart } from 'echarts/charts'
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent,
  DataZoomComponent
} from 'echarts/components'
import VChart from 'vue-echarts'

// 注册ECharts组件
use([
  CanvasRenderer,
  LineChart,
  BarChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent,
  DataZoomComponent
])

interface Props {
  data?: Array<{
    date: string
    sent: number
    success: number
    failed: number
  }>
  loading?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  data: () => [],
  loading: false
})

const chartRef = ref()

// 图表配置
const chartOption = computed(() => {
  const data = props.data || []
  const dates = data.map(item => item.date)
  const sentData = data.map(item => item.sent)
  const successData = data.map(item => item.success)
  const failedData = data.map(item => item.failed)

  return {
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'cross',
        crossStyle: {
          color: '#999'
        }
      },
      backgroundColor: 'rgba(255, 255, 255, 0.95)',
      borderColor: '#e4e7ed',
      borderWidth: 1,
      textStyle: {
        color: '#606266'
      },
      formatter: (params: any) => {
        let result = `<div style="font-weight: 500; margin-bottom: 8px;">${params[0].axisValue}</div>`
        params.forEach((param: any) => {
          result += `
            <div style="display: flex; align-items: center; margin-bottom: 4px;">
              <span style="display: inline-block; width: 10px; height: 10px; border-radius: 50%; background: ${param.color}; margin-right: 8px;"></span>
              <span style="flex: 1;">${param.seriesName}:</span>
              <span style="font-weight: 500; margin-left: 8px;">${param.value.toLocaleString()}</span>
            </div>
          `
        })
        return result
      }
    },
    legend: {
      data: ['总发送', '发送成功', '发送失败'],
      top: 10,
      textStyle: {
        color: '#606266'
      }
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '3%',
      top: '15%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: dates,
      axisLine: {
        lineStyle: {
          color: '#e4e7ed'
        }
      },
      axisLabel: {
        color: '#909399',
        formatter: (value: string) => {
          return new Date(value).toLocaleDateString('zh-CN', { 
            month: 'short', 
            day: 'numeric' 
          })
        }
      }
    },
    yAxis: {
      type: 'value',
      axisLine: {
        lineStyle: {
          color: '#e4e7ed'
        }
      },
      axisLabel: {
        color: '#909399',
        formatter: (value: number) => {
          if (value >= 1000) {
            return (value / 1000).toFixed(1) + 'k'
          }
          return value.toString()
        }
      },
      splitLine: {
        lineStyle: {
          color: '#f5f7fa'
        }
      }
    },
    series: [
      {
        name: '总发送',
        type: 'line',
        data: sentData,
        smooth: true,
        symbol: 'circle',
        symbolSize: 6,
        lineStyle: {
          width: 3,
          color: '#409eff'
        },
        itemStyle: {
          color: '#409eff'
        },
        areaStyle: {
          color: {
            type: 'linear',
            x: 0,
            y: 0,
            x2: 0,
            y2: 1,
            colorStops: [
              { offset: 0, color: 'rgba(64, 158, 255, 0.3)' },
              { offset: 1, color: 'rgba(64, 158, 255, 0.05)' }
            ]
          }
        }
      },
      {
        name: '发送成功',
        type: 'line',
        data: successData,
        smooth: true,
        symbol: 'circle',
        symbolSize: 6,
        lineStyle: {
          width: 3,
          color: '#67c23a'
        },
        itemStyle: {
          color: '#67c23a'
        }
      },
      {
        name: '发送失败',
        type: 'line',
        data: failedData,
        smooth: true,
        symbol: 'circle',
        symbolSize: 6,
        lineStyle: {
          width: 3,
          color: '#f56c6c'
        },
        itemStyle: {
          color: '#f56c6c'
        }
      }
    ]
  }
})

// 监听数据变化，重新渲染图表
watch(() => props.data, () => {
  if (chartRef.value) {
    chartRef.value.setOption(chartOption.value, true)
  }
}, { deep: true })
</script>

<style lang="scss" scoped>
.message-chart {
  height: 100%;
  
  .chart-loading {
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  
  .chart-container {
    height: 100%;
    
    .chart {
      height: 100%;
      width: 100%;
    }
  }
}
</style>