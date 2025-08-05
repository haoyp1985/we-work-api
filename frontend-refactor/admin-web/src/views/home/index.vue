<template>
  <div class="home-container">
    <!-- 欢迎区域 -->
    <div class="welcome-section">
      <div class="welcome-content">
        <h1 class="welcome-title">
          欢迎回来，{{ userStore.userInfo?.nickname || '用户' }}！
        </h1>
        <p class="welcome-subtitle">
          {{ formatDate(new Date()) }} | {{ getGreeting() }}
        </p>
      </div>
      <div class="welcome-actions">
        <el-button type="primary" @click="$router.push('/accounts')">
          管理账号
        </el-button>
        <el-button @click="$router.push('/messages')">
          发送消息
        </el-button>
      </div>
    </div>

    <!-- 统计卡片 -->
    <div class="stats-section">
      <el-row :gutter="20">
        <el-col :xs="24" :sm="12" :md="6">
          <div class="stat-card">
            <div class="stat-icon primary">
              <el-icon><UserFilled /></el-icon>
            </div>
            <div class="stat-content">
              <div class="stat-value">{{ stats.totalAccounts }}</div>
              <div class="stat-label">企微账号</div>
            </div>
          </div>
        </el-col>
        
        <el-col :xs="24" :sm="12" :md="6">
          <div class="stat-card">
            <div class="stat-icon success">
              <el-icon><ChatDotRound /></el-icon>
            </div>
            <div class="stat-content">
              <div class="stat-value">{{ formatNumber(stats.todayMessages) }}</div>
              <div class="stat-label">今日消息</div>
            </div>
          </div>
        </el-col>
        
        <el-col :xs="24" :sm="12" :md="6">
          <div class="stat-card">
            <div class="stat-icon warning">
              <el-icon><Bell /></el-icon>
            </div>
            <div class="stat-content">
              <div class="stat-value">{{ stats.activeAlerts }}</div>
              <div class="stat-label">活跃告警</div>
            </div>
          </div>
        </el-col>
        
        <el-col :xs="24" :sm="12" :md="6">
          <div class="stat-card">
            <div class="stat-icon info">
              <el-icon><TrendCharts /></el-icon>
            </div>
            <div class="stat-content">
              <div class="stat-value">{{ stats.systemHealth }}%</div>
              <div class="stat-label">系统健康度</div>
            </div>
          </div>
        </el-col>
      </el-row>
    </div>

    <!-- 快捷操作 -->
    <div class="quick-actions">
      <h3 class="section-title">快捷操作</h3>
      <el-row :gutter="20">
        <el-col :xs="24" :sm="12" :md="8">
          <div class="action-card" @click="$router.push('/accounts/create')">
            <el-icon class="action-icon"><Plus /></el-icon>
            <h4>添加企微账号</h4>
            <p>快速添加新的企业微信账号</p>
          </div>
        </el-col>
        
        <el-col :xs="24" :sm="12" :md="8">
          <div class="action-card" @click="$router.push('/messages/send')">
            <el-icon class="action-icon"><Promotion /></el-icon>
            <h4>批量发送消息</h4>
            <p>向多个用户群发消息</p>
          </div>
        </el-col>
        
        <el-col :xs="24" :sm="12" :md="8">
          <div class="action-card" @click="$router.push('/monitor')">
            <el-icon class="action-icon"><Monitor /></el-icon>
            <h4>系统监控</h4>
            <p>查看系统运行状态和性能</p>
          </div>
        </el-col>
      </el-row>
    </div>

    <!-- 最近活动 -->
    <div class="recent-activities">
      <h3 class="section-title">最近活动</h3>
      <div class="activity-list">
        <div
          v-for="activity in recentActivities"
          :key="activity.id"
          class="activity-item"
        >
          <div class="activity-icon" :class="activity.type">
            <el-icon v-if="activity.type === 'account'"><UserFilled /></el-icon>
            <el-icon v-else-if="activity.type === 'message'"><ChatDotRound /></el-icon>
            <el-icon v-else-if="activity.type === 'alert'"><Bell /></el-icon>
            <el-icon v-else><InfoFilled /></el-icon>
          </div>
          <div class="activity-content">
            <div class="activity-title">{{ activity.title }}</div>
            <div class="activity-time">{{ formatRelativeTime(activity.time) }}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { 
  UserFilled, 
  ChatDotRound, 
  Bell, 
  TrendCharts, 
  Plus, 
  Promotion, 
  Monitor,
  InfoFilled 
} from '@element-plus/icons-vue';
import { useUserStore } from '@/stores/modules/user';
import { formatDate, formatRelativeTime } from '@/utils/date';
import { formatNumber, setPageTitle } from '@/utils';

const userStore = useUserStore();

// 统计数据
const stats = ref({
  totalAccounts: 0,
  todayMessages: 0,
  activeAlerts: 0,
  systemHealth: 0,
});

// 最近活动
const recentActivities = ref([
  {
    id: 1,
    type: 'account',
    title: '新增企微账号：测试公司',
    time: new Date(Date.now() - 5 * 60 * 1000), // 5分钟前
  },
  {
    id: 2,
    type: 'message',
    title: '批量发送消息：新年祝福',
    time: new Date(Date.now() - 30 * 60 * 1000), // 30分钟前
  },
  {
    id: 3,
    type: 'alert',
    title: '系统告警：CPU使用率过高',
    time: new Date(Date.now() - 2 * 60 * 60 * 1000), // 2小时前
  },
  {
    id: 4,
    type: 'account',
    title: '企微账号状态更新：在线',
    time: new Date(Date.now() - 4 * 60 * 60 * 1000), // 4小时前
  },
]);

// 获取问候语
const getGreeting = (): string => {
  const hour = new Date().getHours();
  if (hour < 6) return '深夜好';
  if (hour < 9) return '早上好';
  if (hour < 12) return '上午好';
  if (hour < 14) return '中午好';
  if (hour < 18) return '下午好';
  if (hour < 22) return '晚上好';
  return '夜里好';
};

// 加载统计数据
const loadStats = async () => {
  try {
    // 模拟数据，实际应该调用API
    stats.value = {
      totalAccounts: 25,
      todayMessages: 12580,
      activeAlerts: 3,
      systemHealth: 98,
    };
  } catch (error) {
    console.error('Failed to load stats:', error);
  }
};

// 初始化
onMounted(() => {
  setPageTitle('首页');
  loadStats();
});
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.home-container {
  padding: 24px;
}

.welcome-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 32px;
  padding: 32px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  color: white;

  .welcome-content {
    .welcome-title {
      margin: 0 0 8px 0;
      font-size: 32px;
      font-weight: 600;
    }

    .welcome-subtitle {
      margin: 0;
      font-size: 16px;
      opacity: 0.9;
    }
  }

  .welcome-actions {
    .el-button {
      margin-left: 12px;
    }
  }
}

.stats-section {
  margin-bottom: 32px;

  .stat-card {
    display: flex;
    align-items: center;
    padding: 24px;
    background: white;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    transition: transform 0.2s ease, box-shadow 0.2s ease;

    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
    }

    .stat-icon {
      display: flex;
      align-items: center;
      justify-content: center;
      width: 60px;
      height: 60px;
      border-radius: 12px;
      margin-right: 16px;
      font-size: 24px;
      color: white;

      &.primary { background: $primary-color; }
      &.success { background: $success-color; }
      &.warning { background: $warning-color; }
      &.info { background: $info-color; }
    }

    .stat-content {
      .stat-value {
        font-size: 28px;
        font-weight: 600;
        color: $text-color-primary;
        line-height: 1;
        margin-bottom: 4px;
      }

      .stat-label {
        font-size: 14px;
        color: $text-color-secondary;
      }
    }
  }
}

.quick-actions {
  margin-bottom: 32px;

  .section-title {
    margin: 0 0 20px 0;
    font-size: 20px;
    font-weight: 600;
    color: $text-color-primary;
  }

  .action-card {
    padding: 24px;
    background: white;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    text-align: center;
    cursor: pointer;
    transition: transform 0.2s ease, box-shadow 0.2s ease;

    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
    }

    .action-icon {
      font-size: 32px;
      color: $primary-color;
      margin-bottom: 16px;
    }

    h4 {
      margin: 0 0 8px 0;
      font-size: 16px;
      font-weight: 600;
      color: $text-color-primary;
    }

    p {
      margin: 0;
      font-size: 14px;
      color: $text-color-secondary;
    }
  }
}

.recent-activities {
  .section-title {
    margin: 0 0 20px 0;
    font-size: 20px;
    font-weight: 600;
    color: $text-color-primary;
  }

  .activity-list {
    background: white;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    overflow: hidden;

    .activity-item {
      display: flex;
      align-items: center;
      padding: 16px 24px;
      border-bottom: 1px solid $border-color-light;

      &:last-child {
        border-bottom: none;
      }

      .activity-icon {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 40px;
        height: 40px;
        border-radius: 8px;
        margin-right: 16px;
        font-size: 18px;
        color: white;

        &.account { background: $primary-color; }
        &.message { background: $success-color; }
        &.alert { background: $warning-color; }
      }

      .activity-content {
        .activity-title {
          font-size: 14px;
          font-weight: 500;
          color: $text-color-primary;
          margin-bottom: 4px;
        }

        .activity-time {
          font-size: 12px;
          color: $text-color-secondary;
        }
      }
    }
  }
}

// 响应式设计
@media (max-width: 768px) {
  .home-container {
    padding: 16px;
  }

  .welcome-section {
    flex-direction: column;
    align-items: flex-start;
    padding: 24px;

    .welcome-content {
      margin-bottom: 20px;

      .welcome-title {
        font-size: 24px;
      }
    }

    .welcome-actions {
      .el-button {
        margin-left: 0;
        margin-right: 12px;
      }
    }
  }

  .stats-section {
    .stat-card {
      margin-bottom: 16px;
    }
  }

  .quick-actions {
    .action-card {
      margin-bottom: 16px;
    }
  }
}
</style>