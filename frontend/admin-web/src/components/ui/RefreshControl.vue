<template>
  <div class="refresh-control">
    <div class="refresh-content">
      <!-- 手动刷新按钮 -->
      <el-tooltip :content="refreshTooltip" placement="top">
        <el-button
          :type="buttonType"
          :size="size"
          :circle="circle"
          :loading="refreshing"
          :disabled="disabled"
          @click="handleManualRefresh"
          :icon="refreshIcon"
        >
          <template v-if="!circle">
            {{ buttonText }}
          </template>
        </el-button>
      </el-tooltip>
      
      <!-- 自动刷新控制 -->
      <div v-if="showAutoRefresh" class="auto-refresh-control">
        <el-switch
          v-model="autoRefreshEnabled"
          :size="size"
          :disabled="disabled"
          @change="handleAutoRefreshToggle"
        />
        <span class="auto-refresh-label">自动刷新</span>
        
        <!-- 间隔设置 -->
        <el-dropdown
          v-if="showIntervalSelector && autoRefreshEnabled"
          @command="handleIntervalChange"
          trigger="click"
        >
          <el-button :size="size" link>
            {{ currentIntervalText }}
            <el-icon class="el-icon--right">
              <ArrowDown />
            </el-icon>
          </el-button>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item
                v-for="option in intervalOptions"
                :key="option.value"
                :command="option.value"
                :disabled="option.disabled"
              >
                {{ option.label }}
              </el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
      
      <!-- 状态信息 -->
      <div v-if="showStatus" class="refresh-status">
        <span class="status-text">
          <template v-if="lastRefreshTime">
            上次更新: {{ formatLastRefreshTime() }}
          </template>
          <template v-else-if="refreshing">
            正在刷新...
          </template>
          <template v-else>
            等待刷新
          </template>
        </span>
        
        <!-- 倒计时显示 -->
        <span v-if="autoRefreshEnabled && countdown > 0" class="countdown">
          ({{ countdown }}s)
        </span>
      </div>
    </div>
    
    <!-- 刷新进度条 -->
    <div v-if="showProgress && refreshing" class="refresh-progress">
      <el-progress
        :percentage="progressPercentage"
        :stroke-width="2"
        :show-text="false"
        status="success"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted, watch } from 'vue'
import { Refresh, ArrowDown } from '@element-plus/icons-vue'
import dayjs from 'dayjs'
import relativeTime from 'dayjs/plugin/relativeTime'
import 'dayjs/locale/zh-cn'

// 配置dayjs
dayjs.extend(relativeTime)
dayjs.locale('zh-cn')

// Props
interface IntervalOption {
  value: number
  label: string
  disabled?: boolean
}

interface Props {
  // 基础配置
  refreshing?: boolean
  disabled?: boolean
  size?: 'large' | 'default' | 'small'
  buttonType?: 'primary' | 'success' | 'warning' | 'danger' | 'info' | 'text' | 'default'
  circle?: boolean
  
  // 显示控制
  showAutoRefresh?: boolean
  showIntervalSelector?: boolean
  showStatus?: boolean
  showProgress?: boolean
  
  // 自动刷新
  autoRefresh?: boolean
  refreshInterval?: number
  intervalOptions?: IntervalOption[]
  
  // 文本配置
  buttonText?: string
  refreshTooltip?: string
  
  // 进度控制
  progressDuration?: number
}

const props = withDefaults(defineProps<Props>(), {
  refreshing: false,
  disabled: false,
  size: 'default',
  buttonType: 'default',
  circle: false,
  showAutoRefresh: true,
  showIntervalSelector: true,
  showStatus: true,
  showProgress: false,
  autoRefresh: false,
  refreshInterval: 30000, // 30秒
  intervalOptions: () => [
    { value: 10000, label: '10秒' },
    { value: 30000, label: '30秒' },
    { value: 60000, label: '1分钟' },
    { value: 300000, label: '5分钟' },
    { value: 600000, label: '10分钟' }
  ],
  buttonText: '刷新',
  refreshTooltip: '手动刷新数据',
  progressDuration: 2000 // 2秒
})

// Emits
const emit = defineEmits<{
  refresh: []
  autoRefreshChange: [enabled: boolean]
  intervalChange: [interval: number]
}>()

// Reactive Data
const autoRefreshEnabled = ref(props.autoRefresh)
const currentInterval = ref(props.refreshInterval)
const lastRefreshTime = ref<Date | null>(null)
const countdown = ref(0)
const progressPercentage = ref(0)

// Timers
let autoRefreshTimer: number | null = null
let countdownTimer: number | null = null
let progressTimer: number | null = null

// Computed
const refreshIcon = computed(() => Refresh)

const currentIntervalText = computed(() => {
  const option = props.intervalOptions.find(opt => opt.value === currentInterval.value)
  return option?.label || '自定义'
})

const buttonText = computed(() => {
  return props.refreshing ? '刷新中...' : props.buttonText
})

// Methods
const handleManualRefresh = () => {
  if (props.refreshing || props.disabled) return
  
  performRefresh()
}

const handleAutoRefreshToggle = (enabled: boolean) => {
  autoRefreshEnabled.value = enabled
  
  if (enabled) {
    startAutoRefresh()
  } else {
    stopAutoRefresh()
  }
  
  emit('autoRefreshChange', enabled)
}

const handleIntervalChange = (interval: number) => {
  currentInterval.value = interval
  
  if (autoRefreshEnabled.value) {
    // 重新启动自动刷新
    stopAutoRefresh()
    startAutoRefresh()
  }
  
  emit('intervalChange', interval)
}

const performRefresh = () => {
  lastRefreshTime.value = new Date()
  
  // 开始进度条
  if (props.showProgress) {
    startProgress()
  }
  
  // 重置倒计时
  if (autoRefreshEnabled.value) {
    startCountdown()
  }
  
  emit('refresh')
}

const startAutoRefresh = () => {
  stopAutoRefresh()
  
  if (!autoRefreshEnabled.value || props.disabled) return
  
  autoRefreshTimer = window.setInterval(() => {
    if (!props.refreshing && !props.disabled) {
      performRefresh()
    }
  }, currentInterval.value)
  
  // 启动倒计时
  startCountdown()
}

const stopAutoRefresh = () => {
  if (autoRefreshTimer) {
    clearInterval(autoRefreshTimer)
    autoRefreshTimer = null
  }
  
  stopCountdown()
}

const startCountdown = () => {
  stopCountdown()
  
  countdown.value = Math.floor(currentInterval.value / 1000)
  
  countdownTimer = window.setInterval(() => {
    countdown.value--
    
    if (countdown.value <= 0) {
      stopCountdown()
    }
  }, 1000)
}

const stopCountdown = () => {
  if (countdownTimer) {
    clearInterval(countdownTimer)
    countdownTimer = null
  }
  countdown.value = 0
}

const startProgress = () => {
  stopProgress()
  
  progressPercentage.value = 0
  const increment = 100 / (props.progressDuration / 50) // 每50ms增加的百分比
  
  progressTimer = window.setInterval(() => {
    progressPercentage.value += increment
    
    if (progressPercentage.value >= 100) {
      progressPercentage.value = 100
      stopProgress()
    }
  }, 50)
}

const stopProgress = () => {
  if (progressTimer) {
    clearInterval(progressTimer)
    progressTimer = null
  }
}

const formatLastRefreshTime = () => {
  if (!lastRefreshTime.value) return ''
  
  const now = dayjs()
  const refreshTime = dayjs(lastRefreshTime.value)
  const diff = now.diff(refreshTime, 'second')
  
  if (diff < 60) {
    return '刚刚'
  } else if (diff < 3600) {
    return `${Math.floor(diff / 60)}分钟前`
  } else if (diff < 86400) {
    return `${Math.floor(diff / 3600)}小时前`
  } else {
    return refreshTime.format('MM-DD HH:mm')
  }
}

// 暴露方法
defineExpose({
  startAutoRefresh,
  stopAutoRefresh,
  refresh: performRefresh
})

// Watchers
watch(() => props.refreshing, (newVal) => {
  if (!newVal && props.showProgress) {
    // 刷新完成，停止进度条
    setTimeout(() => {
      stopProgress()
      progressPercentage.value = 0
    }, 200)
  }
})

watch(() => props.autoRefresh, (newVal) => {
  autoRefreshEnabled.value = newVal
  if (newVal) {
    startAutoRefresh()
  } else {
    stopAutoRefresh()
  }
})

watch(() => props.refreshInterval, (newVal) => {
  currentInterval.value = newVal
  if (autoRefreshEnabled.value) {
    stopAutoRefresh()
    startAutoRefresh()
  }
})

watch(() => props.disabled, (newVal) => {
  if (newVal) {
    stopAutoRefresh()
  } else if (autoRefreshEnabled.value) {
    startAutoRefresh()
  }
})

// Lifecycle
onMounted(() => {
  if (props.autoRefresh) {
    startAutoRefresh()
  }
})

onUnmounted(() => {
  stopAutoRefresh()
  stopProgress()
})
</script>

<style scoped lang="scss">
.refresh-control {
  .refresh-content {
    display: flex;
    align-items: center;
    gap: 16px;
    flex-wrap: wrap;
    
    .auto-refresh-control {
      display: flex;
      align-items: center;
      gap: 8px;
      
      .auto-refresh-label {
        font-size: 14px;
        color: var(--el-text-color-regular);
        white-space: nowrap;
      }
    }
    
    .refresh-status {
      display: flex;
      align-items: center;
      gap: 4px;
      font-size: 12px;
      color: var(--el-text-color-secondary);
      
      .status-text {
        white-space: nowrap;
      }
      
      .countdown {
        color: var(--el-color-primary);
        font-weight: 500;
      }
    }
  }
  
  .refresh-progress {
    margin-top: 8px;
  }
}

// 响应式布局
@media (max-width: 768px) {
  .refresh-control {
    .refresh-content {
      flex-direction: column;
      align-items: flex-start;
      gap: 8px;
      
      .auto-refresh-control {
        order: 2;
      }
      
      .refresh-status {
        order: 3;
        align-self: stretch;
      }
    }
  }
}
</style>