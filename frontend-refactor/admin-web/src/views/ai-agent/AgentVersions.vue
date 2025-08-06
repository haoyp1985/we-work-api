<template>
  <div class="agent-versions">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-left">
        <el-button 
          type="text" 
          :icon="ArrowLeft"
          @click="handleGoBack"
        >
          返回智能体列表
        </el-button>
        <div class="agent-info">
          <h1>{{ agentInfo.name }} - 版本管理</h1>
          <p>管理智能体的版本发布、灰度部署和回滚操作</p>
        </div>
      </div>
      <div class="header-actions">
        <el-button 
          type="primary" 
          :icon="Plus"
          @click="handleCreateVersion"
        >
          创建新版本
        </el-button>
        <el-button 
          :icon="Upload"
          @click="handleImportVersion"
        >
          导入版本
        </el-button>
        <el-button 
          :icon="Document"
          @click="handleViewTemplates"
        >
          版本模板
        </el-button>
      </div>
    </div>

    <!-- 当前生产版本概览 -->
    <el-card class="current-version-card" shadow="never">
      <template #header>
        <div class="card-header">
          <span>当前生产版本</span>
          <el-tag v-if="currentVersion" type="success" size="small">
            {{ currentVersion.version }}
          </el-tag>
        </div>
      </template>
      
      <div v-if="currentVersion" class="current-version-info">
        <el-row :gutter="20">
          <el-col :span="8">
            <div class="info-item">
              <span class="label">版本标题：</span>
              <span class="value">{{ currentVersion.title }}</span>
            </div>
            <div class="info-item">
              <span class="label">发布时间：</span>
              <span class="value">{{ formatDateTime(currentVersion.metadata.publishedAt) }}</span>
            </div>
          </el-col>
          <el-col :span="8">
            <div class="info-item">
              <span class="label">发布人：</span>
              <span class="value">{{ currentVersion.metadata.publishedByName }}</span>
            </div>
            <div class="info-item">
              <span class="label">对话数量：</span>
              <span class="value">{{ currentVersion.statistics.conversationCount }}</span>
            </div>
          </el-col>
          <el-col :span="8">
            <div class="info-item">
              <span class="label">平均响应时间：</span>
              <span class="value">{{ currentVersion.statistics.averageResponseTime }}ms</span>
            </div>
            <div class="info-item">
              <span class="label">满意度评分：</span>
              <span class="value">
                <el-rate 
                  :model-value="currentVersion.statistics.satisfactionScore" 
                  disabled 
                  size="small"
                  show-score
                />
              </span>
            </div>
          </el-col>
        </el-row>
      </div>
      <div v-else class="no-production-version">
        <el-empty description="暂无生产版本" />
      </div>
    </el-card>

    <!-- 版本列表 -->
    <el-card class="versions-card" shadow="never">
      <template #header>
        <div class="card-header">
          <div class="header-title">
            <span>版本历史</span>
            <el-tag type="info" size="small">共 {{ pagination.total }} 个版本</el-tag>
          </div>
          <div class="header-filters">
            <el-select 
              v-model="searchForm.status" 
              placeholder="版本状态" 
              clearable
              style="width: 120px; margin-right: 12px"
            >
              <el-option label="草稿" value="DRAFT" />
              <el-option label="测试中" value="TESTING" />
              <el-option label="已发布" value="PUBLISHED" />
              <el-option label="已归档" value="ARCHIVED" />
            </el-select>
            <el-input
              v-model="searchForm.keyword"
              placeholder="搜索版本标题"
              :prefix-icon="Search"
              clearable
              style="width: 200px; margin-right: 12px"
              @keyup.enter="handleSearch"
            />
            <el-button type="primary" :icon="Search" @click="handleSearch">
              搜索
            </el-button>
          </div>
        </div>
      </template>

      <div class="versions-timeline">
        <div 
          v-for="version in versionList" 
          :key="version.id"
          class="version-item"
          :class="{ 'current': version.status === 'PUBLISHED' }"
        >
          <div class="version-timeline-icon">
            <el-icon v-if="version.status === 'PUBLISHED'" color="#67c23a"><CircleCheck /></el-icon>
            <el-icon v-else-if="version.status === 'TESTING'" color="#e6a23c"><Clock /></el-icon>
            <el-icon v-else-if="version.status === 'DRAFT'" color="#909399"><Edit /></el-icon>
            <el-icon v-else color="#c0c4cc"><Archive /></el-icon>
          </div>
          
          <div class="version-content">
            <div class="version-header">
              <div class="version-title">
                <span class="version-number">{{ version.version }}</span>
                <span class="version-name">{{ version.title }}</span>
                <el-tag 
                  :type="getVersionStatusType(version.status)" 
                  size="small"
                >
                  {{ getVersionStatusText(version.status) }}
                </el-tag>
                <el-tag 
                  v-if="version.deploymentStatus !== 'SUCCESS'"
                  :type="getDeploymentStatusType(version.deploymentStatus)" 
                  size="small"
                  style="margin-left: 8px"
                >
                  {{ getDeploymentStatusText(version.deploymentStatus) }}
                </el-tag>
              </div>
              <div class="version-actions">
                <el-button type="primary" size="small" link @click="handleViewVersion(version)">
                  查看详情
                </el-button>
                <el-dropdown @command="(command) => handleVersionAction(command, version)">
                  <el-button size="small" link>
                    更多 <el-icon><ArrowDown /></el-icon>
                  </el-button>
                  <template #dropdown>
                    <el-dropdown-menu>
                      <el-dropdown-item 
                        v-if="version.status === 'DRAFT'"
                        command="edit" 
                        :icon="Edit"
                      >
                        编辑
                      </el-dropdown-item>
                      <el-dropdown-item 
                        v-if="version.status === 'DRAFT'"
                        command="publishTest" 
                        :icon="Upload"
                      >
                        发布到测试
                      </el-dropdown-item>
                      <el-dropdown-item 
                        v-if="version.status === 'TESTING'"
                        command="publishProd" 
                        :icon="Promotion"
                      >
                        发布到生产
                      </el-dropdown-item>
                      <el-dropdown-item 
                        v-if="version.status === 'TESTING'"
                        command="grayRelease" 
                        :icon="Platform"
                      >
                        灰度发布
                      </el-dropdown-item>
                      <el-dropdown-item command="clone" :icon="CopyDocument">
                        复制版本
                      </el-dropdown-item>
                      <el-dropdown-item 
                        v-if="version.status === 'PUBLISHED' && version.id !== currentVersion?.id"
                        command="rollback" 
                        :icon="RefreshLeft"
                      >
                        回滚到此版本
                      </el-dropdown-item>
                      <el-dropdown-item command="compare" :icon="Operation">
                        版本对比
                      </el-dropdown-item>
                      <el-dropdown-item command="export" :icon="Download">
                        导出配置
                      </el-dropdown-item>
                      <el-dropdown-item 
                        v-if="version.status !== 'PUBLISHED'"
                        command="delete" 
                        :icon="Delete"
                        style="color: #f56c6c"
                      >
                        删除
                      </el-dropdown-item>
                    </el-dropdown-menu>
                  </template>
                </el-dropdown>
              </div>
            </div>
            
            <div class="version-description">
              {{ version.description || '暂无描述' }}
            </div>
            
            <div class="version-meta">
              <span class="meta-item">
                <el-icon><User /></el-icon>
                {{ version.metadata.createdByName }}
              </span>
              <span class="meta-item">
                <el-icon><Calendar /></el-icon>
                {{ formatDateTime(version.metadata.createdAt) }}
              </span>
              <span v-if="version.statistics.conversationCount > 0" class="meta-item">
                <el-icon><ChatDotRound /></el-icon>
                {{ version.statistics.conversationCount }} 对话
              </span>
              <span v-if="version.statistics.averageResponseTime > 0" class="meta-item">
                <el-icon><Timer /></el-icon>
                {{ version.statistics.averageResponseTime }}ms
              </span>
            </div>
            
            <div v-if="version.tags.length > 0" class="version-tags">
              <el-tag 
                v-for="tag in version.tags" 
                :key="tag"
                size="small"
                type="info"
                style="margin-right: 4px"
              >
                {{ tag }}
              </el-tag>
            </div>
          </div>
        </div>
      </div>

      <!-- 分页 -->
      <div class="pagination-wrapper">
        <el-pagination
          v-model:current-page="pagination.current"
          v-model:page-size="pagination.size"
          :total="pagination.total"
          :page-sizes="[10, 20, 50]"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handlePageChange"
        />
      </div>
    </el-card>

    <!-- 版本表单对话框 -->
    <VersionForm
      v-model="versionFormVisible"
      :agent-id="agentId"
      :version-data="currentVersionData"
      :is-edit="isEditVersion"
      @success="handleVersionFormSuccess"
    />

    <!-- 版本详情对话框 -->
    <VersionDetail
      v-model="versionDetailVisible"
      :agent-id="agentId"
      :version-id="currentVersionId"
    />

    <!-- 版本比较对话框 -->
    <VersionCompare
      v-model="compareDialogVisible"
      :agent-id="agentId"
      :source-version-id="compareSourceId"
      :target-version-id="compareTargetId"
    />

    <!-- 灰度发布对话框 -->
    <GrayReleaseDialog
      v-model="grayReleaseVisible"
      :agent-id="agentId"
      :version-id="grayReleaseVersionId"
      @success="handleGrayReleaseSuccess"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { 
  ArrowLeft,
  Plus, 
  Upload, 
  Document,
  Search,
  CircleCheck,
  Clock,
  Edit,
  Archive,
  ArrowDown,
  Promotion,
  Platform,
  CopyDocument,
  RefreshLeft,
  Operation,
  Download,
  Delete,
  User,
  Calendar,
  ChatDotRound,
  Timer
} from '@element-plus/icons-vue'
import * as agentVersionApi from '@/api/agent-version'
import * as agentApi from '@/api/agent'
import type { AgentVersion, VersionStatus, DeploymentStatus } from '@/api/agent-version'
import type { Agent } from '@/types/api'
import VersionForm from './components/VersionForm.vue'
import VersionDetail from './components/VersionDetail.vue'
import VersionCompare from './components/VersionCompare.vue'
import GrayReleaseDialog from './components/GrayReleaseDialog.vue'

const route = useRoute()
const router = useRouter()

// 获取智能体ID
const agentId = computed(() => route.params.id as string)

// 响应式数据
const loading = ref(false)
const agentInfo = ref<Agent>({} as Agent)
const versionList = ref<AgentVersion[]>([])
const currentVersion = ref<AgentVersion | null>(null)

// 搜索表单
const searchForm = reactive({
  status: '' as VersionStatus | '',
  keyword: ''
})

// 分页信息
const pagination = reactive({
  current: 1,
  size: 10,
  total: 0
})

// 对话框状态
const versionFormVisible = ref(false)
const versionDetailVisible = ref(false)
const compareDialogVisible = ref(false)
const grayReleaseVisible = ref(false)

// 当前操作数据
const currentVersionData = ref<AgentVersion | null>(null)
const currentVersionId = ref('')
const isEditVersion = ref(false)
const compareSourceId = ref('')
const compareTargetId = ref('')
const grayReleaseVersionId = ref('')

// 工具函数
const getVersionStatusType = (status: VersionStatus): string => {
  const typeMap = {
    'DRAFT': 'info',
    'TESTING': 'warning',
    'PUBLISHED': 'success',
    'ARCHIVED': ''
  }
  return typeMap[status] || 'info'
}

const getVersionStatusText = (status: VersionStatus): string => {
  const textMap = {
    'DRAFT': '草稿',
    'TESTING': '测试中',
    'PUBLISHED': '已发布',
    'ARCHIVED': '已归档'
  }
  return textMap[status] || status
}

const getDeploymentStatusType = (status: DeploymentStatus): string => {
  const typeMap = {
    'PENDING': 'info',
    'DEPLOYING': 'warning',
    'SUCCESS': 'success',
    'FAILED': 'danger',
    'ROLLBACK': 'warning'
  }
  return typeMap[status] || 'info'
}

const getDeploymentStatusText = (status: DeploymentStatus): string => {
  const textMap = {
    'PENDING': '待部署',
    'DEPLOYING': '部署中',
    'SUCCESS': '部署成功',
    'FAILED': '部署失败',
    'ROLLBACK': '回滚中'
  }
  return textMap[status] || status
}

const formatDateTime = (timeStr: string): string => {
  if (!timeStr) return '-'
  return new Date(timeStr).toLocaleString()
}

// API调用函数
const loadAgentInfo = async () => {
  try {
    const response = await agentApi.getAgent(agentId.value)
    agentInfo.value = response.data
  } catch (error) {
    console.error('加载智能体信息失败:', error)
    ElMessage.error('加载智能体信息失败')
  }
}

const loadVersions = async () => {
  loading.value = true
  try {
    const params = {
      current: pagination.current,
      size: pagination.size,
      status: searchForm.status || undefined,
      keyword: searchForm.keyword || undefined
    }
    
    const response = await agentVersionApi.getAgentVersions(agentId.value, params)
    versionList.value = response.data.records
    pagination.total = response.data.total
    
    // 查找当前生产版本
    currentVersion.value = versionList.value.find(v => v.status === 'PUBLISHED') || null
  } catch (error) {
    console.error('加载版本列表失败:', error)
    ElMessage.error('加载版本列表失败')
  } finally {
    loading.value = false
  }
}

// 事件处理函数
const handleGoBack = () => {
  router.push('/ai-agent')
}

const handleSearch = () => {
  pagination.current = 1
  loadVersions()
}

const handlePageChange = () => {
  loadVersions()
}

const handleSizeChange = () => {
  pagination.current = 1
  loadVersions()
}

const handleCreateVersion = () => {
  currentVersionData.value = null
  isEditVersion.value = false
  versionFormVisible.value = true
}

const handleImportVersion = () => {
  ElMessage.info('导入版本功能开发中...')
}

const handleViewTemplates = () => {
  ElMessage.info('版本模板功能开发中...')
}

const handleViewVersion = (version: AgentVersion) => {
  currentVersionId.value = version.id
  versionDetailVisible.value = true
}

const handleVersionAction = async (command: string, version: AgentVersion) => {
  try {
    switch (command) {
      case 'edit':
        currentVersionData.value = version
        isEditVersion.value = true
        versionFormVisible.value = true
        break
        
      case 'publishTest':
        await ElMessageBox.confirm(
          `确认将版本 ${version.version} 发布到测试环境？`,
          '确认发布',
          { type: 'warning' }
        )
        await agentVersionApi.publishVersionToTest(agentId.value, version.id)
        await loadVersions()
        break
        
      case 'publishProd':
        await ElMessageBox.confirm(
          `确认将版本 ${version.version} 发布到生产环境？`,
          '确认发布',
          { type: 'warning' }
        )
        await agentVersionApi.publishVersionToProduction(agentId.value, version.id, {
          immediate: true
        })
        await loadVersions()
        break
        
      case 'grayRelease':
        grayReleaseVersionId.value = version.id
        grayReleaseVisible.value = true
        break
        
      case 'clone':
        await ElMessageBox.prompt(
          '请输入新版本标题',
          '复制版本',
          { inputPlaceholder: '版本标题' }
        ).then(async ({ value }) => {
          await agentVersionApi.cloneAgentVersion(agentId.value, version.id, {
            title: value,
            changeLog: `基于版本 ${version.version} 复制创建`
          })
          await loadVersions()
        })
        break
        
      case 'rollback':
        await ElMessageBox.prompt(
          `确认回滚到版本 ${version.version}？请输入回滚原因：`,
          '确认回滚',
          { 
            type: 'warning',
            inputPlaceholder: '回滚原因'
          }
        ).then(async ({ value }) => {
          await agentVersionApi.rollbackToVersion(agentId.value, version.id, value)
          await loadVersions()
        })
        break
        
      case 'compare':
        if (currentVersion.value) {
          compareSourceId.value = currentVersion.value.id
          compareTargetId.value = version.id
          compareDialogVisible.value = true
        } else {
          ElMessage.warning('请先选择对比的基准版本')
        }
        break
        
      case 'export':
        const exportResponse = await agentVersionApi.exportVersionConfig(agentId.value, version.id)
        const link = document.createElement('a')
        link.href = exportResponse.data.downloadUrl
        link.download = exportResponse.data.fileName
        link.click()
        break
        
      case 'delete':
        await ElMessageBox.confirm(
          `确认删除版本 ${version.version}？此操作不可恢复！`,
          '确认删除',
          { type: 'error' }
        )
        await agentVersionApi.deleteAgentVersion(agentId.value, version.id)
        await loadVersions()
        break
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('版本操作失败:', error)
      ElMessage.error('操作失败')
    }
  }
}

const handleVersionFormSuccess = () => {
  versionFormVisible.value = false
  loadVersions()
}

const handleGrayReleaseSuccess = () => {
  grayReleaseVisible.value = false
  loadVersions()
}

// 初始化
onMounted(() => {
  loadAgentInfo()
  loadVersions()
})
</script>

<style scoped lang="scss">
.agent-versions {
  padding: 20px;

  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 20px;

    .header-left {
      .agent-info {
        margin-top: 8px;
        
        h1 {
          margin: 0 0 8px 0;
          color: #1f2329;
          font-size: 24px;
          font-weight: 600;
        }

        p {
          margin: 0;
          color: #86909c;
          font-size: 14px;
        }
      }
    }

    .header-actions {
      display: flex;
      gap: 12px;
    }
  }

  .current-version-card {
    margin-bottom: 20px;
    border-radius: 8px;

    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-weight: 600;
      color: #1f2329;
    }

    .current-version-info {
      .info-item {
        display: flex;
        margin-bottom: 8px;

        .label {
          color: #86909c;
          min-width: 100px;
        }

        .value {
          color: #1f2329;
          font-weight: 500;
        }
      }
    }

    .no-production-version {
      text-align: center;
      padding: 40px;
    }
  }

  .versions-card {
    border-radius: 8px;

    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;

      .header-title {
        display: flex;
        align-items: center;
        gap: 12px;
        font-weight: 600;
        color: #1f2329;
      }

      .header-filters {
        display: flex;
        align-items: center;
      }
    }

    .versions-timeline {
      .version-item {
        display: flex;
        margin-bottom: 24px;
        position: relative;

        &:not(:last-child)::after {
          content: '';
          position: absolute;
          left: 11px;
          top: 40px;
          bottom: -24px;
          width: 2px;
          background: #e5e5e5;
        }

        &.current {
          .version-content {
            background: #f0f9f0;
            border-left: 3px solid #67c23a;
          }
        }

        .version-timeline-icon {
          width: 24px;
          height: 24px;
          border-radius: 50%;
          background: #fff;
          border: 2px solid #e5e5e5;
          display: flex;
          align-items: center;
          justify-content: center;
          margin-right: 16px;
          flex-shrink: 0;
          position: relative;
          z-index: 1;
        }

        .version-content {
          flex: 1;
          background: #fafafa;
          border-radius: 8px;
          padding: 16px;
          border-left: 3px solid transparent;

          .version-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;

            .version-title {
              display: flex;
              align-items: center;
              gap: 8px;

              .version-number {
                font-weight: 600;
                color: #1f2329;
                font-size: 16px;
              }

              .version-name {
                font-weight: 500;
                color: #1f2329;
              }
            }

            .version-actions {
              display: flex;
              gap: 8px;
            }
          }

          .version-description {
            color: #86909c;
            margin-bottom: 12px;
            line-height: 1.5;
          }

          .version-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
            margin-bottom: 8px;

            .meta-item {
              display: flex;
              align-items: center;
              gap: 4px;
              color: #86909c;
              font-size: 12px;

              .el-icon {
                font-size: 12px;
              }
            }
          }

          .version-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 4px;
          }
        }
      }
    }

    .pagination-wrapper {
      display: flex;
      justify-content: center;
      margin-top: 20px;
    }
  }
}
</style>