# 🎨 多租户企微监控平台前端设计方案

## 📋 目录
1. [总体架构设计](#总体架构设计)
2. [页面结构设计](#页面结构设计)
3. [组件架构设计](#组件架构设计)
4. [路由权限设计](#路由权限设计)
5. [数据流设计](#数据流设计)
6. [UI/UX设计规范](#uiux设计规范)
7. [技术实现方案](#技术实现方案)

---

## 🏗️ 总体架构设计

### 架构原则
- **多租户隔离**：完全的租户数据和界面隔离
- **权限驱动**：基于角色的动态界面展示
- **响应式设计**：支持桌面端和移动端
- **组件化开发**：高度可复用的业务组件
- **状态管理**：统一的数据状态管理

### 技术栈
```typescript
核心框架：Vue 3.3+ (Composition API)
类型系统：TypeScript 5.0+
UI组件库：Element Plus 2.4+
状态管理：Pinia 2.1+
路由管理：Vue Router 4.2+
HTTP客户端：Axios 1.5+
图表库：ECharts 5.4+
样式方案：SCSS + CSS Variables
构建工具：Vite 4.4+
```

### 目录结构
```
frontend/admin-web/src/
├── views/                     # 页面组件
│   ├── tenant/               # 租户管理
│   ├── dashboard/            # 仪表板
│   ├── account/             # 账号管理
│   ├── monitor/             # 监控中心
│   ├── alert/               # 告警管理
│   ├── autoops/             # 自动运维
│   └── system/              # 系统管理
├── components/              # 公共组件
│   ├── business/           # 业务组件
│   ├── charts/             # 图表组件
│   ├── forms/              # 表单组件
│   └── layout/             # 布局组件
├── composables/            # 组合式函数
├── stores/                 # 状态管理
├── utils/                  # 工具函数
├── types/                  # 类型定义
└── styles/                 # 样式文件
```

---

## 📄 页面结构设计

### 1. 主布局结构

```vue
<!-- MainLayout.vue -->
<template>
  <el-container class="main-layout">
    <!-- 顶部导航栏 -->
    <el-header class="main-header">
      <TopNavbar />
    </el-header>
    
    <el-container>
      <!-- 侧边栏 -->
      <el-aside class="main-sidebar" :width="sidebarWidth">
        <SidebarMenu />
      </el-aside>
      
      <!-- 主内容区 -->
      <el-main class="main-content">
        <BreadcrumbNav />
        <router-view v-slot="{ Component }">
          <transition name="fade-transform" mode="out-in">
            <keep-alive :include="cachedViews">
              <component :is="Component" />
            </keep-alive>
          </transition>
        </router-view>
      </el-main>
    </el-container>
  </el-container>
</template>
```

### 2. 核心页面列表

#### 🏢 租户管理模块
```
/tenant
├── /dashboard              # 租户概览仪表板
├── /profile               # 租户信息管理
├── /users                 # 租户用户管理
├── /settings             # 租户设置
└── /billing              # 计费和使用统计
```

#### 📊 监控中心模块
```
/monitor
├── /dashboard            # 监控总览
├── /realtime             # 实时监控
├── /health               # 健康度分析
├── /statistics           # 统计报表
└── /rules                # 监控规则
```

#### 🚨 告警管理模块
```
/alert
├── /active               # 活跃告警
├── /history              # 告警历史
├── /rules                # 告警规则
├── /notifications        # 通知设置
└── /analytics            # 告警分析
```

#### 💼 账号管理模块
```
/account
├── /list                 # 账号列表
├── /create               # 创建账号
├── /detail/:id           # 账号详情
├── /batch                # 批量操作
└── /templates            # 账号模板
```

#### 🤖 自动运维模块
```
/autoops
├── /dashboard            # 运维概览
├── /recovery             # 故障恢复
├── /maintenance          # 预防维护
├── /policies             # 运维策略
└── /logs                 # 运维日志
```

#### ⚙️ 系统管理模块
```
/system
├── /users                # 用户管理
├── /roles                # 角色权限
├── /logs                 # 系统日志
├── /settings             # 系统设置
└── /about                # 关于系统
```

---

## 🧩 组件架构设计

### 1. 租户切换组件

```vue
<!-- TenantSwitcher.vue -->
<template>
  <el-dropdown trigger="click" @command="handleTenantSwitch">
    <span class="tenant-switcher">
      <el-icon><Building /></el-icon>
      {{ currentTenant?.name || '选择租户' }}
      <el-icon><ArrowDown /></el-icon>
    </span>
    <template #dropdown>
      <el-dropdown-menu>
        <el-dropdown-item 
          v-for="tenant in availableTenants" 
          :key="tenant.id"
          :command="tenant.id"
          :class="{ active: tenant.id === currentTenant?.id }"
        >
          <div class="tenant-item">
            <div class="tenant-info">
              <span class="tenant-name">{{ tenant.name }}</span>
              <span class="tenant-type">{{ tenant.type }}</span>
            </div>
            <el-tag v-if="tenant.id === currentTenant?.id" type="success" size="small">
              当前
            </el-tag>
          </div>
        </el-dropdown-item>
      </el-dropdown-menu>
    </template>
  </el-dropdown>
</template>
```

### 2. 权限控制组件

```vue
<!-- PermissionWrapper.vue -->
<template>
  <div v-if="hasPermission">
    <slot />
  </div>
  <div v-else-if="$slots.fallback" class="permission-fallback">
    <slot name="fallback" />
  </div>
</template>

<script setup lang="ts">
interface Props {
  permission?: string | string[]
  role?: string | string[]
  tenant?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  tenant: true
})

const hasPermission = computed(() => {
  return checkPermission(props.permission, props.role, props.tenant)
})
</script>
```

### 3. 监控图表组件

```vue
<!-- MonitorChart.vue -->
<template>
  <div class="monitor-chart">
    <div class="chart-header">
      <h3 class="chart-title">{{ title }}</h3>
      <div class="chart-actions">
        <el-button-group size="small">
          <el-button 
            v-for="period in timePeriods" 
            :key="period.value"
            :type="selectedPeriod === period.value ? 'primary' : ''"
            @click="handlePeriodChange(period.value)"
          >
            {{ period.label }}
          </el-button>
        </el-button-group>
        <el-button size="small" @click="refreshData">
          <el-icon><Refresh /></el-icon>
        </el-button>
      </div>
    </div>
    
    <div class="chart-content" :style="{ height: height }">
      <v-chart 
        ref="chartRef"
        :option="chartOption" 
        :loading="loading"
        @click="handleChartClick"
      />
    </div>
    
    <div v-if="showLegend" class="chart-legend">
      <div 
        v-for="item in legendData" 
        :key="item.name"
        class="legend-item"
        @click="toggleSeries(item.name)"
      >
        <span 
          class="legend-color" 
          :style="{ backgroundColor: item.color }"
        ></span>
        <span class="legend-label">{{ item.name }}</span>
        <span class="legend-value">{{ item.value }}</span>
      </div>
    </div>
  </div>
</template>
```

### 4. 告警列表组件

```vue
<!-- AlertList.vue -->
<template>
  <div class="alert-list">
    <!-- 过滤器 -->
    <div class="alert-filters">
      <el-form :model="filters" layout="inline">
        <el-form-item label="告警级别">
          <el-select v-model="filters.level" clearable>
            <el-option label="严重" value="critical" />
            <el-option label="错误" value="error" />
            <el-option label="警告" value="warning" />
            <el-option label="信息" value="info" />
          </el-select>
        </el-form-item>
        
        <el-form-item label="告警状态">
          <el-select v-model="filters.status" clearable>
            <el-option label="活跃" value="active" />
            <el-option label="已确认" value="acknowledged" />
            <el-option label="已解决" value="resolved" />
          </el-select>
        </el-form-item>
        
        <el-form-item label="时间范围">
          <el-date-picker
            v-model="filters.timeRange"
            type="datetimerange"
            range-separator="至"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
          />
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" @click="searchAlerts">
            <el-icon><Search /></el-icon>
            搜索
          </el-button>
          <el-button @click="resetFilters">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
    
    <!-- 批量操作 -->
    <div class="alert-actions">
      <el-button 
        :disabled="!selectedAlerts.length"
        @click="batchAcknowledge"
      >
        批量确认
      </el-button>
      <el-button 
        :disabled="!selectedAlerts.length"
        @click="batchResolve"
      >
        批量解决
      </el-button>
    </div>
    
    <!-- 告警表格 -->
    <el-table 
      :data="alerts" 
      @selection-change="handleSelectionChange"
      row-key="id"
    >
      <el-table-column type="selection" width="55" />
      
      <el-table-column label="告警级别" width="100">
        <template #default="{ row }">
          <el-tag :type="getAlertLevelType(row.level)">
            {{ row.levelText }}
          </el-tag>
        </template>
      </el-table-column>
      
      <el-table-column label="告警内容" min-width="300">
        <template #default="{ row }">
          <div class="alert-content">
            <div class="alert-title">{{ row.message }}</div>
            <div class="alert-meta">
              <span>账号: {{ row.accountName }}</span>
              <span>类型: {{ row.typeText }}</span>
            </div>
          </div>
        </template>
      </el-table-column>
      
      <el-table-column label="发生时间" width="180">
        <template #default="{ row }">
          {{ formatTime(row.firstOccurredAt) }}
        </template>
      </el-table-column>
      
      <el-table-column label="发生次数" width="100">
        <template #default="{ row }">
          <el-badge :value="row.occurrenceCount" :max="99">
            <span>次</span>
          </el-badge>
        </template>
      </el-table-column>
      
      <el-table-column label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="getAlertStatusType(row.status)">
            {{ row.statusText }}
          </el-tag>
        </template>
      </el-table-column>
      
      <el-table-column label="操作" width="200" fixed="right">
        <template #default="{ row }">
          <el-button 
            v-if="row.status === 'active'"
            size="small" 
            @click="acknowledgeAlert(row)"
          >
            确认
          </el-button>
          <el-button 
            v-if="row.status !== 'resolved'"
            size="small" 
            type="success"
            @click="resolveAlert(row)"
          >
            解决
          </el-button>
          <el-button 
            size="small" 
            type="info"
            @click="viewAlertDetail(row)"
          >
            详情
          </el-button>
        </template>
      </el-table-column>
    </el-table>
    
    <!-- 分页 -->
    <div class="alert-pagination">
      <el-pagination
        v-model:current-page="pagination.current"
        v-model:page-size="pagination.size"
        :total="pagination.total"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>
  </div>
</template>
```

---

## 🔐 路由权限设计

### 1. 路由配置

```typescript
// router/routes.ts
export const routes: RouteRecordRaw[] = [
  {
    path: '/',
    component: MainLayout,
    redirect: '/dashboard',
    children: [
      // 仪表板 - 所有角色可访问
      {
        path: '/dashboard',
        name: 'Dashboard',
        component: () => import('@/views/dashboard/index.vue'),
        meta: {
          title: '仪表板',
          icon: 'dashboard',
          roles: ['super_admin', 'tenant_admin', 'operator', 'customer_service', 'analyst']
        }
      },
      
      // 租户管理 - 仅超级管理员
      {
        path: '/tenant',
        name: 'TenantManagement',
        component: () => import('@/views/tenant/index.vue'),
        meta: {
          title: '租户管理',
          icon: 'building',
          roles: ['super_admin']
        },
        children: [
          {
            path: '/tenant/list',
            name: 'TenantList',
            component: () => import('@/views/tenant/list.vue'),
            meta: { title: '租户列表' }
          }
        ]
      },
      
      // 账号管理 - 租户管理员以上
      {
        path: '/account',
        name: 'AccountManagement',
        component: () => import('@/views/account/index.vue'),
        meta: {
          title: '账号管理',
          icon: 'user',
          roles: ['super_admin', 'tenant_admin', 'operator'],
          requireTenant: true
        },
        children: [
          {
            path: '/account/list',
            name: 'AccountList',
            component: () => import('@/views/account/list.vue'),
            meta: { title: '账号列表' }
          },
          {
            path: '/account/create',
            name: 'AccountCreate',
            component: () => import('@/views/account/create.vue'),
            meta: { 
              title: '创建账号',
              roles: ['super_admin', 'tenant_admin']
            }
          }
        ]
      },
      
      // 监控中心 - 所有角色可访问
      {
        path: '/monitor',
        name: 'MonitorCenter',
        component: () => import('@/views/monitor/index.vue'),
        meta: {
          title: '监控中心',
          icon: 'monitor',
          roles: ['super_admin', 'tenant_admin', 'operator', 'customer_service', 'analyst'],
          requireTenant: true
        }
      },
      
      // 告警管理 - 运维角色以上
      {
        path: '/alert',
        name: 'AlertManagement',
        component: () => import('@/views/alert/index.vue'),
        meta: {
          title: '告警管理',
          icon: 'warning',
          roles: ['super_admin', 'tenant_admin', 'operator'],
          requireTenant: true
        }
      },
      
      // 自动运维 - 租户管理员以上
      {
        path: '/autoops',
        name: 'AutoOps',
        component: () => import('@/views/autoops/index.vue'),
        meta: {
          title: '自动运维',
          icon: 'robot',
          roles: ['super_admin', 'tenant_admin'],
          requireTenant: true
        }
      }
    ]
  }
]
```

### 2. 权限守卫

```typescript
// router/permission.ts
router.beforeEach(async (to, from, next) => {
  const userStore = useUserStore()
  const tenantStore = useTenantStore()
  
  // 检查用户登录状态
  if (!userStore.token) {
    next('/login')
    return
  }
  
  // 获取用户信息
  if (!userStore.userInfo) {
    try {
      await userStore.getUserInfo()
    } catch (error) {
      next('/login')
      return
    }
  }
  
  // 检查角色权限
  const requiredRoles = to.meta?.roles as string[]
  if (requiredRoles && !hasRole(userStore.userInfo.roles, requiredRoles)) {
    next('/403')
    return
  }
  
  // 检查租户权限
  if (to.meta?.requireTenant) {
    if (!tenantStore.currentTenant) {
      next('/tenant/select')
      return
    }
  }
  
  next()
})
```

---

## 📊 数据流设计

### 1. 状态管理架构

```typescript
// stores/user.ts
export const useUserStore = defineStore('user', () => {
  const token = ref<string>('')
  const userInfo = ref<UserInfo | null>(null)
  const permissions = ref<string[]>([])
  
  const login = async (credentials: LoginCredentials) => {
    const response = await authApi.login(credentials)
    token.value = response.token
    await getUserInfo()
  }
  
  const getUserInfo = async () => {
    const response = await authApi.getUserInfo()
    userInfo.value = response.user
    permissions.value = response.permissions
  }
  
  return {
    token,
    userInfo,
    permissions,
    login,
    getUserInfo
  }
})

// stores/tenant.ts
export const useTenantStore = defineStore('tenant', () => {
  const currentTenant = ref<TenantInfo | null>(null)
  const availableTenants = ref<TenantInfo[]>([])
  
  const switchTenant = async (tenantId: string) => {
    await tenantApi.switchTenant(tenantId)
    currentTenant.value = availableTenants.value.find(t => t.id === tenantId) || null
    // 切换租户后重新加载相关数据
    await reloadTenantData()
  }
  
  return {
    currentTenant,
    availableTenants,
    switchTenant
  }
})

// stores/monitor.ts
export const useMonitorStore = defineStore('monitor', () => {
  const accountStats = ref<AccountStats | null>(null)
  const alertStats = ref<AlertStats | null>(null)
  const healthTrend = ref<HealthTrendData[]>([])
  
  const loadMonitorData = async () => {
    const [accountResponse, alertResponse, trendResponse] = await Promise.all([
      monitorApi.getAccountStats(),
      alertApi.getAlertStats(),
      monitorApi.getHealthTrend()
    ])
    
    accountStats.value = accountResponse.data
    alertStats.value = alertResponse.data
    healthTrend.value = trendResponse.data
  }
  
  return {
    accountStats,
    alertStats,
    healthTrend,
    loadMonitorData
  }
})
```

### 2. API 服务层

```typescript
// api/monitor.ts
export const monitorApi = {
  // 获取监控统计
  getAccountStats: (tenantId?: string) => 
    request.get<AccountStats>('/api/monitor/stats', { params: { tenantId } }),
  
  // 获取账号健康报告
  getAccountHealth: (accountId: string) =>
    request.get<AccountHealthReport>(`/api/monitor/account/${accountId}/health`),
  
  // 获取健康度趋势
  getHealthTrend: (params: HealthTrendParams) =>
    request.get<HealthTrendData[]>('/api/monitor/health-trend', { params }),
  
  // 实时监控数据
  getRealTimeData: () =>
    request.get<RealTimeData>('/api/monitor/realtime')
}

// api/alert.ts
export const alertApi = {
  // 获取告警列表
  getAlerts: (params: AlertQueryParams) =>
    request.get<PaginatedResponse<AlertInfo>>('/api/alerts', { params }),
  
  // 确认告警
  acknowledgeAlert: (alertId: string, userId: string) =>
    request.post(`/api/alerts/${alertId}/acknowledge`, { userId }),
  
  // 解决告警
  resolveAlert: (alertId: string, data: ResolveAlertData) =>
    request.post(`/api/alerts/${alertId}/resolve`, data),
  
  // 批量操作
  batchOperation: (alertIds: string[], operation: string, data?: any) =>
    request.post('/api/alerts/batch', { alertIds, operation, data })
}
```

---

## 🎨 UI/UX设计规范

### 1. 设计系统

```scss
// styles/variables.scss
:root {
  // 主色调
  --primary-color: #409EFF;
  --success-color: #67C23A;
  --warning-color: #E6A23C;
  --danger-color: #F56C6C;
  --info-color: #909399;
  
  // 租户主题色
  --tenant-primary: var(--primary-color);
  --tenant-secondary: #E6F7FF;
  
  // 告警级别色彩
  --alert-critical: #FF4D4F;
  --alert-error: #FF7A45;
  --alert-warning: #FFA940;
  --alert-info: #40A9FF;
  
  // 监控状态色彩
  --status-online: #52C41A;
  --status-offline: #FF4D4F;
  --status-warning: #FAAD14;
  
  // 间距
  --spacing-xs: 4px;
  --spacing-sm: 8px;
  --spacing-md: 16px;
  --spacing-lg: 24px;
  --spacing-xl: 32px;
  
  // 圆角
  --border-radius-sm: 4px;
  --border-radius-md: 8px;
  --border-radius-lg: 12px;
}
```

### 2. 组件样式规范

```scss
// styles/components.scss
.monitor-card {
  background: white;
  border-radius: var(--border-radius-md);
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  padding: var(--spacing-lg);
  margin-bottom: var(--spacing-md);
  
  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: var(--spacing-md);
    
    .card-title {
      font-size: 16px;
      font-weight: 600;
      color: #1f2937;
    }
  }
  
  .card-content {
    min-height: 200px;
  }
}

.status-indicator {
  display: inline-flex;
  align-items: center;
  gap: var(--spacing-xs);
  
  .status-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    
    &.online { background: var(--status-online); }
    &.offline { background: var(--status-offline); }
    &.warning { background: var(--status-warning); }
  }
}

.metric-item {
  text-align: center;
  padding: var(--spacing-md);
  
  .metric-value {
    font-size: 24px;
    font-weight: 600;
    margin-bottom: var(--spacing-xs);
    
    &.success { color: var(--success-color); }
    &.warning { color: var(--warning-color); }
    &.danger { color: var(--danger-color); }
  }
  
  .metric-label {
    font-size: 14px;
    color: #6b7280;
  }
}
```

### 3. 响应式设计

```scss
// styles/responsive.scss
.responsive-grid {
  display: grid;
  gap: var(--spacing-md);
  
  // 桌面端 (>=1200px)
  @media (min-width: 1200px) {
    grid-template-columns: repeat(4, 1fr);
  }
  
  // 平板端 (768px-1199px)
  @media (min-width: 768px) and (max-width: 1199px) {
    grid-template-columns: repeat(2, 1fr);
  }
  
  // 移动端 (<768px)
  @media (max-width: 767px) {
    grid-template-columns: 1fr;
  }
}

.mobile-hidden {
  @media (max-width: 767px) {
    display: none !important;
  }
}

.desktop-hidden {
  @media (min-width: 768px) {
    display: none !important;
  }
}
```

---

## 🔧 技术实现方案

### 1. 多租户支持

```typescript
// composables/useTenant.ts
export function useTenant() {
  const tenantStore = useTenantStore()
  
  const currentTenant = computed(() => tenantStore.currentTenant)
  
  const switchTenant = async (tenantId: string) => {
    await tenantStore.switchTenant(tenantId)
    // 刷新当前页面数据
    window.location.reload()
  }
  
  const getTenantTheme = computed(() => {
    if (!currentTenant.value) return {}
    
    return {
      '--tenant-primary': currentTenant.value.themeColor || '#409EFF',
      '--tenant-secondary': currentTenant.value.secondaryColor || '#E6F7FF'
    }
  })
  
  return {
    currentTenant,
    switchTenant,
    getTenantTheme
  }
}
```

### 2. 权限控制

```typescript
// composables/usePermission.ts
export function usePermission() {
  const userStore = useUserStore()
  
  const hasPermission = (permission: string | string[]) => {
    const permissions = userStore.permissions
    if (Array.isArray(permission)) {
      return permission.some(p => permissions.includes(p))
    }
    return permissions.includes(permission)
  }
  
  const hasRole = (role: string | string[]) => {
    const userRoles = userStore.userInfo?.roles || []
    if (Array.isArray(role)) {
      return role.some(r => userRoles.includes(r))
    }
    return userRoles.includes(role)
  }
  
  const canAccessTenant = (tenantId?: string) => {
    if (!tenantId) return true
    const userTenants = userStore.userInfo?.tenants || []
    return userTenants.includes(tenantId)
  }
  
  return {
    hasPermission,
    hasRole,
    canAccessTenant
  }
}
```

### 3. 实时数据更新

```typescript
// composables/useRealTimeData.ts
export function useRealTimeData(endpoint: string, interval = 30000) {
  const data = ref(null)
  const loading = ref(false)
  const error = ref(null)
  
  let timer: NodeJS.Timeout | null = null
  
  const fetchData = async () => {
    loading.value = true
    try {
      const response = await request.get(endpoint)
      data.value = response.data
      error.value = null
    } catch (err) {
      error.value = err
    } finally {
      loading.value = false
    }
  }
  
  const startPolling = () => {
    fetchData()
    timer = setInterval(fetchData, interval)
  }
  
  const stopPolling = () => {
    if (timer) {
      clearInterval(timer)
      timer = null
    }
  }
  
  onMounted(startPolling)
  onUnmounted(stopPolling)
  
  return {
    data,
    loading,
    error,
    refresh: fetchData,
    startPolling,
    stopPolling
  }
}
```

---

## 📱 页面功能详细设计

### 1. 监控仪表板页面

```vue
<!-- views/monitor/dashboard.vue -->
<template>
  <div class="monitor-dashboard">
    <!-- 概览指标 -->
    <div class="metrics-overview">
      <el-row :gutter="24">
        <el-col :span="6">
          <MetricCard
            title="总账号数"
            :value="monitorStats?.totalAccounts"
            :trend="accountTrend"
            color="primary"
          />
        </el-col>
        <el-col :span="6">
          <MetricCard
            title="在线账号"
            :value="monitorStats?.onlineAccounts"
            :trend="onlineTrend"
            color="success"
          />
        </el-col>
        <el-col :span="6">
          <MetricCard
            title="活跃告警"
            :value="alertStats?.activeAlerts"
            :trend="alertTrend"
            color="warning"
          />
        </el-col>
        <el-col :span="6">
          <MetricCard
            title="平均健康度"
            :value="monitorStats?.avgHealthScore"
            suffix="分"
            color="info"
          />
        </el-col>
      </el-row>
    </div>
    
    <!-- 图表区域 -->
    <el-row :gutter="24" class="chart-section">
      <el-col :span="12">
        <MonitorChart
          title="健康度趋势"
          :data="healthTrendData"
          type="line"
          height="300px"
        />
      </el-col>
      <el-col :span="12">
        <MonitorChart
          title="账号状态分布"
          :data="statusDistribution"
          type="doughnut"
          height="300px"
        />
      </el-col>
    </el-row>
    
    <el-row :gutter="24" class="chart-section">
      <el-col :span="12">
        <MonitorChart
          title="告警统计"
          :data="alertDistribution"
          type="bar"
          height="300px"
        />
      </el-col>
      <el-col :span="12">
        <MonitorChart
          title="API响应时间"
          :data="responseTimeData"
          type="area"
          height="300px"
        />
      </el-col>
    </el-row>
    
    <!-- 实时监控表格 -->
    <div class="realtime-monitor">
      <div class="section-header">
        <h3>实时监控</h3>
        <div class="header-actions">
          <el-button @click="refreshRealTimeData">
            <el-icon><Refresh /></el-icon>
            刷新
          </el-button>
          <el-switch
            v-model="autoRefresh"
            active-text="自动刷新"
          />
        </div>
      </div>
      
      <AccountMonitorTable
        :data="realTimeData"
        :loading="realTimeLoading"
        @view-detail="handleViewDetail"
        @quick-action="handleQuickAction"
      />
    </div>
  </div>
</template>
```

### 2. 告警管理页面

```vue
<!-- views/alert/index.vue -->
<template>
  <div class="alert-management">
    <!-- 告警统计卡片 -->
    <div class="alert-stats">
      <el-row :gutter="16">
        <el-col :span="6">
          <el-card class="stat-card critical">
            <div class="stat-content">
              <div class="stat-value">{{ alertStats?.criticalAlerts || 0 }}</div>
              <div class="stat-label">严重告警</div>
            </div>
            <el-icon class="stat-icon"><WarningFilled /></el-icon>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="stat-card error">
            <div class="stat-content">
              <div class="stat-value">{{ alertStats?.errorAlerts || 0 }}</div>
              <div class="stat-label">错误告警</div>
            </div>
            <el-icon class="stat-icon"><CircleCloseFilled /></el-icon>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="stat-card warning">
            <div class="stat-content">
              <div class="stat-value">{{ alertStats?.warningAlerts || 0 }}</div>
              <div class="stat-label">警告告警</div>
            </div>
            <el-icon class="stat-icon"><Warning /></el-icon>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="stat-card info">
            <div class="stat-content">
              <div class="stat-value">{{ alertStats?.infoAlerts || 0 }}</div>
              <div class="stat-label">信息告警</div>
            </div>
            <el-icon class="stat-icon"><InfoFilled /></el-icon>
          </el-card>
        </el-col>
      </el-row>
    </div>
    
    <!-- 告警列表 -->
    <el-card class="alert-list-card">
      <template #header>
        <div class="card-header">
          <span>告警列表</span>
          <div class="header-actions">
            <el-button type="primary" @click="createAlertRule">
              <el-icon><Plus /></el-icon>
              新增规则
            </el-button>
          </div>
        </div>
      </template>
      
      <AlertList
        ref="alertListRef"
        @alert-acknowledged="handleAlertAcknowledged"
        @alert-resolved="handleAlertResolved"
        @alert-detail="handleAlertDetail"
      />
    </el-card>
  </div>
</template>
```

---

## 🚀 实施计划

### 第一阶段：基础架构 (1-2周)
1. ✅ 搭建基础项目结构
2. ✅ 配置多租户路由和权限系统
3. ✅ 实现租户切换组件
4. ✅ 完成基础UI组件库

### 第二阶段：核心功能 (2-3周)
1. 📊 监控仪表板页面
2. 🚨 告警管理界面
3. 💼 账号管理功能
4. 📈 数据可视化组件

### 第三阶段：高级功能 (1-2周)
1. 🤖 自动运维界面
2. ⚙️ 系统配置管理
3. 📱 移动端适配
4. 🎨 主题定制功能

### 第四阶段：优化完善 (1周)
1. 🚀 性能优化
2. 🧪 测试完善
3. 📚 文档补充
4. 🐛 问题修复

---

## 💡 总结

这个前端设计方案具备以下特点：

### ✨ 核心优势
- **🏢 完整多租户支持**：租户切换、数据隔离、权限控制
- **📊 丰富数据可视化**：实时监控、趋势分析、状态展示
- **🎨 现代化UI设计**：响应式布局、组件化开发、主题定制
- **🔐 细粒度权限控制**：基于角色和租户的访问控制
- **⚡ 优秀的用户体验**：实时更新、智能提示、操作便捷

### 🎯 技术亮点
- **Vue 3 + TypeScript**：类型安全的现代化开发
- **Element Plus**：成熟的企业级UI组件库
- **Pinia**：轻量级状态管理
- **ECharts**：强大的数据可视化
- **组合式函数**：高度可复用的业务逻辑

这个设计方案将为企微监控平台提供一个功能完整、用户友好、可扩展的前端界面！

---

**🔄 请确认以上设计方案，我将开始具体的代码实现。**