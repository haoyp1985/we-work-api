<template>
  <div class="agent-management">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-left">
        <h2 class="page-title">
          <el-icon><Robot /></el-icon>
          AI智能体管理
        </h2>
        <div class="header-stats">
          <StatusIndicator
            mode="simple"
            type="success"
            :text="`已发布: ${stats.publishedCount}`"
          />
          <StatusIndicator
            mode="simple"
            type="warning"
            :text="`草稿: ${stats.draftCount}`"
          />
          <StatusIndicator
            mode="simple"
            type="info"
            :text="`总计: ${stats.totalCount}`"
          />
        </div>
      </div>
      
      <div class="header-right">
        <el-button type="primary" @click="showCreateDialog = true">
          <el-icon><Plus /></el-icon>
          创建智能体
        </el-button>
        <el-button @click="handleImport">
          <el-icon><Upload /></el-icon>
          批量导入
        </el-button>
        <el-button @click="handleExport">
          <el-icon><Download /></el-icon>
          导出配置
        </el-button>
      </div>
    </div>

    <!-- 搜索和过滤 -->
    <el-card shadow="never" class="filter-card">
      <div class="filter-section">
        <div class="filter-left">
          <el-input
            v-model="filters.keyword"
            placeholder="搜索智能体名称、描述"
            style="width: 300px;"
            clearable
            @keyup.enter="handleSearch"
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>
          
          <el-select
            v-model="filters.type"
            placeholder="智能体类型"
            clearable
            style="width: 140px;"
            @change="handleFilterChange"
          >
            <el-option
              v-for="type in typeOptions"
              :key="type.value"
              :label="type.label"
              :value="type.value"
            />
          </el-select>
          
          <el-select
            v-model="filters.status"
            placeholder="状态"
            clearable
            style="width: 120px;"
            @change="handleFilterChange"
          >
            <el-option
              v-for="status in statusOptions"
              :key="status.value"
              :label="status.label"
              :value="status.value"
            />
          </el-select>

          <el-select
            v-model="filters.platformType"
            placeholder="平台类型"
            clearable
            style="width: 140px;"
            @change="handleFilterChange"
          >
            <el-option
              v-for="platform in platformOptions"
              :key="platform.value"
              :label="platform.label"
              :value="platform.value"
            />
          </el-select>
        </div>
        
        <div class="filter-right">
          <el-button @click="resetFilters">
            <el-icon><RefreshRight /></el-icon>
            重置
          </el-button>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon>
            搜索
          </el-button>
        </div>
      </div>
    </el-card>

    <!-- 智能体列表 -->
    <el-card shadow="never" class="table-card">
      <DataTable
        ref="tableRef"
        :data="agentList"
        :columns="tableColumns"
        :loading="loading"
        :current-page="pagination.current"
        :page-size="pagination.size"
        :total="pagination.total"
        :batch-actions="batchActions"
        show-selection
        show-toolbar
        @update:current-page="handlePageChange"
        @update:page-size="handleSizeChange"
        @selection-change="handleSelectionChange"
        @action="handleAction"
        @batch-action="handleBatchAction"
        @refresh="loadAgents"
      />
    </el-card>

    <!-- 创建/编辑智能体弹窗 -->
    <el-dialog
      v-model="showCreateDialog"
      :title="editingAgent ? '编辑智能体' : '创建智能体'"
      width="800px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="formRef"
        :model="agentForm"
        :rules="formRules"
        label-width="120px"
      >
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="智能体名称" prop="name">
              <el-input v-model="agentForm.name" placeholder="请输入智能体名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="智能体类型" prop="type">
              <el-select v-model="agentForm.type" placeholder="选择类型" style="width: 100%;">
                <el-option
                  v-for="type in typeOptions"
                  :key="type.value"
                  :label="type.label"
                  :value="type.value"
                />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="智能体描述" prop="description">
          <el-input
            v-model="agentForm.description"
            type="textarea"
            :rows="3"
            placeholder="请输入智能体描述"
          />
        </el-form-item>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="平台类型" prop="platformType">
              <el-select v-model="agentForm.platformType" placeholder="选择平台" style="width: 100%;">
                <el-option
                  v-for="platform in platformOptions"
                  :key="platform.value"
                  :label="platform.label"
                  :value="platform.value"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="头像URL" prop="avatarUrl">
              <el-input v-model="agentForm.avatarUrl" placeholder="请输入头像URL（可选）" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="平台智能体ID" prop="platformAgentId">
          <el-input v-model="agentForm.platformAgentId" placeholder="请输入平台中的智能体ID" />
        </el-form-item>

        <el-form-item label="模型配置" prop="modelConfig">
          <el-input
            v-model="agentForm.modelConfig"
            type="textarea"
            :rows="4"
            placeholder="请输入JSON格式的模型配置"
          />
        </el-form-item>

        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="最大token数" prop="maxTokens">
              <el-input-number
                v-model="agentForm.maxTokens"
                :min="100"
                :max="32000"
                :step="100"
                style="width: 100%;"
              />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="温度参数" prop="temperature">
              <el-input-number
                v-model="agentForm.temperature"
                :min="0"
                :max="2"
                :step="0.1"
                :precision="1"
                style="width: 100%;"
              />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="超时时间(秒)" prop="timeoutSeconds">
              <el-input-number
                v-model="agentForm.timeoutSeconds"
                :min="5"
                :max="300"
                :step="5"
                style="width: 100%;"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="系统提示词" prop="systemPrompt">
          <el-input
            v-model="agentForm.systemPrompt"
            type="textarea"
            :rows="3"
            placeholder="请输入系统提示词（可选）"
          />
        </el-form-item>

        <el-form-item label="智能体标签" prop="tags">
          <el-input v-model="agentForm.tags" placeholder="输入标签，多个标签用逗号分隔" />
        </el-form-item>
      </el-form>
      
      <template #footer>
        <el-button @click="showCreateDialog = false">取消</el-button>
        <el-button type="primary" @click="handleSaveAgent" :loading="saving">
          {{ editingAgent ? '更新' : '创建' }}
        </el-button>
      </template>
    </el-dialog>

    <!-- 智能体详情抽屉 -->
    <el-drawer
      v-model="showDetailDrawer"
      title="智能体详情"
      size="600px"
      direction="rtl"
    >
      <div v-if="selectedAgent" class="agent-detail">
        <div class="detail-section">
          <h3>基本信息</h3>
          <el-descriptions :column="2" border>
            <el-descriptions-item label="名称">
              {{ selectedAgent.name }}
            </el-descriptions-item>
            <el-descriptions-item label="类型">
              <el-tag>{{ getTypeLabel(selectedAgent.type) }}</el-tag>
            </el-descriptions-item>
            <el-descriptions-item label="状态">
              <el-tag :type="getStatusType(selectedAgent.status)">
                {{ getStatusLabel(selectedAgent.status) }}
              </el-tag>
            </el-descriptions-item>
            <el-descriptions-item label="平台">
              <el-tag type="info">{{ getPlatformLabel(selectedAgent.platformType) }}</el-tag>
            </el-descriptions-item>
            <el-descriptions-item label="创建时间" :span="2">
              {{ formatDateTime(selectedAgent.createdAt) }}
            </el-descriptions-item>
            <el-descriptions-item label="更新时间" :span="2">
              {{ formatDateTime(selectedAgent.updatedAt) }}
            </el-descriptions-item>
          </el-descriptions>
        </div>

        <div class="detail-section" v-if="selectedAgent.description">
          <h3>描述</h3>
          <p>{{ selectedAgent.description }}</p>
        </div>

        <div class="detail-section" v-if="selectedAgent.systemPrompt">
          <h3>系统提示词</h3>
          <pre class="prompt-content">{{ selectedAgent.systemPrompt }}</pre>
        </div>

        <div class="detail-section" v-if="selectedAgent.modelConfig">
          <h3>模型配置</h3>
          <pre class="config-content">{{ formatJson(selectedAgent.modelConfig) }}</pre>
        </div>
      </div>
    </el-drawer>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Robot, Plus, Upload, Download, Search, RefreshRight } from '@element-plus/icons-vue'
import { DataTable, StatusIndicator } from '@/components/ui'
import { formatDateTime } from '@/utils/format'
import { agentApi } from '@/api/agent'
import { useTenantStore } from '@/stores/modules/tenant'
import type { 
  AgentDTO, 
  AgentType, 
  AgentStatus, 
  PlatformType, 
  CreateAgentRequest 
} from '@/types/agent'

// 状态管理
const tenantStore = useTenantStore()

// 响应式数据
const loading = ref(false)
const saving = ref(false)
const showCreateDialog = ref(false)
const showDetailDrawer = ref(false)
const editingAgent = ref<AgentDTO | null>(null)
const selectedAgent = ref<AgentDTO | null>(null)
const selectedAgents = ref<AgentDTO[]>([])
const tableRef = ref()
const formRef = ref()

// 智能体列表数据
const agentList = ref<AgentDTO[]>([])

// 统计数据
const stats = computed(() => {
  const total = agentList.value.length
  const published = agentList.value.filter(agent => agent.status === AgentStatus.PUBLISHED).length
  const draft = agentList.value.filter(agent => agent.status === AgentStatus.DRAFT).length
  
  return {
    totalCount: total,
    publishedCount: published,
    draftCount: draft
  }
})

// 过滤器
const filters = reactive({
  keyword: '',
  type: '',
  status: '',
  platformType: ''
})

// 分页
const pagination = reactive({
  current: 1,
  size: 20,
  total: 0
})

// 表单数据
const agentForm = reactive<CreateAgentRequest>({
  name: '',
  description: '',
  type: AgentType.CHAT_ASSISTANT,
  platformType: PlatformType.COZE,
  platformAgentId: '',
  avatarUrl: '',
  systemPrompt: '',
  modelConfig: '{}',
  maxTokens: 4000,
  temperature: 0.7,
  timeoutSeconds: 30,
  tags: ''
})

// 表单验证规则
const formRules = {
  name: [
    { required: true, message: '请输入智能体名称', trigger: 'blur' }
  ],
  type: [
    { required: true, message: '请选择智能体类型', trigger: 'change' }
  ],
  platformType: [
    { required: true, message: '请选择平台类型', trigger: 'change' }
  ],
  platformAgentId: [
    { required: true, message: '请输入平台智能体ID', trigger: 'blur' }
  ],
  modelConfig: [
    {
      validator: (rule: any, value: string, callback: Function) => {
        if (value) {
          try {
            JSON.parse(value)
            callback()
          } catch (error) {
            callback(new Error('请输入有效的JSON格式'))
          }
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ]
}

// 选项数据
const typeOptions = [
  { label: '聊天助手', value: AgentType.CHAT_ASSISTANT },
  { label: '工作流', value: AgentType.WORKFLOW },
  { label: '代码助手', value: AgentType.CODE_ASSISTANT },
  { label: '知识问答', value: AgentType.KNOWLEDGE_QA },
  { label: '自定义', value: AgentType.CUSTOM }
]

const statusOptions = [
  { label: '草稿', value: AgentStatus.DRAFT },
  { label: '已发布', value: AgentStatus.PUBLISHED },
  { label: '已删除', value: AgentStatus.DELETED }
]

const platformOptions = [
  { label: 'Coze', value: PlatformType.COZE },
  { label: 'Dify', value: PlatformType.DIFY },
  { label: '阿里百炼', value: PlatformType.ALIBABA_DASHSCOPE },
  { label: 'OpenAI', value: PlatformType.OPENAI },
  { label: 'Claude', value: PlatformType.CLAUDE },
  { label: '文心一言', value: PlatformType.WENXIN_YIYAN },
  { label: '自定义', value: PlatformType.CUSTOM }
]

// 表格列配置
const tableColumns = [
  {
    prop: 'name',
    label: '智能体名称',
    minWidth: 150,
    fixed: 'left' as const
  },
  {
    prop: 'type',
    label: '类型',
    width: 120,
    formatter: (row: AgentDTO) => getTypeLabel(row.type)
  },
  {
    prop: 'status',
    label: '状态',
    width: 100,
    type: 'status' as const,
    statusMap: {
      [AgentStatus.DRAFT]: { text: '草稿', type: 'warning' },
      [AgentStatus.PUBLISHED]: { text: '已发布', type: 'success' },
      [AgentStatus.DELETED]: { text: '已删除', type: 'danger' }
    }
  },
  {
    prop: 'platformType',
    label: '平台',
    width: 120,
    formatter: (row: AgentDTO) => getPlatformLabel(row.platformType)
  },
  {
    prop: 'description',
    label: '描述',
    minWidth: 200,
    showOverflowTooltip: true
  },
  {
    prop: 'createdAt',
    label: '创建时间',
    width: 160,
    type: 'datetime' as const,
    format: 'YYYY-MM-DD HH:mm:ss'
  },
  {
    prop: 'updatedAt',
    label: '更新时间',
    width: 160,
    type: 'datetime' as const,
    format: 'YYYY-MM-DD HH:mm:ss'
  },
  {
    prop: 'actions',
    label: '操作',
    width: 280,
    fixed: 'right' as const,
    type: 'actions' as const,
    actions: [
      {
        key: 'detail',
        label: '详情',
        type: 'info' as const,
        icon: 'View'
      },
      {
        key: 'chat',
        label: '测试对话',
        type: 'primary' as const,
        icon: 'ChatDotRound',
        hidden: (row: AgentDTO) => row.status !== AgentStatus.PUBLISHED
      },
      {
        key: 'publish',
        label: '发布',
        type: 'success' as const,
        icon: 'Promotion',
        hidden: (row: AgentDTO) => row.status !== AgentStatus.DRAFT
      },
      {
        key: 'edit',
        label: '编辑',
        type: 'primary' as const,
        icon: 'Edit'
      },
      {
        key: 'delete',
        label: '删除',
        type: 'danger' as const,
        icon: 'Delete'
      }
    ]
  }
]

// 批量操作
const batchActions = [
  {
    key: 'batchPublish',
    label: '批量发布',
    type: 'success' as const,
    icon: 'Promotion'
  },
  {
    key: 'batchDelete',
    label: '批量删除',
    type: 'danger' as const,
    icon: 'Delete'
  }
]

// 方法
const loadAgents = async () => {
  try {
    loading.value = true
    
    const response = await agentApi.queryAgents({
      pageNum: pagination.current,
      pageSize: pagination.size,
      name: filters.keyword || undefined,
      type: filters.type || undefined,
      status: filters.status || undefined,
      platformType: filters.platformType || undefined
    })
    
    if (response.code === 200 && response.data) {
      agentList.value = response.data.records || []
      pagination.total = response.data.total || 0
    } else {
      ElMessage.error(response.message || '加载智能体列表失败')
    }
  } catch (error: any) {
    console.error('加载智能体列表失败:', error)
    ElMessage.error('加载智能体列表失败: ' + (error.message || '网络错误'))
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  pagination.current = 1
  loadAgents()
}

const handleFilterChange = () => {
  pagination.current = 1
  loadAgents()
}

const resetFilters = () => {
  Object.assign(filters, {
    keyword: '',
    type: '',
    status: '',
    platformType: ''
  })
  pagination.current = 1
  loadAgents()
}

const handlePageChange = (page: number) => {
  pagination.current = page
  loadAgents()
}

const handleSizeChange = (size: number) => {
  pagination.size = size
  pagination.current = 1
  loadAgents()
}

const handleSelectionChange = (selection: AgentDTO[]) => {
  selectedAgents.value = selection
}

const handleAction = async (action: { key: string }, row: AgentDTO, index: number) => {
  switch (action.key) {
    case 'detail':
      selectedAgent.value = row
      showDetailDrawer.value = true
      break
    case 'chat':
      // 跳转到对话页面
      ElMessage.info(`跳转到智能体 "${row.name}" 的测试对话`)
      break
    case 'publish':
      await handlePublishAgent(row)
      break
    case 'edit':
      editingAgent.value = row
      Object.assign(agentForm, {
        name: row.name,
        description: row.description || '',
        type: row.type,
        platformType: row.platformType,
        platformAgentId: row.platformAgentId || '',
        avatarUrl: row.avatarUrl || '',
        systemPrompt: row.systemPrompt || '',
        modelConfig: row.modelConfig || '{}',
        maxTokens: row.maxTokens || 4000,
        temperature: row.temperature || 0.7,
        timeoutSeconds: row.timeoutSeconds || 30,
        tags: Array.isArray(row.tags) ? row.tags.join(',') : ''
      })
      showCreateDialog.value = true
      break
    case 'delete':
      await handleDeleteAgent(row)
      break
  }
}

const handleBatchAction = async (action: string) => {
  if (selectedAgents.value.length === 0) {
    ElMessage.warning('请选择要操作的智能体')
    return
  }
  
  switch (action) {
    case 'batchPublish':
      await handleBatchPublish()
      break
    case 'batchDelete':
      await handleBatchDelete()
      break
  }
}

const handleSaveAgent = async () => {
  if (!formRef.value) return
  
  try {
    await formRef.value.validate()
    saving.value = true
    
    // 处理标签
    const tags = agentForm.tags ? agentForm.tags.split(',').map(tag => tag.trim()).filter(tag => tag) : []
    
    const requestData: CreateAgentRequest = {
      ...agentForm,
      tags
    }
    
    if (editingAgent.value) {
      const response = await agentApi.updateAgent(editingAgent.value.id, requestData)
      if (response.code === 200) {
        ElMessage.success('智能体更新成功')
      } else {
        ElMessage.error(response.message || '更新失败')
        return
      }
    } else {
      const response = await agentApi.createAgent(requestData)
      if (response.code === 200) {
        ElMessage.success('智能体创建成功')
      } else {
        ElMessage.error(response.message || '创建失败')
        return
      }
    }
    
    showCreateDialog.value = false
    resetForm()
    loadAgents()
  } catch (error: any) {
    if (error.message) {
      ElMessage.error(error.message)
    }
  } finally {
    saving.value = false
  }
}

const resetForm = () => {
  editingAgent.value = null
  Object.assign(agentForm, {
    name: '',
    description: '',
    type: AgentType.CHAT_ASSISTANT,
    platformType: PlatformType.COZE,
    platformAgentId: '',
    avatarUrl: '',
    systemPrompt: '',
    modelConfig: '{}',
    maxTokens: 4000,
    temperature: 0.7,
    timeoutSeconds: 30,
    tags: ''
  })
  formRef.value?.resetFields()
}

const handlePublishAgent = async (agent: AgentDTO) => {
  try {
    const response = await agentApi.publishAgent(agent.id)
    if (response.code === 200) {
      ElMessage.success(`智能体 "${agent.name}" 发布成功`)
      loadAgents()
    } else {
      ElMessage.error(response.message || '发布失败')
    }
  } catch (error: any) {
    ElMessage.error('发布失败: ' + (error.message || '网络错误'))
  }
}

const handleDeleteAgent = async (agent: AgentDTO) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除智能体 "${agent.name}" 吗？此操作不可恢复。`,
      '确认删除',
      {
        type: 'warning',
        confirmButtonText: '确定删除',
        cancelButtonText: '取消'
      }
    )
    
    const response = await agentApi.deleteAgent(agent.id)
    if (response.code === 200) {
      ElMessage.success('智能体删除成功')
      loadAgents()
    } else {
      ElMessage.error(response.message || '删除失败')
    }
  } catch (error: any) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败: ' + (error.message || '网络错误'))
    }
  }
}

const handleBatchPublish = async () => {
  try {
    await ElMessageBox.confirm(
      `确定要发布选中的 ${selectedAgents.value.length} 个智能体吗？`,
      '确认批量发布',
      {
        type: 'warning',
        confirmButtonText: '确定发布',
        cancelButtonText: '取消'
      }
    )
    
    // 批量发布
    const promises = selectedAgents.value.map(agent => agentApi.publishAgent(agent.id))
    await Promise.all(promises)
    
    ElMessage.success('批量发布成功')
    loadAgents()
  } catch (error: any) {
    if (error !== 'cancel') {
      ElMessage.error('批量发布失败')
    }
  }
}

const handleBatchDelete = async () => {
  try {
    await ElMessageBox.confirm(
      `确定要删除选中的 ${selectedAgents.value.length} 个智能体吗？此操作不可恢复。`,
      '确认批量删除',
      {
        type: 'warning',
        confirmButtonText: '确定删除',
        cancelButtonText: '取消'
      }
    )
    
    // 批量删除
    const promises = selectedAgents.value.map(agent => agentApi.deleteAgent(agent.id))
    await Promise.all(promises)
    
    ElMessage.success('批量删除成功')
    loadAgents()
  } catch (error: any) {
    if (error !== 'cancel') {
      ElMessage.error('批量删除失败')
    }
  }
}

const handleImport = () => {
  ElMessage.info('智能体批量导入功能开发中...')
}

const handleExport = () => {
  ElMessage.info('智能体配置导出功能开发中...')
}

// 工具方法
const getTypeLabel = (type: AgentType): string => {
  const option = typeOptions.find(opt => opt.value === type)
  return option?.label || type
}

const getStatusLabel = (status: AgentStatus): string => {
  const option = statusOptions.find(opt => opt.value === status)
  return option?.label || status
}

const getStatusType = (status: AgentStatus): string => {
  switch (status) {
    case AgentStatus.PUBLISHED:
      return 'success'
    case AgentStatus.DRAFT:
      return 'warning'
    case AgentStatus.DELETED:
      return 'danger'
    default:
      return 'info'
  }
}

const getPlatformLabel = (platform: PlatformType): string => {
  const option = platformOptions.find(opt => opt.value === platform)
  return option?.label || platform
}

const formatJson = (jsonStr: string): string => {
  try {
    return JSON.stringify(JSON.parse(jsonStr), null, 2)
  } catch {
    return jsonStr
  }
}

// 生命周期
onMounted(() => {
  loadAgents()
})
</script>

<style lang="scss" scoped>
.agent-management {
  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 20px;
    
    .header-left {
      display: flex;
      flex-direction: column;
      gap: 12px;
      
      .page-title {
        display: flex;
        align-items: center;
        gap: 8px;
        margin: 0;
        font-size: 20px;
        font-weight: 600;
        color: var(--el-text-color-primary);
      }
      
      .header-stats {
        display: flex;
        gap: 16px;
      }
    }
    
    .header-right {
      display: flex;
      gap: 12px;
    }
  }
  
  .filter-card {
    margin-bottom: 20px;
    
    .filter-section {
      display: flex;
      justify-content: space-between;
      align-items: center;
      
      .filter-left {
        display: flex;
        gap: 12px;
        align-items: center;
      }
      
      .filter-right {
        display: flex;
        gap: 8px;
      }
    }
  }
  
  .table-card {
    :deep(.el-card__body) {
      padding: 0;
    }
  }
  
  .agent-detail {
    .detail-section {
      margin-bottom: 24px;
      
      h3 {
        margin: 0 0 16px 0;
        font-size: 16px;
        font-weight: 600;
        color: var(--el-text-color-primary);
      }
      
      p {
        margin: 0;
        line-height: 1.6;
        color: var(--el-text-color-regular);
      }
      
      .prompt-content,
      .config-content {
        background: #f5f7fa;
        border: 1px solid var(--el-border-color);
        border-radius: 4px;
        padding: 12px;
        margin: 0;
        font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
        font-size: 13px;
        line-height: 1.5;
        color: var(--el-text-color-primary);
        white-space: pre-wrap;
        word-break: break-all;
      }
    }
  }
}

// 响应式适配
@media (max-width: 768px) {
  .agent-management {
    .page-header {
      flex-direction: column;
      gap: 16px;
      
      .header-right {
        width: 100%;
        
        .el-button {
          flex: 1;
        }
      }
    }
    
    .filter-section {
      flex-direction: column;
      gap: 16px;
      
      .filter-left {
        width: 100%;
        flex-wrap: wrap;
      }
      
      .filter-right {
        width: 100%;
        
        .el-button {
          flex: 1;
        }
      }
    }
  }
}
</style>