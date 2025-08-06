<template>
  <div class="permission-list">
    <div class="search-area">
      <el-form :model="searchForm" inline class="search-form">
        <el-form-item label="权限名称">
          <el-input
            v-model="searchForm.permissionName"
            placeholder="请输入权限名称"
            clearable
          />
        </el-form-item>
        <el-form-item label="权限类型">
          <el-select
            v-model="searchForm.type"
            placeholder="请选择权限类型"
            clearable
          >
            <el-option label="菜单权限" value="menu" />
            <el-option label="按钮权限" value="button" />
            <el-option label="接口权限" value="api" />
          </el-select>
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
        新增权限
      </el-button>
      <el-button type="success" @click="expandAll">
        <el-icon><Sort /></el-icon>
        展开全部
      </el-button>
      <el-button type="info" @click="collapseAll">
        <el-icon><Fold /></el-icon>
        收起全部
      </el-button>
    </div>

    <div class="table-area">
      <el-table
        ref="tableRef"
        :data="tableData"
        :loading="loading"
        stripe
        border
        row-key="id"
        :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
        style="width: 100%"
      >
        <el-table-column prop="name" label="权限名称" width="200" />
        <el-table-column prop="code" label="权限编码" width="200" />
        <el-table-column prop="type" label="权限类型" width="120">
          <template #default="{ row }">
            <el-tag :type="getPermissionTypeColor(row.type)">
              {{ getPermissionTypeName(row.type) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="path" label="路径/接口" width="250" show-overflow-tooltip />
        <el-table-column prop="icon" label="图标" width="80">
          <template #default="{ row }">
            <el-icon v-if="row.icon">
              <component :is="row.icon" />
            </el-icon>
          </template>
        </el-table-column>
        <el-table-column prop="sort" label="排序" width="80" />
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
        <el-table-column prop="description" label="描述" min-width="150" show-overflow-tooltip />
        <el-table-column label="操作" fixed="right" width="200">
          <template #default="{ row }">
            <el-button size="small" type="primary" link @click="handleEdit(row)">
              编辑
            </el-button>
            <el-button 
              v-if="row.type === 'menu'" 
              size="small" 
              type="success" 
              link 
              @click="handleAddChild(row)"
            >
              添加子权限
            </el-button>
            <el-button size="small" type="danger" link @click="handleDelete(row)">
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 权限表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogMode === 'create' ? '新增权限' : '编辑权限'"
      width="700px"
    >
      <el-form
        ref="formRef"
        :model="formData"
        :rules="formRules"
        label-width="120px"
      >
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="权限名称" prop="name">
              <el-input v-model="formData.name" placeholder="请输入权限名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="权限编码" prop="code">
              <el-input v-model="formData.code" placeholder="请输入权限编码" />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="权限类型" prop="type">
              <el-select v-model="formData.type" placeholder="请选择权限类型" @change="handleTypeChange">
                <el-option label="菜单权限" value="menu" />
                <el-option label="按钮权限" value="button" />
                <el-option label="接口权限" value="api" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="上级权限">
              <el-tree-select
                v-model="formData.parentId"
                :data="permissionTree"
                :render-after-expand="false"
                placeholder="请选择上级权限"
                check-strictly
                :props="{
                  value: 'id',
                  label: 'name',
                  children: 'children'
                }"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="路径/接口" prop="path">
              <el-input 
                v-model="formData.path" 
                :placeholder="formData.type === 'api' ? '请输入接口路径' : '请输入路由路径'" 
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="图标" v-if="formData.type === 'menu'">
              <el-input v-model="formData.icon" placeholder="请输入图标名称" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="排序">
              <el-input-number v-model="formData.sort" :min="0" placeholder="排序值" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态">
              <el-radio-group v-model="formData.status">
                <el-radio value="enabled">启用</el-radio>
                <el-radio value="disabled">禁用</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="描述">
          <el-input
            v-model="formData.description"
            type="textarea"
            :rows="3"
            placeholder="请输入权限描述"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitting">
          确定
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search, Plus, Sort, Fold } from '@element-plus/icons-vue'

// 响应式数据
const loading = ref(false)
const submitting = ref(false)
const tableData = ref([])
const dialogVisible = ref(false)
const dialogMode = ref<'create' | 'edit'>('create')
const formRef = ref()
const tableRef = ref()

// 搜索表单
const searchForm = reactive({
  permissionName: '',
  type: '',
  status: ''
})

// 表单数据
const formData = reactive({
  id: '',
  name: '',
  code: '',
  type: '',
  parentId: '',
  path: '',
  icon: '',
  sort: 0,
  status: 'enabled',
  description: ''
})

// 表单验证规则
const formRules = {
  name: [{ required: true, message: '请输入权限名称', trigger: 'blur' }],
  code: [{ required: true, message: '请输入权限编码', trigger: 'blur' }],
  type: [{ required: true, message: '请选择权限类型', trigger: 'change' }],
  path: [{ required: true, message: '请输入路径', trigger: 'blur' }]
}

// 权限树数据
const permissionTree = ref([
  {
    id: '1',
    name: '系统管理',
    children: [
      { id: '1-1', name: '用户管理' },
      { id: '1-2', name: '角色管理' },
      { id: '1-3', name: '权限管理' }
    ]
  },
  {
    id: '2',
    name: '业务管理',
    children: [
      { id: '2-1', name: '订单管理' },
      { id: '2-2', name: '商品管理' }
    ]
  }
])

// 方法
const handleSearch = () => {
  fetchPermissionList()
}

const handleReset = () => {
  searchForm.permissionName = ''
  searchForm.type = ''
  searchForm.status = ''
  fetchPermissionList()
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

const handleAddChild = (row: any) => {
  dialogMode.value = 'create'
  resetForm()
  formData.parentId = row.id
  dialogVisible.value = true
}

const handleDelete = async (row: any) => {
  try {
    await ElMessageBox.confirm(`确定要删除权限 "${row.name}" 吗？`, '删除确认', {
      type: 'warning'
    })
    ElMessage.success('删除成功')
    fetchPermissionList()
  } catch (error) {
    // 用户取消
  }
}

const handleStatusChange = async (row: any) => {
  try {
    ElMessage.success(`权限状态已${row.status === 'enabled' ? '启用' : '禁用'}`)
  } catch (error) {
    ElMessage.error('状态修改失败')
    // 回滚状态
    row.status = row.status === 'enabled' ? 'disabled' : 'enabled'
  }
}

const handleTypeChange = (type: string) => {
  // 根据类型清空某些字段
  if (type !== 'menu') {
    formData.icon = ''
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
      fetchPermissionList()
    }, 1000)
  } catch (error) {
    console.error('表单验证失败:', error)
  }
}

const expandAll = () => {
  // 展开所有节点的简化版本
  ElMessage.info('展开所有节点')
}

const collapseAll = () => {
  // 收起所有节点的简化版本
  ElMessage.info('收起所有节点')
}

const getAllKeys = (data: any[], keys: string[] = []): string[] => {
  data.forEach(item => {
    keys.push(item.id)
    if (item.children && item.children.length > 0) {
      getAllKeys(item.children, keys)
    }
  })
  return keys
}

const resetForm = () => {
  formData.id = ''
  formData.name = ''
  formData.code = ''
  formData.type = ''
  formData.parentId = ''
  formData.path = ''
  formData.icon = ''
  formData.sort = 0
  formData.status = 'enabled'
  formData.description = ''
}

const getPermissionTypeName = (type: string) => {
  const typeMap: Record<string, string> = {
    menu: '菜单权限',
    button: '按钮权限',
    api: '接口权限'
  }
  return typeMap[type] || type
}

const getPermissionTypeColor = (type: string) => {
  const colorMap: Record<string, string> = {
    menu: 'primary',
    button: 'success',
    api: 'warning'
  }
  return colorMap[type] || 'info'
}

const fetchPermissionList = async () => {
  loading.value = true
  try {
    // 模拟数据
    setTimeout(() => {
      tableData.value = [
        {
          id: '1',
          name: '系统管理',
          code: 'system',
          type: 'menu',
          path: '/system',
          icon: 'Setting',
          sort: 1,
          status: 'enabled',
          description: '系统管理模块',
          children: [
            {
              id: '1-1',
              name: '用户管理',
              code: 'system:user',
              type: 'menu',
              path: '/system/user',
              icon: 'User',
              sort: 1,
              status: 'enabled',
              description: '用户管理页面',
              children: [
                {
                  id: '1-1-1',
                  name: '用户新增',
                  code: 'system:user:add',
                  type: 'button',
                  path: '',
                  icon: '',
                  sort: 1,
                  status: 'enabled',
                  description: '用户新增按钮'
                },
                {
                  id: '1-1-2',
                  name: '用户编辑',
                  code: 'system:user:edit',
                  type: 'button',
                  path: '',
                  icon: '',
                  sort: 2,
                  status: 'enabled',
                  description: '用户编辑按钮'
                }
              ]
            }
          ]
        }
      ] as any
      loading.value = false
    }, 1000)
  } catch (error) {
    ElMessage.error('获取权限列表失败')
    loading.value = false
  }
}

// 生命周期
onMounted(() => {
  fetchPermissionList()
})
</script>

<style lang="scss" scoped>
.permission-list {
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

    .el-button {
      margin-right: 10px;
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