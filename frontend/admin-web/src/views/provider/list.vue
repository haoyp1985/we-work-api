<template>
  <div class="provider-management">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-left">
        <h2 class="page-title">
          <el-icon><Connection /></el-icon>
          提供商管理
        </h2>
        <div class="header-stats">
          <StatusIndicator
            mode="simple"
            type="success"
            :text="`活跃: ${stats.activeCount}`"
          />
          <StatusIndicator
            mode="simple"
            type="warning"
            :text="`待审核: ${stats.pendingCount}`"
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
          添加提供商
        </el-button>
        <el-button @click="handleRefresh">
          <el-icon><RefreshRight /></el-icon>
          刷新
        </el-button>
      </div>
    </div>

    <!-- 搜索和过滤 -->
    <el-card shadow="never" class="filter-card">
      <div class="filter-section">
        <div class="filter-left">
          <el-input
            v-model="filters.keyword"
            placeholder="搜索提供商名称、API地址"
            style="width: 300px;"
            clearable
            @keyup.enter="handleSearch"
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>
          
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
            v-model="filters.type"
            placeholder="类型"
            clearable
            style="width: 120px;"
            @change="handleFilterChange"
          >
            <el-option
              v-for="type in typeOptions"
              :key="type.value"
              :label="type.label"
              :value="type.value"
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

    <!-- 提供商列表 -->
    <el-card shadow="never" class="table-card">
      <DataTable
        ref="tableRef"
        :data="providerList"
        :columns="tableColumns"
        :loading="loading"
        :current-page="pagination.current"
        :page-size="pagination.size"
        :total="pagination.total"
        show-toolbar
        @update:current-page="handlePageChange"
        @update:page-size="handleSizeChange"
        @action="handleAction"
        @refresh="loadProviders"
      />
    </el-card>

    <!-- 创建/编辑提供商弹窗 -->
    <el-dialog
      v-model="showCreateDialog"
      :title="editingProvider ? '编辑提供商' : '添加提供商'"
      width="700px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="formRef"
        :model="providerForm"
        :rules="formRules"
        label-width="120px"
      >
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="提供商名称" prop="name">
              <el-input v-model="providerForm.name" placeholder="请输入提供商名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="提供商类型" prop="type">
              <el-select v-model="providerForm.type" placeholder="选择类型" style="width: 100%;">
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
        
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="API地址" prop="apiUrl">
              <el-input v-model="providerForm.apiUrl" placeholder="https://api.example.com" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="API版本" prop="apiVersion">
              <el-input v-model="providerForm.apiVersion" placeholder="v1.0" />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-form-item label="认证方式" prop="authType">
          <el-radio-group v-model="providerForm.authType">
            <el-radio value="api_key">API Key</el-radio>
            <el-radio value="oauth">OAuth 2.0</el-radio>
            <el-radio value="basic">Basic Auth</el-radio>
            <el-radio value="bearer">Bearer Token</el-radio>
          </el-radio-group>
        </el-form-item>
        
        <el-form-item v-if="providerForm.authType === 'api_key'" label="API Key" prop="apiKey">
          <el-input
            v-model="providerForm.apiKey"
            type="password"
            placeholder="请输入API Key"
            show-password
          />
        </el-form-item>
        
        <el-form-item v-if="providerForm.authType === 'basic'" label="用户名" prop="username">
          <el-input v-model="providerForm.username" placeholder="请输入用户名" />
        </el-form-item>
        
        <el-form-item v-if="providerForm.authType === 'basic'" label="密码" prop="password">
          <el-input
            v-model="providerForm.password"
            type="password"
            placeholder="请输入密码"
            show-password
          />
        </el-form-item>
        
        <el-form-item v-if="providerForm.authType === 'bearer'" label="Token" prop="token">
          <el-input
            v-model="providerForm.token"
            type="password"
            placeholder="请输入Bearer Token"
            show-password
          />
        </el-form-item>
        
        <el-form-item v-if="providerForm.authType === 'oauth'" label="Client ID" prop="clientId">
          <el-input v-model="providerForm.clientId" placeholder="请输入Client ID" />
        </el-form-item>
        
        <el-form-item v-if="providerForm.authType === 'oauth'" label="Client Secret" prop="clientSecret">
          <el-input
            v-model="providerForm.clientSecret"
            type="password"
            placeholder="请输入Client Secret"
            show-password
          />
        </el-form-item>
        
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="超时时间" prop="timeout">
              <el-input-number
                v-model="providerForm.timeout"
                :min="1"
                :max="300"
                style="width: 100%;"
              /> 秒
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="重试次数" prop="retryCount">
              <el-input-number
                v-model="providerForm.retryCount"
                :min="0"
                :max="10"
                style="width: 100%;"
              />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="QPS限制" prop="qpsLimit">
              <el-input-number
                v-model="providerForm.qpsLimit"
                :min="1"
                :max="10000"
                style="width: 100%;"
              /> 请求/秒
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="优先级" prop="priority">
              <el-input-number
                v-model="providerForm.priority"
                :min="1"
                :max="100"
                style="width: 100%;"
              />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-form-item label="启用状态">
          <el-switch v-model="providerForm.enabled" />
        </el-form-item>
        
        <el-form-item label="健康检查">
          <el-switch v-model="providerForm.healthCheck" />
        </el-form-item>
        
        <el-form-item v-if="providerForm.healthCheck" label="检查URL" prop="healthCheckUrl">
          <el-input v-model="providerForm.healthCheckUrl" placeholder="健康检查接口地址" />
        </el-form-item>
        
        <el-form-item label="备注说明" prop="description">
          <el-input
            v-model="providerForm.description"
            type="textarea"
            :rows="3"
            placeholder="请输入备注说明"
          />
        </el-form-item>
      </el-form>
      
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="showCreateDialog = false">取消</el-button>
          <el-button @click="testConnection" :loading="testing">测试连接</el-button>
          <el-button type="primary" @click="handleSaveProvider" :loading="saving">
            {{ editingProvider ? '更新' : '创建' }}
          </el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 提供商详情弹窗 -->
    <el-dialog
      v-model="showDetailDialog"
      title="提供商详情"
      width="800px"
    >
      <div v-if="selectedProvider" class="provider-detail">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="提供商名称">
            {{ selectedProvider.name }}
          </el-descriptions-item>
          <el-descriptions-item label="类型">
            {{ getTypeLabel(selectedProvider.type) }}
          </el-descriptions-item>
          <el-descriptions-item label="状态">
            <StatusIndicator
              mode="simple"
              :type="getStatusType(selectedProvider.status)"
              :text="getStatusLabel(selectedProvider.status)"
            />
          </el-descriptions-item>
          <el-descriptions-item label="API地址">
            {{ selectedProvider.apiUrl }}
          </el-descriptions-item>
          <el-descriptions-item label="API版本">
            {{ selectedProvider.apiVersion }}
          </el-descriptions-item>
          <el-descriptions-item label="认证方式">
            {{ getAuthTypeLabel(selectedProvider.authType) }}
          </el-descriptions-item>
          <el-descriptions-item label="超时时间">
            {{ selectedProvider.timeout }}秒
          </el-descriptions-item>
          <el-descriptions-item label="重试次数">
            {{ selectedProvider.retryCount }}次
          </el-descriptions-item>
          <el-descriptions-item label="QPS限制">
            {{ selectedProvider.qpsLimit }}/秒
          </el-descriptions-item>
          <el-descriptions-item label="优先级">
            {{ selectedProvider.priority }}
          </el-descriptions-item>
          <el-descriptions-item label="响应时间">
            {{ selectedProvider.avgResponseTime }}ms
          </el-descriptions-item>
          <el-descriptions-item label="成功率">
            {{ selectedProvider.successRate }}%
          </el-descriptions-item>
          <el-descriptions-item label="创建时间" :span="2">
            {{ formatDateTime(selectedProvider.createdAt) }}
          </el-descriptions-item>
          <el-descriptions-item label="最后更新" :span="2">
            {{ formatDateTime(selectedProvider.updatedAt) }}
          </el-descriptions-item>
          <el-descriptions-item v-if="selectedProvider.description" label="备注说明" :span="2">
            {{ selectedProvider.description }}
          </el-descriptions-item>
        </el-descriptions>
        
        <!-- 性能统计 -->
        <div class="performance-stats">
          <h4>性能统计</h4>
          <el-row :gutter="16">
            <el-col :span="6">
              <StatsCard
                title="今日请求"
                :value="selectedProvider.todayRequests"
                icon="DataLine"
                color="#409eff"
              />
            </el-col>
            <el-col :span="6">
              <StatsCard
                title="成功请求"
                :value="selectedProvider.successRequests"
                icon="CircleCheck"
                color="#67c23a"
              />
            </el-col>
            <el-col :span="6">
              <StatsCard
                title="失败请求"
                :value="selectedProvider.failedRequests"
                icon="CircleClose"
                color="#f56c6c"
              />
            </el-col>
            <el-col :span="6">
              <StatsCard
                title="平均延迟"
                :value="`${selectedProvider.avgResponseTime}ms`"
                icon="Timer"
                color="#e6a23c"
              />
            </el-col>
          </el-row>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { DataTable, StatusIndicator, StatsCard } from '@/components/ui'
import { formatDateTime } from '@/utils/format'

// 接口定义
interface Provider {
  id: string
  name: string
  type: string
  status: string
  apiUrl: string
  apiVersion: string
  authType: string
  timeout: number
  retryCount: number
  qpsLimit: number
  priority: number
  enabled: boolean
  healthCheck: boolean
  healthCheckUrl?: string
  avgResponseTime: number
  successRate: number
  todayRequests: number
  successRequests: number
  failedRequests: number
  description?: string
  createdAt: string
  updatedAt: string
}

// 响应式数据
const loading = ref(false)
const saving = ref(false)
const testing = ref(false)
const showCreateDialog = ref(false)
const showDetailDialog = ref(false)
const editingProvider = ref<Provider | null>(null)
const selectedProvider = ref<Provider | null>(null)
const tableRef = ref()
const formRef = ref()

// 模拟数据
const providerList = ref<Provider[]>([
  {
    id: '1',
    name: '企微官方API',
    type: 'wework',
    status: 'active',
    apiUrl: 'https://qyapi.weixin.qq.com',
    apiVersion: 'v1.0',
    authType: 'api_key',
    timeout: 30,
    retryCount: 3,
    qpsLimit: 100,
    priority: 1,
    enabled: true,
    healthCheck: true,
    healthCheckUrl: 'https://qyapi.weixin.qq.com/cgi-bin/gettoken',
    avgResponseTime: 120,
    successRate: 99.5,
    todayRequests: 15234,
    successRequests: 15158,
    failedRequests: 76,
    description: '企业微信官方API接口',
    createdAt: '2024-01-01T00:00:00Z',
    updatedAt: '2024-01-01T10:30:00Z'
  },
  {
    id: '2',
    name: '第三方代理',
    type: 'proxy',
    status: 'pending',
    apiUrl: 'https://proxy.example.com',
    apiVersion: 'v2.0',
    authType: 'oauth',
    timeout: 45,
    retryCount: 2,
    qpsLimit: 50,
    priority: 2,
    enabled: false,
    healthCheck: true,
    healthCheckUrl: 'https://proxy.example.com/health',
    avgResponseTime: 250,
    successRate: 95.2,
    todayRequests: 8756,
    successRequests: 8334,
    failedRequests: 422,
    description: '第三方代理服务提供商',
    createdAt: '2024-01-01T00:00:00Z',
    updatedAt: '2024-01-01T09:15:00Z'
  }
])

// 统计数据
const stats = computed(() => {
  const total = providerList.value.length
  const active = providerList.value.filter(p => p.status === 'active').length
  const pending = providerList.value.filter(p => p.status === 'pending').length
  
  return {
    totalCount: total,
    activeCount: active,
    pendingCount: pending
  }
})

// 过滤器
const filters = reactive({
  keyword: '',
  status: '',
  type: ''
})

// 分页
const pagination = reactive({
  current: 1,
  size: 20,
  total: 0
})

// 表单数据
const providerForm = reactive({
  name: '',
  type: '',
  apiUrl: '',
  apiVersion: '',
  authType: 'api_key',
  apiKey: '',
  username: '',
  password: '',
  token: '',
  clientId: '',
  clientSecret: '',
  timeout: 30,
  retryCount: 3,
  qpsLimit: 100,
  priority: 1,
  enabled: true,
  healthCheck: false,
  healthCheckUrl: '',
  description: ''
})

// 表单验证规则
const formRules = {
  name: [
    { required: true, message: '请输入提供商名称', trigger: 'blur' }
  ],
  type: [
    { required: true, message: '请选择提供商类型', trigger: 'change' }
  ],
  apiUrl: [
    { required: true, message: '请输入API地址', trigger: 'blur' }
  ],
  apiKey: [
    { required: true, message: '请输入API Key', trigger: 'blur' }
  ],
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' }
  ],
  token: [
    { required: true, message: '请输入Token', trigger: 'blur' }
  ],
  clientId: [
    { required: true, message: '请输入Client ID', trigger: 'blur' }
  ],
  clientSecret: [
    { required: true, message: '请输入Client Secret', trigger: 'blur' }
  ]
}

// 选项数据
const statusOptions = [
  { label: '活跃', value: 'active' },
  { label: '待审核', value: 'pending' },
  { label: '已禁用', value: 'disabled' },
  { label: '异常', value: 'error' }
]

const typeOptions = [
  { label: '企微官方', value: 'wework' },
  { label: '代理服务', value: 'proxy' },
  { label: '云服务', value: 'cloud' },
  { label: '私有部署', value: 'private' }
]

// 表格列配置
const tableColumns = [
  {
    prop: 'name',
    label: '提供商名称',
    minWidth: 140,
    fixed: 'left' as const
  },
  {
    prop: 'type',
    label: '类型',
    width: 100,
    formatter: (row: Provider) => getTypeLabel(row.type)
  },
  {
    prop: 'status',
    label: '状态',
    width: 100,
    type: 'status' as const,
    statusMap: {
      active: { text: '活跃', type: 'success' },
      pending: { text: '待审核', type: 'warning' },
      disabled: { text: '已禁用', type: 'info' },
      error: { text: '异常', type: 'danger' }
    }
  },
  {
    prop: 'apiUrl',
    label: 'API地址',
    width: 200,
    showOverflowTooltip: true
  },
  {
    prop: 'priority',
    label: '优先级',
    width: 80,
    align: 'center' as const
  },
  {
    prop: 'successRate',
    label: '成功率',
    width: 100,
    formatter: (row: Provider) => `${row.successRate}%`
  },
  {
    prop: 'avgResponseTime',
    label: '平均响应',
    width: 100,
    formatter: (row: Provider) => `${row.avgResponseTime}ms`
  },
  {
    prop: 'todayRequests',
    label: '今日请求',
    width: 100,
    align: 'center' as const
  },
  {
    prop: 'enabled',
    label: '启用状态',
    width: 80,
    align: 'center' as const,
    formatter: (row: Provider) => row.enabled ? '✓' : '✗'
  },
  {
    prop: 'actions',
    label: '操作',
    width: 200,
    fixed: 'right' as const,
    type: 'actions' as const,
    actions: [
      {
        key: 'detail',
        label: '详情',
        type: 'primary' as const,
        icon: 'View'
      },
      {
        key: 'edit',
        label: '编辑',
        type: 'primary' as const,
        icon: 'Edit'
      },
      {
        key: 'test',
        label: '测试',
        type: 'warning' as const,
        icon: 'Connection'
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

// 方法
const loadProviders = async () => {
  try {
    loading.value = true
    // 模拟API调用
    await new Promise(resolve => setTimeout(resolve, 500))
    pagination.total = providerList.value.length
  } catch (error: any) {
    ElMessage.error('加载提供商列表失败')
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  loadProviders()
}

const handleFilterChange = () => {
  loadProviders()
}

const resetFilters = () => {
  Object.assign(filters, {
    keyword: '',
    status: '',
    type: ''
  })
  loadProviders()
}

const handleRefresh = () => {
  loadProviders()
}

const handlePageChange = (page: number) => {
  pagination.current = page
  loadProviders()
}

const handleSizeChange = (size: number) => {
  pagination.size = size
  pagination.current = 1
  loadProviders()
}

const handleAction = async (action: any, row: Provider) => {
  switch (action) {
    case 'detail':
      selectedProvider.value = row
      showDetailDialog.value = true
      break
    case 'edit':
      editingProvider.value = row
      Object.assign(providerForm, {
        name: row.name,
        type: row.type,
        apiUrl: row.apiUrl,
        apiVersion: row.apiVersion,
        authType: row.authType,
        timeout: row.timeout,
        retryCount: row.retryCount,
        qpsLimit: row.qpsLimit,
        priority: row.priority,
        enabled: row.enabled,
        healthCheck: row.healthCheck,
        healthCheckUrl: row.healthCheckUrl || '',
        description: row.description || ''
      })
      showCreateDialog.value = true
      break
    case 'test':
      await testProviderConnection(row)
      break
    case 'delete':
      await handleDeleteProvider(row)
      break
  }
}

const handleSaveProvider = async () => {
  if (!formRef.value) return
  
  try {
    await formRef.value.validate()
    saving.value = true
    
    // 模拟API调用
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    if (editingProvider.value) {
      ElMessage.success('提供商更新成功')
    } else {
      ElMessage.success('提供商创建成功')
    }
    
    showCreateDialog.value = false
    resetForm()
    loadProviders()
  } catch (error) {
    // 验证失败
  } finally {
    saving.value = false
  }
}

const resetForm = () => {
  editingProvider.value = null
  Object.assign(providerForm, {
    name: '',
    type: '',
    apiUrl: '',
    apiVersion: '',
    authType: 'api_key',
    apiKey: '',
    username: '',
    password: '',
    token: '',
    clientId: '',
    clientSecret: '',
    timeout: 30,
    retryCount: 3,
    qpsLimit: 100,
    priority: 1,
    enabled: true,
    healthCheck: false,
    healthCheckUrl: '',
    description: ''
  })
  formRef.value?.resetFields()
}

const testConnection = async () => {
  if (!formRef.value) return
  
  try {
    await formRef.value.validate(['apiUrl'])
    testing.value = true
    
    // 模拟连接测试
    await new Promise(resolve => setTimeout(resolve, 2000))
    
    ElMessage.success('连接测试成功')
  } catch (error) {
    ElMessage.error('连接测试失败')
  } finally {
    testing.value = false
  }
}

const testProviderConnection = async (provider: Provider) => {
  try {
    ElMessage.info(`正在测试 ${provider.name} 连接...`)
    // 模拟API调用
    await new Promise(resolve => setTimeout(resolve, 1000))
    ElMessage.success('连接测试成功')
  } catch (error) {
    ElMessage.error('连接测试失败')
  }
}

const handleDeleteProvider = async (provider: Provider) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除提供商 "${provider.name}" 吗？此操作不可恢复。`,
      '确认删除',
      {
        type: 'warning',
        confirmButtonText: '确定删除',
        cancelButtonText: '取消'
      }
    )
    
    ElMessage.success('提供商删除成功')
    loadProviders()
  } catch (error) {
    // 用户取消
  }
}

// 辅助方法
const getTypeLabel = (type: string) => {
  const typeMap: Record<string, string> = {
    wework: '企微官方',
    proxy: '代理服务',
    cloud: '云服务',
    private: '私有部署'
  }
  return typeMap[type] || type
}

const getStatusLabel = (status: string) => {
  const statusMap: Record<string, string> = {
    active: '活跃',
    pending: '待审核',
    disabled: '已禁用',
    error: '异常'
  }
  return statusMap[status] || status
}

const getStatusType = (status: string): 'success' | 'warning' | 'info' | 'danger' => {
  const statusTypeMap: Record<string, 'success' | 'warning' | 'info' | 'danger'> = {
    active: 'success',
    pending: 'warning',
    disabled: 'info',
    error: 'danger'
  }
  return statusTypeMap[status] || 'info'
}

const getAuthTypeLabel = (authType: string) => {
  const authTypeMap: Record<string, string> = {
    api_key: 'API Key',
    oauth: 'OAuth 2.0',
    basic: 'Basic Auth',
    bearer: 'Bearer Token'
  }
  return authTypeMap[authType] || authType
}

// 生命周期
onMounted(() => {
  loadProviders()
})
</script>

<style lang="scss" scoped>
.provider-management {
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
  
  .provider-detail {
    .performance-stats {
      margin-top: 24px;
      
      h4 {
        margin: 0 0 16px 0;
        font-size: 16px;
        font-weight: 600;
        color: var(--el-text-color-primary);
      }
    }
  }
  
  .dialog-footer {
    display: flex;
    gap: 12px;
    justify-content: flex-end;
  }
}

// 响应式适配
@media (max-width: 768px) {
  .provider-management {
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