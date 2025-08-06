<template>
  <div class="conversation-list-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-title">
        <h1>对话管理</h1>
        <p>管理所有AI对话，查看对话历史和统计信息</p>
      </div>
      <div class="header-actions">
        <el-button 
          type="primary" 
          :icon="Plus" 
          @click="handleCreate"
        >
          创建对话
        </el-button>
      </div>
    </div>

    <!-- 搜索和过滤 -->
    <el-card class="search-card" shadow="never">
      <el-form :model="searchForm" inline>
        <el-form-item label="关键词">
          <el-input
            v-model="searchForm.keyword"
            placeholder="搜索对话标题、内容"
            :prefix-icon="Search"
            clearable
            style="width: 250px"
          />
        </el-form-item>
        
        <el-form-item label="智能体">
          <el-select
            v-model="searchForm.agentId"
            placeholder="选择智能体"
            clearable
            style="width: 200px"
          >
            <el-option
              v-for="agent in agentOptions"
              :key="agent.id"
              :label="agent.name"
              :value="agent.id"
            />
          </el-select>
        </el-form-item>

        <el-form-item label="状态">
          <el-select
            v-model="searchForm.status"
            placeholder="选择状态"
            clearable
            style="width: 150px"
          >
            <el-option
              v-for="option in statusOptions"
              :key="option.value"
              :label="option.label"
              :value="option.value"
            />
          </el-select>
        </el-form-item>

        <el-form-item label="时间范围">
          <el-date-picker
            v-model="dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            style="width: 250px"
          />
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
      <template #header>
        <div class="table-header">
          <div class="table-title">
            <span>对话列表 ({{ total }})</span>
          </div>
          <div class="table-actions">
            <el-button 
              :icon="Download" 
              @click="handleExport"
              :disabled="!selectedRows.length"
            >
              导出选中
            </el-button>
            <el-button 
              :icon="Delete" 
              type="danger" 
              @click="handleBatchDelete"
              :disabled="!selectedRows.length"
            >
              批量删除
            </el-button>
          </div>
        </div>
      </template>

      <el-table
        v-loading="loading"
        :data="tableData"
        @selection-change="handleSelectionChange"
        @row-click="handleRowClick"
        style="width: 100%"
      >
        <el-table-column type="selection" width="55" align="center" />
        
        <el-table-column label="对话信息" min-width="300">
          <template #default="{ row }">
            <div class="conversation-info">
              <div class="conversation-title">
                <span>{{ row.title }}</span>
                <div class="conversation-badges">
                  <el-tag v-if="row.isPinned" type="warning" size="small">置顶</el-tag>
                  <el-tag v-if="row.isStarred" type="primary" size="small">收藏</el-tag>
                </div>
              </div>
              <div class="conversation-meta">
                <span class="agent-name">{{ row.agentName }}</span>
                <span class="divider">•</span>
                <span class="message-count">{{ row.messageCount }} 条消息</span>
                <span class="divider">•</span>
                <span class="user-name">{{ row.userName }}</span>
              </div>
              <div v-if="row.lastMessage" class="last-message">
                {{ row.lastMessage }}
              </div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="状态" width="100" align="center">
          <template #default="{ row }">
            <el-tag 
              :type="getStatusTagType(row.status)"
              size="small"
            >
              {{ getStatusLabel(row.status) }}
            </el-tag>
          </template>
        </el-table-column>

        <el-table-column label="标签" width="120">
          <template #default="{ row }">
            <div class="tags-container">
              <el-tag
                v-for="tag in row.tags.slice(0, 2)"
                :key="tag"
                size="small"
                class="tag-item"
              >
                {{ tag }}
              </el-tag>
              <el-tooltip 
                v-if="row.tags.length > 2"
                :content="row.tags.slice(2).join(', ')"
                placement="top"
              >
                <el-tag size="small" class="tag-item">
                  +{{ row.tags.length - 2 }}
                </el-tag>
              </el-tooltip>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="最后活动" width="150" align="center">
          <template #default="{ row }">
            <div class="time-info">
              <div>{{ formatTime(row.lastMessageAt || row.updatedAt) }}</div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="200" align="center">
          <template #default="{ row }">
            <div class="action-buttons">
              <el-button
                type="primary"
                size="small"
                :icon="ChatDotRound"
                @click="handleChat(row)"
              >
                对话
              </el-button>
              
              <el-dropdown @command="(command) => handleDropdownAction(command, row)">
                <el-button size="small" :icon="Setting" />
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item command="view" :icon="View">
                      查看详情
                    </el-dropdown-item>
                    <el-dropdown-item command="edit" :icon="Edit">
                      编辑
                    </el-dropdown-item>
                    <el-dropdown-item 
                      :command="row.isStarred ? 'unstar' : 'star'" 
                      :icon="row.isStarred ? Star : StarFilled"
                    >
                      {{ row.isStarred ? '取消收藏' : '收藏' }}
                    </el-dropdown-item>
                    <el-dropdown-item 
                      :command="row.isPinned ? 'unpin' : 'pin'" 
                      :icon="Top"
                    >
                      {{ row.isPinned ? '取消置顶' : '置顶' }}
                    </el-dropdown-item>
                    <el-dropdown-item 
                      :command="row.status === 'ARCHIVED' ? 'unarchive' : 'archive'" 
                      :icon="Box"
                    >
                      {{ row.status === 'ARCHIVED' ? '取消归档' : '归档' }}
                    </el-dropdown-item>
                    <el-dropdown-item command="export" :icon="Download">
                      导出对话
                    </el-dropdown-item>
                    <el-dropdown-item 
                      command="delete" 
                      :icon="Delete"
                      style="color: #f56c6c"
                    >
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

    <!-- 创建对话对话框 -->
    <el-dialog
      v-model="createDialogVisible"
      title="创建对话"
      width="500px"
      :before-close="handleCreateDialogClose"
    >
      <el-form
        ref="createFormRef"
        :model="createForm"
        :rules="createFormRules"
        label-width="80px"
      >
        <el-form-item label="对话标题" prop="title">
          <el-input
            v-model="createForm.title"
            placeholder="请输入对话标题"
          />
        </el-form-item>
        
        <el-form-item label="选择智能体" prop="agentId">
          <el-select
            v-model="createForm.agentId"
            placeholder="请选择智能体"
            style="width: 100%"
          >
            <el-option
              v-for="agent in agentOptions"
              :key="agent.id"
              :label="agent.name"
              :value="agent.id"
            />
          </el-select>
        </el-form-item>

        <el-form-item label="描述" prop="description">
          <el-input
            v-model="createForm.description"
            type="textarea"
            :rows="3"
            placeholder="请输入对话描述（可选）"
          />
        </el-form-item>

        <el-form-item label="标签" prop="tags">
          <el-select
            v-model="createForm.tags"
            multiple
            filterable
            allow-create
            placeholder="添加标签"
            style="width: 100%"
          >
            <el-option
              v-for="tag in commonTags"
              :key="tag"
              :label="tag"
              :value="tag"
            />
          </el-select>
        </el-form-item>
      </el-form>

      <template #footer>
        <div class="dialog-footer">
          <el-button @click="createDialogVisible = false">取消</el-button>
          <el-button 
            type="primary" 
            :loading="createLoading"
            @click="handleCreateConfirm"
          >
            创建
          </el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { 
  Plus, 
  Search, 
  Refresh, 
  Download, 
  Delete, 
  Edit, 
  View,
  Setting,
  ChatDotRound,
  Star,
  StarFilled,
  Top,
  Box
} from '@element-plus/icons-vue'
import { useRouter } from 'vue-router'
import * as conversationApi from '@/api/conversation'
import * as agentApi from '@/api/agent'
import type { 
  Conversation, 
  ConversationStatus, 
  Agent,
  PageQuery
} from '@/types/api'
import type { FormInstance, FormRules } from 'element-plus'

const router = useRouter()

// 响应式数据
const loading = ref(false)
const tableData = ref<Conversation[]>([])
const total = ref(0)
const selectedRows = ref<Conversation[]>([])
const agentOptions = ref<Agent[]>([])

// 搜索表单
const searchForm = reactive<PageQuery & {
  agentId?: string
  status?: ConversationStatus
}>({
  current: 1,
  size: 10,
  keyword: '',
  agentId: undefined,
  status: undefined
})

const dateRange = ref<[string, string]>()

// 状态选项
const statusOptions = [
  { label: '活跃', value: 'ACTIVE' },
  { label: '已归档', value: 'ARCHIVED' },
  { label: '已删除', value: 'DELETED' }
]

// 常用标签
const commonTags = [
  '客服咨询', '技术支持', '产品介绍', '问题反馈', 
  '商务合作', '培训学习', '测试对话'
]

// 创建对话相关
const createDialogVisible = ref(false)
const createLoading = ref(false)
const createFormRef = ref<FormInstance>()
const createForm = reactive({
  title: '',
  agentId: '',
  description: '',
  tags: [] as string[]
})

const createFormRules: FormRules = {
  title: [
    { required: true, message: '请输入对话标题', trigger: 'blur' },
    { min: 1, max: 100, message: '标题长度在 1 到 100 个字符', trigger: 'blur' }
  ],
  agentId: [
    { required: true, message: '请选择智能体', trigger: 'change' }
  ]
}

// 计算属性
const filteredData = computed(() => {
  return tableData.value
})

// 获取状态标签类型
const getStatusTagType = (status: ConversationStatus): string => {
  const typeMap = {
    'ACTIVE': 'success',
    'ARCHIVED': 'warning',
    'DELETED': 'danger'
  }
  return typeMap[status] || 'info'
}

// 获取状态标签文本
const getStatusLabel = (status: ConversationStatus): string => {
  const labelMap = {
    'ACTIVE': '活跃',
    'ARCHIVED': '已归档',
    'DELETED': '已删除'
  }
  return labelMap[status] || status
}

// 格式化时间
const formatTime = (timeStr: string): string => {
  if (!timeStr) return '-'
  
  const time = new Date(timeStr)
  const now = new Date()
  const diff = now.getTime() - time.getTime()
  
  const minute = 60 * 1000
  const hour = 60 * minute
  const day = 24 * hour
  
  if (diff < minute) {
    return '刚刚'
  } else if (diff < hour) {
    return `${Math.floor(diff / minute)}分钟前`
  } else if (diff < day) {
    return `${Math.floor(diff / hour)}小时前`
  } else if (diff < 7 * day) {
    return `${Math.floor(diff / day)}天前`
  } else {
    return time.toLocaleDateString()
  }
}

// 加载智能体选项
const loadAgentOptions = async () => {
  try {
    const response = await agentApi.getAgents({
      current: 1,
      size: 100,
      status: 'PUBLISHED'
    })
    agentOptions.value = response.data.records
  } catch (error) {
    console.error('加载智能体列表失败:', error)
  }
}

// 加载数据
const loadData = async () => {
  loading.value = true
  try {
    const params = {
      ...searchForm,
      startDate: dateRange.value?.[0],
      endDate: dateRange.value?.[1]
    }
    
    const response = await conversationApi.getConversations(params)
    tableData.value = response.data.records
    total.value = response.data.total
    searchForm.current = response.data.current
    searchForm.size = response.data.size
  } catch (error) {
    console.error('加载对话列表失败:', error)
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
    agentId: undefined,
    status: undefined
  })
  dateRange.value = undefined
  loadData()
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

// 表格选择变化
const handleSelectionChange = (selection: Conversation[]) => {
  selectedRows.value = selection
}

// 行点击
const handleRowClick = (row: Conversation) => {
  router.push(`/conversation/chat/${row.agentId}?conversationId=${row.id}`)
}

// 创建对话
const handleCreate = () => {
  createDialogVisible.value = true
}

// 创建对话确认
const handleCreateConfirm = async () => {
  if (!createFormRef.value) return
  
  try {
    await createFormRef.value.validate()
    createLoading.value = true
    
    const response = await conversationApi.createConversation(createForm)
    
    createDialogVisible.value = false
    
    // 跳转到聊天页面
    router.push(`/conversation/chat/${createForm.agentId}?conversationId=${response.data.id}`)
  } catch (error) {
    console.error('创建对话失败:', error)
  } finally {
    createLoading.value = false
  }
}

// 创建对话框关闭
const handleCreateDialogClose = () => {
  createFormRef.value?.resetFields()
  Object.assign(createForm, {
    title: '',
    agentId: '',
    description: '',
    tags: []
  })
}

// 对话操作
const handleChat = (row: Conversation) => {
  router.push(`/conversation/chat/${row.agentId}?conversationId=${row.id}`)
}

// 下拉菜单操作
const handleDropdownAction = async (command: string, row: Conversation) => {
  switch (command) {
    case 'view':
      router.push(`/conversation/detail/${row.id}`)
      break
    case 'edit':
      // TODO: 实现编辑功能
      break
    case 'star':
    case 'unstar':
      await handleToggleStar(row, command === 'star')
      break
    case 'pin':
    case 'unpin':
      await handleTogglePin(row, command === 'pin')
      break
    case 'archive':
    case 'unarchive':
      await handleToggleArchive(row, command === 'archive')
      break
    case 'export':
      await handleExportConversation(row)
      break
    case 'delete':
      await handleDelete(row)
      break
  }
}

// 切换收藏状态
const handleToggleStar = async (row: Conversation, isStarred: boolean) => {
  try {
    const response = await conversationApi.toggleConversationStar(row.id, isStarred)
    
    // 更新本地数据
    const index = tableData.value.findIndex(item => item.id === row.id)
    if (index > -1) {
      tableData.value[index] = response.data
    }
  } catch (error) {
    console.error('切换收藏状态失败:', error)
    ElMessage.error('操作失败')
  }
}

// 切换置顶状态
const handleTogglePin = async (row: Conversation, isPinned: boolean) => {
  try {
    const response = await conversationApi.toggleConversationPin(row.id, isPinned)
    
    // 更新本地数据
    const index = tableData.value.findIndex(item => item.id === row.id)
    if (index > -1) {
      tableData.value[index] = response.data
    }
  } catch (error) {
    console.error('切换置顶状态失败:', error)
    ElMessage.error('操作失败')
  }
}

// 切换归档状态
const handleToggleArchive = async (row: Conversation, archive: boolean) => {
  try {
    if (archive) {
      await conversationApi.archiveConversation(row.id)
    } else {
      await conversationApi.unarchiveConversation(row.id)
    }
    
    // 重新加载数据
    await loadData()
  } catch (error) {
    console.error('切换归档状态失败:', error)
    ElMessage.error('操作失败')
  }
}

// 导出对话
const handleExportConversation = async (row: Conversation) => {
  try {
    await conversationApi.exportConversation(row.id, 'json')
  } catch (error) {
    console.error('导出对话失败:', error)
    ElMessage.error('导出失败')
  }
}

// 删除对话
const handleDelete = async (row: Conversation) => {
  try {
    await ElMessageBox.confirm(
      `确认删除对话"${row.title}"吗？此操作不可恢复。`,
      '删除确认',
      {
        confirmButtonText: '确认删除',
        cancelButtonText: '取消',
        type: 'warning',
      }
    )
    
    await conversationApi.deleteConversation(row.id)
    
    // 重新加载数据
    await loadData()
  } catch (error) {
    // 用户取消删除或API错误
    if (error && typeof error === 'object' && 'message' in error) {
      console.error('删除对话失败:', error)
    }
  }
}

// 批量删除
const handleBatchDelete = async () => {
  if (!selectedRows.value.length) return
  
  try {
    await ElMessageBox.confirm(
      `确认删除选中的 ${selectedRows.value.length} 个对话吗？此操作不可恢复。`,
      '批量删除确认',
      {
        confirmButtonText: '确认删除',
        cancelButtonText: '取消',
        type: 'warning',
      }
    )
    
    const ids = selectedRows.value.map(row => row.id)
    await conversationApi.batchDeleteConversations(ids)
    
    // 重新加载数据
    await loadData()
  } catch (error) {
    // 用户取消删除或API错误
    if (error && typeof error === 'object' && 'message' in error) {
      console.error('批量删除对话失败:', error)
    }
  }
}

// 导出选中的对话
const handleExport = async () => {
  if (!selectedRows.value.length) return
  
  // TODO: 实现批量导出功能
  ElMessage.info('批量导出功能开发中...')
}

// 初始化
onMounted(() => {
  loadAgentOptions()
  loadData()
})
</script>

<style scoped lang="scss">
.conversation-list-container {
  padding: 20px;

  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;

    .header-title {
      h1 {
        margin: 0 0 8px 0;
        color: #1f2329;
        font-size: 24px;
        font-weight: 600;
      }

      p {
        margin: 0;
        color: #86909c;
        font-size: 14px;
      }
    }
  }

  .search-card {
    margin-bottom: 20px;
    border-radius: 8px;
    
    :deep(.el-card__body) {
      padding: 20px;
    }
  }

  .table-card {
    border-radius: 8px;

    .table-header {
      display: flex;
      justify-content: space-between;
      align-items: center;

      .table-title {
        font-weight: 600;
        color: #1f2329;
      }

      .table-actions {
        display: flex;
        gap: 8px;
      }
    }

    .conversation-info {
      .conversation-title {
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 4px;
        font-weight: 500;
        font-size: 14px;
        color: #1f2329;

        .conversation-badges {
          display: flex;
          gap: 4px;
        }
      }

      .conversation-meta {
        display: flex;
        align-items: center;
        margin-bottom: 4px;
        font-size: 12px;
        color: #86909c;

        .divider {
          margin: 0 6px;
        }

        .agent-name {
          color: #165dff;
        }
      }

      .last-message {
        font-size: 12px;
        color: #86909c;
        line-height: 1.4;
        max-width: 280px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }
    }

    .tags-container {
      display: flex;
      flex-wrap: wrap;
      gap: 4px;

      .tag-item {
        margin: 0;
      }
    }

    .time-info {
      font-size: 12px;
      color: #86909c;
    }

    .action-buttons {
      display: flex;
      gap: 8px;
      align-items: center;
    }
  }

  .pagination-container {
    display: flex;
    justify-content: center;
    margin-top: 20px;
  }

  .dialog-footer {
    display: flex;
    justify-content: flex-end;
    gap: 12px;
  }
}
</style>