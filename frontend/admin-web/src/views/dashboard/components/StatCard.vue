<template>
  <el-card class="stat-card" :body-style="{ padding: '20px' }">
    <div class="stat-content">
      <div class="stat-info">
        <div class="stat-title">{{ title }}</div>
        <div class="stat-value" v-if="!loading">
          <CountUp :end-val="value" />
        </div>
        <el-skeleton v-else animated>
          <template #template>
            <el-skeleton-item variant="text" style="width: 60px; height: 32px;" />
          </template>
        </el-skeleton>
      </div>
      <div class="stat-icon" :style="{ backgroundColor: color }">
        <el-icon>
          <component :is="icon" />
        </el-icon>
      </div>
    </div>
    
    <!-- 趋势指示器 -->
    <div v-if="trend" class="stat-trend">
      <el-icon 
        class="trend-icon"
        :class="{ 'trend-up': trend > 0, 'trend-down': trend < 0 }"
      >
        <component :is="trend > 0 ? 'ArrowUp' : 'ArrowDown'" />
      </el-icon>
      <span class="trend-text">
        {{ Math.abs(trend) }}%
        <span class="trend-label">{{ trend > 0 ? '较昨日' : '较昨日' }}</span>
      </span>
    </div>
  </el-card>
</template>

<script setup lang="ts">
import { ref, onMounted, defineComponent, h } from 'vue'

interface Props {
  title: string
  value?: number
  icon: string
  color: string
  loading?: boolean
  trend?: number // 趋势百分比，正数为上升，负数为下降
}

const props = withDefaults(defineProps<Props>(), {
  value: 0,
  loading: false,
  trend: undefined
})

// 数字动画组件
const CountUp = defineComponent({
  props: {
    endVal: {
      type: Number,
      required: true
    },
    duration: {
      type: Number,
      default: 2000
    }
  },
  setup(props) {
    const displayValue = ref(0)
    
    onMounted(() => {
      const startTime = Date.now()
      const startVal = 0
      const endVal = Number(props.endVal) || 0  // 确保是有效数字
      const duration = props.duration
      
      const animate = () => {
        const elapsed = Date.now() - startTime
        const progress = Math.min(elapsed / duration, 1)
        
        // 使用easeOutQuart缓动函数
        const easeProgress = 1 - Math.pow(1 - progress, 4)
        displayValue.value = Math.floor(startVal + (endVal - startVal) * easeProgress)
        
        if (progress < 1) {
          requestAnimationFrame(animate)
        } else {
          displayValue.value = endVal
        }
      }
      
      requestAnimationFrame(animate)
    })
    
    return () => h('span', (displayValue.value || 0).toLocaleString())
  }
})
</script>

<style lang="scss" scoped>
.stat-card {
  border: none;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transition: all $transition-duration-base;
  
  &:hover {
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
    transform: translateY(-2px);
  }
  
  .stat-content {
    display: flex;
    align-items: center;
    justify-content: space-between;
    
    .stat-info {
      flex: 1;
      
      .stat-title {
        font-size: 14px;
        color: var(--text-color-secondary);
        margin-bottom: 8px;
      }
      
      .stat-value {
        font-size: 28px;
        font-weight: 700;
        color: var(--text-color-primary);
        line-height: 1;
      }
    }
    
    .stat-icon {
      width: 56px;
      height: 56px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
      
      .el-icon {
        font-size: 24px;
        color: white;
      }
    }
  }
  
  .stat-trend {
    display: flex;
    align-items: center;
    margin-top: 12px;
    padding-top: 12px;
    border-top: 1px solid var(--border-color-extra-light);
    
    .trend-icon {
      font-size: 16px;
      margin-right: 4px;
      
      &.trend-up {
        color: var(--el-color-success);
      }
      
      &.trend-down {
        color: var(--el-color-danger);
      }
    }
    
    .trend-text {
      font-size: 12px;
      color: var(--text-color-secondary);
      
      .trend-label {
        margin-left: 4px;
      }
    }
  }
}

// 响应式适配
@include respond-to(sm) {
  .stat-card {
    .stat-content {
      .stat-info {
        .stat-value {
          font-size: 24px;
        }
      }
      
      .stat-icon {
        width: 48px;
        height: 48px;
        
        .el-icon {
          font-size: 20px;
        }
      }
    }
  }
}
</style>