<template>
  <div class="dashboard-container">
    <!-- 欢迎信息 -->
    <div class="welcome-section">
      <el-card class="welcome-card">
        <div class="welcome-content">
          <div class="welcome-info">
            <h1 class="welcome-title">
              欢迎回来，{{ userStore.userInfo?.nickname || userStore.userInfo?.username }}！
            </h1>
            <p class="welcome-subtitle">
              今天是 {{ formatTime(new Date(), 'YYYY年MM月DD日 dddd') }}，祝您工作愉快
            </p>
          </div>
          <div class="welcome-avatar">
            <el-avatar 
              :size="64" 
              :src="userStore.userInfo?.avatar"
            >
              <el-icon><User /></el-icon>
            </el-avatar>
          </div>
        </div>
      </el-card>
    </div>

    <!-- 数据概览 -->
    <div class="overview-section">
      <el-row :gutter="20">
        <el-col :span="6" :xs="12" :sm="12" :md="6">
          <StatCard
            title="账号总数"
            :value="stats.totalAccounts"
            icon="User"
            color="#409eff"
            :loading="statsLoading"
          />
        </el-col>
        <el-col :span="6" :xs="12" :sm="12" :md="6">
          <StatCard
            title="在线账号"
            :value="stats.onlineAccounts"
            icon="Connection"
            color="#67c23a"
            :loading="statsLoading"
          />
        </el-col>
        <el-col :span="6" :xs="12" :sm="12" :md="6">
          <StatCard
            title="今日消息"
            :value="stats.todayMessages"
            icon="ChatLineSquare"
            color="#e6a23c"
            :loading="statsLoading"
          />
        </el-col>
        <el-col :span="6" :xs="12" :sm="12" :md="6">
          <StatCard
            title="API提供商"
            :value="stats.totalProviders"
            icon="Connection"
            color="#f56c6c"
            :loading="statsLoading"
          />
        </el-col>
      </el-row>
    </div>

    <!-- 图表和列表 -->
    <el-row :gutter="20" class="charts-section">
      <!-- 消息统计图表 -->
      <el-col :span="12" :xs="24" :sm="24" :md="12">
        <el-card class="chart-card" header="消息发送统计">
          <MessageChart :data="messageChartData" :loading="chartLoading" />
        </el-card>
      </el-col>
      
      <!-- 系统监控 -->
      <el-col :span="12" :xs="24" :sm="24" :md="12">
        <el-card class="chart-card" header="系统监控">
          <SystemMonitor :metrics="systemMetrics" :loading="metricsLoading" />
        </el-card>
      </el-col>
    </el-row>

    <!-- 快捷操作和最新动态 -->
    <el-row :gutter="20" class="bottom-section">
      <!-- 快捷操作 -->
      <el-col :span="8" :xs="24" :sm="24" :md="8">
        <el-card class="quick-actions-card" header="快捷操作">
          <div class="quick-actions">
            <div class="action-item" @click="$router.push('/account/create')">
              <el-icon class="action-icon"><Plus /></el-icon>
              <span>添加账号</span>
            </div>
            <div class="action-item" @click="$router.push('/message/send')">
              <el-icon class="action-icon"><Promotion /></el-icon>
              <span>发送消息</span>
            </div>
            <div class="action-item" @click="$router.push('/provider/create')">
              <el-icon class="action-icon"><Connection /></el-icon>
              <span>添加提供商</span>
            </div>
            <div class="action-item" @click="$router.push('/monitor/dashboard')">
              <el-icon class="action-icon"><Monitor /></el-icon>
              <span>系统监控</span>
            </div>
            <div class="action-item" @click="$router.push('/message/template')">
              <el-icon class="action-icon"><DocumentCopy /></el-icon>
              <span>消息模板</span>
            </div>
            <div class="action-item" @click="$router.push('/system/settings')">
              <el-icon class="action-icon"><Setting /></el-icon>
              <span>系统设置</span>
            </div>
          </div>
        </el-card>
      </el-col>
      
      <!-- 最新动态 -->
      <el-col :span="8" :xs="24" :sm="24" :md="8">
        <el-card class="activities-card" header="最新动态">
          <ActivityList :activities="activities" :loading="activitiesLoading" />
        </el-card>
      </el-col>
      
      <!-- 系统通知 -->
      <el-col :span="8" :xs="24" :sm="24" :md="8">
        <el-card class="notifications-card" header="系统通知">
          <NotificationList :notifications="notifications" :loading="notificationsLoading" />
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useUserStore } from '@/stores'
import { formatTime } from '@/utils'
import { getAccountStats } from '@/api/account'
import { getMessageStats } from '@/api/message'
import { getProviderStats } from '@/api/provider'
import { getSystemMetrics } from '@/api/monitor'

// 组件导入
import StatCard from './components/StatCard.vue'
import MessageChart from './components/MessageChart.vue'
import SystemMonitor from './components/SystemMonitor.vue'
import ActivityList from './components/ActivityList.vue'
import NotificationList from './components/NotificationList.vue'

const userStore = useUserStore()

// 加载状态
const statsLoading = ref(true)
const chartLoading = ref(true)
const metricsLoading = ref(true)
const activitiesLoading = ref(true)
const notificationsLoading = ref(true)

// 统计数据
const stats = ref({
  totalAccounts: 0,
  onlineAccounts: 0,
  todayMessages: 0,
  totalProviders: 0
})

// 图表数据
const messageChartData = ref([])
const systemMetrics = ref({
  cpu: { usage: 0, cores: 0 },
  memory: { usage: 0, used: 0, total: 0 },
  disk: { usage: 0, used: 0, total: 0 },
  network: { in: 0, out: 0, inRate: 0, outRate: 0 }
})

// 活动和通知数据
const activities = ref([])
const notifications = ref([])

// 加载统计数据
const loadStats = async () => {
  try {
    statsLoading.value = true
    
    const [accountStats, messageStats, providerStats] = await Promise.all([
      getAccountStats(),
      getMessageStats({ 
        startTime: new Date(new Date().setHours(0, 0, 0, 0)).toISOString(),
        endTime: new Date().toISOString()
      }),
      getProviderStats()
    ])
    
    stats.value = {
      totalAccounts: accountStats.data.totalAccounts || 0,
      onlineAccounts: accountStats.data.activeAccounts || 0,
      todayMessages: messageStats.data.todayMessages || 0,
      totalProviders: providerStats.data.total || 0
    }
    
  } catch (error) {
    console.error('加载统计数据失败:', error)
    // 设置默认值，防止组件报错
    stats.value = {
      totalAccounts: 0,
      onlineAccounts: 0,
      todayMessages: 0,
      totalProviders: 0
    }
  } finally {
    statsLoading.value = false
  }
}

// 加载图表数据
const loadChartData = async () => {
  try {
    chartLoading.value = true
    
    const messageStats = await getMessageStats({
      startTime: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString(),
      endTime: new Date().toISOString()
    })
    
    // 由于后端暂未提供dailyStats，使用模拟数据
    messageChartData.value = generateMockChartData()
    
  } catch (error) {
    console.error('加载图表数据失败:', error)
    // 使用默认模拟数据
    messageChartData.value = generateMockChartData()
  } finally {
    chartLoading.value = false
  }
}

// 加载系统指标
const loadSystemMetrics = async () => {
  try {
    metricsLoading.value = true
    
    const metrics = await getSystemMetrics()
    systemMetrics.value = metrics.data
    
  } catch (error) {
    console.error('加载系统指标失败:', error)
    // 设置默认指标数据
    systemMetrics.value = {
      cpu: { usage: 0, cores: 0 },
      memory: { usage: 0, used: 0, total: 0 },
      disk: { usage: 0, used: 0, total: 0 },
      network: { in: 0, out: 0, inRate: 0, outRate: 0 }
    }
  } finally {
    metricsLoading.value = false
  }
}

// 生成模拟图表数据
const generateMockChartData = () => {
  const days = ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
  return days.map((day, index) => ({
    date: day,
    sent: Math.floor(Math.random() * 100) + 20,
    failed: Math.floor(Math.random() * 10),
    success: Math.floor(Math.random() * 90) + 10
  }))
}

// 加载活动数据
const loadActivities = async () => {
  try {
    activitiesLoading.value = true
    
    // 模拟数据
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    activities.value = [
      { id: 1, type: 'account', content: '新增账号: test001', time: '2024-01-15 10:30:00' },
      { id: 2, type: 'message', content: '发送消息: 系统通知', time: '2024-01-15 10:25:00' },
      { id: 3, type: 'provider', content: '提供商连接测试成功', time: '2024-01-15 10:20:00' },
      { id: 4, type: 'system', content: '系统备份完成', time: '2024-01-15 10:15:00' },
      { id: 5, type: 'user', content: '用户登录: admin', time: '2024-01-15 10:10:00' }
    ]
    
  } catch (error) {
    console.error('加载活动数据失败:', error)
  } finally {
    activitiesLoading.value = false
  }
}

// 加载通知数据
const loadNotifications = async () => {
  try {
    notificationsLoading.value = true
    
    // 模拟数据
    await new Promise(resolve => setTimeout(resolve, 800))
    
    notifications.value = [
      { id: 1, title: '系统更新通知', content: '系统将于今晚23:00进行更新维护', type: 'info', time: '2024-01-15 09:00:00' },
      { id: 2, title: '账号异常提醒', content: '账号test001出现连接异常，请及时处理', type: 'warning', time: '2024-01-15 08:30:00' },
      { id: 3, title: '新功能上线', content: '消息模板功能已上线，欢迎使用', type: 'success', time: '2024-01-14 18:00:00' }
    ]
    
  } catch (error) {
    console.error('加载通知数据失败:', error)
  } finally {
    notificationsLoading.value = false
  }
}

// 初始化
onMounted(async () => {
  await Promise.all([
    loadStats(),
    loadChartData(),
    loadSystemMetrics(),
    loadActivities(),
    loadNotifications()
  ])
})
</script>

<style lang="scss" scoped>
.dashboard-container {
  padding: 0;
  padding-bottom: 40px; // 确保底部有足够空间
  
  .welcome-section {
    margin-bottom: 20px;
    
    .welcome-card {
      :deep(.el-card__body) {
        padding: 24px;
      }
      
      .welcome-content {
        display: flex;
        align-items: center;
        justify-content: space-between;
        
        .welcome-info {
          flex: 1;
          
          .welcome-title {
            font-size: 24px;
            font-weight: 600;
            color: var(--text-color-primary);
            margin: 0 0 8px 0;
          }
          
          .welcome-subtitle {
            font-size: 14px;
            color: var(--text-color-secondary);
            margin: 0;
          }
        }
        
        .welcome-avatar {
          flex-shrink: 0;
        }
      }
    }
  }
  
  .overview-section {
    margin-bottom: 20px;
  }
  
  .charts-section {
    margin-bottom: 20px;
    
    .chart-card {
      height: 400px;
      
      :deep(.el-card__body) {
        height: calc(100% - 56px);
        padding: 20px;
      }
    }
  }
  
  .bottom-section {
    margin-bottom: 40px; // 确保底部有足够空间
    
    .quick-actions-card,
    .activities-card,
    .notifications-card {
      height: 400px;
      
      :deep(.el-card__body) {
        height: calc(100% - 56px);
        padding: 20px;
      }
    }
    
    .quick-actions {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 16px;
      
      .action-item {
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: 20px;
        border: 1px solid var(--border-color-light);
        border-radius: 8px;
        cursor: pointer;
        transition: all $transition-duration-base;
        
        &:hover {
          border-color: var(--el-color-primary);
          box-shadow: 0 2px 8px rgba(64, 158, 255, 0.1);
          transform: translateY(-2px);
        }
        
        .action-icon {
          font-size: 28px;
          color: var(--el-color-primary);
          margin-bottom: 8px;
        }
        
        span {
          font-size: 14px;
          color: var(--text-color-primary);
          font-weight: 500;
        }
      }
    }
  }
}

// 响应式适配
@include respond-to(md) {
  .welcome-content {
    flex-direction: column;
    text-align: center;
    gap: 16px;
  }
  
  .charts-section {
    .el-col {
      margin-bottom: 20px;
    }
  }
  
  .bottom-section {
    .el-col {
      margin-bottom: 20px;
    }
  }
}

@include respond-to(sm) {
  .quick-actions {
    grid-template-columns: 1fr;
  }
}
</style>