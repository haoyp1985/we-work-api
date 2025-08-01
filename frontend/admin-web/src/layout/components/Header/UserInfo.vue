<template>
  <el-dropdown class="user-info" @command="handleCommand">
    <div class="user-avatar-container">
      <el-avatar 
        :size="36" 
        :src="userStore.userInfo?.avatar || '/default-avatar.png'"
        :alt="userStore.userInfo?.nickname || userStore.userInfo?.username"
      >
        <el-icon><User /></el-icon>
      </el-avatar>
      <span v-if="!isMobile" class="user-name">
        {{ userStore.userInfo?.nickname || userStore.userInfo?.username }}
      </span>
      <el-icon class="dropdown-arrow"><ArrowDown /></el-icon>
    </div>
    
    <template #dropdown>
      <el-dropdown-menu>
        <el-dropdown-item command="profile">
          <el-icon><User /></el-icon>
          <span>个人中心</span>
        </el-dropdown-item>
        <el-dropdown-item command="settings">
          <el-icon><Setting /></el-icon>
          <span>个人设置</span>
        </el-dropdown-item>
        <el-dropdown-item divided command="logout">
          <el-icon><SwitchButton /></el-icon>
          <span>退出登录</span>
        </el-dropdown-item>
      </el-dropdown-menu>
    </template>
  </el-dropdown>
  
  <!-- 个人资料对话框 -->
  <UserProfileDialog 
    v-model:visible="showProfileDialog"
    :user-info="userStore.userInfo"
    @update="handleProfileUpdate"
  />
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useUserStore, useAppStore } from '@/stores'
import UserProfileDialog from './UserProfileDialog.vue'
import type { UserInfo } from '@/types'

const router = useRouter()
const userStore = useUserStore()
const appStore = useAppStore()

const showProfileDialog = ref(false)

// 是否移动端
const isMobile = computed(() => appStore.device === 'mobile')

// 处理下拉菜单命令
const handleCommand = async (command: string) => {
  switch (command) {
    case 'profile':
      showProfileDialog.value = true
      break
      
    case 'settings':
      router.push('/system/settings')
      break
      
    case 'logout':
      await handleLogout()
      break
  }
}

// 处理退出登录
const handleLogout = async () => {
  try {
    await ElMessageBox.confirm(
      '确定要退出登录吗？',
      '系统提示',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    
    await userStore.logoutAction()
    router.push('/login')
  } catch (error) {
    // 用户取消或出错
    if (error !== 'cancel') {
      ElMessage.error('退出登录失败')
    }
  }
}

// 处理个人资料更新
const handleProfileUpdate = (updatedInfo: Partial<UserInfo>) => {
  userStore.updateUserInfo(updatedInfo)
  showProfileDialog.value = false
  ElMessage.success('个人资料更新成功')
}
</script>

<style lang="scss" scoped>
.user-info {
  cursor: pointer;
  
  .user-avatar-container {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 8px 12px;
    border-radius: $border-radius-base;
    transition: all $transition-duration-base;
    
    &:hover {
      background-color: rgba(0, 0, 0, 0.05);
    }
    
    .user-name {
      font-size: 14px;
      color: var(--text-color-primary);
      font-weight: 500;
      max-width: 120px;
      @include ellipsis();
    }
    
    .dropdown-arrow {
      font-size: 12px;
      color: var(--text-color-secondary);
      transition: transform $transition-duration-base;
    }
  }
  
  &.is-active {
    .user-avatar-container {
      .dropdown-arrow {
        transform: rotate(180deg);
      }
    }
  }
}

// 下拉菜单样式
:deep(.el-dropdown-menu) {
  .el-dropdown-menu__item {
    display: flex;
    align-items: center;
    gap: 8px;
    
    .el-icon {
      font-size: 16px;
    }
  }
}

// 响应式适配
@include respond-to(md) {
  .user-info {
    .user-avatar-container {
      padding: 4px 8px;
      
      .user-name {
        display: none;
      }
    }
  }
}

// 深色主题适配
[data-theme="dark"] {
  .user-info {
    .user-avatar-container {
      &:hover {
        background-color: rgba(255, 255, 255, 0.1);
      }
    }
  }
}
</style>