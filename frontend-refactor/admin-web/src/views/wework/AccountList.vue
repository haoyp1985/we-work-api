<template>
  <div class="wework-account-list">
    <!-- 搜索栏 -->
    <div class="search-bar">
      <el-card shadow="never">
        <el-form :model="searchForm" inline>
          <el-form-item label="关键词">
            <el-input
              v-model="searchForm.keyword"
              placeholder="请输入账号名称或CorpID"
              clearable
              style="width: 200px"
              @keyup.enter="handleSearch"
            />
          </el-form-item>
          <el-form-item label="状态">
            <el-select
              v-model="searchForm.status"
              placeholder="请选择状态"
              clearable
              style="width: 120px"
            >
              <el-option label="活跃" :value="1" />
              <el-option label="非活跃" :value="2" />
              <el-option label="已过期" :value="3" />
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
    </div>

    <!-- 工具栏 -->
    <div class="toolbar">
      <div class="toolbar-left">
        <el-button type="primary" :icon="Plus" @click="handleCreate">
          添加账号
        </el-button>
        <el-button 
          type="success" 
          :icon="Connection"
          :disabled="!selectedAccounts.length"
          @click="handleBatchLogin"
        >
          批量登录
        </el-button>
        <el-button 
          type="warning" 
          :icon="SwitchButton"
          :disabled="!selectedAccounts.length"
          @click="handleBatchLogout"
        >
          批量登出
        </el-button>
        <el-button 
          type="danger" 
          :icon="Delete"
          :disabled="!selectedAccounts.length"
          @click="handleBatchDelete"
        >
          批量删除
        </el-button>
      </div>
      <div class="toolbar-right">
        <el-button :icon="Upload" @click="handleImport">
          导入配置
        </el-button>
        <el-button :icon="Download" @click="handleExport">
          导出配置
        </el-button>
      </div>
    </div>

    <!-- 表格 -->
    <el-card shadow="never">
      <el-table
        v-loading="loading"
        :data="tableData"
        @selection-change="handleSelectionChange"
        stripe
        style="width: 100%"
      >
        <el-table-column type="selection" width="55" />
        
        <el-table-column prop="name" label="账号名称" min-width="150">
          <template #default="{ row }">
            <div class="account-info">
              <el-avatar :src="row.avatar" :size="32">
                {{ row.name?.charAt(0) }}
              </el-avatar>
              <div class="account-details">
                <div class="account-name">{{ row.name }}</div>
                <div class="account-corp">{{ row.corpId }}</div>
              </div>
            </div>
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

        <el-table-column prop="isOnline" label="在线状态" width="100">
          <template #default="{ row }">
            <el-tag 
              :type="row.isOnline ? 'success' : 'info'"
              size="small"
            >
              <el-icon><Dot /></el-icon>
              {{ row.isOnline ? '在线' : '离线' }}
            </el-tag>
          </template>
        </el-table-column>

        <el-table-column prop="contactCount" label="联系人" width="80">
          <template #default="{ row }">
            <span class="stat-number">{{ row.contactCount || 0 }}</span>
          </template>
        </el-table-column>

        <el-table-column prop="groupCount" label="群聊" width="80">
          <template #default="{ row }">
            <span class="stat-number">{{ row.groupCount || 0 }}</span>
          </template>
        </el-table-column>

        <el-table-column prop="lastLoginTime" label="最后登录" min-width="160">
          <template #default="{ row }">
            <span class="time-text">
              {{ row.lastLoginTime ? formatTime(row.lastLoginTime) : '从未登录' }}
            </span>
          </template>
        </el-table-column>

        <el-table-column prop="description" label="描述" min-width="120" show-overflow-tooltip />

        <el-table-column label="操作" width="220" fixed="right">
          <template #default="{ row }">
            <div class="action-buttons">
              <el-button 
                v-if="!row.isOnline"
                type="primary" 
                size="small"
                :icon="Connection"
                @click="handleLogin(row)"
              >
                登录
              </el-button>
              <el-button 
                v-else
                type="warning" 
                size="small"
                :icon="SwitchButton"
                @click="handleLogout(row)"
              >
                登出
              </el-button>
              <el-button 
                type="info" 
                size="small"
                :icon="View"
                @click="handleView(row)"
              >
                详情
              </el-button>
              <el-dropdown @command="(cmd) => handleDropdownCommand(cmd, row)">
                <el-button type="info" size="small" :icon="More" />
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item command="edit" :icon="Edit">
                      编辑
                    </el-dropdown-item>
                    <el-dropdown-item command="restart" :icon="Refresh">
                      重启
                    </el-dropdown-item>
                    <el-dropdown-item command="stats" :icon="DataBoard">
                      统计
                    </el-dropdown-item>
                    <el-dropdown-item command="logs" :icon="Document">
                      日志
                    </el-dropdown-item>
                    <el-dropdown-item 
                      command="delete" 
                      :icon="Delete"
                      divided
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
      <div class="pagination-wrapper">
        <el-pagination
          v-model:current-page="pagination.pageNum"
          v-model:page-size="pagination.pageSize"
          :total="pagination.total"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>

    <!-- 账号详情对话框 -->
    <el-dialog
      v-model="detailDialogVisible"
      title="账号详情"
      width="800px"
      destroy-on-close
    >
      <WeWorkAccountDetail 
        v-if="detailDialogVisible"
        :account-id="currentAccountId"
        @refresh="loadData"
      />
    </el-dialog>

    <!-- 创建/编辑账号对话框 -->
    <el-dialog
      v-model="formDialogVisible"
      :title="formMode === 'create' ? '添加账号' : '编辑账号'"
      width="600px"
      destroy-on-close
    >
      <WeWorkAccountForm 
        v-if="formDialogVisible"
        :mode="formMode"
        :account-id="currentAccountId"
        @success="handleFormSuccess"
        @cancel="formDialogVisible = false"
      />
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { 
  Search, 
  Refresh, 
  Plus,
  Connection,
  SwitchButton,
  Delete,
  Upload,
  Download,
  View,
  Edit,
  More,
  DataBoard,
  Document,
  Dot
} from '@element-plus/icons-vue'
import * as weworkApi from '@/api/wework-account'
import type { WeWorkAccount, AccountQuery } from '@/api/wework-account'
import WeWorkAccountDetail from './components/WeWorkAccountDetail.vue'
import WeWorkAccountForm from './components/WeWorkAccountForm.vue'

// 响应式数据
const loading = ref(false)
const tableData = ref<WeWorkAccount[]>([])
const selectedAccounts = ref<WeWorkAccount[]>([])

// 搜索表单
const searchForm = reactive<AccountQuery>({
  keyword: '',
  status: undefined
})

// 分页信息
const pagination = reactive({
  pageNum: 1,
  pageSize: 20,
  total: 0
})

// 对话框状态
const detailDialogVisible = ref(false)
const formDialogVisible = ref(false)
const formMode = ref<'create' | 'edit'>('create')
const currentAccountId = ref('')

// 获取状态标签类型
const getStatusType = (status: string) => {
  const typeMap = {
    'active': 'success',
    'inactive': 'warning',
    'expired': 'danger'
  }
  return typeMap[status] || 'info'
}

// 获取状态文本
const getStatusText = (status: string) => {
  const textMap = {
    'active': '活跃',
    'inactive': '非活跃',
    'expired': '已过期'
  }
  return textMap[status] || status
}

// 格式化时间
const formatTime = (timeStr: string): string => {
  return new Date(timeStr).toLocaleString()
}

// 加载数据
const loadData = async () => {
  loading.value = true
  try {
    const params = {
      ...searchForm,
      pageNum: pagination.pageNum,
      pageSize: pagination.pageSize
    }
    
    const response = await weworkApi.getAccountList(params)
    tableData.value = response.data.records || response.data.items || []
    pagination.total = response.data.total || 0
  } catch (error) {
    console.error('加载账号列表失败:', error)
    ElMessage.error('加载账号列表失败')
  } finally {
    loading.value = false
  }
}

// 搜索
const handleSearch = () => {
  pagination.pageNum = 1
  loadData()
}

// 重置
const handleReset = () => {
  Object.assign(searchForm, {
    keyword: '',
    status: undefined
  })
  pagination.pageNum = 1
  loadData()
}

// 分页变化
const handleSizeChange = (size: number) => {
  pagination.pageSize = size
  pagination.pageNum = 1
  loadData()
}

const handleCurrentChange = (page: number) => {
  pagination.pageNum = page
  loadData()
}

// 选择变化
const handleSelectionChange = (selection: WeWorkAccount[]) => {
  selectedAccounts.value = selection
}

// 创建账号
const handleCreate = () => {
  formMode.value = 'create'
  currentAccountId.value = ''
  formDialogVisible.value = true
}

// 查看详情
const handleView = (account: WeWorkAccount) => {
  currentAccountId.value = account.id
  detailDialogVisible.value = true
}

// 登录账号
const handleLogin = async (account: WeWorkAccount) => {
  try {
    const response = await weworkApi.loginAccount(account.id)
    ElMessage.success('登录请求已发送，请扫描二维码')
    // 可以显示二维码对话框
    loadData()
  } catch (error) {
    console.error('登录失败:', error)
    ElMessage.error('登录失败')
  }
}

// 登出账号
const handleLogout = async (account: WeWorkAccount) => {
  try {
    await weworkApi.logoutAccount(account.id)
    ElMessage.success('账号已登出')
    loadData()
  } catch (error) {
    console.error('登出失败:', error)
    ElMessage.error('登出失败')
  }
}

// 下拉菜单命令
const handleDropdownCommand = (command: string, account: WeWorkAccount) => {
  switch (command) {
    case 'edit':
      formMode.value = 'edit'
      currentAccountId.value = account.id
      formDialogVisible.value = true
      break
    case 'restart':
      handleRestart(account)
      break
    case 'stats':
      handleViewStats(account)
      break
    case 'logs':
      handleViewLogs(account)
      break
    case 'delete':
      handleDelete(account)
      break
  }
}

// 重启账号
const handleRestart = async (account: WeWorkAccount) => {
  try {
    await ElMessageBox.confirm(
      `确定要重启账号 "${account.name}" 吗？`,
      '确认重启',
      { type: 'warning' }
    )
    
    await weworkApi.restartAccount(account.id)
    ElMessage.success('账号重启成功')
    loadData()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('重启失败:', error)
      ElMessage.error('重启失败')
    }
  }
}

// 查看统计
const handleViewStats = (account: WeWorkAccount) => {
  // TODO: 实现统计页面
  ElMessage.info('统计功能开发中')
}

// 查看日志
const handleViewLogs = (account: WeWorkAccount) => {
  // TODO: 实现日志页面
  ElMessage.info('日志功能开发中')
}

// 删除账号
const handleDelete = async (account: WeWorkAccount) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除账号 "${account.name}" 吗？此操作不可恢复！`,
      '确认删除',
      { type: 'warning' }
    )
    
    await weworkApi.deleteAccount(account.id)
    ElMessage.success('删除成功')
    loadData()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除失败:', error)
      ElMessage.error('删除失败')
    }
  }
}

// 批量操作
const handleBatchLogin = async () => {
  try {
    const accountIds = selectedAccounts.value.map(account => account.id)
    await weworkApi.batchAccountOperation({
      accountIds,
      operation: 'login'
    })
    ElMessage.success('批量登录操作已发送')
    loadData()
  } catch (error) {
    console.error('批量登录失败:', error)
    ElMessage.error('批量登录失败')
  }
}

const handleBatchLogout = async () => {
  try {
    const accountIds = selectedAccounts.value.map(account => account.id)
    await weworkApi.batchAccountOperation({
      accountIds,
      operation: 'logout'
    })
    ElMessage.success('批量登出成功')
    loadData()
  } catch (error) {
    console.error('批量登出失败:', error)
    ElMessage.error('批量登出失败')
  }
}

const handleBatchDelete = async () => {
  try {
    await ElMessageBox.confirm(
      `确定要删除选中的 ${selectedAccounts.value.length} 个账号吗？此操作不可恢复！`,
      '确认批量删除',
      { type: 'warning' }
    )
    
    const accountIds = selectedAccounts.value.map(account => account.id)
    await weworkApi.batchAccountOperation({
      accountIds,
      operation: 'delete'
    })
    ElMessage.success('批量删除成功')
    loadData()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('批量删除失败:', error)
      ElMessage.error('批量删除失败')
    }
  }
}

// 导入导出
const handleImport = () => {
  // TODO: 实现导入功能
  ElMessage.info('导入功能开发中')
}

const handleExport = () => {
  // TODO: 实现导出功能
  ElMessage.info('导出功能开发中')
}

// 表单成功回调
const handleFormSuccess = () => {
  formDialogVisible.value = false
  loadData()
}

// 页面加载
onMounted(() => {
  loadData()
})
</script>

<style scoped lang="scss">
.wework-account-list {
  .search-bar {
    margin-bottom: 16px;
  }

  .toolbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;

    .toolbar-left,
    .toolbar-right {
      display: flex;
      gap: 8px;
    }
  }

  .account-info {
    display: flex;
    align-items: center;
    gap: 12px;

    .account-details {
      flex: 1;

      .account-name {
        font-weight: 500;
        color: #1f2329;
        margin-bottom: 2px;
      }

      .account-corp {
        font-size: 12px;
        color: #86909c;
      }
    }
  }

  .stat-number {
    font-weight: 500;
    color: #1f2329;
  }

  .time-text {
    font-size: 12px;
    color: #4e5969;
  }

  .action-buttons {
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .pagination-wrapper {
    display: flex;
    justify-content: center;
    margin-top: 20px;
  }
}
</style>