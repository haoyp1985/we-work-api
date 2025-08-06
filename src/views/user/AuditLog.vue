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
        <el-table-column prop="description" label="操作描述" min-width="200" />
        <el-table-column prop="createdAt" label="操作时间" width="180" />
      </el-table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Search } from '@element-plus/icons-vue'

const loading = ref(false)
const tableData = ref([])

const searchForm = reactive({
  operator: '',
  actionType: ''
})

const handleSearch = () => {
  fetchAuditLogs()
}

const handleReset = () => {
  searchForm.operator = ''
  searchForm.actionType = ''
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
    setTimeout(() => {
      tableData.value = [
        {
          id: '1',
          operator: 'admin',
          actionType: 'login',
          description: '用户登录系统',
          createdAt: '2024-01-01 10:00:00'
        }
      ] as any
      loading.value = false
    }, 1000)
  } catch (error) {
    ElMessage.error('获取审计日志失败')
    loading.value = false
  }
}

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
  }

  .table-area {
    background: #fff;
    padding: 20px;
    border-radius: 4px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }
}
</style>