<template>
  <div class="login-container">
    <div class="login-wrapper">
      <div class="login-form-container">
        <div class="login-header">
          <div class="logo">
            <img src="/logo.png" alt="WeWork Platform" />
          </div>
          <h1 class="title">{{ APP_INFO.NAME }}</h1>
          <p class="subtitle">企业微信管理平台</p>
        </div>

        <el-form
          ref="loginFormRef"
          :model="loginForm"
          :rules="loginRules"
          class="login-form"
          size="large"
          @keyup.enter="handleLogin"
        >
          <el-form-item prop="username">
            <el-input
              v-model="loginForm.username"
              placeholder="请输入用户名"
              prefix-icon="User"
              clearable
            />
          </el-form-item>

          <el-form-item prop="password">
            <el-input
              v-model="loginForm.password"
              type="password"
              placeholder="请输入密码"
              prefix-icon="Lock"
              show-password
              clearable
            />
          </el-form-item>

          <el-form-item>
            <div class="login-options">
              <el-checkbox v-model="rememberPassword">记住密码</el-checkbox>
              <el-link type="primary" :underline="false">忘记密码？</el-link>
            </div>
          </el-form-item>

          <el-form-item>
            <el-button
              type="primary"
              :loading="loading"
              class="login-button"
              @click="handleLogin"
            >
              {{ loading ? '登录中...' : '登录' }}
            </el-button>
          </el-form-item>
        </el-form>

        <div class="login-footer">
          <p>&copy; 2024 WeWork Platform. All rights reserved.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { ElMessage, ElForm } from 'element-plus';
import { useUserStore } from '@/stores/modules/user';
import { APP_INFO, STORAGE_KEYS, REGEX } from '@/constants';
import { setPageTitle } from '@/utils';
import type { LoginData } from '@/types/user';

const router = useRouter();
const userStore = useUserStore();

// 表单引用
const loginFormRef = ref<InstanceType<typeof ElForm>>();

// 表单数据
const loginForm = reactive<LoginData>({
  username: '',
  password: '',
});

// 表单验证规则
const loginRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度在 3 到 20 个字符', trigger: 'blur' },
    { pattern: REGEX.USERNAME, message: '用户名只能包含字母、数字和下划线', trigger: 'blur' },
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度在 6 到 20 个字符', trigger: 'blur' },
  ],
};

// 状态
const loading = ref(false);
const rememberPassword = ref(false);

// 登录处理
const handleLogin = async () => {
  if (!loginFormRef.value) return;

  try {
    await loginFormRef.value.validate();
    
    loading.value = true;
    
    await userStore.userLogin(loginForm);
    
    // 保存记住密码状态
    if (rememberPassword.value) {
      localStorage.setItem(STORAGE_KEYS.REMEMBER_PASSWORD, JSON.stringify({
        username: loginForm.username,
        remember: true,
      }));
    } else {
      localStorage.removeItem(STORAGE_KEYS.REMEMBER_PASSWORD);
    }
    
    ElMessage.success('登录成功');
    
    // 跳转到首页
    router.push('/');
    
  } catch (error) {
    console.error('Login failed:', error);
    ElMessage.error('登录失败，请检查用户名和密码');
  } finally {
    loading.value = false;
  }
};

// 初始化
onMounted(() => {
  setPageTitle('登录');
  
  // 恢复记住的用户名
  const remembered = localStorage.getItem(STORAGE_KEYS.REMEMBER_PASSWORD);
  if (remembered) {
    try {
      const data = JSON.parse(remembered);
      if (data.remember) {
        loginForm.username = data.username;
        rememberPassword.value = true;
      }
    } catch (error) {
      console.error('Failed to parse remembered data:', error);
    }
  }
});
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.login-container {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px;
}

.login-wrapper {
  width: 100%;
  max-width: 400px;
}

.login-form-container {
  background: #ffffff;
  border-radius: 8px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  padding: 40px;
  backdrop-filter: blur(10px);
}

.login-header {
  text-align: center;
  margin-bottom: 32px;

  .logo {
    margin-bottom: 16px;

    img {
      width: 64px;
      height: 64px;
      border-radius: 8px;
    }
  }

  .title {
    margin: 0 0 8px 0;
    font-size: 28px;
    font-weight: 600;
    color: $text-color-primary;
  }

  .subtitle {
    margin: 0;
    font-size: 16px;
    color: $text-color-secondary;
  }
}

.login-form {
  .login-options {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
  }

  .login-button {
    width: 100%;
    height: 48px;
    font-size: 16px;
    border-radius: 6px;
  }
}

.login-footer {
  text-align: center;
  margin-top: 32px;
  padding-top: 20px;
  border-top: 1px solid $border-color-light;

  p {
    margin: 0;
    font-size: 14px;
    color: $text-color-secondary;
  }
}

// 响应式设计
@media (max-width: 480px) {
  .login-container {
    padding: 10px;
  }

  .login-form-container {
    padding: 24px;
  }

  .login-header {
    margin-bottom: 24px;

    .title {
      font-size: 24px;
    }

    .subtitle {
      font-size: 14px;
    }
  }
}
</style>