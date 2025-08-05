<template>
  <div class="model-config-detail">
    <!-- 基本信息 -->
    <div class="detail-section">
      <div class="section-title">
        <el-icon><InfoFilled /></el-icon>
        <span>基本信息</span>
      </div>
      
      <div class="info-grid">
        <div class="info-item">
          <label>配置名称</label>
          <span>{{ data.configName }}</span>
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
          <label>创建时间</label>
          <span>{{ formatDate(data.createdAt) }}</span>
        </div>
        
        <div class="info-item" v-if="data.description">
          <label>描述</label>
          <span>{{ data.description }}</span>
        </div>
      </div>
    </div>

    <!-- 模型信息 -->
    <div class="detail-section">
      <div class="section-title">
        <el-icon><Cpu /></el-icon>
        <span>模型信息</span>
      </div>
      
      <div class="info-grid">
        <div class="info-item">
          <label>模型名称</label>
          <span>{{ data.modelName }}</span>
        </div>
        
        <div class="info-item" v-if="data.modelVersion">
          <label>模型版本</label>
          <span>{{ data.modelVersion }}</span>
        </div>
        
        <div class="info-item">
          <label>最大Token数</label>
          <span>{{ data.maxTokens?.toLocaleString() || 'N/A' }}</span>
        </div>
        
        <div class="info-item">
          <label>温度参数</label>
          <span>{{ data.temperature || 'N/A' }}</span>
        </div>
        
        <div class="info-item" v-if="data.topP">
          <label>Top P</label>
          <span>{{ data.topP }}</span>
        </div>
        
        <div class="info-item" v-if="data.frequencyPenalty">
          <label>频率惩罚</label>
          <span>{{ data.frequencyPenalty }}</span>
        </div>
        
        <div class="info-item" v-if="data.presencePenalty">
          <label>存在惩罚</label>
          <span>{{ data.presencePenalty }}</span>
        </div>
      </div>
    </div>

    <!-- 扩展配置 -->
    <div class="detail-section" v-if="data.configJson">
      <div class="section-title">
        <el-icon><Tools /></el-icon>
        <span>扩展配置</span>
      </div>
      
      <div class="config-display">
        <div class="config-header">
          <span>自定义配置参数</span>
          <el-button
            size="small"
            text
            @click="copyConfig"
          >
            <el-icon><DocumentCopy /></el-icon>
            复制配置
          </el-button>
        </div>
        
        <div class="config-content">
          <pre><code>{{ formatJsonConfig(data.configJson) }}</code></pre>
        </div>
      </div>
    </div>

    <!-- 功能开关 -->
    <div class="detail-section">
      <div class="section-title">
        <el-icon><SwitchButton /></el-icon>
        <span>功能开关</span>
      </div>
      
      <div class="switches-grid">
        <div class="switch-item">
          <label>启用状态</label>
          <el-switch
            :model-value="data.enabled"
            disabled
            active-text="启用"
            inactive-text="禁用"
          />
        </div>
        
        <div class="switch-item">
          <label>日志记录</label>
          <el-switch
            :model-value="data.enableLogging !== false"
            disabled
            active-text="启用"
            inactive-text="禁用"
          />
        </div>
      </div>
    </div>

    <!-- 使用统计 -->
    <div class="detail-section" v-if="statistics">
      <div class="section-title">
        <el-icon><DataAnalysis /></el-icon>
        <span>使用统计</span>
        <el-button
          size="small"
          text
          @click="refreshStatistics"
          :loading="statisticsLoading"
        >
          <el-icon><Refresh /></el-icon>
          刷新
        </el-button>
      </div>
      
      <div class="statistics-grid">
        <div class="stat-card">
          <div class="stat-number">{{ statistics.totalCalls || 0 }}</div>
          <div class="stat-label">总调用次数</div>
        </div>
        
        <div class="stat-card">
          <div class="stat-number">{{ statistics.successCalls || 0 }}</div>
          <div class="stat-label">成功调用</div>
        </div>
        
        <div class="stat-card">
          <div class="stat-number">{{ statistics.failedCalls || 0 }}</div>
          <div class="stat-label">失败调用</div>
        </div>
        
        <div class="stat-card">
          <div class="stat-number">{{ statistics.avgResponseTime || 0 }}ms</div>
          <div class="stat-label">平均响应时间</div>
        </div>
        
        <div class="stat-card">
          <div class="stat-number">{{ statistics.totalTokens || 0 }}</div>
          <div class="stat-label">总Token消耗</div>
        </div>
        
        <div class="stat-card">
          <div class="stat-number">{{ formatDate(statistics.lastUsedAt) || 'N/A' }}</div>
          <div class="stat-label">最后使用时间</div>
        </div>
      </div>
    </div>

    <!-- 备注信息 -->
    <div class="detail-section" v-if="data.remarks">
      <div class="section-title">
        <el-icon><Document /></el-icon>
        <span>备注信息</span>
      </div>
      
      <div class="remarks-content">
        {{ data.remarks }}
      </div>
    </div>

    <!-- 操作按钮 -->
    <div class="detail-actions">
      <el-button
        @click="$emit('close')"
      >
        关闭
      </el-button>
      
      <el-button
        type="warning"
        @click="$emit('test', data)"
        v-permission="'model-config:test'"
      >
        <el-icon><Lightning /></el-icon>
        测试配置
      </el-button>
      
      <el-button
        type="primary"
        @click="$emit('edit', data)"
        v-permission="'model-config:update'"
      >
        <el-icon><Edit /></el-icon>
        编辑配置
      </el-button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import {
  InfoFilled,
  Cpu,
  Tools,
  SwitchButton,
  DataAnalysis,
  Document,
  DocumentCopy,
  Refresh,
  Lightning,
  Edit
} from '@element-plus/icons-vue'

// 导入类型
import type { ModelConfigDTO, PlatformType } from '@/types/agent'
import { agentApi } from '@/api/agent'

// =============== Props & Emits ===============
interface Props {
  data: ModelConfigDTO
}

interface Emits {
  (event: 'edit', data: ModelConfigDTO): void
  (event: 'test', data: ModelConfigDTO): void
  (event: 'close'): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

// =============== 响应式数据 ===============
const statistics = ref<any>(null)
const statisticsLoading = ref(false)

// =============== 方法定义 ===============
const getPlatformTypeText = (type: PlatformType): string => {
  const typeMap = {
    'COZE': 'Coze',
    'DIFY': 'Dify',
    'ALIBABA_DASHSCOPE': '阿里百炼',
    'OPENAI': 'OpenAI',
    'CLAUDE': 'Claude',
    'WENXIN_YIYAN': '文心一言',
    'CUSTOM': '自定义'
  }
  return typeMap[type] || type
}

const getPlatformTypeTagType = (type: PlatformType): string => {
  const tagTypeMap = {
    'COZE': 'primary',
    'DIFY': 'success',
    'ALIBABA_DASHSCOPE': 'warning',
    'OPENAI': 'info',
    'CLAUDE': 'danger',
    'WENXIN_YIYAN': 'primary',
    'CUSTOM': 'info'
  }
  return tagTypeMap[type] || 'info'
}

const formatDate = (dateString: string): string => {
  if (!dateString) return 'N/A'
  return new Date(dateString).toLocaleString('zh-CN')
}

const formatJsonConfig = (configJson: string): string => {
  try {
    const parsed = JSON.parse(configJson)
    return JSON.stringify(parsed, null, 2)
  } catch (error) {
    return configJson
  }
}

const copyConfig = async () => {
  try {
    const formattedConfig = formatJsonConfig(props.data.configJson!)
    await navigator.clipboard.writeText(formattedConfig)
    ElMessage.success('配置已复制到剪贴板')
  } catch (error) {
    ElMessage.error('复制失败，请手动复制')
  }
}

const refreshStatistics = async () => {
  statisticsLoading.value = true
  try {
    // 这里调用获取统计信息的API
    // const response = await agentApi.getModelConfigStatistics(props.data.id)
    // statistics.value = response.data
    
    // 模拟数据
    await new Promise(resolve => setTimeout(resolve, 1000))
    statistics.value = {
      totalCalls: Math.floor(Math.random() * 10000) + 1000,
      successCalls: Math.floor(Math.random() * 9000) + 900,
      failedCalls: Math.floor(Math.random() * 100) + 10,
      avgResponseTime: Math.floor(Math.random() * 1000) + 200,
      totalTokens: Math.floor(Math.random() * 1000000) + 100000,
      lastUsedAt: new Date(Date.now() - Math.random() * 7 * 24 * 60 * 60 * 1000).toISOString()
    }
  } catch (error: any) {
    ElMessage.error(error.message || '获取统计信息失败')
  } finally {
    statisticsLoading.value = false
  }
}

// =============== 生命周期 ===============
onMounted(() => {
  refreshStatistics()
})
</script>

<style lang="scss" scoped>
.model-config-detail {
  .detail-section {
    margin-bottom: 24px;
    
    &:last-child {
      margin-bottom: 0;
    }

    .section-title {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 8px;
      margin-bottom: 16px;
      padding-bottom: 8px;
      border-bottom: 1px solid var(--el-border-color-lighter);
      font-size: 16px;
      font-weight: 600;
      color: var(--el-text-color-primary);

      .el-icon {
        color: var(--el-color-primary);
      }

      .el-button {
        margin-left: auto;
      }
    }
  }

  .info-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 16px;

    .info-item {
      display: flex;
      flex-direction: column;
      gap: 4px;

      label {
        font-size: 13px;
        font-weight: 500;
        color: var(--el-text-color-secondary);
      }

      span {
        font-size: 14px;
        color: var(--el-text-color-primary);
        word-break: break-all;
      }
    }
  }

  .config-display {
    .config-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 12px;
      
      span {
        font-weight: 500;
        color: var(--el-text-color-primary);
      }
    }

    .config-content {
      background: var(--el-fill-color-lighter);
      border: 1px solid var(--el-border-color-light);
      border-radius: 6px;
      padding: 16px;
      overflow-x: auto;

      pre {
        margin: 0;
        font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
        font-size: 13px;
        line-height: 1.5;
        color: var(--el-text-color-primary);

        code {
          background: none;
          padding: 0;
          font-size: inherit;
          color: inherit;
        }
      }
    }
  }

  .switches-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 16px;

    .switch-item {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 12px;
      background: var(--el-fill-color-lighter);
      border-radius: 6px;

      label {
        font-weight: 500;
        color: var(--el-text-color-primary);
      }
    }
  }

  .statistics-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    gap: 16px;

    .stat-card {
      text-align: center;
      padding: 16px;
      background: var(--el-fill-color-lighter);
      border-radius: 8px;
      border: 1px solid var(--el-border-color-light);

      .stat-number {
        font-size: 20px;
        font-weight: 600;
        color: var(--el-color-primary);
        margin-bottom: 4px;
      }

      .stat-label {
        font-size: 12px;
        color: var(--el-text-color-secondary);
      }
    }
  }

  .remarks-content {
    padding: 16px;
    background: var(--el-fill-color-lighter);
    border-radius: 6px;
    line-height: 1.6;
    color: var(--el-text-color-primary);
    white-space: pre-wrap;
    word-break: break-word;
  }

  .detail-actions {
    display: flex;
    justify-content: flex-end;
    gap: 12px;
    margin-top: 32px;
    padding-top: 20px;
    border-top: 1px solid var(--el-border-color-lighter);
  }
}
</style>