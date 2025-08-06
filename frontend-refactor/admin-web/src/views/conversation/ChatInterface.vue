<template>
  <div class="chat-interface">
    <!-- 聊天头部 -->
    <div class="chat-header">
      <div class="header-left">
        <el-button 
          :icon="ArrowLeft" 
          @click="handleBack"
          circle
          size="small"
        />
        <div class="agent-info">
          <div class="agent-avatar">
            <img v-if="currentAgent?.avatar" :src="currentAgent.avatar" alt="智能体头像" />
            <div v-else class="default-avatar">{{ currentAgent?.name?.charAt(0) || 'A' }}</div>
          </div>
          <div class="agent-details">
            <h3>{{ currentAgent?.name || '智能体' }}</h3>
            <p>{{ currentAgent?.description || '正在为您服务...' }}</p>
          </div>
        </div>
      </div>
      
      <div class="header-right">
        <el-dropdown @command="handleHeaderAction">
          <el-button :icon="Setting" circle />
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item command="conversation-info" :icon="InfoFilled">
                对话信息
              </el-dropdown-item>
              <el-dropdown-item command="clear-history" :icon="Delete">
                清空历史
              </el-dropdown-item>
              <el-dropdown-item command="export" :icon="Download">
                导出对话
              </el-dropdown-item>
              <el-dropdown-item 
                :command="currentConversation?.isStarred ? 'unstar' : 'star'" 
                :icon="currentConversation?.isStarred ? Star : StarFilled"
              >
                {{ currentConversation?.isStarred ? '取消收藏' : '收藏对话' }}
              </el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </div>

    <!-- 消息列表区域 -->
    <div class="chat-messages" ref="messagesContainer">
      <div class="messages-wrapper">
        <!-- 欢迎消息 -->
        <div v-if="!messages.length && !loading" class="welcome-message">
          <div class="welcome-avatar">
            <img v-if="currentAgent?.avatar" :src="currentAgent.avatar" alt="智能体头像" />
            <div v-else class="default-avatar">{{ currentAgent?.name?.charAt(0) || 'A' }}</div>
          </div>
          <div class="welcome-content">
            <h3>你好！我是 {{ currentAgent?.name || '智能体' }}</h3>
            <p>{{ currentAgent?.description || '我可以帮助您解答问题，请告诉我您需要什么帮助。' }}</p>
            
            <!-- 快速建议 -->
            <div v-if="suggestions.length" class="quick-suggestions">
              <div class="suggestions-title">您可以这样问我：</div>
              <div class="suggestions-list">
                <el-button
                  v-for="suggestion in suggestions"
                  :key="suggestion"
                  size="small"
                  type="primary"
                  plain
                  @click="handleSuggestionClick(suggestion)"
                >
                  {{ suggestion }}
                </el-button>
              </div>
            </div>
          </div>
        </div>

        <!-- 消息列表 -->
        <div 
          v-for="message in messages" 
          :key="message.id"
          class="message-item"
          :class="{ 'is-user': message.role === 'USER', 'is-assistant': message.role === 'ASSISTANT' }"
        >
          <div class="message-avatar">
            <template v-if="message.role === 'USER'">
              <img v-if="userStore.userInfo.avatar" :src="userStore.userInfo.avatar" alt="用户头像" />
              <div v-else class="default-avatar user-avatar">{{ userStore.userInfo.realName?.charAt(0) || 'U' }}</div>
            </template>
            <template v-else>
              <img v-if="currentAgent?.avatar" :src="currentAgent.avatar" alt="智能体头像" />
              <div v-else class="default-avatar agent-avatar">{{ currentAgent?.name?.charAt(0) || 'A' }}</div>
            </template>
          </div>
          
          <div class="message-content">
            <div class="message-header">
              <span class="message-sender">
                {{ message.role === 'USER' ? (userStore.userInfo.realName || '我') : (currentAgent?.name || '智能体') }}
              </span>
              <span class="message-time">{{ formatMessageTime(message.createdAt) }}</span>
            </div>
            
            <div class="message-body">
              <!-- 文本消息 -->
              <div v-if="message.type === 'TEXT'" class="message-text">
                <div v-if="message.id === streamingMessageId && isStreaming" class="streaming-text">
                  {{ streamingContent }}
                  <span class="typing-cursor">|</span>
                </div>
                <div v-else v-html="formatMessageContent(message.content)"></div>
              </div>
              
              <!-- 图片消息 -->
              <div v-else-if="message.type === 'IMAGE'" class="message-image">
                <el-image 
                  :src="message.content" 
                  fit="cover"
                  style="max-width: 300px; max-height: 200px; border-radius: 8px"
                  :preview-src-list="[message.content]"
                />
              </div>
              
              <!-- 文件消息 -->
              <div v-else-if="message.type === 'FILE'" class="message-file">
                <div class="file-info">
                  <el-icon><Document /></el-icon>
                  <span>{{ message.metadata?.filename || '文件' }}</span>
                  <el-button size="small" type="primary" link @click="downloadFile(message.content)">
                    下载
                  </el-button>
                </div>
              </div>
            </div>
            
            <!-- 消息操作 -->
            <div class="message-actions">
              <el-button-group size="small">
                <el-button 
                  :icon="Copy" 
                  @click="copyMessage(message.content)"
                  title="复制"
                />
                <el-button 
                  v-if="message.role === 'ASSISTANT'"
                  :icon="Refresh" 
                  @click="regenerateMessage(message)"
                  title="重新生成"
                />
                <el-button 
                  :icon="message.reactions?.some(r => r.type === 'LIKE') ? ThumbsUp : ThumbsUpOutline"
                  @click="toggleReaction(message, 'LIKE')"
                  title="点赞"
                />
                <el-button 
                  :icon="Delete" 
                  @click="deleteMessage(message)"
                  title="删除"
                />
              </el-button-group>
            </div>
            
            <!-- 消息状态 -->
            <div v-if="message.status" class="message-status">
              <el-icon v-if="message.status === 'SENDING'"><Loading /></el-icon>
              <el-icon v-else-if="message.status === 'FAILED'" class="failed"><CircleCloseFilled /></el-icon>
              <span v-if="message.tokens" class="token-count">{{ message.tokens }} tokens</span>
              <span v-if="message.cost" class="cost">¥{{ message.cost.toFixed(4) }}</span>
            </div>
          </div>
        </div>

        <!-- 输入提示 -->
        <div v-if="isTyping" class="typing-indicator">
          <div class="typing-avatar">
            <img v-if="currentAgent?.avatar" :src="currentAgent.avatar" alt="智能体头像" />
            <div v-else class="default-avatar agent-avatar">{{ currentAgent?.name?.charAt(0) || 'A' }}</div>
          </div>
          <div class="typing-content">
            <div class="typing-dots">
              <span></span>
              <span></span>
              <span></span>
            </div>
            <span class="typing-text">{{ currentAgent?.name || '智能体' }} 正在输入...</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 输入区域 -->
    <div class="chat-input">
      <div class="input-container">
        <div class="input-actions">
          <el-upload
            :before-upload="handleFileUpload"
            :show-file-list="false"
            accept="image/*,.pdf,.doc,.docx,.txt"
          >
            <el-button :icon="Paperclip" circle size="small" title="上传文件" />
          </el-upload>
          
          <el-button 
            :icon="Picture" 
            circle 
            size="small" 
            title="发送图片"
            @click="handleImageUpload"
          />
        </div>
        
        <div class="input-main">
          <el-input
            v-model="inputMessage"
            type="textarea"
            :rows="1"
            :autosize="{ minRows: 1, maxRows: 6 }"
            placeholder="输入您的问题..."
            @keydown.enter.exact.prevent="handleSendMessage"
            @keydown.enter.shift.exact="handleNewLine"
            :disabled="isStreaming || sending"
            ref="inputRef"
          />
          
          <!-- 文件预览 -->
          <div v-if="uploadedFiles.length" class="file-preview">
            <div 
              v-for="file in uploadedFiles" 
              :key="file.id"
              class="preview-item"
            >
              <img v-if="file.type === 'image'" :src="file.preview" alt="预览" />
              <div v-else class="file-icon">
                <el-icon><Document /></el-icon>
                <span>{{ file.name }}</span>
              </div>
              <el-button 
                :icon="Close" 
                size="small" 
                circle 
                @click="removeFile(file.id)"
              />
            </div>
          </div>
        </div>
        
        <div class="input-send">
          <el-button 
            type="primary" 
            :icon="isStreaming ? Stop : Send"
            :loading="sending"
            :disabled="!canSend"
            @click="isStreaming ? stopGeneration() : handleSendMessage()"
          >
            {{ isStreaming ? '停止' : '发送' }}
          </el-button>
        </div>
      </div>
      
      <!-- 输入提示 -->
      <div class="input-footer">
        <div class="input-tips">
          <span>按 Enter 发送，Shift + Enter 换行</span>
          <span class="divider">•</span>
          <span>支持 Markdown 格式</span>
        </div>
        
        <div class="character-count">
          {{ inputMessage.length }}/{{ maxInputLength }}
        </div>
      </div>
    </div>

    <!-- 对话信息侧边栏 -->
    <el-drawer
      v-model="infoDrawerVisible"
      title="对话信息"
      direction="rtl"
      size="400px"
    >
      <div v-if="currentConversation" class="conversation-info">
        <div class="info-section">
          <h4>基本信息</h4>
          <div class="info-item">
            <label>对话标题：</label>
            <span>{{ currentConversation.title }}</span>
          </div>
          <div class="info-item">
            <label>智能体：</label>
            <span>{{ currentConversation.agentName }}</span>
          </div>
          <div class="info-item">
            <label>创建时间：</label>
            <span>{{ formatTime(currentConversation.createdAt) }}</span>
          </div>
          <div class="info-item">
            <label>消息数量：</label>
            <span>{{ currentConversation.messageCount }} 条</span>
          </div>
        </div>
        
        <div class="info-section">
          <h4>标签</h4>
          <div class="tags-container">
            <el-tag
              v-for="tag in currentConversation.tags"
              :key="tag"
              size="small"
            >
              {{ tag }}
            </el-tag>
            <el-tag v-if="!currentConversation.tags.length" type="info" size="small">
              暂无标签
            </el-tag>
          </div>
        </div>
        
        <div class="info-section">
          <h4>统计信息</h4>
          <div class="stats-grid">
            <div class="stat-item">
              <div class="stat-value">{{ conversationStats.tokenCount || 0 }}</div>
              <div class="stat-label">总Token数</div>
            </div>
            <div class="stat-item">
              <div class="stat-value">¥{{ (conversationStats.cost || 0).toFixed(4) }}</div>
              <div class="stat-label">总成本</div>
            </div>
            <div class="stat-item">
              <div class="stat-value">{{ conversationStats.duration || 0 }}分钟</div>
              <div class="stat-label">对话时长</div>
            </div>
          </div>
        </div>
      </div>
    </el-drawer>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted, onUnmounted, nextTick, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { 
  ArrowLeft, 
  Setting, 
  InfoFilled, 
  Delete, 
  Download, 
  Star, 
  StarFilled,
  Send,
  Stop,
  Paperclip,
  Picture,
  Close,
  Copy,
  Refresh,
  ThumbsUp,
  Document,
  Loading,
  CircleCloseFilled
} from '@element-plus/icons-vue'
import { useUserStore } from '@/stores/modules/user'
import * as conversationApi from '@/api/conversation'
import * as agentApi from '@/api/agent'
import { uploadFile } from '@/api/upload'
import type { 
  Message, 
  Conversation, 
  Agent, 
  SendMessageRequest,
  MessageRole 
} from '@/types/api'

// 图标导入修复
const ThumbsUpOutline = ThumbsUp

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

// 基础数据
const agentId = computed(() => route.params.agentId as string)
const conversationId = computed(() => route.query.conversationId as string)

// 响应式数据
const loading = ref(true)
const messages = ref<Message[]>([])
const currentAgent = ref<Agent>()
const currentConversation = ref<Conversation>()
const conversationStats = ref({
  tokenCount: 0,
  cost: 0,
  duration: 0
})

// 聊天状态
const inputMessage = ref('')
const sending = ref(false)
const isStreaming = ref(false)
const isTyping = ref(false)
const streamingMessageId = ref('')
const streamingContent = ref('')

// UI状态
const infoDrawerVisible = ref(false)
const messagesContainer = ref<HTMLElement>()
const inputRef = ref()

// 文件上传
const uploadedFiles = ref<Array<{
  id: string
  name: string
  type: 'image' | 'file'
  url: string
  preview?: string
}>>([])

// 配置
const maxInputLength = 2000
const suggestions = ref([
  '你好，请介绍一下自己',
  '你能帮我做什么？',
  '我有个问题想咨询',
  '请给我一些建议'
])

// 计算属性
const canSend = computed(() => {
  return (inputMessage.value.trim() || uploadedFiles.value.length > 0) && !sending.value
})

// 格式化消息时间
const formatMessageTime = (timeStr: string): string => {
  const time = new Date(timeStr)
  const now = new Date()
  const diff = now.getTime() - time.getTime()
  
  const minute = 60 * 1000
  const hour = 60 * minute
  const day = 24 * hour
  
  if (diff < minute) {
    return '刚刚'
  } else if (diff < hour) {
    return `${Math.floor(diff / minute)}分钟前`
  } else if (diff < day) {
    return time.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
  } else {
    return time.toLocaleDateString()
  }
}

// 格式化时间
const formatTime = (timeStr: string): string => {
  if (!timeStr) return '-'
  return new Date(timeStr).toLocaleString()
}

// 格式化消息内容（支持Markdown）
const formatMessageContent = (content: string): string => {
  // 简单的Markdown解析
  return content
    .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
    .replace(/\*(.*?)\*/g, '<em>$1</em>')
    .replace(/`(.*?)`/g, '<code>$1</code>')
    .replace(/\n/g, '<br>')
}

// 加载智能体信息
const loadAgentInfo = async () => {
  try {
    const response = await agentApi.getAgent(agentId.value)
    currentAgent.value = response.data
  } catch (error) {
    console.error('加载智能体信息失败:', error)
    ElMessage.error('加载智能体信息失败')
  }
}

// 加载对话信息
const loadConversationInfo = async () => {
  if (!conversationId.value) return
  
  try {
    const response = await conversationApi.getConversation(conversationId.value)
    currentConversation.value = response.data
    
    // 加载统计信息
    const statsResponse = await conversationApi.getConversationStats(conversationId.value)
    conversationStats.value = statsResponse.data
  } catch (error) {
    console.error('加载对话信息失败:', error)
  }
}

// 加载消息列表
const loadMessages = async () => {
  if (!conversationId.value) return
  
  try {
    const response = await conversationApi.getConversationMessages(conversationId.value, {
      current: 1,
      size: 100
    })
    messages.value = response.data.records.reverse() // 按时间正序显示
    
    // 滚动到底部
    nextTick(() => {
      scrollToBottom()
    })
  } catch (error) {
    console.error('加载消息失败:', error)
    ElMessage.error('加载消息失败')
  }
}

// 发送消息
const handleSendMessage = async () => {
  if (!canSend.value) return
  
  const content = inputMessage.value.trim()
  const files = [...uploadedFiles.value]
  
  if (!content && !files.length) return
  
  try {
    sending.value = true
    
    // 创建发送请求
    const sendRequest: SendMessageRequest = {
      conversationId: conversationId.value,
      agentId: agentId.value,
      content: content,
      type: files.length > 0 ? (files[0].type === 'image' ? 'IMAGE' : 'FILE') : 'TEXT',
      attachments: files.map(f => ({
        id: f.id,
        name: f.name,
        type: f.type,
        size: 0,
        url: f.url
      }))
    }
    
    // 添加用户消息到界面
    const userMessage: Message = {
      id: `temp_${Date.now()}`,
      conversationId: conversationId.value || '',
      type: sendRequest.type!,
      role: 'USER' as MessageRole,
      content: content || files[0]?.url || '',
      parentId: undefined,
      children: [],
      status: 'SENDING',
      error: undefined,
      isRead: true,
      reactions: [],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    }
    
    messages.value.push(userMessage)
    
    // 清空输入
    inputMessage.value = ''
    uploadedFiles.value = []
    
    // 滚动到底部
    nextTick(() => {
      scrollToBottom()
    })
    
    // 发送消息 (使用流式响应)
    isStreaming.value = true
    isTyping.value = true
    streamingContent.value = ''
    
    // 创建临时AI消息
    const aiMessage: Message = {
      id: `ai_${Date.now()}`,
      conversationId: conversationId.value || '',
      type: 'TEXT',
      role: 'ASSISTANT' as MessageRole,
      content: '',
      parentId: userMessage.id,
      children: [],
      status: 'SENDING',
      error: undefined,
      isRead: true,
      reactions: [],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    }
    
    messages.value.push(aiMessage)
    streamingMessageId.value = aiMessage.id
    
    // 启动流式响应
    conversationApi.sendMessageStream(
      sendRequest,
      (chunk: string) => {
        streamingContent.value += chunk
        nextTick(() => {
          scrollToBottom()
        })
      },
      (completeMessage: Message) => {
        // 替换临时消息
        const index = messages.value.findIndex(m => m.id === aiMessage.id)
        if (index > -1) {
          messages.value[index] = completeMessage
        }
        
        isStreaming.value = false
        isTyping.value = false
        streamingMessageId.value = ''
        streamingContent.value = ''
        
        // 更新用户消息状态
        const userIndex = messages.value.findIndex(m => m.id === userMessage.id)
        if (userIndex > -1) {
          messages.value[userIndex].status = 'SENT'
        }
        
        nextTick(() => {
          scrollToBottom()
        })
      },
      (error: any) => {
        console.error('发送消息失败:', error)
        ElMessage.error('发送消息失败')
        
        // 标记消息失败
        const index = messages.value.findIndex(m => m.id === aiMessage.id)
        if (index > -1) {
          messages.value[index].status = 'FAILED'
          messages.value[index].error = error.message || '发送失败'
        }
        
        const userIndex = messages.value.findIndex(m => m.id === userMessage.id)
        if (userIndex > -1) {
          messages.value[userIndex].status = 'FAILED'
        }
        
        isStreaming.value = false
        isTyping.value = false
        streamingMessageId.value = ''
        streamingContent.value = ''
      }
    )
    
  } catch (error) {
    console.error('发送消息失败:', error)
    ElMessage.error('发送消息失败')
  } finally {
    sending.value = false
  }
}

// 处理换行
const handleNewLine = () => {
  inputMessage.value += '\n'
}

// 停止生成
const stopGeneration = () => {
  isStreaming.value = false
  isTyping.value = false
  streamingMessageId.value = ''
  streamingContent.value = ''
  // TODO: 实际停止API调用
}

// 文件上传处理
const handleFileUpload = async (file: File) => {
  try {
    const response = await uploadFile(file)
    
    const fileData = {
      id: `file_${Date.now()}`,
      name: file.name,
      type: file.type.startsWith('image/') ? 'image' as const : 'file' as const,
      url: response.data.url,
      preview: file.type.startsWith('image/') ? URL.createObjectURL(file) : undefined
    }
    
    uploadedFiles.value.push(fileData)
    ElMessage.success('文件上传成功')
  } catch (error) {
    console.error('文件上传失败:', error)
    ElMessage.error('文件上传失败')
  }
  
  return false // 阻止默认上传
}

// 图片上传
const handleImageUpload = () => {
  const input = document.createElement('input')
  input.type = 'file'
  input.accept = 'image/*'
  input.onchange = (e) => {
    const file = (e.target as HTMLInputElement).files?.[0]
    if (file) {
      handleFileUpload(file)
    }
  }
  input.click()
}

// 移除文件
const removeFile = (fileId: string) => {
  uploadedFiles.value = uploadedFiles.value.filter(f => f.id !== fileId)
}

// 滚动到底部
const scrollToBottom = () => {
  if (messagesContainer.value) {
    messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight
  }
}

// 复制消息
const copyMessage = async (content: string) => {
  try {
    await navigator.clipboard.writeText(content)
    ElMessage.success('已复制到剪贴板')
  } catch (error) {
    console.error('复制失败:', error)
    ElMessage.error('复制失败')
  }
}

// 重新生成消息
const regenerateMessage = async (message: Message) => {
  try {
    const response = await conversationApi.regenerateMessage(message.id)
    
    // 更新消息
    const index = messages.value.findIndex(m => m.id === message.id)
    if (index > -1) {
      messages.value[index] = response.data
    }
    
    ElMessage.success('消息已重新生成')
  } catch (error) {
    console.error('重新生成失败:', error)
    ElMessage.error('重新生成失败')
  }
}

// 删除消息
const deleteMessage = async (message: Message) => {
  try {
    await ElMessageBox.confirm('确认删除这条消息吗？', '删除确认', {
      confirmButtonText: '确认',
      cancelButtonText: '取消',
      type: 'warning'
    })
    
    await conversationApi.deleteMessage(message.id)
    
    // 从列表中移除
    messages.value = messages.value.filter(m => m.id !== message.id)
    
    ElMessage.success('消息已删除')
  } catch (error) {
    // 用户取消或删除失败
    if (error && typeof error === 'object' && 'message' in error) {
      console.error('删除消息失败:', error)
      ElMessage.error('删除失败')
    }
  }
}

// 切换消息反应
const toggleReaction = async (message: Message, type: 'LIKE' | 'DISLIKE') => {
  try {
    await conversationApi.toggleMessageReaction(message.id, type)
    
    // 更新本地状态
    if (!message.reactions) {
      message.reactions = []
    }
    
    const existingIndex = message.reactions.findIndex(r => r.type === type)
    if (existingIndex > -1) {
      message.reactions.splice(existingIndex, 1)
    } else {
      message.reactions.push({
        id: `reaction_${Date.now()}`,
        messageId: message.id,
        userId: userStore.userInfo.id,
        type: type,
        createdAt: new Date().toISOString()
      })
    }
  } catch (error) {
    console.error('切换反应失败:', error)
    ElMessage.error('操作失败')
  }
}

// 下载文件
const downloadFile = (url: string) => {
  const link = document.createElement('a')
  link.href = url
  link.download = ''
  link.click()
}

// 建议点击
const handleSuggestionClick = (suggestion: string) => {
  inputMessage.value = suggestion
  handleSendMessage()
}

// 返回
const handleBack = () => {
  router.push('/conversation')
}

// 头部操作
const handleHeaderAction = async (command: string) => {
  switch (command) {
    case 'conversation-info':
      infoDrawerVisible.value = true
      break
    case 'clear-history':
      await handleClearHistory()
      break
    case 'export':
      await handleExport()
      break
    case 'star':
    case 'unstar':
      await handleToggleStar(command === 'star')
      break
  }
}

// 清空历史
const handleClearHistory = async () => {
  if (!conversationId.value) return
  
  try {
    await ElMessageBox.confirm('确认清空所有聊天记录吗？此操作不可恢复。', '清空确认', {
      confirmButtonText: '确认',
      cancelButtonText: '取消',
      type: 'warning'
    })
    
    await conversationApi.clearConversationMessages(conversationId.value)
    messages.value = []
    ElMessage.success('聊天记录已清空')
  } catch (error) {
    if (error && typeof error === 'object' && 'message' in error) {
      console.error('清空历史失败:', error)
      ElMessage.error('清空失败')
    }
  }
}

// 导出对话
const handleExport = async () => {
  if (!conversationId.value) return
  
  try {
    await conversationApi.exportConversation(conversationId.value, 'json')
  } catch (error) {
    console.error('导出失败:', error)
    ElMessage.error('导出失败')
  }
}

// 切换收藏
const handleToggleStar = async (isStarred: boolean) => {
  if (!conversationId.value || !currentConversation.value) return
  
  try {
    const response = await conversationApi.toggleConversationStar(conversationId.value, isStarred)
    currentConversation.value = response.data
    ElMessage.success(isStarred ? '已收藏' : '已取消收藏')
  } catch (error) {
    console.error('切换收藏失败:', error)
    ElMessage.error('操作失败')
  }
}

// 键盘快捷键
const handleKeydown = (e: KeyboardEvent) => {
  // Ctrl/Cmd + K 聚焦输入框
  if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
    e.preventDefault()
    inputRef.value?.focus()
  }
}

// 监听路由变化
watch([agentId, conversationId], () => {
  if (agentId.value) {
    loadAgentInfo()
  }
  if (conversationId.value) {
    loadConversationInfo()
    loadMessages()
  }
}, { immediate: true })

// 生命周期
onMounted(() => {
  document.addEventListener('keydown', handleKeydown)
  loading.value = false
})

onUnmounted(() => {
  document.removeEventListener('keydown', handleKeydown)
})
</script>

<style scoped lang="scss">
.chat-interface {
  height: 100vh;
  display: flex;
  flex-direction: column;
  background: #f5f5f5;

  .chat-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16px 20px;
    background: white;
    border-bottom: 1px solid #e5e5e5;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);

    .header-left {
      display: flex;
      align-items: center;
      gap: 12px;

      .agent-info {
        display: flex;
        align-items: center;
        gap: 12px;

        .agent-avatar {
          width: 40px;
          height: 40px;
          border-radius: 50%;
          overflow: hidden;

          img {
            width: 100%;
            height: 100%;
            object-fit: cover;
          }

          .default-avatar {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #409eff;
            color: white;
            font-weight: 600;
          }
        }

        .agent-details {
          h3 {
            margin: 0 0 4px 0;
            font-size: 16px;
            font-weight: 600;
            color: #1f2329;
          }

          p {
            margin: 0;
            font-size: 12px;
            color: #86909c;
          }
        }
      }
    }
  }

  .chat-messages {
    flex: 1;
    overflow-y: auto;
    padding: 20px;

    .messages-wrapper {
      max-width: 800px;
      margin: 0 auto;
    }

    .welcome-message {
      display: flex;
      gap: 12px;
      margin-bottom: 40px;

      .welcome-avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        overflow: hidden;
        flex-shrink: 0;

        img {
          width: 100%;
          height: 100%;
          object-fit: cover;
        }

        .default-avatar {
          width: 100%;
          height: 100%;
          display: flex;
          align-items: center;
          justify-content: center;
          background: #409eff;
          color: white;
          font-weight: 600;
        }
      }

      .welcome-content {
        flex: 1;

        h3 {
          margin: 0 0 8px 0;
          font-size: 18px;
          font-weight: 600;
          color: #1f2329;
        }

        p {
          margin: 0 0 20px 0;
          color: #86909c;
          line-height: 1.5;
        }

        .quick-suggestions {
          .suggestions-title {
            margin-bottom: 12px;
            font-size: 14px;
            color: #1f2329;
            font-weight: 500;
          }

          .suggestions-list {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
          }
        }
      }
    }

    .message-item {
      display: flex;
      gap: 12px;
      margin-bottom: 24px;

      &.is-user {
        flex-direction: row-reverse;

        .message-content {
          background: #409eff;
          color: white;

          .message-text {
            color: white;
          }
        }
      }

      .message-avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        overflow: hidden;
        flex-shrink: 0;

        img {
          width: 100%;
          height: 100%;
          object-fit: cover;
        }

        .default-avatar {
          width: 100%;
          height: 100%;
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 12px;
          font-weight: 600;

          &.user-avatar {
            background: #67c23a;
            color: white;
          }

          &.agent-avatar {
            background: #409eff;
            color: white;
          }
        }
      }

      .message-content {
        flex: 1;
        max-width: 70%;
        background: white;
        border-radius: 12px;
        padding: 12px 16px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);

        .message-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 8px;

          .message-sender {
            font-size: 12px;
            font-weight: 500;
            color: #1f2329;
          }

          .message-time {
            font-size: 12px;
            color: #86909c;
          }
        }

        .message-body {
          .message-text {
            line-height: 1.6;
            color: #1f2329;

            .streaming-text {
              .typing-cursor {
                animation: blink 1s infinite;
              }
            }
          }

          .message-image {
            margin: 8px 0;
          }

          .message-file {
            .file-info {
              display: flex;
              align-items: center;
              gap: 8px;
              padding: 8px;
              background: #f5f5f5;
              border-radius: 6px;
            }
          }
        }

        .message-actions {
          margin-top: 8px;
          opacity: 0;
          transition: opacity 0.2s;
        }

        .message-status {
          margin-top: 8px;
          display: flex;
          align-items: center;
          gap: 8px;
          font-size: 12px;
          color: #86909c;

          .failed {
            color: #f56c6c;
          }

          .token-count,
          .cost {
            color: #67c23a;
          }
        }

        &:hover .message-actions {
          opacity: 1;
        }
      }
    }

    .typing-indicator {
      display: flex;
      gap: 12px;
      align-items: center;

      .typing-avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        overflow: hidden;
        flex-shrink: 0;

        img {
          width: 100%;
          height: 100%;
          object-fit: cover;
        }

        .default-avatar {
          width: 100%;
          height: 100%;
          display: flex;
          align-items: center;
          justify-content: center;
          background: #409eff;
          color: white;
          font-size: 12px;
          font-weight: 600;
        }
      }

      .typing-content {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 12px 16px;
        background: white;
        border-radius: 12px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);

        .typing-dots {
          display: flex;
          gap: 4px;

          span {
            width: 6px;
            height: 6px;
            background: #86909c;
            border-radius: 50%;
            animation: typing 1.5s infinite ease-in-out;

            &:nth-child(2) {
              animation-delay: 0.2s;
            }

            &:nth-child(3) {
              animation-delay: 0.4s;
            }
          }
        }

        .typing-text {
          font-size: 12px;
          color: #86909c;
        }
      }
    }
  }

  .chat-input {
    background: white;
    border-top: 1px solid #e5e5e5;
    padding: 16px 20px;

    .input-container {
      max-width: 800px;
      margin: 0 auto;
      display: flex;
      gap: 12px;
      align-items: flex-end;

      .input-actions {
        display: flex;
        gap: 8px;
        align-items: center;
      }

      .input-main {
        flex: 1;
        position: relative;

        .file-preview {
          display: flex;
          gap: 8px;
          margin-bottom: 8px;
          flex-wrap: wrap;

          .preview-item {
            position: relative;
            padding: 8px;
            background: #f5f5f5;
            border-radius: 6px;
            display: flex;
            align-items: center;
            gap: 8px;

            img {
              width: 40px;
              height: 40px;
              object-fit: cover;
              border-radius: 4px;
            }

            .file-icon {
              display: flex;
              align-items: center;
              gap: 4px;
              font-size: 12px;
            }

            .el-button {
              position: absolute;
              top: -6px;
              right: -6px;
            }
          }
        }
      }
    }

    .input-footer {
      max-width: 800px;
      margin: 8px auto 0;
      display: flex;
      justify-content: space-between;
      align-items: center;

      .input-tips {
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 12px;
        color: #86909c;

        .divider {
          color: #c9cdd4;
        }
      }

      .character-count {
        font-size: 12px;
        color: #86909c;
      }
    }
  }
}

// 动画
@keyframes blink {
  0%, 50% { opacity: 1; }
  51%, 100% { opacity: 0; }
}

@keyframes typing {
  0%, 60%, 100% {
    transform: translateY(0);
  }
  30% {
    transform: translateY(-10px);
  }
}

// 对话信息抽屉样式
.conversation-info {
  .info-section {
    margin-bottom: 24px;

    h4 {
      margin: 0 0 12px 0;
      font-size: 14px;
      font-weight: 600;
      color: #1f2329;
    }

    .info-item {
      display: flex;
      margin-bottom: 8px;

      label {
        min-width: 80px;
        font-size: 12px;
        color: #86909c;
      }

      span {
        font-size: 12px;
        color: #1f2329;
      }
    }

    .tags-container {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
    }

    .stats-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 12px;

      .stat-item {
        text-align: center;
        padding: 12px;
        background: #f5f5f5;
        border-radius: 6px;

        .stat-value {
          font-size: 18px;
          font-weight: 600;
          color: #1f2329;
          margin-bottom: 4px;
        }

        .stat-label {
          font-size: 12px;
          color: #86909c;
        }
      }
    }
  }
}
</style>