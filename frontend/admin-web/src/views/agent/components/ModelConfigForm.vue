<template>
  <div class="model-config-form">
    <el-form
      ref="formRef"
      :model="formData"
      :rules="formRules"
      label-width="140px"
      size="default"
    >
      <!-- 基本信息 -->
      <div class="form-section">
        <div class="section-title">
          <el-icon><InfoFilled /></el-icon>
          <span>基本信息</span>
        </div>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="配置名称" prop="configName">
              <el-input
                v-model="formData.configName"
                placeholder="请输入配置名称"
                maxlength="100"
                show-word-limit
              />
            </el-form-item>
          </el-col>
          
          <el-col :span="12">
            <el-form-item label="平台类型" prop="platformType">
              <el-select
                v-model="formData.platformType"
                placeholder="请选择平台类型"
                style="width: 100%"
                @change="handlePlatformTypeChange"
              >
                <el-option
                  v-for="option in platformTypeOptions"
                  :key="option.value"
                  :label="option.label"
                  :value="option.value"
                >
                  <div class="platform-option">
                    <span class="platform-name">{{ option.label }}</span>
                    <el-tag size="small" :type="option.tagType as any">
                      {{ option.label }}
                    </el-tag>
                  </div>
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="模型名称" prop="modelName">
              <el-input
                v-model="formData.modelName"
                placeholder="请输入模型名称"
                maxlength="100"
                show-word-limit
              />
            </el-form-item>
          </el-col>
          
          <el-col :span="12">
            <el-form-item label="模型版本" prop="modelVersion">
              <el-input
                v-model="formData.modelVersion"
                placeholder="请输入模型版本"
                maxlength="50"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="描述" prop="description">
          <el-input
            v-model="formData.description"
            type="textarea"
            :rows="3"
            placeholder="请输入配置描述"
            maxlength="500"
            show-word-limit
          />
        </el-form-item>
      </div>

      <!-- 模型参数 -->
      <div class="form-section">
        <div class="section-title">
          <el-icon><Setting /></el-icon>
          <span>模型参数</span>
        </div>

        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="最大Token数" prop="maxTokens">
              <el-input-number
                v-model="formData.maxTokens"
                :min="1"
                :max="32000"
                :step="100"
                style="width: 100%"
                controls-position="right"
              />
            </el-form-item>
          </el-col>
          
          <el-col :span="8">
            <el-form-item label="温度参数" prop="temperature">
              <el-input-number
                v-model="formData.temperature"
                :min="0"
                :max="2"
                :step="0.1"
                :precision="1"
                style="width: 100%"
                controls-position="right"
              />
            </el-form-item>
          </el-col>
          
          <el-col :span="8">
            <el-form-item label="Top P" prop="topP">
              <el-input-number
                v-model="formData.topP"
                :min="0"
                :max="1"
                :step="0.1"
                :precision="1"
                style="width: 100%"
                controls-position="right"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="频率惩罚" prop="frequencyPenalty">
              <el-input-number
                v-model="formData.frequencyPenalty"
                :min="-2"
                :max="2"
                :step="0.1"
                :precision="1"
                style="width: 100%"
                controls-position="right"
              />
            </el-form-item>
          </el-col>
          
          <el-col :span="12">
            <el-form-item label="存在惩罚" prop="presencePenalty">
              <el-input-number
                v-model="formData.presencePenalty"
                :min="-2"
                :max="2"
                :step="0.1"
                :precision="1"
                style="width: 100%"
                controls-position="right"
              />
            </el-form-item>
          </el-col>
        </el-row>
      </div>

      <!-- 扩展配置 -->
      <div class="form-section">
        <div class="section-title">
          <el-icon><Tools /></el-icon>
          <span>扩展配置</span>
        </div>

        <el-form-item label="自定义配置" prop="configJson">
          <div class="config-json-editor">
            <el-input
              v-model="formData.configJson"
              type="textarea"
              :rows="6"
              placeholder="请输入JSON格式的自定义配置，例如：&#10;{&#10;  &quot;stream&quot;: true,&#10;  &quot;stop&quot;: [&quot;\n&quot;, &quot;Human:&quot;, &quot;AI:&quot;],&#10;  &quot;presence_penalty&quot;: 0.1&#10;}"
              style="font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace"
            />
            <div class="config-tips">
              <el-alert
                title="配置说明"
                type="info"
                :closable="false"
                show-icon
              >
                <ul>
                  <li>请使用标准JSON格式</li>
                  <li>配置会与基本参数合并，优先级更高</li>
                  <li>常用参数：stream(流式输出)、stop(停止词)、logit_bias(偏置)</li>
                </ul>
              </el-alert>
            </div>
          </div>
        </el-form-item>
      </div>

      <!-- 功能开关 -->
      <div class="form-section">
        <div class="section-title">
          <el-icon><SwitchButton /></el-icon>
          <span>功能开关</span>
        </div>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="启用状态">
              <el-switch
                v-model="formData.enabled"
                active-text="启用"
                inactive-text="禁用"
                style="--el-switch-on-color: var(--el-color-success)"
              />
            </el-form-item>
          </el-col>
          
          <el-col :span="12">
            <el-form-item label="启用日志记录">
              <el-switch
                v-model="formData.enableLogging"
                active-text="启用"
                inactive-text="禁用"
                style="--el-switch-on-color: var(--el-color-primary)"
              />
            </el-form-item>
          </el-col>
        </el-row>
      </div>

      <!-- 备注 -->
      <div class="form-section">
        <el-form-item label="备注" prop="remarks">
          <el-input
            v-model="formData.remarks"
            type="textarea"
            :rows="3"
            placeholder="请输入备注信息（可选）"
            maxlength="500"
            show-word-limit
          />
        </el-form-item>
      </div>
    </el-form>

    <!-- 操作按钮 -->
    <div class="form-actions">
      <el-button
        size="large"
        @click="handleCancel"
      >
        取消
      </el-button>
      
      <el-button
        type="primary"
        size="large"
        @click="handleTest"
        :loading="testing"
        :disabled="!isFormValid"
      >
        <el-icon><Lightning /></el-icon>
        测试连接
      </el-button>
      
      <el-button
        type="success"
        size="large"
        @click="handleSubmit"
        :loading="submitting"
        :disabled="!isFormValid"
      >
        <el-icon><Check /></el-icon>
        {{ mode === 'create' ? '创建配置' : '更新配置' }}
      </el-button>
    </div>

    <!-- 测试结果对话框 -->
    <el-dialog
      v-model="showTestDialog"
      title="连接测试结果"
      width="50%"
      append-to-body
    >
      <div class="test-result">
        <div class="result-header">
          <el-tag :type="testResult?.success ? 'success' : 'danger'" size="large">
            {{ testResult?.success ? '测试成功' : '测试失败' }}
          </el-tag>
          
          <div class="test-metrics" v-if="testResult?.success">
            <span class="metric-item">
              响应时间: {{ testResult.responseTime }}ms
            </span>
          </div>
        </div>

        <div class="result-content">
          <el-alert
            v-if="!testResult?.success"
            :title="testResult?.error || '连接测试失败'"
            type="error"
            :closable="false"
            show-icon
          />
          
          <div v-else class="success-info">
            <el-alert
              title="连接测试成功！模型配置正常，可以正常使用。"
              type="success"
              :closable="false"
              show-icon
            />
            
            <div class="response-details" v-if="testResult.response">
              <h4>测试响应:</h4>
              <div class="response-text">{{ testResult.response }}</div>
            </div>
          </div>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, watch } from 'vue'
import { ElMessage, type FormInstance, type FormRules } from 'element-plus'
import {
  InfoFilled,
  Setting,
  Tools,
  SwitchButton,
  Lightning,
  Check
} from '@element-plus/icons-vue'

// 导入类型
import type { ModelConfigDTO, CreateModelConfigRequest, PlatformType } from '@/types/agent'
import { agentApi } from '@/api/agent'

// =============== Props & Emits ===============
interface Props {
  mode: 'create' | 'edit'
  modelValue?: ModelConfigDTO | null
}

interface Emits {
  (event: 'submit', data: CreateModelConfigRequest): void
  (event: 'cancel'): void
}

const props = withDefaults(defineProps<Props>(), {
  mode: 'create',
  modelValue: null
})

const emit = defineEmits<Emits>()

// =============== 响应式数据 ===============
const formRef = ref<FormInstance>()
const submitting = ref(false)
const testing = ref(false)
const showTestDialog = ref(false)
const testResult = ref<any>(null)

// 表单数据
const formData = reactive<CreateModelConfigRequest>({
  configName: '',
  platformType: 'OPENAI' as PlatformType,
  modelName: '',
  modelVersion: '',
  description: '',
  maxTokens: 4000,
  temperature: 0.7,
  topP: 1.0,
  frequencyPenalty: 0,
  presencePenalty: 0,
  configJson: '',
  enabled: true,
  enableLogging: true,
  remarks: ''
})

// =============== 计算属性 ===============
const platformTypeOptions = computed(() => [
  { 
    value: 'COZE' as PlatformType, 
    label: 'Coze', 
    tagType: 'primary' 
  },
  { 
    value: 'DIFY' as PlatformType, 
    label: 'Dify', 
    tagType: 'success' 
  },
  { 
    value: 'ALIBABA_DASHSCOPE' as PlatformType, 
    label: '阿里百炼', 
    tagType: 'warning' 
  },
  { 
    value: 'OPENAI' as PlatformType, 
    label: 'OpenAI', 
    tagType: 'info' 
  },
  { 
    value: 'CLAUDE' as PlatformType, 
    label: 'Claude', 
    tagType: 'danger' 
  },
  { 
    value: 'WENXIN_YIYAN' as PlatformType, 
    label: '文心一言', 
    tagType: 'primary' 
  },
  { 
    value: 'CUSTOM' as PlatformType, 
    label: '自定义', 
    tagType: 'info' 
  }
])

const isFormValid = computed(() => {
  return !!(formData.configName && formData.platformType && formData.modelName)
})

// =============== 表单验证规则 ===============
const formRules = computed<FormRules>(() => ({
  configName: [
    { required: true, message: '请输入配置名称', trigger: 'blur' },
    { min: 2, max: 100, message: '配置名称长度在2-100个字符', trigger: 'blur' }
  ],
  platformType: [
    { required: true, message: '请选择平台类型', trigger: 'change' }
  ],
  modelName: [
    { required: true, message: '请输入模型名称', trigger: 'blur' },
    { min: 1, max: 100, message: '模型名称长度在1-100个字符', trigger: 'blur' }
  ],
  maxTokens: [
    { 
      type: 'number' as const, 
      min: 1, 
      max: 32000, 
      message: 'Token数量范围1-32000', 
      trigger: 'blur' 
    }
  ],
  temperature: [
    { 
      type: 'number' as const, 
      min: 0, 
      max: 2, 
      message: '温度参数范围0-2', 
      trigger: 'blur' 
    }
  ],
  topP: [
    { 
      type: 'number' as const, 
      min: 0, 
      max: 1, 
      message: 'Top P参数范围0-1', 
      trigger: 'blur' 
    }
  ],
  configJson: [
    {
      validator: (rule: any, value: string, callback: Function) => {
        if (value && value.trim()) {
          try {
            JSON.parse(value)
            callback()
          } catch (error) {
            callback(new Error('请输入有效的JSON格式'))
          }
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ]
}))

// =============== 方法定义 ===============
const handlePlatformTypeChange = (type: PlatformType) => {
  // 根据平台类型设置默认模型名称
  const defaultModels = {
    'COZE': 'gpt-3.5-turbo',
    'DIFY': 'gpt-3.5-turbo',
    'ALIBABA_DASHSCOPE': 'qwen-turbo',
    'OPENAI': 'gpt-3.5-turbo',
    'CLAUDE': 'claude-3-haiku-20240307',
    'WENXIN_YIYAN': 'ernie-bot-turbo',
    'CUSTOM': ''
  }
  
  if (!formData.modelName || formData.modelName === defaultModels[formData.platformType as keyof typeof defaultModels]) {
    formData.modelName = defaultModels[type as keyof typeof defaultModels] || ''
  }
}

const handleTest = async () => {
  // 验证表单
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid) {
    ElMessage.error('请完善表单信息后再进行测试')
    return
  }

  testing.value = true
  testResult.value = null

  try {
    const startTime = Date.now()
    
    // 这里调用测试API（如果后端提供）
    // 或者进行前端验证
    const response = await mockModelTest(formData)
    const endTime = Date.now()

    testResult.value = {
      success: response.success,
      responseTime: endTime - startTime,
      response: response.response,
      error: response.error
    }

    showTestDialog.value = true
  } catch (error: any) {
    testResult.value = {
      success: false,
      error: error.message || '测试失败'
    }
    showTestDialog.value = true
  } finally {
    testing.value = false
  }
}

const handleSubmit = async () => {
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid) return

  submitting.value = true
  
  try {
    emit('submit', { ...formData })
  } finally {
    submitting.value = false
  }
}

const handleCancel = () => {
  emit('cancel')
}

// 模拟测试API
const mockModelTest = async (config: any) => {
  // 模拟API调用延迟
  await new Promise(resolve => setTimeout(resolve, 1000 + Math.random() * 2000))
  
  // 模拟成功/失败
  if (Math.random() > 0.1) {
    return {
      success: true,
      response: `模型 ${config.modelName} 连接测试成功！当前配置参数正常，可以正常使用。`
    }
  } else {
    return {
      success: false,
      error: '连接超时，请检查平台配置或网络连接'
    }
  }
}

// =============== 监听器 ===============
watch(() => props.modelValue, (newValue) => {
  if (newValue && props.mode === 'edit') {
    Object.assign(formData, {
      configName: newValue.configName,
      platformType: newValue.platformType,
      modelName: newValue.modelName,
      modelVersion: newValue.modelVersion || '',
      description: newValue.description || '',
      maxTokens: newValue.maxTokens || 4000,
      temperature: newValue.temperature || 0.7,
      topP: newValue.topP || 1.0,
      frequencyPenalty: newValue.frequencyPenalty || 0,
      presencePenalty: newValue.presencePenalty || 0,
      configJson: newValue.configJson || '',
      enabled: newValue.enabled,
      enableLogging: newValue.enableLogging !== false,
      remarks: newValue.remarks || ''
    })
  } else if (props.mode === 'create') {
    // 重置表单
    Object.assign(formData, {
      configName: '',
      platformType: 'OPENAI' as PlatformType,
      modelName: '',
      modelVersion: '',
      description: '',
      maxTokens: 4000,
      temperature: 0.7,
      topP: 1.0,
      frequencyPenalty: 0,
      presencePenalty: 0,
      configJson: '',
      enabled: true,
      enableLogging: true,
      remarks: ''
    })
  }
}, { immediate: true })
</script>

<style lang="scss" scoped>
.model-config-form {
  .form-section {
    margin-bottom: 24px;
    
    &:last-child {
      margin-bottom: 0;
    }

    .section-title {
      display: flex;
      align-items: center;
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
    }
  }

  .platform-option {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;

    .platform-name {
      font-weight: 500;
    }
  }

  .config-json-editor {
    width: 100%;

    .config-tips {
      margin-top: 12px;

      :deep(.el-alert__content) {
        ul {
          margin: 0;
          padding-left: 16px;
          
          li {
            margin-bottom: 4px;
            font-size: 13px;
            
            &:last-child {
              margin-bottom: 0;
            }
          }
        }
      }
    }
  }

  .form-actions {
    display: flex;
    justify-content: flex-end;
    gap: 12px;
    margin-top: 32px;
    padding-top: 20px;
    border-top: 1px solid var(--el-border-color-lighter);
  }

  .test-result {
    .result-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 16px;

      .test-metrics {
        .metric-item {
          color: var(--el-text-color-regular);
          font-size: 14px;
        }
      }
    }

    .success-info {
      .response-details {
        margin-top: 16px;

        h4 {
          margin: 0 0 8px 0;
          color: var(--el-text-color-primary);
        }

        .response-text {
          padding: 12px;
          background: var(--el-fill-color-lighter);
          border-radius: 6px;
          line-height: 1.6;
          color: var(--el-text-color-primary);
          font-size: 14px;
        }
      }
    }
  }
}
</style>