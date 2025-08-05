<template>
  <div class="platform-config-management">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-left">
        <h2 class="page-title">
          <el-icon><Connection /></el-icon>
          外部平台配置
        </h2>
        <div class="header-stats">
          <StatusIndicator
            mode="simple"
            type="success"
            :text="`已启用: ${stats.enabledCount}`"
          />
          <StatusIndicator
            mode="simple"
            type="warning"
            :text="`已禁用: ${stats.disabledCount}`"
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
          新增平台配置
        </el-button>
      </div>
    </div>

    <!-- 搜索筛选区域 -->
    <el-card class="search-card" shadow="never">
      <el-form 
        :model="searchForm" 
        inline 
        label-width="auto"
        @submit.prevent="handleSearch"
      >
        <el-form-item label="平台名称">
          <el-input
            v-model="searchForm.platformName"
            placeholder="请输入平台名称"
            clearable
            style="width: 200px"
            @keyup.enter="handleSearch"
          />
        </el-form-item>

        <el-form-item label="平台类型">
          <el-select
            v-model="searchForm.platformType"
            placeholder="请选择平台类型"
            clearable
            style="width: 180px"
          >
            <el-option
              v-for="(label, value) in platformTypeOptions"
              :key="value"
              :label="label"
              :value="value"
            />
          </el-select>
        </el-form-item>

        <el-form-item label="状态">
          <el-select
            v-model="searchForm.enabled"
            placeholder="请选择状态"
            clearable
            style="width: 120px"
          >
            <el-option label="已启用" :value="true" />
            <el-option label="已禁用" :value="false" />
          </el-select>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon>
            搜索
          </el-button>
          <el-button @click="handleReset">
            <el-icon><Refresh /></el-icon>
            重置
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 数据表格 -->
    <el-card class="table-card" shadow="never">
      <DataTable
        v-model:selected="selectedRows"
        :data="tableData"
        :columns="tableColumns"
        :loading="loading"
        :pagination="pagination"
        row-key="id"
        @page-change="handlePageChange"
        @size-change="handleSizeChange"
        @selection-change="handleSelectionChange"
      >
        <!-- 平台类型列 -->
        <template #platformType="{ row }">
          <el-tag :type="getPlatformTypeTagType(row.platformType)" size="small">
            {{ getPlatformTypeText(row.platformType) }}
          </el-tag>
        </template>

        <!-- 状态列 -->
        <template #enabled="{ row }">
          <el-switch
            v-model="row.enabled"
            :disabled="updating.includes(row.id)"
            @change="handleStatusChange(row)"
          />
        </template>

        <!-- 连接状态列 -->
        <template #connectionStatus="{ row }">
          <div class="connection-status">
            <el-tag
              :type="getConnectionStatusType(row.lastTestResult)"
              size="small"
              effect="plain"
            >
              {{ getConnectionStatusText(row.lastTestResult) }}
            </el-tag>
            <el-button
              type="primary"
              size="small"
              link
              @click="handleTestConnection(row)"
              :loading="testing.includes(row.id)"
            >
              测试连接
            </el-button>
          </div>
        </template>

        <!-- 操作列 -->
        <template #actions="{ row }">
          <div class="table-actions">
            <el-button 
              size="small" 
              type="primary" 
              link
              @click="handleView(row)"
            >
              查看
            </el-button>
            <el-button 
              size="small" 
              type="primary" 
              link
              @click="handleEdit(row)"
            >
              编辑
            </el-button>
            <el-button 
              size="small" 
              type="primary" 
              link
              @click="handleTestConnection(row)"
              :loading="testing.includes(row.id)"
            >
              测试
            </el-button>
            <el-popconfirm
              title="确定要删除这个平台配置吗？"
              @confirm="handleDelete(row)"
            >
              <template #reference>
                <el-button 
                  size="small" 
                  type="danger" 
                  link
                >
                  删除
                </el-button>
              </template>
            </el-popconfirm>
          </div>
        </template>
      </DataTable>
    </el-card>

    <!-- 创建/编辑对话框 -->
    <el-dialog
      v-model="showCreateDialog"
      :title="dialogMode === 'create' ? '创建平台配置' : '编辑平台配置'"
      width="800px"
      :close-on-click-modal="false"
      @close="handleDialogClose"
    >
      <PlatformConfigForm
        :mode="dialogMode"
        :data="currentFormData"
        @submit="handleFormSubmit"
        @cancel="showCreateDialog = false"
      />
    </el-dialog>

    <!-- 查看详情对话框 -->
    <el-dialog
      v-model="showDetailDialog"
      title="平台配置详情"
      width="700px"
    >
      <PlatformConfigDetail
        v-if="currentPlatformConfig"
        :data="currentPlatformConfig"
        @close="showDetailDialog = false"
      />
    </el-dialog>

    <!-- 批量操作工具栏 -->
    <div v-if="selectedRows.length > 0" class="batch-actions">
      <div class="batch-info">
        已选择 {{ selectedRows.length }} 项
      </div>
      <div class="batch-buttons">
        <el-button 
          type="success" 
          size="small"
          @click="handleBatchEnable"
        >
          批量启用
        </el-button>
        <el-button 
          type="warning" 
          size="small"
          @click="handleBatchDisable"
        >
          批量禁用
        </el-button>
        <el-popconfirm
          title="确定要删除选中的平台配置吗？"
          @confirm="handleBatchDelete"
        >
          <template #reference>
            <el-button type="danger" size="small">
              批量删除
            </el-button>
          </template>
        </el-popconfirm>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { 
  Connection, Plus, Search, Refresh 
} from '@element-plus/icons-vue'
import { agentApi } from '@/api/agent'
import DataTable from '@/components/ui/DataTable.vue'
import StatusIndicator from '@/components/ui/StatusIndicator.vue'
import PlatformConfigForm from './components/PlatformConfigForm.vue'
import PlatformConfigDetail from './components/PlatformConfigDetail.vue'
import type { 
  PlatformConfigDTO, 
  PlatformType,
  PageResult,
  PlatformConfigQueryRequest
} from '@/types'

// ==================== 数据定义 ====================

// 表格数据
const tableData = ref<PlatformConfigDTO[]>([])
const loading = ref(false)
const selectedRows = ref<PlatformConfigDTO[]>([])
const updating = ref<string[]>([])
const testing = ref<string[]>([])

// 分页信息
const pagination = reactive({
  current: 1,
  size: 20,
  total: 0
})

// 搜索表单
const searchForm = reactive<PlatformConfigQueryRequest>({
  platformName: '',
  platformType: '',
  enabled: undefined,
  current: 1,
  size: 20
})

// 对话框相关
const showCreateDialog = ref(false)
const showDetailDialog = ref(false)
const dialogMode = ref<'create' | 'edit' | 'view'>('create')
const currentFormData = ref<Partial<PlatformConfigDTO>>({})
const currentPlatformConfig = ref<PlatformConfigDTO | null>(null)

// 平台类型选项
const platformTypeOptions = computed(() => ({
  'COZE': 'Coze',
  'DIFY': 'Dify',
  'ALIBABA_DASHSCOPE': '阿里百炼',
  'OPENAI': 'OpenAI',
  'CLAUDE': 'Claude',
  'WENXIN_YIYAN': '文心一言',
  'CUSTOM': '自定义平台'
}))

// 表格列配置
const tableColumns = computed(() => [
  { type: 'selection', width: 50 },
  { 
    prop: 'platformName', 
    label: '平台名称', 
    width: 180,
    showOverflowTooltip: true
  },
  { 
    prop: 'platformType', 
    label: '平台类型', 
    width: 120,
    slot: 'platformType'
  },
  { 
    prop: 'endpoint', 
    label: 'API端点', 
    width: 200,
    showOverflowTooltip: true
  },
  { 
    prop: 'enabled', 
    label: '状态', 
    width: 80,
    slot: 'enabled'
  },
  { 
    prop: 'connectionStatus', 
    label: '连接状态', 
    width: 140,
    slot: 'connectionStatus'
  },
  { 
    prop: 'createdAt', 
    label: '创建时间', 
    width: 160,
    formatter: (value: string) => new Date(value).toLocaleString()
  },
  { 
    prop: 'actions', 
    label: '操作', 
    width: 200,
    slot: 'actions',
    fixed: 'right'
  }
])

// 统计数据
const stats = computed(() => {
  const enabled = tableData.value.filter(item => item.enabled).length
  const disabled = tableData.value.filter(item => !item.enabled).length
  return {
    enabledCount: enabled,
    disabledCount: disabled,
    totalCount: tableData.value.length
  }
})

// ==================== 方法定义 ====================

// 获取平台配置列表
const fetchPlatformConfigs = async () => {
  loading.value = true
  try {
    const params = {
      ...searchForm,
      current: pagination.current,
      size: pagination.size
    }
    
    const response = await agentApi.getPlatformConfigList(params)
    if (response.success) {
      const result = response.data as PageResult<PlatformConfigDTO>
      tableData.value = result.records
      pagination.total = result.total
    } else {
      ElMessage.error(response.message || '获取平台配置列表失败')
    }
  } catch (error) {
    console.error('获取平台配置列表失败:', error)
    ElMessage.error('获取平台配置列表失败')
  } finally {
    loading.value = false
  }
}

// 搜索
const handleSearch = () => {
  pagination.current = 1
  fetchPlatformConfigs()
}

// 重置搜索
const handleReset = () => {
  Object.assign(searchForm, {
    platformName: '',
    platformType: '',
    enabled: undefined,
    current: 1,
    size: 20
  })
  pagination.current = 1
  fetchPlatformConfigs()
}

// 分页变化
const handlePageChange = (page: number) => {
  pagination.current = page
  fetchPlatformConfigs()
}

const handleSizeChange = (size: number) => {
  pagination.size = size
  pagination.current = 1
  fetchPlatformConfigs()
}

// 选择变化
const handleSelectionChange = (selection: PlatformConfigDTO[]) => {
  selectedRows.value = selection
}

// 查看详情
const handleView = async (row: PlatformConfigDTO) => {
  try {
    const response = await agentApi.getPlatformConfig(row.id)
    if (response.success) {
      currentPlatformConfig.value = response.data
      showDetailDialog.value = true
    } else {
      ElMessage.error(response.message || '获取平台配置详情失败')
    }
  } catch (error) {
    console.error('获取平台配置详情失败:', error)
    ElMessage.error('获取平台配置详情失败')
  }
}

// 编辑
const handleEdit = (row: PlatformConfigDTO) => {
  dialogMode.value = 'edit'
  currentFormData.value = { ...row }
  showCreateDialog.value = true
}

// 删除
const handleDelete = async (row: PlatformConfigDTO) => {
  try {
    const response = await agentApi.deletePlatformConfig(row.id)
    if (response.success) {
      ElMessage.success('删除成功')
      fetchPlatformConfigs()
    } else {
      ElMessage.error(response.message || '删除失败')
    }
  } catch (error) {
    console.error('删除平台配置失败:', error)
    ElMessage.error('删除失败')
  }
}

// 状态变化
const handleStatusChange = async (row: PlatformConfigDTO) => {
  updating.value.push(row.id)
  try {
    const response = await agentApi.updatePlatformConfig(row.id, {
      enabled: row.enabled
    })
    
    if (response.success) {
      ElMessage.success(`${row.enabled ? '启用' : '禁用'}成功`)
    } else {
      row.enabled = !row.enabled // 回滚状态
      ElMessage.error(response.message || '状态更新失败')
    }
  } catch (error) {
    console.error('状态更新失败:', error)
    row.enabled = !row.enabled // 回滚状态
    ElMessage.error('状态更新失败')
  } finally {
    updating.value = updating.value.filter(id => id !== row.id)
  }
}

// 测试连接
const handleTestConnection = async (row: PlatformConfigDTO) => {
  testing.value.push(row.id)
  try {
    const response = await agentApi.testPlatformConnection(row.id)
    if (response.success) {
      ElMessage.success('连接测试成功')
      // 更新连接状态
      row.lastTestResult = 'SUCCESS'
      row.lastTestTime = new Date().toISOString()
    } else {
      ElMessage.error(response.message || '连接测试失败')
      row.lastTestResult = 'FAILED'
      row.lastTestTime = new Date().toISOString()
    }
  } catch (error) {
    console.error('连接测试失败:', error)
    ElMessage.error('连接测试失败')
    row.lastTestResult = 'FAILED'
    row.lastTestTime = new Date().toISOString()
  } finally {
    testing.value = testing.value.filter(id => id !== row.id)
  }
}

// 表单提交
const handleFormSubmit = async (formData: PlatformConfigDTO) => {
  try {
    let response
    if (dialogMode.value === 'create') {
      response = await agentApi.createPlatformConfig(formData)
    } else {
      response = await agentApi.updatePlatformConfig(formData.id!, formData)
    }
    
    if (response.success) {
      ElMessage.success(`${dialogMode.value === 'create' ? '创建' : '更新'}成功`)
      showCreateDialog.value = false
      fetchPlatformConfigs()
    } else {
      ElMessage.error(response.message || `${dialogMode.value === 'create' ? '创建' : '更新'}失败`)
    }
  } catch (error) {
    console.error('表单提交失败:', error)
    ElMessage.error(`${dialogMode.value === 'create' ? '创建' : '更新'}失败`)
  }
}

// 对话框关闭
const handleDialogClose = () => {
  currentFormData.value = {}
  dialogMode.value = 'create'
}

// 批量启用
const handleBatchEnable = async () => {
  const ids = selectedRows.value.map(row => row.id)
  try {
    const response = await agentApi.batchUpdatePlatformConfigStatus(ids, true)
    if (response.success) {
      ElMessage.success('批量启用成功')
      selectedRows.value = []
      fetchPlatformConfigs()
    } else {
      ElMessage.error(response.message || '批量启用失败')
    }
  } catch (error) {
    console.error('批量启用失败:', error)
    ElMessage.error('批量启用失败')
  }
}

// 批量禁用
const handleBatchDisable = async () => {
  const ids = selectedRows.value.map(row => row.id)
  try {
    const response = await agentApi.batchUpdatePlatformConfigStatus(ids, false)
    if (response.success) {
      ElMessage.success('批量禁用成功')
      selectedRows.value = []
      fetchPlatformConfigs()
    } else {
      ElMessage.error(response.message || '批量禁用失败')
    }
  } catch (error) {
    console.error('批量禁用失败:', error)
    ElMessage.error('批量禁用失败')
  }
}

// 批量删除
const handleBatchDelete = async () => {
  const ids = selectedRows.value.map(row => row.id)
  try {
    await ElMessageBox.confirm('确定要删除选中的平台配置吗？', '批量删除确认')
    
    const response = await agentApi.batchDeletePlatformConfigs(ids)
    if (response.success) {
      ElMessage.success('批量删除成功')
      selectedRows.value = []
      fetchPlatformConfigs()
    } else {
      ElMessage.error(response.message || '批量删除失败')
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('批量删除失败:', error)
      ElMessage.error('批量删除失败')
    }
  }
}

// 工具方法
const getPlatformTypeText = (type: PlatformType) => {
  return platformTypeOptions.value[type] || type
}

const getPlatformTypeTagType = (type: PlatformType) => {
  const typeMap: Record<string, string> = {
    'COZE': 'primary',
    'DIFY': 'success',
    'ALIBABA_DASHSCOPE': 'warning',
    'OPENAI': 'danger',
    'CLAUDE': 'info',
    'WENXIN_YIYAN': 'primary',
    'CUSTOM': 'default'
  }
  return typeMap[type] || 'default'
}

const getConnectionStatusText = (status?: string) => {
  const statusMap: Record<string, string> = {
    'SUCCESS': '连接正常',
    'FAILED': '连接失败',
    'TIMEOUT': '连接超时'
  }
  return statusMap[status || ''] || '未测试'
}

const getConnectionStatusType = (status?: string) => {
  const typeMap: Record<string, string> = {
    'SUCCESS': 'success',
    'FAILED': 'danger',
    'TIMEOUT': 'warning'
  }
  return typeMap[status || ''] || 'info'
}

// ==================== 生命周期 ====================

onMounted(() => {
  fetchPlatformConfigs()
})
</script>

<style lang="scss" scoped>
.platform-config-management {
  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    
    .header-left {
      display: flex;
      align-items: center;
      gap: 20px;
      
      .page-title {
        margin: 0;
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 20px;
        font-weight: 600;
        color: var(--el-text-color-primary);
      }
      
      .header-stats {
        display: flex;
        gap: 16px;
      }
    }
  }
  
  .search-card {
    margin-bottom: 20px;
    
    .el-form {
      margin-bottom: 0;
    }
  }
  
  .table-card {
    margin-bottom: 20px;
  }
  
  .connection-status {
    display: flex;
    align-items: center;
    gap: 8px;
  }
  
  .table-actions {
    display: flex;
    gap: 8px;
  }
  
  .batch-actions {
    position: fixed;
    bottom: 20px;
    left: 50%;
    transform: translateX(-50%);
    background: var(--el-bg-color);
    border: 1px solid var(--el-border-color);
    border-radius: 8px;
    padding: 12px 20px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    z-index: 1000;
    display: flex;
    align-items: center;
    gap: 20px;
    
    .batch-info {
      color: var(--el-text-color-regular);
      font-size: 14px;
    }
    
    .batch-buttons {
      display: flex;
      gap: 12px;
    }
  }
}
</style>