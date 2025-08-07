<template>
  <div class="online-users">
    <div class="search-area">
      <el-form :model="searchForm" inline class="search-form">
        <el-form-item label="用户名">
          <el-input
            v-model="searchForm.username"
            placeholder="请输入用户名"
            clearable
          />
        </el-form-item>
        <el-form-item label="部门">
          <el-select
            v-model="searchForm.department"
            placeholder="请选择部门"
            clearable
          >
            <el-option label="技术部" value="tech" />
            <el-option label="产品部" value="product" />
            <el-option label="运营部" value="operation" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon>
            搜索
          </el-button>
          <el-button @click="handleReset">重置</el-button>
          <el-button type="success" @click="fetchOnlineUsers">
            <el-icon><Refresh /></el-icon>
            刷新
          </el-button>
        </el-form-item>
      </el-form>
    </div>

    <div class="stats-area">
      <el-row :gutter="20">
        <el-col :span="6">
          <el-card class="stats-card">
            <div class="stats-content">
              <div class="stats-icon online">
                <el-icon><User /></el-icon>
              </div>
              <div class="stats-info">
                <div class="stats-value">{{ onlineCount }}</div>
                <div class="stats-label">在线用户</div>
              </div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="stats-card">
            <div class="stats-content">
              <div class="stats-icon total">
                <el-icon><UserFilled /></el-icon>
              </div>
              <div class="stats-info">
                <div class="stats-value">{{ totalCount }}</div>
                <div class="stats-label">总用户数</div>
              </div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="stats-card">
            <div class="stats-content">
              <div class="stats-icon rate">
                <el-icon><TrendCharts /></el-icon>
              </div>
              <div class="stats-info">
                <div class="stats-value">{{ onlineRate }}%</div>
                <div class="stats-label">在线率</div>
              </div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="stats-card">
            <div class="stats-content">
              <div class="stats-icon today">
                <el-icon><Calendar /></el-icon>
              </div>
              <div class="stats-info">
                <div class="stats-value">{{ todayLoginCount }}</div>
                <div class="stats-label">今日登录</div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <div class="table-area">
      <el-table
        :data="tableData"
        :loading="loading"
        stripe
        border
        style="width: 100%"
      >
        <el-table-column prop="username" label="用户名" width="120" />
        <el-table-column prop="realName" label="真实姓名" width="100" />
        <el-table-column prop="department" label="部门" width="120" />
        <el-table-column prop="role" label="角色" width="100">
          <template #default="{ row }">
            <el-tag :type="getRoleColor(row.role)">
              {{ getRoleText(row.role) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="loginTime" label="登录时间" width="180" />
        <el-table-column prop="lastActiveTime" label="最后活跃时间" width="180" />
        <el-table-column prop="ip" label="IP地址" width="130" />
        <el-table-column prop="location" label="登录地点" width="150" />
        <el-table-column prop="device" label="设备信息" min-width="200" show-overflow-tooltip />
        <el-table-column prop="onlineDuration" label="在线时长" width="120" />
        <el-table-column label="操作" fixed="right" width="120">
          <template #default="{ row }">
            <el-button
              size="small"
              type="danger"
              link
              @click="handleForceLogout(row)"
            >
              强制下线
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
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted, onUnmounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search, Refresh, User, UserFilled, TrendCharts, Calendar } from '@element-plus/icons-vue'

// 响应式数据
const loading = ref(false)
const tableData = ref([])
let refreshTimer: any = null

// 搜索表单
const searchForm = reactive({
  username: '',
  department: ''
})

// 分页
const pagination = reactive({
  pageNum: 1,
  pageSize: 20,
  total: 0
})

// 统计数据
const onlineCount = ref(0)
const totalCount = ref(0)
const todayLoginCount = ref(0)

// 计算属性
const onlineRate = computed(() => {
  if (totalCount.value === 0) return 0
  return Math.round((onlineCount.value / totalCount.value) * 100)
})

// 方法
const handleSearch = () => {
  pagination.pageNum = 1
  fetchOnlineUsers()
}

const handleReset = () => {
  searchForm.username = ''
  searchForm.department = ''
  pagination.pageNum = 1
  fetchOnlineUsers()
}

const handleForceLogout = async (row: any) => {
  try {
    await ElMessageBox.confirm(
      `确定要强制用户 "${row.username}" 下线吗？`,
      '强制下线确认',
      {
        type: 'warning',
        confirmButtonText: '确定',
        cancelButtonText: '取消'
      }
    )
    
    // 模拟强制下线操作
    ElMessage.success('用户已强制下线')
    fetchOnlineUsers()
  } catch (error) {
    // 用户取消
  }
}

const handlePageChange = (page: number) => {
  pagination.pageNum = page
  fetchOnlineUsers()
}

const handleSizeChange = (size: number) => {
  pagination.pageSize = size
  pagination.pageNum = 1
  fetchOnlineUsers()
}

const getRoleText = (role: string) => {
  const roleMap: Record<string, string> = {
    admin: '管理员',
    user: '普通用户',
    manager: '经理',
    operator: '操作员'
  }
  return roleMap[role] || role
}

const getRoleColor = (role: string) => {
  const colorMap: Record<string, string> = {
    admin: 'danger',
    manager: 'warning',
    operator: 'success',
    user: 'info'
  }
  return colorMap[role] || 'info'
}

const fetchOnlineUsers = async () => {
  loading.value = true
  try {
    // 模拟数据
    setTimeout(() => {
      tableData.value = [
        {
          id: '1',
          username: 'admin',
          realName: '管理员',
          department: '技术部',
          role: 'admin',
          loginTime: '2024-01-01 09:00:00',
          lastActiveTime: '2024-01-01 10:30:00',
          ip: '192.168.1.100',
          location: '北京市',
          device: 'Chrome 120.0.0.0 / macOS',
          onlineDuration: '1小时30分钟'
        },
        {
          id: '2',
          username: 'user001',
          realName: '张三',
          department: '产品部',
          role: 'user',
          loginTime: '2024-01-01 08:30:00',
          lastActiveTime: '2024-01-01 10:25:00',
          ip: '192.168.1.101',
          location: '上海市',
          device: 'Chrome 120.0.0.0 / Windows',
          onlineDuration: '1小时55分钟'
        }
      ] as any
      
      // 统计数据
      onlineCount.value = 2
      totalCount.value = 10
      todayLoginCount.value = 5
      pagination.total = 2
      
      loading.value = false
    }, 1000)
  } catch (error) {
    ElMessage.error('获取在线用户失败')
    loading.value = false
  }
}

// 自动刷新
const startAutoRefresh = () => {
  refreshTimer = setInterval(() => {
    fetchOnlineUsers()
  }, 30000) // 30秒刷新一次
}

const stopAutoRefresh = () => {
  if (refreshTimer) {
    clearInterval(refreshTimer)
    refreshTimer = null
  }
}

// 生命周期
onMounted(() => {
  fetchOnlineUsers()
  startAutoRefresh()
})

onUnmounted(() => {
  stopAutoRefresh()
})
</script>

<style lang="scss" scoped>
.online-users {
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

  .stats-area {
    margin-bottom: 20px;

    .stats-card {
      .stats-content {
        display: flex;
        align-items: center;
        padding: 10px 0;

        .stats-icon {
          width: 60px;
          height: 60px;
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          margin-right: 15px;
          font-size: 24px;
          color: #fff;

          &.online {
            background: linear-gradient(135deg, #67c23a, #85ce61);
          }

          &.total {
            background: linear-gradient(135deg, #409eff, #66b1ff);
          }

          &.rate {
            background: linear-gradient(135deg, #e6a23c, #ebb563);
          }

          &.today {
            background: linear-gradient(135deg, #f56c6c, #f78989);
          }
        }

        .stats-info {
          flex: 1;

          .stats-value {
            font-size: 24px;
            font-weight: bold;
            color: #303133;
            line-height: 1;
          }

          .stats-label {
            font-size: 14px;
            color: #909399;
            margin-top: 5px;
          }
        }
      }
    }
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