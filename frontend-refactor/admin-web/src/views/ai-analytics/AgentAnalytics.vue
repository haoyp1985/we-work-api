<template>
  <div class="agent-analytics">
    <!-- 统计卡片 -->
    <div class="stats-grid">
      <el-row :gutter="20">
        <el-col :span="6">
          <el-card class="stats-card">
            <div class="stats-content">
              <div class="stats-icon active">
                <el-icon><Robot /></el-icon>
              </div>
              <div class="stats-info">
                <div class="stats-value">{{ stats.activeAgents }}</div>
                <div class="stats-label">活跃代理</div>
              </div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="stats-card">
            <div class="stats-content">
              <div class="stats-icon total">
                <el-icon><DataAnalysis /></el-icon>
              </div>
              <div class="stats-info">
                <div class="stats-value">{{ stats.totalConversations }}</div>
                <div class="stats-label">总对话数</div>
              </div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="stats-card">
            <div class="stats-content">
              <div class="stats-icon success">
                <el-icon><Checked /></el-icon>
              </div>
              <div class="stats-info">
                <div class="stats-value">{{ stats.successRate }}%</div>
                <div class="stats-label">成功率</div>
              </div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="stats-card">
            <div class="stats-content">
              <div class="stats-icon response">
                <el-icon><Timer /></el-icon>
              </div>
              <div class="stats-info">
                <div class="stats-value">{{ stats.avgResponseTime }}ms</div>
                <div class="stats-label">平均响应时间</div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- 图表区域 -->
    <div class="charts-area">
      <el-row :gutter="20">
        <el-col :span="12">
          <el-card title="对话趋势" class="chart-card">
            <div id="conversationChart" class="chart-container"></div>
          </el-card>
        </el-col>
        <el-col :span="12">
          <el-card title="代理性能" class="chart-card">
            <div id="performanceChart" class="chart-container"></div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- 代理列表 -->
    <div class="agent-list">
      <el-card title="代理分析">
        <template #header>
          <div class="card-header">
            <span>代理分析</span>
            <el-button type="primary" @click="refreshData">
              <el-icon><Refresh /></el-icon>
              刷新数据
            </el-button>
          </div>
        </template>
        
        <el-table :data="agentData" :loading="loading" stripe border>
          <el-table-column prop="name" label="代理名称" width="150" />
          <el-table-column prop="type" label="类型" width="120">
            <template #default="{ row }">
              <el-tag :type="getAgentTypeColor(row.type)">
                {{ row.type }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="conversations" label="对话数" width="100" />
          <el-table-column prop="successRate" label="成功率" width="100">
            <template #default="{ row }">
              <el-progress 
                :percentage="row.successRate" 
                :color="getProgressColor(row.successRate)"
                :show-text="false"
              />
              <span class="progress-text">{{ row.successRate }}%</span>
            </template>
          </el-table-column>
          <el-table-column prop="avgResponseTime" label="平均响应时间" width="130" />
          <el-table-column prop="lastActive" label="最后活跃时间" width="180" />
          <el-table-column prop="status" label="状态" width="100">
            <template #default="{ row }">
              <el-tag :type="row.status === 'online' ? 'success' : 'danger'">
                {{ row.status === 'online' ? '在线' : '离线' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" fixed="right" width="150">
            <template #default="{ row }">
              <el-button size="small" type="primary" link @click="viewDetails(row)">
                详情
              </el-button>
              <el-button size="small" type="success" link @click="viewLogs(row)">
                日志
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-card>
    </div>

    <!-- 详情对话框 -->
    <el-dialog v-model="detailVisible" title="代理详情" width="800px">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="代理名称">{{ currentAgent.name }}</el-descriptions-item>
        <el-descriptions-item label="类型">{{ currentAgent.type }}</el-descriptions-item>
        <el-descriptions-item label="对话数">{{ currentAgent.conversations }}</el-descriptions-item>
        <el-descriptions-item label="成功率">{{ currentAgent.successRate }}%</el-descriptions-item>
        <el-descriptions-item label="平均响应时间">{{ currentAgent.avgResponseTime }}</el-descriptions-item>
        <el-descriptions-item label="状态">{{ currentAgent.status === 'online' ? '在线' : '离线' }}</el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ currentAgent.createdAt }}</el-descriptions-item>
        <el-descriptions-item label="最后活跃时间">{{ currentAgent.lastActive }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, nextTick } from 'vue'
import { ElMessage } from 'element-plus'
import { Robot, DataAnalysis, Checked, Timer, Refresh } from '@element-plus/icons-vue'

// 响应式数据
const loading = ref(false)
const detailVisible = ref(false)
const currentAgent = ref({} as any)

// 统计数据
const stats = reactive({
  activeAgents: 12,
  totalConversations: 1547,
  successRate: 92.5,
  avgResponseTime: 850
})

// 代理数据
const agentData = ref([
  {
    id: '1',
    name: '客服代理-01',
    type: '客服助手',
    conversations: 234,
    successRate: 95,
    avgResponseTime: '720ms',
    lastActive: '2024-01-01 10:30:00',
    status: 'online',
    createdAt: '2024-01-01 09:00:00'
  },
  {
    id: '2',
    name: '销售代理-01',
    type: '销售助手',
    conversations: 156,
    successRate: 88,
    avgResponseTime: '980ms',
    lastActive: '2024-01-01 10:25:00',
    status: 'online',
    createdAt: '2024-01-01 08:30:00'
  }
])

// 方法
const refreshData = async () => {
  loading.value = true
  try {
    // 模拟刷新数据
    setTimeout(() => {
      ElMessage.success('数据刷新成功')
      loading.value = false
    }, 1000)
  } catch (error) {
    ElMessage.error('数据刷新失败')
    loading.value = false
  }
}

const viewDetails = (row: any) => {
  currentAgent.value = row
  detailVisible.value = true
}

const viewLogs = (row: any) => {
  ElMessage.info(`查看 ${row.name} 的日志`)
}

const getAgentTypeColor = (type: string) => {
  const colorMap: Record<string, string> = {
    '客服助手': 'primary',
    '销售助手': 'success',
    '技术助手': 'warning',
    '营销助手': 'danger'
  }
  return colorMap[type] || 'info'
}

const getProgressColor = (percentage: number) => {
  if (percentage >= 90) return '#67c23a'
  if (percentage >= 70) return '#e6a23c'
  return '#f56c6c'
}

const initCharts = () => {
  // 这里可以初始化ECharts图表
  // 暂时用占位符
  nextTick(() => {
    const conversationEl = document.getElementById('conversationChart')
    const performanceEl = document.getElementById('performanceChart')
    
    if (conversationEl) {
      conversationEl.innerHTML = '<div style="text-align: center; padding: 50px; color: #999;">对话趋势图表</div>'
    }
    
    if (performanceEl) {
      performanceEl.innerHTML = '<div style="text-align: center; padding: 50px; color: #999;">性能分析图表</div>'
    }
  })
}

// 生命周期
onMounted(() => {
  initCharts()
})
</script>

<style lang="scss" scoped>
.agent-analytics {
  padding: 20px;

  .stats-grid {
    margin-bottom: 20px;

    .stats-card {
      .stats-content {
        display: flex;
        align-items: center;
        padding: 10px 0;

        .stats-icon {
          width: 60px;
          height: 60px;
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          margin-right: 15px;
          font-size: 24px;
          color: #fff;

          &.active {
            background: linear-gradient(135deg, #409eff, #66b1ff);
          }

          &.total {
            background: linear-gradient(135deg, #67c23a, #85ce61);
          }

          &.success {
            background: linear-gradient(135deg, #e6a23c, #ebb563);
          }

          &.response {
            background: linear-gradient(135deg, #f56c6c, #f78989);
          }
        }

        .stats-info {
          flex: 1;

          .stats-value {
            font-size: 24px;
            font-weight: bold;
            color: #303133;
            line-height: 1;
          }

          .stats-label {
            font-size: 14px;
            color: #909399;
            margin-top: 5px;
          }
        }
      }
    }
  }

  .charts-area {
    margin-bottom: 20px;

    .chart-card {
      height: 400px;

      .chart-container {
        height: 300px;
        background: #f5f7fa;
        border-radius: 4px;
      }
    }
  }

  .agent-list {
    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .progress-text {
      margin-left: 10px;
      font-size: 12px;
      color: #606266;
    }
  }
}
</style>