<template>
  <div class="department-list">
    <div class="search-area">
      <el-form :model="searchForm" inline class="search-form">
        <el-form-item label="部门名称">
          <el-input
            v-model="searchForm.departmentName"
            placeholder="请输入部门名称"
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

    <div class="action-area">
      <el-button type="primary" @click="handleCreate">
        <el-icon><Plus /></el-icon>
        新增部门
      </el-button>
    </div>

    <div class="table-area">
      <el-table
        :data="tableData"
        :loading="loading"
        stripe
        border
        style="width: 100%"
      >
        <el-table-column prop="name" label="部门名称" width="200" />
        <el-table-column prop="leader" label="部门负责人" width="150" />
        <el-table-column prop="phone" label="联系电话" width="150" />
        <el-table-column prop="createdAt" label="创建时间" width="180" />
        <el-table-column label="操作" fixed="right" width="200">
          <template #default="{ row }">
            <el-button size="small" type="primary" link @click="handleEdit(row)">
              编辑
            </el-button>
            <el-button size="small" type="danger" link @click="handleDelete(row)">
              删除
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
import { Search, Plus } from '@element-plus/icons-vue'

const loading = ref(false)
const tableData = ref([])

const searchForm = reactive({
  departmentName: ''
})

const handleSearch = () => {
  fetchDepartmentList()
}

const handleReset = () => {
  searchForm.departmentName = ''
  fetchDepartmentList()
}

const handleCreate = () => {
  ElMessage.info('创建部门功能待实现')
}

const handleEdit = (row: any) => {
  ElMessage.info(`编辑部门：${row.name}`)
}

const handleDelete = async (row: any) => {
  try {
    await ElMessageBox.confirm(`确定要删除部门 "${row.name}" 吗？`, '删除确认', {
      type: 'warning'
    })
    ElMessage.success('删除成功')
    fetchDepartmentList()
  } catch (error) {
    // 用户取消
  }
}

const fetchDepartmentList = async () => {
  loading.value = true
  try {
    setTimeout(() => {
      tableData.value = [
        {
          id: '1',
          name: '技术部',
          leader: '张三',
          phone: '138****1234',
          createdAt: '2024-01-01 10:00:00'
        }
      ] as any
      loading.value = false
    }, 1000)
  } catch (error) {
    ElMessage.error('获取部门列表失败')
    loading.value = false
  }
}

onMounted(() => {
  fetchDepartmentList()
})
</script>

<style lang="scss" scoped>
.department-list {
  padding: 20px;

  .search-area {
    margin-bottom: 20px;
    padding: 20px;
    background: #fff;
    border-radius: 4px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }

  .action-area {
    margin-bottom: 20px;
  }

  .table-area {
    background: #fff;
    padding: 20px;
    border-radius: 4px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }
}
</style>