<template>
  <div class="activity-list">
    <div v-if="loading" class="activity-loading">
      <el-skeleton animated>
        <template #template>
          <div v-for="i in 5" :key="i" class="activity-skeleton">
            <el-skeleton-item variant="circle" style="width: 32px; height: 32px;" />
            <div style="flex: 1; margin-left: 12px;">
              <el-skeleton-item variant="text" style="width: 80%; height: 16px; margin-bottom: 8px;" />
              <el-skeleton-item variant="text" style="width: 40%; height: 12px;" />
            </div>
          </div>
        </template>
      </el-skeleton>
    </div>
    
    <div v-else-if="activities.length === 0" class="activity-empty">
      <el-empty description="暂无活动记录" :image-size="80" />
    </div>
    
    <div v-else class="activity-content">
      <div class="activity-header">
        <span class="header-title">最新活动</span>
        <el-button text type="primary" size="small" @click="viewMore">
          查看更多
        </el-button>
      </div>
      
      <div class="activity-timeline">
        <div 
          v-for="(activity, index) in activities" 
          :key="activity.id"
          class="activity-item"
          :class="{ 'is-last': index === activities.length - 1 }"
        >
          <div class="activity-icon" :class="`activity-${activity.type}`">
            <el-icon>
              <component :is="getActivityIcon(activity.type)" />
            </el-icon>
          </div>
          
          <div class="activity-content-item">
            <div class="activity-text">{{ activity.content }}</div>
            <div class="activity-time">{{ formatTime(activity.time, 'MM-DD HH:mm') }}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'
import { formatTime } from '@/utils'

interface Activity {
  id: number
  type: string
  content: string
  time: string
}

interface Props {
  activities: Activity[]
  loading?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  loading: false
})

const router = useRouter()

// 获取活动图标
const getActivityIcon = (type: string): string => {
  const iconMap: Record<string, string> = {
    account: 'User',
    message: 'ChatLineSquare',
    provider: 'Connection',
    system: 'Setting',
    user: 'UserFilled',
    error: 'Warning',
    success: 'Check'
  }
  return iconMap[type] || 'InfoFilled'
}

// 查看更多
const viewMore = () => {
  // 这里可以跳转到活动日志页面
  router.push('/system/logs')
}
</script>

<style lang="scss" scoped>
.activity-list {
  height: 100%;
  display: flex;
  flex-direction: column;
  
  .activity-loading {
    flex: 1;
    
    .activity-skeleton {
      display: flex;
      align-items: flex-start;
      margin-bottom: 16px;
      
      &:last-child {
        margin-bottom: 0;
      }
    }
  }
  
  .activity-empty {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  
  .activity-content {
    height: 100%;
    display: flex;
    flex-direction: column;
    
    .activity-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 16px;
      
      .header-title {
        font-size: 14px;
        font-weight: 500;
        color: var(--text-color-primary);
      }
    }
    
    .activity-timeline {
      flex: 1;
      overflow-y: auto;
      
      .activity-item {
        display: flex;
        align-items: flex-start;
        margin-bottom: 16px;
        position: relative;
        
        &:not(.is-last)::after {
          content: '';
          position: absolute;
          left: 15px;
          top: 40px;
          bottom: -16px;
          width: 2px;
          background: var(--border-color-light);
        }
        
        &:last-child {
          margin-bottom: 0;
        }
        
        .activity-icon {
          width: 32px;
          height: 32px;
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          flex-shrink: 0;
          position: relative;
          z-index: 1;
          
          .el-icon {
            font-size: 14px;
            color: white;
          }
          
          &.activity-account {
            background: var(--el-color-primary);
          }
          
          &.activity-message {
            background: var(--el-color-success);
          }
          
          &.activity-provider {
            background: var(--el-color-warning);
          }
          
          &.activity-system {
            background: var(--el-color-info);
          }
          
          &.activity-user {
            background: #909399;
          }
          
          &.activity-error {
            background: var(--el-color-danger);
          }
          
          &.activity-success {
            background: var(--el-color-success);
          }
        }
        
        .activity-content-item {
          flex: 1;
          margin-left: 12px;
          
          .activity-text {
            font-size: 13px;
            color: var(--text-color-primary);
            line-height: 1.4;
            margin-bottom: 4px;
          }
          
          .activity-time {
            font-size: 11px;
            color: var(--text-color-secondary);
          }
        }
      }
    }
  }
}

// 滚动条样式
.activity-timeline {
  @include scrollbar(4px, transparent, rgba(144, 147, 153, 0.3));
}
</style>