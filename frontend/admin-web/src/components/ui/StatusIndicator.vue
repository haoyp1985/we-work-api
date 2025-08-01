<template>
  <div class="status-indicator" :class="indicatorClass">
    <!-- 简单模式 -->
    <template v-if="mode === 'simple'">
      <div class="status-dot" :class="`dot-${type}`"></div>
      <span class="status-text">{{ text }}</span>
    </template>
    
    <!-- 徽章模式 -->
    <template v-else-if="mode === 'badge'">
      <el-badge 
        :value="badgeValue" 
        :type="badgeType"
        :is-dot="isDot"
        :hidden="badgeHidden"
      >
        <slot>
          <div class="badge-content">
            <el-icon v-if="icon" :size="iconSize">
              <component :is="icon" />
            </el-icon>
            <span v-if="text">{{ text }}</span>
          </div>
        </slot>
      </el-badge>
    </template>
    
    <!-- 标签模式 -->
    <template v-else-if="mode === 'tag'">
      <el-tag 
        :type="tagType" 
        :effect="tagEffect"
        :size="tagSize"
        :closable="closable"
        :disable-transitions="disableTransitions"
        @close="handleClose"
      >
        <el-icon v-if="icon" :size="iconSize" class="tag-icon">
          <component :is="icon" />
        </el-icon>
        {{ text }}
      </el-tag>
    </template>
    
    <!-- 进度模式 -->
    <template v-else-if="mode === 'progress'">
      <div class="progress-indicator">
        <div class="progress-header">
          <span class="progress-text">{{ text }}</span>
          <span class="progress-value">{{ progressValue }}%</span>
        </div>
        <el-progress 
          :percentage="progressValue"
          :color="progressColor"
          :stroke-width="progressStrokeWidth"
          :show-text="false"
        />
      </div>
    </template>
    
    <!-- 图标模式 -->
    <template v-else-if="mode === 'icon'">
      <div class="icon-indicator" :class="`icon-${type}`">
        <el-icon :size="iconSize">
          <component :is="icon" />
        </el-icon>
        <span v-if="text" class="icon-text">{{ text }}</span>
      </div>
    </template>
    
    <!-- 卡片模式 -->
    <template v-else-if="mode === 'card'">
      <div class="card-indicator" :class="`card-${type}`">
        <div class="card-icon">
          <el-icon :size="iconSize">
            <component :is="icon" />
          </el-icon>
        </div>
        <div class="card-content">
          <div class="card-title">{{ text }}</div>
          <div v-if="description" class="card-description">{{ description }}</div>
        </div>
        <div v-if="showTime" class="card-time">
          {{ formatTime(time) }}
        </div>
      </div>
    </template>
    
    <!-- 健康度模式 -->
    <template v-else-if="mode === 'health'">
      <div class="health-indicator">
        <div class="health-score" :class="getHealthScoreClass(healthScore)">
          {{ healthScore || 0 }}
        </div>
        <div class="health-info">
          <div class="health-text">{{ text }}</div>
          <div class="health-level">{{ getHealthLevel(healthScore) }}</div>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import dayjs from 'dayjs'

// Props
interface Props {
  // 通用属性
  mode?: 'simple' | 'badge' | 'tag' | 'progress' | 'icon' | 'card' | 'health'
  type?: 'primary' | 'success' | 'warning' | 'danger' | 'info' | 'default'
  text?: string
  icon?: any
  iconSize?: number
  
  // 徽章模式
  badgeValue?: string | number
  badgeType?: 'primary' | 'success' | 'warning' | 'danger' | 'info'
  isDot?: boolean
  badgeHidden?: boolean
  
  // 标签模式
  tagType?: 'primary' | 'success' | 'warning' | 'danger' | 'info' | ''
  tagEffect?: 'dark' | 'light' | 'plain'
  tagSize?: 'large' | 'default' | 'small'
  closable?: boolean
  disableTransitions?: boolean
  
  // 进度模式
  progressValue?: number
  progressColor?: string | string[]
  progressStrokeWidth?: number
  
  // 卡片模式
  description?: string
  time?: string | Date
  showTime?: boolean
  
  // 健康度模式
  healthScore?: number
}

const props = withDefaults(defineProps<Props>(), {
  mode: 'simple',
  type: 'default',
  iconSize: 16,
  isDot: false,
  badgeHidden: false,
  tagEffect: 'light',
  tagSize: 'default',
  closable: false,
  disableTransitions: false,
  progressValue: 0,
  progressStrokeWidth: 6,
  showTime: true
})

// Emits
const emit = defineEmits<{
  close: []
}>()

// Computed
const indicatorClass = computed(() => {
  return [
    `status-indicator--${props.mode}`,
    `status-indicator--${props.type}`
  ]
})

const badgeType = computed(() => {
  const typeMap: Record<string, any> = {
    primary: 'primary',
    success: 'success',
    warning: 'warning',
    danger: 'danger',
    info: 'info',
    default: ''
  }
  return typeMap[props.type] || ''
})

const tagType = computed(() => {
  const typeMap: Record<string, any> = {
    primary: 'primary',
    success: 'success',
    warning: 'warning',
    danger: 'danger',
    info: 'info',
    default: ''
  }
  return typeMap[props.type] || ''
})

const progressColor = computed(() => {
  if (props.progressColor) {
    return props.progressColor
  }
  
  const colorMap: Record<string, string> = {
    primary: '#409EFF',
    success: '#67C23A',
    warning: '#E6A23C',
    danger: '#F56C6C',
    info: '#909399',
    default: '#409EFF'
  }
  return colorMap[props.type] || '#409EFF'
})

// Methods
const handleClose = () => {
  emit('close')
}

const formatTime = (time?: string | Date) => {
  if (!time) return ''
  return dayjs(time).format('MM-DD HH:mm')
}

const getHealthScoreClass = (score?: number) => {
  if (!score) return 'health-score--unknown'
  if (score >= 90) return 'health-score--excellent'
  if (score >= 80) return 'health-score--good'
  if (score >= 60) return 'health-score--fair'
  return 'health-score--poor'
}

const getHealthLevel = (score?: number) => {
  if (!score) return '未知'
  if (score >= 90) return '优秀'
  if (score >= 80) return '良好'
  if (score >= 60) return '一般'
  return '较差'
}
</script>

<style scoped lang="scss">
.status-indicator {
  display: inline-flex;
  align-items: center;
  
  // 简单模式
  &--simple {
    gap: 6px;
    
    .status-dot {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      flex-shrink: 0;
      
      &.dot-primary { background-color: var(--el-color-primary); }
      &.dot-success { background-color: var(--el-color-success); }
      &.dot-warning { background-color: var(--el-color-warning); }
      &.dot-danger { background-color: var(--el-color-danger); }
      &.dot-info { background-color: var(--el-color-info); }
      &.dot-default { background-color: var(--el-color-info); }
    }
    
    .status-text {
      font-size: 14px;
      color: var(--el-text-color-primary);
    }
  }
  
  // 徽章模式
  &--badge {
    .badge-content {
      display: flex;
      align-items: center;
      gap: 4px;
      color: var(--el-text-color-primary);
    }
  }
  
  // 标签模式
  &--tag {
    .tag-icon {
      margin-right: 4px;
    }
  }
  
  // 进度模式
  &--progress {
    .progress-indicator {
      min-width: 120px;
      
      .progress-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 4px;
        
        .progress-text {
          font-size: 12px;
          color: var(--el-text-color-regular);
        }
        
        .progress-value {
          font-size: 12px;
          font-weight: 600;
          color: var(--el-text-color-primary);
        }
      }
    }
  }
  
  // 图标模式
  &--icon {
    .icon-indicator {
      display: flex;
      align-items: center;
      gap: 6px;
      
      &.icon-primary { color: var(--el-color-primary); }
      &.icon-success { color: var(--el-color-success); }
      &.icon-warning { color: var(--el-color-warning); }
      &.icon-danger { color: var(--el-color-danger); }
      &.icon-info { color: var(--el-color-info); }
      &.icon-default { color: var(--el-text-color-secondary); }
      
      .icon-text {
        font-size: 14px;
        color: var(--el-text-color-primary);
      }
    }
  }
  
  // 卡片模式
  &--card {
    .card-indicator {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 12px;
      border-radius: 6px;
      border: 1px solid var(--el-border-color-light);
      background: var(--el-bg-color);
      transition: all 0.2s;
      
      &:hover {
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      }
      
      &.card-primary { border-left: 4px solid var(--el-color-primary); }
      &.card-success { border-left: 4px solid var(--el-color-success); }
      &.card-warning { border-left: 4px solid var(--el-color-warning); }
      &.card-danger { border-left: 4px solid var(--el-color-danger); }
      &.card-info { border-left: 4px solid var(--el-color-info); }
      
      .card-icon {
        color: var(--el-text-color-secondary);
      }
      
      .card-content {
        flex: 1;
        
        .card-title {
          font-size: 14px;
          font-weight: 500;
          color: var(--el-text-color-primary);
          margin-bottom: 2px;
        }
        
        .card-description {
          font-size: 12px;
          color: var(--el-text-color-secondary);
        }
      }
      
      .card-time {
        font-size: 12px;
        color: var(--el-text-color-secondary);
      }
    }
  }
  
  // 健康度模式
  &--health {
    .health-indicator {
      display: flex;
      align-items: center;
      gap: 8px;
      
      .health-score {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 36px;
        height: 36px;
        border-radius: 50%;
        font-size: 14px;
        font-weight: 600;
        color: white;
        
        &.health-score--excellent {
          background: linear-gradient(135deg, #67C23A, #85CE61);
        }
        
        &.health-score--good {
          background: linear-gradient(135deg, #409EFF, #66B1FF);
        }
        
        &.health-score--fair {
          background: linear-gradient(135deg, #E6A23C, #EEBE77);
        }
        
        &.health-score--poor {
          background: linear-gradient(135deg, #F56C6C, #F78989);
        }
        
        &.health-score--unknown {
          background: linear-gradient(135deg, #909399, #A6A9AD);
        }
      }
      
      .health-info {
        .health-text {
          font-size: 14px;
          color: var(--el-text-color-primary);
          margin-bottom: 2px;
        }
        
        .health-level {
          font-size: 12px;
          color: var(--el-text-color-secondary);
        }
      }
    }
  }
}
</style>