<template>
  <div class="account-management">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-left">
        <h2 class="page-title">
          <el-icon><User /></el-icon>
          企微账号管理
        </h2>
        <div class="header-stats">
          <StatusIndicator
            mode="simple"
            type="success"
            :text="`在线: ${stats.onlineCount}`"
          />
          <StatusIndicator
            mode="simple"
            type="danger"
            :text="`离线: ${stats.offlineCount}`"
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
          添加账号
        </el-button>
        <el-button @click="handleImport">
          <el-icon><Upload /></el-icon>
          批量导入
        </el-button>
        <el-button @click="handleExport">
          <el-icon><Download /></el-icon>
          导出
        </el-button>
      </div>
    </div>

    <!-- 搜索和过滤 -->
    <el-card shadow="never" class="filter-card">
      <div class="filter-section">
        <div class="filter-left">
          <el-input
            v-model="filters.keyword"
            placeholder="搜索账号名称、企微GUID"
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
            placeholder="账号状态"
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
            v-model="filters.groupId"
            placeholder="账号分组"
            clearable
            style="width: 120px;"
            @change="handleFilterChange"
          >
            <el-option
              v-for="group in groupOptions"
              :key="group.value"
              :label="group.label"
              :value="group.value"
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

    <!-- 账号列表 -->
    <el-card shadow="never" class="table-card">
      <DataTable
        ref="tableRef"
        :data="accountList"
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
        @refresh="loadAccounts"
      />
    </el-card>

    <!-- 创建/编辑账号弹窗 -->
    <el-dialog
      v-model="showCreateDialog"
      :title="editingAccount ? '编辑账号' : '创建账号'"
      width="600px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="formRef"
        :model="accountForm"
        :rules="formRules"
        label-width="100px"
      >
        <el-form-item label="账号名称" prop="accountName">
          <el-input v-model="accountForm.accountName" placeholder="请输入账号名称" />
        </el-form-item>
        
        <el-form-item label="企微GUID" prop="weWorkGuid">
          <el-input v-model="accountForm.weWorkGuid" placeholder="请输入企微GUID" />
        </el-form-item>
        
        <el-form-item label="手机号码" prop="phone">
          <el-input v-model="accountForm.phone" placeholder="请输入手机号码" />
        </el-form-item>
        
        <el-form-item label="代理ID" prop="proxyId">
          <el-input v-model="accountForm.proxyId" placeholder="请输入代理ID（可选）" />
        </el-form-item>
        
        <el-form-item label="回调地址" prop="callbackUrl">
          <el-input v-model="accountForm.callbackUrl" placeholder="请输入回调地址" />
        </el-form-item>
        
        <el-form-item label="账号分组" prop="groupId">
          <el-select v-model="accountForm.groupId" placeholder="选择分组" style="width: 100%;">
            <el-option
              v-for="group in groupOptions"
              :key="group.value"
              :label="group.label"
              :value="group.value"
            />
          </el-select>
        </el-form-item>
        
        <el-form-item label="自动重连" prop="autoReconnect">
          <el-switch v-model="accountForm.autoReconnect" />
        </el-form-item>
        
        <el-form-item label="监控间隔" prop="monitorInterval">
          <el-input-number
            v-model="accountForm.monitorInterval"
            :min="5"
            :max="300"
            :step="5"
            style="width: 100%;"
          /> 秒
        </el-form-item>
        
        <el-form-item label="最大重试" prop="maxRetryCount">
          <el-input-number
            v-model="accountForm.maxRetryCount"
            :min="1"
            :max="10"
            style="width: 100%;"
          />
        </el-form-item>
        
        <el-form-item label="账号标签" prop="tags">
          <el-input v-model="accountForm.tags" placeholder="输入标签，多个标签用逗号分隔" />
        </el-form-item>
      </el-form>
      
      <template #footer>
        <el-button @click="showCreateDialog = false">取消</el-button>
        <el-button type="primary" @click="handleSaveAccount" :loading="saving">
          {{ editingAccount ? '更新' : '创建' }}
        </el-button>
      </template>
    </el-dialog>

    <!-- 批量导入弹窗 -->
    <el-dialog v-model="showImportDialog" title="批量导入账号" width="500px">
      <div class="import-section">
        <el-upload
          ref="uploadRef"
          :auto-upload="false"
          :on-change="handleFileChange"
          :before-upload="beforeUpload"
          accept=".xlsx,.xls,.csv"
          drag
        >
          <el-icon class="el-icon--upload"><UploadFilled /></el-icon>
          <div class="el-upload__text">
            将文件拖到此处，或<em>点击上传</em>
          </div>
          <template #tip>
            <div class="el-upload__tip">
              只能上传 xlsx/xls/csv 文件，且不超过500KB
            </div>
          </template>
        </el-upload>
        
        <div class="import-tips">
          <h4>导入说明：</h4>
          <ul>
            <li>支持 Excel (.xlsx, .xls) 和 CSV 格式</li>
            <li>必需字段：账号名称、企微GUID</li>
            <li>可选字段：手机号码、代理ID、回调地址等</li>
            <li><el-link type="primary" @click="downloadTemplate">下载模板文件</el-link></li>
          </ul>
        </div>
      </div>
      
      <template #footer>
        <el-button @click="showImportDialog = false">取消</el-button>
        <el-button type="primary" @click="handleImportConfirm" :loading="importing">
          确认导入
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { DataTable, StatusIndicator } from '@/components/ui'
import { formatDateTime } from '@/utils/format'
import type { WeWorkAccountDetail } from '@/types'
import { getAccountList, createAccount, updateAccount, deleteAccount } from '@/api/account'
import { useTenantStore } from '@/stores/modules/tenant'

// 状态管理
const tenantStore = useTenantStore()

// 响应式数据
const loading = ref(false)
const saving = ref(false)
const importing = ref(false)
const showCreateDialog = ref(false)
const showImportDialog = ref(false)
const editingAccount = ref<WeWorkAccountDetail | null>(null)
const selectedAccounts = ref<WeWorkAccountDetail[]>([])
const tableRef = ref()
const formRef = ref()
const uploadRef = ref()

// 账号列表数据
const accountList = ref<WeWorkAccountDetail[]>([])



// 统计数据
const stats = computed(() => {
  const total = accountList.value.length
  const online = accountList.value.filter(acc => acc.status === 'ONLINE').length
  const offline = accountList.value.filter(acc => acc.status === 'OFFLINE').length
  
  return {
    totalCount: total,
    onlineCount: online,
    offlineCount: offline
  }
})

// 过滤器
const filters = reactive({
  keyword: '',
  status: '',
  groupId: ''
})

// 分页
const pagination = reactive({
  current: 1,
  size: 20,
  total: 0
})

// 表单数据
const accountForm = reactive({
  accountName: '',
  weWorkGuid: '',
  phone: '',
  proxyId: '',
  callbackUrl: '',
  groupId: '',
  autoReconnect: true,
  monitorInterval: 30,
  maxRetryCount: 3,
  tags: ''
})

// 表单验证规则
const formRules = {
  accountName: [
    { required: true, message: '请输入账号名称', trigger: 'blur' }
  ],
  weWorkGuid: [
    { required: true, message: '请输入企微GUID', trigger: 'blur' }
  ],
  phone: [
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
  ]
}

// 选项数据
const statusOptions = [
  { label: '在线', value: 'ONLINE' },
  { label: '离线', value: 'OFFLINE' },
  { label: '错误', value: 'ERROR' },
  { label: '恢复中', value: 'RECOVERING' }
]

const groupOptions = [
  { label: '客服组', value: 'customer-service' },
  { label: '销售组', value: 'sales' },
  { label: '运营组', value: 'operations' },
  { label: '测试组', value: 'test' }
]

// 表格列配置
const tableColumns = [
  {
    prop: 'accountName',
    label: '账号名称',
    minWidth: 120,
    fixed: 'left' as const
  },
  {
    prop: 'status',
    label: '状态',
    width: 80,
    type: 'status' as const,
    statusMap: {
      ONLINE: { text: '在线', type: 'success' },
      OFFLINE: { text: '离线', type: 'danger' },
      ERROR: { text: '错误', type: 'danger' },
      RECOVERING: { text: '恢复中', type: 'warning' }
    }
  },
  {
    prop: 'healthScore',
    label: '健康分数',
    width: 100,
    formatter: (row: WeWorkAccountDetail) => `${row.healthScore || 0}分`
  },
  {
    prop: 'weWorkGuid',
    label: '企微GUID',
    width: 180,
    showOverflowTooltip: true
  },
  {
    prop: 'phone',
    label: '手机号码',
    width: 120
  },
  {
    prop: 'lastHeartbeatTime',
    label: '最后心跳',
    width: 160,
    type: 'datetime' as const,
    format: 'MM-DD HH:mm:ss'
  },
  {
    prop: 'autoReconnect',
    label: '自动重连',
    width: 80,
    align: 'center' as const,
    formatter: (row: WeWorkAccountDetail) => row.autoReconnect ? '✓' : '✗'
  },
  {
    prop: 'actions',
    label: '操作',
    width: 200,
    fixed: 'right' as const,
    type: 'actions' as const,
    actions: [
      {
        key: 'edit',
        label: '编辑',
        type: 'primary' as const,
        icon: 'Edit'
      },
      {
        key: 'login',
        label: '登录',
        type: 'success' as const,
        icon: 'VideoPlay',
        hidden: (row: WeWorkAccountDetail) => row.status === 'ONLINE'
      },
      {
        key: 'logout',
        label: '下线',
        type: 'warning' as const,
        icon: 'SwitchButton',
        hidden: (row: WeWorkAccountDetail) => row.status !== 'ONLINE'
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
    key: 'batchLogin',
    label: '批量登录',
    type: 'success' as const,
    icon: 'VideoPlay'
  },
  {
    key: 'batchLogout',
    label: '批量下线',
    type: 'warning' as const,
    icon: 'SwitchButton'
  },
  {
    key: 'batchDelete',
    label: '批量删除',
    type: 'danger' as const,
    icon: 'Delete'
  }
]

// 方法
const loadAccounts = async () => {
  try {
    loading.value = true
    
    // 获取当前租户ID
    const tenantId = tenantStore.currentTenant?.id || 'tenant-001'
    
    // 调用真实API
    const response = await getAccountList({
      page: pagination.current,
      size: pagination.size,
      name: filters.keyword,
      status: filters.status,
      tenantId  // 作为额外参数传递
    } as any)
    
    if (response.code === 200) {
      accountList.value = response.data.records || []
      pagination.total = response.data.total || 0
      ElMessage.success('加载账号列表成功')
    } else {
      ElMessage.error(response.message || '加载账号列表失败')
    }
  } catch (error: any) {
    console.error('加载账号列表失败:', error)
    ElMessage.error('加载账号列表失败: ' + (error.message || '网络错误'))
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  loadAccounts()
}

const handleFilterChange = () => {
  loadAccounts()
}

const resetFilters = () => {
  Object.assign(filters, {
    keyword: '',
    status: '',
    groupId: ''
  })
  loadAccounts()
}

const handlePageChange = (page: number) => {
  pagination.current = page
  loadAccounts()
}

const handleSizeChange = (size: number) => {
  pagination.size = size
  pagination.current = 1
  loadAccounts()
}

const handleSelectionChange = (selection: WeWorkAccountDetail[]) => {
  selectedAccounts.value = selection
}

const handleAction = async (action: { key: string }, row: WeWorkAccountDetail, index: number) => {
  switch (action.key) {
    case 'edit':
      editingAccount.value = row
      Object.assign(accountForm, {
        accountName: row.accountName,
        weWorkGuid: row.weWorkGuid,
        phone: row.phone || '',
        proxyId: row.proxyId || '',
        callbackUrl: row.callbackUrl || '',
        autoReconnect: row.autoReconnect,
        monitorInterval: row.monitorInterval,
        maxRetryCount: row.maxRetryCount
      })
      showCreateDialog.value = true
      break
    case 'login':
      await handleAccountLogin(row)
      break
    case 'logout':
      await handleAccountLogout(row)
      break
    case 'delete':
      await handleDeleteAccount(row)
      break
  }
}

const handleBatchAction = async (action: string) => {
  if (selectedAccounts.value.length === 0) {
    ElMessage.warning('请选择要操作的账号')
    return
  }
  
  switch (action) {
    case 'batchLogin':
      await handleBatchLogin()
      break
    case 'batchLogout':
      await handleBatchLogout()
      break
    case 'batchDelete':
      await handleBatchDelete()
      break
  }
}

const handleSaveAccount = async () => {
  if (!formRef.value) return
  
  try {
    await formRef.value.validate()
    saving.value = true
    
    // 模拟API调用
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    if (editingAccount.value) {
      ElMessage.success('账号更新成功')
    } else {
      ElMessage.success('账号创建成功')
    }
    
    showCreateDialog.value = false
    resetForm()
    loadAccounts()
  } catch (error) {
    // 验证失败
  } finally {
    saving.value = false
  }
}

const resetForm = () => {
  editingAccount.value = null
  Object.assign(accountForm, {
    accountName: '',
    weWorkGuid: '',
    phone: '',
    proxyId: '',
    callbackUrl: '',
    groupId: '',
    autoReconnect: true,
    monitorInterval: 30,
    maxRetryCount: 3,
    tags: ''
  })
  formRef.value?.resetFields()
}

const handleAccountLogin = async (account: WeWorkAccountDetail) => {
  try {
    ElMessage.success(`正在启动账号: ${account.accountName}`)
    // 模拟API调用
    loadAccounts()
  } catch (error) {
    ElMessage.error('启动账号失败')
  }
}

const handleAccountLogout = async (account: WeWorkAccountDetail) => {
  try {
    ElMessage.success(`正在下线账号: ${account.accountName}`)
    // 模拟API调用
    loadAccounts()
  } catch (error) {
    ElMessage.error('下线账号失败')
  }
}

const handleDeleteAccount = async (account: WeWorkAccountDetail) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除账号 "${account.accountName}" 吗？此操作不可恢复。`,
      '确认删除',
      {
        type: 'warning',
        confirmButtonText: '确定删除',
        cancelButtonText: '取消'
      }
    )
    
    ElMessage.success('账号删除成功')
    loadAccounts()
  } catch (error) {
    // 用户取消
  }
}

const handleBatchLogin = async () => {
  ElMessage.success(`正在批量启动 ${selectedAccounts.value.length} 个账号`)
  loadAccounts()
}

const handleBatchLogout = async () => {
  ElMessage.success(`正在批量下线 ${selectedAccounts.value.length} 个账号`)
  loadAccounts()
}

const handleBatchDelete = async () => {
  try {
    await ElMessageBox.confirm(
      `确定要删除选中的 ${selectedAccounts.value.length} 个账号吗？此操作不可恢复。`,
      '确认批量删除',
      {
        type: 'warning',
        confirmButtonText: '确定删除',
        cancelButtonText: '取消'
      }
    )
    
    ElMessage.success('批量删除成功')
    loadAccounts()
  } catch (error) {
    // 用户取消
  }
}

const handleImport = () => {
  showImportDialog.value = true
}

const handleExport = () => {
  ElMessage.success('正在导出账号数据...')
}

const handleFileChange = (file: any) => {
  // 处理文件选择
}

const beforeUpload = (file: any) => {
  const isExcel = file.type === 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' || 
                 file.type === 'application/vnd.ms-excel' ||
                 file.type === 'text/csv'
  
  if (!isExcel) {
    ElMessage.error('只能上传 Excel 或 CSV 文件!')
    return false
  }
  
  const isLt500K = file.size / 1024 < 500
  if (!isLt500K) {
    ElMessage.error('文件大小不能超过 500KB!')
    return false
  }
  
  return true
}

const handleImportConfirm = async () => {
  try {
    importing.value = true
    // 模拟导入处理
    await new Promise(resolve => setTimeout(resolve, 2000))
    ElMessage.success('导入成功')
    showImportDialog.value = false
    loadAccounts()
  } catch (error) {
    ElMessage.error('导入失败')
  } finally {
    importing.value = false
  }
}

const downloadTemplate = () => {
  ElMessage.success('正在下载模板文件...')
}

// 生命周期
onMounted(() => {
  loadAccounts()
})
</script>

<style lang="scss" scoped>
.account-management {
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
  
  .import-section {
    .import-tips {
      margin-top: 20px;
      padding: 16px;
      background: #f8f9fa;
      border-radius: 4px;
      
      h4 {
        margin: 0 0 8px 0;
        font-size: 14px;
        color: var(--el-text-color-primary);
      }
      
      ul {
        margin: 0;
        padding-left: 20px;
        
        li {
          margin-bottom: 4px;
          font-size: 13px;
          color: var(--el-text-color-regular);
        }
      }
    }
  }
}

// 响应式适配
@media (max-width: 768px) {
  .account-management {
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