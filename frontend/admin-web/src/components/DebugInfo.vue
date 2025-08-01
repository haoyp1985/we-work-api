<template>
  <div v-if="showDebug" class="debug-info">
    <el-card header="🐛 调试信息" shadow="always">
      <div class="debug-section">
        <h4>👤 用户信息</h4>
        <pre>{{ JSON.stringify(userStore.userInfo, null, 2) }}</pre>
        <p><strong>角色:</strong> {{ userStore.roles.join(', ') }}</p>
      </div>
      
      <div class="debug-section">
        <h4>🗺️ 当前路由</h4>
        <p><strong>路径:</strong> {{ $route.path }}</p>
        <p><strong>名称:</strong> {{ $route.name }}</p>
        <p><strong>参数:</strong> {{ JSON.stringify($route.params) }}</p>
      </div>
      
      <div class="debug-section">
        <h4>📋 权限路由 ({{ permissionStore.routes.length }})</h4>
        <ul>
          <li v-for="route in permissionStore.routes" :key="route.path">
            <strong>{{ route.path }}</strong> ({{ route.name }})
            <span v-if="route.children?.length"> - {{ route.children.length }} 子路由</span>
          </li>
        </ul>
      </div>
      
      <div class="debug-section">
        <h4>🍔 菜单列表 ({{ permissionStore.menuList.length }})</h4>
        <ul>
          <li v-for="menu in permissionStore.menuList" :key="menu.path">
            <strong>{{ menu.path }}</strong> - {{ menu.meta?.title }}
            <span v-if="menu.children?.length"> ({{ menu.children.length }} 子菜单)</span>
          </li>
        </ul>
      </div>
      
      <div class="debug-actions">
        <el-button @click="refreshRoutes" type="primary" size="small">刷新路由</el-button>
        <el-button @click="showDebug = false" size="small">关闭调试</el-button>
      </div>
    </el-card>
  </div>
  
  <el-button 
    v-else 
    @click="showDebug = true" 
    class="debug-toggle"
    type="danger" 
    size="small"
    circle
  >
    🐛
  </el-button>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore, usePermissionStore } from '@/stores'

const router = useRouter()
const userStore = useUserStore()
const permissionStore = usePermissionStore()

const showDebug = ref(false)

const refreshRoutes = async () => {
  try {
    console.log('🔄 手动刷新路由...')
    const accessRoutes = await permissionStore.generateRoutes(userStore.roles)
    
    // 重新添加路由
    accessRoutes.forEach(route => {
      router.addRoute(route)
    })
    
    console.log('✅ 路由刷新完成')
  } catch (error) {
    console.error('❌ 路由刷新失败:', error)
  }
}
</script>

<style lang="scss" scoped>
.debug-info {
  position: fixed;
  top: 20px;
  right: 20px;
  width: 400px;
  max-height: 80vh;
  overflow-y: auto;
  z-index: 9999;
  
  .debug-section {
    margin-bottom: 16px;
    
    h4 {
      margin: 0 0 8px 0;
      color: var(--el-color-primary);
    }
    
    pre {
      background: #f5f5f5;
      padding: 8px;
      border-radius: 4px;
      font-size: 12px;
      max-height: 150px;
      overflow-y: auto;
    }
    
    ul {
      margin: 0;
      padding-left: 20px;
      font-size: 12px;
      
      li {
        margin-bottom: 4px;
      }
    }
  }
  
  .debug-actions {
    margin-top: 16px;
    display: flex;
    gap: 8px;
  }
}

.debug-toggle {
  position: fixed;
  bottom: 20px;
  right: 20px;
  z-index: 9999;
  font-size: 16px;
}
</style>