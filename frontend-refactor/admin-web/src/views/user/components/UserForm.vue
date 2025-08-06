<template>
  <el-dialog
    v-model="dialogVisible"
    :title="isEdit ? '编辑用户' : '新增用户'"
    width="800px"
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <el-form
      ref="formRef"
      :model="formData"
      :rules="formRules"
      label-width="100px"
      @submit.prevent
    >
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="用户名" prop="username">
            <el-input 
              v-model="formData.username" 
              placeholder="请输入用户名"
              :disabled="isEdit"
            />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="姓名" prop="realName">
            <el-input 
              v-model="formData.realName" 
              placeholder="请输入真实姓名"
            />
          </el-form-item>
        </el-col>
      </el-row>

      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="邮箱" prop="email">
            <el-input 
              v-model="formData.email" 
              placeholder="请输入邮箱地址"
            />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="手机号" prop="phone">
            <el-input 
              v-model="formData.phone" 
              placeholder="请输入手机号"
            />
          </el-form-item>
        </el-col>
      </el-row>

      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="昵称" prop="nickname">
            <el-input 
              v-model="formData.nickname" 
              placeholder="请输入昵称"
            />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="职位" prop="jobTitle">
            <el-input 
              v-model="formData.jobTitle" 
              placeholder="请输入职位"
            />
          </el-form-item>
        </el-col>
      </el-row>

      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="部门" prop="departmentId">
            <el-tree-select
              v-model="formData.departmentId"
              :data="departmentTree"
              :render-after-expand="false"
              :check-strictly="true"
              placeholder="请选择部门"
              clearable
              style="width: 100%"
              :props="{
                value: 'id',
                label: 'name',
                children: 'children'
              }"
            />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="状态" prop="status">
            <el-select 
              v-model="formData.status" 
              placeholder="请选择状态"
              style="width: 100%"
            >
              <el-option label="正常" value="ACTIVE" />
              <el-option label="禁用" value="DISABLED" />
              <el-option label="待激活" value="PENDING" />
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>

      <el-form-item label="角色" prop="roleIds">
        <el-select 
          v-model="formData.roleIds" 
          multiple
          placeholder="请选择角色"
          style="width: 100%"
        >
          <el-option 
            v-for="role in roleOptions" 
            :key="role.id" 
            :label="role.name" 
            :value="role.id" 
          />
        </el-select>
      </el-form-item>

      <el-form-item label="头像" prop="avatar">
        <div class="avatar-upload">
          <el-upload
            class="avatar-uploader"
            action="#"
            :show-file-list="false"
            :before-upload="handleAvatarUpload"
            accept="image/*"
          >
            <el-avatar 
              v-if="formData.avatar" 
              :src="formData.avatar" 
              :size="100"
            />
            <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
          </el-upload>
        </div>
      </el-form-item>

      <el-form-item 
        v-if="!isEdit" 
        label="密码" 
        prop="password"
      >
        <el-input 
          v-model="formData.password" 
          type="password"
          placeholder="请输入密码"
          show-password
        />
      </el-form-item>

      <el-form-item label="描述" prop="description">
        <el-input 
          v-model="formData.description" 
          type="textarea"
          :rows="3"
          placeholder="请输入用户描述"
        />
      </el-form-item>
    </el-form>

    <template #footer>
      <div class="dialog-footer">
        <el-button @click="handleClose">取消</el-button>
        <el-button 
          type="primary" 
          :loading="loading"
          @click="handleSubmit"
        >
          {{ isEdit ? '更新' : '创建' }}
        </el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, reactive, watch, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import * as userApi from '@/api/user'
import { uploadAvatar } from '@/api/upload'
import type { UserInfo, UserStatus } from '@/types/api'
import type { FormInstance, FormRules } from 'element-plus'

interface Props {
  modelValue: boolean
  userData?: UserInfo | null
  isEdit: boolean
}

interface Emits {
  (e: 'update:modelValue', value: boolean): void
  (e: 'success'): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

// 响应式数据
const formRef = ref<FormInstance>()
const loading = ref(false)
const dialogVisible = ref(false)

// 表单数据
const formData = reactive({
  username: '',
  realName: '',
  email: '',
  phone: '',
  nickname: '',
  jobTitle: '',
  departmentId: '',
  status: 'ACTIVE' as UserStatus,
  roleIds: [] as string[],
  avatar: '',
  password: '',
  description: ''
})

// 选项数据
const roleOptions = ref([])
const departmentTree = ref([])

// 表单验证规则
const formRules: FormRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度为3-20位', trigger: 'blur' },
    { pattern: /^[a-zA-Z0-9_]+$/, message: '用户名只能包含字母、数字和下划线', trigger: 'blur' }
  ],
  realName: [
    { required: true, message: '请输入真实姓名', trigger: 'blur' },
    { min: 2, max: 20, message: '姓名长度为2-20位', trigger: 'blur' }
  ],
  email: [
    { required: true, message: '请输入邮箱地址', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ],
  phone: [
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
  ],
  status: [
    { required: true, message: '请选择状态', trigger: 'change' }
  ],
  roleIds: [
    { required: true, message: '请选择角色', trigger: 'change' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 8, message: '密码长度不能少于8位', trigger: 'blur' }
  ]
}

// 监听对话框显示状态
watch(() => props.modelValue, (val) => {
  dialogVisible.value = val
  if (val) {
    initForm()
  }
})

watch(dialogVisible, (val) => {
  emit('update:modelValue', val)
})

// 初始化表单
const initForm = () => {
  if (props.isEdit && props.userData) {
    // 编辑模式，填充用户数据
    Object.assign(formData, {
      username: props.userData.username,
      realName: props.userData.realName,
      email: props.userData.email,
      phone: props.userData.phone || '',
      nickname: props.userData.nickname || '',
      jobTitle: props.userData.jobTitle || '',
      departmentId: props.userData.departmentId || '',
      status: props.userData.status,
      roleIds: props.userData.roles?.map(role => role.id) || [],
      avatar: props.userData.avatar || '',
      description: props.userData.description || ''
    })
  } else {
    // 新增模式，重置表单
    Object.assign(formData, {
      username: '',
      realName: '',
      email: '',
      phone: '',
      nickname: '',
      jobTitle: '',
      departmentId: '',
      status: 'ACTIVE',
      roleIds: [],
      avatar: '',
      password: '',
      description: ''
    })
  }
}

// 加载角色选项
const loadRoleOptions = async () => {
  try {
    const response = await userApi.getRoles()
    roleOptions.value = response.data.records
  } catch (error) {
    console.error('加载角色选项失败:', error)
  }
}

// 加载部门树
const loadDepartmentTree = async () => {
  try {
    const response = await userApi.getDepartmentTree()
    departmentTree.value = response.data
  } catch (error) {
    console.error('加载部门树失败:', error)
  }
}

// 头像上传处理
const handleAvatarUpload = async (file: File) => {
  const isImage = file.type.startsWith('image/')
  const isLt2M = file.size / 1024 / 1024 < 2

  if (!isImage) {
    ElMessage.error('只能上传图片文件!')
    return false
  }
  if (!isLt2M) {
    ElMessage.error('上传头像图片大小不能超过 2MB!')
    return false
  }

  try {
    const response = await uploadAvatar(file)
    formData.avatar = response.data.url
    ElMessage.success('头像上传成功')
  } catch (error) {
    console.error('头像上传失败:', error)
    ElMessage.error('头像上传失败')
  }

  return false // 阻止自动上传
}

// 提交表单
const handleSubmit = async () => {
  if (!formRef.value) return

  try {
    await formRef.value.validate()
    loading.value = true

    if (props.isEdit && props.userData) {
      // 编辑用户
      const updateData = {
        email: formData.email,
        phone: formData.phone,
        realName: formData.realName,
        nickname: formData.nickname,
        avatar: formData.avatar,
        departmentId: formData.departmentId,
        jobTitle: formData.jobTitle,
        roleIds: formData.roleIds,
        status: formData.status,
        description: formData.description
      }
      await userApi.updateUser(props.userData.id, updateData)
      ElMessage.success('用户更新成功')
    } else {
      // 创建用户
      const createData = {
        username: formData.username,
        email: formData.email,
        phone: formData.phone,
        realName: formData.realName,
        nickname: formData.nickname,
        avatar: formData.avatar,
        departmentId: formData.departmentId,
        jobTitle: formData.jobTitle,
        roleIds: formData.roleIds,
        status: formData.status,
        password: formData.password,
        description: formData.description
      }
      await userApi.createUser(createData)
      ElMessage.success('用户创建成功')
    }

    emit('success')
  } catch (error) {
    console.error('操作失败:', error)
    ElMessage.error('操作失败')
  } finally {
    loading.value = false
  }
}

// 关闭对话框
const handleClose = () => {
  formRef.value?.resetFields()
  dialogVisible.value = false
}

// 初始化
onMounted(() => {
  loadRoleOptions()
  loadDepartmentTree()
})
</script>

<style scoped lang="scss">
.avatar-upload {
  .avatar-uploader {
    :deep(.el-upload) {
      border: 1px dashed #d9d9d9;
      border-radius: 6px;
      cursor: pointer;
      position: relative;
      overflow: hidden;
      transition: all 0.3s;

      &:hover {
        border-color: #409eff;
      }

      .avatar-uploader-icon {
        font-size: 28px;
        color: #8c939d;
        width: 100px;
        height: 100px;
        line-height: 100px;
        text-align: center;
        background-color: #fbfdff;
      }
    }
  }
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}
</style>