<template>
  <div class="account-management">
    <!-- 页面头部 -->
    <div class="page-header">
      <h2 class="page-title">
        <el-icon><User /></el-icon>
        企微账号管理
      </h2>
      
      <div class="header-actions">
        <el-button type="primary" @click="showCreateDialog = true">
          <el-icon><Plus /></el-icon>
          添加账号
        </el-button>
      </div>
    </div>

    <!-- 搜索区域 -->
    <el-card shadow="never" class="filter-card">
      <div class="filter-section">
        <el-input
          v-model="searchKeyword"
          placeholder="搜索账号名称、企微GUID"
          style="width: 300px;"
          clearable
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
        
        <el-select v-model="statusFilter" placeholder="状态" clearable style="width: 120px;">
          <el-option label="在线" value="ONLINE" />
          <el-option label="离线" value="OFFLINE" />
          <el-option label="错误" value="ERROR" />
        </el-select>
      </div>
    </el-card>

    <!-- 账号列表 -->
    <el-card shadow="never" class="table-card">
      <el-table :data="filteredAccounts" v-loading="loading">
        <el-table-column prop="accountName" label="账号名称" min-width="120" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.status)">
              {{ getStatusText(row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="weWorkGuid" label="企微GUID" width="180" show-overflow-tooltip />
        <el-table-column prop="phone" label="手机号码" width="120" />
        <el-table-column prop="healthScore" label="健康分数" width="100">
          <template #default="{ row }">
            {{ row.healthScore || 0 }}分
          </template>
        </el-table-column>
        <el-table-column prop="autoReconnect" label="自动重连" width="80">
          <template #default="{ row }">
            {{ row.autoReconnect ? '✓' : '✗' }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="handleEdit(row)">编辑</el-button>
            <el-button size="small" type="success" @click="handleStart(row)" v-if="row.status !== 'ONLINE'">启动</el-button>
            <el-button size="small" type="warning" @click="handleStop(row)" v-if="row.status === 'ONLINE'">停止</el-button>
            <el-button size="small" type="danger" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 创建/编辑弹窗 -->
    <el-dialog
      v-model="showCreateDialog"
      :title="editingAccount ? '编辑账号' : '创建账号'"
      width="600px"
    >
      <el-form ref="formRef" :model="accountForm" label-width="100px">
        <el-form-item label="账号名称" required>
          <el-input v-model="accountForm.accountName" placeholder="请输入账号名称" />
        </el-form-item>
        
        <el-form-item label="企微GUID" required>
          <el-input v-model="accountForm.weWorkGuid" placeholder="请输入企微GUID" />
        </el-form-item>
        
        <el-form-item label="手机号码">
          <el-input v-model="accountForm.phone" placeholder="请输入手机号码" />
        </el-form-item>
        
        <el-form-item label="自动重连">
          <el-switch v-model="accountForm.autoReconnect" />
        </el-form-item>
      </el-form>
      
      <template #footer>
        <el-button @click="showCreateDialog = false">取消</el-button>
        <el-button type="primary" @click="handleSave" :loading="saving">
          {{ editingAccount ? '更新' : '创建' }}
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, reactive } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'

// 定义账号接口
interface Account {
  id: string
  accountName: string
  weWorkGuid: string
  phone?: string
  status: 'ONLINE' | 'OFFLINE' | 'ERROR'
  healthScore: number
  autoReconnect: boolean
}

// 响应式数据
const loading = ref(false)
const saving = ref(false)
const showCreateDialog = ref(false)
const searchKeyword = ref('')
const statusFilter = ref('')
const editingAccount = ref<Account | null>(null)

// 表单数据
const accountForm = reactive({
  accountName: '',
  weWorkGuid: '',
  phone: '',
  autoReconnect: true
})

// 模拟账号数据
const accountList = ref<Account[]>([
  {
    id: '1',
    accountName: '客服01',
    weWorkGuid: 'wx123456789abcdef',
    phone: '13800138001',
    status: 'ONLINE',
    healthScore: 95,
    autoReconnect: true
  },
  {
    id: '2',
    accountName: '销售02',
    weWorkGuid: 'wx987654321fedcba',
    phone: '13800138002',
    status: 'OFFLINE',
    healthScore: 72,
    autoReconnect: false
  }
])

// 计算属性 - 过滤后的账号列表
const filteredAccounts = computed(() => {
  let result = accountList.value
  
  if (searchKeyword.value) {
    result = result.filter(account => 
      account.accountName.includes(searchKeyword.value) ||
      account.weWorkGuid.includes(searchKeyword.value)
    )
  }
  
  if (statusFilter.value) {
    result = result.filter(account => account.status === statusFilter.value)
  }
  
  return result
})

// 状态相关方法
const getStatusType = (status: string) => {
  const statusMap = {
    'ONLINE': 'success',
    'OFFLINE': 'danger',
    'ERROR': 'danger'
  }
  return statusMap[status] || 'info'
}

const getStatusText = (status: string) => {
  const statusMap = {
    'ONLINE': '在线',
    'OFFLINE': '离线',
    'ERROR': '错误'
  }
  return statusMap[status] || status
}

// 操作方法
const handleEdit = (account: Account) => {
  editingAccount.value = account
  Object.assign(accountForm, {
    accountName: account.accountName,
    weWorkGuid: account.weWorkGuid,
    phone: account.phone || '',
    autoReconnect: account.autoReconnect
  })
  showCreateDialog.value = true
}

const handleStart = async (account: Account) => {
  try {
    loading.value = true
    // 模拟API调用
    await new Promise(resolve => setTimeout(resolve, 1000))
    account.status = 'ONLINE'
    ElMessage.success(`账号 ${account.accountName} 启动成功`)
  } catch (error) {
    ElMessage.error('启动失败')
  } finally {
    loading.value = false
  }
}

const handleStop = async (account: Account) => {
  try {
    loading.value = true
    // 模拟API调用
    await new Promise(resolve => setTimeout(resolve, 1000))
    account.status = 'OFFLINE'
    ElMessage.success(`账号 ${account.accountName} 停止成功`)
  } catch (error) {
    ElMessage.error('停止失败')
  } finally {
    loading.value = false
  }
}

const handleDelete = async (account: Account) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除账号 "${account.accountName}" 吗？`,
      '确认删除',
      { type: 'warning' }
    )
    
    const index = accountList.value.findIndex(item => item.id === account.id)
    if (index > -1) {
      accountList.value.splice(index, 1)
      ElMessage.success('删除成功')
    }
  } catch (error) {
    // 用户取消
  }
}

const handleSave = async () => {
  try {
    saving.value = true
    // 模拟API调用
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    if (editingAccount.value) {
      // 更新现有账号
      Object.assign(editingAccount.value, accountForm)
      ElMessage.success('更新成功')
    } else {
      // 创建新账号
      const newAccount: Account = {
        id: Date.now().toString(),
        accountName: accountForm.accountName,
        weWorkGuid: accountForm.weWorkGuid,
        phone: accountForm.phone,
        status: 'OFFLINE',
        healthScore: 100,
        autoReconnect: accountForm.autoReconnect
      }
      accountList.value.push(newAccount)
      ElMessage.success('创建成功')
    }
    
    showCreateDialog.value = false
    resetForm()
  } catch (error) {
    ElMessage.error('保存失败')
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
    autoReconnect: true
  })
}
</script>

<style lang="scss" scoped>
.account-management {
  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    
    .page-title {
      display: flex;
      align-items: center;
      gap: 8px;
      margin: 0;
      font-size: 20px;
      font-weight: 600;
    }
  }
  
  .filter-card {
    margin-bottom: 20px;
    
    .filter-section {
      display: flex;
      gap: 12px;
      align-items: center;
    }
  }
  
  .table-card {
    :deep(.el-card__body) {
      padding: 0;
    }
  }
}

@media (max-width: 768px) {
  .account-management {
    .page-header {
      flex-direction: column;
      gap: 16px;
      align-items: stretch;
    }
    
    .filter-section {
      flex-direction: column;
      align-items: stretch;
    }
  }
}
</style>