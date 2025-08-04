# 🎨 前端编码规范和开发规则

## 📐 Vue 3 + TypeScript 基础规范

### 1. 项目结构规范
```
frontend/admin-web/
├── public/                     # 静态资源
│   ├── logo.png
│   └── index.html
├── src/
│   ├── api/                    # API接口层
│   │   ├── account.ts
│   │   ├── auth.ts
│   │   └── types/              # API类型定义
│   ├── components/             # 通用组件
│   │   ├── ui/                 # UI基础组件
│   │   │   ├── DataTable.vue
│   │   │   ├── MonitorChart.vue
│   │   │   └── index.ts        # 组件导出
│   │   └── business/           # 业务组件
│   ├── views/                  # 页面组件
│   │   ├── account/
│   │   ├── dashboard/
│   │   └── login/
│   ├── layout/                 # 布局组件
│   │   ├── components/
│   │   └── index.vue
│   ├── router/                 # 路由配置
│   │   ├── index.ts
│   │   └── routes.ts
│   ├── stores/                 # 状态管理
│   │   ├── modules/
│   │   └── index.ts
│   ├── utils/                  # 工具函数
│   ├── types/                  # TypeScript类型定义
│   ├── constants/              # 常量定义
│   ├── directives/             # 自定义指令
│   ├── styles/                 # 样式文件
│   │   ├── variables.scss      # SCSS变量
│   │   ├── mixins.scss         # SCSS混入
│   │   └── index.scss          # 主样式
│   ├── App.vue                 # 根组件
│   └── main.ts                 # 应用入口
├── package.json
├── tsconfig.json
├── vite.config.ts
└── .eslintrc.js
```

### 2. 命名规范
```typescript
// ✅ 正确的命名规范

// 文件名：kebab-case
account-list.vue
user-profile.ts
api-types.ts

// 组件名：PascalCase
<template>
  <UserProfile />
  <AccountList />
  <DataTable />
</template>

// 变量和函数：camelCase
const userInfo = ref<UserInfo>()
const accountList = ref<Account[]>([])

const getUserInfo = async (userId: string) => {
  // 函数实现
}

// 常量：SCREAMING_SNAKE_CASE
const API_BASE_URL = 'https://api.example.com'
const MAX_RETRY_COUNT = 3

// 类型和接口：PascalCase
interface UserInfo {
  id: string
  username: string
  email: string
}

type AccountStatus = 'active' | 'inactive' | 'pending'

// ❌ 错误的命名
const user_info = ref()           // 应该用camelCase
const User_Profile = {}           // 应该用PascalCase
const api_base_url = ''          // 常量应该用SCREAMING_SNAKE_CASE
```

## 🧩 组件开发规范

### 1. Vue 3 组合式API规范
```vue
<!-- ✅ 标准Vue 3组件结构 -->
<template>
  <div class="account-list">
    <!-- 搜索区域 -->
    <div class="search-area">
      <el-form :model="searchForm" inline class="search-form">
        <el-form-item label="账号名称">
          <el-input
            v-model="searchForm.accountName"
            placeholder="请输入账号名称"
            clearable
            @keyup.enter="handleSearch"
          />
        </el-form-item>
        <el-form-item label="状态">
          <el-select
            v-model="searchForm.status"
            placeholder="请选择状态"
            clearable
          >
            <el-option
              v-for="item in statusOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
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

    <!-- 操作区域 -->
    <div class="action-area">
      <el-button
        type="primary"
        @click="handleCreate"
        v-permission="'account:create'"
      >
        <el-icon><Plus /></el-icon>
        新增账号
      </el-button>
      <el-button
        type="danger"
        :disabled="!selectedRows.length"
        @click="handleBatchDelete"
        v-permission="'account:delete'"
      >
        <el-icon><Delete /></el-icon>
        批量删除
      </el-button>
    </div>

    <!-- 数据表格 -->
    <DataTable
      v-model:selected="selectedRows"
      :data="tableData"
      :columns="tableColumns"
      :loading="loading"
      :pagination="pagination"
      @page-change="handlePageChange"
      @size-change="handleSizeChange"
    >
      <template #status="{ row }">
        <el-tag :type="getStatusType(row.status)">
          {{ getStatusText(row.status) }}
        </el-tag>
      </template>
      
      <template #actions="{ row }">
        <el-button
          size="small"
          type="primary"
          link
          @click="handleEdit(row)"
          v-permission="'account:update'"
        >
          编辑
        </el-button>
        <el-button
          size="small"
          type="danger"
          link
          @click="handleDelete(row)"
          v-permission="'account:delete'"
        >
          删除
        </el-button>
      </template>
    </DataTable>

    <!-- 创建/编辑对话框 -->
    <AccountForm
      v-model:visible="formVisible"
      :form-data="formData"
      :mode="formMode"
      @success="handleFormSuccess"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search, Plus, Delete } from '@element-plus/icons-vue'
import { useAccountStore } from '@/stores/modules/account'
import { useUserStore } from '@/stores/modules/user'
import DataTable from '@/components/ui/DataTable.vue'
import AccountForm from './components/AccountForm.vue'
import type { Account, AccountSearchForm, TableColumn } from '@/types/account'

// ===== 组合式函数和状态管理 =====
const accountStore = useAccountStore()
const userStore = useUserStore()

// ===== 响应式数据 =====
const loading = ref(false)
const formVisible = ref(false)
const formMode = ref<'create' | 'edit'>('create')
const selectedRows = ref<Account[]>([])

// 搜索表单
const searchForm = reactive<AccountSearchForm>({
  accountName: '',
  status: '',
  pageNum: 1,
  pageSize: 20
})

// 表单数据
const formData = ref<Partial<Account>>({})

// ===== 计算属性 =====
const tableData = computed(() => accountStore.accountList)
const pagination = computed(() => accountStore.pagination)

const statusOptions = computed(() => [
  { label: '在线', value: 'ONLINE' },
  { label: '离线', value: 'OFFLINE' },
  { label: '错误', value: 'ERROR' }
])

const tableColumns = computed<TableColumn[]>(() => [
  { prop: 'accountName', label: '账号名称', width: 200 },
  { prop: 'weWorkGuid', label: '企微GUID', width: 200 },
  { prop: 'status', label: '状态', width: 120, slot: 'status' },
  { prop: 'createdAt', label: '创建时间', width: 180, formatter: formatDate },
  { prop: 'actions', label: '操作', width: 160, slot: 'actions', fixed: 'right' }
])

// ===== 方法定义 =====
const fetchAccountList = async () => {
  loading.value = true
  try {
    await accountStore.fetchAccountList(searchForm)
  } catch (error) {
    ElMessage.error('获取账号列表失败')
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  searchForm.pageNum = 1
  fetchAccountList()
}

const handleReset = () => {
  Object.assign(searchForm, {
    accountName: '',
    status: '',
    pageNum: 1,
    pageSize: 20
  })
  fetchAccountList()
}

const handleCreate = () => {
  formMode.value = 'create'
  formData.value = {}
  formVisible.value = true
}

const handleEdit = (row: Account) => {
  formMode.value = 'edit'
  formData.value = { ...row }
  formVisible.value = true
}

const handleDelete = async (row: Account) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除账号 "${row.accountName}" 吗？`,
      '删除确认',
      {
        type: 'warning',
        confirmButtonText: '确定',
        cancelButtonText: '取消'
      }
    )
    
    await accountStore.deleteAccount(row.id)
    ElMessage.success('删除成功')
    fetchAccountList()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

const handleBatchDelete = async () => {
  if (!selectedRows.value.length) {
    ElMessage.warning('请选择要删除的账号')
    return
  }
  
  try {
    await ElMessageBox.confirm(
      `确定要删除选中的 ${selectedRows.value.length} 个账号吗？`,
      '批量删除确认',
      {
        type: 'warning',
        confirmButtonText: '确定',
        cancelButtonText: '取消'
      }
    )
    
    const ids = selectedRows.value.map(row => row.id)
    await accountStore.batchDeleteAccounts(ids)
    ElMessage.success('批量删除成功')
    selectedRows.value = []
    fetchAccountList()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('批量删除失败')
    }
  }
}

const handlePageChange = (page: number) => {
  searchForm.pageNum = page
  fetchAccountList()
}

const handleSizeChange = (size: number) => {
  searchForm.pageSize = size
  searchForm.pageNum = 1
  fetchAccountList()
}

const handleFormSuccess = () => {
  formVisible.value = false
  fetchAccountList()
}

// ===== 工具函数 =====
const getStatusType = (status: string) => {
  const typeMap: Record<string, string> = {
    ONLINE: 'success',
    OFFLINE: 'warning',
    ERROR: 'danger'
  }
  return typeMap[status] || 'info'
}

const getStatusText = (status: string) => {
  const textMap: Record<string, string> = {
    ONLINE: '在线',
    OFFLINE: '离线',
    ERROR: '错误'
  }
  return textMap[status] || '未知'
}

const formatDate = (value: string) => {
  return new Date(value).toLocaleString('zh-CN')
}

// ===== 生命周期 =====
onMounted(() => {
  fetchAccountList()
})
</script>

<style lang="scss" scoped>
.account-list {
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
        margin-bottom: 0;
      }
    }
  }

  .action-area {
    margin-bottom: 20px;

    .el-button {
      margin-right: 10px;
    }
  }
}
</style>
```

### 2. 组件Props和Emits规范
```typescript
// ✅ 正确的Props和Emits定义
<script setup lang="ts">
interface Props {
  // 基础属性
  visible: boolean
  title?: string
  width?: string | number
  
  // 业务属性
  formData: Partial<Account>
  mode: 'create' | 'edit'
  
  // 可选属性使用?标记
  readonly?: boolean
  loading?: boolean
}

interface Emits {
  // 更新事件
  (event: 'update:visible', value: boolean): void
  (event: 'update:formData', value: Partial<Account>): void
  
  // 业务事件
  (event: 'success', data: Account): void
  (event: 'cancel'): void
  (event: 'validate', field: string, valid: boolean): void
}

// 定义Props默认值
const props = withDefaults(defineProps<Props>(), {
  title: '表单',
  width: '600px',
  readonly: false,
  loading: false
})

// 定义Emits
const emit = defineEmits<Emits>()

// ❌ 错误的定义方式
// const props = defineProps(['visible', 'data'])  // 缺少类型
// const emit = defineEmits(['update', 'change'])   // 缺少具体事件定义
</script>
```

## 🏪 状态管理规范 (Pinia)

### 1. Store定义规范
```typescript
// ✅ stores/modules/account.ts
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { accountApi } from '@/api/account'
import type { Account, AccountSearchForm, PageResult } from '@/types/account'

export const useAccountStore = defineStore('account', () => {
  // ===== State =====
  const accountList = ref<Account[]>([])
  const currentAccount = ref<Account | null>(null)
  const loading = ref(false)
  const pagination = ref({
    total: 0,
    pageNum: 1,
    pageSize: 20,
    pages: 0
  })

  // ===== Getters =====
  const onlineAccountCount = computed(() => {
    return accountList.value.filter(account => account.status === 'ONLINE').length
  })

  const offlineAccountCount = computed(() => {
    return accountList.value.filter(account => account.status === 'OFFLINE').length
  })

  const accountStatusDistribution = computed(() => {
    const distribution = { ONLINE: 0, OFFLINE: 0, ERROR: 0 }
    accountList.value.forEach(account => {
      distribution[account.status] = (distribution[account.status] || 0) + 1
    })
    return distribution
  })

  // ===== Actions =====
  const fetchAccountList = async (params: AccountSearchForm) => {
    loading.value = true
    try {
      const response = await accountApi.getAccountList(params)
      if (response.code === 200) {
        accountList.value = response.data.records
        pagination.value = {
          total: response.data.total,
          pageNum: response.data.pageNum,
          pageSize: response.data.pageSize,
          pages: response.data.pages
        }
      }
    } catch (error) {
      console.error('获取账号列表失败:', error)
      throw error
    } finally {
      loading.value = false
    }
  }

  const fetchAccountById = async (id: string) => {
    try {
      const response = await accountApi.getAccountById(id)
      if (response.code === 200) {
        currentAccount.value = response.data
        return response.data
      }
    } catch (error) {
      console.error('获取账号详情失败:', error)
      throw error
    }
  }

  const createAccount = async (accountData: Omit<Account, 'id' | 'createdAt' | 'updatedAt'>) => {
    try {
      const response = await accountApi.createAccount(accountData)
      if (response.code === 200) {
        // 创建成功后刷新列表
        await fetchAccountList({ pageNum: 1, pageSize: pagination.value.pageSize })
        return response.data
      }
    } catch (error) {
      console.error('创建账号失败:', error)
      throw error
    }
  }

  const updateAccount = async (id: string, accountData: Partial<Account>) => {
    try {
      const response = await accountApi.updateAccount(id, accountData)
      if (response.code === 200) {
        // 更新本地数据
        const index = accountList.value.findIndex(account => account.id === id)
        if (index !== -1) {
          accountList.value[index] = { ...accountList.value[index], ...response.data }
        }
        return response.data
      }
    } catch (error) {
      console.error('更新账号失败:', error)
      throw error
    }
  }

  const deleteAccount = async (id: string) => {
    try {
      const response = await accountApi.deleteAccount(id)
      if (response.code === 200) {
        // 从本地列表中移除
        const index = accountList.value.findIndex(account => account.id === id)
        if (index !== -1) {
          accountList.value.splice(index, 1)
          pagination.value.total -= 1
        }
      }
    } catch (error) {
      console.error('删除账号失败:', error)
      throw error
    }
  }

  const batchDeleteAccounts = async (ids: string[]) => {
    try {
      const response = await accountApi.batchDeleteAccounts(ids)
      if (response.code === 200) {
        // 从本地列表中移除
        accountList.value = accountList.value.filter(account => !ids.includes(account.id))
        pagination.value.total -= ids.length
      }
    } catch (error) {
      console.error('批量删除账号失败:', error)
      throw error
    }
  }

  const clearAccountList = () => {
    accountList.value = []
    pagination.value = { total: 0, pageNum: 1, pageSize: 20, pages: 0 }
  }

  const setCurrentAccount = (account: Account | null) => {
    currentAccount.value = account
  }

  return {
    // State
    accountList,
    currentAccount,
    loading,
    pagination,
    
    // Getters
    onlineAccountCount,
    offlineAccountCount,
    accountStatusDistribution,
    
    // Actions
    fetchAccountList,
    fetchAccountById,
    createAccount,
    updateAccount,
    deleteAccount,
    batchDeleteAccounts,
    clearAccountList,
    setCurrentAccount
  }
})
```

### 2. Store使用规范
```typescript
// ✅ 在组件中使用Store
<script setup lang="ts">
import { useAccountStore } from '@/stores/modules/account'
import { useUserStore } from '@/stores/modules/user'
import { storeToRefs } from 'pinia'

// 获取store实例
const accountStore = useAccountStore()
const userStore = useUserStore()

// 解构响应式状态（必须使用storeToRefs）
const { accountList, loading, pagination } = storeToRefs(accountStore)
const { userInfo, permissions } = storeToRefs(userStore)

// 直接解构actions（不需要storeToRefs）
const { fetchAccountList, createAccount, deleteAccount } = accountStore
const { login, logout, checkPermission } = userStore

// ❌ 错误的解构方式
// const { accountList, loading } = accountStore  // 会失去响应性
</script>
```

## 🎨 样式开发规范

### 1. SCSS变量和混入
```scss
// ✅ styles/variables.scss - SCSS变量定义
// 颜色变量
$primary-color: #409eff;
$success-color: #67c23a;
$warning-color: #e6a23c;
$danger-color: #f56c6c;
$info-color: #909399;

// 中性色
$text-color-primary: #303133;
$text-color-regular: #606266;
$text-color-secondary: #909399;
$text-color-placeholder: #c0c4cc;

$border-color-base: #dcdfe6;
$border-color-light: #e4e7ed;
$border-color-lighter: #ebeef5;
$border-color-extra-light: #f2f6fc;

$background-color-base: #f5f7fa;

// 尺寸变量
$border-radius-base: 4px;
$border-radius-small: 2px;
$border-radius-large: 6px;

$font-size-extra-small: 12px;
$font-size-small: 13px;
$font-size-base: 14px;
$font-size-medium: 16px;
$font-size-large: 18px;

$spacing-mini: 4px;
$spacing-small: 8px;
$spacing-base: 12px;
$spacing-medium: 16px;
$spacing-large: 20px;
$spacing-extra-large: 24px;

// Z-index层级
$z-index-dropdown: 1000;
$z-index-sticky: 1020;
$z-index-fixed: 1030;
$z-index-modal-backdrop: 1040;
$z-index-modal: 1050;
$z-index-popover: 1060;
$z-index-tooltip: 1070;

// ✅ styles/mixins.scss - SCSS混入定义
// 清除浮动
@mixin clearfix {
  &::after {
    content: '';
    display: table;
    clear: both;
  }
}

// 文本省略
@mixin text-ellipsis($lines: 1) {
  @if $lines == 1 {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  } @else {
    display: -webkit-box;
    -webkit-line-clamp: $lines;
    -webkit-box-orient: vertical;
    overflow: hidden;
    text-overflow: ellipsis;
  }
}

// Flex布局
@mixin flex-center {
  display: flex;
  align-items: center;
  justify-content: center;
}

@mixin flex-between {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

// 响应式断点
@mixin respond-to($breakpoint) {
  @if $breakpoint == mobile {
    @media (max-width: 767px) { @content; }
  }
  @if $breakpoint == tablet {
    @media (min-width: 768px) and (max-width: 1023px) { @content; }
  }
  @if $breakpoint == desktop {
    @media (min-width: 1024px) { @content; }
  }
}

// 组件样式模板
@mixin component-base {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
  color: $text-color-primary;
  font-size: $font-size-base;
  line-height: 1.5;
  list-style: none;
}

// 卡片样式
@mixin card-style {
  background: #fff;
  border: 1px solid $border-color-light;
  border-radius: $border-radius-base;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: $spacing-large;
}
```

### 2. 组件样式规范
```vue
<!-- ✅ 组件样式最佳实践 -->
<template>
  <div class="account-card">
    <div class="account-card__header">
      <h3 class="account-card__title">{{ account.accountName }}</h3>
      <div class="account-card__status" :class="`account-card__status--${account.status.toLowerCase()}`">
        {{ getStatusText(account.status) }}
      </div>
    </div>
    
    <div class="account-card__content">
      <div class="account-card__info">
        <span class="account-card__label">企微GUID:</span>
        <span class="account-card__value">{{ account.weWorkGuid }}</span>
      </div>
    </div>
    
    <div class="account-card__actions">
      <el-button size="small" @click="handleEdit">编辑</el-button>
      <el-button size="small" type="danger" @click="handleDelete">删除</el-button>
    </div>
  </div>
</template>

<style lang="scss" scoped>
// 导入变量和混入
@import '@/styles/variables.scss';
@import '@/styles/mixins.scss';

.account-card {
  @include card-style;
  
  // 使用BEM命名规范
  &__header {
    @include flex-between;
    margin-bottom: $spacing-medium;
    padding-bottom: $spacing-base;
    border-bottom: 1px solid $border-color-lighter;
  }
  
  &__title {
    margin: 0;
    font-size: $font-size-medium;
    font-weight: 500;
    color: $text-color-primary;
    
    @include text-ellipsis;
  }
  
  &__status {
    padding: $spacing-mini $spacing-small;
    border-radius: $border-radius-small;
    font-size: $font-size-extra-small;
    font-weight: 500;
    
    // 状态样式修饰符
    &--online {
      background: lighten($success-color, 35%);
      color: $success-color;
    }
    
    &--offline {
      background: lighten($warning-color, 35%);
      color: $warning-color;
    }
    
    &--error {
      background: lighten($danger-color, 35%);
      color: $danger-color;
    }
  }
  
  &__content {
    margin-bottom: $spacing-medium;
  }
  
  &__info {
    @include flex-between;
    margin-bottom: $spacing-small;
    
    &:last-child {
      margin-bottom: 0;
    }
  }
  
  &__label {
    color: $text-color-secondary;
    font-size: $font-size-small;
  }
  
  &__value {
    color: $text-color-primary;
    font-size: $font-size-small;
    
    @include text-ellipsis;
  }
  
  &__actions {
    @include flex-between;
    
    .el-button + .el-button {
      margin-left: $spacing-small;
    }
  }
  
  // 响应式设计
  @include respond-to(mobile) {
    padding: $spacing-medium;
    
    &__header {
      flex-direction: column;
      align-items: flex-start;
      gap: $spacing-small;
    }
    
    &__actions {
      flex-direction: column;
      gap: $spacing-small;
      
      .el-button {
        width: 100%;
        margin-left: 0;
      }
    }
  }
  
  // 悬停效果
  &:hover {
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
    transform: translateY(-2px);
    transition: all 0.3s ease;
  }
}
</style>

<!-- ❌ 错误的样式写法 -->
<style lang="scss" scoped>
// 不使用BEM命名
.card {
  .header {
    .title { }
    .status { }
  }
}

// 硬编码颜色值
.status {
  color: #67c23a;  // 应该使用变量
}

// 内联样式过多
.content {
  display: flex;
  align-items: center;
  justify-content: space-between;  // 应该使用混入
}
</style>
```

## 🔌 API和工具函数规范

### 1. API接口层规范
```typescript
// ✅ api/account.ts - API接口定义
import { request } from '@/utils/request'
import type { Account, AccountSearchForm, PageResult, ApiResponse } from '@/types'

export const accountApi = {
  // 获取账号列表
  getAccountList(params: AccountSearchForm): Promise<ApiResponse<PageResult<Account>>> {
    return request.get('/api/v1/accounts', { params })
  },

  // 获取账号详情
  getAccountById(id: string): Promise<ApiResponse<Account>> {
    return request.get(`/api/v1/accounts/${id}`)
  },

  // 创建账号
  createAccount(data: Omit<Account, 'id' | 'createdAt' | 'updatedAt'>): Promise<ApiResponse<Account>> {
    return request.post('/api/v1/accounts', data)
  },

  // 更新账号
  updateAccount(id: string, data: Partial<Account>): Promise<ApiResponse<Account>> {
    return request.put(`/api/v1/accounts/${id}`, data)
  },

  // 删除账号
  deleteAccount(id: string): Promise<ApiResponse<void>> {
    return request.delete(`/api/v1/accounts/${id}`)
  },

  // 批量删除账号
  batchDeleteAccounts(ids: string[]): Promise<ApiResponse<void>> {
    return request.delete('/api/v1/accounts/batch', { data: { ids } })
  },

  // 更新账号状态
  updateAccountStatus(id: string, status: AccountStatus): Promise<ApiResponse<void>> {
    return request.patch(`/api/v1/accounts/${id}/status`, { status })
  },

  // 获取账号统计
  getAccountStatistics(): Promise<ApiResponse<AccountStatistics>> {
    return request.get('/api/v1/accounts/statistics')
  }
}

// ✅ utils/request.ts - HTTP请求工具
import axios, { type AxiosInstance, type AxiosRequestConfig, type AxiosResponse } from 'axios'
import { ElMessage, ElLoading } from 'element-plus'
import { useUserStore } from '@/stores/modules/user'
import { getToken, removeToken } from '@/utils/auth'
import router from '@/router'

// 请求配置
const config = {
  baseURL: import.meta.env.VITE_API_BASE_URL || '/api',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json;charset=UTF-8'
  }
}

class RequestService {
  private instance: AxiosInstance
  private loadingInstance: any = null

  constructor(config: AxiosRequestConfig) {
    this.instance = axios.create(config)
    this.setupInterceptors()
  }

  private setupInterceptors(): void {
    // 请求拦截器
    this.instance.interceptors.request.use(
      (config) => {
        // 添加认证token
        const token = getToken()
        if (token) {
          config.headers.Authorization = `Bearer ${token}`
        }

        // 添加租户ID
        const userStore = useUserStore()
        if (userStore.userInfo?.tenantId) {
          config.headers['X-Tenant-Id'] = userStore.userInfo.tenantId
        }

        // 显示加载动画（可选）
        if (config.loading !== false) {
          this.showLoading()
        }

        return config
      },
      (error) => {
        this.hideLoading()
        return Promise.reject(error)
      }
    )

    // 响应拦截器
    this.instance.interceptors.response.use(
      (response: AxiosResponse) => {
        this.hideLoading()

        const { code, message, data } = response.data

        // 成功响应
        if (code === 200) {
          return response.data
        }

        // 业务错误
        if (code === 401) {
          ElMessage.error('登录已过期，请重新登录')
          this.handleLogout()
          return Promise.reject(new Error('未授权'))
        }

        if (code === 403) {
          ElMessage.error('权限不足')
          return Promise.reject(new Error('权限不足'))
        }

        // 其他业务错误
        ElMessage.error(message || '请求失败')
        return Promise.reject(new Error(message || '请求失败'))
      },
      (error) => {
        this.hideLoading()

        // 网络错误
        if (!error.response) {
          ElMessage.error('网络连接失败')
          return Promise.reject(error)
        }

        const { status } = error.response

        switch (status) {
          case 401:
            ElMessage.error('登录已过期，请重新登录')
            this.handleLogout()
            break
          case 403:
            ElMessage.error('权限不足')
            break
          case 404:
            ElMessage.error('请求的资源不存在')
            break
          case 500:
            ElMessage.error('服务器内部错误')
            break
          default:
            ElMessage.error('请求失败')
        }

        return Promise.reject(error)
      }
    )
  }

  private showLoading(): void {
    this.loadingInstance = ElLoading.service({
      text: '加载中...',
      background: 'rgba(0, 0, 0, 0.7)'
    })
  }

  private hideLoading(): void {
    if (this.loadingInstance) {
      this.loadingInstance.close()
      this.loadingInstance = null
    }
  }

  private handleLogout(): void {
    const userStore = useUserStore()
    userStore.logout()
    removeToken()
    router.push('/login')
  }

  // HTTP方法封装
  get<T = any>(url: string, config?: AxiosRequestConfig): Promise<T> {
    return this.instance.get(url, config)
  }

  post<T = any>(url: string, data?: any, config?: AxiosRequestConfig): Promise<T> {
    return this.instance.post(url, data, config)
  }

  put<T = any>(url: string, data?: any, config?: AxiosRequestConfig): Promise<T> {
    return this.instance.put(url, data, config)
  }

  patch<T = any>(url: string, data?: any, config?: AxiosRequestConfig): Promise<T> {
    return this.instance.patch(url, data, config)
  }

  delete<T = any>(url: string, config?: AxiosRequestConfig): Promise<T> {
    return this.instance.delete(url, config)
  }
}

export const request = new RequestService(config)
export default request
```

**规则总结**:
- 严格遵循Vue 3组合式API和TypeScript规范
- 使用BEM命名规范编写CSS，配合SCSS变量和混入
- Pinia状态管理采用组合式API风格，明确区分state、getters、actions
- API接口层统一封装，包含完整的错误处理和拦截器
- 组件Props和Emits必须定义明确的TypeScript类型
- 样式支持响应式设计和主题变量系统