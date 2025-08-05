<template>
  <div class="platform-config-form">
    <el-form
      ref="formRef"
      :model="formData"
      :rules="formRules"
      label-width="120px"
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
            <el-form-item label="平台名称" prop="platformName">
              <el-input
                v-model="formData.platformName"
                placeholder="请输入平台名称"
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
                  v-for="(label, value) in platformTypeOptions"
                  :key="value"
                  :label="label"
                  :value="value"
                />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="平台描述" prop="description">
          <el-input
            v-model="formData.description"
            type="textarea"
            :rows="3"
            placeholder="请输入平台描述"
            maxlength="500"
            show-word-limit
          />
        </el-form-item>
      </div>

      <!-- 连接配置 -->
      <div class="form-section">
        <div class="section-title">
          <el-icon><Connection /></el-icon>
          <span>连接配置</span>
        </div>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="API端点" prop="endpoint">
              <el-input
                v-model="formData.endpoint"
                placeholder="请输入API端点URL"
              />
            </el-form-item>
          </el-col>
          
          <el-col :span="12">
            <el-form-item label="API版本" prop="apiVersion">
              <el-input
                v-model="formData.apiVersion"
                placeholder="请输入API版本（如：v1）"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="超时时间(秒)" prop="timeoutSeconds">
              <el-input-number
                v-model="formData.timeoutSeconds"
                :min="1"
                :max="300"
                :step="1"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
          
          <el-col :span="12">
            <el-form-item label="重试次数" prop="retryCount">
              <el-input-number
                v-model="formData.retryCount"
                :min="0"
                :max="10"
                :step="1"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
        </el-row>
      </div>

      <!-- 认证配置 -->
      <div class="form-section">
        <div class="section-title">
          <el-icon><Key /></el-icon>
          <span>认证配置</span>
        </div>

        <!-- 认证类型选择 -->
        <el-form-item label="认证方式" prop="authType">
          <el-radio-group v-model="formData.authType" @change="handleAuthTypeChange">
            <el-radio label="API_KEY">API Key</el-radio>
            <el-radio label="BEARER_TOKEN">Bearer Token</el-radio>
            <el-radio label="OAUTH2">OAuth 2.0</el-radio>
            <el-radio label="CUSTOM">自定义认证</el-radio>
          </el-radio-group>
        </el-form-item>

        <!-- API Key 认证 -->
        <template v-if="formData.authType === 'API_KEY'">
          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="API Key" prop="apiKey">
                <el-input
                  v-model="formData.apiKey"
                  type="password"
                  placeholder="请输入API Key"
                  show-password
                />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="Key参数名" prop="apiKeyName">
                <el-input
                  v-model="formData.apiKeyName"
                  placeholder="请输入Key参数名（如：Authorization）"
                />
              </el-form-item>
            </el-col>
          </el-row>
        </template>

        <!-- Bearer Token 认证 -->
        <template v-if="formData.authType === 'BEARER_TOKEN'">
          <el-form-item label="Access Token" prop="accessToken">
            <el-input
              v-model="formData.accessToken"
              type="password"
              placeholder="请输入Access Token"
              show-password
            />
          </el-form-item>
        </template>

        <!-- OAuth 2.0 认证 -->
        <template v-if="formData.authType === 'OAUTH2'">
          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="Client ID" prop="clientId">
                <el-input
                  v-model="formData.clientId"
                  placeholder="请输入Client ID"
                />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="Client Secret" prop="clientSecret">
                <el-input
                  v-model="formData.clientSecret"
                  type="password"
                  placeholder="请输入Client Secret"
                  show-password
                />
              </el-form-item>
            </el-col>
          </el-row>
          
          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="授权URL" prop="authUrl">
                <el-input
                  v-model="formData.authUrl"
                  placeholder="请输入授权URL"
                />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="Token URL" prop="tokenUrl">
                <el-input
                  v-model="formData.tokenUrl"
                  placeholder="请输入Token URL"
                />
              </el-form-item>
            </el-col>
          </el-row>

          <el-form-item label="授权范围" prop="scopes">
            <el-input
              v-model="formData.scopes"
              placeholder="请输入授权范围，多个用逗号分隔"
            />
          </el-form-item>
        </template>

        <!-- 自定义认证 -->
        <template v-if="formData.authType === 'CUSTOM'">
          <el-form-item label="自定义Headers">
            <div class="custom-headers">
              <div 
                v-for="(header, index) in customHeaders" 
                :key="index"
                class="header-item"
              >
                <el-input
                  v-model="header.key"
                  placeholder="Header名称"
                  style="width: 200px"
                />
                <el-input
                  v-model="header.value"
                  placeholder="Header值"
                  style="width: 300px"
                  type="password"
                  show-password
                />
                <el-button
                  type="danger"
                  size="small"
                  @click="removeCustomHeader(index)"
                >
                  删除
                </el-button>
              </div>
              <el-button
                type="primary"
                size="small"
                @click="addCustomHeader"
              >
                添加Header
              </el-button>
            </div>
          </el-form-item>
        </template>
      </div>

      <!-- 平台特定配置 -->
      <div class="form-section">
        <div class="section-title">
          <el-icon><Setting /></el-icon>
          <span>平台特定配置</span>
        </div>

        <el-form-item label="配置参数">
          <div class="config-params">
            <div 
              v-for="(param, index) in configParams" 
              :key="index"
              class="param-item"
            >
              <el-input
                v-model="param.key"
                placeholder="参数名称"
                style="width: 200px"
              />
              <el-input
                v-model="param.value"
                placeholder="参数值"
                style="width: 300px"
              />
              <el-button
                type="danger"
                size="small"
                @click="removeConfigParam(index)"
              >
                删除
              </el-button>
            </div>
            <el-button
              type="primary"
              size="small"
              @click="addConfigParam"
            >
              添加参数
            </el-button>
          </div>
        </el-form-item>
      </div>

      <!-- 其他配置 -->
      <div class="form-section">
        <div class="section-title">
          <el-icon><Tools /></el-icon>
          <span>其他配置</span>
        </div>

        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="优先级" prop="priority">
              <el-select
                v-model="formData.priority"
                placeholder="请选择优先级"
                style="width: 100%"
              >
                <el-option label="最高" :value="1" />
                <el-option label="高" :value="2" />
                <el-option label="中等" :value="3" />
                <el-option label="低" :value="4" />
                <el-option label="最低" :value="5" />
              </el-select>
            </el-form-item>
          </el-col>
          
          <el-col :span="8">
            <el-form-item label="启用状态" prop="enabled">
              <el-switch
                v-model="formData.enabled"
                active-text="启用"
                inactive-text="禁用"
              />
            </el-form-item>
          </el-col>
          
          <el-col :span="8">
            <el-form-item label="启用日志" prop="enableLogging">
              <el-switch
                v-model="formData.enableLogging"
                active-text="启用"
                inactive-text="禁用"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="备注" prop="remarks">
          <el-input
            v-model="formData.remarks"
            type="textarea"
            :rows="3"
            placeholder="请输入备注信息"
            maxlength="1000"
            show-word-limit
          />
        </el-form-item>
      </div>
    </el-form>

    <!-- 操作按钮 -->
    <div class="form-actions">
      <el-button @click="handleCancel">取消</el-button>
      <el-button 
        type="primary" 
        @click="handleTestConnection"
        :loading="testing"
      >
        测试连接
      </el-button>
      <el-button 
        type="primary" 
        @click="handleSubmit"
        :loading="submitting"
      >
        {{ mode === 'create' ? '创建' : '更新' }}
      </el-button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, watch, onMounted } from 'vue'
import { ElMessage, type FormInstance } from 'element-plus'
import { 
  InfoFilled, Connection, Key, Setting, Tools 
} from '@element-plus/icons-vue'
import { agentApi } from '@/api/agent'
import type { 
  PlatformConfigDTO, 
  CreatePlatformConfigRequest,
  PlatformType 
} from '@/types'

// ==================== Props & Emits ====================

interface Props {
  mode: 'create' | 'edit'
  data?: Partial<PlatformConfigDTO>
}

interface Emits {
  (event: 'submit', data: PlatformConfigDTO): void
  (event: 'cancel'): void
}

const props = withDefaults(defineProps<Props>(), {
  mode: 'create'
})

const emit = defineEmits<Emits>()

// ==================== 数据定义 ====================

const formRef = ref<FormInstance>()
const submitting = ref(false)
const testing = ref(false)

// 表单数据
const formData = reactive<CreatePlatformConfigRequest & { id?: string }>({
  platformName: '',
  platformType: 'COZE',
  description: '',
  endpoint: '',
  apiVersion: 'v1',
  authType: 'API_KEY',
  apiKey: '',
  apiKeyName: 'Authorization',
  accessToken: '',
  clientId: '',
  clientSecret: '',
  authUrl: '',
  tokenUrl: '',
  scopes: '',
  customHeaders: '{}',
  configParams: '{}',
  timeoutSeconds: 30,
  retryCount: 3,
  priority: 3,
  enabled: true,
  enableLogging: true,
  remarks: ''
})

// 自定义Headers
const customHeaders = ref<Array<{ key: string; value: string }>>([])

// 配置参数
const configParams = ref<Array<{ key: string; value: string }>>([])

// 平台类型选项
const platformTypeOptions = computed(() => ({
  'COZE': 'Coze',
  'DIFY': 'Dify', 
  'ALIBABA_DASHSCOPE': '阿里百炼',
  'OPENAI': 'OpenAI',
  'CLAUDE': 'Claude',
  'WENXIN_YIYAN': '文心一言',
  'CUSTOM': '自定义平台'
}))

// 表单验证规则
const formRules = computed(() => ({
  platformName: [
    { required: true, message: '请输入平台名称', trigger: 'blur' },
    { min: 2, max: 100, message: '平台名称长度在2-100个字符', trigger: 'blur' }
  ],
  platformType: [
    { required: true, message: '请选择平台类型', trigger: 'change' }
  ],
  endpoint: [
    { required: true, message: '请输入API端点', trigger: 'blur' },
    { 
      pattern: /^https?:\/\/.+/, 
      message: '请输入有效的URL地址', 
      trigger: 'blur' 
    }
  ],
  apiKey: formData.authType === 'API_KEY' 
    ? [{ required: true, message: '请输入API Key', trigger: 'blur' }]
    : [],
  accessToken: formData.authType === 'BEARER_TOKEN'
    ? [{ required: true, message: '请输入Access Token', trigger: 'blur' }]
    : [],
  clientId: formData.authType === 'OAUTH2'
    ? [{ required: true, message: '请输入Client ID', trigger: 'blur' }]
    : [],
  clientSecret: formData.authType === 'OAUTH2'
    ? [{ required: true, message: '请输入Client Secret', trigger: 'blur' }]
    : [],
  timeoutSeconds: [
    { required: true, message: '请输入超时时间', trigger: 'blur' },
    { type: 'number', min: 1, max: 300, message: '超时时间范围1-300秒', trigger: 'blur' }
  ],
  retryCount: [
    { required: true, message: '请输入重试次数', trigger: 'blur' },
    { type: 'number', min: 0, max: 10, message: '重试次数范围0-10次', trigger: 'blur' }
  ]
}))

// ==================== 方法定义 ====================

// 平台类型变化
const handlePlatformTypeChange = (type: PlatformType) => {
  // 根据平台类型设置默认配置
  const presets: Record<PlatformType, Partial<CreatePlatformConfigRequest>> = {
    'COZE': {
      endpoint: 'https://www.coze.cn/api/v1',
      authType: 'BEARER_TOKEN',
      apiKeyName: 'Authorization'
    },
    'DIFY': {
      endpoint: 'https://api.dify.ai/v1',
      authType: 'BEARER_TOKEN',
      apiKeyName: 'Authorization'
    },
    'ALIBABA_DASHSCOPE': {
      endpoint: 'https://dashscope.aliyuncs.com/api/v1',
      authType: 'API_KEY',
      apiKeyName: 'X-DashScope-SSE'
    },
    'OPENAI': {
      endpoint: 'https://api.openai.com/v1',
      authType: 'BEARER_TOKEN',
      apiKeyName: 'Authorization'
    },
    'CLAUDE': {
      endpoint: 'https://api.anthropic.com/v1',
      authType: 'API_KEY',
      apiKeyName: 'x-api-key'
    },
    'WENXIN_YIYAN': {
      endpoint: 'https://aip.baidubce.com/rpc/2.0',
      authType: 'OAUTH2'
    },
    'CUSTOM': {
      endpoint: '',
      authType: 'API_KEY'
    }
  }

  const preset = presets[type]
  if (preset) {
    Object.assign(formData, preset)
  }
}

// 认证方式变化
const handleAuthTypeChange = () => {
  // 清空认证相关字段
  formData.apiKey = ''
  formData.accessToken = ''
  formData.clientId = ''
  formData.clientSecret = ''
  formData.authUrl = ''
  formData.tokenUrl = ''
  formData.scopes = ''
}

// 添加自定义Header
const addCustomHeader = () => {
  customHeaders.value.push({ key: '', value: '' })
}

// 删除自定义Header
const removeCustomHeader = (index: number) => {
  customHeaders.value.splice(index, 1)
}

// 添加配置参数
const addConfigParam = () => {
  configParams.value.push({ key: '', value: '' })
}

// 删除配置参数
const removeConfigParam = (index: number) => {
  configParams.value.splice(index, 1)
}

// 测试连接
const handleTestConnection = async () => {
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid) return

  testing.value = true
  try {
    // 构建测试数据
    const testData = {
      ...formData,
      customHeaders: JSON.stringify(
        customHeaders.value.reduce((acc, header) => {
          if (header.key && header.value) {
            acc[header.key] = header.value
          }
          return acc
        }, {} as Record<string, string>)
      ),
      configParams: JSON.stringify(
        configParams.value.reduce((acc, param) => {
          if (param.key && param.value) {
            acc[param.key] = param.value
          }
          return acc
        }, {} as Record<string, string>)
      )
    }

    const response = await agentApi.testPlatformConnectionDirect(testData)
    if (response.success) {
      ElMessage.success('连接测试成功')
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

// 提交表单
const handleSubmit = async () => {
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid) return

  submitting.value = true
  try {
    // 构建提交数据
    const submitData = {
      ...formData,
      customHeaders: JSON.stringify(
        customHeaders.value.reduce((acc, header) => {
          if (header.key && header.value) {
            acc[header.key] = header.value
          }
          return acc
        }, {} as Record<string, string>)
      ),
      configParams: JSON.stringify(
        configParams.value.reduce((acc, param) => {
          if (param.key && param.value) {
            acc[param.key] = param.value
          }
          return acc
        }, {} as Record<string, string>)
      )
    }

    emit('submit', submitData as PlatformConfigDTO)
  } catch (error) {
    console.error('表单提交失败:', error)
    ElMessage.error('表单提交失败')
  } finally {
    submitting.value = false
  }
}

// 取消
const handleCancel = () => {
  emit('cancel')
}

// 初始化表单数据
const initFormData = () => {
  if (props.data && props.mode === 'edit') {
    Object.assign(formData, props.data)
    
    // 解析自定义Headers
    try {
      const headers = JSON.parse(props.data.customHeaders || '{}')
      customHeaders.value = Object.entries(headers).map(([key, value]) => ({
        key,
        value: value as string
      }))
    } catch (error) {
      console.warn('解析customHeaders失败:', error)
    }
    
    // 解析配置参数
    try {
      const params = JSON.parse(props.data.configParams || '{}')
      configParams.value = Object.entries(params).map(([key, value]) => ({
        key,
        value: value as string
      }))
    } catch (error) {
      console.warn('解析configParams失败:', error)
    }
  }
}

// ==================== 监听器 ====================

watch(() => props.data, initFormData, { immediate: true })

// ==================== 生命周期 ====================

onMounted(() => {
  initFormData()
})
</script>

<style lang="scss" scoped>
.platform-config-form {
  .form-section {
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
  
  .custom-headers,
  .config-params {
    .header-item,
    .param-item {
      display: flex;
      align-items: center;
      gap: 12px;
      margin-bottom: 12px;
    }
  }
  
  .form-actions {
    display: flex;
    justify-content: flex-end;
    gap: 12px;
    padding-top: 24px;
    border-top: 1px solid var(--el-border-color-light);
  }
}
</style>