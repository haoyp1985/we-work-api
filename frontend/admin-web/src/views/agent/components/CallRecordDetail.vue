<template>
  <div class="call-record-detail">
    <!-- 基本信息 -->
    <div class="detail-section">
      <h3>基本信息</h3>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="记录ID">
          {{ record.id }}
        </el-descriptions-item>
        <el-descriptions-item label="智能体">
          {{ record.agentName }}
        </el-descriptions-item>
        <el-descriptions-item label="平台类型">
          <el-tag :type="getPlatformTagType(record.platformType)">
            {{ getPlatformName(record.platformType) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="调用类型">
          {{ record.callType }}
        </el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="getStatusTagType(record.status)">
            {{ getStatusText(record.status) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="调用时间">
          {{ formatDate(record.createdAt) }}
        </el-descriptions-item>
      </el-descriptions>
    </div>

    <!-- 性能指标 -->
    <div class="detail-section">
      <h3>性能指标</h3>
      <el-row :gutter="20">
        <el-col :span="6">
          <div class="metric-card">
            <div class="metric-value">{{ record.responseTime }}ms</div>
            <div class="metric-label">响应时间</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="metric-card">
            <div class="metric-value">{{ record.inputTokens }}</div>
            <div class="metric-label">输入Token</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="metric-card">
            <div class="metric-value">{{ record.outputTokens }}</div>
            <div class="metric-label">输出Token</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="metric-card">
            <div class="metric-value">¥{{ record.cost?.toFixed(4) }}</div>
            <div class="metric-label">调用成本</div>
          </div>
        </el-col>
      </el-row>
    </div>

    <!-- 请求信息 -->
    <div class="detail-section">
      <h3>请求信息</h3>
      <div class="request-info">
        <div class="info-item">
          <label>API端点:</label>
          <span>{{ record.apiEndpoint }}</span>
        </div>
        <div class="info-item">
          <label>请求方法:</label>
          <span>{{ record.requestMethod }}</span>
        </div>
        <div class="info-item">
          <label>用户ID:</label>
          <span>{{ record.userId }}</span>
        </div>
        <div class="info-item">
          <label>会话ID:</label>
          <span>{{ record.conversationId }}</span>
        </div>
      </div>
    </div>

    <!-- 请求内容 -->
    <div class="detail-section">
      <h3>请求内容</h3>
      <el-tabs>
        <el-tab-pane label="请求参数" name="request">
          <div class="code-block">
            <pre>{{ formatJson(record.requestParams) }}</pre>
          </div>
        </el-tab-pane>
        <el-tab-pane label="请求头" name="headers">
          <div class="code-block">
            <pre>{{ formatJson(record.requestHeaders) }}</pre>
          </div>
        </el-tab-pane>
      </el-tabs>
    </div>

    <!-- 响应内容 -->
    <div class="detail-section">
      <h3>响应内容</h3>
      <el-tabs>
        <el-tab-pane label="响应数据" name="response">
          <div class="code-block">
            <pre>{{ formatJson(record.responseData) }}</pre>
          </div>
        </el-tab-pane>
        <el-tab-pane label="响应头" name="responseHeaders" v-if="record.responseHeaders">
          <div class="code-block">
            <pre>{{ formatJson(record.responseHeaders) }}</pre>
          </div>
        </el-tab-pane>
      </el-tabs>
    </div>

    <!-- 错误信息 -->
    <div class="detail-section" v-if="record.status !== 'success' && record.errorMessage">
      <h3>错误信息</h3>
      <el-alert
        :title="record.errorMessage"
        type="error"
        :description="record.errorDetails"
        show-icon
        :closable="false"
      />
    </div>

    <!-- 模型配置 -->
    <div class="detail-section" v-if="record.modelConfig">
      <h3>模型配置</h3>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="模型名称">
          {{ record.modelConfig.modelName }}
        </el-descriptions-item>
        <el-descriptions-item label="温度">
          {{ record.modelConfig.temperature }}
        </el-descriptions-item>
        <el-descriptions-item label="最大Token">
          {{ record.modelConfig.maxTokens }}
        </el-descriptions-item>
        <el-descriptions-item label="Top P">
          {{ record.modelConfig.topP }}
        </el-descriptions-item>
        <el-descriptions-item label="Top K" v-if="record.modelConfig.topK">
          {{ record.modelConfig.topK }}
        </el-descriptions-item>
        <el-descriptions-item label="频率惩罚" v-if="record.modelConfig.frequencyPenalty">
          {{ record.modelConfig.frequencyPenalty }}
        </el-descriptions-item>
      </el-descriptions>
    </div>

    <!-- 调用链路 -->
    <div class="detail-section" v-if="record.traceInfo">
      <h3>调用链路</h3>
      <el-timeline>
        <el-timeline-item
          v-for="(trace, index) in record.traceInfo"
          :key="index"
          :timestamp="formatTime(trace.timestamp)"
        >
          <div class="trace-item">
            <div class="trace-title">{{ trace.stage }}</div>
            <div class="trace-description">{{ trace.description }}</div>
            <div class="trace-duration" v-if="trace.duration">
              耗时: {{ trace.duration }}ms
            </div>
          </div>
        </el-timeline-item>
      </el-timeline>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { CallRecordDTO } from '@/types/agent'

interface Props {
  record: CallRecordDTO
}

const props = defineProps<Props>()

// 工具函数
const getPlatformName = (platform: string) => {
  const platformMap: Record<string, string> = {
    dify: 'Dify',
    coze: 'Coze',
    openai: 'OpenAI',
    claude: 'Claude',
    gemini: 'Gemini'
  }
  return platformMap[platform] || platform
}

const getPlatformTagType = (platform: string) => {
  const typeMap: Record<string, string> = {
    dify: 'primary',
    coze: 'success',
    openai: 'warning',
    claude: 'info',
    gemini: 'danger'
  }
  return typeMap[platform] || ''
}

const getStatusText = (status: string) => {
  const statusMap: Record<string, string> = {
    success: '成功',
    failed: '失败',
    timeout: '超时',
    error: '错误'
  }
  return statusMap[status] || status
}

const getStatusTagType = (status: string) => {
  const typeMap: Record<string, string> = {
    success: 'success',
    failed: 'danger',
    timeout: 'warning',
    error: 'danger'
  }
  return typeMap[status] || ''
}

const formatDate = (dateStr: string) => {
  return new Date(dateStr).toLocaleString('zh-CN')
}

const formatTime = (timestamp: number) => {
  return new Date(timestamp).toLocaleTimeString('zh-CN')
}

const formatJson = (obj: any) => {
  if (!obj) return ''
  if (typeof obj === 'string') {
    try {
      return JSON.stringify(JSON.parse(obj), null, 2)
    } catch {
      return obj
    }
  }
  return JSON.stringify(obj, null, 2)
}
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.call-record-detail {
  .detail-section {
    margin-bottom: 24px;

    &:last-child {
      margin-bottom: 0;
    }

    h3 {
      margin: 0 0 16px 0;
      font-size: 16px;
      font-weight: 600;
      color: $text-color-primary;
      border-bottom: 1px solid $border-color-lighter;
      padding-bottom: 8px;
    }
  }

  .metric-card {
    text-align: center;
    padding: 16px;
    background: $background-color-base;
    border-radius: 6px;

    .metric-value {
      font-size: 18px;
      font-weight: 600;
      color: $text-color-primary;
      margin-bottom: 4px;
    }

    .metric-label {
      font-size: 12px;
      color: $text-color-secondary;
    }
  }

  .request-info {
    .info-item {
      display: flex;
      align-items: center;
      margin-bottom: 12px;

      &:last-child {
        margin-bottom: 0;
      }

      label {
        width: 100px;
        font-weight: 500;
        color: $text-color-secondary;
        margin-right: 12px;
      }

      span {
        color: $text-color-primary;
        word-break: break-all;
      }
    }
  }

  .code-block {
    background: #f8f9fa;
    border: 1px solid $border-color-light;
    border-radius: 4px;
    padding: 16px;
    max-height: 400px;
    overflow-y: auto;

    pre {
      margin: 0;
      font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
      font-size: 12px;
      line-height: 1.5;
      color: $text-color-primary;
      white-space: pre-wrap;
      word-break: break-all;
    }
  }

  .trace-item {
    .trace-title {
      font-weight: 500;
      color: $text-color-primary;
      margin-bottom: 4px;
    }

    .trace-description {
      font-size: 14px;
      color: $text-color-secondary;
      margin-bottom: 4px;
    }

    .trace-duration {
      font-size: 12px;
      color: $text-color-placeholder;
    }
  }
}
</style>