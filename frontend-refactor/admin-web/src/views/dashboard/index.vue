<script setup lang="ts">
import { ref, onMounted } from "vue";
import { ElMessage } from "element-plus";
import {
  User,
  Message,
  Monitor,
  DataAnalysis,
  TrendCharts,
  Calendar,
  Bell,
  Setting,
} from "@element-plus/icons-vue";
import { useUserStore } from "@/stores/modules/user";

const userStore = useUserStore();

// 统计数据
const statistics = ref({
  totalUsers: 1248,
  activeUsers: 856,
  totalMessages: 5632,
  systemHealth: 98.5,
});

// 快捷操作
const quickActions = [
  { title: "用户管理", icon: User, color: "#409eff", path: "/system/user" },
  { title: "消息中心", icon: Message, color: "#67c23a", path: "/message/send" },
  {
    title: "系统监控",
    icon: Monitor,
    color: "#e6a23c",
    path: "/monitor/performance",
  },
  {
    title: "数据分析",
    icon: DataAnalysis,
    color: "#f56c6c",
    path: "/dashboard",
  },
];

// 最近活动
const recentActivities = ref([
  {
    id: 1,
    type: "login",
    user: "张三",
    action: "登录系统",
    time: "2024-01-15 14:30:25",
    status: "success",
  },
  {
    id: 2,
    type: "message",
    user: "李四",
    action: "发送消息",
    time: "2024-01-15 14:28:15",
    status: "success",
  },
  {
    id: 3,
    type: "error",
    user: "系统",
    action: "数据库连接异常",
    time: "2024-01-15 14:25:30",
    status: "error",
  },
  {
    id: 4,
    type: "warning",
    user: "系统",
    action: "磁盘空间不足警告",
    time: "2024-01-15 14:20:10",
    status: "warning",
  },
]);

// 系统通知
const notifications = ref([
  {
    id: 1,
    title: "系统维护通知",
    content: "系统将于今晚23:00-次日凌晨2:00进行维护，请提前保存工作。",
    type: "warning",
    time: "2024-01-15 14:00:00",
    read: false,
  },
  {
    id: 2,
    title: "功能更新",
    content: "消息模板功能已上线，支持批量发送和定时发送。",
    type: "info",
    time: "2024-01-15 10:30:00",
    read: false,
  },
  {
    id: 3,
    title: "安全提醒",
    content: "检测到异常登录行为，建议修改密码并启用二次验证。",
    type: "error",
    time: "2024-01-15 09:15:00",
    read: true,
  },
]);

  // 图表数据
  const _chartData = ref({
    userGrowth: [
      { month: "1月", value: 820 },
      { month: "2月", value: 932 },
      { month: "3月", value: 901 },
      { month: "4月", value: 934 },
      { month: "5月", value: 1290 },
      { month: "6月", value: 1330 },
      { month: "7月", value: 1248 },
    ],
    messageStats: [
      { name: "已发送", value: 4856 },
      { name: "失败", value: 421 },
      { name: "待发送", value: 355 },
    ],
  });

// 页面方法
const handleQuickAction = (path: string) => {
  ElMessage.info(`跳转到: ${path}`);
};

const markNotificationRead = (id: number) => {
  const notification = notifications.value.find((n) => n.id === id);
  if (notification) {
    notification.read = true;
    ElMessage.success("通知已标记为已读");
  }
};

const getActivityIcon = (type: string) => {
  switch (type) {
    case "login":
      return User;
    case "message":
      return Message;
    case "error":
      return Bell;
    default:
      return Setting;
  }
};

const getActivityColor = (status: string) => {
  switch (status) {
    case "success":
      return "#67c23a";
    case "error":
      return "#f56c6c";
    case "warning":
      return "#e6a23c";
    default:
      return "#909399";
  }
};

// 获取问候语
const getGreeting = () => {
  const hour = new Date().getHours();
  if (hour < 12) return "上午好";
  if (hour < 18) return "下午好";
  return "晚上好";
};

onMounted(() => {
  // 模拟数据加载
  console.log("Dashboard mounted");
});
</script>

<template>
  <div class="dashboard-container">
    <!-- 顶部欢迎区 -->
    <div class="welcome-section">
      <div class="welcome-content">
        <h1 class="welcome-title">
          {{ getGreeting() }}，{{ userStore.userInfo?.realName || "用户" }}！
        </h1>
        <p class="welcome-subtitle">欢迎回到 WeWork Platform 管理后台</p>
      </div>
      <div class="welcome-stats">
        <div class="stat-item">
          <div class="stat-number">
            {{ statistics.totalUsers }}
          </div>
          <div class="stat-label">总用户数</div>
        </div>
        <div class="stat-item">
          <div class="stat-number">
            {{ statistics.activeUsers }}
          </div>
          <div class="stat-label">活跃用户</div>
        </div>
        <div class="stat-item">
          <div class="stat-number">
            {{ statistics.totalMessages }}
          </div>
          <div class="stat-label">消息总数</div>
        </div>
      </div>
    </div>

    <!-- 快捷操作区 -->
    <div class="quick-actions-section">
      <h2 class="section-title">快捷操作</h2>
      <div class="quick-actions-grid">
        <div
          v-for="action in quickActions"
          :key="action.title"
          class="quick-action-card"
          @click="handleQuickAction(action.path)"
        >
          <div class="action-icon" :style="{ backgroundColor: action.color }">
            <el-icon :size="32">
              <component :is="action.icon" />
            </el-icon>
          </div>
          <div class="action-title">
            {{ action.title }}
          </div>
        </div>
      </div>
    </div>

    <!-- 主要内容区 -->
    <div class="main-content">
      <!-- 左侧内容 -->
      <div class="left-content">
        <!-- 数据概览 -->
        <el-card class="overview-card">
          <template #header>
            <div class="card-header">
              <span>数据概览</span>
              <el-icon>
                <TrendCharts />
              </el-icon>
            </div>
          </template>
          <div class="overview-content">
            <div class="chart-placeholder">
              <el-icon :size="48" color="#c0c4cc">
                <DataAnalysis />
              </el-icon>
              <p>图表数据加载中...</p>
            </div>
          </div>
        </el-card>

        <!-- 最近活动 -->
        <el-card class="activity-card">
          <template #header>
            <div class="card-header">
              <span>最近活动</span>
              <el-icon>
                <Calendar />
              </el-icon>
            </div>
          </template>
          <div class="activity-list">
            <div
              v-for="activity in recentActivities"
              :key="activity.id"
              class="activity-item"
            >
              <div class="activity-icon">
                <el-icon :size="20" :color="getActivityColor(activity.status)">
                  <component :is="getActivityIcon(activity.type)" />
                </el-icon>
              </div>
              <div class="activity-content">
                <div class="activity-text">
                  <span class="activity-user">{{ activity.user }}</span>
                  {{ activity.action }}
                </div>
                <div class="activity-time">
                  {{ activity.time }}
                </div>
              </div>
            </div>
          </div>
        </el-card>
      </div>

      <!-- 右侧内容 -->
      <div class="right-content">
        <!-- 系统状态 -->
        <el-card class="status-card">
          <template #header>
            <div class="card-header">
              <span>系统状态</span>
              <el-icon>
                <Monitor />
              </el-icon>
            </div>
          </template>
          <div class="status-content">
            <div class="status-item">
              <div class="status-label">系统健康度</div>
              <div class="status-value">
                <el-progress
                  :percentage="statistics.systemHealth"
                  :color="statistics.systemHealth > 95 ? '#67c23a' : '#e6a23c'"
                />
              </div>
            </div>
            <div class="status-metrics">
              <div class="metric-item">
                <span class="metric-label">CPU使用率</span>
                <span class="metric-value">45%</span>
              </div>
              <div class="metric-item">
                <span class="metric-label">内存使用率</span>
                <span class="metric-value">68%</span>
              </div>
              <div class="metric-item">
                <span class="metric-label">磁盘使用率</span>
                <span class="metric-value">72%</span>
              </div>
            </div>
          </div>
        </el-card>

        <!-- 系统通知 -->
        <el-card class="notification-card">
          <template #header>
            <div class="card-header">
              <span>系统通知</span>
              <el-badge
                :value="notifications.filter((n) => !n.read).length"
                class="notification-badge"
              >
                <el-icon>
                  <Bell />
                </el-icon>
              </el-badge>
            </div>
          </template>
          <div class="notification-list">
            <div
              v-for="notification in notifications"
              :key="notification.id"
              class="notification-item"
              :class="{ 'notification-unread': !notification.read }"
            >
              <div class="notification-header">
                <span class="notification-title">{{ notification.title }}</span>
                <el-tag :type="notification.type" size="small">
                  {{ notification.type }}
                </el-tag>
              </div>
              <div class="notification-content">
                {{ notification.content }}
              </div>
              <div class="notification-footer">
                <span class="notification-time">{{ notification.time }}</span>
                <el-button
                  v-if="!notification.read"
                  type="text"
                  size="small"
                  @click="markNotificationRead(notification.id)"
                >
                  标记已读
                </el-button>
              </div>
            </div>
          </div>
        </el-card>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
.dashboard-container {
  padding: 24px;
  background-color: #f5f7fa;
  min-height: calc(100vh - 60px);
}

.welcome-section {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 16px;
  padding: 32px;
  margin-bottom: 24px;
  color: white;
  display: flex;
  justify-content: space-between;
  align-items: center;
  box-shadow: 0 8px 32px rgba(102, 126, 234, 0.3);

  .welcome-content {
    .welcome-title {
      font-size: 28px;
      font-weight: 600;
      margin: 0 0 8px 0;
    }

    .welcome-subtitle {
      font-size: 16px;
      opacity: 0.9;
      margin: 0;
    }
  }

  .welcome-stats {
    display: flex;
    gap: 32px;

    .stat-item {
      text-align: center;

      .stat-number {
        font-size: 32px;
        font-weight: 700;
        margin-bottom: 4px;
      }

      .stat-label {
        font-size: 14px;
        opacity: 0.8;
      }
    }
  }
}

.quick-actions-section {
  margin-bottom: 24px;

  .section-title {
    font-size: 20px;
    font-weight: 600;
    margin-bottom: 16px;
    color: #333;
  }

  .quick-actions-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 16px;

    .quick-action-card {
      background: white;
      border-radius: 12px;
      padding: 24px;
      text-align: center;
      cursor: pointer;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
      transition: all 0.3s ease;

      &:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
      }

      .action-icon {
        width: 64px;
        height: 64px;
        border-radius: 16px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 16px auto;
        color: white;
      }

      .action-title {
        font-size: 16px;
        font-weight: 500;
        color: #333;
      }
    }
  }
}

.main-content {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 24px;
}

.left-content,
.right-content {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: 600;
}

.overview-card {
  .overview-content {
    .chart-placeholder {
      height: 300px;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      color: #999;

      p {
        margin: 16px 0 0 0;
        font-size: 14px;
      }
    }
  }
}

.activity-card {
  .activity-list {
    .activity-item {
      display: flex;
      align-items: flex-start;
      gap: 12px;
      padding: 16px 0;
      border-bottom: 1px solid #f0f0f0;

      &:last-child {
        border-bottom: none;
      }

      .activity-icon {
        width: 40px;
        height: 40px;
        border-radius: 8px;
        background-color: #f5f7fa;
        display: flex;
        align-items: center;
        justify-content: center;
      }

      .activity-content {
        flex: 1;

        .activity-text {
          font-size: 14px;
          color: #333;
          margin-bottom: 4px;

          .activity-user {
            font-weight: 500;
            color: #409eff;
          }
        }

        .activity-time {
          font-size: 12px;
          color: #999;
        }
      }
    }
  }
}

.status-card {
  .status-content {
    .status-item {
      margin-bottom: 24px;

      .status-label {
        font-size: 14px;
        color: #666;
        margin-bottom: 8px;
      }

      .status-value {
        margin-bottom: 16px;
      }
    }

    .status-metrics {
      .metric-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 12px 0;
        border-bottom: 1px solid #f0f0f0;

        &:last-child {
          border-bottom: none;
        }

        .metric-label {
          font-size: 14px;
          color: #666;
        }

        .metric-value {
          font-size: 14px;
          font-weight: 500;
          color: #333;
        }
      }
    }
  }
}

.notification-card {
  .notification-badge {
    :deep(.el-badge__content) {
      top: 8px;
      right: 8px;
    }
  }

  .notification-list {
    max-height: 400px;
    overflow-y: auto;

    .notification-item {
      padding: 16px 0;
      border-bottom: 1px solid #f0f0f0;

      &:last-child {
        border-bottom: none;
      }

      &.notification-unread {
        background-color: #f0f9ff;
        border-radius: 8px;
        padding: 16px;
        margin-bottom: 8px;
      }

      .notification-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 8px;

        .notification-title {
          font-size: 14px;
          font-weight: 500;
          color: #333;
        }
      }

      .notification-content {
        font-size: 13px;
        color: #666;
        line-height: 1.5;
        margin-bottom: 8px;
      }

      .notification-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;

        .notification-time {
          font-size: 12px;
          color: #999;
        }
      }
    }
  }
}

// 响应式设计
@media (max-width: 768px) {
  .dashboard-container {
    padding: 16px;
  }

  .welcome-section {
    flex-direction: column;
    text-align: center;
    gap: 24px;
  }

  .main-content {
    grid-template-columns: 1fr;
  }

  .quick-actions-grid {
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  }
}
</style>
