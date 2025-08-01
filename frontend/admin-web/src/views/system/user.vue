<template>
  <div class="user-management">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-left">
        <h2 class="page-title">
          <el-icon><User /></el-icon>
          用户管理
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
          添加用户
        </el-button>
        <el-button @click="$router.push('/system/role')">
          <el-icon><Key /></el-icon>
          角色管理
        </el-button>
      </div>
    </div>

    <!-- 搜索和过滤 -->
    <el-card shadow="never" class="filter-card">
      <div class="filter-section">
        <div class="filter-left">
          <el-input
            v-model="filters.keyword"
            placeholder="搜索用户名、邮箱、姓名"
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
            placeholder="用户状态"
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
            v-model="filters.role"
            placeholder="用户角色"
            clearable
            style="width: 120px;"
            @change="handleFilterChange"
          >
            <el-option
              v-for="role in roleOptions"
              :key="role.value"
              :label="role.label"
              :value="role.value"
            />
          </el-select>
          
          <el-select
            v-model="filters.department"
            placeholder="所属部门"
            clearable
            style="width: 120px;"
            @change="handleFilterChange"
          >
            <el-option
              v-for="dept in departmentOptions"
              :key="dept.value"
              :label="dept.label"
              :value="dept.value"
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

    <!-- 用户列表 -->
    <el-card shadow="never" class="table-card">
      <DataTable
        ref="tableRef"
        :data="userList"
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
        @refresh="loadUsers"
      />
    </el-card>

    <!-- 创建/编辑用户弹窗 -->
    <el-dialog
      v-model="showCreateDialog"
      :title="editingUser ? '编辑用户' : '创建用户'"
      width="600px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="formRef"
        :model="userForm"
        :rules="formRules"
        label-width="100px"
      >
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="用户名" prop="username">
              <el-input 
                v-model="userForm.username" 
                placeholder="请输入用户名"
                :disabled="!!editingUser"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="邮箱" prop="email">
              <el-input v-model="userForm.email" placeholder="请输入邮箱" />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="姓名" prop="name">
              <el-input v-model="userForm.name" placeholder="请输入真实姓名" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="手机号" prop="phone">
              <el-input v-model="userForm.phone" placeholder="请输入手机号" />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-form-item v-if="!editingUser" label="密码" prop="password">
          <el-input
            v-model="userForm.password"
            type="password"
            placeholder="请输入密码"
            show-password
          />
        </el-form-item>
        
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="所属部门" prop="department">
              <el-select v-model="userForm.department" placeholder="选择部门" style="width: 100%;">
                <el-option
                  v-for="dept in departmentOptions"
                  :key="dept.value"
                  :label="dept.label"
                  :value="dept.value"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="职位" prop="position">
              <el-input v-model="userForm.position" placeholder="请输入职位" />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-form-item label="用户角色" prop="roles">
          <el-select
            v-model="userForm.roles"
            multiple
            placeholder="选择角色"
            style="width: 100%;"
          >
            <el-option
              v-for="role in roleOptions"
              :key="role.value"
              :label="role.label"
              :value="role.value"
            />
          </el-select>
        </el-form-item>
        
        <el-form-item label="头像">
          <el-upload
            ref="avatarUploadRef"
            :auto-upload="false"
            :on-change="handleAvatarChange"
            :before-upload="beforeAvatarUpload"
            accept="image/*"
            list-type="picture-card"
            :limit="1"
          >
            <el-icon><Plus /></el-icon>
          </el-upload>
        </el-form-item>
        
        <el-form-item label="用户状态">
          <el-radio-group v-model="userForm.status">
            <el-radio value="active">活跃</el-radio>
            <el-radio value="inactive">禁用</el-radio>
            <el-radio value="pending">待审核</el-radio>
          </el-radio-group>
        </el-form-item>
        
        <el-form-item label="备注说明" prop="description">
          <el-input
            v-model="userForm.description"
            type="textarea"
            :rows="3"
            placeholder="请输入备注说明"
          />
        </el-form-item>
      </el-form>
      
      <template #footer>
        <el-button @click="showCreateDialog = false">取消</el-button>
        <el-button type="primary" @click="handleSaveUser" :loading="saving">
          {{ editingUser ? '更新' : '创建' }}
        </el-button>
      </template>
    </el-dialog>

    <!-- 用户详情弹窗 -->
    <el-dialog
      v-model="showDetailDialog"
      title="用户详情"
      width="700px"
    >
      <div v-if="selectedUser" class="user-detail">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="用户名">
            {{ selectedUser.username }}
          </el-descriptions-item>
          <el-descriptions-item label="邮箱">
            {{ selectedUser.email }}
          </el-descriptions-item>
          <el-descriptions-item label="姓名">
            {{ selectedUser.name }}
          </el-descriptions-item>
          <el-descriptions-item label="手机号">
            {{ selectedUser.phone || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="状态">
            <StatusIndicator
              mode="dot"
              :type="getStatusType(selectedUser.status)"
              :text="getStatusLabel(selectedUser.status)"
            />
          </el-descriptions-item>
          <el-descriptions-item label="所属部门">
            {{ getDepartmentLabel(selectedUser.department) }}
          </el-descriptions-item>
          <el-descriptions-item label="职位">
            {{ selectedUser.position || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="用户角色">
            <el-tag
              v-for="role in selectedUser.roles"
              :key="role"
              size="small"
              style="margin-right: 8px;"
            >
              {{ getRoleLabel(role) }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="最后登录">
            {{ selectedUser.lastLoginTime ? formatDateTime(selectedUser.lastLoginTime) : '从未登录' }}
          </el-descriptions-item>
          <el-descriptions-item label="登录次数">
            {{ selectedUser.loginCount || 0 }}次
          </el-descriptions-item>
          <el-descriptions-item label="创建时间" :span="2">
            {{ formatDateTime(selectedUser.createdAt) }}
          </el-descriptions-item>
          <el-descriptions-item label="最后更新" :span="2">
            {{ formatDateTime(selectedUser.updatedAt) }}
          </el-descriptions-item>
          <el-descriptions-item v-if="selectedUser.description" label="备注说明" :span="2">
            {{ selectedUser.description }}
          </el-descriptions-item>
        </el-descriptions>
        
        <!-- 操作日志 -->
        <div class="operation-logs">
          <h4>最近操作日志</h4>
          <el-table :data="selectedUser.recentLogs" size="small">
            <el-table-column prop="action" label="操作" width="150" />
            <el-table-column prop="resource" label="资源" width="200" />
            <el-table-column prop="ip" label="IP地址" width="120" />
            <el-table-column prop="time" label="操作时间" width="160">
              <template #default="{ row }">
                {{ formatDateTime(row.time, 'MM-DD HH:mm:ss') }}
              </template>
            </el-table-column>
            <el-table-column prop="result" label="结果" width="80">
              <template #default="{ row }">
                <el-tag :type="row.result === 'success' ? 'success' : 'danger'" size="small">
                  {{ row.result === 'success' ? '成功' : '失败' }}
                </el-tag>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </div>
    </el-dialog>

    <!-- 重置密码弹窗 -->
    <el-dialog
      v-model="showResetPasswordDialog"
      title="重置密码"
      width="400px"
    >
      <el-form ref="passwordFormRef" :model="passwordForm" :rules="passwordRules" label-width="80px">
        <el-form-item label="新密码" prop="newPassword">
          <el-input
            v-model="passwordForm.newPassword"
            type="password"
            placeholder="请输入新密码"
            show-password
          />
        </el-form-item>
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input
            v-model="passwordForm.confirmPassword"
            type="password"
            placeholder="请再次输入新密码"
            show-password
          />
        </el-form-item>
      </el-form>
      
      <template #footer>
        <el-button @click="showResetPasswordDialog = false">取消</el-button>
        <el-button type="primary" @click="handleResetPassword" :loading="resetting">
          确认重置
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

// 接口定义
interface User {
  id: string
  username: string
  email: string
  name: string
  phone?: string
  status: string
  department: string
  position?: string
  roles: string[]
  avatar?: string
  lastLoginTime?: string
  loginCount?: number
  description?: string
  createdAt: string
  updatedAt: string
  recentLogs?: any[]
}

// 响应式数据
const loading = ref(false)
const saving = ref(false)
const resetting = ref(false)
const showCreateDialog = ref(false)
const showDetailDialog = ref(false)
const showResetPasswordDialog = ref(false)
const editingUser = ref<User | null>(null)
const selectedUser = ref<User | null>(null)
const selectedUsers = ref<User[]>([])
const resetPasswordUser = ref<User | null>(null)
const tableRef = ref()
const formRef = ref()
const passwordFormRef = ref()
const avatarUploadRef = ref()

// 模拟数据
const userList = ref<User[]>([
  {
    id: '1',
    username: 'admin',
    email: 'admin@wework.com',
    name: '系统管理员',
    phone: '13800138000',
    status: 'active',
    department: 'technology',
    position: '系统管理员',
    roles: ['admin', 'super_admin'],
    lastLoginTime: '2024-01-01T10:30:00Z',
    loginCount: 256,
    description: '系统超级管理员账号',
    createdAt: '2024-01-01T00:00:00Z',
    updatedAt: '2024-01-01T10:30:00Z',
    recentLogs: [
      { action: '登录系统', resource: '系统', ip: '192.168.1.100', time: '2024-01-01T10:30:00Z', result: 'success' },
      { action: '创建用户', resource: '用户管理', ip: '192.168.1.100', time: '2024-01-01T10:25:00Z', result: 'success' },
      { action: '修改角色', resource: '角色管理', ip: '192.168.1.100', time: '2024-01-01T10:20:00Z', result: 'success' }
    ]
  },
  {
    id: '2',
    username: 'operator',
    email: 'operator@wework.com',
    name: '运营专员',
    phone: '13800138001',
    status: 'active',
    department: 'operations',
    position: '运营专员',
    roles: ['operator', 'tenant_admin'],
    lastLoginTime: '2024-01-01T09:15:00Z',
    loginCount: 128,
    description: '运营部门专员',
    createdAt: '2024-01-01T00:00:00Z',
    updatedAt: '2024-01-01T09:15:00Z',
    recentLogs: [
      { action: '查看报表', resource: '数据分析', ip: '192.168.1.101', time: '2024-01-01T09:15:00Z', result: 'success' },
      { action: '导出数据', resource: '账号管理', ip: '192.168.1.101', time: '2024-01-01T09:10:00Z', result: 'success' }
    ]
  },
  {
    id: '3',
    username: 'viewer',
    email: 'viewer@wework.com',
    name: '访客用户',
    status: 'pending',
    department: 'guest',
    roles: ['viewer'],
    loginCount: 0,
    description: '待审核的访客用户',
    createdAt: '2024-01-01T00:00:00Z',
    updatedAt: '2024-01-01T08:00:00Z',
    recentLogs: []
  }
])

// 统计数据
const stats = computed(() => {
  const total = userList.value.length
  const active = userList.value.filter(u => u.status === 'active').length
  const pending = userList.value.filter(u => u.status === 'pending').length
  
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
  role: '',
  department: ''
})

// 分页
const pagination = reactive({
  current: 1,
  size: 20,
  total: 0
})

// 表单数据
const userForm = reactive({
  username: '',
  email: '',
  name: '',
  phone: '',
  password: '',
  department: '',
  position: '',
  roles: [] as string[],
  avatar: '',
  status: 'active',
  description: ''
})

// 密码重置表单
const passwordForm = reactive({
  newPassword: '',
  confirmPassword: ''
})

// 表单验证规则
const formRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度为3-20个字符', trigger: 'blur' }
  ],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ],
  name: [
    { required: true, message: '请输入姓名', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度为6-20个字符', trigger: 'blur' }
  ],
  phone: [
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
  ],
  department: [
    { required: true, message: '请选择所属部门', trigger: 'change' }
  ],
  roles: [
    { required: true, message: '请选择用户角色', trigger: 'change' }
  ]
}

// 密码验证规则
const passwordRules = {
  newPassword: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度为6-20个字符', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请再次输入新密码', trigger: 'blur' },
    {
      validator: (rule: any, value: any, callback: any) => {
        if (value !== passwordForm.newPassword) {
          callback(new Error('两次输入的密码不一致'))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ]
}

// 选项数据
const statusOptions = [
  { label: '活跃', value: 'active' },
  { label: '禁用', value: 'inactive' },
  { label: '待审核', value: 'pending' }
]

const roleOptions = [
  { label: '超级管理员', value: 'super_admin' },
  { label: '系统管理员', value: 'admin' },
  { label: '租户管理员', value: 'tenant_admin' },
  { label: '运营人员', value: 'operator' },
  { label: '监控查看者', value: 'monitor_viewer' },
  { label: '访客', value: 'viewer' }
]

const departmentOptions = [
  { label: '技术部', value: 'technology' },
  { label: '运营部', value: 'operations' },
  { label: '销售部', value: 'sales' },
  { label: '客服部', value: 'customer_service' },
  { label: '访客', value: 'guest' }
]

// 表格列配置
const tableColumns = [
  {
    prop: 'username',
    label: '用户名',
    minWidth: 120,
    fixed: 'left' as const
  },
  {
    prop: 'name',
    label: '姓名',
    width: 100
  },
  {
    prop: 'email',
    label: '邮箱',
    width: 200,
    showOverflowTooltip: true
  },
  {
    prop: 'status',
    label: '状态',
    width: 80,
    type: 'status' as const,
    statusMap: {
      active: { text: '活跃', type: 'success' },
      inactive: { text: '禁用', type: 'danger' },
      pending: { text: '待审核', type: 'warning' }
    }
  },
  {
    prop: 'department',
    label: '部门',
    width: 100,
    formatter: (row: User) => getDepartmentLabel(row.department)
  },
  {
    prop: 'roles',
    label: '角色',
    width: 150,
    formatter: (row: User) => row.roles.map(role => getRoleLabel(role)).join(', ')
  },
  {
    prop: 'lastLoginTime',
    label: '最后登录',
    width: 160,
    type: 'datetime' as const,
    format: 'MM-DD HH:mm:ss'
  },
  {
    prop: 'loginCount',
    label: '登录次数',
    width: 80,
    align: 'center' as const,
    formatter: (row: User) => row.loginCount || 0
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
        key: 'resetPassword',
        label: '重置密码',
        type: 'warning' as const,
        icon: 'Key'
      },
      {
        key: 'delete',
        label: '删除',
        type: 'danger' as const,
        icon: 'Delete',
        hidden: (row: User) => row.username === 'admin' // 不能删除管理员
      }
    ]
  }
]

// 批量操作
const batchActions = [
  {
    key: 'batchEnable',
    label: '批量启用',
    type: 'success' as const,
    icon: 'CircleCheck'
  },
  {
    key: 'batchDisable',
    label: '批量禁用',
    type: 'warning' as const,
    icon: 'CircleClose'
  },
  {
    key: 'batchDelete',
    label: '批量删除',
    type: 'danger' as const,
    icon: 'Delete'
  }
]

// 方法
const loadUsers = async () => {
  try {
    loading.value = true
    // 模拟API调用
    await new Promise(resolve => setTimeout(resolve, 500))
    pagination.total = userList.value.length
  } catch (error: any) {
    ElMessage.error('加载用户列表失败')
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  loadUsers()
}

const handleFilterChange = () => {
  loadUsers()
}

const resetFilters = () => {
  Object.assign(filters, {
    keyword: '',
    status: '',
    role: '',
    department: ''
  })
  loadUsers()
}

const handlePageChange = (page: number) => {
  pagination.current = page
  loadUsers()
}

const handleSizeChange = (size: number) => {
  pagination.size = size
  pagination.current = 1
  loadUsers()
}

const handleSelectionChange = (selection: User[]) => {
  selectedUsers.value = selection
}

const handleAction = async (action: string, row: User) => {
  switch (action) {
    case 'detail':
      selectedUser.value = row
      showDetailDialog.value = true
      break
    case 'edit':
      editingUser.value = row
      Object.assign(userForm, {
        username: row.username,
        email: row.email,
        name: row.name,
        phone: row.phone || '',
        department: row.department,
        position: row.position || '',
        roles: [...row.roles],
        status: row.status,
        description: row.description || ''
      })
      showCreateDialog.value = true
      break
    case 'resetPassword':
      resetPasswordUser.value = row
      passwordForm.newPassword = ''
      passwordForm.confirmPassword = ''
      showResetPasswordDialog.value = true
      break
    case 'delete':
      await handleDeleteUser(row)
      break
  }
}

const handleBatchAction = async (action: string) => {
  if (selectedUsers.value.length === 0) {
    ElMessage.warning('请选择要操作的用户')
    return
  }
  
  switch (action) {
    case 'batchEnable':
      await handleBatchEnable()
      break
    case 'batchDisable':
      await handleBatchDisable()
      break
    case 'batchDelete':
      await handleBatchDelete()
      break
  }
}

const handleSaveUser = async () => {
  if (!formRef.value) return
  
  try {
    await formRef.value.validate()
    saving.value = true
    
    // 模拟API调用
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    if (editingUser.value) {
      ElMessage.success('用户更新成功')
    } else {
      ElMessage.success('用户创建成功')
    }
    
    showCreateDialog.value = false
    resetForm()
    loadUsers()
  } catch (error) {
    // 验证失败
  } finally {
    saving.value = false
  }
}

const resetForm = () => {
  editingUser.value = null
  Object.assign(userForm, {
    username: '',
    email: '',
    name: '',
    phone: '',
    password: '',
    department: '',
    position: '',
    roles: [],
    avatar: '',
    status: 'active',
    description: ''
  })
  formRef.value?.resetFields()
}

const handleResetPassword = async () => {
  if (!passwordFormRef.value) return
  
  try {
    await passwordFormRef.value.validate()
    resetting.value = true
    
    // 模拟API调用
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    ElMessage.success('密码重置成功')
    showResetPasswordDialog.value = false
  } catch (error) {
    // 验证失败
  } finally {
    resetting.value = false
  }
}

const handleDeleteUser = async (user: User) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除用户 "${user.name}" 吗？此操作不可恢复。`,
      '确认删除',
      {
        type: 'warning',
        confirmButtonText: '确定删除',
        cancelButtonText: '取消'
      }
    )
    
    ElMessage.success('用户删除成功')
    loadUsers()
  } catch (error) {
    // 用户取消
  }
}

const handleBatchEnable = async () => {
  ElMessage.success(`正在批量启用 ${selectedUsers.value.length} 个用户`)
  loadUsers()
}

const handleBatchDisable = async () => {
  ElMessage.success(`正在批量禁用 ${selectedUsers.value.length} 个用户`)
  loadUsers()
}

const handleBatchDelete = async () => {
  try {
    await ElMessageBox.confirm(
      `确定要删除选中的 ${selectedUsers.value.length} 个用户吗？此操作不可恢复。`,
      '确认批量删除',
      {
        type: 'warning',
        confirmButtonText: '确定删除',
        cancelButtonText: '取消'
      }
    )
    
    ElMessage.success('批量删除成功')
    loadUsers()
  } catch (error) {
    // 用户取消
  }
}

const handleAvatarChange = (file: any) => {
  userForm.avatar = URL.createObjectURL(file.raw)
}

const beforeAvatarUpload = (file: any) => {
  const isImage = file.type.startsWith('image/')
  const isLt2M = file.size / 1024 / 1024 < 2
  
  if (!isImage) {
    ElMessage.error('只能上传图片文件!')
    return false
  }
  if (!isLt2M) {
    ElMessage.error('图片大小不能超过 2MB!')
    return false
  }
  return true
}

// 辅助方法
const getStatusLabel = (status: string) => {
  const statusMap = {
    active: '活跃',
    inactive: '禁用',
    pending: '待审核'
  }
  return statusMap[status] || status
}

const getStatusType = (status: string) => {
  const statusTypeMap = {
    active: 'success',
    inactive: 'danger',
    pending: 'warning'
  }
  return statusTypeMap[status] || 'info'
}

const getRoleLabel = (role: string) => {
  const roleMap = {
    super_admin: '超级管理员',
    admin: '系统管理员',
    tenant_admin: '租户管理员',
    operator: '运营人员',
    monitor_viewer: '监控查看者',
    viewer: '访客'
  }
  return roleMap[role] || role
}

const getDepartmentLabel = (department: string) => {
  const departmentMap = {
    technology: '技术部',
    operations: '运营部',
    sales: '销售部',
    customer_service: '客服部',
    guest: '访客'
  }
  return departmentMap[department] || department
}

// 生命周期
onMounted(() => {
  loadUsers()
})
</script>

<style lang="scss" scoped>
.user-management {
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
  
  .user-detail {
    .operation-logs {
      margin-top: 24px;
      
      h4 {
        margin: 0 0 16px 0;
        font-size: 16px;
        font-weight: 600;
        color: var(--el-text-color-primary);
      }
    }
  }
}

// 响应式适配
@media (max-width: 768px) {
  .user-management {
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