<template>
  <div class="model-config-list">
    <div class="search-area">
      <el-form :model="searchForm" inline class="search-form">
        <el-form-item label="模型名称">
          <el-input
            v-model="searchForm.modelName"
            placeholder="请输入模型名称"
            clearable
          />
        </el-form-item>
        <el-form-item label="模型类型">
          <el-select
            v-model="searchForm.modelType"
            placeholder="请选择模型类型"
            clearable
          >
            <el-option label="GPT-3.5" value="gpt-3.5-turbo" />
            <el-option label="GPT-4" value="gpt-4" />
            <el-option label="Claude" value="claude" />
            <el-option label="文心一言" value="ernie" />
            <el-option label="通义千问" value="qianwen" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select
            v-model="searchForm.status"
            placeholder="请选择状态"
            clearable
          >
            <el-option label="启用" value="enabled" />
            <el-option label="禁用" value="disabled" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon>
            搜索
          </el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <div class="action-area">
      <el-button type="primary" @click="handleCreate">
        <el-icon><Plus /></el-icon>
        新增模型配置
      </el-button>
    </div>

    <div class="table-area">
      <el-table
        :data="tableData"
        :loading="loading"
        stripe
        border
        style="width: 100%"
      >
        <el-table-column prop="name" label="模型名称" width="200" />
        <el-table-column prop="type" label="模型类型" width="150">
          <template #default="{ row }">
            <el-tag :type="getModelTypeColor(row.type)">
              {{ getModelTypeName(row.type) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="apiKey" label="API Key" width="200" show-overflow-tooltip>
          <template #default="{ row }">
            {{ maskApiKey(row.apiKey) }}
          </template>
        </el-table-column>
        <el-table-column prop="baseUrl" label="API地址" width="250" show-overflow-tooltip />
        <el-table-column prop="maxTokens" label="最大Token" width="120" />
        <el-table-column prop="temperature" label="Temperature" width="120" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-switch
              v-model="row.status"
              active-value="enabled"
              inactive-value="disabled"
              @change="handleStatusChange(row)"
            />
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="创建时间" width="180" />
        <el-table-column label="操作" fixed="right" width="200">
          <template #default="{ row }">
            <el-button size="small" type="primary" link @click="handleEdit(row)">
              编辑
            </el-button>
            <el-button size="small" type="success" link @click="handleTest(row)">
              测试
            </el-button>
            <el-button size="small" type="danger" link @click="handleDelete(row)">
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination-area">
        <el-pagination
          v-model:current-page="pagination.pageNum"
          v-model:page-size="pagination.pageSize"
          :total="pagination.total"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handlePageChange"
        />
      </div>
    </div>

    <!-- 配置对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogMode === 'create' ? '新增模型配置' : '编辑模型配置'"
      width="600px"
    >
      <el-form
        ref="formRef"
        :model="formData"
        :rules="formRules"
        label-width="120px"
      >
        <el-form-item label="模型名称" prop="name">
          <el-input v-model="formData.name" placeholder="请输入模型名称" />
        </el-form-item>
        <el-form-item label="模型类型" prop="type">
          <el-select v-model="formData.type" placeholder="请选择模型类型">
            <el-option label="GPT-3.5" value="gpt-3.5-turbo" />
            <el-option label="GPT-4" value="gpt-4" />
            <el-option label="Claude" value="claude" />
            <el-option label="文心一言" value="ernie" />
            <el-option label="通义千问" value="qianwen" />
          </el-select>
        </el-form-item>
        <el-form-item label="API Key" prop="apiKey">
          <el-input
            v-model="formData.apiKey"
            type="password"
            placeholder="请输入API Key"
            show-password
          />
        </el-form-item>
        <el-form-item label="API地址" prop="baseUrl">
          <el-input v-model="formData.baseUrl" placeholder="请输入API地址" />
        </el-form-item>
        <el-form-item label="最大Token" prop="maxTokens">
          <el-input-number
            v-model="formData.maxTokens"
            :min="1"
            :max="32000"
            placeholder="最大Token数量"
          />
        </el-form-item>
        <el-form-item label="Temperature" prop="temperature">
          <el-input-number
            v-model="formData.temperature"
            :min="0"
            :max="2"
            :step="0.1"
            placeholder="创造性参数"
          />
        </el-form-item>
        <el-form-item label="描述">
          <el-input
            v-model="formData.description"
            type="textarea"
            :rows="3"
            placeholder="请输入模型描述"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitting">
          确定
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search, Plus } from '@element-plus/icons-vue'

// 响应式数据
const loading = ref(false)
const submitting = ref(false)
const tableData = ref([])
const dialogVisible = ref(false)
const dialogMode = ref<'create' | 'edit'>('create')
const formRef = ref()

// 搜索表单
const searchForm = reactive({
  modelName: '',
  modelType: '',
  status: ''
})

// 分页
const pagination = reactive({
  pageNum: 1,
  pageSize: 20,
  total: 0
})

// 表单数据
const formData = reactive({
  id: '',
  name: '',
  type: '',
  apiKey: '',
  baseUrl: '',
  maxTokens: 4000,
  temperature: 0.7,
  description: ''
})

// 表单验证规则
const formRules = {
  name: [{ required: true, message: '请输入模型名称', trigger: 'blur' }],
  type: [{ required: true, message: '请选择模型类型', trigger: 'change' }],
  apiKey: [{ required: true, message: '请输入API Key', trigger: 'blur' }],
  baseUrl: [{ required: true, message: '请输入API地址', trigger: 'blur' }],
  maxTokens: [{ required: true, message: '请输入最大Token数量', trigger: 'blur' }],
  temperature: [{ required: true, message: '请输入Temperature值', trigger: 'blur' }]
}

// 方法
const handleSearch = () => {
  pagination.pageNum = 1
  fetchModelConfigs()
}

const handleReset = () => {
  searchForm.modelName = ''
  searchForm.modelType = ''
  searchForm.status = ''
  pagination.pageNum = 1
  fetchModelConfigs()
}

const handleCreate = () => {
  dialogMode.value = 'create'
  resetForm()
  dialogVisible.value = true
}

const handleEdit = (row: any) => {
  dialogMode.value = 'edit'
  Object.assign(formData, row)
  dialogVisible.value = true
}

const handleDelete = async (row: any) => {
  try {
    await ElMessageBox.confirm(`确定要删除模型配置 "${row.name}" 吗？`, '删除确认', {
      type: 'warning'
    })
    ElMessage.success('删除成功')
    fetchModelConfigs()
  } catch (error) {
    // 用户取消
  }
}

const handleTest = async (row: any) => {
  loading.value = true
  try {
    // 模拟测试API
    setTimeout(() => {
      ElMessage.success('模型测试连接成功')
      loading.value = false
    }, 2000)
  } catch (error) {
    ElMessage.error('模型测试连接失败')
    loading.value = false
  }
}

const handleStatusChange = async (row: any) => {
  try {
    ElMessage.success(`模型配置已${row.status === 'enabled' ? '启用' : '禁用'}`)
  } catch (error) {
    ElMessage.error('状态修改失败')
    // 回滚状态
    row.status = row.status === 'enabled' ? 'disabled' : 'enabled'
  }
}

const handleSubmit = async () => {
  try {
    await formRef.value.validate()
    submitting.value = true
    
    // 模拟提交
    setTimeout(() => {
      ElMessage.success(dialogMode.value === 'create' ? '创建成功' : '更新成功')
      dialogVisible.value = false
      submitting.value = false
      fetchModelConfigs()
    }, 1000)
  } catch (error) {
    console.error('表单验证失败:', error)
  }
}

const resetForm = () => {
  formData.id = ''
  formData.name = ''
  formData.type = ''
  formData.apiKey = ''
  formData.baseUrl = ''
  formData.maxTokens = 4000
  formData.temperature = 0.7
  formData.description = ''
}

const handlePageChange = (page: number) => {
  pagination.pageNum = page
  fetchModelConfigs()
}

const handleSizeChange = (size: number) => {
  pagination.pageSize = size
  pagination.pageNum = 1
  fetchModelConfigs()
}

const getModelTypeName = (type: string) => {
  const typeMap: Record<string, string> = {
    'gpt-3.5-turbo': 'GPT-3.5',
    'gpt-4': 'GPT-4',
    'claude': 'Claude',
    'ernie': '文心一言',
    'qianwen': '通义千问'
  }
  return typeMap[type] || type
}

const getModelTypeColor = (type: string) => {
  const colorMap: Record<string, string> = {
    'gpt-3.5-turbo': 'success',
    'gpt-4': 'warning',
    'claude': 'primary',
    'ernie': 'info',
    'qianwen': 'danger'
  }
  return colorMap[type] || 'info'
}

const maskApiKey = (apiKey: string) => {
  if (!apiKey) return ''
  if (apiKey.length <= 8) return apiKey
  return `${apiKey.substring(0, 4)}****${apiKey.substring(apiKey.length - 4)}`
}

const fetchModelConfigs = async () => {
  loading.value = true
  try {
    // 模拟数据
    setTimeout(() => {
      tableData.value = [
        {
          id: '1',
          name: 'GPT-3.5 生产环境',
          type: 'gpt-3.5-turbo',
          apiKey: 'sk-1234567890abcdef1234567890abcdef',
          baseUrl: 'https://api.openai.com/v1',
          maxTokens: 4000,
          temperature: 0.7,
          status: 'enabled',
          description: '生产环境使用的GPT-3.5模型',
          createdAt: '2024-01-01 10:00:00'
        }
      ] as any
      pagination.total = 1
      loading.value = false
    }, 1000)
  } catch (error) {
    ElMessage.error('获取模型配置失败')
    loading.value = false
  }
}

// 生命周期
onMounted(() => {
  fetchModelConfigs()
})
</script>

<style lang="scss" scoped>
.model-config-list {
  padding: 20px;

  .search-area {
    margin-bottom: 20px;
    padding: 20px;
    background: #fff;
    border-radius: 4px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);

    .search-form {
      .el-form-item {
        margin-right: 20px;
        margin-bottom: 10px;
      }
    }
  }

  .action-area {
    margin-bottom: 20px;
  }

  .table-area {
    background: #fff;
    padding: 20px;
    border-radius: 4px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);

    .pagination-area {
      margin-top: 20px;
      text-align: right;
    }
  }
}
</style>