<template>
  <el-dialog
    v-model="dialogVisible"
    title="个人资料"
    width="500px"
    :before-close="handleClose"
  >
    <el-form 
      ref="formRef"
      :model="formData"
      :rules="formRules"
      label-width="80px"
    >
      <el-form-item label="头像">
        <div class="avatar-upload">
          <el-upload
            class="avatar-uploader"
            action="/api/upload/avatar"
            :headers="uploadHeaders"
            :show-file-list="false"
            :on-success="handleAvatarSuccess"
            :before-upload="beforeAvatarUpload"
          >
            <el-avatar 
              :size="100" 
              :src="formData.avatar || '/default-avatar.png'"
            >
              <el-icon><User /></el-icon>
            </el-avatar>
            <div class="avatar-upload-overlay">
              <el-icon><Camera /></el-icon>
            </div>
          </el-upload>
        </div>
      </el-form-item>
      
      <el-form-item label="用户名" prop="username">
        <el-input v-model="formData.username" disabled />
      </el-form-item>
      
      <el-form-item label="昵称" prop="nickname">
        <el-input 
          v-model="formData.nickname" 
          placeholder="请输入昵称"
          maxlength="20"
          show-word-limit
        />
      </el-form-item>
      
      <el-form-item label="邮箱" prop="email">
        <el-input 
          v-model="formData.email" 
          placeholder="请输入邮箱"
          type="email"
        />
      </el-form-item>
      
      <el-form-item label="手机" prop="phone">
        <el-input 
          v-model="formData.phone" 
          placeholder="请输入手机号"
          maxlength="11"
        />
      </el-form-item>
    </el-form>
    
    <template #footer>
      <div class="dialog-footer">
        <el-button @click="handleClose">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitting">
          保存
        </el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, computed, watch, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import type { FormInstance, FormRules, UploadProps } from 'element-plus'
import { getToken } from '@/utils/auth'
import { isValidEmail, isValidPhone } from '@/utils'
import type { UserInfo } from '@/types'

interface Props {
  visible: boolean
  userInfo: UserInfo | null
}

interface Emits {
  (e: 'update:visible', value: boolean): void
  (e: 'update', value: Partial<UserInfo>): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

const formRef = ref<FormInstance>()
const submitting = ref(false)

// 对话框显示状态
const dialogVisible = computed({
  get: () => props.visible,
  set: (value) => emit('update:visible', value)
})

// 表单数据
const formData = reactive({
  username: '',
  nickname: '',
  email: '',
  phone: '',
  avatar: ''
})

// 表单验证规则
const formRules: FormRules = {
  nickname: [
    { max: 20, message: '昵称不能超过20个字符', trigger: 'blur' }
  ],
  email: [
    { validator: (rule, value, callback) => {
      if (value && !isValidEmail(value)) {
        callback(new Error('请输入正确的邮箱格式'))
      } else {
        callback()
      }
    }, trigger: 'blur' }
  ],
  phone: [
    { validator: (rule, value, callback) => {
      if (value && !isValidPhone(value)) {
        callback(new Error('请输入正确的手机号格式'))
      } else {
        callback()
      }
    }, trigger: 'blur' }
  ]
}

// 上传请求头
const uploadHeaders = computed(() => ({
  Authorization: `Bearer ${getToken()}`
}))

// 监听用户信息变化，更新表单数据
watch(() => props.userInfo, (newUserInfo) => {
  if (newUserInfo) {
    Object.assign(formData, {
      username: newUserInfo.username || '',
      nickname: newUserInfo.nickname || '',
      email: newUserInfo.email || '',
      phone: newUserInfo.phone || '',
      avatar: newUserInfo.avatar || ''
    })
  }
}, { immediate: true })

// 头像上传成功
const handleAvatarSuccess: UploadProps['onSuccess'] = (response) => {
  if (response.code === 200) {
    formData.avatar = response.data.url
    ElMessage.success('头像上传成功')
  } else {
    ElMessage.error(response.message || '头像上传失败')
  }
}

// 头像上传前验证
const beforeAvatarUpload: UploadProps['beforeUpload'] = (file) => {
  const isImage = file.type.startsWith('image/')
  const isLt2M = file.size / 1024 / 1024 < 2

  if (!isImage) {
    ElMessage.error('只能上传图片文件')
    return false
  }
  if (!isLt2M) {
    ElMessage.error('图片大小不能超过 2MB')
    return false
  }
  return true
}

// 提交表单
const handleSubmit = async () => {
  if (!formRef.value) return
  
  try {
    await formRef.value.validate()
    
    submitting.value = true
    
    // 这里应该调用更新用户信息的API
    // await updateUserProfile(formData)
    
    // 模拟API调用
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    emit('update', {
      nickname: formData.nickname,
      email: formData.email,
      phone: formData.phone,
      avatar: formData.avatar
    })
    
  } catch (error) {
    console.error('表单验证失败:', error)
  } finally {
    submitting.value = false
  }
}

// 关闭对话框
const handleClose = () => {
  dialogVisible.value = false
}
</script>

<style lang="scss" scoped>
.avatar-upload {
  .avatar-uploader {
    position: relative;
    cursor: pointer;
    
    &:hover {
      .avatar-upload-overlay {
        opacity: 1;
      }
    }
    
    .avatar-upload-overlay {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: rgba(0, 0, 0, 0.6);
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 50%;
      opacity: 0;
      transition: opacity $transition-duration-base;
      
      .el-icon {
        color: white;
        font-size: 24px;
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