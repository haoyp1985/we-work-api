<template>
  <div class="tenant-switcher">
    <el-dropdown
      trigger="click"
      placement="bottom-end"
      @command="handleTenantSwitch"
      :disabled="loading"
    >
      <div class="current-tenant">
        <div class="tenant-info">
          <el-avatar
            v-if="currentTenant?.logo"
            :src="currentTenant.logo"
            :size="24"
            class="tenant-avatar"
          />
          <el-icon v-else :size="24" class="tenant-icon">
            <OfficeBuilding />
          </el-icon>
          <div class="tenant-details">
            <div class="tenant-name">
              {{ currentTenant?.name || '请选择租户' }}
            </div>
            <div v-if="currentTenant" class="tenant-type">
              {{ getTenantTypeText(currentTenant.type) }}
            </div>
          </div>
        </div>
        <el-icon class="dropdown-arrow" :class="{ loading }">
          <ArrowDown v-if="!loading" />
          <Loading v-else />
        </el-icon>
      </div>

      <template #dropdown>
        <el-dropdown-menu>
          <div class="tenant-list">
            <div class="tenant-list-header">
              <span>选择租户</span>
              <el-button
                v-if="isAdmin"
                type="primary"
                link
                size="small"
                @click="handleManageTenants"
              >
                管理
              </el-button>
            </div>
            
            <div class="tenant-items">
              <el-dropdown-item
                v-for="tenant in availableTenants"
                :key="tenant.id"
                :command="tenant.id"
                :class="{
                  'is-current': currentTenant?.id === tenant.id,
                  'is-inactive': tenant.status !== 'ACTIVE'
                }"
              >
                <div class="tenant-item">
                  <el-avatar
                    v-if="tenant.logo"
                    :src="tenant.logo"
                    :size="32"
                    class="tenant-avatar"
                  />
                  <el-icon v-else :size="32" class="tenant-icon">
                    <OfficeBuilding />
                  </el-icon>
                  
                  <div class="tenant-content">
                    <div class="tenant-name">{{ tenant.name }}</div>
                    <div class="tenant-meta">
                      <el-tag
                        :type="getTenantTypeColor(tenant.type)"
                        size="small"
                        effect="plain"
                      >
                        {{ getTenantTypeText(tenant.type) }}
                      </el-tag>
                      <el-tag
                        :type="getTenantStatusColor(tenant.status)"
                        size="small"
                        effect="plain"
                        class="status-tag"
                      >
                        {{ getTenantStatusText(tenant.status) }}
                      </el-tag>
                    </div>
                  </div>
                  
                  <el-icon
                    v-if="currentTenant?.id === tenant.id"
                    class="check-icon"
                    color="var(--el-color-primary)"
                  >
                    <Check />
                  </el-icon>
                </div>
              </el-dropdown-item>
            </div>
            
            <div v-if="availableTenants.length === 0" class="empty-state">
              <el-empty description="暂无可用租户" :image-size="60" />
            </div>
          </div>
        </el-dropdown-menu>
      </template>
    </el-dropdown>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { 
  OfficeBuilding, 
  ArrowDown, 
  Loading, 
  Check 
} from '@element-plus/icons-vue'
import { useTenantStore } from '@/stores'
import { TenantType, TenantStatus } from '@/types'
import type { TenantInfo } from '@/types'

// Props
interface Props {
  showManage?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  showManage: true
})

// Emits
const emit = defineEmits<{
  tenantChanged: [tenant: TenantInfo]
  manageTenants: []
}>()

// Store
const tenantStore = useTenantStore()

// Computed
const currentTenant = computed(() => tenantStore.currentTenant)
const availableTenants = computed(() => tenantStore.availableTenants)
const loading = computed(() => tenantStore.tenantLoading)
const isAdmin = computed(() => tenantStore.isAdmin)

// Methods
const handleTenantSwitch = async (tenantId: string) => {
  if (tenantId === currentTenant.value?.id) {
    return
  }
  
  const success = await tenantStore.switchTenant(tenantId)
  if (success && currentTenant.value) {
    emit('tenantChanged', currentTenant.value)
  }
}

const handleManageTenants = () => {
  emit('manageTenants')
}

const getTenantTypeText = (type: TenantType): string => {
  return tenantStore.getTenantDisplayText({ type } as TenantInfo).split(' ')[1] || ''
}

const getTenantTypeColor = (type: TenantType): string => {
  const colorMap: Record<TenantType, string> = {
    [TenantType.TRIAL]: 'info',
    [TenantType.STANDARD]: 'primary',
    [TenantType.PREMIUM]: 'warning',
    [TenantType.ENTERPRISE]: 'success'
  }
  return colorMap[type] || 'info'
}

const getTenantStatusText = (status: TenantStatus): string => {
  return tenantStore.getTenantStatusText(status)
}

const getTenantStatusColor = (status: TenantStatus): string => {
  return tenantStore.getTenantStatusColor(status)
}

// Lifecycle
onMounted(() => {
  tenantStore.initTenant()
})
</script>

<style scoped lang="scss">
.tenant-switcher {
  .current-tenant {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 8px 12px;
    background: var(--el-bg-color);
    border: 1px solid var(--el-border-color);
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.2s;
    min-width: 200px;

    &:hover {
      border-color: var(--el-color-primary);
      background: var(--el-color-primary-light-9);
    }

    .tenant-info {
      display: flex;
      align-items: center;
      gap: 8px;
      flex: 1;

      .tenant-avatar {
        flex-shrink: 0;
      }

      .tenant-icon {
        color: var(--el-color-info);
        flex-shrink: 0;
      }

      .tenant-details {
        min-width: 0;
        flex: 1;

        .tenant-name {
          font-size: 14px;
          font-weight: 500;
          color: var(--el-text-color-primary);
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }

        .tenant-type {
          font-size: 12px;
          color: var(--el-text-color-secondary);
          margin-top: 1px;
        }
      }
    }

    .dropdown-arrow {
      color: var(--el-text-color-secondary);
      transition: transform 0.2s;
      
      &.loading {
        animation: rotating 2s linear infinite;
      }
    }
  }
}

.tenant-list {
  min-width: 280px;
  max-width: 320px;

  .tenant-list-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12px 16px 8px;
    border-bottom: 1px solid var(--el-border-color-light);
    font-weight: 500;
    color: var(--el-text-color-primary);
  }

  .tenant-items {
    max-height: 300px;
    overflow-y: auto;

    :deep(.el-dropdown-menu__item) {
      padding: 0;
      
      &:hover {
        background: var(--el-color-primary-light-9);
      }

      &.is-current {
        background: var(--el-color-primary-light-8);
        
        .tenant-item {
          .tenant-name {
            color: var(--el-color-primary);
            font-weight: 500;
          }
        }
      }

      &.is-inactive {
        opacity: 0.7;
        
        .tenant-item {
          .tenant-name {
            color: var(--el-text-color-disabled);
          }
        }
      }
    }

    .tenant-item {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 12px 16px;
      width: 100%;

      .tenant-avatar {
        flex-shrink: 0;
      }

      .tenant-icon {
        color: var(--el-color-info);
        flex-shrink: 0;
      }

      .tenant-content {
        flex: 1;
        min-width: 0;

        .tenant-name {
          font-size: 14px;
          font-weight: 400;
          color: var(--el-text-color-primary);
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
          margin-bottom: 4px;
        }

        .tenant-meta {
          display: flex;
          gap: 6px;

          .status-tag {
            font-size: 11px;
          }
        }
      }

      .check-icon {
        flex-shrink: 0;
      }
    }
  }

  .empty-state {
    padding: 20px;
    text-align: center;
  }
}

@keyframes rotating {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}
</style>