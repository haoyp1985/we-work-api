<template>
  <div class="model-config-management">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-left">
        <h2 class="page-title">
          <el-icon><Cpu /></el-icon>
          AI模型配置
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
          新增模型配置
        </el-button>
      </div>
    </div>

    <!-- 搜索过滤器 -->
    <div class="search-area">
      <el-form :model="searchForm" inline>
        <el-form-item label="配置名称">
          <el-input
            v-model="searchForm.configName"
            placeholder="请输入配置名称"
            style="width: 200px"
            clearable
            @keyup.enter="handleSearch"
          />
        </el-form-item>
        
        <el-form-item label="平台类型">
          <el-select
            v-model="searchForm.platformType"
            placeholder="请选择平台类型"
            style="width: 150px"
            clearable
          >
            <el-option
              v-for="(label, value) in platformTypeOptions"
              :key="value"
              :label="label"
              :value="value"
            />
          </el-select>
        </el-form-item>
        
        <el-form-item label="模型名称">
          <el-input
            v-model="searchForm.modelName"
            placeholder="请输入模型名称"
            style="width: 200px"
            clearable
            @keyup.enter="handleSearch"
          />
        </el-form-item>
        
        <el-form-item label="状态">
          <el-select
            v-model="searchForm.enabled"
            placeholder="请选择状态"
            style="width: 120px"
            clearable
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
    </div>

    <!-- 数据表格 -->
    <div class="table-container">
      <DataTable
        v-model:loading="loading"
        :data="tableData"
        :columns="tableColumns"
        :pagination="pagination"
        @page-change="handlePageChange"
        @size-change="handleSizeChange"
        @refresh="handleRefresh"
      >
        <!-- 平台类型列 -->
        <template #platformType="{ row }">
          <el-tag :type="getPlatformTypeTagType(row.platformType)" size="small">
            {{ getPlatformTypeText(row.platformType) }}
          </el-tag>
        </template>

        <!-- 模型参数列 -->
        <template #modelParams="{ row }">
          <div class="model-params">
            <div class="param-item">
              <span class="param-label">Max Tokens:</span>
              <span class="param-value">{{ row.maxTokens || 'N/A' }}</span>
            </div>
            <div class="param-item">
              <span class="param-label">Temperature:</span>
              <span class="param-value">{{ row.temperature || 'N/A' }}</span>
            </div>
            <div class="param-item" v-if="row.topP">
              <span class="param-label">Top P:</span>
              <span class="param-value">{{ row.topP }}</span>
            </div>
          </div>
        </template>

        <!-- 状态列 -->
        <template #enabled="{ row }">
          <el-switch
            v-model="row.enabled"
            :loading="statusLoading[row.id]"
            @change="handleStatusChange(row)"
          />
        </template>

        <!-- 操作列 -->
        <template #actions="{ row }">
          <div class="action-buttons">
            <el-button
              size="small"
              type="primary"
              text
              @click="handleView(row)"
              v-permission="'model-config:read'"
            >
              <el-icon><View /></el-icon>
              查看
            </el-button>
            
            <el-button
              size="small"
              type="success"
              text
              @click="handleEdit(row)"
              v-permission="'model-config:update'"
            >
              <el-icon><Edit /></el-icon>
              编辑
            </el-button>
            
            <el-button
              size="small"
              type="warning"
              text
              @click="handleTest(row)"
              v-permission="'model-config:test'"
            >
              <el-icon><Lightning /></el-icon>
              测试
            </el-button>
            
            <el-button
              size="small"
              type="danger"
              text
              @click="handleDelete(row)"
              v-permission="'model-config:delete'"
            >
              <el-icon><Delete /></el-icon>
              删除
            </el-button>
          </div>
        </template>
      </DataTable>
    </div>

    <!-- 创建/编辑对话框 -->
    <el-dialog
      v-model="showCreateDialog"
      :title="dialogMode === 'create' ? '新增模型配置' : '编辑模型配置'"
      width="80%"
      :close-on-click-modal="false"
      append-to-body
    >
      <ModelConfigForm
        v-if="showCreateDialog"
        :mode="dialogMode"
        :model-value="currentConfig"
        @submit="handleFormSubmit"
        @cancel="handleFormCancel"
      />
    </el-dialog>

    <!-- 详情对话框 -->
    <el-dialog
      v-model="showDetailDialog"
      title="模型配置详情"
      width="70%"
      append-to-body
    >
      <ModelConfigDetail
        v-if="showDetailDialog && currentConfig"
        :data="currentConfig"
        @edit="handleEditFromDetail"
        @test="handleTestFromDetail"
        @close="showDetailDialog = false"
      />
    </el-dialog>

    <!-- 测试对话框 -->
    <el-dialog
      v-model="showTestDialog"
      title="模型测试"
      width="60%"
      append-to-body
    >
      <div class="test-container" v-if="showTestDialog">
        <div class="test-form">
          <el-form :model="testForm" label-width="100px">
            <el-form-item label="测试消息">
              <el-input
                v-model="testForm.message"
                type="textarea"
                :rows="3"
                placeholder="请输入测试消息"
                maxlength="500"
                show-word-limit
              />
            </el-form-item>
            
            <el-form-item>
              <el-button
                type="primary"
                @click="handleRunTest"
                :loading="testLoading"
              >
                <el-icon><Lightning /></el-icon>
                发送测试
              </el-button>
            </el-form-item>
          </el-form>
        </div>

        <div class="test-result" v-if="testResult">
          <div class="result-header">
            <h4>测试结果</h4>
            <el-tag :type="testResult.success ? 'success' : 'danger'" size="small">
              {{ testResult.success ? '成功' : '失败' }}
            </el-tag>
          </div>

          <div class="result-content">
            <el-alert
              v-if="!testResult.success"
              :title="testResult.error"
              type="error"
              :closable="false"
              show-icon
            />
            
            <div v-else class="success-result">
              <div class="result-metrics">
                <div class="metric-item">
                  <span class="metric-label">响应时间:</span>
                  <span class="metric-value">{{ testResult.responseTime }}ms</span>
                </div>
                <div class="metric-item">
                  <span class="metric-label">Token消耗:</span>
                  <span class="metric-value">{{ testResult.tokens || 'N/A' }}</span>
                </div>
              </div>
              
              <div class="response-content">
                <h5>模型响应:</h5>
                <div class="response-text">{{ testResult.response }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  Plus,
  Search,
  Refresh,
  View,
  Edit,
  Delete,
  Lightning,
  Cpu
} from '@element-plus/icons-vue'

// 导入组件和工具
import DataTable from '@/components/ui/DataTable.vue'
import StatusIndicator from '@/components/ui/StatusIndicator.vue'
import ModelConfigForm from './components/ModelConfigForm.vue'
import ModelConfigDetail from './components/ModelConfigDetail.vue'

// 导入类型和API
import type {
  ModelConfigDTO,
  ModelConfigQueryRequest,
  PlatformType,
  PageResult
} from '@/types/agent'
import { agentApi } from '@/api/agent'

// =============== 响应式数据 ===============
const loading = ref(false)
const statusLoading = ref<Record<string, boolean>>({})

// 对话框状态
const showCreateDialog = ref(false)
const showDetailDialog = ref(false)
const showTestDialog = ref(false)
const dialogMode = ref<'create' | 'edit'>('create')

// 表格数据
const tableData = ref<ModelConfigDTO[]>([])
const currentConfig = ref<ModelConfigDTO | null>(null)

// 搜索表单
const searchForm = reactive<ModelConfigQueryRequest>({
  configName: '',
  platformType: '',
  modelName: '',
  enabled: undefined,
  current: 1,
  size: 20
})

// 分页数据
const pagination = reactive({
  current: 1,
  size: 20,
  total: 0,
  showSizeChanger: true,
  showQuickJumper: true,
  showTotal: true
})

// 测试表单
const testForm = reactive({
  message: 'Hello, this is a test message. Please respond.'
})
const testLoading = ref(false)
const testResult = ref<any>(null)

// =============== 计算属性 ===============
const stats = computed(() => {
  const total = tableData.value.length
  const enabled = tableData.value.filter(item => item.enabled).length
  const disabled = total - enabled

  return {
    totalCount: total,
    enabledCount: enabled,
    disabledCount: disabled
  }
})

const platformTypeOptions = computed(() => ({
  'COZE': 'Coze',
  'DIFY': 'Dify',
  'ALIBABA_DASHSCOPE': '阿里百炼',
  'OPENAI': 'OpenAI',
  'CLAUDE': 'Claude',
  'WENXIN_YIYAN': '文心一言',
  'CUSTOM': '自定义'
}))

const tableColumns = computed(() => [
  {
    prop: 'configName',
    label: '配置名称',
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
    prop: 'modelName',
    label: '模型名称',
    width: 160,
    showOverflowTooltip: true
  },
  {
    prop: 'modelVersion',
    label: '模型版本',
    width: 120,
    showOverflowTooltip: true
  },
  {
    prop: 'modelParams',
    label: '模型参数',
    width: 200,
    slot: 'modelParams'
  },
  {
    prop: 'enabled',
    label: '状态',
    width: 80,
    slot: 'enabled'
  },
  {
    prop: 'createdAt',
    label: '创建时间',
    width: 160,
    formatter: (row: ModelConfigDTO) => formatDate(row.createdAt)
  },
  {
    prop: 'actions',
    label: '操作',
    width: 240,
    slot: 'actions',
    fixed: 'right'
  }
])

// =============== 方法定义 ===============
const fetchModelConfigs = async () => {
  loading.value = true
  try {
    const params = {
      ...searchForm,
      current: pagination.current,
      size: pagination.size
    }
    
    const response = await agentApi.getModelConfigs(params)
    if (response.code === 200) {
      const result = response.data as PageResult<ModelConfigDTO>
      tableData.value = result.records
      pagination.total = result.total
      pagination.current = result.current
    }
  } catch (error: any) {
    ElMessage.error(error.message || '获取模型配置列表失败')
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  pagination.current = 1
  fetchModelConfigs()
}

const handleReset = () => {
  Object.assign(searchForm, {
    configName: '',
    platformType: '',
    modelName: '',
    enabled: undefined,
    current: 1,
    size: 20
  })
  pagination.current = 1
  fetchModelConfigs()
}

const handleRefresh = () => {
  fetchModelConfigs()
}

const handlePageChange = (page: number) => {
  pagination.current = page
  fetchModelConfigs()
}

const handleSizeChange = (size: number) => {
  pagination.size = size
  pagination.current = 1
  fetchModelConfigs()
}

const handleStatusChange = async (row: ModelConfigDTO) => {
  statusLoading.value[row.id] = true
  try {
    const response = await agentApi.updateModelConfig(row.id, {
      enabled: row.enabled
    })
    if (response.code === 200) {
      ElMessage.success(`模型配置已${row.enabled ? '启用' : '禁用'}`)
    }
  } catch (error: any) {
    // 恢复原状态
    row.enabled = !row.enabled
    ElMessage.error(error.message || '状态更新失败')
  } finally {
    statusLoading.value[row.id] = false
  }
}

const handleView = (row: ModelConfigDTO) => {
  currentConfig.value = row
  showDetailDialog.value = true
}

const handleEdit = (row: ModelConfigDTO) => {
  currentConfig.value = row
  dialogMode.value = 'edit'
  showCreateDialog.value = true
}

const handleEditFromDetail = (config: ModelConfigDTO) => {
  showDetailDialog.value = false
  handleEdit(config)
}

const handleTest = (row: ModelConfigDTO) => {
  currentConfig.value = row
  testResult.value = null
  showTestDialog.value = true
}

const handleTestFromDetail = (config: ModelConfigDTO) => {
  showDetailDialog.value = false
  handleTest(config)
}

const handleDelete = async (row: ModelConfigDTO) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除模型配置 "${row.configName}" 吗？删除后不可恢复。`,
      '删除确认',
      {
        type: 'warning',
        confirmButtonText: '确定删除',
        cancelButtonText: '取消'
      }
    )

    const response = await agentApi.deleteModelConfig(row.id)
    if (response.code === 200) {
      ElMessage.success('模型配置删除成功')
      fetchModelConfigs()
    }
  } catch (error: any) {
    if (error !== 'cancel') {
      ElMessage.error(error.message || '删除失败')
    }
  }
}

const handleFormSubmit = async (formData: any) => {
  try {
    if (dialogMode.value === 'create') {
      const response = await agentApi.createModelConfig(formData)
      if (response.code === 200) {
        ElMessage.success('模型配置创建成功')
        showCreateDialog.value = false
        fetchModelConfigs()
      }
    } else {
      const response = await agentApi.updateModelConfig(currentConfig.value!.id, formData)
      if (response.code === 200) {
        ElMessage.success('模型配置更新成功')
        showCreateDialog.value = false
        fetchModelConfigs()
      }
    }
  } catch (error: any) {
    ElMessage.error(error.message || '操作失败')
  }
}

const handleFormCancel = () => {
  showCreateDialog.value = false
  currentConfig.value = null
}

const handleRunTest = async () => {
  if (!testForm.message.trim()) {
    ElMessage.warning('请输入测试消息')
    return
  }

  testLoading.value = true
  testResult.value = null

  try {
    const startTime = Date.now()
    const response = await agentApi.testModelConfig(currentConfig.value!.id, {
      message: testForm.message
    })
    const endTime = Date.now()

    if (response.code === 200) {
      testResult.value = {
        success: true,
        response: response.data.response,
        responseTime: endTime - startTime,
        tokens: response.data.tokens || null
      }
    } else {
      testResult.value = {
        success: false,
        error: response.message || '测试失败'
      }
    }
  } catch (error: any) {
    testResult.value = {
      success: false,
      error: error.message || '测试失败'
    }
  } finally {
    testLoading.value = false
  }
}

// =============== 工具函数 ===============
const getPlatformTypeText = (type: PlatformType): string => {
  return platformTypeOptions.value[type] || type
}

const getPlatformTypeTagType = (type: PlatformType): string => {
  const typeMap = {
    'COZE': 'primary',
    'DIFY': 'success',
    'ALIBABA_DASHSCOPE': 'warning',
    'OPENAI': 'info',
    'CLAUDE': 'danger',
    'WENXIN_YIYAN': 'primary',
    'CUSTOM': 'info'
  }
  return typeMap[type] || 'info'
}

const formatDate = (dateString: string): string => {
  return new Date(dateString).toLocaleString('zh-CN')
}

// =============== 生命周期 ===============
onMounted(() => {
  fetchModelConfigs()
})
</script>

<style lang="scss" scoped>
.model-config-management {
  height: 100%;
  display: flex;
  flex-direction: column;

  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    padding: 0 4px;

    .header-left {
      display: flex;
      align-items: center;
      gap: 20px;

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
        gap: 12px;
      }
    }
  }

  .search-area {
    background: var(--el-bg-color);
    border: 1px solid var(--el-border-color-light);
    border-radius: 8px;
    padding: 20px;
    margin-bottom: 20px;

    .el-form {
      margin: 0;

      .el-form-item {
        margin-bottom: 0;
        margin-right: 20px;

        &:last-child {
          margin-right: 0;
        }
      }
    }
  }

  .table-container {
    flex: 1;
    background: var(--el-bg-color);
    border: 1px solid var(--el-border-color-light);
    border-radius: 8px;
    overflow: hidden;

    .model-params {
      .param-item {
        display: flex;
        justify-content: space-between;
        margin-bottom: 4px;
        font-size: 12px;

        &:last-child {
          margin-bottom: 0;
        }

        .param-label {
          color: var(--el-text-color-secondary);
          font-weight: 500;
        }

        .param-value {
          color: var(--el-text-color-primary);
        }
      }
    }

    .action-buttons {
      display: flex;
      gap: 8px;
      flex-wrap: wrap;
    }
  }

  .test-container {
    .test-form {
      margin-bottom: 20px;
    }

    .test-result {
      .result-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 12px;

        h4 {
          margin: 0;
          color: var(--el-text-color-primary);
        }
      }

      .success-result {
        .result-metrics {
          display: flex;
          gap: 20px;
          margin-bottom: 16px;
          padding: 12px;
          background: var(--el-fill-color-lighter);
          border-radius: 6px;

          .metric-item {
            display: flex;
            align-items: center;
            gap: 8px;

            .metric-label {
              color: var(--el-text-color-secondary);
              font-size: 14px;
            }

            .metric-value {
              color: var(--el-text-color-primary);
              font-weight: 500;
            }
          }
        }

        .response-content {
          h5 {
            margin: 0 0 8px 0;
            color: var(--el-text-color-primary);
          }

          .response-text {
            padding: 12px;
            background: var(--el-fill-color-lighter);
            border-radius: 6px;
            line-height: 1.6;
            color: var(--el-text-color-primary);
            white-space: pre-wrap;
            word-break: break-word;
          }
        }
      }
    }
  }
}
</style>