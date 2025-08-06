<template>
  <div class="role-list">
    <div class="search-area">
      <el-form :model="searchForm" inline class="search-form">
        <el-form-item label="角色名称">
          <el-input
            v-model="searchForm.roleName"
            placeholder="请输入角色名称"
            clearable
          />
        </el-form-item>
        <el-form-item label="状态">
          <el-select
            v-model="searchForm.status"
            placeholder="请选择状态"
            clearable
          >
            <el-option label="启用" value="enabled" />
            <el-option label="禁用" value="disabled" />
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

    <div class="action-area">
      <el-button type="primary" @click="handleCreate">
        <el-icon><Plus /></el-icon>
        新增角色
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
        <el-table-column prop="name" label="角色名称" width="150" />
        <el-table-column prop="code" label="角色编码" width="150" />
        <el-table-column prop="description" label="角色描述" min-width="200" />
        <el-table-column prop="userCount" label="用户数量" width="100" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-switch
              v-model="row.status"
              active-value="enabled"
              inactive-value="disabled"
              @change="handleStatusChange(row)"
            />
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="创建时间" width="180" />
        <el-table-column label="操作" fixed="right" width="250">
          <template #default="{ row }">
            <el-button size="small" type="primary" link @click="handleEdit(row)">
              编辑
            </el-button>
            <el-button size="small" type="success" link @click="handlePermission(row)">
              权限配置
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

    <!-- 角色表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogMode === 'create' ? '新增角色' : '编辑角色'"
      width="600px"
    >
      <el-form
        ref="formRef"
        :model="formData"
        :rules="formRules"
        label-width="100px"
      >
        <el-form-item label="角色名称" prop="name">
          <el-input v-model="formData.name" placeholder="请输入角色名称" />
        </el-form-item>
        <el-form-item label="角色编码" prop="code">
          <el-input
            v-model="formData.code"
            placeholder="请输入角色编码"
            :disabled="dialogMode === 'edit'"
          />
        </el-form-item>
        <el-form-item label="角色描述" prop="description">
          <el-input
            v-model="formData.description"
            type="textarea"
            :rows="3"
            placeholder="请输入角色描述"
          />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="formData.status">
            <el-radio value="enabled">启用</el-radio>
            <el-radio value="disabled">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitting">
          确定
        </el-button>
      </template>
    </el-dialog>

    <!-- 权限配置对话框 -->
    <el-dialog v-model="permissionVisible" title="权限配置" width="800px">
      <div class="permission-tree-area">
        <el-tree
          ref="permissionTreeRef"
          :data="permissionTree"
          :props="treeProps"
          show-checkbox
          node-key="id"
          :default-expand-all="true"
          :check-strictly="false"
        />
      </div>
      <template #footer>
        <el-button @click="permissionVisible = false">取消</el-button>
        <el-button type="primary" @click="handlePermissionSubmit" :loading="permissionSubmitting">
          保存权限
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search, Plus } from '@element-plus/icons-vue'

// 响应式数据
const loading = ref(false)
const submitting = ref(false)
const permissionSubmitting = ref(false)
const tableData = ref([])
const dialogVisible = ref(false)
const permissionVisible = ref(false)
const dialogMode = ref<'create' | 'edit'>('create')
const formRef = ref()
const permissionTreeRef = ref()
const currentRole = ref({} as any)

// 搜索表单
const searchForm = reactive({
  roleName: '',
  status: ''
})

// 分页
const pagination = reactive({
  pageNum: 1,
  pageSize: 20,
  total: 0
})

// 表单数据
const formData = reactive({
  id: '',
  name: '',
  code: '',
  description: '',
  status: 'enabled'
})

// 表单验证规则
const formRules = {
  name: [{ required: true, message: '请输入角色名称', trigger: 'blur' }],
  code: [{ required: true, message: '请输入角色编码', trigger: 'blur' }],
  description: [{ required: true, message: '请输入角色描述', trigger: 'blur' }]
}

// 权限树配置
const treeProps = {
  children: 'children',
  label: 'name'
}

// 权限树数据
const permissionTree = ref([
  {
    id: '1',
    name: '用户管理',
    children: [
      { id: '1-1', name: '用户列表' },
      { id: '1-2', name: '用户新增' },
      { id: '1-3', name: '用户编辑' },
      { id: '1-4', name: '用户删除' }
    ]
  },
  {
    id: '2',
    name: '角色管理',
    children: [
      { id: '2-1', name: '角色列表' },
      { id: '2-2', name: '角色新增' },
      { id: '2-3', name: '角色编辑' },
      { id: '2-4', name: '角色删除' }
    ]
  },
  {
    id: '3',
    name: '系统管理',
    children: [
      { id: '3-1', name: '系统配置' },
      { id: '3-2', name: '日志查看' },
      { id: '3-3', name: '监控管理' }
    ]
  }
])

// 方法
const handleSearch = () => {
  pagination.pageNum = 1
  fetchRoleList()
}

const handleReset = () => {
  searchForm.roleName = ''
  searchForm.status = ''
  pagination.pageNum = 1
  fetchRoleList()
}

const handleCreate = () => {
  dialogMode.value = 'create'
  resetForm()
  dialogVisible.value = true
}

const handleEdit = (row: any) => {
  dialogMode.value = 'edit'
  Object.assign(formData, row)
  dialogVisible.value = true
}

const handleDelete = async (row: any) => {
  try {
    await ElMessageBox.confirm(`确定要删除角色 "${row.name}" 吗？`, '删除确认', {
      type: 'warning'
    })
    ElMessage.success('删除成功')
    fetchRoleList()
  } catch (error) {
    // 用户取消
  }
}

const handlePermission = (row: any) => {
  currentRole.value = row
  permissionVisible.value = true
  // 模拟设置已有权限
  setTimeout(() => {
    if (permissionTreeRef.value) {
      permissionTreeRef.value.setCheckedKeys(['1-1', '1-2', '2-1'])
    }
  }, 100)
}

const handleStatusChange = async (row: any) => {
  try {
    ElMessage.success(`角色状态已${row.status === 'enabled' ? '启用' : '禁用'}`)
  } catch (error) {
    ElMessage.error('状态修改失败')
    // 回滚状态
    row.status = row.status === 'enabled' ? 'disabled' : 'enabled'
  }
}

const handleSubmit = async () => {
  try {
    await formRef.value.validate()
    submitting.value = true
    
    // 模拟提交
    setTimeout(() => {
      ElMessage.success(dialogMode.value === 'create' ? '创建成功' : '更新成功')
      dialogVisible.value = false
      submitting.value = false
      fetchRoleList()
    }, 1000)
  } catch (error) {
    console.error('表单验证失败:', error)
  }
}

const handlePermissionSubmit = async () => {
  permissionSubmitting.value = true
  try {
    const checkedKeys = permissionTreeRef.value.getCheckedKeys()
    console.log('选中的权限:', checkedKeys)
    
    // 模拟保存权限
    setTimeout(() => {
      ElMessage.success('权限配置保存成功')
      permissionVisible.value = false
      permissionSubmitting.value = false
    }, 1000)
  } catch (error) {
    ElMessage.error('权限配置保存失败')
    permissionSubmitting.value = false
  }
}

const resetForm = () => {
  formData.id = ''
  formData.name = ''
  formData.code = ''
  formData.description = ''
  formData.status = 'enabled'
}

const handlePageChange = (page: number) => {
  pagination.pageNum = page
  fetchRoleList()
}

const handleSizeChange = (size: number) => {
  pagination.pageSize = size
  pagination.pageNum = 1
  fetchRoleList()
}

const fetchRoleList = async () => {
  loading.value = true
  try {
    // 模拟数据
    setTimeout(() => {
      tableData.value = [
        {
          id: '1',
          name: '超级管理员',
          code: 'SUPER_ADMIN',
          description: '系统超级管理员，拥有所有权限',
          userCount: 1,
          status: 'enabled',
          createdAt: '2024-01-01 10:00:00'
        },
        {
          id: '2',
          name: '普通用户',
          code: 'USER',
          description: '普通用户角色',
          userCount: 25,
          status: 'enabled',
          createdAt: '2024-01-01 10:05:00'
        }
      ] as any
      pagination.total = 2
      loading.value = false
    }, 1000)
  } catch (error) {
    ElMessage.error('获取角色列表失败')
    loading.value = false
  }
}

// 生命周期
onMounted(() => {
  fetchRoleList()
})
</script>

<style lang="scss" scoped>
.role-list {
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

  .permission-tree-area {
    max-height: 400px;
    overflow-y: auto;
    border: 1px solid #dcdfe6;
    border-radius: 4px;
    padding: 10px;
  }
}
</style>