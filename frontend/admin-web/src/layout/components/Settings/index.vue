<template>
  <div class="settings-container">
    <div class="settings-trigger" @click="toggleSettings">
      <el-icon class="settings-icon">
        <Setting />
      </el-icon>
    </div>
    
    <el-drawer
      v-model="settingsVisible"
      title="系统设置"
      direction="rtl"
      size="300px"
      :before-close="handleClose"
    >
      <div class="settings-content">
        <!-- 主题设置 -->
        <div class="setting-item">
          <h4 class="setting-title">主题模式</h4>
          <div class="theme-options">
            <div 
              class="theme-option"
              :class="{ active: appStore.theme === 'light' }"
              @click="setTheme('light')"
            >
              <div class="theme-preview light-theme">
                <div class="theme-header"></div>
                <div class="theme-sidebar"></div>
                <div class="theme-content"></div>
              </div>
              <span class="theme-name">浅色</span>
            </div>
            
            <div 
              class="theme-option"
              :class="{ active: appStore.theme === 'dark' }"
              @click="setTheme('dark')"
            >
              <div class="theme-preview dark-theme">
                <div class="theme-header"></div>
                <div class="theme-sidebar"></div>
                <div class="theme-content"></div>
              </div>
              <span class="theme-name">深色</span>
            </div>
          </div>
        </div>
        
        <!-- 组件尺寸 -->
        <div class="setting-item">
          <h4 class="setting-title">组件尺寸</h4>
          <el-radio-group 
            v-model="appStore.componentSize" 
            @change="setComponentSize"
          >
            <el-radio label="large">大号</el-radio>
            <el-radio label="default">默认</el-radio>
            <el-radio label="small">小号</el-radio>
          </el-radio-group>
        </div>
        
        <!-- 语言设置 -->
        <div class="setting-item">
          <h4 class="setting-title">语言设置</h4>
          <el-select 
            v-model="appStore.language" 
            @change="setLanguage"
            style="width: 100%"
          >
            <el-option label="简体中文" value="zh-cn" />
            <el-option label="English" value="en" />
          </el-select>
        </div>
        
        <!-- 布局设置 -->
        <div class="setting-item">
          <h4 class="setting-title">布局设置</h4>
          <div class="setting-option">
            <span>显示标签页</span>
            <el-switch v-model="showTagsView" />
          </div>
          <div class="setting-option">
            <span>固定顶栏</span>
            <el-switch v-model="fixedHeader" />
          </div>
          <div class="setting-option">
            <span>显示Logo</span>
            <el-switch v-model="showLogo" />
          </div>
        </div>
        
        <!-- 操作按钮 -->
        <div class="setting-actions">
          <el-button @click="resetSettings">重置设置</el-button>
          <el-button type="primary" @click="saveSettings">保存设置</el-button>
        </div>
      </div>
    </el-drawer>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import { useAppStore } from '@/stores'

const appStore = useAppStore()

const settingsVisible = ref(false)
const showTagsView = ref(true)
const fixedHeader = ref(true)
const showLogo = ref(true)

// 切换设置面板
const toggleSettings = () => {
  settingsVisible.value = !settingsVisible.value
}

// 关闭设置面板
const handleClose = () => {
  settingsVisible.value = false
}

// 设置主题
const setTheme = (theme: 'light' | 'dark') => {
  appStore.setTheme(theme)
}

// 设置组件尺寸
const setComponentSize = (size: 'large' | 'default' | 'small') => {
  appStore.setComponentSize(size)
}

// 设置语言
const setLanguage = (language: 'zh-cn' | 'en') => {
  appStore.setLanguage(language)
}

// 重置设置
const resetSettings = () => {
  appStore.setTheme('light')
  appStore.setComponentSize('default')
  appStore.setLanguage('zh-cn')
  showTagsView.value = true
  fixedHeader.value = true
  showLogo.value = true
  ElMessage.success('设置已重置')
}

// 保存设置
const saveSettings = () => {
  // 这里可以保存用户的个性化设置到后端
  ElMessage.success('设置已保存')
  settingsVisible.value = false
}
</script>

<style lang="scss" scoped>
.settings-container {
  .settings-trigger {
    position: fixed;
    top: 50%;
    right: 0;
    width: 48px;
    height: 48px;
    background: var(--el-color-primary);
    border-radius: 6px 0 0 6px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    z-index: 999;
    transition: all $transition-duration-base;
    
    &:hover {
      background: var(--el-color-primary-light-3);
      width: 52px;
    }
    
    .settings-icon {
      color: #fff;
      font-size: 20px;
      animation: rotate 2s linear infinite;
    }
  }
}

.settings-content {
  padding: 20px;
  
  .setting-item {
    margin-bottom: 24px;
    
    .setting-title {
      margin: 0 0 12px 0;
      font-size: 14px;
      font-weight: 500;
      color: var(--text-color-primary);
    }
    
    .setting-option {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 12px;
      
      span {
        font-size: 13px;
        color: var(--text-color-regular);
      }
    }
  }
  
  .theme-options {
    display: flex;
    gap: 16px;
    
    .theme-option {
      cursor: pointer;
      text-align: center;
      
      &.active {
        .theme-preview {
          border-color: var(--el-color-primary);
          box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
        }
      }
      
      .theme-preview {
        width: 80px;
        height: 60px;
        border: 2px solid var(--border-color-base);
        border-radius: 4px;
        position: relative;
        margin-bottom: 8px;
        transition: all $transition-duration-base;
        
        &.light-theme {
          background: #fff;
          
          .theme-header {
            height: 12px;
            background: #f0f2f5;
            border-bottom: 1px solid #e8e8e8;
          }
          
          .theme-sidebar {
            position: absolute;
            left: 0;
            top: 12px;
            bottom: 0;
            width: 20px;
            background: #304156;
          }
          
          .theme-content {
            position: absolute;
            left: 20px;
            top: 12px;
            right: 0;
            bottom: 0;
            background: #f0f2f5;
          }
        }
        
        &.dark-theme {
          background: #1f2d3d;
          
          .theme-header {
            height: 12px;
            background: #2d3a4b;
            border-bottom: 1px solid #3a4a5c;
          }
          
          .theme-sidebar {
            position: absolute;
            left: 0;
            top: 12px;
            bottom: 0;
            width: 20px;
            background: #1f2d3d;
          }
          
          .theme-content {
            position: absolute;
            left: 20px;
            top: 12px;
            right: 0;
            bottom: 0;
            background: #2d3a4b;
          }
        }
      }
      
      .theme-name {
        font-size: 12px;
        color: var(--text-color-regular);
      }
    }
  }
  
  .setting-actions {
    margin-top: 32px;
    display: flex;
    gap: 12px;
    
    .el-button {
      flex: 1;
    }
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