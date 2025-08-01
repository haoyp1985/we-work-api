<template>
  <div class="notification-list">
    <div v-if="loading" class="notification-loading">
      <el-skeleton animated>
        <template #template>
          <div v-for="i in 3" :key="i" class="notification-skeleton">
            <div style="flex: 1;">
              <el-skeleton-item variant="text" style="width: 90%; height: 16px; margin-bottom: 8px;" />
              <el-skeleton-item variant="text" style="width: 100%; height: 14px; margin-bottom: 8px;" />
              <el-skeleton-item variant="text" style="width: 50%; height: 12px;" />
            </div>
          </div>
        </template>
      </el-skeleton>
    </div>
    
    <div v-else-if="notifications.length === 0" class="notification-empty">
      <el-empty description="暂无通知消息" :image-size="80" />
    </div>
    
    <div v-else class="notification-content">
      <div class="notification-header">
        <span class="header-title">系统通知</span>
        <el-button text type="primary" size="small" @click="markAllRead">
          全部已读
        </el-button>
      </div>
      
      <div class="notification-items">
        <div 
          v-for="notification in notifications" 
          :key="notification.id"
          class="notification-item"
          :class="`notification-${notification.type}`"
          @click="handleNotificationClick(notification)"
        >
          <div class="notification-icon">
            <el-icon>
              <component :is="getNotificationIcon(notification.type)" />
            </el-icon>
          </div>
          
          <div class="notification-main">
            <div class="notification-title">{{ notification.title }}</div>
            <div class="notification-content-text">{{ notification.content }}</div>
            <div class="notification-time">{{ formatTime(notification.time, 'MM-DD HH:mm') }}</div>
          </div>
          
          <div class="notification-actions">
            <el-button 
              text 
              type="primary" 
              size="small"
              @click.stop="markAsRead(notification)"
            >
              标记已读
            </el-button>
            <el-button 
              text 
              type="danger" 
              size="small"
              @click.stop="deleteNotification(notification)"
            >
              删除
            </el-button>
          </div>
        </div>
      </div>
      
      <div class="notification-footer">
        <el-button text type="primary" @click="viewAllNotifications">
          查看所有通知
        </el-button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { formatTime } from '@/utils'

interface Notification {
  id: number
  title: string
  content: string
  type: 'info' | 'success' | 'warning' | 'error'
  time: string
  read?: boolean
}

interface Props {
  notifications: Notification[]
  loading?: boolean
}

interface Emits {
  (e: 'markRead', id: number): void
  (e: 'delete', id: number): void
  (e: 'markAllRead'): void
}

const props = withDefaults(defineProps<Props>(), {
  loading: false
})

const emit = defineEmits<Emits>()
const router = useRouter()

// 获取通知图标
const getNotificationIcon = (type: string): string => {
  const iconMap: Record<string, string> = {
    info: 'InfoFilled',
    success: 'SuccessFilled',
    warning: 'WarningFilled',
    error: 'CircleCloseFilled'
  }
  return iconMap[type] || 'InfoFilled'
}

// 处理通知点击
const handleNotificationClick = (notification: Notification) => {
  // 这里可以根据通知类型跳转到不同页面
  console.log('点击通知:', notification)
}

// 标记单个通知为已读
const markAsRead = (notification: Notification) => {
  emit('markRead', notification.id)
  ElMessage.success('已标记为已读')
}

// 删除通知
const deleteNotification = (notification: Notification) => {
  emit('delete', notification.id)
  ElMessage.success('通知已删除')
}

// 标记全部为已读
const markAllRead = () => {
  emit('markAllRead')
  ElMessage.success('所有通知已标记为已读')
}

// 查看所有通知
const viewAllNotifications = () => {
  router.push('/system/notifications')
}
</script>

<style lang="scss" scoped>
.notification-list {
  height: 100%;
  display: flex;
  flex-direction: column;
  
  .notification-loading {
    flex: 1;
    
    .notification-skeleton {
      display: flex;
      padding: 16px;
      border-bottom: 1px solid var(--border-color-extra-light);
      
      &:last-child {
        border-bottom: none;
      }
    }
  }
  
  .notification-empty {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  
  .notification-content {
    height: 100%;
    display: flex;
    flex-direction: column;
    
    .notification-header {
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
    
    .notification-items {
      flex: 1;
      overflow-y: auto;
      
      .notification-item {
        display: flex;
        align-items: flex-start;
        padding: 12px;
        border-radius: 8px;
        margin-bottom: 8px;
        cursor: pointer;
        transition: all $transition-duration-base;
        border: 1px solid transparent;
        
        &:hover {
          background: var(--bg-color-page);
          border-color: var(--border-color-light);
        }
        
        &:last-child {
          margin-bottom: 0;
        }
        
        .notification-icon {
          width: 32px;
          height: 32px;
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          flex-shrink: 0;
          margin-right: 12px;
          
          .el-icon {
            font-size: 16px;
            color: white;
          }
        }
        
        &.notification-info .notification-icon {
          background: var(--el-color-primary);
        }
        
        &.notification-success .notification-icon {
          background: var(--el-color-success);
        }
        
        &.notification-warning .notification-icon {
          background: var(--el-color-warning);
        }
        
        &.notification-error .notification-icon {
          background: var(--el-color-danger);
        }
        
        .notification-main {
          flex: 1;
          min-width: 0;
          
          .notification-title {
            font-size: 13px;
            font-weight: 500;
            color: var(--text-color-primary);
            margin-bottom: 4px;
            @include ellipsis();
          }
          
          .notification-content-text {
            font-size: 12px;
            color: var(--text-color-regular);
            line-height: 1.4;
            margin-bottom: 6px;
            @include ellipsis(2);
          }
          
          .notification-time {
            font-size: 11px;
            color: var(--text-color-secondary);
          }
        }
        
        .notification-actions {
          display: flex;
          flex-direction: column;
          gap: 4px;
          opacity: 0;
          transition: opacity $transition-duration-base;
          
          .el-button {
            padding: 2px 6px;
            font-size: 11px;
            height: auto;
            min-height: auto;
          }
        }
        
        &:hover .notification-actions {
          opacity: 1;
        }
      }
    }
    
    .notification-footer {
      margin-top: 16px;
      padding-top: 16px;
      border-top: 1px solid var(--border-color-extra-light);
      text-align: center;
    }
  }
}

// 滚动条样式
.notification-items {
  @include scrollbar(4px, transparent, rgba(144, 147, 153, 0.3));
}
</style>