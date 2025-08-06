<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage } from 'element-plus'
import { 
  ArrowLeft, 
  Edit, 
  ChatDotRound, 
  DataBoard, 
  Setting,
  Star,
  Share,
  Download,
  Refresh,
  Switch,
  View
} from '@element-plus/icons-vue'
import { useRouter, useRoute } from 'vue-router'
import * as echarts from 'echarts'

const router = useRouter()
const route = useRoute()

// 智能体ID
const agentId = computed(() => route.params.id as string)

// 智能体状态和类型枚举
enum AgentStatus {
  DRAFT = 'DRAFT',
  PUBLISHED = 'PUBLISHED',
  DISABLED = 'DISABLED'
}

enum AgentType {
  CHAT = 'CHAT',
  TASK = 'TASK',
  ANALYSIS = 'ANALYSIS'
}

// 智能体数据接口
interface Agent {
  id: string
  name: string
  description: string
  type: AgentType
  status: AgentStatus
  avatar?: string
  tags: string[]
  platformType: string
  modelName: string
  systemPrompt: string
  temperature: number
  maxTokens: number
  topP: number
  frequencyPenalty: number
  presencePenalty: number
  features: {
    memoryEnabled: boolean
    contextWindow: number
    streamResponse: boolean
    webSearch: boolean
    codeExecution: boolean
    imageAnalysis: boolean
  }
  security: {
    contentFilter: boolean
    rateLimitEnabled: boolean
    maxRequestsPerMinute: number
    allowedDomains: string[]
    blockedKeywords: string[]
  }
  createdAt: string
  updatedAt: string
  createdBy: string
  lastActiveAt?: string
}

// 使用统计接口
interface AgentStats {
  totalConversations: number
  totalMessages: number
  totalUsers: number
  averageRating: number
  totalCost: number
  todayConversations: number
  todayMessages: number
  thisWeekConversations: number
  thisMonthConversations: number
}

// 响应式数据
const loading = ref(false)
const agentData = ref<Agent | null>(null)
const statsData = ref<AgentStats | null>(null)
const activeTab = ref('overview')

// 图表引用
const usageChartRef = ref()
const ratingChartRef = ref()
const costChartRef = ref()

// 状态选项
const statusOptions = [
  { label: '草稿', value: AgentStatus.DRAFT, type: 'info' },
  { label: '已发布', value: AgentStatus.PUBLISHED, type: 'success' },
  { label: '已禁用', value: AgentStatus.DISABLED, type: 'danger' }
]

const typeOptions = [
  { label: '聊天助手', value: AgentType.CHAT, icon: '💬' },
  { label: '任务处理', value: AgentType.TASK, icon: '⚙️' },
  { label: '数据分析', value: AgentType.ANALYSIS, icon: '📊' }
]

const platformOptions = [
  { label: 'OpenAI', value: 'OPENAI' },
  { label: 'Anthropic Claude', value: 'ANTHROPIC_CLAUDE' },
  { label: '百度文心一言', value: 'BAIDU_WENXIN' },
  { label: 'Coze', value: 'COZE' },
  { label: 'Dify', value: 'DIFY' }
]

// 计算属性
const statusText = computed(() => {
  if (!agentData.value) return ''
  const option = statusOptions.find(opt => opt.value === agentData.value?.status)
  return option?.label || agentData.value.status
})

const statusType = computed(() => {
  if (!agentData.value) return 'info'
  const option = statusOptions.find(opt => opt.value === agentData.value?.status)
  return option?.type || 'info'
})

const typeText = computed(() => {
  if (!agentData.value) return ''
  const option = typeOptions.find(opt => opt.value === agentData.value?.type)
  return option?.label || agentData.value.type
})

const typeIcon = computed(() => {
  if (!agentData.value) return ''
  const option = typeOptions.find(opt => opt.value === agentData.value?.type)
  return option?.icon || ''
})

const platformText = computed(() => {
  if (!agentData.value) return ''
  const option = platformOptions.find(opt => opt.value === agentData.value?.platformType)
  return option?.label || agentData.value.platformType
})

// 模拟数据
const mockAgentData: Agent = {
  id: '1',
  name: '智能客服助手',
  description: '专业的客户服务AI助手，能够处理常见问题咨询、产品介绍等。具备多轮对话能力，可以理解上下文，提供个性化的服务体验。',
  type: AgentType.CHAT,
  status: AgentStatus.PUBLISHED,
  avatar: 'https://avatars.githubusercontent.com/u/1?v=4',
  tags: ['客服', '咨询', '自动化', '多语言'],
  platformType: 'OPENAI',
  modelName: 'gpt-3.5-turbo',
  systemPrompt: '你是一个专业的客户服务AI助手，请始终保持友好、专业的态度，为用户提供准确、有用的信息。你需要：\n1. 耐心倾听用户的问题\n2. 提供清晰、准确的答案\n3. 在必要时引导用户联系人工客服\n4. 保持礼貌和专业的语调',
  temperature: 0.7,
  maxTokens: 2048,
  topP: 1.0,
  frequencyPenalty: 0.0,
  presencePenalty: 0.0,
  features: {
    memoryEnabled: true,
    contextWindow: 4000,
    streamResponse: true,
    webSearch: false,
    codeExecution: false,
    imageAnalysis: false
  },
  security: {
    contentFilter: true,
    rateLimitEnabled: true,
    maxRequestsPerMinute: 60,
    allowedDomains: ['company.com', 'support.company.com'],
    blockedKeywords: ['敏感词1', '敏感词2']
  },
  createdAt: '2024-01-10 09:30:00',
  updatedAt: '2024-01-15 14:20:00',
  createdBy: '张三',
  lastActiveAt: '2024-01-15 16:45:00'
}

const mockStatsData: AgentStats = {
  totalConversations: 156,
  totalMessages: 2341,
  totalUsers: 89,
  averageRating: 4.7,
  totalCost: 45.67,
  todayConversations: 12,
  todayMessages: 87,
  thisWeekConversations: 67,
  thisMonthConversations: 156
}

// 使用趋势图数据
const usageChartData = {
  dates: ['01-10', '01-11', '01-12', '01-13', '01-14', '01-15', '01-16'],
  conversations: [12, 15, 8, 22, 18, 25, 12],
  messages: [180, 225, 120, 330, 270, 375, 180]
}

// 评分分布数据
const ratingChartData = [
  { rating: '5星', count: 45, percentage: 65 },
  { rating: '4星', count: 18, percentage: 26 },
  { rating: '3星', count: 4, percentage: 6 },
  { rating: '2星', count: 2, percentage: 3 },
  { rating: '1星', count: 0, percentage: 0 }
]

// 成本趋势数据
const costChartData = {
  dates: ['01-10', '01-11', '01-12', '01-13', '01-14', '01-15', '01-16'],
  costs: [3.2, 4.1, 2.8, 6.5, 5.2, 7.8, 3.9]
}

// 加载智能体数据
const loadAgentData = async () => {
  loading.value = true
  try {
    // 模拟API调用
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    agentData.value = mockAgentData
    statsData.value = mockStatsData
    
    // 延迟初始化图表，确保DOM已渲染
    setTimeout(() => {
      initCharts()
    }, 100)
  } catch (error) {
    ElMessage.error('加载智能体数据失败')
  } finally {
    loading.value = false
  }
}

// 初始化图表
const initCharts = () => {
  initUsageChart()
  initRatingChart()
  initCostChart()
}

// 使用趋势图
const initUsageChart = () => {
  if (!usageChartRef.value) return
  
  const chart = echarts.init(usageChartRef.value)
  const option = {
    title: {
      text: '使用趋势',
      textStyle: { fontSize: 16 }
    },
    tooltip: {
      trigger: 'axis',
      axisPointer: { type: 'cross' }
    },
    legend: {
      data: ['会话数', '消息数']
    },
    xAxis: {
      type: 'category',
      data: usageChartData.dates
    },
    yAxis: [
      {
        type: 'value',
        name: '会话数',
        position: 'left'
      },
      {
        type: 'value',
        name: '消息数',
        position: 'right'
      }
    ],
    series: [
      {
        name: '会话数',
        type: 'line',
        data: usageChartData.conversations,
        smooth: true,
        itemStyle: { color: '#409EFF' }
      },
      {
        name: '消息数',
        type: 'bar',
        yAxisIndex: 1,
        data: usageChartData.messages,
        itemStyle: { color: '#67C23A' }
      }
    ]
  }
  chart.setOption(option)
}

// 评分分布图
const initRatingChart = () => {
  if (!ratingChartRef.value) return
  
  const chart = echarts.init(ratingChartRef.value)
  const option = {
    title: {
      text: '用户评分分布',
      textStyle: { fontSize: 16 }
    },
    tooltip: {
      trigger: 'item',
      formatter: '{b}: {c} ({d}%)'
    },
    series: [
      {
        type: 'pie',
        radius: ['40%', '70%'],
        avoidLabelOverlap: false,
        label: {
          show: false,
          position: 'center'
        },
        emphasis: {
          label: {
            show: true,
            fontSize: '18',
            fontWeight: 'bold'
          }
        },
        labelLine: {
          show: false
        },
        data: ratingChartData.map(item => ({
          name: item.rating,
          value: item.count
        }))
      }
    ]
  }
  chart.setOption(option)
}

// 成本趋势图
const initCostChart = () => {
  if (!costChartRef.value) return
  
  const chart = echarts.init(costChartRef.value)
  const option = {
    title: {
      text: '成本趋势 ($)',
      textStyle: { fontSize: 16 }
    },
    tooltip: {
      trigger: 'axis',
      formatter: '{b}: ${c}'
    },
    xAxis: {
      type: 'category',
      data: costChartData.dates
    },
    yAxis: {
      type: 'value',
      name: '成本 ($)'
    },
    series: [
      {
        type: 'line',
        data: costChartData.costs,
        smooth: true,
        areaStyle: {
          opacity: 0.3
        },
        itemStyle: { color: '#E6A23C' }
      }
    ]
  }
  chart.setOption(option)
}

// 操作方法
const handleEdit = () => {
  router.push(`/ai-agent/edit/${agentId.value}`)
}

const handleChat = () => {
  router.push(`/conversation/chat/${agentId.value}`)
}

const handleViewAnalytics = () => {
  router.push(`/ai-analytics/agent/${agentId.value}`)
}

const handleToggleStatus = async () => {
  if (!agentData.value) return
  
  const newStatus = agentData.value.status === AgentStatus.PUBLISHED 
    ? AgentStatus.DISABLED 
    : AgentStatus.PUBLISHED
  
  try {
    // 模拟API调用
    await new Promise(resolve => setTimeout(resolve, 500))
    
    agentData.value.status = newStatus
    agentData.value.updatedAt = new Date().toLocaleString()
    
    ElMessage.success(`智能体已${newStatus === AgentStatus.PUBLISHED ? '启用' : '禁用'}`)
  } catch (error) {
    ElMessage.error('状态切换失败')
  }
}

const handleShare = () => {
  // 模拟分享功能
  navigator.clipboard?.writeText(`${window.location.origin}/conversation/chat/${agentId.value}`)
  ElMessage.success('分享链接已复制到剪贴板')
}

const handleExport = () => {
  // 模拟导出功能
  ElMessage.success('配置导出功能开发中...')
}

const handleRefresh = () => {
  loadAgentData()
}

const handleBack = () => {
  router.push('/ai-agent')
}

// 生命周期
onMounted(() => {
  loadAgentData()
})
</script>

<template>
  <div class="agent-detail-container" v-loading="loading">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-left">
        <el-button :icon="ArrowLeft" @click="handleBack" class="back-btn">
          返回列表
        </el-button>
        
        <div class="agent-basic-info" v-if="agentData">
          <el-avatar 
            :src="agentData.avatar" 
            :size="60"
            class="agent-avatar"
          >
            {{ agentData.name.charAt(0) }}
          </el-avatar>
          
          <div class="agent-info">
            <div class="agent-name">
              {{ agentData.name }}
              <el-tag 
                :type="statusType" 
                size="small"
                class="status-tag"
              >
                {{ statusText }}
              </el-tag>
            </div>
            <div class="agent-meta">
              <span class="agent-type">{{ typeIcon }} {{ typeText }}</span>
              <span class="agent-platform">{{ platformText }}</span>
              <span class="agent-model">{{ agentData.modelName }}</span>
            </div>
            <div class="agent-desc">{{ agentData.description }}</div>
          </div>
        </div>
      </div>
      
      <div class="header-actions" v-if="agentData">
        <el-button :icon="Refresh" @click="handleRefresh">
          刷新
        </el-button>
        <el-button :icon="Share" @click="handleShare">
          分享
        </el-button>
        <el-button :icon="Download" @click="handleExport">
          导出
        </el-button>
        <el-button 
          type="primary" 
          :icon="ChatDotRound"
          @click="handleChat"
          v-if="agentData.status === AgentStatus.PUBLISHED"
        >
          开始对话
        </el-button>
        <el-button 
          type="warning" 
          :icon="Edit"
          @click="handleEdit"
        >
          编辑
        </el-button>
        <el-button 
          :type="agentData.status === AgentStatus.PUBLISHED ? 'danger' : 'success'"
          :icon="Switch"
          @click="handleToggleStatus"
          v-if="agentData.status !== AgentStatus.DRAFT"
        >
          {{ agentData.status === AgentStatus.PUBLISHED ? '禁用' : '启用' }}
        </el-button>
      </div>
    </div>

    <!-- 统计卡片 -->
    <div class="stats-cards" v-if="statsData">
      <el-row :gutter="20">
        <el-col :span="6">
          <el-card shadow="hover" class="stat-card">
            <div class="stat-content">
              <div class="stat-icon conversations">💬</div>
              <div class="stat-info">
                <div class="stat-number">{{ statsData.totalConversations }}</div>
                <div class="stat-label">总会话数</div>
                <div class="stat-change">今日 +{{ statsData.todayConversations }}</div>
              </div>
            </div>
          </el-card>
        </el-col>
        
        <el-col :span="6">
          <el-card shadow="hover" class="stat-card">
            <div class="stat-content">
              <div class="stat-icon messages">📨</div>
              <div class="stat-info">
                <div class="stat-number">{{ statsData.totalMessages }}</div>
                <div class="stat-label">总消息数</div>
                <div class="stat-change">今日 +{{ statsData.todayMessages }}</div>
              </div>
            </div>
          </el-card>
        </el-col>
        
        <el-col :span="6">
          <el-card shadow="hover" class="stat-card">
            <div class="stat-content">
              <div class="stat-icon rating">⭐</div>
              <div class="stat-info">
                <div class="stat-number">{{ statsData.averageRating }}</div>
                <div class="stat-label">平均评分</div>
                <div class="stat-change">{{ statsData.totalUsers }} 人评价</div>
              </div>
            </div>
          </el-card>
        </el-col>
        
        <el-col :span="6">
          <el-card shadow="hover" class="stat-card">
            <div class="stat-content">
              <div class="stat-icon cost">💰</div>
              <div class="stat-info">
                <div class="stat-number">${{ statsData.totalCost }}</div>
                <div class="stat-label">总成本</div>
                <div class="stat-change">本月消费</div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- 主要内容 -->
    <el-card class="main-content" shadow="never">
      <el-tabs v-model="activeTab" type="border-card">
        <!-- 概览 -->
        <el-tab-pane label="概览" name="overview">
          <el-row :gutter="20">
            <el-col :span="16">
              <!-- 使用趋势图 -->
              <el-card shadow="never" class="chart-card">
                <div ref="usageChartRef" class="chart-container"></div>
              </el-card>
            </el-col>
            
            <el-col :span="8">
              <!-- 评分分布图 -->
              <el-card shadow="never" class="chart-card">
                <div ref="ratingChartRef" class="chart-container"></div>
              </el-card>
            </el-col>
          </el-row>
          
          <el-row :gutter="20" style="margin-top: 20px;">
            <el-col :span="24">
              <!-- 成本趋势图 -->
              <el-card shadow="never" class="chart-card">
                <div ref="costChartRef" class="chart-container"></div>
              </el-card>
            </el-col>
          </el-row>
        </el-tab-pane>

        <!-- 配置信息 -->
        <el-tab-pane label="配置信息" name="config" v-if="agentData">
          <el-row :gutter="20">
            <el-col :span="12">
              <el-card shadow="never" title="基本配置" class="config-card">
                <el-descriptions :column="1" border>
                  <el-descriptions-item label="智能体名称">{{ agentData.name }}</el-descriptions-item>
                  <el-descriptions-item label="类型">{{ typeText }}</el-descriptions-item>
                  <el-descriptions-item label="状态">
                    <el-tag :type="statusType" size="small">{{ statusText }}</el-tag>
                  </el-descriptions-item>
                  <el-descriptions-item label="平台">{{ platformText }}</el-descriptions-item>
                  <el-descriptions-item label="模型">{{ agentData.modelName }}</el-descriptions-item>
                  <el-descriptions-item label="标签">
                    <el-tag 
                      v-for="tag in agentData.tags" 
                      :key="tag" 
                      size="small" 
                      style="margin-right: 8px;"
                    >
                      {{ tag }}
                    </el-tag>
                  </el-descriptions-item>
                  <el-descriptions-item label="创建者">{{ agentData.createdBy }}</el-descriptions-item>
                  <el-descriptions-item label="创建时间">{{ agentData.createdAt }}</el-descriptions-item>
                  <el-descriptions-item label="更新时间">{{ agentData.updatedAt }}</el-descriptions-item>
                  <el-descriptions-item label="最后活跃">{{ agentData.lastActiveAt || '未使用' }}</el-descriptions-item>
                </el-descriptions>
              </el-card>
            </el-col>
            
            <el-col :span="12">
              <el-card shadow="never" title="模型参数" class="config-card">
                <el-descriptions :column="1" border>
                  <el-descriptions-item label="温度系数">{{ agentData.temperature }}</el-descriptions-item>
                  <el-descriptions-item label="最大Token">{{ agentData.maxTokens }}</el-descriptions-item>
                  <el-descriptions-item label="Top P">{{ agentData.topP }}</el-descriptions-item>
                  <el-descriptions-item label="频率惩罚">{{ agentData.frequencyPenalty }}</el-descriptions-item>
                  <el-descriptions-item label="存在惩罚">{{ agentData.presencePenalty }}</el-descriptions-item>
                </el-descriptions>
              </el-card>
            </el-col>
          </el-row>

          <el-row :gutter="20" style="margin-top: 20px;">
            <el-col :span="24">
              <el-card shadow="never" title="系统提示词" class="config-card">
                <div class="system-prompt">
                  {{ agentData.systemPrompt }}
                </div>
              </el-card>
            </el-col>
          </el-row>

          <el-row :gutter="20" style="margin-top: 20px;">
            <el-col :span="12">
              <el-card shadow="never" title="功能配置" class="config-card">
                <div class="feature-list">
                  <div class="feature-item">
                    <span class="feature-name">记忆功能</span>
                    <el-tag :type="agentData.features.memoryEnabled ? 'success' : 'info'" size="small">
                      {{ agentData.features.memoryEnabled ? '已启用' : '已禁用' }}
                    </el-tag>
                  </div>
                  <div class="feature-item">
                    <span class="feature-name">上下文窗口</span>
                    <span class="feature-value">{{ agentData.features.contextWindow }} tokens</span>
                  </div>
                  <div class="feature-item">
                    <span class="feature-name">流式响应</span>
                    <el-tag :type="agentData.features.streamResponse ? 'success' : 'info'" size="small">
                      {{ agentData.features.streamResponse ? '已启用' : '已禁用' }}
                    </el-tag>
                  </div>
                  <div class="feature-item">
                    <span class="feature-name">网络搜索</span>
                    <el-tag :type="agentData.features.webSearch ? 'success' : 'info'" size="small">
                      {{ agentData.features.webSearch ? '已启用' : '已禁用' }}
                    </el-tag>
                  </div>
                  <div class="feature-item">
                    <span class="feature-name">代码执行</span>
                    <el-tag :type="agentData.features.codeExecution ? 'success' : 'info'" size="small">
                      {{ agentData.features.codeExecution ? '已启用' : '已禁用' }}
                    </el-tag>
                  </div>
                  <div class="feature-item">
                    <span class="feature-name">图像分析</span>
                    <el-tag :type="agentData.features.imageAnalysis ? 'success' : 'info'" size="small">
                      {{ agentData.features.imageAnalysis ? '已启用' : '已禁用' }}
                    </el-tag>
                  </div>
                </div>
              </el-card>
            </el-col>
            
            <el-col :span="12">
              <el-card shadow="never" title="安全配置" class="config-card">
                <div class="feature-list">
                  <div class="feature-item">
                    <span class="feature-name">内容过滤</span>
                    <el-tag :type="agentData.security.contentFilter ? 'success' : 'warning'" size="small">
                      {{ agentData.security.contentFilter ? '已启用' : '已禁用' }}
                    </el-tag>
                  </div>
                  <div class="feature-item">
                    <span class="feature-name">速率限制</span>
                    <el-tag :type="agentData.security.rateLimitEnabled ? 'success' : 'info'" size="small">
                      {{ agentData.security.rateLimitEnabled ? '已启用' : '已禁用' }}
                    </el-tag>
                  </div>
                  <div class="feature-item" v-if="agentData.security.rateLimitEnabled">
                    <span class="feature-name">最大请求数</span>
                    <span class="feature-value">{{ agentData.security.maxRequestsPerMinute }}/分钟</span>
                  </div>
                  <div class="feature-item" v-if="agentData.security.allowedDomains.length > 0">
                    <span class="feature-name">允许域名</span>
                    <div class="domain-list">
                      <el-tag 
                        v-for="domain in agentData.security.allowedDomains" 
                        :key="domain" 
                        size="small"
                        style="margin-right: 4px; margin-bottom: 4px;"
                      >
                        {{ domain }}
                      </el-tag>
                    </div>
                  </div>
                  <div class="feature-item" v-if="agentData.security.blockedKeywords.length > 0">
                    <span class="feature-name">屏蔽关键词</span>
                    <div class="keyword-list">
                      <el-tag 
                        v-for="keyword in agentData.security.blockedKeywords" 
                        :key="keyword" 
                        type="warning"
                        size="small"
                        style="margin-right: 4px; margin-bottom: 4px;"
                      >
                        {{ keyword }}
                      </el-tag>
                    </div>
                  </div>
                </div>
              </el-card>
            </el-col>
          </el-row>
        </el-tab-pane>

        <!-- 使用统计 -->
        <el-tab-pane label="使用统计" name="statistics">
          <div class="stats-section">
            <el-button type="primary" :icon="DataBoard" @click="handleViewAnalytics">
              查看详细分析
            </el-button>
            <p style="margin-top: 20px; color: #606266;">
              更多详细的使用统计和分析数据请点击上方按钮查看完整的分析报告。
            </p>
          </div>
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<style scoped lang="scss">
.agent-detail-container {
  padding: 20px;
  background-color: #f5f7fa;
  min-height: calc(100vh - 60px);
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 20px;
  
  .header-left {
    display: flex;
    align-items: center;
    gap: 20px;
    
    .back-btn {
      flex-shrink: 0;
    }
    
    .agent-basic-info {
      display: flex;
      align-items: center;
      gap: 16px;
      
      .agent-avatar {
        flex-shrink: 0;
      }
      
      .agent-info {
        .agent-name {
          display: flex;
          align-items: center;
          gap: 12px;
          font-size: 24px;
          font-weight: 600;
          color: #303133;
          margin-bottom: 8px;
          
          .status-tag {
            font-size: 12px;
          }
        }
        
        .agent-meta {
          display: flex;
          align-items: center;
          gap: 16px;
          margin-bottom: 8px;
          font-size: 14px;
          color: #606266;
          
          .agent-type {
            font-weight: 500;
          }
        }
        
        .agent-desc {
          color: #909399;
          font-size: 14px;
          line-height: 1.5;
          max-width: 600px;
        }
      }
    }
  }
  
  .header-actions {
    display: flex;
    gap: 12px;
    flex-wrap: wrap;
  }
}

.stats-cards {
  margin-bottom: 20px;
  
  .stat-card {
    height: 120px;
    
    :deep(.el-card__body) {
      padding: 20px;
      height: 100%;
    }
    
    .stat-content {
      display: flex;
      align-items: center;
      height: 100%;
      gap: 16px;
      
      .stat-icon {
        width: 60px;
        height: 60px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
        
        &.conversations {
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        &.messages {
          background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        
        &.rating {
          background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }
        
        &.cost {
          background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
        }
      }
      
      .stat-info {
        flex: 1;
        
        .stat-number {
          font-size: 28px;
          font-weight: 600;
          color: #303133;
          line-height: 1;
          margin-bottom: 4px;
        }
        
        .stat-label {
          font-size: 14px;
          color: #606266;
          margin-bottom: 4px;
        }
        
        .stat-change {
          font-size: 12px;
          color: #67c23a;
        }
      }
    }
  }
}

.main-content {
  :deep(.el-card__body) {
    padding: 0;
  }
  
  :deep(.el-tabs__content) {
    padding: 20px;
  }
}

.chart-card {
  margin-bottom: 20px;
  
  .chart-container {
    width: 100%;
    height: 300px;
  }
}

.config-card {
  margin-bottom: 20px;
  
  .system-prompt {
    padding: 16px;
    background-color: #f8f9fa;
    border-radius: 6px;
    border-left: 4px solid #409eff;
    white-space: pre-wrap;
    font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
    font-size: 14px;
    line-height: 1.6;
    color: #303133;
  }
  
  .feature-list {
    .feature-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 12px 0;
      border-bottom: 1px solid #ebeef5;
      
      &:last-child {
        border-bottom: none;
      }
      
      .feature-name {
        font-weight: 500;
        color: #303133;
      }
      
      .feature-value {
        color: #606266;
        font-family: monospace;
      }
      
      .domain-list,
      .keyword-list {
        display: flex;
        flex-wrap: wrap;
        gap: 4px;
        max-width: 200px;
      }
    }
  }
}

.stats-section {
  text-align: center;
  padding: 40px 20px;
}
</style>