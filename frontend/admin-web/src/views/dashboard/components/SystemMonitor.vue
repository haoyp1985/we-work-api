<template>
  <div class="system-monitor">
    <div v-if="loading" class="monitor-loading">
      <el-skeleton animated>
        <template #template>
          <el-skeleton-item variant="rect" style="width: 100%; height: 80px; margin-bottom: 16px;" />
          <el-skeleton-item variant="rect" style="width: 100%; height: 80px; margin-bottom: 16px;" />
          <el-skeleton-item variant="rect" style="width: 100%; height: 80px;" />
        </template>
      </el-skeleton>
    </div>
    
    <div v-else class="monitor-content">
      <!-- CPU使用率 -->
      <div class="metric-item">
        <div class="metric-header">
          <span class="metric-label">CPU使用率</span>
          <span class="metric-value">{{ metrics?.cpu.usage || 0 }}%</span>
        </div>
        <el-progress 
          :percentage="metrics?.cpu.usage || 0" 
          :color="getProgressColor(metrics?.cpu.usage || 0)"
          :show-text="false"
          :stroke-width="8"
        />
        <div class="metric-info">
          <span class="info-text">核心数: {{ metrics?.cpu.cores || 0 }}</span>
        </div>
      </div>
      
      <!-- 内存使用率 -->
      <div class="metric-item">
        <div class="metric-header">
          <span class="metric-label">内存使用率</span>
          <span class="metric-value">{{ metrics?.memory.usage || 0 }}%</span>
        </div>
        <el-progress 
          :percentage="metrics?.memory.usage || 0" 
          :color="getProgressColor(metrics?.memory.usage || 0)"
          :show-text="false"
          :stroke-width="8"
        />
        <div class="metric-info">
          <span class="info-text">
            {{ formatBytes(metrics?.memory.used || 0) }} / {{ formatBytes(metrics?.memory.total || 0) }}
          </span>
        </div>
      </div>
      
      <!-- 磁盘使用率 -->
      <div class="metric-item">
        <div class="metric-header">
          <span class="metric-label">磁盘使用率</span>
          <span class="metric-value">{{ metrics?.disk.usage || 0 }}%</span>
        </div>
        <el-progress 
          :percentage="metrics?.disk.usage || 0" 
          :color="getProgressColor(metrics?.disk.usage || 0)"
          :show-text="false"
          :stroke-width="8"
        />
        <div class="metric-info">
          <span class="info-text">
            {{ formatBytes(metrics?.disk.used || 0) }} / {{ formatBytes(metrics?.disk.total || 0) }}
          </span>
        </div>
      </div>
      
      <!-- 网络流量 -->
      <div class="metric-item">
        <div class="metric-header">
          <span class="metric-label">网络流量</span>
          <span class="metric-value">实时</span>
        </div>
        <div class="network-stats">
          <div class="network-item">
            <span class="network-label">
              <el-icon class="network-icon upload"><Upload /></el-icon>
              上传
            </span>
            <span class="network-value">{{ formatBytes(metrics?.network.tx || 0) }}/s</span>
          </div>
          <div class="network-item">
            <span class="network-label">
              <el-icon class="network-icon download"><Download /></el-icon>
              下载
            </span>
            <span class="network-value">{{ formatBytes(metrics?.network.rx || 0) }}/s</span>
          </div>
        </div>
      </div>
      
      <!-- 系统信息 -->
      <div class="system-info">
        <div class="info-item">
          <span class="info-label">运行时间</span>
          <span class="info-value">{{ formatUptime(metrics?.timestamp) }}</span>
        </div>
        <div class="info-item">
          <span class="info-label">最后更新</span>
          <span class="info-value">{{ formatTime(metrics?.timestamp, 'HH:mm:ss') }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { formatTime, formatFileSize } from '@/utils'
import type { SystemMetrics } from '@/types'

interface Props {
  metrics: SystemMetrics | null
  loading?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  loading: false
})

// 格式化字节数
const formatBytes = (bytes: number): string => {
  return formatFileSize(bytes)
}

// 获取进度条颜色
const getProgressColor = (percentage: number): string => {
  if (percentage < 50) return '#67c23a'
  if (percentage < 80) return '#e6a23c'
  return '#f56c6c'
}

// 格式化运行时间
const formatUptime = (timestamp?: string): string => {
  if (!timestamp) return '--'
  
  const now = new Date()
  const start = new Date(timestamp)
  const diff = now.getTime() - start.getTime()
  
  const days = Math.floor(diff / (1000 * 60 * 60 * 24))
  const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
  const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60))
  
  if (days > 0) {
    return `${days}天${hours}小时`
  } else if (hours > 0) {
    return `${hours}小时${minutes}分钟`
  } else {
    return `${minutes}分钟`
  }
}
</script>

<style lang="scss" scoped>
.system-monitor {
  height: 100%;
  
  .monitor-loading {
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  
  .monitor-content {
    height: 100%;
    display: flex;
    flex-direction: column;
    gap: 20px;
  }
  
  .metric-item {
    .metric-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 8px;
      
      .metric-label {
        font-size: 14px;
        font-weight: 500;
        color: var(--text-color-primary);
      }
      
      .metric-value {
        font-size: 16px;
        font-weight: 600;
        color: var(--el-color-primary);
      }
    }
    
    .metric-info {
      margin-top: 4px;
      
      .info-text {
        font-size: 12px;
        color: var(--text-color-secondary);
      }
    }
    
    .network-stats {
      display: flex;
      justify-content: space-between;
      gap: 16px;
      
      .network-item {
        flex: 1;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 8px 12px;
        background: var(--bg-color-page);
        border-radius: 6px;
        
        .network-label {
          display: flex;
          align-items: center;
          gap: 4px;
          font-size: 12px;
          color: var(--text-color-secondary);
          
          .network-icon {
            font-size: 14px;
            
            &.upload {
              color: var(--el-color-danger);
            }
            
            &.download {
              color: var(--el-color-success);
            }
          }
        }
        
        .network-value {
          font-size: 13px;
          font-weight: 500;
          color: var(--text-color-primary);
        }
      }
    }
  }
  
  .system-info {
    margin-top: auto;
    padding-top: 16px;
    border-top: 1px solid var(--border-color-extra-light);
    
    .info-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 8px;
      
      &:last-child {
        margin-bottom: 0;
      }
      
      .info-label {
        font-size: 12px;
        color: var(--text-color-secondary);
      }
      
      .info-value {
        font-size: 12px;
        font-weight: 500;
        color: var(--text-color-primary);
      }
    }
  }
}

// 进度条样式定制
:deep(.el-progress) {
  .el-progress-bar {
    .el-progress-bar__outer {
      background-color: var(--border-color-extra-light);
    }
  }
}
</style>