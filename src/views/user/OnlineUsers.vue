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
        <el-form-item>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon>
            搜索
          </el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <div class="stats-area">
      <el-row :gutter="20">
        <el-col :span="6">
          <el-card class="stats-card">
            <div class="stats-content">
              <div class="stats-value">{{ onlineCount }}</div>
              <div class="stats-label">在线用户</div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="stats-card">
            <div class="stats-content">
              <div class="stats-value">{{ totalCount }}</div>
              <div class="stats-label">总用户数</div>
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
        <el-table-column prop="loginTime" label="登录时间" width="180" />
        <el-table-column prop="ip" label="IP地址" width="130" />
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
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search } from '@element-plus/icons-vue'

const loading = ref(false)
const tableData = ref([])

const searchForm = reactive({
  username: ''
})

const onlineCount = ref(0)
const totalCount = ref(0)

const handleSearch = () => {
  fetchOnlineUsers()
}

const handleReset = () => {
  searchForm.username = ''
  fetchOnlineUsers()
}

const handleForceLogout = async (row: any) => {
  try {
    await ElMessageBox.confirm(
      `确定要强制用户 "${row.username}" 下线吗？`,
      '强制下线确认',
      {
        type: 'warning'
      }
    )
    ElMessage.success('用户已强制下线')
    fetchOnlineUsers()
  } catch (error) {
    // 用户取消
  }
}

const fetchOnlineUsers = async () => {
  loading.value = true
  try {
    setTimeout(() => {
      tableData.value = [
        {
          id: '1',
          username: 'admin',
          realName: '管理员',
          loginTime: '2024-01-01 09:00:00',
          ip: '192.168.1.100'
        }
      ] as any
      
      onlineCount.value = 1
      totalCount.value = 10
      loading.value = false
    }, 1000)
  } catch (error) {
    ElMessage.error('获取在线用户失败')
    loading.value = false
  }
}

onMounted(() => {
  fetchOnlineUsers()
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
  }

  .stats-area {
    margin-bottom: 20px;

    .stats-card {
      .stats-content {
        padding: 20px;
        text-align: center;

        .stats-value {
          font-size: 32px;
          font-weight: bold;
          color: #409eff;
        }

        .stats-label {
          font-size: 14px;
          color: #909399;
          margin-top: 10px;
        }
      }
    }
  }

  .table-area {
    background: #fff;
    padding: 20px;
    border-radius: 4px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }
}
</style>