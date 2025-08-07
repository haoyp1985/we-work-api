<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { 
  Plus, 
  Edit, 
  Delete, 
  Search, 
  Refresh, 
  View,
  Switch,
  Setting,
  ChatDotRound,
  DataBoard,
  Document
} from '@element-plus/icons-vue'
import { useRouter } from 'vue-router'
import * as agentApi from '@/api/agent'
import type { Agent, AgentQuery, AgentStatus, AgentType } from '@/types/api'

const router = useRouter()

// 响应式数据
const loading = ref(false)
const tableData = ref<Agent[]>([])
const total = ref(0)

// 搜索表单
const searchForm = reactive<AgentQuery>({
  current: 1,
  size: 10,
  keyword: '',
  status: undefined,
  type: undefined,
  platformType: undefined
})

// 状态选项
const statusOptions = [
  { label: '草稿', value: AgentStatus.DRAFT, type: 'info' },
  { label: '已发布', value: AgentStatus.PUBLISHED, type: 'success' },
  { label: '已禁用', value: AgentStatus.DISABLED, type: 'danger' }
]

const typeOptions = [
  { label: '聊天助手', value: AgentType.CHAT },
  { label: '任务处理', value: AgentType.TASK },
  { label: '数据分析', value: AgentType.ANALYSIS }
]

const platformOptions = [
  { label: 'OpenAI', value: 'OPENAI' },
  { label: 'Claude', value: 'ANTHROPIC_CLAUDE' },
  { label: '文心一言', value: 'BAIDU_WENXIN' },
  { label: 'Coze', value: 'COZE' },
  { label: 'Dify', value: 'DIFY' }
]

// 计算属性 - 服务端分页，不需要前端过滤
const filteredData = computed(() => {
  return tableData.value
})

// 获取状态标签类型
const getStatusType = (status: AgentStatus) => {
  const option = statusOptions.find(opt => opt.value === status)
  return option?.type || 'info'
}

// 获取状态标签文本
const getStatusText = (status: AgentStatus) => {
  const option = statusOptions.find(opt => opt.value === status)
  return option?.label || status
}

// 获取类型文本
const getTypeText = (type: AgentType) => {
  const option = typeOptions.find(opt => opt.value === type)
  return option?.label || type
}

// 获取平台文本
const getPlatformText = (platform: string) => {
  const option = platformOptions.find(opt => opt.value === platform)
  return option?.label || platform
}

// 加载数据
const loadData = async () => {
  loading.value = true
  try {
    const response = await agentApi.getAgents(searchForm)
    tableData.value = response.data.records || response.data.items || []
    total.value = response.data.total || 0
    searchForm.current = response.data.current || searchForm.current
    searchForm.size = response.data.size || searchForm.size
  } catch (error) {
    console.error('加载智能体列表失败:', error)
    ElMessage.error('加载数据失败')
  } finally {
    loading.value = false
  }
}

// 搜索
const handleSearch = () => {
  searchForm.current = 1
  loadData()
}

// 重置搜索
const handleReset = () => {
  Object.assign(searchForm, {
    current: 1,
    size: 10,
    keyword: '',
    status: undefined,
    type: undefined,
    platformType: undefined
  })
  loadData()
}

// 新建智能体
const handleCreate = () => {
  router.push('/ai-agent/create')
}

// 编辑智能体
const handleEdit = (row: Agent) => {
  router.push(`/ai-agent/edit/${row.id}`)
}

// 查看详情
const handleView = (row: Agent) => {
  router.push(`/ai-agent/detail/${row.id}`)
}

// 版本管理
const handleVersions = (row: Agent) => {
  router.push(`/ai-agent/${row.id}/versions`)
}

// 删除智能体
const handleDelete = async (row: Agent) => {
  try {
    await ElMessageBox.confirm(
      `确认删除智能体"${row.name}"吗？此操作不可恢复。`,
      '删除确认',
      {
        confirmButtonText: '确认删除',
        cancelButtonText: '取消',
        type: 'warning',
      }
    )
    
    await agentApi.deleteAgent(row.id)
    
    // 重新加载数据
    await loadData()
  } catch (error) {
    // 用户取消删除或API错误
    if (error && typeof error === 'object' && 'message' in error) {
      console.error('删除智能体失败:', error)
    }
  }
}

// 切换状态
const handleStatusToggle = async (row: Agent) => {
  const newStatus = row.status === AgentStatus.PUBLISHED ? AgentStatus.DISABLED : AgentStatus.PUBLISHED
  
  try {
    const response = await agentApi.toggleAgentStatus(row.id, newStatus)
    
    // 更新本地数据
    const index = tableData.value.findIndex(item => item.id === row.id)
    if (index > -1) {
      tableData.value[index] = response.data
    }
  } catch (error) {
    console.error('状态切换失败:', error)
    ElMessage.error('状态切换失败')
  }
}

// 进入对话
const handleChat = (row: Agent) => {
  router.push(`/conversation/chat/${row.id}`)
}

// 查看统计
const handleStats = (row: Agent) => {
  router.push(`/ai-analytics/agent/${row.id}`)
}

// 分页变化
const handlePageChange = (page: number) => {
  searchForm.current = page
  loadData()
}

const handleSizeChange = (size: number) => {
  searchForm.size = size
  searchForm.current = 1
  loadData()
}

// 生命周期
onMounted(() => {
  loadData()
})
</script>

<template>
  <div class="agent-list-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">AI智能体管理</h1>
        <p class="page-subtitle">管理和配置您的AI智能体，包括聊天助手、任务处理和数据分析等类型</p>
      </div>
      <div class="header-actions">
        <el-button type="primary" :icon="Plus" @click="handleCreate">
          新建智能体
        </el-button>
      </div>
    </div>

    <!-- 搜索区域 -->
    <el-card class="search-card" shadow="never">
      <el-form :model="searchForm" inline>
        <el-form-item label="关键词">
          <el-input
            v-model="searchForm.keyword"
            placeholder="搜索智能体名称或描述"
            :prefix-icon="Search"
            clearable
            style="width: 240px"
            @keyup.enter="handleSearch"
          />
        </el-form-item>
        
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="选择状态" clearable style="width: 140px">
            <el-option
              v-for="option in statusOptions"
              :key="option.value"
              :label="option.label"
              :value="option.value"
            />
          </el-select>
        </el-form-item>

        <el-form-item label="类型">
          <el-select v-model="searchForm.type" placeholder="选择类型" clearable style="width: 140px">
            <el-option
              v-for="option in typeOptions"
              :key="option.value"
              :label="option.label"
              :value="option.value"
            />
          </el-select>
        </el-form-item>

        <el-form-item label="平台">
          <el-select v-model="searchForm.platformType" placeholder="选择平台" clearable style="width: 140px">
            <el-option
              v-for="option in platformOptions"
              :key="option.value"
              :label="option.label"
              :value="option.value"
            />
          </el-select>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" :icon="Search" @click="handleSearch">
            搜索
          </el-button>
          <el-button :icon="Refresh" @click="handleReset">
            重置
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 数据表格 -->
    <el-card class="table-card" shadow="never">
      <el-table 
        v-loading="loading"
        :data="filteredData" 
        style="width: 100%"
        row-key="id"
        stripe
      >
        <el-table-column prop="name" label="智能体名称" min-width="180">
          <template #default="{ row }">
            <div class="agent-info">
              <el-avatar 
                :src="row.avatar" 
                :size="40"
                class="agent-avatar"
              >
                {{ row.name.charAt(0) }}
              </el-avatar>
              <div class="agent-details">
                <div class="agent-name">{{ row.name }}</div>
                <div class="agent-desc">{{ row.description }}</div>
              </div>
            </div>
          </template>
        </el-table-column>

        <el-table-column prop="type" label="类型" width="120">
          <template #default="{ row }">
            <el-tag size="small">{{ getTypeText(row.type) }}</el-tag>
          </template>
        </el-table-column>

        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag 
              :type="getStatusType(row.status)" 
              size="small"
            >
              {{ getStatusText(row.status) }}
            </el-tag>
          </template>
        </el-table-column>

        <el-table-column prop="platformType" label="平台" width="120">
          <template #default="{ row }">
            {{ getPlatformText(row.platformType) }}
          </template>
        </el-table-column>

        <el-table-column prop="modelName" label="模型" width="140" />

        <el-table-column label="对话数据" width="120">
          <template #default="{ row }">
            <div class="stats-info">
              <div>会话: {{ row.conversationCount }}</div>
              <div>消息: {{ row.messageCount }}</div>
            </div>
          </template>
        </el-table-column>

        <el-table-column prop="lastActiveAt" label="最后活跃" width="160">
          <template #default="{ row }">
            {{ row.lastActiveAt || '未使用' }}
          </template>
        </el-table-column>

        <el-table-column prop="createdBy" label="创建者" width="100" />

        <el-table-column prop="updatedAt" label="更新时间" width="160" />

        <el-table-column label="操作" width="320" fixed="right">
          <template #default="{ row }">
            <div class="action-buttons">
              <el-button 
                type="primary" 
                size="small" 
                :icon="ChatDotRound"
                @click="handleChat(row)"
                v-if="row.status === AgentStatus.PUBLISHED"
              >
                对话
              </el-button>
              
              <el-button 
                type="info" 
                size="small" 
                :icon="View"
                @click="handleView(row)"
              >
                详情
              </el-button>

              <el-button 
                type="warning" 
                size="small" 
                :icon="Edit"
                @click="handleEdit(row)"
              >
                编辑
              </el-button>

              <el-button 
                type="primary" 
                size="small" 
                :icon="Document"
                @click="handleVersions(row)"
              >
                版本
              </el-button>

              <el-button 
                :type="row.status === AgentStatus.PUBLISHED ? 'danger' : 'success'"
                size="small" 
                :icon="Switch"
                @click="handleStatusToggle(row)"
                v-if="row.status !== AgentStatus.DRAFT"
              >
                {{ row.status === AgentStatus.PUBLISHED ? '禁用' : '启用' }}
              </el-button>

              <el-dropdown trigger="click">
                <el-button size="small" :icon="Setting" circle />
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item @click="handleStats(row)">
                      <el-icon><DataBoard /></el-icon>
                      查看统计
                    </el-dropdown-item>
                    <el-dropdown-item @click="handleDelete(row)" divided>
                      <el-icon><Delete /></el-icon>
                      删除
                    </el-dropdown-item>
                  </el-dropdown-menu>
                </template>
              </el-dropdown>
            </div>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination-container">
        <el-pagination
          v-model:current-page="searchForm.current"
          v-model:page-size="searchForm.size"
          :page-sizes="[10, 20, 50, 100]"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handlePageChange"
        />
      </div>
    </el-card>
  </div>
</template>

<style scoped lang="scss">
.agent-list-container {
  padding: 20px;
  background-color: #f5f7fa;
  min-height: calc(100vh - 60px);
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 20px;
  
  .header-content {
    .page-title {
      margin: 0 0 8px 0;
      font-size: 24px;
      font-weight: 600;
      color: #303133;
    }
    
    .page-subtitle {
      margin: 0;
      color: #606266;
      font-size: 14px;
    }
  }
  
  .header-actions {
    display: flex;
    gap: 12px;
  }
}

.search-card {
  margin-bottom: 20px;
  
  :deep(.el-card__body) {
    padding: 20px;
  }
}

.table-card {
  :deep(.el-card__body) {
    padding: 0;
  }
  
  :deep(.el-table) {
    .el-table__header {
      background-color: #fafafa;
    }
  }
}

.agent-info {
  display: flex;
  align-items: center;
  gap: 12px;
  
  .agent-avatar {
    flex-shrink: 0;
  }
  
  .agent-details {
    min-width: 0;
    
    .agent-name {
      font-weight: 500;
      color: #303133;
      margin-bottom: 4px;
    }
    
    .agent-desc {
      font-size: 12px;
      color: #909399;
      line-height: 1.4;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }
  }
}

.stats-info {
  font-size: 12px;
  color: #606266;
  line-height: 1.4;
}

.action-buttons {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.pagination-container {
  padding: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>