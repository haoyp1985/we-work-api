<template>
  <div class="platform-config-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-title">
        <h1>平台集成管理</h1>
        <p>管理AI平台连接配置，包括OpenAI、Claude、文心一言等平台的接入</p>
      </div>
      <div class="header-actions">
        <el-button 
          type="primary" 
          :icon="Plus" 
          @click="handleCreate"
        >
          添加平台配置
        </el-button>
      </div>
    </div>

    <!-- 平台概览卡片 -->
    <div class="platform-overview">
      <el-row :gutter="20">
        <el-col :span="6">
          <el-card class="stat-card">
            <div class="stat-content">
              <div class="stat-icon">
                <el-icon><Connection /></el-icon>
              </div>
              <div class="stat-info">
                <div class="stat-value">{{ totalConfigs }}</div>
                <div class="stat-label">总配置数</div>
              </div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="stat-card">
            <div class="stat-content">
              <div class="stat-icon active">
                <el-icon><Check /></el-icon>
              </div>
              <div class="stat-info">
                <div class="stat-value">{{ activeConfigs }}</div>
                <div class="stat-label">活跃配置</div>
              </div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="stat-card">
            <div class="stat-content">
              <div class="stat-icon warning">
                <el-icon><Warning /></el-icon>
              </div>
              <div class="stat-info">
                <div class="stat-value">{{ errorConfigs }}</div>
                <div class="stat-label">异常配置</div>
              </div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="stat-card">
            <div class="stat-content">
              <div class="stat-icon cost">
                <el-icon><Money /></el-icon>
              </div>
              <div class="stat-info">
                <div class="stat-value">¥{{ totalCost.toFixed(2) }}</div>
                <div class="stat-label">本月费用</div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- 搜索和过滤 -->
    <el-card class="search-card" shadow="never">
      <el-form :model="searchForm" inline>
        <el-form-item label="关键词">
          <el-input
            v-model="searchForm.keyword"
            placeholder="搜索配置名称、描述"
            :prefix-icon="Search"
            clearable
            style="width: 250px"
          />
        </el-form-item>
        
        <el-form-item label="平台类型">
          <el-select
            v-model="searchForm.platformType"
            placeholder="选择平台类型"
            clearable
            style="width: 200px"
          >
            <el-option
              v-for="platform in platformTypes"
              :key="platform.value"
              :label="platform.label"
              :value="platform.value"
            >
              <span class="platform-option">
                <span class="platform-logo">{{ platform.logo }}</span>
                <span>{{ platform.label }}</span>
              </span>
            </el-option>
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

    <!-- 平台配置列表 -->
    <el-card class="table-card" shadow="never">
      <template #header>
        <div class="table-header">
          <div class="table-title">
            <span>平台配置列表</span>
          </div>
          <div class="table-actions">
            <el-button 
              :icon="Download" 
              @click="handleExport"
              :disabled="!selectedRows.length"
            >
              导出配置
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
        style="width: 100%"
      >
        <el-table-column type="selection" width="55" align="center" />
        
        <el-table-column label="平台信息" min-width="280">
          <template #default="{ row }">
            <div class="platform-info">
              <div class="platform-header">
                <div class="platform-logo">
                  {{ getPlatformLogo(row.platformType) }}
                </div>
                <div class="platform-details">
                  <div class="platform-name">
                    {{ row.name }}
                    <el-tag v-if="row.isDefault" type="success" size="small">默认</el-tag>
                  </div>
                  <div class="platform-type">
                    {{ getPlatformLabel(row.platformType) }}
                  </div>
                </div>
              </div>
              <div v-if="row.description" class="platform-description">
                {{ row.description }}
              </div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="状态" width="120" align="center">
          <template #default="{ row }">
            <div class="status-column">
              <el-tag 
                :type="getStatusTagType(row.status)"
                size="small"
              >
                {{ getStatusLabel(row.status) }}
              </el-tag>
              <div v-if="row.lastTestedAt" class="last-test">
                上次测试: {{ formatTime(row.lastTestedAt) }}
              </div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="配置信息" width="200">
          <template #default="{ row }">
            <div class="config-info">
              <div class="config-item">
                <span class="label">API密钥:</span>
                <span class="value masked">{{ maskApiKey(row.config.apiKey) }}</span>
              </div>
              <div v-if="row.config.apiUrl" class="config-item">
                <span class="label">接口地址:</span>
                <span class="value">{{ row.config.apiUrl }}</span>
              </div>
              <div v-if="row.config.region" class="config-item">
                <span class="label">区域:</span>
                <span class="value">{{ row.config.region }}</span>
              </div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="使用统计" width="160" align="center">
          <template #default="{ row }">
            <div class="usage-stats">
              <div class="stat-item">
                <span class="stat-label">请求数:</span>
                <span class="stat-value">{{ row.stats?.requestCount || 0 }}</span>
              </div>
              <div class="stat-item">
                <span class="stat-label">费用:</span>
                <span class="stat-value">¥{{ (row.stats?.cost || 0).toFixed(2) }}</span>
              </div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="创建时间" width="150" align="center">
          <template #default="{ row }">
            <div class="time-info">
              <div>{{ formatDate(row.createdAt) }}</div>
              <div class="sub-text">{{ row.createdBy }}</div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="200" align="center" fixed="right">
          <template #default="{ row }">
            <div class="action-buttons">
              <el-button
                type="primary"
                size="small"
                :icon="Cpu"
                @click="handleTest(row)"
                :loading="row.testing"
              >
                测试
              </el-button>
              
              <el-dropdown @command="(command) => handleDropdownAction(command, row)">
                <el-button size="small" :icon="Setting" />
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item command="edit" :icon="Edit">
                      编辑
                    </el-dropdown-item>
                    <el-dropdown-item 
                      command="set-default" 
                      :icon="Star"
                      :disabled="row.isDefault"
                    >
                      设为默认
                    </el-dropdown-item>
                    <el-dropdown-item command="stats" :icon="DataBoard">
                      查看统计
                    </el-dropdown-item>
                    <el-dropdown-item command="quota" :icon="Money">
                      配额管理
                    </el-dropdown-item>
                    <el-dropdown-item 
                      :command="row.status === 'ACTIVE' ? 'disable' : 'enable'" 
                      :icon="row.status === 'ACTIVE' ? Close : Check"
                    >
                      {{ row.status === 'ACTIVE' ? '禁用' : '启用' }}
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

    <!-- 创建/编辑平台配置对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogMode === 'create' ? '添加平台配置' : '编辑平台配置'"
      width="600px"
      :before-close="handleDialogClose"
    >
      <el-form
        ref="formRef"
        :model="formData"
        :rules="formRules"
        label-width="100px"
      >
        <el-form-item label="配置名称" prop="name">
          <el-input
            v-model="formData.name"
            placeholder="请输入配置名称"
          />
        </el-form-item>
        
        <el-form-item label="平台类型" prop="platformType">
          <el-select
            v-model="formData.platformType"
            placeholder="请选择平台类型"
            style="width: 100%"
            @change="handlePlatformTypeChange"
          >
            <el-option
              v-for="platform in platformTypes"
              :key="platform.value"
              :label="platform.label"
              :value="platform.value"
            >
              <span class="platform-option">
                <span class="platform-logo">{{ platform.logo }}</span>
                <span>{{ platform.label }}</span>
              </span>
            </el-option>
          </el-select>
        </el-form-item>

        <el-form-item label="描述" prop="description">
          <el-input
            v-model="formData.description"
            type="textarea"
            :rows="2"
            placeholder="请输入配置描述（可选）"
          />
        </el-form-item>

        <el-form-item label="API密钥" prop="apiKey">
          <el-input
            v-model="formData.config.apiKey"
            type="password"
            placeholder="请输入API密钥"
            show-password
          />
        </el-form-item>

        <el-form-item 
          v-if="currentPlatformConfig?.configFields?.find(f => f.name === 'apiUrl')"
          label="API地址" 
          prop="apiUrl"
        >
          <el-input
            v-model="formData.config.apiUrl"
            placeholder="请输入API地址（可选）"
          />
        </el-form-item>

        <el-form-item 
          v-if="currentPlatformConfig?.configFields?.find(f => f.name === 'organizationId')"
          label="组织ID" 
          prop="organizationId"
        >
          <el-input
            v-model="formData.config.organizationId"
            placeholder="请输入组织ID（可选）"
          />
        </el-form-item>

        <el-form-item 
          v-if="currentPlatformConfig?.configFields?.find(f => f.name === 'region')"
          label="区域" 
          prop="region"
        >
          <el-select
            v-model="formData.config.region"
            placeholder="请选择区域"
            style="width: 100%"
          >
            <el-option label="美国东部" value="us-east-1" />
            <el-option label="美国西部" value="us-west-1" />
            <el-option label="欧洲" value="eu-west-1" />
            <el-option label="亚太" value="ap-southeast-1" />
          </el-select>
        </el-form-item>

        <el-form-item label="超时时间" prop="timeout">
          <el-input-number
            v-model="formData.config.timeout"
            :min="1000"
            :max="60000"
            :step="1000"
            placeholder="毫秒"
            style="width: 100%"
          />
          <span class="form-tip">API请求超时时间（毫秒）</span>
        </el-form-item>

        <el-form-item label="重试次数" prop="maxRetries">
          <el-input-number
            v-model="formData.config.maxRetries"
            :min="0"
            :max="5"
            placeholder="次数"
            style="width: 100%"
          />
          <span class="form-tip">API请求失败时的重试次数</span>
        </el-form-item>
      </el-form>

      <template #footer>
        <div class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button 
            type="primary" 
            :loading="saveLoading"
            @click="handleSave"
          >
            {{ dialogMode === 'create' ? '创建' : '保存' }}
          </el-button>
          <el-button 
            v-if="dialogMode === 'create'"
            type="success"
            :loading="testLoading"
            @click="handleTestAndSave"
          >
            测试并保存
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
  Setting,
  Star,
  DataBoard,
  Money,
  Check,
  Close,
  Cpu,
  Connection,
  Warning
} from '@element-plus/icons-vue'
import * as platformApi from '@/api/platform'
import type { 
  PlatformConfig, 
  PlatformType, 
  PlatformConfigStatus,
  PageQuery
} from '@/types/api'
import type { FormInstance, FormRules } from 'element-plus'

// 响应式数据
const loading = ref(false)
const tableData = ref<PlatformConfig[]>([])
const total = ref(0)
const selectedRows = ref<PlatformConfig[]>([])

// 统计数据
const totalConfigs = ref(0)
const activeConfigs = ref(0)
const errorConfigs = ref(0)
const totalCost = ref(0)

// 搜索表单
const searchForm = reactive<PageQuery & {
  platformType?: PlatformType
  status?: PlatformConfigStatus
}>({
  current: 1,
  size: 10,
  keyword: '',
  platformType: undefined,
  status: undefined
})

// 平台类型选项
const platformTypes = [
  { label: 'OpenAI', value: 'OPENAI', logo: '🤖' },
  { label: 'Anthropic Claude', value: 'ANTHROPIC_CLAUDE', logo: '🧠' },
  { label: '百度文心一言', value: 'BAIDU_WENXIN', logo: '🐻' },
  { label: 'Coze', value: 'COZE', logo: '🚀' },
  { label: 'Dify', value: 'DIFY', logo: '⚡' }
]

// 状态选项
const statusOptions = [
  { label: '活跃', value: 'ACTIVE' },
  { label: '非活跃', value: 'INACTIVE' },
  { label: '错误', value: 'ERROR' }
]

// 表单相关
const dialogVisible = ref(false)
const dialogMode = ref<'create' | 'edit'>('create')
const saveLoading = ref(false)
const testLoading = ref(false)
const formRef = ref<FormInstance>()
const currentPlatformConfig = ref<any>()

const formData = reactive({
  id: '',
  name: '',
  platformType: '' as PlatformType,
  description: '',
  config: {
    apiKey: '',
    apiUrl: '',
    organizationId: '',
    region: '',
    timeout: 30000,
    maxRetries: 3
  }
})

const formRules: FormRules = {
  name: [
    { required: true, message: '请输入配置名称', trigger: 'blur' },
    { min: 1, max: 50, message: '名称长度在 1 到 50 个字符', trigger: 'blur' }
  ],
  platformType: [
    { required: true, message: '请选择平台类型', trigger: 'change' }
  ],
  apiKey: [
    { required: true, message: '请输入API密钥', trigger: 'blur' }
  ]
}

// 计算属性
const filteredData = computed(() => {
  return tableData.value
})

// 获取平台标签
const getPlatformLabel = (platformType: PlatformType): string => {
  const platform = platformTypes.find(p => p.value === platformType)
  return platform?.label || platformType
}

// 获取平台Logo
const getPlatformLogo = (platformType: PlatformType): string => {
  const platform = platformTypes.find(p => p.value === platformType)
  return platform?.logo || '🔗'
}

// 获取状态标签类型
const getStatusTagType = (status: PlatformConfigStatus): string => {
  const typeMap = {
    'ACTIVE': 'success',
    'INACTIVE': 'warning',
    'ERROR': 'danger'
  }
  return typeMap[status] || 'info'
}

// 获取状态标签文本
const getStatusLabel = (status: PlatformConfigStatus): string => {
  const labelMap = {
    'ACTIVE': '活跃',
    'INACTIVE': '非活跃',
    'ERROR': '错误'
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
  } else {
    return time.toLocaleDateString()
  }
}

// 格式化日期
const formatDate = (timeStr: string): string => {
  if (!timeStr) return '-'
  return new Date(timeStr).toLocaleDateString()
}

// 掩码API密钥
const maskApiKey = (apiKey: string): string => {
  if (!apiKey) return '-'
  if (apiKey.length <= 8) return '*'.repeat(apiKey.length)
  return apiKey.substring(0, 4) + '*'.repeat(apiKey.length - 8) + apiKey.substring(apiKey.length - 4)
}

// 加载数据
const loadData = async () => {
  loading.value = true
  try {
    const response = await platformApi.getPlatformConfigs(searchForm)
    tableData.value = response.data.records
    total.value = response.data.total
    searchForm.current = response.data.current
    searchForm.size = response.data.size
    
    // 更新统计数据
    updateStats()
  } catch (error) {
    console.error('加载平台配置列表失败:', error)
    ElMessage.error('加载数据失败')
  } finally {
    loading.value = false
  }
}

// 更新统计数据
const updateStats = () => {
  totalConfigs.value = tableData.value.length
  activeConfigs.value = tableData.value.filter(item => item.status === 'ACTIVE').length
  errorConfigs.value = tableData.value.filter(item => item.status === 'ERROR').length
  totalCost.value = tableData.value.reduce((sum, item) => sum + (item.stats?.cost || 0), 0)
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
    platformType: undefined,
    status: undefined
  })
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
const handleSelectionChange = (selection: PlatformConfig[]) => {
  selectedRows.value = selection
}

// 创建配置
const handleCreate = () => {
  dialogMode.value = 'create'
  dialogVisible.value = true
  resetForm()
}

// 重置表单
const resetForm = () => {
  Object.assign(formData, {
    id: '',
    name: '',
    platformType: '',
    description: '',
    config: {
      apiKey: '',
      apiUrl: '',
      organizationId: '',
      region: '',
      timeout: 30000,
      maxRetries: 3
    }
  })
  currentPlatformConfig.value = null
}

// 平台类型变化
const handlePlatformTypeChange = async (platformType: PlatformType) => {
  try {
    // 这里可以加载平台特定的配置模板
    // const template = await platformApi.getPlatformConfigTemplate(platformType)
    // currentPlatformConfig.value = template.data
  } catch (error) {
    console.error('加载平台配置模板失败:', error)
  }
}

// 保存配置
const handleSave = async () => {
  if (!formRef.value) return
  
  try {
    await formRef.value.validate()
    saveLoading.value = true
    
    if (dialogMode.value === 'create') {
      await platformApi.createPlatformConfig({
        name: formData.name,
        platformType: formData.platformType,
        description: formData.description,
        config: formData.config
      })
    } else {
      await platformApi.updatePlatformConfig(formData.id, {
        name: formData.name,
        description: formData.description,
        config: formData.config
      })
    }
    
    dialogVisible.value = false
    await loadData()
  } catch (error) {
    console.error('保存平台配置失败:', error)
  } finally {
    saveLoading.value = false
  }
}

// 测试并保存
const handleTestAndSave = async () => {
  if (!formRef.value) return
  
  try {
    await formRef.value.validate()
    testLoading.value = true
    
    // 先创建配置
    const response = await platformApi.createPlatformConfig({
      name: formData.name,
      platformType: formData.platformType,
      description: formData.description,
      config: formData.config
    })
    
    // 然后测试连接
    await platformApi.testPlatformConnection(response.data.id)
    
    ElMessage.success('配置创建成功，连接测试通过')
    dialogVisible.value = false
    await loadData()
  } catch (error) {
    console.error('测试或保存失败:', error)
    ElMessage.error('测试或保存失败')
  } finally {
    testLoading.value = false
  }
}

// 测试连接
const handleTest = async (row: PlatformConfig) => {
  try {
    row.testing = true
    const response = await platformApi.testPlatformConnection(row.id)
    
    if (response.data.success) {
      ElMessage.success(`连接测试成功，响应时间: ${response.data.responseTime}ms`)
    } else {
      ElMessage.error(`连接测试失败: ${response.data.message}`)
    }
  } catch (error) {
    console.error('连接测试失败:', error)
    ElMessage.error('连接测试失败')
  } finally {
    row.testing = false
  }
}

// 下拉菜单操作
const handleDropdownAction = async (command: string, row: PlatformConfig) => {
  switch (command) {
    case 'edit':
      await handleEdit(row)
      break
    case 'set-default':
      await handleSetDefault(row)
      break
    case 'stats':
      // TODO: 显示统计信息
      ElMessage.info('统计功能开发中...')
      break
    case 'quota':
      // TODO: 配额管理
      ElMessage.info('配额管理功能开发中...')
      break
    case 'enable':
    case 'disable':
      await handleToggleStatus(row, command === 'enable' ? 'ACTIVE' : 'INACTIVE')
      break
    case 'delete':
      await handleDelete(row)
      break
  }
}

// 编辑配置
const handleEdit = async (row: PlatformConfig) => {
  try {
    const response = await platformApi.getPlatformConfig(row.id)
    const config = response.data
    
    Object.assign(formData, {
      id: config.id,
      name: config.name,
      platformType: config.platformType,
      description: config.description,
      config: config.config
    })
    
    dialogMode.value = 'edit'
    dialogVisible.value = true
  } catch (error) {
    console.error('加载配置详情失败:', error)
    ElMessage.error('加载配置详情失败')
  }
}

// 设为默认
const handleSetDefault = async (row: PlatformConfig) => {
  try {
    await platformApi.setDefaultPlatformConfig(row.id)
    await loadData()
  } catch (error) {
    console.error('设置默认配置失败:', error)
    ElMessage.error('设置默认配置失败')
  }
}

// 切换状态
const handleToggleStatus = async (row: PlatformConfig, status: PlatformConfigStatus) => {
  try {
    await platformApi.updatePlatformConfig(row.id, { status })
    
    // 更新本地数据
    const index = tableData.value.findIndex(item => item.id === row.id)
    if (index > -1) {
      tableData.value[index].status = status
    }
    
    updateStats()
  } catch (error) {
    console.error('切换状态失败:', error)
    ElMessage.error('切换状态失败')
  }
}

// 删除配置
const handleDelete = async (row: PlatformConfig) => {
  try {
    await ElMessageBox.confirm(
      `确认删除平台配置"${row.name}"吗？此操作不可恢复。`,
      '删除确认',
      {
        confirmButtonText: '确认删除',
        cancelButtonText: '取消',
        type: 'warning',
      }
    )
    
    await platformApi.deletePlatformConfig(row.id)
    await loadData()
  } catch (error) {
    // 用户取消删除或API错误
    if (error && typeof error === 'object' && 'message' in error) {
      console.error('删除平台配置失败:', error)
    }
  }
}

// 批量删除
const handleBatchDelete = async () => {
  if (!selectedRows.value.length) return
  
  try {
    await ElMessageBox.confirm(
      `确认删除选中的 ${selectedRows.value.length} 个配置吗？此操作不可恢复。`,
      '批量删除确认',
      {
        confirmButtonText: '确认删除',
        cancelButtonText: '取消',
        type: 'warning',
      }
    )
    
    // 批量删除
    await Promise.all(selectedRows.value.map(row => 
      platformApi.deletePlatformConfig(row.id)
    ))
    
    await loadData()
  } catch (error) {
    if (error && typeof error === 'object' && 'message' in error) {
      console.error('批量删除失败:', error)
    }
  }
}

// 导出配置
const handleExport = () => {
  if (!selectedRows.value.length) return
  
  // TODO: 实现导出功能
  ElMessage.info('导出功能开发中...')
}

// 对话框关闭
const handleDialogClose = () => {
  formRef.value?.resetFields()
  resetForm()
}

// 初始化
onMounted(() => {
  loadData()
})
</script>

<style scoped lang="scss">
.platform-config-container {
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

  .platform-overview {
    margin-bottom: 20px;

    .stat-card {
      border-radius: 8px;
      
      :deep(.el-card__body) {
        padding: 20px;
      }

      .stat-content {
        display: flex;
        align-items: center;
        gap: 16px;

        .stat-icon {
          width: 48px;
          height: 48px;
          border-radius: 8px;
          display: flex;
          align-items: center;
          justify-content: center;
          background: #f0f0f0;
          color: #86909c;
          font-size: 24px;

          &.active {
            background: #e8f5e8;
            color: #67c23a;
          }

          &.warning {
            background: #fef0e6;
            color: #e6a23c;
          }

          &.cost {
            background: #e6f7ff;
            color: #1890ff;
          }
        }

        .stat-info {
          .stat-value {
            font-size: 24px;
            font-weight: 600;
            color: #1f2329;
            margin-bottom: 4px;
          }

          .stat-label {
            font-size: 12px;
            color: #86909c;
          }
        }
      }
    }
  }

  .search-card {
    margin-bottom: 20px;
    border-radius: 8px;
    
    :deep(.el-card__body) {
      padding: 20px;
    }

    .platform-option {
      display: flex;
      align-items: center;
      gap: 8px;

      .platform-logo {
        font-size: 16px;
      }
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

    .platform-info {
      .platform-header {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-bottom: 4px;

        .platform-logo {
          font-size: 20px;
        }

        .platform-details {
          .platform-name {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            font-size: 14px;
            color: #1f2329;
            margin-bottom: 2px;
          }

          .platform-type {
            font-size: 12px;
            color: #86909c;
          }
        }
      }

      .platform-description {
        font-size: 12px;
        color: #86909c;
        line-height: 1.4;
      }
    }

    .status-column {
      .last-test {
        font-size: 11px;
        color: #86909c;
        margin-top: 4px;
      }
    }

    .config-info {
      .config-item {
        display: flex;
        margin-bottom: 4px;
        font-size: 12px;

        .label {
          min-width: 60px;
          color: #86909c;
        }

        .value {
          color: #1f2329;
          flex: 1;

          &.masked {
            font-family: monospace;
          }
        }
      }
    }

    .usage-stats {
      .stat-item {
        display: flex;
        justify-content: space-between;
        margin-bottom: 4px;
        font-size: 12px;

        .stat-label {
          color: #86909c;
        }

        .stat-value {
          color: #1f2329;
          font-weight: 500;
        }
      }
    }

    .time-info {
      font-size: 12px;
      color: #1f2329;

      .sub-text {
        color: #86909c;
        margin-top: 2px;
      }
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

  .form-tip {
    font-size: 12px;
    color: #86909c;
    margin-left: 8px;
  }
}
</style>