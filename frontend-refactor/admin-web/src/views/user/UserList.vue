<template>
  <div class="user-list">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-title">
        <h1>用户管理</h1>
        <p>管理系统用户、角色权限和组织架构</p>
      </div>
      <div class="header-actions">
        <el-button 
          type="primary" 
          :icon="Plus"
          @click="handleCreate"
        >
          新增用户
        </el-button>
        <el-button 
          :icon="Upload"
          @click="handleImport"
        >
          导入用户
        </el-button>
        <el-button 
          :icon="Download"
          @click="handleExport"
        >
          导出用户
        </el-button>
      </div>
    </div>

    <!-- 搜索过滤区域 -->
    <el-card class="search-card" shadow="never">
      <el-form 
        :model="searchForm" 
        :inline="true" 
        label-width="80px"
        @submit.prevent
      >
        <el-form-item label="关键词">
          <el-input
            v-model="searchForm.keyword"
            placeholder="用户名、姓名、邮箱"
            :prefix-icon="Search"
            clearable
            style="width: 200px"
            @keyup.enter="handleSearch"
          />
        </el-form-item>
        
        <el-form-item label="状态">
          <el-select 
            v-model="searchForm.status" 
            placeholder="选择状态" 
            clearable
            style="width: 120px"
          >
            <el-option label="正常" value="ACTIVE" />
            <el-option label="禁用" value="DISABLED" />
            <el-option label="锁定" value="LOCKED" />
            <el-option label="待激活" value="PENDING" />
          </el-select>
        </el-form-item>
        
        <el-form-item label="角色">
          <el-select 
            v-model="searchForm.roleId" 
            placeholder="选择角色" 
            clearable
            style="width: 150px"
          >
            <el-option 
              v-for="role in roleOptions" 
              :key="role.id" 
              :label="role.name" 
              :value="role.id" 
            />
          </el-select>
        </el-form-item>
        
        <el-form-item label="部门">
          <el-tree-select
            v-model="searchForm.departmentId"
            :data="departmentTree"
            :render-after-expand="false"
            :check-strictly="true"
            placeholder="选择部门"
            clearable
            style="width: 200px"
            :props="{
              value: 'id',
              label: 'name',
              children: 'children'
            }"
          />
        </el-form-item>
        
        <el-form-item label="创建时间">
          <el-date-picker
            v-model="searchForm.createdDateRange"
            type="daterange"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            style="width: 220px"
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
            <span>用户列表</span>
            <el-tag type="info" size="small">共 {{ pagination.total }} 条</el-tag>
          </div>
          <div class="table-actions">
            <el-button 
              v-if="selectedUsers.length > 0"
              type="danger" 
              size="small"
              :icon="Delete"
              @click="handleBatchDelete"
            >
              批量删除 ({{ selectedUsers.length }})
            </el-button>
            <el-button 
              v-if="selectedUsers.length > 0"
              size="small"
              @click="handleBatchExport"
            >
              批量导出
            </el-button>
            <el-button 
              size="small" 
              :icon="Refresh"
              @click="loadData"
              :loading="loading"
            >
              刷新
            </el-button>
          </div>
        </div>
      </template>

      <el-table 
        :data="userList" 
        :loading="loading"
        @selection-change="handleSelectionChange"
        style="width: 100%"
      >
        <el-table-column type="selection" width="50" />
        
        <el-table-column label="用户信息" min-width="200" fixed="left">
          <template #default="{ row }">
            <div class="user-info">
              <el-avatar 
                :src="row.avatar" 
                :size="40"
                style="margin-right: 12px"
              >
                {{ row.realName?.charAt(0) || row.username?.charAt(0) }}
              </el-avatar>
              <div class="user-details">
                <div class="user-name">{{ row.realName || row.username }}</div>
                <div class="user-username">@{{ row.username }}</div>
              </div>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column label="联系方式" width="200">
          <template #default="{ row }">
            <div class="contact-info">
              <div v-if="row.email" class="contact-item">
                <el-icon><Message /></el-icon>
                <span>{{ row.email }}</span>
              </div>
              <div v-if="row.phone" class="contact-item">
                <el-icon><Phone /></el-icon>
                <span>{{ row.phone }}</span>
              </div>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column label="角色" width="150">
          <template #default="{ row }">
            <div class="roles">
              <el-tag 
                v-for="role in row.roles?.slice(0, 2)" 
                :key="role.id"
                size="small"
                type="primary"
                style="margin-right: 4px; margin-bottom: 4px"
              >
                {{ role.name }}
              </el-tag>
              <el-tag 
                v-if="row.roles?.length > 2"
                size="small"
                type="info"
              >
                +{{ row.roles.length - 2 }}
              </el-tag>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column label="部门" prop="departmentName" width="120" />
        
        <el-table-column label="状态" width="100" align="center">
          <template #default="{ row }">
            <el-tag 
              :type="getUserStatusType(row.status)" 
              size="small"
            >
              {{ getUserStatusText(row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        
        <el-table-column label="最后登录" width="160">
          <template #default="{ row }">
            <div v-if="row.lastLoginAt" class="login-info">
              <div class="login-time">{{ formatTime(row.lastLoginAt) }}</div>
              <div v-if="row.lastLoginIp" class="login-ip">{{ row.lastLoginIp }}</div>
            </div>
            <span v-else class="text-gray">从未登录</span>
          </template>
        </el-table-column>
        
        <el-table-column label="创建时间" prop="createdAt" width="160">
          <template #default="{ row }">
            {{ formatDateTime(row.createdAt) }}
          </template>
        </el-table-column>
        
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <div class="action-buttons">
              <el-button 
                type="primary" 
                size="small" 
                link
                @click="handleView(row)"
              >
                查看
              </el-button>
              <el-button 
                type="primary" 
                size="small" 
                link
                @click="handleEdit(row)"
              >
                编辑
              </el-button>
              <el-dropdown @command="(command) => handleAction(command, row)">
                <el-button size="small" link>
                  更多 <el-icon><ArrowDown /></el-icon>
                </el-button>
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item command="resetPassword" :icon="Key">
                      重置密码
                    </el-dropdown-item>
                    <el-dropdown-item 
                      :command="row.status === 'ACTIVE' ? 'disable' : 'enable'"
                      :icon="row.status === 'ACTIVE' ? Lock : Unlock"
                    >
                      {{ row.status === 'ACTIVE' ? '禁用' : '启用' }}
                    </el-dropdown-item>
                    <el-dropdown-item 
                      v-if="row.status === 'LOCKED'"
                      command="unlock" 
                      :icon="Unlock"
                    >
                      解锁
                    </el-dropdown-item>
                    <el-dropdown-item command="forceLogout" :icon="SwitchButton">
                      强制下线
                    </el-dropdown-item>
                    <el-dropdown-item command="viewLogs" :icon="Document">
                      查看日志
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

      <!-- 分页组件 -->
      <div class="pagination-wrapper">
        <el-pagination
          v-model:current-page="pagination.current"
          v-model:page-size="pagination.size"
          :total="pagination.total"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handlePageChange"
        />
      </div>
    </el-card>

    <!-- 用户表单对话框 -->
    <UserForm
      v-model="formDialogVisible"
      :user-data="currentUser"
      :is-edit="isEdit"
      @success="handleFormSuccess"
    />

    <!-- 用户详情对话框 -->
    <UserDetail
      v-model="detailDialogVisible"
      :user-id="currentUserId"
    />

    <!-- 导入用户对话框 -->
    <UserImport
      v-model="importDialogVisible"
      @success="handleImportSuccess"
    />

    <!-- 导出用户对话框 -->
    <UserExport
      v-model="exportDialogVisible"
      :selected-users="selectedUsers"
      :search-filters="searchForm"
    />

    <!-- 重置密码对话框 -->
    <el-dialog
      v-model="resetPasswordDialogVisible"
      title="重置密码"
      width="400px"
    >
      <el-form ref="resetPasswordFormRef" :model="resetPasswordForm" :rules="resetPasswordRules">
        <el-form-item label="新密码" prop="newPassword">
          <el-input
            v-model="resetPasswordForm.newPassword"
            type="password"
            placeholder="请输入新密码"
            show-password
          />
        </el-form-item>
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input
            v-model="resetPasswordForm.confirmPassword"
            type="password"
            placeholder="请再次输入密码"
            show-password
          />
        </el-form-item>
      </el-form>

      <template #footer>
        <div class="dialog-footer">
          <el-button @click="resetPasswordDialogVisible = false">取消</el-button>
          <el-button 
            type="primary" 
            :loading="resetPasswordLoading"
            @click="handleConfirmResetPassword"
          >
            确认重置
          </el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { 
  Search, 
  Refresh, 
  Plus, 
  Upload, 
  Download, 
  Delete, 
  Message, 
  Phone, 
  ArrowDown,
  Key,
  Lock,
  Unlock,
  SwitchButton,
  Document
} from '@element-plus/icons-vue'
import * as userApi from '@/api/user'
import type { UserInfo, UserStatus } from '@/types/api'
import type { FormInstance, FormRules } from 'element-plus'
import UserForm from './components/UserForm.vue'
import UserDetail from './components/UserDetail.vue'
import UserImport from './components/UserImport.vue'
import UserExport from './components/UserExport.vue'

const router = useRouter()

// 响应式数据
const loading = ref(false)
const userList = ref<UserInfo[]>([])
const selectedUsers = ref<UserInfo[]>([])

// 搜索表单
const searchForm = reactive({
  keyword: '',
  status: '' as UserStatus | '',
  roleId: '',
  departmentId: '',
  createdDateRange: [] as string[]
})

// 分页信息
const pagination = reactive({
  current: 1,
  size: 20,
  total: 0
})

// 选项数据
const roleOptions = ref([])
const departmentTree = ref([])

// 对话框状态
const formDialogVisible = ref(false)
const detailDialogVisible = ref(false)
const importDialogVisible = ref(false)
const exportDialogVisible = ref(false)
const resetPasswordDialogVisible = ref(false)

// 当前操作的用户
const currentUser = ref<UserInfo | null>(null)
const currentUserId = ref('')
const isEdit = ref(false)

// 重置密码表单
const resetPasswordFormRef = ref<FormInstance>()
const resetPasswordLoading = ref(false)
const resetPasswordForm = reactive({
  newPassword: '',
  confirmPassword: ''
})

const resetPasswordRules: FormRules = {
  newPassword: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    { min: 8, message: '密码长度不能少于8位', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        if (value !== resetPasswordForm.newPassword) {
          callback(new Error('两次输入密码不一致'))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ]
}

// 工具函数
const getUserStatusType = (status: UserStatus): string => {
  const typeMap = {
    'ACTIVE': 'success',
    'DISABLED': 'info',
    'LOCKED': 'danger',
    'PENDING': 'warning'
  }
  return typeMap[status] || 'info'
}

const getUserStatusText = (status: UserStatus): string => {
  const textMap = {
    'ACTIVE': '正常',
    'DISABLED': '禁用',
    'LOCKED': '锁定',
    'PENDING': '待激活'
  }
  return textMap[status] || status
}

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

const formatDateTime = (timeStr: string): string => {
  if (!timeStr) return '-'
  return new Date(timeStr).toLocaleString()
}

// API调用函数
const loadData = async () => {
  loading.value = true
  try {
    const params = {
      current: pagination.current,
      size: pagination.size,
      keyword: searchForm.keyword || undefined,
      status: searchForm.status || undefined,
      roleId: searchForm.roleId || undefined,
      departmentId: searchForm.departmentId || undefined,
      createdStartDate: searchForm.createdDateRange[0] || undefined,
      createdEndDate: searchForm.createdDateRange[1] || undefined
    }
    
    const response = await userApi.getUsers(params)
    userList.value = response.data.records
    pagination.total = response.data.total
  } catch (error) {
    console.error('加载用户列表失败:', error)
    ElMessage.error('加载用户列表失败')
  } finally {
    loading.value = false
  }
}

const loadRoleOptions = async () => {
  try {
    const response = await userApi.getRoles()
    roleOptions.value = response.data.records
  } catch (error) {
    console.error('加载角色选项失败:', error)
  }
}

const loadDepartmentTree = async () => {
  try {
    const response = await userApi.getDepartmentTree()
    departmentTree.value = response.data
  } catch (error) {
    console.error('加载部门树失败:', error)
  }
}

// 事件处理函数
const handleSearch = () => {
  pagination.current = 1
  loadData()
}

const handleReset = () => {
  Object.assign(searchForm, {
    keyword: '',
    status: '',
    roleId: '',
    departmentId: '',
    createdDateRange: []
  })
  pagination.current = 1
  loadData()
}

const handlePageChange = () => {
  loadData()
}

const handleSizeChange = () => {
  pagination.current = 1
  loadData()
}

const handleSelectionChange = (selection: UserInfo[]) => {
  selectedUsers.value = selection
}

const handleCreate = () => {
  currentUser.value = null
  isEdit.value = false
  formDialogVisible.value = true
}

const handleEdit = (user: UserInfo) => {
  currentUser.value = user
  isEdit.value = true
  formDialogVisible.value = true
}

const handleView = (user: UserInfo) => {
  currentUserId.value = user.id
  detailDialogVisible.value = true
}

const handleAction = async (command: string, user: UserInfo) => {
  try {
    switch (command) {
      case 'resetPassword':
        currentUser.value = user
        resetPasswordForm.newPassword = ''
        resetPasswordForm.confirmPassword = ''
        resetPasswordDialogVisible.value = true
        break
        
      case 'enable':
      case 'disable':
        await ElMessageBox.confirm(
          `确认${command === 'enable' ? '启用' : '禁用'}用户 ${user.realName || user.username}？`,
          '确认操作',
          { type: 'warning' }
        )
        await userApi.toggleUserStatus(user.id, command === 'enable' ? 'ACTIVE' : 'DISABLED')
        await loadData()
        break
        
      case 'unlock':
        await userApi.unlockUser(user.id)
        await loadData()
        break
        
      case 'forceLogout':
        await ElMessageBox.confirm(
          `确认强制用户 ${user.realName || user.username} 下线？`,
          '确认操作',
          { type: 'warning' }
        )
        await userApi.forceUserLogout(user.id)
        break
        
      case 'viewLogs':
        router.push({
          path: '/audit/logs',
          query: { userId: user.id }
        })
        break
        
      case 'delete':
        await ElMessageBox.confirm(
          `确认删除用户 ${user.realName || user.username}？此操作不可恢复！`,
          '确认删除',
          { type: 'error' }
        )
        await userApi.deleteUser(user.id)
        await loadData()
        break
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('操作失败:', error)
      ElMessage.error('操作失败')
    }
  }
}

const handleBatchDelete = async () => {
  try {
    await ElMessageBox.confirm(
      `确认删除选中的 ${selectedUsers.value.length} 个用户？此操作不可恢复！`,
      '确认批量删除',
      { type: 'error' }
    )
    
    const userIds = selectedUsers.value.map(user => user.id)
    const result = await userApi.batchDeleteUsers(userIds)
    
    if (result.data.failed > 0) {
      ElMessage.warning(`删除完成，成功 ${result.data.success} 个，失败 ${result.data.failed} 个`)
    } else {
      ElMessage.success(`成功删除 ${result.data.success} 个用户`)
    }
    
    await loadData()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('批量删除失败:', error)
      ElMessage.error('批量删除失败')
    }
  }
}

const handleBatchExport = () => {
  exportDialogVisible.value = true
}

const handleImport = () => {
  importDialogVisible.value = true
}

const handleExport = () => {
  exportDialogVisible.value = true
}

const handleFormSuccess = () => {
  formDialogVisible.value = false
  loadData()
}

const handleImportSuccess = () => {
  importDialogVisible.value = false
  loadData()
}

const handleConfirmResetPassword = async () => {
  if (!resetPasswordFormRef.value || !currentUser.value) return
  
  try {
    await resetPasswordFormRef.value.validate()
    resetPasswordLoading.value = true
    
    await userApi.resetUserPassword(currentUser.value.id, resetPasswordForm.newPassword)
    
    resetPasswordDialogVisible.value = false
    ElMessage.success('密码重置成功')
  } catch (error) {
    console.error('重置密码失败:', error)
    ElMessage.error('重置密码失败')
  } finally {
    resetPasswordLoading.value = false
  }
}

// 初始化
onMounted(() => {
  loadData()
  loadRoleOptions()
  loadDepartmentTree()
})
</script>

<style scoped lang="scss">
.user-list {
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

    .header-actions {
      display: flex;
      gap: 12px;
    }
  }

  .search-card {
    margin-bottom: 20px;
    border-radius: 8px;
  }

  .table-card {
    border-radius: 8px;

    .table-header {
      display: flex;
      justify-content: space-between;
      align-items: center;

      .table-title {
        display: flex;
        align-items: center;
        gap: 12px;
        font-weight: 600;
        color: #1f2329;
      }

      .table-actions {
        display: flex;
        gap: 8px;
      }
    }

    .user-info {
      display: flex;
      align-items: center;

      .user-details {
        .user-name {
          font-weight: 500;
          color: #1f2329;
          margin-bottom: 2px;
        }

        .user-username {
          font-size: 12px;
          color: #86909c;
        }
      }
    }

    .contact-info {
      .contact-item {
        display: flex;
        align-items: center;
        gap: 4px;
        margin-bottom: 4px;
        font-size: 12px;
        color: #86909c;

        .el-icon {
          font-size: 12px;
        }
      }
    }

    .roles {
      display: flex;
      flex-wrap: wrap;
    }

    .login-info {
      .login-time {
        font-size: 12px;
        color: #1f2329;
        margin-bottom: 2px;
      }

      .login-ip {
        font-size: 11px;
        color: #86909c;
      }
    }

    .text-gray {
      color: #86909c;
      font-size: 12px;
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

  .dialog-footer {
    display: flex;
    justify-content: flex-end;
    gap: 12px;
  }
}
</style>