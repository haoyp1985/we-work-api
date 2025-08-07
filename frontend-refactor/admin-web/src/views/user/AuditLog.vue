<template>
  <div class="audit-log">
    <div class="search-area">
      <el-form :model="searchForm" inline class="search-form">
        <el-form-item label="操作人">
          <el-input
            v-model="searchForm.operator"
            placeholder="请输入操作人"
            clearable
          />
        </el-form-item>
        <el-form-item label="操作类型">
          <el-select
            v-model="searchForm.actionType"
            placeholder="请选择操作类型"
            clearable
          >
            <el-option label="登录" value="login" />
            <el-option label="登出" value="logout" />
            <el-option label="创建" value="create" />
            <el-option label="更新" value="update" />
            <el-option label="删除" value="delete" />
          </el-select>
        </el-form-item>
        <el-form-item label="时间范围">
          <el-date-picker
            v-model="searchForm.dateRange"
            type="datetimerange"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
            format="YYYY-MM-DD HH:mm:ss"
            value-format="YYYY-MM-DD HH:mm:ss"
          />
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

    <div class="table-area">
      <el-table
        :data="tableData"
        :loading="loading"
        stripe
        border
        style="width: 100%"
      >
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="operator" label="操作人" width="120" />
        <el-table-column prop="actionType" label="操作类型" width="100">
          <template #default="{ row }">
            <el-tag :type="getActionTypeColor(row.actionType)">
              {{ getActionTypeText(row.actionType) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="resource" label="操作资源" width="150" />
        <el-table-column prop="description" label="操作描述" min-width="200" />
        <el-table-column prop="ip" label="IP地址" width="130" />
        <el-table-column prop="userAgent" label="用户代理" width="200" show-overflow-tooltip />
        <el-table-column prop="result" label="操作结果" width="100">
          <template #default="{ row }">
            <el-tag :type="row.result === 'success' ? 'success' : 'danger'">
              {{ row.result === 'success' ? '成功' : '失败' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="操作时间" width="180" />
        <el-table-column label="操作" fixed="right" width="100">
          <template #default="{ row }">
            <el-button size="small" type="primary" link @click="handleDetail(row)">
              详情
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

    <!-- 详情对话框 -->
    <el-dialog
      v-model="detailVisible"
      title="审计日志详情"
      width="60%"
    >
      <el-descriptions :column="2" border>
        <el-descriptions-item label="操作ID">{{ currentLog.id }}</el-descriptions-item>
        <el-descriptions-item label="操作人">{{ currentLog.operator }}</el-descriptions-item>
        <el-descriptions-item label="操作类型">{{ getActionTypeText(currentLog.actionType) }}</el-descriptions-item>
        <el-descriptions-item label="操作资源">{{ currentLog.resource }}</el-descriptions-item>
        <el-descriptions-item label="操作描述" :span="2">{{ currentLog.description }}</el-descriptions-item>
        <el-descriptions-item label="IP地址">{{ currentLog.ip }}</el-descriptions-item>
        <el-descriptions-item label="操作结果">{{ currentLog.result === 'success' ? '成功' : '失败' }}</el-descriptions-item>
        <el-descriptions-item label="用户代理" :span="2">{{ currentLog.userAgent }}</el-descriptions-item>
        <el-descriptions-item label="操作时间">{{ currentLog.createdAt }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Search } from '@element-plus/icons-vue'

// 响应式数据
const loading = ref(false)
const tableData = ref([])
const detailVisible = ref(false)
const currentLog = ref({} as any)

// 搜索表单
const searchForm = reactive({
  operator: '',
  actionType: '',
  dateRange: null as any
})

// 分页
const pagination = reactive({
  pageNum: 1,
  pageSize: 20,
  total: 0
})

// 方法
const handleSearch = () => {
  pagination.pageNum = 1
  fetchAuditLogs()
}

const handleReset = () => {
  searchForm.operator = ''
  searchForm.actionType = ''
  searchForm.dateRange = null
  pagination.pageNum = 1
  fetchAuditLogs()
}

const handleDetail = (row: any) => {
  currentLog.value = row
  detailVisible.value = true
}

const handlePageChange = (page: number) => {
  pagination.pageNum = page
  fetchAuditLogs()
}

const handleSizeChange = (size: number) => {
  pagination.pageSize = size
  pagination.pageNum = 1
  fetchAuditLogs()
}

const getActionTypeText = (type: string) => {
  const typeMap: Record<string, string> = {
    login: '登录',
    logout: '登出',
    create: '创建',
    update: '更新',
    delete: '删除'
  }
  return typeMap[type] || type
}

const getActionTypeColor = (type: string) => {
  const colorMap: Record<string, string> = {
    login: 'success',
    logout: 'info',
    create: 'primary',
    update: 'warning',
    delete: 'danger'
  }
  return colorMap[type] || 'info'
}

const fetchAuditLogs = async () => {
  loading.value = true
  try {
    // 模拟数据
    setTimeout(() => {
      tableData.value = [
        {
          id: '1',
          operator: 'admin',
          actionType: 'login',
          resource: '系统',
          description: '用户登录系统',
          ip: '192.168.1.100',
          userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)',
          result: 'success',
          createdAt: '2024-01-01 10:00:00'
        },
        {
          id: '2',
          operator: 'admin',
          actionType: 'create',
          resource: '账号管理',
          description: '创建新账号',
          ip: '192.168.1.100',
          userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)',
          result: 'success',
          createdAt: '2024-01-01 10:05:00'
        }
      ] as any
      pagination.total = 2
      loading.value = false
    }, 1000)
  } catch (error) {
    ElMessage.error('获取审计日志失败')
    loading.value = false
  }
}

// 生命周期
onMounted(() => {
  fetchAuditLogs()
})
</script>

<style lang="scss" scoped>
.audit-log {
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