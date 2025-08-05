<template>
  <div class="agent-form">
    <el-form
      ref="formRef"
      :model="formData"
      :rules="formRules"
      label-width="120px"
      size="default"
      :disabled="formMode === 'view'"
    >
      <!-- 基本信息 -->
      <el-card class="form-card" shadow="never">
        <template #header>
          <div class="card-header">
            <el-icon><InfoFilled /></el-icon>
            <span>基本信息</span>
          </div>
        </template>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="智能体名称" prop="name">
              <el-input
                v-model="formData.name"
                placeholder="请输入智能体名称"
                maxlength="100"
                show-word-limit
              />
            </el-form-item>
          </el-col>
          
          <el-col :span="12">
            <el-form-item label="智能体类型" prop="type">
              <el-select
                v-model="formData.type"
                placeholder="请选择智能体类型"
                style="width: 100%"
              >
                <el-option
                  v-for="option in agentTypeOptions"
                  :key="option.value"
                  :label="option.label"
                  :value="option.value"
                >
                  <div class="option-item">
                    <span>{{ option.label }}</span>
                    <span class="option-desc">{{ option.description }}</span>
                  </div>
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="智能体描述" prop="description">
          <el-input
            v-model="formData.description"
            type="textarea"
            :rows="3"
            placeholder="请输入智能体的功能描述"
            maxlength="500"
            show-word-limit
          />
        </el-form-item>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="头像URL" prop="avatar">
              <div class="avatar-upload">
                <el-input
                  v-model="formData.avatar"
                  placeholder="请输入头像URL或点击上传"
                >
                  <template #append>
                    <el-button @click="handleAvatarUpload">
                      <el-icon><Upload /></el-icon>
                      上传
                    </el-button>
                  </template>
                </el-input>
                <div v-if="formData.avatar" class="avatar-preview">
                  <el-image
                    :src="formData.avatar"
                    fit="cover"
                    :preview-src-list="[formData.avatar]"
                  />
                </div>
              </div>
            </el-form-item>
          </el-col>
          
          <el-col :span="12">
            <el-form-item label="启用状态" prop="enabled">
              <el-switch
                v-model="formData.enabled"
                active-text="启用"
                inactive-text="禁用"
              />
            </el-form-item>
          </el-col>
        </el-row>
      </el-card>

      <!-- 平台配置 -->
      <el-card class="form-card" shadow="never">
        <template #header>
          <div class="card-header">
            <el-icon><Connection /></el-icon>
            <span>平台配置</span>
          </div>
        </template>

        <el-form-item label="外部平台类型" prop="externalPlatformType">
          <el-select
            v-model="formData.externalPlatformType"
            placeholder="请选择外部平台类型"
            style="width: 100%"
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

        <el-form-item label="外部智能体ID" prop="externalAgentId">
          <el-input
            v-model="formData.externalAgentId"
            placeholder="请输入外部平台的智能体ID"
            :disabled="!formData.externalPlatformType"
          />
        </el-form-item>
      </el-card>

      <!-- 高级配置 -->
      <el-card class="form-card" shadow="never">
        <template #header>
          <div class="card-header">
            <el-icon><Setting /></el-icon>
            <span>高级配置</span>
          </div>
        </template>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="排序权重" prop="sortWeight">
              <el-input-number
                v-model="formData.sortWeight"
                :min="0"
                :max="999"
                :step="1"
                style="width: 100%"
                placeholder="数值越大排序越靠前"
              />
            </el-form-item>
          </el-col>
          
          <el-col :span="12">
            <el-form-item label="公开状态" prop="isPublic">
              <el-switch
                v-model="formData.isPublic"
                active-text="公开"
                inactive-text="私有"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="系统提示词" prop="systemPrompt">
          <el-input
            v-model="formData.systemPrompt"
            type="textarea"
            :rows="5"
            placeholder="请输入系统提示词，用于指导AI的行为"
            maxlength="2000"
            show-word-limit
          />
        </el-form-item>

        <el-form-item label="欢迎消息" prop="welcomeMessage">
          <el-input
            v-model="formData.welcomeMessage"
            type="textarea"
            :rows="3"
            placeholder="请输入用户开始对话时的欢迎消息"
            maxlength="500"
            show-word-limit
          />
        </el-form-item>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="启用状态">
              <el-switch
                v-model="formData.enabled"
                active-text="启用"
                inactive-text="禁用"
              />
            </el-form-item>
          </el-col>
          
          <el-col :span="12">
            <el-form-item label="启用日志">
              <el-switch
                v-model="formData.enableLogging"
                active-text="启用"
                inactive-text="禁用"
              />
            </el-form-item>
          </el-col>
        </el-row>
      </el-card>

      <!-- 标签管理 -->
      <el-card class="form-card" shadow="never">
        <template #header>
          <div class="card-header">
            <el-icon><PriceTag /></el-icon>
            <span>标签管理</span>
          </div>
        </template>

        <el-form-item label="智能体标签" prop="tags">
          <div class="tags-input">
            <el-tag
              v-for="(tag, index) in formData.tags"
              :key="index"
              closable
              @close="removeTag(index)"
              style="margin-right: 8px; margin-bottom: 8px"
            >
              {{ tag }}
            </el-tag>
            <el-input
              v-if="tagInputVisible"
              ref="tagInputRef"
              v-model="tagInputValue"
              size="small"
              style="width: 120px"
              @keyup.enter="addTag"
              @blur="addTag"
            />
            <el-button
              v-else
              size="small"
              type="primary"
              plain
              @click="showTagInput"
            >
              <el-icon><Plus /></el-icon>
              添加标签
            </el-button>
          </div>
        </el-form-item>
      </el-card>

      <!-- 表单操作按钮 -->
      <div class="form-actions">
        <el-button @click="handleCancel">取消</el-button>
        <el-button type="primary" @click="handleTest" :loading="testing">
          <el-icon><ChatLineRound /></el-icon>
          测试对话
        </el-button>
        <el-button
          type="primary"
          @click="handleSubmit"
          :loading="submitting"
          v-if="formMode !== 'view'"
        >
          {{ formMode === 'create' ? '创建智能体' : '更新智能体' }}
        </el-button>
      </div>
    </el-form>

    <!-- 平台配置弹窗 -->
    <PlatformConfigDialog
      v-model:visible="showPlatformDialog"
      @success="handlePlatformCreated"
    />

    <!-- 模型配置弹窗 -->
    <ModelConfigDialog
      v-model:visible="showModelDialog"
      :platform-config-id="formData.platformConfigId"
      @success="handleModelCreated"
    />

    <!-- 测试对话弹窗 -->
    <ChatTestDialog
      v-model:visible="showChatDialog"
      :agent-data="formData"
      @success="handleTestSuccess"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, watch, onMounted, nextTick } from 'vue'
import { ElMessage, ElMessageBox, type FormInstance } from 'element-plus'
import { 
  InfoFilled, Connection, Setting, PriceTag, Plus, Upload, 
  ChatLineRound 
} from '@element-plus/icons-vue'
import { agentApi } from '@/api/agent'
import type { 
  AgentDTO, CreateAgentRequest, UpdateAgentRequest, 
  PlatformConfigDTO, ModelConfigDTO
} from '@/types'
import { AgentType, AgentStatus, PlatformType } from '@/types'

// =============== Props & Emits ===============
interface Props {
  modelValue?: AgentDTO | null
  mode?: 'create' | 'edit' | 'view'
}

interface Emits {
  (event: 'update:modelValue', value: AgentDTO | null): void
  (event: 'success', agent: AgentDTO): void
  (event: 'cancel'): void
}

const props = withDefaults(defineProps<Props>(), {
  mode: 'create'
})
const emit = defineEmits<Emits>()

// =============== Reactive Data ===============
const formRef = ref<FormInstance>()
const tagInputRef = ref()

const formMode = computed(() => props.mode)
const submitting = ref(false)
const testing = ref(false)

// 表单数据
const formData = reactive<CreateAgentRequest & { id?: string }>({
  name: '',
  description: '',
  avatar: '',
  type: AgentType.CHAT_ASSISTANT,
  externalPlatformType: '',
  externalAgentId: '',
  systemPrompt: '',
  welcomeMessage: '您好！我是您的AI助手，有什么可以帮助您的吗？',
  temperature: 0.7,
  maxTokens: 1000,
  enabled: true,
  tags: []
})

// 平台和模型配置
const platformConfigs = ref<PlatformConfigDTO[]>([])
const modelConfigs = ref<ModelConfigDTO[]>([])

// 对话框状态
const showPlatformDialog = ref(false)
const showModelDialog = ref(false)
const showChatDialog = ref(false)

// 标签输入
const tagInputVisible = ref(false)
const tagInputValue = ref('')

// =============== Form Rules ===============
const formRules = {
  name: [
    { required: true, message: '请输入智能体名称', trigger: 'blur' },
    { min: 2, max: 100, message: '长度在 2 到 100 个字符', trigger: 'blur' }
  ],
  type: [
    { required: true, message: '请选择智能体类型', trigger: 'change' }
  ],
  platformConfigId: [
    { required: true, message: '请选择外部平台配置', trigger: 'change' }
  ],
  modelConfigId: [
    { required: true, message: '请选择AI模型配置', trigger: 'change' }
  ],
  timeoutSeconds: [
    { required: true, message: '请输入超时时间', trigger: 'blur' },
    { type: 'number' as const, min: 1, max: 300, message: '超时时间必须在1-300秒之间', trigger: 'blur' }
  ],
  maxRetries: [
    { required: true, message: '请输入最大重试次数', trigger: 'blur' },
    { type: 'number' as const, min: 0, max: 10, message: '重试次数必须在0-10次之间', trigger: 'blur' }
  ],
  priority: [
    { required: true, message: '请选择优先级', trigger: 'change' }
  ]
}

// =============== Computed ===============
const platformTypeOptions = computed(() => [
  { 
    value: PlatformType.COZE, 
    label: 'Coze', 
    description: 'Coze AI对话平台',
    tagType: 'primary'
  },
  { 
    value: PlatformType.DIFY, 
    label: 'Dify', 
    description: 'Dify LLM应用平台',
    tagType: 'success'
  },
  { 
    value: PlatformType.ALIBABA_DASHSCOPE, 
    label: '阿里百炼', 
    description: '阿里云通义千问模型服务',
    tagType: 'warning'
  },
  { 
    value: PlatformType.OPENAI, 
    label: 'OpenAI', 
    description: 'OpenAI GPT模型服务',
    tagType: 'info'
  },
  { 
    value: PlatformType.CLAUDE, 
    label: 'Claude', 
    description: 'Anthropic Claude模型服务',
    tagType: 'danger'
  },
  { 
    value: PlatformType.WENXIN_YIYAN, 
    label: '文心一言', 
    description: '百度文心一言模型服务',
    tagType: 'primary'
  },
  { 
    value: PlatformType.CUSTOM, 
    label: '自定义', 
    description: '自定义平台接入',
    tagType: 'info'
  }
])

const agentTypeOptions = computed(() => [
  { 
    value: AgentType.CHAT_ASSISTANT, 
    label: '聊天助手', 
    description: '通用对话式AI助手' 
  },
  { 
    value: AgentType.WORKFLOW, 
    label: '工作流', 
    description: '自动化任务处理流程' 
  },
  { 
    value: AgentType.CODE_ASSISTANT, 
    label: '代码助手', 
    description: '编程开发辅助工具' 
  },
  { 
    value: AgentType.KNOWLEDGE_QA, 
    label: '知识问答', 
    description: '基于知识库的问答系统' 
  },
  { 
    value: AgentType.CUSTOM, 
    label: '自定义', 
    description: '自定义功能智能体' 
  }
])

const filteredModelConfigs = computed(() => {
  if (!formData.platformConfigId) return []
  return modelConfigs.value.filter(model => 
    model.platformConfigId === formData.platformConfigId
  )
})

// =============== Methods ===============
const loadPlatformConfigs = async () => {
  try {
    const response = await agentApi.getPlatformConfigs({ pageNum: 1, pageSize: 100 })
    if (response.code === 200) {
      platformConfigs.value = response.data.records
    }
  } catch (error) {
    console.error('加载平台配置失败:', error)
  }
}

const loadModelConfigs = async () => {
  try {
    const response = await agentApi.getModelConfigs({ pageNum: 1, pageSize: 100 })
    if (response.code === 200) {
      modelConfigs.value = response.data.records
    }
  } catch (error) {
    console.error('加载模型配置失败:', error)
  }
}

const handlePlatformChange = () => {
  // 清空模型选择
  formData.modelConfigId = ''
}

const handlePlatformCreated = (platform: PlatformConfigDTO) => {
  platformConfigs.value.push(platform)
  formData.platformConfigId = platform.id
  ElMessage.success('平台配置创建成功')
}

const handleModelCreated = (model: ModelConfigDTO) => {
  modelConfigs.value.push(model)
  formData.modelConfigId = model.id
  ElMessage.success('模型配置创建成功')
}

const handleAvatarUpload = () => {
  // 实现头像上传逻辑
  ElMessage.info('头像上传功能待实现')
}

const showTagInput = () => {
  tagInputVisible.value = true
  nextTick(() => {
    tagInputRef.value?.focus()
  })
}

const addTag = () => {
  const value = tagInputValue.value.trim()
  if (!formData.tags) {
    formData.tags = []
  }
  if (value && !formData.tags.includes(value)) {
    formData.tags.push(value)
  }
  tagInputValue.value = ''
  tagInputVisible.value = false
}

const removeTag = (index: number) => {
  if (formData.tags) {
    formData.tags.splice(index, 1)
  }
}

const handleTest = async () => {
  // 验证表单
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid) {
    ElMessage.error('请完善表单信息后再进行测试')
    return
  }
  
  showChatDialog.value = true
}

const handleTestSuccess = () => {
  ElMessage.success('测试对话完成')
}

const handleSubmit = async () => {
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid) return

  submitting.value = true
  
  try {
    if (formMode.value === 'create') {
      const response = await agentApi.createAgent(formData)
      if (response.code === 200) {
        ElMessage.success('智能体创建成功')
        emit('success', response.data)
      }
    } else if (formMode.value === 'edit') {
      const response = await agentApi.updateAgent(formData.id!, formData as UpdateAgentRequest)
      if (response.code === 200) {
        ElMessage.success('智能体更新成功')
        emit('success', response.data)
      }
    }
  } catch (error: any) {
    ElMessage.error(error.message || '操作失败')
  } finally {
    submitting.value = false
  }
}

const handleCancel = () => {
  emit('cancel')
}

const resetForm = () => {
  Object.assign(formData, {
    name: '',
    description: '',
    avatarUrl: '',
    type: AgentType.CHAT_ASSISTANT,
    status: AgentStatus.DRAFT,
    platformConfigId: '',
    modelConfigId: '',
    systemPrompt: '',
    welcomeMessage: '您好！我是您的AI助手，有什么可以帮助您的吗？',
    timeoutSeconds: 30,
    maxRetries: 3,
    priority: 5,
    enabled: true,
    enableLogging: true,
    tags: []
  })
  formRef.value?.clearValidate()
}

// =============== Utils ===============
const getPlatformTypeText = (type: PlatformType): string => {
  const typeMap = {
    [PlatformType.COZE]: 'Coze',
    [PlatformType.DIFY]: 'Dify',
    [PlatformType.ALIBABA_DASHSCOPE]: '阿里百炼',
    [PlatformType.OPENAI]: 'OpenAI',
    [PlatformType.CLAUDE]: 'Claude',
    [PlatformType.WENXIN_YIYAN]: '文心一言',
    [PlatformType.CUSTOM]: '自定义'
  }
  return typeMap[type] || type
}

const getPlatformTagType = (type: PlatformType): string => {
  const tagTypeMap = {
    [PlatformType.COZE]: 'primary',
    [PlatformType.DIFY]: 'success',
    [PlatformType.ALIBABA_DASHSCOPE]: 'warning',
    [PlatformType.OPENAI]: 'info',
    [PlatformType.CLAUDE]: 'danger',
    [PlatformType.WENXIN_YIYAN]: 'primary',
    [PlatformType.CUSTOM]: 'info'
  }
  return tagTypeMap[type] || 'info'
}

// =============== Watchers ===============
watch(() => props.modelValue, (newValue) => {
  if (newValue && formMode.value !== 'create') {
    Object.assign(formData, newValue)
  } else if (formMode.value === 'create') {
    resetForm()
  }
}, { immediate: true })

// =============== Lifecycle ===============
onMounted(() => {
  loadPlatformConfigs()
  loadModelConfigs()
})

// =============== Expose ===============
defineExpose({
  resetForm,
  formRef
})
</script>

<style lang="scss" scoped>
.agent-form {
  .form-card {
    margin-bottom: 20px;
    
    :deep(.el-card__header) {
      padding: 16px 20px;
      border-bottom: 1px solid var(--el-border-color-light);
    }
    
    :deep(.el-card__body) {
      padding: 20px;
    }
  }
  
  .card-header {
    display: flex;
    align-items: center;
    font-weight: 600;
    color: var(--el-text-color-primary);
    
    .el-icon {
      margin-right: 8px;
      color: var(--el-color-primary);
    }
  }
  
  .option-item {
    display: flex;
    flex-direction: column;
    
    .option-desc {
      font-size: 12px;
      color: var(--el-text-color-secondary);
      margin-top: 2px;
    }
  }
  
  .avatar-upload {
    .avatar-preview {
      margin-top: 10px;
      
      .el-image {
        width: 80px;
        height: 80px;
        border-radius: 8px;
        border: 1px solid var(--el-border-color);
      }
    }
  }
  
  .platform-config,
  .model-config {
    display: flex;
    align-items: center;
  }
  
  .platform-option,
  .model-option {
    display: flex;
    align-items: center;
    justify-content: space-between;
    width: 100%;
    
    .platform-name,
    .model-name {
      font-weight: 500;
    }
    
    .model-provider {
      font-size: 12px;
      color: var(--el-text-color-secondary);
      margin-left: 8px;
    }
  }
  
  .tags-input {
    .el-tag {
      margin-right: 8px;
      margin-bottom: 8px;
    }
  }
  
  .form-actions {
    display: flex;
    justify-content: center;
    gap: 16px;
    padding: 20px 0;
    border-top: 1px solid var(--el-border-color-light);
    margin-top: 20px;
  }
}

@media (max-width: 768px) {
  .agent-form {
    .form-actions {
      flex-direction: column;
      
      .el-button {
        width: 100%;
      }
    }
  }
}
</style>