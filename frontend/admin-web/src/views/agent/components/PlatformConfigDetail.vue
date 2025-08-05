<template>
  <div class="platform-config-detail">
    <!-- 基本信息 -->
    <div class="detail-section">
      <div class="section-title">
        <el-icon><InfoFilled /></el-icon>
        <span>基本信息</span>
      </div>
      
      <div class="info-grid">
        <div class="info-item">
          <label>平台名称</label>
          <span>{{ data.platformName }}</span>
        </div>
        
        <div class="info-item">
          <label>平台类型</label>
          <el-tag :type="getPlatformTypeTagType(data.platformType)" size="small">
            {{ getPlatformTypeText(data.platformType) }}
          </el-tag>
        </div>
        
        <div class="info-item">
          <label>状态</label>
          <el-tag :type="data.enabled ? 'success' : 'info'" size="small">
            {{ data.enabled ? '已启用' : '已禁用' }}
          </el-tag>
        </div>
        
        <div class="info-item">
          <label>优先级</label>
          <span>{{ getPriorityText(data.priority) }}</span>
        </div>
        
        <div class="info-item">
          <label>创建时间</label>
          <span>{{ formatDateTime(data.createdAt) }}</span>
        </div>
        
        <div class="info-item">
          <label>更新时间</label>
          <span>{{ formatDateTime(data.updatedAt) }}</span>
        </div>
      </div>
      
      <div v-if="data.description" class="info-item full-width">
        <label>平台描述</label>
        <p class="description">{{ data.description }}</p>
      </div>
    </div>

    <!-- 连接配置 -->
    <div class="detail-section">
      <div class="section-title">
        <el-icon><Connection /></el-icon>
        <span>连接配置</span>
      </div>
      
      <div class="info-grid">
        <div class="info-item">
          <label>API端点</label>
          <span class="monospace">{{ data.endpoint }}</span>
        </div>
        
        <div class="info-item">
          <label>API版本</label>
          <span>{{ data.apiVersion }}</span>
        </div>
        
        <div class="info-item">
          <label>超时时间</label>
          <span>{{ data.timeoutSeconds }}秒</span>
        </div>
        
        <div class="info-item">
          <label>重试次数</label>
          <span>{{ data.retryCount }}次</span>
        </div>
        
        <div class="info-item">
          <label>启用日志</label>
          <el-tag :type="data.enableLogging ? 'success' : 'info'" size="small">
            {{ data.enableLogging ? '已启用' : '已禁用' }}
          </el-tag>
        </div>
      </div>
    </div>

    <!-- 认证配置 -->
    <div class="detail-section">
      <div class="section-title">
        <el-icon><Key /></el-icon>
        <span>认证配置</span>
      </div>
      
      <div class="info-grid">
        <div class="info-item">
          <label>认证方式</label>
          <el-tag size="small">{{ getAuthTypeText(data.authType) }}</el-tag>
        </div>

        <!-- API Key 认证 -->
        <template v-if="data.authType === 'API_KEY'">
          <div class="info-item">
            <label>Key参数名</label>
            <span class="monospace">{{ data.apiKeyName }}</span>
          </div>
          <div class="info-item">
            <label>API Key</label>
            <span class="masked">{{ maskSensitiveData(data.apiKey) }}</span>
          </div>
        </template>

        <!-- Bearer Token 认证 -->
        <template v-if="data.authType === 'BEARER_TOKEN'">
          <div class="info-item">
            <label>Access Token</label>
            <span class="masked">{{ maskSensitiveData(data.accessToken) }}</span>
          </div>
        </template>

        <!-- OAuth 2.0 认证 -->
        <template v-if="data.authType === 'OAUTH2'">
          <div class="info-item">
            <label>Client ID</label>
            <span class="monospace">{{ data.clientId }}</span>
          </div>
          <div class="info-item">
            <label>Client Secret</label>
            <span class="masked">{{ maskSensitiveData(data.clientSecret) }}</span>
          </div>
          <div class="info-item">
            <label>授权URL</label>
            <span class="monospace">{{ data.authUrl }}</span>
          </div>
          <div class="info-item">
            <label>Token URL</label>
            <span class="monospace">{{ data.tokenUrl }}</span>
          </div>
          <div v-if="data.scopes" class="info-item full-width">
            <label>授权范围</label>
            <div class="scopes">
              <el-tag
                v-for="scope in data.scopes?.split(',')"
                :key="scope"
                size="small"
                class="scope-tag"
              >
                {{ scope.trim() }}
              </el-tag>
            </div>
          </div>
        </template>
      </div>
    </div>

    <!-- 自定义Headers -->
    <div v-if="customHeaders.length > 0" class="detail-section">
      <div class="section-title">
        <el-icon><Document /></el-icon>
        <span>自定义Headers</span>
      </div>
      
      <div class="headers-list">
        <div
          v-for="(header, index) in customHeaders"
          :key="index"
          class="header-item"
        >
          <span class="header-key">{{ header.key }}</span>
          <span class="header-separator">:</span>
          <span class="header-value masked">{{ maskSensitiveData(header.value) }}</span>
        </div>
      </div>
    </div>

    <!-- 配置参数 -->
    <div v-if="configParams.length > 0" class="detail-section">
      <div class="section-title">
        <el-icon><Setting /></el-icon>
        <span>配置参数</span>
      </div>
      
      <div class="params-list">
        <div
          v-for="(param, index) in configParams"
          :key="index"
          class="param-item"
        >
          <span class="param-key">{{ param.key }}</span>
          <span class="param-separator">:</span>
          <span class="param-value">{{ param.value }}</span>
        </div>
      </div>
    </div>

    <!-- 连接测试历史 -->
    <div class="detail-section">
      <div class="section-title">
        <el-icon><Monitor /></el-icon>
        <span>连接测试</span>
      </div>
      
      <div class="test-info">
        <div class="info-item">
          <label>最后测试时间</label>
          <span>{{ data.lastTestTime ? formatDateTime(data.lastTestTime) : '未测试' }}</span>
        </div>
        
        <div class="info-item">
          <label>测试结果</label>
          <el-tag 
            :type="getTestResultType(data.lastTestResult)" 
            size="small"
          >
            {{ getTestResultText(data.lastTestResult) }}
          </el-tag>
        </div>
        
        <div v-if="data.lastTestError" class="info-item full-width">
          <label>错误信息</label>
          <div class="error-message">
            {{ data.lastTestError }}
          </div>
        </div>
      </div>
      
      <!-- 测试按钮 -->
      <div class="test-actions">
        <el-button 
          type="primary" 
          @click="handleTestConnection"
          :loading="testing"
        >
          重新测试连接
        </el-button>
      </div>
    </div>

    <!-- 备注信息 -->
    <div v-if="data.remarks" class="detail-section">
      <div class="section-title">
        <el-icon><ChatLineRound /></el-icon>
        <span>备注信息</span>
      </div>
      
      <div class="remarks">
        {{ data.remarks }}
      </div>
    </div>

    <!-- 操作按钮 -->
    <div class="detail-actions">
      <el-button @click="$emit('close')">关闭</el-button>
      <el-button type="primary" @click="handleEdit">
        编辑配置
      </el-button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { 
  InfoFilled, Connection, Key, Document, Setting, 
  Monitor, ChatLineRound 
} from '@element-plus/icons-vue'
import { agentApi } from '@/api/agent'
import type { PlatformConfigDTO, PlatformType } from '@/types'

// ==================== Props & Emits ====================

interface Props {
  data: PlatformConfigDTO
}

interface Emits {
  (event: 'close'): void
  (event: 'edit', data: PlatformConfigDTO): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

// ==================== 数据定义 ====================

const testing = ref(false)

// 解析自定义Headers
const customHeaders = computed(() => {
  try {
    const headers = JSON.parse(props.data.customHeaders || '{}')
    return Object.entries(headers).map(([key, value]) => ({
      key,
      value: value as string
    }))
  } catch (error) {
    return []
  }
})

// 解析配置参数
const configParams = computed(() => {
  try {
    const params = JSON.parse(props.data.configParams || '{}')
    return Object.entries(params).map(([key, value]) => ({
      key,
      value: value as string
    }))
  } catch (error) {
    return []
  }
})

// ==================== 方法定义 ====================

// 格式化日期时间
const formatDateTime = (dateTime?: string) => {
  if (!dateTime) return '-'
  return new Date(dateTime).toLocaleString()
}

// 遮蔽敏感数据
const maskSensitiveData = (data?: string) => {
  if (!data) return '-'
  if (data.length <= 8) return '*'.repeat(data.length)
  return data.substring(0, 4) + '*'.repeat(data.length - 8) + data.substring(data.length - 4)
}

// 获取平台类型文本
const getPlatformTypeText = (type: PlatformType) => {
  const typeMap: Record<PlatformType, string> = {
    'COZE': 'Coze',
    'DIFY': 'Dify',
    'ALIBABA_DASHSCOPE': '阿里百炼',
    'OPENAI': 'OpenAI',
    'CLAUDE': 'Claude',
    'WENXIN_YIYAN': '文心一言',
    'CUSTOM': '自定义平台'
  }
  return typeMap[type] || type
}

// 获取平台类型标签类型
const getPlatformTypeTagType = (type: PlatformType) => {
  const typeMap: Record<string, string> = {
    'COZE': 'primary',
    'DIFY': 'success',
    'ALIBABA_DASHSCOPE': 'warning',
    'OPENAI': 'danger',
    'CLAUDE': 'info',
    'WENXIN_YIYAN': 'primary',
    'CUSTOM': 'default'
  }
  return typeMap[type] || 'default'
}

// 获取认证方式文本
const getAuthTypeText = (type: string) => {
  const typeMap: Record<string, string> = {
    'API_KEY': 'API Key',
    'BEARER_TOKEN': 'Bearer Token',
    'OAUTH2': 'OAuth 2.0',
    'CUSTOM': '自定义认证'
  }
  return typeMap[type] || type
}

// 获取优先级文本
const getPriorityText = (priority: number) => {
  const priorityMap: Record<number, string> = {
    1: '最高',
    2: '高',
    3: '中等',
    4: '低',
    5: '最低'
  }
  return priorityMap[priority] || `${priority}`
}

// 获取测试结果文本
const getTestResultText = (result?: string) => {
  const resultMap: Record<string, string> = {
    'SUCCESS': '连接成功',
    'FAILED': '连接失败',
    'TIMEOUT': '连接超时'
  }
  return resultMap[result || ''] || '未测试'
}

// 获取测试结果标签类型
const getTestResultType = (result?: string) => {
  const typeMap: Record<string, string> = {
    'SUCCESS': 'success',
    'FAILED': 'danger',
    'TIMEOUT': 'warning'
  }
  return typeMap[result || ''] || 'info'
}

// 测试连接
const handleTestConnection = async () => {
  testing.value = true
  try {
    const response = await agentApi.testPlatformConnection(props.data.id!)
    if (response.success) {
      ElMessage.success('连接测试成功')
      // 更新测试结果（这里应该重新获取数据）
    } else {
      ElMessage.error(response.message || '连接测试失败')
    }
  } catch (error) {
    console.error('连接测试失败:', error)
    ElMessage.error('连接测试失败')
  } finally {
    testing.value = false
  }
}

// 编辑配置
const handleEdit = () => {
  emit('edit', props.data)
}
</script>

<style lang="scss" scoped>
.platform-config-detail {
  .detail-section {
    margin-bottom: 32px;
    
    .section-title {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 16px;
      font-weight: 600;
      color: var(--el-text-color-primary);
      margin-bottom: 16px;
      padding-bottom: 8px;
      border-bottom: 1px solid var(--el-border-color-light);
    }
  }
  
  .info-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 16px;
    
    .info-item {
      display: flex;
      flex-direction: column;
      gap: 4px;
      
      &.full-width {
        grid-column: 1 / -1;
      }
      
      label {
        font-size: 12px;
        color: var(--el-text-color-secondary);
        font-weight: 500;
      }
      
      span, p {
        color: var(--el-text-color-primary);
        
        &.monospace {
          font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
          background: var(--el-bg-color-page);
          padding: 2px 6px;
          border-radius: 4px;
          font-size: 12px;
        }
        
        &.masked {
          font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
          background: var(--el-bg-color-page);
          padding: 2px 6px;
          border-radius: 4px;
          font-size: 12px;
          color: var(--el-text-color-secondary);
        }
      }
      
      .description {
        margin: 0;
        line-height: 1.5;
        padding: 8px 12px;
        background: var(--el-bg-color-page);
        border-radius: 4px;
        border-left: 3px solid var(--el-color-primary);
      }
    }
  }
  
  .scopes {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    
    .scope-tag {
      margin: 0;
    }
  }
  
  .headers-list,
  .params-list {
    .header-item,
    .param-item {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 8px 12px;
      background: var(--el-bg-color-page);
      border-radius: 4px;
      margin-bottom: 8px;
      font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
      font-size: 12px;
      
      .header-key,
      .param-key {
        color: var(--el-color-primary);
        font-weight: 500;
        min-width: 120px;
      }
      
      .header-separator,
      .param-separator {
        color: var(--el-text-color-secondary);
      }
      
      .header-value {
        color: var(--el-text-color-secondary);
        
        &.masked {
          color: var(--el-text-color-secondary);
        }
      }
      
      .param-value {
        color: var(--el-text-color-primary);
      }
    }
  }
  
  .test-info {
    margin-bottom: 16px;
    
    .error-message {
      padding: 8px 12px;
      background: var(--el-color-error-light-9);
      border: 1px solid var(--el-color-error-light-7);
      border-radius: 4px;
      color: var(--el-color-error);
      font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
      font-size: 12px;
      line-height: 1.5;
    }
  }
  
  .test-actions {
    padding-top: 12px;
    border-top: 1px solid var(--el-border-color-lighter);
  }
  
  .remarks {
    padding: 12px 16px;
    background: var(--el-bg-color-page);
    border-radius: 4px;
    border-left: 3px solid var(--el-color-info);
    line-height: 1.6;
  }
  
  .detail-actions {
    display: flex;
    justify-content: flex-end;
    gap: 12px;
    padding-top: 24px;
    border-top: 1px solid var(--el-border-color-light);
  }
}
</style>