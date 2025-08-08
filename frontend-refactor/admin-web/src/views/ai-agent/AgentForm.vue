<script setup lang="ts">
import { ref, reactive, computed, onMounted, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { 
  ArrowLeft, 
  Check, 
  Close, 
  Upload, 
  Plus, 
  Delete,
  Warning,
  InfoFilled,
  Setting
} from '@element-plus/icons-vue'
import { useRouter, useRoute } from 'vue-router'
import type { FormInstance, FormRules, UploadProps } from 'element-plus'
import * as agentApi from '@/api/agent'
import { uploadAvatar } from '@/api/upload'
import type { 
  Agent, 
  CreateAgentRequest, 
  UpdateAgentRequest, 
  AgentStatus
} from '@/types/api'
import { AgentType, PlatformType } from '@/types/api'

const router = useRouter()
const route = useRoute()

// 表单引用
const formRef = ref<FormInstance>()

// 是否编辑模式
const isEdit = computed(() => route.name === 'AgentEdit')
const agentId = computed(() => route.params.id as string)

// 当前步骤
const currentStep = ref(0)
const steps = [
  { title: '基本信息', description: '设置智能体的基本信息' },
  { title: '平台配置', description: '选择AI平台和模型' },
  { title: '高级设置', description: '配置智能体行为参数' },
  { title: '预览发布', description: '确认配置并发布' }
]

// 使用导入的类型枚举

// 表单数据
const formData = reactive<CreateAgentRequest & { id?: string }>({
  name: '',
  description: '',
  type: AgentType.CHAT,
  avatar: '',
  tags: [],
  
  // 平台配置
  platformType: PlatformType.OPENAI,
  modelName: '',
  
  // 高级设置
  systemPrompt: '',
  temperature: 0.7,
  maxTokens: 2048,
  topP: 1.0,
  frequencyPenalty: 0.0,
  presencePenalty: 0.0,
  
  // 功能配置
  features: {
    memoryEnabled: true,
    contextWindow: 4000,
    streamResponse: true,
    webSearch: false,
    codeExecution: false,
    imageAnalysis: false
  },
  
  // 安全配置
  security: {
    contentFilter: true,
    rateLimitEnabled: true,
    maxRequestsPerMinute: 60,
    allowedDomains: [],
    blockedKeywords: []
  }
})

// 表单验证规则
const formRules: FormRules = {
  name: [
    { required: true, message: '请输入智能体名称', trigger: 'blur' },
    { min: 2, max: 50, message: '名称长度应在2-50个字符之间', trigger: 'blur' }
  ],
  description: [
    { required: true, message: '请输入智能体描述', trigger: 'blur' },
    { min: 10, max: 500, message: '描述长度应在10-500个字符之间', trigger: 'blur' }
  ],
  type: [
    { required: true, message: '请选择智能体类型', trigger: 'change' }
  ],
  platformType: [
    { required: true, message: '请选择AI平台', trigger: 'change' }
  ],
  modelName: [
    { required: true, message: '请选择模型', trigger: 'change' }
  ],
  systemPrompt: [
    { required: true, message: '请输入系统提示词', trigger: 'blur' },
    { min: 20, max: 2000, message: '提示词长度应在20-2000个字符之间', trigger: 'blur' }
  ]
}

// 选项数据
const typeOptions = [
  { 
    label: '聊天助手', 
    value: AgentType.CHAT, 
    description: '专注于对话交流，适合客服、咨询等场景',
    icon: '💬'
  },
  { 
    label: '任务处理', 
    value: AgentType.TASK, 
    description: '执行特定任务和工作流程，适合自动化场景',
    icon: '⚙️'
  },
  { 
    label: '数据分析', 
    value: AgentType.ANALYSIS, 
    description: '分析数据和生成报告，适合业务分析场景',
    icon: '📊'
  }
]

const platformOptions = [
  { 
    label: 'OpenAI', 
    value: PlatformType.OPENAI, 
    description: 'GPT系列模型，强大的通用能力',
    models: ['gpt-3.5-turbo', 'gpt-4', 'gpt-4-turbo']
  },
  { 
    label: 'Anthropic Claude', 
    value: PlatformType.ANTHROPIC_CLAUDE, 
    description: 'Claude系列模型，安全可靠',
    models: ['claude-3-haiku', 'claude-3-sonnet', 'claude-3-opus']
  },
  { 
    label: '百度文心一言', 
    value: PlatformType.BAIDU_WENXIN, 
    description: '中文优化，本土化服务',
    models: ['ernie-3.5', 'ernie-4.0', 'ernie-bot-turbo']
  },
  { 
    label: 'Coze', 
    value: PlatformType.COZE, 
    description: '字节跳动AI平台',
    models: ['coze-pro', 'coze-standard']
  },
  { 
    label: 'Dify', 
    value: PlatformType.DIFY, 
    description: '开源LLM应用平台',
    models: ['dify-chat', 'dify-completion']
  }
]

// 当前平台的模型选项
const availableModels = computed(() => {
  const platform = platformOptions.find(p => p.value === formData.platformType)
  return platform?.models || []
})

// 标签输入
const newTag = ref('')
const tagInputVisible = ref(false)
const tagInputRef = ref()

// 响应式状态
const loading = ref(false)
const saveLoading = ref(false)

// 头像上传处理
const handleAvatarUpload = async (file: File) => {
  const isJPG = file.type === 'image/jpeg' || file.type === 'image/png'
  const isLt2M = file.size / 1024 / 1024 < 2

  if (!isJPG) {
    ElMessage.error('头像只能是 JPG/PNG 格式!')
    return false
  }
  if (!isLt2M) {
    ElMessage.error('头像大小不能超过 2MB!')
    return false
  }

  try {
    const response = await uploadAvatar(file)
    formData.avatar = response.data.url
    ElMessage.success('头像上传成功')
  } catch (error) {
    console.error('头像上传失败:', error)
    ElMessage.error('头像上传失败')
  }
  
  return false // 阻止自动上传
}

// 监听平台变化，重置模型选择
watch(() => formData.platformType, () => {
  formData.modelName = ''
})

// 步骤导航
const nextStep = async () => {
  if (currentStep.value < steps.length - 1) {
    const valid = await validateCurrentStep()
    if (valid) {
      currentStep.value++
    }
  }
}

const prevStep = () => {
  if (currentStep.value > 0) {
    currentStep.value--
  }
}

// 验证当前步骤
const validateCurrentStep = async (): Promise<boolean> => {
  if (!formRef.value) return false
  
  let fieldsToValidate: string[] = []
  
  switch (currentStep.value) {
    case 0: // 基本信息
      fieldsToValidate = ['name', 'description', 'type']
      break
    case 1: // 平台配置
      fieldsToValidate = ['platformType', 'modelName']
      break
    case 2: // 高级设置
      fieldsToValidate = ['systemPrompt']
      break
  }
  
  try {
    if (fieldsToValidate.length > 0) {
      await formRef.value.validateField(fieldsToValidate)
    }
    return true
  } catch (error) {
    return false
  }
}

// 标签管理
const addTag = () => {
  const tag = newTag.value.trim()
  if (tag && !formData.tags.includes(tag)) {
    formData.tags.push(tag)
    newTag.value = ''
  }
  tagInputVisible.value = false
}

const removeTag = (tag: string) => {
  const index = formData.tags.indexOf(tag)
  if (index > -1) {
    formData.tags.splice(index, 1)
  }
}

const showTagInput = () => {
  tagInputVisible.value = true
  setTimeout(() => {
    tagInputRef.value?.focus()
  }, 100)
}

// 域名管理
const addDomain = () => {
  formData.security.allowedDomains.push('')
}

const removeDomain = (index: number) => {
  formData.security.allowedDomains.splice(index, 1)
}

// 关键词管理
const addKeyword = () => {
  formData.security.blockedKeywords.push('')
}

const removeKeyword = (index: number) => {
  formData.security.blockedKeywords.splice(index, 1)
}

// 保存智能体
const handleSave = async (publish = false) => {
  if (!formRef.value) return
  
  try {
    await formRef.value.validate()
    
    saveLoading.value = true
    
    if (isEdit.value && formData.id) {
      // 更新智能体
      const updateData: UpdateAgentRequest = {
        id: formData.id,
        ...formData
      }
      
      await agentApi.updateAgent(updateData)
      
      // 如果需要发布
      if (publish) {
        await agentApi.publishAgent(formData.id)
      }
    } else {
      // 创建智能体
      const response = await agentApi.createAgent(formData)
      
      // 如果需要发布
      if (publish && response.data.id) {
        await agentApi.publishAgent(response.data.id)
      }
    }
    
    router.push('/ai-agent')
  } catch (error) {
    console.error('保存智能体失败:', error)
    ElMessage.error('保存失败，请重试')
  } finally {
    saveLoading.value = false
  }
}

// 取消编辑
const handleCancel = async () => {
  try {
    await ElMessageBox.confirm(
      '确认取消编辑吗？未保存的更改将丢失。',
      '取消确认',
      {
        confirmButtonText: '确认取消',
        cancelButtonText: '继续编辑',
        type: 'warning',
      }
    )
    
    router.push('/ai-agent')
  } catch (error) {
    // 用户取消
  }
}

// 加载数据（编辑模式）
const loadAgentData = async () => {
  if (!isEdit.value || !agentId.value) return
  
  loading.value = true
  try {
    const response = await agentApi.getAgent(agentId.value)
    const agent = response.data
    
    // 映射数据到表单
    Object.assign(formData, {
      id: agent.id,
      name: agent.name,
      description: agent.description,
      type: agent.type,
      avatar: agent.avatar,
      tags: agent.tags,
      platformType: agent.platformType,
      modelName: agent.modelName,
      systemPrompt: agent.systemPrompt,
      temperature: agent.temperature,
      maxTokens: agent.maxTokens,
      topP: agent.topP,
      frequencyPenalty: agent.frequencyPenalty,
      presencePenalty: agent.presencePenalty,
      features: agent.features,
      security: agent.security
    })
  } catch (error) {
    console.error('加载智能体数据失败:', error)
    ElMessage.error('加载智能体数据失败')
    router.push('/ai-agent')
  } finally {
    loading.value = false
  }
}

// 生命周期
onMounted(() => {
  loadAgentData()
})
</script>

<template>
  <div class="agent-form-container" v-loading="loading">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="header-content">
        <el-button :icon="ArrowLeft" @click="handleCancel" class="back-btn">
          返回列表
        </el-button>
        <div class="title-info">
          <h1 class="page-title">
            {{ isEdit ? '编辑智能体' : '创建智能体' }}
          </h1>
          <p class="page-subtitle">
            {{ isEdit ? '修改智能体配置和参数' : '创建一个新的AI智能体，配置其行为和能力' }}
          </p>
        </div>
      </div>
    </div>

    <!-- 步骤导航 -->
    <el-card class="steps-card" shadow="never">
      <el-steps :active="currentStep" align-center>
        <el-step
          v-for="(step, index) in steps"
          :key="index"
          :title="step.title"
          :description="step.description"
        />
      </el-steps>
    </el-card>

    <!-- 表单内容 -->
    <el-card class="form-card" shadow="never">
      <el-form
        ref="formRef"
        :model="formData"
        :rules="formRules"
        label-width="120px"
        size="large"
      >
        <!-- 步骤1: 基本信息 -->
        <div v-show="currentStep === 0" class="step-content">
          <div class="step-header">
            <h3>基本信息</h3>
            <p>设置智能体的基本信息，包括名称、类型和描述</p>
          </div>

          <el-row :gutter="24">
            <el-col :span="16">
              <el-form-item label="智能体名称" prop="name">
                <el-input
                  v-model="formData.name"
                  placeholder="请输入智能体名称"
                  maxlength="50"
                  show-word-limit
                />
              </el-form-item>

              <el-form-item label="智能体类型" prop="type">
                <el-radio-group v-model="formData.type" class="type-radio-group">
                  <el-radio
                    v-for="option in typeOptions"
                    :key="option.value"
                    :label="option.value"
                    class="type-radio"
                  >
                    <div class="type-option">
                      <div class="type-icon">{{ option.icon }}</div>
                      <div class="type-info">
                        <div class="type-label">{{ option.label }}</div>
                        <div class="type-desc">{{ option.description }}</div>
                      </div>
                    </div>
                  </el-radio>
                </el-radio-group>
              </el-form-item>

              <el-form-item label="智能体描述" prop="description">
                <el-input
                  v-model="formData.description"
                  type="textarea"
                  :rows="4"
                  placeholder="请详细描述智能体的功能和用途"
                  maxlength="500"
                  show-word-limit
                />
              </el-form-item>

              <el-form-item label="标签">
                <div class="tags-container">
                  <el-tag
                    v-for="tag in formData.tags"
                    :key="tag"
                    closable
                    @close="removeTag(tag)"
                    class="tag-item"
                  >
                    {{ tag }}
                  </el-tag>
                  
                  <el-input
                    v-if="tagInputVisible"
                    ref="tagInputRef"
                    v-model="newTag"
                    size="small"
                    @keyup.enter="addTag"
                    @blur="addTag"
                    class="tag-input"
                  />
                  
                  <el-button
                    v-else
                    size="small"
                    @click="showTagInput"
                    class="add-tag-btn"
                  >
                    + 添加标签
                  </el-button>
                </div>
              </el-form-item>
            </el-col>

            <el-col :span="8">
              <el-form-item label="头像">
                <div class="avatar-upload">
                  <el-upload
                    :before-upload="handleAvatarUpload"
                    :show-file-list="false"
                    class="avatar-uploader"
                  >
                    <img v-if="formData.avatar" :src="formData.avatar" class="avatar" />
                    <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
                  </el-upload>
                  <div class="avatar-tip">
                    <p>支持 JPG、PNG 格式</p>
                    <p>文件大小不超过 2MB</p>
                  </div>
                </div>
              </el-form-item>
            </el-col>
          </el-row>
        </div>

        <!-- 步骤2: 平台配置 -->
        <div v-show="currentStep === 1" class="step-content">
          <div class="step-header">
            <h3>平台配置</h3>
            <p>选择AI平台和模型，配置智能体的核心能力</p>
          </div>

          <el-form-item label="AI平台" prop="platformType">
            <el-radio-group v-model="formData.platformType" class="platform-radio-group">
              <el-radio
                v-for="platform in platformOptions"
                :key="platform.value"
                :label="platform.value"
                class="platform-radio"
              >
                <div class="platform-option">
                  <div class="platform-name">{{ platform.label }}</div>
                  <div class="platform-desc">{{ platform.description }}</div>
                </div>
              </el-radio>
            </el-radio-group>
          </el-form-item>

          <el-form-item label="模型选择" prop="modelName" v-if="formData.platformType">
            <el-select v-model="formData.modelName" placeholder="请选择模型" style="width: 100%">
              <el-option
                v-for="model in availableModels"
                :key="model"
                :label="model"
                :value="model"
              />
            </el-select>
          </el-form-item>

          <el-alert
            title="平台配置说明"
            type="info"
            :closable="false"
            show-icon
          >
            <template #default>
              <p>• 不同平台和模型具有不同的能力特点和价格策略</p>
              <p>• OpenAI GPT-4 适合复杂推理，GPT-3.5 性价比高</p>
              <p>• Claude 在安全性和长文本处理方面表现优秀</p>
              <p>• 文心一言对中文理解和本土化场景支持更好</p>
            </template>
          </el-alert>
        </div>

        <!-- 步骤3: 高级设置 -->
        <div v-show="currentStep === 2" class="step-content">
          <div class="step-header">
            <h3>高级设置</h3>
            <p>配置智能体的行为参数和功能特性</p>
          </div>

          <el-tabs type="border-card">
            <el-tab-pane label="系统提示词">
              <el-form-item label="系统提示词" prop="systemPrompt">
                <el-input
                  v-model="formData.systemPrompt"
                  type="textarea"
                  :rows="8"
                  placeholder="请输入系统提示词，定义智能体的角色、行为和回复风格..."
                  maxlength="2000"
                  show-word-limit
                />
              </el-form-item>
            </el-tab-pane>

            <el-tab-pane label="模型参数">
              <el-row :gutter="24">
                <el-col :span="12">
                  <el-form-item label="温度系数">
                    <el-slider
                      v-model="formData.temperature"
                      :min="0"
                      :max="1"
                      :step="0.1"
                      show-tooltip
                    />
                    <div class="param-tip">控制回复的随机性，越高越有创意</div>
                  </el-form-item>

                  <el-form-item label="最大Token">
                    <el-input-number
                      v-model="formData.maxTokens"
                      :min="1"
                      :max="4096"
                      :step="256"
                      style="width: 100%"
                    />
                    <div class="param-tip">控制回复的最大长度</div>
                  </el-form-item>

                  <el-form-item label="Top P">
                    <el-slider
                      v-model="formData.topP"
                      :min="0"
                      :max="1"
                      :step="0.1"
                      show-tooltip
                    />
                    <div class="param-tip">控制词汇选择的多样性</div>
                  </el-form-item>
                </el-col>

                <el-col :span="12">
                  <el-form-item label="频率惩罚">
                    <el-slider
                      v-model="formData.frequencyPenalty"
                      :min="0"
                      :max="2"
                      :step="0.1"
                      show-tooltip
                    />
                    <div class="param-tip">减少重复词汇的使用</div>
                  </el-form-item>

                  <el-form-item label="存在惩罚">
                    <el-slider
                      v-model="formData.presencePenalty"
                      :min="0"
                      :max="2"
                      :step="0.1"
                      show-tooltip
                    />
                    <div class="param-tip">鼓励讨论新话题</div>
                  </el-form-item>
                </el-col>
              </el-row>
            </el-tab-pane>

            <el-tab-pane label="功能配置">
              <el-row :gutter="24">
                <el-col :span="12">
                  <el-form-item label="记忆功能">
                    <el-switch v-model="formData.features.memoryEnabled" />
                    <div class="param-tip">是否记住对话历史</div>
                  </el-form-item>

                  <el-form-item label="上下文窗口">
                    <el-input-number
                      v-model="formData.features.contextWindow"
                      :min="1000"
                      :max="32000"
                      :step="1000"
                      style="width: 100%"
                    />
                    <div class="param-tip">上下文记忆的最大长度</div>
                  </el-form-item>

                  <el-form-item label="流式响应">
                    <el-switch v-model="formData.features.streamResponse" />
                    <div class="param-tip">是否启用实时流式回复</div>
                  </el-form-item>
                </el-col>

                <el-col :span="12">
                  <el-form-item label="网络搜索">
                    <el-switch v-model="formData.features.webSearch" />
                    <div class="param-tip">是否支持实时网络搜索</div>
                  </el-form-item>

                  <el-form-item label="代码执行">
                    <el-switch v-model="formData.features.codeExecution" />
                    <div class="param-tip">是否支持代码分析和执行</div>
                  </el-form-item>

                  <el-form-item label="图像分析">
                    <el-switch v-model="formData.features.imageAnalysis" />
                    <div class="param-tip">是否支持图像识别和分析</div>
                  </el-form-item>
                </el-col>
              </el-row>
            </el-tab-pane>

            <el-tab-pane label="安全配置">
              <el-form-item label="内容过滤">
                <el-switch v-model="formData.security.contentFilter" />
                <div class="param-tip">是否启用内容安全过滤</div>
              </el-form-item>

              <el-form-item label="速率限制">
                <el-switch v-model="formData.security.rateLimitEnabled" />
                <div class="param-tip">是否启用API调用速率限制</div>
              </el-form-item>

              <el-form-item label="每分钟最大请求数" v-if="formData.security.rateLimitEnabled">
                <el-input-number
                  v-model="formData.security.maxRequestsPerMinute"
                  :min="1"
                  :max="1000"
                  style="width: 200px"
                />
              </el-form-item>

              <el-form-item label="允许的域名">
                <div class="list-config">
                  <div
                    v-for="(domain, index) in formData.security.allowedDomains"
                    :key="index"
                    class="list-item"
                  >
                    <el-input v-model="formData.security.allowedDomains[index]" placeholder="example.com" />
                    <el-button :icon="Delete" @click="removeDomain(index)" />
                  </div>
                  <el-button :icon="Plus" @click="addDomain">添加域名</el-button>
                </div>
              </el-form-item>

              <el-form-item label="屏蔽关键词">
                <div class="list-config">
                  <div
                    v-for="(keyword, index) in formData.security.blockedKeywords"
                    :key="index"
                    class="list-item"
                  >
                    <el-input v-model="formData.security.blockedKeywords[index]" placeholder="敏感词" />
                    <el-button :icon="Delete" @click="removeKeyword(index)" />
                  </div>
                  <el-button :icon="Plus" @click="addKeyword">添加关键词</el-button>
                </div>
              </el-form-item>
            </el-tab-pane>
          </el-tabs>
        </div>

        <!-- 步骤4: 预览发布 -->
        <div v-show="currentStep === 3" class="step-content">
          <div class="step-header">
            <h3>预览发布</h3>
            <p>确认智能体配置信息，选择保存或发布</p>
          </div>

          <div class="preview-container">
            <el-descriptions title="智能体信息" :column="2" border>
              <el-descriptions-item label="名称">{{ formData.name }}</el-descriptions-item>
              <el-descriptions-item label="类型">
                {{ typeOptions.find(t => t.value === formData.type)?.label }}
              </el-descriptions-item>
              <el-descriptions-item label="描述" :span="2">{{ formData.description }}</el-descriptions-item>
              <el-descriptions-item label="平台">
                {{ platformOptions.find(p => p.value === formData.platformType)?.label }}
              </el-descriptions-item>
              <el-descriptions-item label="模型">{{ formData.modelName }}</el-descriptions-item>
              <el-descriptions-item label="标签" :span="2">
                <el-tag v-for="tag in formData.tags" :key="tag" size="small" class="tag-preview">
                  {{ tag }}
                </el-tag>
              </el-descriptions-item>
            </el-descriptions>

            <el-alert
              title="发布说明"
              type="warning"
              :closable="false"
              show-icon
              class="publish-alert"
            >
              <template #default>
                <p>• <strong>保存为草稿</strong>：智能体将保存但不会对外提供服务</p>
                <p>• <strong>发布</strong>：智能体将立即可用，用户可以开始对话</p>
                <p>• 发布后仍可以修改配置，但建议先进行充分测试</p>
              </template>
            </el-alert>
          </div>
        </div>
      </el-form>
    </el-card>

    <!-- 操作按钮 -->
    <div class="action-bar">
      <div class="step-actions">
        <el-button v-if="currentStep > 0" @click="prevStep">
          上一步
        </el-button>
        
        <el-button
          v-if="currentStep < steps.length - 1"
          type="primary"
          @click="nextStep"
        >
          下一步
        </el-button>
      </div>

      <div class="save-actions" v-if="currentStep === steps.length - 1">
        <el-button @click="handleCancel">
          取消
        </el-button>
        <el-button
          type="info"
          :loading="saveLoading"
          @click="handleSave(false)"
        >
          保存为草稿
        </el-button>
        <el-button
          type="primary"
          :loading="saveLoading"
          @click="handleSave(true)"
        >
          发布智能体
        </el-button>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
.agent-form-container {
  padding: 20px;
  background-color: #f5f7fa;
  min-height: calc(100vh - 60px);
}

.page-header {
  margin-bottom: 20px;
  
  .header-content {
    display: flex;
    align-items: center;
    gap: 16px;
    
    .back-btn {
      flex-shrink: 0;
    }
    
    .title-info {
      .page-title {
        margin: 0 0 4px 0;
        font-size: 24px;
        font-weight: 600;
        color: #303133;
      }
      
      .page-subtitle {
        margin: 0;
        color: #606266;
        font-size: 14px;
      }
    }
  }
}

.steps-card {
  margin-bottom: 20px;
  
  :deep(.el-card__body) {
    padding: 30px 20px;
  }
}

.form-card {
  margin-bottom: 20px;
  
  :deep(.el-card__body) {
    padding: 30px;
  }
}

.step-content {
  .step-header {
    margin-bottom: 30px;
    padding-bottom: 20px;
    border-bottom: 1px solid #ebeef5;
    
    h3 {
      margin: 0 0 8px 0;
      font-size: 18px;
      font-weight: 600;
      color: #303133;
    }
    
    p {
      margin: 0;
      color: #606266;
      font-size: 14px;
    }
  }
}

.type-radio-group {
  width: 100%;
  display: block; /* 防止内联布局导致项重叠 */
  
  .type-radio {
    width: 100%;
    display: block; /* 每个选项独占一行 */
    margin-right: 0;
    margin-bottom: 16px;
    
    :deep(.el-radio__label) {
      width: 100%;
      padding-left: 12px;
    }
    
    .type-option {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 16px;
      border: 1px solid #dcdfe6;
      border-radius: 8px;
      transition: all 0.3s;
      
      &:hover {
        border-color: #409eff;
      }
      
      .type-icon {
        font-size: 24px;
      }
      
      .type-info {
        .type-label {
          font-weight: 500;
          color: #303133;
          margin-bottom: 4px;
        }
        
        .type-desc {
          font-size: 12px;
          color: #909399;
        }
      }
    }
  }
  
  :deep(.el-radio__input.is-checked + .el-radio__label .type-option) {
    border-color: #409eff;
    background-color: #f0f9ff;
  }
}

.platform-radio-group {
  width: 100%;
  
  .platform-radio {
    width: 100%;
    margin-right: 0;
    margin-bottom: 12px;
    
    :deep(.el-radio__label) {
      width: 100%;
      padding-left: 12px;
    }
    
    .platform-option {
      padding: 12px 16px;
      border: 1px solid #dcdfe6;
      border-radius: 6px;
      transition: all 0.3s;
      
      &:hover {
        border-color: #409eff;
      }
      
      .platform-name {
        font-weight: 500;
        color: #303133;
        margin-bottom: 4px;
      }
      
      .platform-desc {
        font-size: 12px;
        color: #909399;
      }
    }
  }
  
  :deep(.el-radio__input.is-checked + .el-radio__label .platform-option) {
    border-color: #409eff;
    background-color: #f0f9ff;
  }
}

.tags-container {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  align-items: center;
  
  .tag-item {
    margin-right: 0;
  }
  
  .tag-input {
    width: 100px;
  }
  
  .add-tag-btn {
    height: 24px;
    line-height: 22px;
    border-style: dashed;
  }
}

.avatar-upload {
  text-align: center;
  
  .avatar-uploader {
    :deep(.el-upload) {
      border: 1px dashed #d9d9d9;
      border-radius: 6px;
      cursor: pointer;
      position: relative;
      overflow: hidden;
      transition: 0.3s;
      
      &:hover {
        border-color: #409eff;
      }
    }
  }
  
  .avatar-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 80px;
    height: 80px;
    text-align: center;
    line-height: 80px;
  }
  
  .avatar {
    width: 80px;
    height: 80px;
    display: block;
  }
  
  .avatar-tip {
    margin-top: 8px;
    font-size: 12px;
    color: #909399;
    
    p {
      margin: 4px 0;
    }
  }
}

.param-tip {
  font-size: 12px;
  color: #909399;
  margin-top: 4px;
}

.list-config {
  .list-item {
    display: flex;
    gap: 8px;
    margin-bottom: 8px;
    align-items: center;
    
    .el-input {
      flex: 1;
    }
  }
}

.preview-container {
  .tag-preview {
    margin-right: 8px;
    margin-bottom: 4px;
  }
  
  .publish-alert {
    margin-top: 20px;
  }
}

.action-bar {
  position: sticky; /* 与内容同宽，避免跑到侧边栏下方 */
  bottom: 0;
  background: #fff;
  border-top: 1px solid #ebeef5;
  padding: 16px 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  z-index: 1002; /* 保证在页面内置footer之上 */
  
  .step-actions {
    display: flex;
    gap: 12px;
  }
  
  .save-actions {
    display: flex;
    gap: 12px;
  }
}

// 为底部固定按钮留出空间
.agent-form-container {
  padding-bottom: 96px; /* 预留更大空间，避免被全局footer遮挡 */
}
</style>