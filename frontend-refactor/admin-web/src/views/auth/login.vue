<script setup lang="ts">
import { ref, reactive } from "vue";
import { useRouter } from "vue-router";
import { ElMessage } from "element-plus";
import { User, Lock, View, Hide } from "@element-plus/icons-vue";
import { useUserStore } from "@/stores/modules/user";

const router = useRouter();
const userStore = useUserStore();

// 表单数据
const loginForm = reactive({
  username: "",
  password: "",
  rememberMe: false,
});

// 表单验证规则
const loginRules = {
  username: [
    { required: true, message: "请输入用户名", trigger: "blur" },
    {
      min: 3,
      max: 20,
      message: "用户名长度在 3 到 20 个字符",
      trigger: "blur",
    },
  ],
  password: [
    { required: true, message: "请输入密码", trigger: "blur" },
    { min: 6, max: 50, message: "密码长度在 6 到 50 个字符", trigger: "blur" },
  ],
};

// 状态
const loading = ref(false);
const showPassword = ref(false);
const loginFormRef = ref();

// 切换密码显示/隐藏
const togglePasswordVisibility = () => {
  showPassword.value = !showPassword.value;
};

// 登录处理
const handleLogin = async () => {
  if (!loginFormRef.value) return;

  try {
    await loginFormRef.value.validate();
    loading.value = true;

    const loginData = {
      username: loginForm.username,
      password: loginForm.password,
      rememberMe: loginForm.rememberMe,
    };

    await userStore.login(loginData);
    ElMessage.success("登录成功");

    // 获取重定向路径
    const redirect = router.currentRoute.value.query.redirect as string;
    router.push(redirect || "/dashboard");
  } catch (error) {
    console.error("登录失败:", error);
  } finally {
    loading.value = false;
  }
};

// 忘记密码
const handleForgotPassword = () => {
  ElMessage.info("忘记密码功能开发中");
};

// 注册
const handleRegister = () => {
  ElMessage.info("注册功能开发中");
};
</script>

<template>
  <div class="login-container">
    <div class="login-background">
      <div class="bg-overlay" />
      <div class="bg-pattern" />
    </div>

    <div class="login-card">
      <div class="login-header">
        <div class="logo">
          <img src="/logo.svg"
alt="WeWork Platform" class="logo-image"
/>
          <h1 class="logo-text">WeWork Platform</h1>
        </div>
        <p class="login-subtitle">企业工作协作平台</p>
      </div>

      <el-form
        ref="loginFormRef"
        :model="loginForm"
        :rules="loginRules"
        class="login-form"
        @submit.prevent="handleLogin"
      >
        <el-form-item prop="username">
          <el-input
            v-model="loginForm.username"
            size="large"
            placeholder="请输入用户名"
            clearable
            :prefix-icon="User"
            @keyup.enter="handleLogin"
          />
        </el-form-item>

        <el-form-item prop="password">
          <el-input
            v-model="loginForm.password"
            :type="showPassword ? 'text' : 'password'"
            size="large"
            placeholder="请输入密码"
            show-password
            :prefix-icon="Lock"
            @keyup.enter="handleLogin"
          >
            <template #suffix>
              <el-icon
                class="password-toggle"
                @click="togglePasswordVisibility"
              >
                <View v-if="showPassword" />
                <Hide v-else />
              </el-icon>
            </template>
          </el-input>
        </el-form-item>

        <div class="login-options">
          <el-checkbox v-model="loginForm.rememberMe">
记住我
</el-checkbox>
          <el-button type="text" @click="handleForgotPassword">
            忘记密码？
          </el-button>
        </div>

        <el-button
          type="primary"
          size="large"
          class="login-button"
          :loading="loading"
          @click="handleLogin"
        >
          <span v-if="!loading">登录</span>
          <span v-else>登录中...</span>
        </el-button>

        <div class="register-link">
          <span>还没有账号？</span>
          <el-button type="text"
@click="handleRegister"
>
立即注册
</el-button>
        </div>
      </el-form>

      <div class="login-footer">
        <p>&copy; 2024 WeWork Platform. All rights reserved.</p>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
.login-container {
  position: relative;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.login-background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);

  .bg-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.3);
  }

  .bg-pattern {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-image: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.1'%3E%3Ccircle cx='30' cy='30' r='2'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
    animation: float 20s ease-in-out infinite;
  }
}

@keyframes float {
  0%,
  100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-20px);
  }
}

.login-card {
  position: relative;
  width: 100%;
  max-width: 400px;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
  padding: 40px;
  margin: 20px;
  animation: slideIn 0.6s ease-out;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.login-header {
  text-align: center;
  margin-bottom: 40px;

  .logo {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 12px;
    margin-bottom: 16px;

    .logo-image {
      width: 40px;
      height: 40px;
    }

    .logo-text {
      font-size: 28px;
      font-weight: 700;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
      margin: 0;
    }
  }

  .login-subtitle {
    color: #666;
    font-size: 14px;
    margin: 0;
  }
}

.login-form {
  .el-form-item {
    margin-bottom: 24px;

    :deep(.el-input__wrapper) {
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      transition: all 0.3s ease;

      &:hover {
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
      }

      &.is-focus {
        box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
      }
    }
  }

  .password-toggle {
    cursor: pointer;
    color: #999;
    transition: color 0.3s ease;

    &:hover {
      color: #667eea;
    }
  }
}

.login-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 32px;

  .el-button--text {
    color: #667eea;
    font-size: 14px;
    padding: 0;

    &:hover {
      color: #5a6fd8;
    }
  }
}

.login-button {
  width: 100%;
  height: 48px;
  border-radius: 12px;
  font-size: 16px;
  font-weight: 600;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  margin-bottom: 24px;
  transition: all 0.3s ease;

  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
  }

  &:active {
    transform: translateY(0);
  }
}

.register-link {
  text-align: center;
  color: #666;
  font-size: 14px;

  .el-button--text {
    color: #667eea;
    font-size: 14px;
    padding: 0;
    margin-left: 4px;

    &:hover {
      color: #5a6fd8;
    }
  }
}

.login-footer {
  text-align: center;
  margin-top: 40px;
  padding-top: 24px;
  border-top: 1px solid #eee;

  p {
    color: #999;
    font-size: 12px;
    margin: 0;
  }
}

// 响应式设计
@media (max-width: 480px) {
  .login-card {
    padding: 30px 20px;
    margin: 10px;
  }

  .login-header .logo .logo-text {
    font-size: 24px;
  }

  .login-button {
    height: 44px;
    font-size: 15px;
  }
}
</style>
