<template>
  <el-card 
    :shadow="shadow" 
    :class="['stats-card', `stats-card--${variant}`, { 'is-loading': loading }]"
  >
    <div v-loading="loading" class="stats-content">
      <!-- 卡片头部 -->
      <div class="stats-header">
        <div class="stats-icon-wrapper" :class="`icon-${iconColor}`">
          <el-icon :size="iconSize">
            <component :is="icon" />
          </el-icon>
        </div>
        <div v-if="showTrend" class="stats-trend" :class="`trend-${trendType}`">
          <el-icon :size="14">
            <ArrowUp v-if="trendType === 'up'" />
            <ArrowDown v-if="trendType === 'down'" />
            <Minus v-if="trendType === 'flat'" />
          </el-icon>
          <span class="trend-value">{{ formatTrendValue(trendValue) }}</span>
        </div>
      </div>

      <!-- 主要数据 -->
      <div class="stats-main">
        <div class="stats-value">
          <span class="value-number">{{ formattedValue }}</span>
          <span v-if="unit" class="value-unit">{{ unit }}</span>
        </div>
        <div class="stats-title">{{ title }}</div>
      </div>

      <!-- 副标题/描述 -->
      <div v-if="subtitle || $slots.subtitle" class="stats-subtitle">
        <slot name="subtitle">
          {{ subtitle }}
        </slot>
      </div>

      <!-- 进度条 -->
      <div v-if="showProgress" class="stats-progress">
        <el-progress
          :percentage="progressPercentage"
          :color="progressColor"
          :stroke-width="4"
          :show-text="false"
        />
        <div class="progress-info">
          <span class="progress-text">{{ progressText }}</span>
          <span class="progress-value">{{ progressPercentage }}%</span>
        </div>
      </div>

      <!-- 额外内容 -->
      <div v-if="$slots.extra" class="stats-extra">
        <slot name="extra" />
      </div>

      <!-- 操作按钮 -->
      <div v-if="$slots.actions" class="stats-actions">
        <slot name="actions" />
      </div>
    </div>
  </el-card>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { ArrowUp, ArrowDown, Minus } from '@element-plus/icons-vue'

// Props
interface Props {
  // 基础数据
  title: string
  value: number | string
  unit?: string
  subtitle?: string
  icon?: any
  
  // 样式控制
  variant?: 'default' | 'primary' | 'success' | 'warning' | 'danger' | 'info'
  shadow?: 'always' | 'hover' | 'never'
  iconColor?: 'primary' | 'success' | 'warning' | 'danger' | 'info' | 'default'
  iconSize?: number
  
  // 趋势显示
  showTrend?: boolean
  trendType?: 'up' | 'down' | 'flat'
  trendValue?: number
  trendUnit?: string
  
  // 进度条
  showProgress?: boolean
  progressPercentage?: number
  progressColor?: string | string[]
  progressText?: string
  
  // 状态
  loading?: boolean
  
  // 数值格式化
  formatter?: (value: number | string) => string
  precision?: number
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'default',
  shadow: 'hover',
  iconColor: 'default',
  iconSize: 24,
  showTrend: false,
  trendType: 'flat',
  showProgress: false,
  progressPercentage: 0,
  loading: false,
  precision: 0
})

// Computed
const formattedValue = computed(() => {
  if (props.formatter) {
    return props.formatter(props.value)
  }
  
  if (typeof props.value === 'number') {
    if (props.precision > 0) {
      return props.value.toFixed(props.precision)
    }
    
    // 自动格式化大数字
    if (props.value >= 1000000) {
      return (props.value / 1000000).toFixed(1) + 'M'
    }
    if (props.value >= 1000) {
      return (props.value / 1000).toFixed(1) + 'K'
    }
    
    return props.value.toString()
  }
  
  return props.value
})

const formatTrendValue = (value?: number): string => {
  if (value === undefined) return ''
  
  const absValue = Math.abs(value)
  let formatted = ''
  
  if (absValue >= 100) {
    formatted = absValue.toFixed(0)
  } else if (absValue >= 10) {
    formatted = absValue.toFixed(1)
  } else {
    formatted = absValue.toFixed(2)
  }
  
  return formatted + (props.trendUnit || '%')
}
</script>

<style scoped lang="scss">
.stats-card {
  border: 1px solid var(--el-border-color-light);
  transition: all 0.3s ease;
  
  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  }
  
  &.is-loading {
    .stats-content {
      min-height: 120px;
    }
  }
  
  // 变体样式
  &--primary {
    border-left: 4px solid var(--el-color-primary);
  }
  
  &--success {
    border-left: 4px solid var(--el-color-success);
  }
  
  &--warning {
    border-left: 4px solid var(--el-color-warning);
  }
  
  &--danger {
    border-left: 4px solid var(--el-color-danger);
  }
  
  &--info {
    border-left: 4px solid var(--el-color-info);
  }
  
  :deep(.el-card__body) {
    padding: 20px;
  }
}

.stats-content {
  .stats-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 16px;
    
    .stats-icon-wrapper {
      display: flex;
      align-items: center;
      justify-content: center;
      width: 48px;
      height: 48px;
      border-radius: 8px;
      background: var(--el-bg-color-page);
      
      &.icon-primary {
        background: rgba(64, 158, 255, 0.1);
        color: var(--el-color-primary);
      }
      
      &.icon-success {
        background: rgba(103, 194, 58, 0.1);
        color: var(--el-color-success);
      }
      
      &.icon-warning {
        background: rgba(230, 162, 60, 0.1);
        color: var(--el-color-warning);
      }
      
      &.icon-danger {
        background: rgba(245, 108, 108, 0.1);
        color: var(--el-color-danger);
      }
      
      &.icon-info {
        background: rgba(144, 147, 153, 0.1);
        color: var(--el-color-info);
      }
      
      &.icon-default {
        background: var(--el-bg-color-page);
        color: var(--el-text-color-secondary);
      }
    }
    
    .stats-trend {
      display: flex;
      align-items: center;
      gap: 4px;
      padding: 4px 8px;
      border-radius: 12px;
      font-size: 12px;
      font-weight: 500;
      
      &.trend-up {
        background: rgba(103, 194, 58, 0.1);
        color: var(--el-color-success);
      }
      
      &.trend-down {
        background: rgba(245, 108, 108, 0.1);
        color: var(--el-color-danger);
      }
      
      &.trend-flat {
        background: rgba(144, 147, 153, 0.1);
        color: var(--el-color-info);
      }
      
      .trend-value {
        font-weight: 600;
      }
    }
  }
  
  .stats-main {
    margin-bottom: 12px;
    
    .stats-value {
      display: flex;
      align-items: baseline;
      gap: 4px;
      margin-bottom: 4px;
      
      .value-number {
        font-size: 28px;
        font-weight: 700;
        color: var(--el-text-color-primary);
        line-height: 1;
      }
      
      .value-unit {
        font-size: 14px;
        color: var(--el-text-color-secondary);
        font-weight: 500;
      }
    }
    
    .stats-title {
      font-size: 14px;
      color: var(--el-text-color-regular);
      font-weight: 500;
      line-height: 1.4;
    }
  }
  
  .stats-subtitle {
    font-size: 12px;
    color: var(--el-text-color-secondary);
    margin-bottom: 12px;
    line-height: 1.4;
  }
  
  .stats-progress {
    margin-bottom: 12px;
    
    .progress-info {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-top: 6px;
      font-size: 12px;
      
      .progress-text {
        color: var(--el-text-color-secondary);
      }
      
      .progress-value {
        color: var(--el-text-color-primary);
        font-weight: 600;
      }
    }
  }
  
  .stats-extra {
    margin-bottom: 12px;
    padding-top: 12px;
    border-top: 1px solid var(--el-border-color-lighter);
  }
  
  .stats-actions {
    display: flex;
    gap: 8px;
    justify-content: flex-end;
    padding-top: 12px;
    border-top: 1px solid var(--el-border-color-lighter);
  }
}
</style>