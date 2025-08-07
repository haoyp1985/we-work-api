<template>
  <div class="department-list">
    <div class="search-area">
      <el-form :model="searchForm" inline class="search-form">
        <el-form-item label="部门名称">
          <el-input
            v-model="searchForm.departmentName"
            placeholder="请输入部门名称"
            clearable
            @keyup.enter="handleSearch"
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
        <el-table-column prop="parentName" label="上级部门" width="200" />
        <el-table-column prop="leader" label="部门负责人" width="150" />
        <el-table-column prop="phone" label="联系电话" width="150" />
        <el-table-column prop="email" label="邮箱" width="200" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 'active' ? 'success' : 'danger'">
              {{ row.status === 'active' ? '正常' : '停用' }}
            </el-tag>
          </template>
        </el-table-column>
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
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search, Plus } from '@element-plus/icons-vue'

// 响应式数据
const loading = ref(false)
const tableData = ref([])

// 搜索表单
const searchForm = reactive({
  departmentName: ''
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
  fetchDepartmentList()
}

const handleReset = () => {
  searchForm.departmentName = ''
  pagination.pageNum = 1
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

const handlePageChange = (page: number) => {
  pagination.pageNum = page
  fetchDepartmentList()
}

const handleSizeChange = (size: number) => {
  pagination.pageSize = size
  pagination.pageNum = 1
  fetchDepartmentList()
}

const fetchDepartmentList = async () => {
  loading.value = true
  try {
    // 模拟数据
    setTimeout(() => {
      tableData.value = [
        {
          id: '1',
          name: '技术部',
          parentName: '总部',
          leader: '张三',
          phone: '138****1234',
          email: 'tech@company.com',
          status: 'active',
          createdAt: '2024-01-01 10:00:00'
        }
      ] as any
      pagination.total = 1
      loading.value = false
    }, 1000)
  } catch (error) {
    ElMessage.error('获取部门列表失败')
    loading.value = false
  }
}

// 生命周期
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

    .pagination-area {
      margin-top: 20px;
      text-align: right;
    }
  }
}
</style>