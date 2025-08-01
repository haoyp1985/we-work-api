<template>
  <div class="login-container">
    <div class="login-wrapper">
      <div class="login-left">
        <div class="login-brand">
          <div class="brand-logo">WP</div>
          <h1 class="brand-title">WeWork Platform</h1>
          <p class="brand-subtitle">企业微信管理平台</p>
        </div>
        
        <div class="login-features">
          <div class="feature-item">
            <el-icon class="feature-icon"><User /></el-icon>
            <span>账号管理</span>
          </div>
          <div class="feature-item">
            <el-icon class="feature-icon"><ChatLineSquare /></el-icon>
            <span>消息管理</span>
          </div>
          <div class="feature-item">
            <el-icon class="feature-icon"><Monitor /></el-icon>
            <span>实时监控</span>
          </div>
          <div class="feature-item">
            <el-icon class="feature-icon"><Setting /></el-icon>
            <span>系统管理</span>
          </div>
        </div>
      </div>
      
      <div class="login-right">
        <div class="login-form-container">
          <h2 class="login-title">登录系统</h2>
          
          <!-- 登录方式切换 -->
          <el-segmented 
            v-model="loginType" 
            :options="loginOptions"
            class="login-type-selector"
          />
          
          <!-- 账号密码登录 -->
          <el-form
            v-if="loginType === 'password'"
            ref="loginFormRef"
            :model="loginForm"
            :rules="loginRules"
            class="login-form"
            @keyup.enter="handleLogin"
          >
            <el-form-item prop="username">
              <el-input
                v-model="loginForm.username"
                placeholder="请输入用户名"
                size="large"
                prefix-icon="User"
              />
            </el-form-item>
            
            <el-form-item prop="password">
              <el-input
                v-model="loginForm.password"
                type="password"
                placeholder="请输入密码"
                size="large"
                prefix-icon="Lock"
                show-password
              />
            </el-form-item>
            
            <el-form-item>
              <div class="login-options">
                <el-checkbox v-model="rememberMe">记住密码</el-checkbox>
                <el-link type="primary" :underline="false">忘记密码？</el-link>
              </div>
            </el-form-item>
            
            <el-form-item>
              <el-button
                type="primary"
                size="large"
                :loading="loading"
                class="login-button"
                @click="handleLogin"
              >
                {{ loading ? '登录中...' : '登录' }}
              </el-button>
            </el-form-item>
          </el-form>
          
          <!-- 二维码登录 -->
          <div v-else-if="loginType === 'qrcode'" class="qrcode-login">
            <div class="qrcode-container">
              <el-image
                v-if="qrCodeUrl"
                :src="qrCodeUrl"
                alt="登录二维码"
                class="qrcode-image"
                :preview-disabled="true"
              >
                <template #error>
                  <div class="qrcode-error">
                    <el-icon><Picture /></el-icon>
                    <span>二维码加载失败</span>
                  </div>
                </template>
              </el-image>
              
              <div v-else class="qrcode-loading">
                <el-icon class="loading-icon"><Loading /></el-icon>
                <span>二维码生成中...</span>
              </div>
              
              <!-- 二维码状态覆盖层 -->
              <div v-if="qrCodeStatus === 'expired'" class="qrcode-overlay">
                <div class="overlay-content">
                  <el-icon class="overlay-icon"><RefreshRight /></el-icon>
                  <p>二维码已过期</p>
                  <el-button type="primary" size="small" @click="refreshQrCode">
                    点击刷新
                  </el-button>
                </div>
              </div>
            </div>
            
            <div class="qrcode-tips">
              <p>请使用企业微信扫描二维码登录</p>
              <p class="tip-small">扫码后请在手机上确认登录</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, onUnmounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'
import { useUserStore } from '@/stores'
import { getLoginQrCode, verifyQrCode } from '@/api/auth'

const router = useRouter()
const userStore = useUserStore()

const loginFormRef = ref<FormInstance>()
const loading = ref(false)
const loginType = ref<'password' | 'qrcode'>('password')
const rememberMe = ref(false)

// 登录方式选项
const loginOptions = [
  { label: '账号登录', value: 'password' },
  { label: '扫码登录', value: 'qrcode' }
]

// 登录表单
const loginForm = reactive({
  username: 'admin',
  password: '123456'
})

// 表单验证规则
const loginRules: FormRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度在 3 到 20 个字符', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度在 6 到 20 个字符', trigger: 'blur' }
  ]
}

// 二维码相关
const qrCodeUrl = ref('')
const qrCodeKey = ref('')
const qrCodeStatus = ref<'pending' | 'scanned' | 'confirmed' | 'expired'>('pending')
let qrCodeTimer: NodeJS.Timeout | null = null

// 处理账号密码登录
const handleLogin = async () => {
  if (!loginFormRef.value) return
  
  try {
    await loginFormRef.value.validate()
    
    loading.value = true
    
    const success = await userStore.loginAction({
      username: loginForm.username,
      password: loginForm.password
    })
    
    if (success) {
      ElMessage.success('登录成功')
      
      // 跳转到目标页面或首页
      const redirect = router.currentRoute.value.query.redirect as string
      router.push(redirect || '/')
    }
    
  } catch (error) {
    console.error('登录失败:', error)
  } finally {
    loading.value = false
  }
}

// 获取登录二维码
const getQrCode = async () => {
  try {
    const response = await getLoginQrCode()
    qrCodeUrl.value = response.data.qrCode
    qrCodeKey.value = response.data.key
    qrCodeStatus.value = 'pending'
    
    // 开始轮询检查二维码状态
    startQrCodePolling()
    
  } catch (error) {
    ElMessage.error('获取二维码失败')
    console.error('获取二维码失败:', error)
  }
}

// 开始二维码状态轮询
const startQrCodePolling = () => {
  clearQrCodeTimer()
  
  qrCodeTimer = setInterval(async () => {
    try {
      const response = await verifyQrCode(qrCodeKey.value)
      
      if (response.data) {
        // 登录成功
        qrCodeStatus.value = 'confirmed'
        clearQrCodeTimer()
        
        ElMessage.success('登录成功')
        
        // 跳转到目标页面或首页
        const redirect = router.currentRoute.value.query.redirect as string
        router.push(redirect || '/')
      }
      
    } catch (error: any) {
      if (error.response?.status === 408) {
        // 二维码过期
        qrCodeStatus.value = 'expired'
        clearQrCodeTimer()
      }
    }
  }, 2000)
  
  // 5分钟后自动停止轮询
  setTimeout(() => {
    if (qrCodeStatus.value === 'pending') {
      qrCodeStatus.value = 'expired'
      clearQrCodeTimer()
    }
  }, 5 * 60 * 1000)
}

// 清除二维码轮询
const clearQrCodeTimer = () => {
  if (qrCodeTimer) {
    clearInterval(qrCodeTimer)
    qrCodeTimer = null
  }
}

// 刷新二维码
const refreshQrCode = () => {
  qrCodeUrl.value = ''
  getQrCode()
}

// 监听登录类型切换
watch(() => loginType.value, (newType) => {
  if (newType === 'qrcode' && !qrCodeUrl.value) {
    getQrCode()
  } else if (newType === 'password') {
    clearQrCodeTimer()
  }
})

onMounted(() => {
  // 如果用户已登录，直接跳转
  if (userStore.isLoggedIn) {
    router.push('/')
  }
})

onUnmounted(() => {
  clearQrCodeTimer()
})
</script>

<style lang="scss" scoped>
.login-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
}

.login-wrapper {
  display: flex;
  background: var(--bg-color);
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 1000px;
  min-height: 600px;
}

.login-left {
  flex: 1;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 60px 40px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  
  .login-brand {
    text-align: center;
    margin-bottom: 60px;
    
    .brand-logo {
      width: 80px;
      height: 80px;
      margin-bottom: 20px;
      background: rgba(255, 255, 255, 0.2);
      border: 2px solid rgba(255, 255, 255, 0.3);
      border-radius: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 32px;
      font-weight: 800;
      color: white;
      margin-left: auto;
      margin-right: auto;
    }
    
    .brand-title {
      font-size: 28px;
      font-weight: 600;
      margin: 0 0 12px 0;
    }
    
    .brand-subtitle {
      font-size: 16px;
      opacity: 0.9;
      margin: 0;
    }
  }
  
  .login-features {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 24px;
    
    .feature-item {
      display: flex;
      align-items: center;
      gap: 12px;
      
      .feature-icon {
        font-size: 24px;
        opacity: 0.9;
      }
      
      span {
        font-size: 16px;
        font-weight: 500;
      }
    }
  }
}

.login-right {
  flex: 1;
  padding: 60px 40px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.login-form-container {
  width: 100%;
  max-width: 360px;
  
  .login-title {
    font-size: 24px;
    font-weight: 600;
    color: var(--text-color-primary);
    text-align: center;
    margin: 0 0 32px 0;
  }
  
  .login-type-selector {
    width: 100%;
    margin-bottom: 24px;
  }
}

.login-form {
  .el-form-item {
    margin-bottom: 20px;
    
    &:last-child {
      margin-bottom: 0;
    }
  }
  
  .login-options {
    display: flex;
    align-items: center;
    justify-content: space-between;
    width: 100%;
  }
  
  .login-button {
    width: 100%;
    height: 44px;
    font-size: 16px;
    font-weight: 500;
  }
}

.qrcode-login {
  text-align: center;
  
  .qrcode-container {
    position: relative;
    display: inline-block;
    margin-bottom: 24px;
    
    .qrcode-image {
      width: 200px;
      height: 200px;
      border: 1px solid var(--border-color-base);
      border-radius: 8px;
    }
    
    .qrcode-loading,
    .qrcode-error {
      width: 200px;
      height: 200px;
      border: 1px solid var(--border-color-base);
      border-radius: 8px;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      gap: 12px;
      color: var(--text-color-secondary);
      
      .el-icon {
        font-size: 32px;
      }
      
      .loading-icon {
        animation: rotate 1s linear infinite;
      }
    }
    
    .qrcode-overlay {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: rgba(255, 255, 255, 0.95);
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 8px;
      
      .overlay-content {
        text-align: center;
        
        .overlay-icon {
          font-size: 32px;
          color: var(--text-color-secondary);
          margin-bottom: 12px;
        }
        
        p {
          margin: 0 0 16px 0;
          color: var(--text-color-regular);
        }
      }
    }
  }
  
  .qrcode-tips {
    p {
      margin: 0 0 8px 0;
      color: var(--text-color-regular);
      
      &.tip-small {
        font-size: 12px;
        color: var(--text-color-secondary);
        margin-bottom: 0;
      }
    }
  }
}

// 响应式适配
@include respond-to(md) {
  .login-wrapper {
    flex-direction: column;
    max-width: 400px;
  }
  
  .login-left {
    padding: 40px 30px;
    
    .login-brand {
      margin-bottom: 40px;
      
      .brand-title {
        font-size: 24px;
      }
    }
    
    .login-features {
      grid-template-columns: 1fr;
      gap: 20px;
    }
  }
  
  .login-right {
    padding: 40px 30px;
  }
}

// 旋转动画
@keyframes rotate {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}
</style>