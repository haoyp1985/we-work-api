<template>
  <div class="chat-container">
    <!-- 左侧会话列表 -->
    <div class="conversation-sidebar">
      <div class="sidebar-header">
        <h3 class="sidebar-title">
          <el-icon><ChatLineRound /></el-icon>
          会话列表
        </h3>
        <el-button 
          type="primary" 
          size="small"
          @click="showNewChatDialog = true"
        >
          <el-icon><Plus /></el-icon>
          新建会话
        </el-button>
      </div>

      <!-- 会话搜索 -->
      <div class="conversation-search">
        <el-input
          v-model="conversationSearchText"
          placeholder="搜索会话..."
          size="small"
          clearable
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
      </div>

      <!-- 会话列表 -->
      <div class="conversation-list" v-loading="conversationLoading">
        <div
          v-for="conversation in filteredConversations"
          :key="conversation.id"
          class="conversation-item"
          :class="{ active: currentConversationId === conversation.id }"
          @click="selectConversation(conversation)"
        >
          <div class="conversation-info">
            <div class="conversation-title">
              {{ conversation.title || `与${conversation.agentName}的对话` }}
            </div>
            <div class="conversation-meta">
              <span class="last-message-time">
                {{ formatTime(conversation.updatedAt) }}
              </span>
              <el-tag 
                :type="getConversationStatusType(conversation.status)" 
                size="small"
              >
                {{ getConversationStatusText(conversation.status) }}
              </el-tag>
            </div>
          </div>
          
          <div class="conversation-actions">
            <el-dropdown @command="handleConversationAction" trigger="click">
              <el-button type="text" size="small">
                <el-icon><MoreFilled /></el-icon>
              </el-button>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item :command="`rename:${conversation.id}`">
                    <el-icon><Edit /></el-icon>
                    重命名
                  </el-dropdown-item>
                  <el-dropdown-item :command="`clear:${conversation.id}`">
                    <el-icon><Delete /></el-icon>
                    清空历史
                  </el-dropdown-item>
                  <el-dropdown-item :command="`end:${conversation.id}`">
                    <el-icon><CircleClose /></el-icon>
                    结束会话
                  </el-dropdown-item>
                  <el-dropdown-item :command="`delete:${conversation.id}`" divided>
                    <el-icon><Delete /></el-icon>
                    删除会话
                  </el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </div>
        </div>

        <!-- 空状态 -->
        <div v-if="!conversationLoading && filteredConversations.length === 0" class="empty-conversations">
          <el-icon><ChatLineRound /></el-icon>
          <p>暂无会话</p>
          <el-button type="primary" @click="showNewChatDialog = true">
            创建新会话
          </el-button>
        </div>
      </div>
    </div>

    <!-- 中间聊天区域 -->
    <div class="chat-main">
      <div v-if="!currentConversationId" class="chat-welcome">
        <div class="welcome-content">
          <el-icon><ChatLineRound /></el-icon>
          <h2>欢迎使用AI智能体对话</h2>
          <p>选择一个会话开始聊天，或创建新的会话</p>
          <el-button type="primary" @click="showNewChatDialog = true">
            <el-icon><Plus /></el-icon>
            开始新对话
          </el-button>
        </div>
      </div>

      <div v-else class="chat-content">
        <!-- 聊天头部 -->
        <div class="chat-header">
          <div class="chat-info">
            <h3 class="chat-title">
              {{ currentConversation?.title || `与${currentConversation?.agentName}的对话` }}
            </h3>
            <div class="chat-meta">
              <el-tag :type="getAgentStatusType(currentAgent?.status)" size="small">
                {{ currentAgent?.agentName }}
              </el-tag>
              <span class="separator">•</span>
              <span class="message-count">{{ messageCount }} 条消息</span>
            </div>
          </div>
          
          <div class="chat-actions">
            <el-button size="small" @click="clearCurrentConversation">
              <el-icon><Delete /></el-icon>
              清空历史
            </el-button>
            <el-button size="small" @click="exportConversation">
              <el-icon><Download /></el-icon>
              导出对话
            </el-button>
          </div>
        </div>

        <!-- 消息列表区域 -->
        <div class="messages-container" ref="messagesContainer">
          <div 
            v-for="message in messages" 
            :key="message.id"
            class="message-item"
            :class="{ 'user-message': message.messageType === MessageType.USER, 'assistant-message': message.messageType === MessageType.ASSISTANT }"
          >
            <div class="message-avatar">
              <el-avatar 
                :size="32" 
                :src="message.messageType === MessageType.USER ? userAvatar : agentAvatar"
              >
                <el-icon v-if="message.messageType === MessageType.USER"><User /></el-icon>
                <el-icon v-else><Robot /></el-icon>
              </el-avatar>
            </div>
            
            <div class="message-content">
              <div class="message-header">
                <span class="message-sender">
                  {{ message.messageType === MessageType.USER ? '我' : currentAgent?.agentName }}
                </span>
                <span class="message-time">
                  {{ formatTime(message.createdAt) }}
                </span>
              </div>
              
              <div class="message-body">
                <div v-if="message.messageType === MessageType.USER" class="user-text">
                  {{ message.content }}
                </div>
                <div v-else class="assistant-text">
                  <div v-if="message.status === MessageStatus.SENDING" class="typing-indicator">
                    <span></span>
                    <span></span>
                    <span></span>
                  </div>
                  <div v-else-if="message.status === MessageStatus.FAILED" class="error-message">
                    <el-icon><WarningFilled /></el-icon>
                    发送失败：{{ message.errorMessage }}
                    <el-button type="text" size="small" @click="regenerateMessage(message)">
                      重新生成
                    </el-button>
                  </div>
                  <div v-else class="assistant-content">
                    {{ message.content }}
                  </div>
                </div>
              </div>
              
              <!-- 消息操作 -->
              <div v-if="message.status === MessageStatus.SUCCESS" class="message-actions">
                <el-button type="text" size="small" @click="copyMessage(message)">
                  <el-icon><CopyDocument /></el-icon>
                  复制
                </el-button>
                <el-button 
                  v-if="message.messageType === MessageType.ASSISTANT" 
                  type="text" 
                  size="small" 
                  @click="regenerateMessage(message)"
                >
                  <el-icon><Refresh /></el-icon>
                  重新生成
                </el-button>
              </div>
            </div>
          </div>

          <!-- 加载更多 -->
          <div v-if="hasMoreMessages" class="load-more">
            <el-button @click="loadMoreMessages" :loading="loadingMore">
              加载更多消息
            </el-button>
          </div>
        </div>

        <!-- 消息输入区域 -->
        <div class="input-area">
          <div class="input-container">
            <el-input
              v-model="inputMessage"
              type="textarea"
              :rows="3"
              placeholder="输入您的问题..."
              :disabled="sending"
              @keydown.enter.ctrl="sendMessage"
              resize="none"
            />
            
            <div class="input-actions">
              <div class="input-tools">
                <el-button type="text" size="small">
                  <el-icon><Paperclip /></el-icon>
                  附件
                </el-button>
                <el-button type="text" size="small">
                  <el-icon><Picture /></el-icon>
                  图片
                </el-button>
              </div>
              
              <div class="send-area">
                <span class="shortcut-hint">Ctrl + Enter 发送</span>
                <el-button 
                  type="primary" 
                  :disabled="!inputMessage.trim() || sending"
                  :loading="sending"
                  @click="sendMessage"
                >
                  <el-icon><Promotion /></el-icon>
                  发送
                </el-button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 新建会话对话框 -->
    <el-dialog
      v-model="showNewChatDialog"
      title="创建新会话"
      width="500px"
      :close-on-click-modal="false"
    >
      <el-form :model="newChatForm" label-width="80px">
        <el-form-item label="智能体" required>
          <el-select
            v-model="newChatForm.agentId"
            placeholder="请选择智能体"
            style="width: 100%"
            filterable
          >
            <el-option
              v-for="agent in availableAgents"
              :key="agent.id"
              :label="agent.agentName"
              :value="agent.id"
            >
              <div class="agent-option">
                <span class="agent-name">{{ agent.agentName }}</span>
                <el-tag :type="getAgentStatusType(agent.status)" size="small">
                  {{ getAgentStatusText(agent.status) }}
                </el-tag>
              </div>
            </el-option>
          </el-select>
        </el-form-item>
        
        <el-form-item label="会话标题">
          <el-input
            v-model="newChatForm.title"
            placeholder="可选，留空将自动生成"
            maxlength="100"
            show-word-limit
          />
        </el-form-item>
      </el-form>
      
      <template #footer>
        <el-button @click="showNewChatDialog = false">取消</el-button>
        <el-button 
          type="primary" 
          :disabled="!newChatForm.agentId"
          :loading="creating"
          @click="createNewConversation"
        >
          创建
        </el-button>
      </template>
    </el-dialog>

    <!-- 重命名会话对话框 -->
    <el-dialog
      v-model="showRenameDialog"
      title="重命名会话"
      width="400px"
      :close-on-click-modal="false"
    >
      <el-input
        v-model="renameTitle"
        placeholder="请输入新的会话标题"
        maxlength="100"
        show-word-limit
      />
      
      <template #footer>
        <el-button @click="showRenameDialog = false">取消</el-button>
        <el-button 
          type="primary" 
          :loading="renaming"
          @click="confirmRename"
        >
          确定
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted, nextTick, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  ChatLineRound,
  Plus,
  Search,
  MoreFilled,
  Edit,
  Delete,
  CircleClose,
  User,
  Robot,
  WarningFilled,
  CopyDocument,
  Refresh,
  Paperclip,
  Picture,
  Promotion,
  Download
} from '@element-plus/icons-vue'
import { agentApi } from '@/api/agent'
import type {
  ConversationDTO,
  MessageDTO,
  AgentDTO,
  ChatRequest,
  ChatResponse
} from '@/types/agent'
import {
  ConversationStatus,
  MessageType,
  MessageStatus,
  AgentStatus
} from '@/types/agent'

// =============== 响应式数据 ===============
const conversationLoading = ref(false)
const conversationSearchText = ref('')
const conversations = ref<ConversationDTO[]>([])
const currentConversationId = ref<string>('')
const currentConversation = ref<ConversationDTO | null>(null)
const currentAgent = ref<AgentDTO | null>(null)

const messages = ref<MessageDTO[]>([])
const messageCount = ref(0)
const hasMoreMessages = ref(false)
const loadingMore = ref(false)
const messagesContainer = ref<HTMLElement>()

const inputMessage = ref('')
const sending = ref(false)

// 新建会话相关
const showNewChatDialog = ref(false)
const creating = ref(false)
const newChatForm = reactive({
  agentId: '',
  title: ''
})
const availableAgents = ref<AgentDTO[]>([])

// 重命名会话相关
const showRenameDialog = ref(false)
const renaming = ref(false)
const renameTitle = ref('')
const renamingConversationId = ref('')

// 用户信息
const userAvatar = ref('')
const agentAvatar = ref('')

// =============== 计算属性 ===============
const filteredConversations = computed(() => {
  if (!conversationSearchText.value) {
    return conversations.value
  }
  
  const searchText = conversationSearchText.value.toLowerCase()
  return conversations.value.filter(conversation => {
    return conversation.title?.toLowerCase().includes(searchText) ||
           conversation.agentName?.toLowerCase().includes(searchText)
  })
})

// =============== 方法定义 ===============

// 获取用户会话列表
const loadConversations = async () => {
  conversationLoading.value = true
  try {
    const userId = 'current-user-id' // TODO: 获取当前用户ID
    const response = await agentApi.getUserConversations(userId)
    if (response.code === 200) {
      conversations.value = response.data.records
    }
  } catch (error) {
    console.error('加载会话列表失败:', error)
    ElMessage.error('加载会话列表失败')
  } finally {
    conversationLoading.value = false
  }
}

// 获取可用的智能体列表
const loadAvailableAgents = async () => {
  try {
    const response = await agentApi.getAgentList({
      status: AgentStatus.PUBLISHED,
      pageNum: 1,
      pageSize: 100
    })
    if (response.code === 200) {
      availableAgents.value = response.data.records
    }
  } catch (error) {
    console.error('加载智能体列表失败:', error)
  }
}

// 选择会话
const selectConversation = async (conversation: ConversationDTO) => {
  currentConversationId.value = conversation.id
  currentConversation.value = conversation
  
  // 获取智能体信息
  try {
    const agentResponse = await agentApi.getAgent(conversation.agentId)
    if (agentResponse.code === 200) {
      currentAgent.value = agentResponse.data
    }
  } catch (error) {
    console.error('获取智能体信息失败:', error)
  }
  
  // 加载会话消息
  await loadConversationMessages(conversation.id)
}

// 加载会话消息
const loadConversationMessages = async (conversationId: string, pageNum: number = 1) => {
  try {
    const response = await agentApi.getConversationMessages(conversationId, pageNum, 20)
    if (response.code === 200) {
      if (pageNum === 1) {
        messages.value = response.data.records.reverse() // 最新消息在下方
        messageCount.value = response.data.total
      } else {
        messages.value = [...response.data.records.reverse(), ...messages.value]
      }
      hasMoreMessages.value = response.data.pages > pageNum
      
      // 滚动到底部（仅首次加载）
      if (pageNum === 1) {
        await nextTick()
        scrollToBottom()
      }
    }
  } catch (error) {
    console.error('加载消息失败:', error)
    ElMessage.error('加载消息失败')
  }
}

// 发送消息
const sendMessage = async () => {
  if (!inputMessage.value.trim() || !currentConversationId.value || sending.value) {
    return
  }
  
  const messageContent = inputMessage.value.trim()
  inputMessage.value = ''
  sending.value = true
  
  // 添加用户消息到界面
  const userMessage: MessageDTO = {
    id: `temp-${Date.now()}`,
    conversationId: currentConversationId.value,
    messageType: MessageType.USER,
    content: messageContent,
    status: MessageStatus.SUCCESS,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  }
  messages.value.push(userMessage)
  
  // 添加助手消息（显示发送中状态）
  const assistantMessage: MessageDTO = {
    id: `temp-assistant-${Date.now()}`,
    conversationId: currentConversationId.value,
    messageType: MessageType.ASSISTANT,
    content: '',
    status: MessageStatus.SENDING,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  }
  messages.value.push(assistantMessage)
  
  await nextTick()
  scrollToBottom()
  
  try {
    const chatRequest: ChatRequest = {
      agentId: currentAgent.value!.id,
      conversationId: currentConversationId.value,
      message: messageContent,
      stream: false
    }
    
    const response = await agentApi.sendMessageToConversation(currentConversationId.value, chatRequest)
    
    if (response.code === 200) {
      const chatResponse: ChatResponse = response.data
      
      // 更新助手消息
      const index = messages.value.findIndex(m => m.id === assistantMessage.id)
      if (index !== -1) {
        messages.value[index] = {
          ...assistantMessage,
          id: chatResponse.messageId,
          content: chatResponse.content,
          status: MessageStatus.SUCCESS
        }
      }
      
      messageCount.value += 2 // 用户消息 + 助手消息
    } else {
      // 更新助手消息为失败状态
      const index = messages.value.findIndex(m => m.id === assistantMessage.id)
      if (index !== -1) {
        messages.value[index] = {
          ...assistantMessage,
          status: MessageStatus.FAILED,
          errorMessage: response.message || '发送失败'
        }
      }
    }
  } catch (error) {
    console.error('发送消息失败:', error)
    
    // 更新助手消息为失败状态
    const index = messages.value.findIndex(m => m.id === assistantMessage.id)
    if (index !== -1) {
      messages.value[index] = {
        ...assistantMessage,
        status: MessageStatus.FAILED,
        errorMessage: '网络错误，请重试'
      }
    }
  } finally {
    sending.value = false
    await nextTick()
    scrollToBottom()
  }
}

// 重新生成消息
const regenerateMessage = async (message: MessageDTO) => {
  if (!currentConversationId.value || !currentAgent.value) {
    return
  }
  
  try {
    // 找到对应的用户消息
    const messageIndex = messages.value.findIndex(m => m.id === message.id)
    const userMessageIndex = messageIndex - 1
    
    if (userMessageIndex >= 0) {
      const userMessage = messages.value[userMessageIndex]
      
      // 更新消息状态为发送中
      messages.value[messageIndex] = {
        ...message,
        status: MessageStatus.SENDING,
        content: ''
      }
      
      const chatRequest: ChatRequest = {
        agentId: currentAgent.value.id,
        conversationId: currentConversationId.value,
        message: userMessage.content,
        stream: false
      }
      
      const response = await agentApi.regenerateResponse(chatRequest)
      
      if (response.code === 200) {
        const chatResponse: ChatResponse = response.data
        
        messages.value[messageIndex] = {
          ...message,
          content: chatResponse.content,
          status: MessageStatus.SUCCESS
        }
      } else {
        messages.value[messageIndex] = {
          ...message,
          status: MessageStatus.FAILED,
          errorMessage: response.message || '重新生成失败'
        }
      }
    }
  } catch (error) {
    console.error('重新生成失败:', error)
    ElMessage.error('重新生成失败')
  }
}

// 复制消息
const copyMessage = async (message: MessageDTO) => {
  try {
    await navigator.clipboard.writeText(message.content)
    ElMessage.success('已复制到剪贴板')
  } catch (error) {
    console.error('复制失败:', error)
    ElMessage.error('复制失败')
  }
}

// 滚动到底部
const scrollToBottom = () => {
  if (messagesContainer.value) {
    messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight
  }
}

// 加载更多消息
const loadMoreMessages = async () => {
  if (!hasMoreMessages.value || loadingMore.value || !currentConversationId.value) {
    return
  }
  
  loadingMore.value = true
  const currentPage = Math.ceil(messages.value.length / 20) + 1
  
  try {
    await loadConversationMessages(currentConversationId.value, currentPage)
  } finally {
    loadingMore.value = false
  }
}

// 创建新会话
const createNewConversation = async () => {
  if (!newChatForm.agentId) {
    return
  }
  
  creating.value = true
  try {
    const response = await agentApi.createConversation(newChatForm.agentId, newChatForm.title)
    if (response.code === 200) {
      const newConversation = response.data
      conversations.value.unshift(newConversation)
      
      // 选择新创建的会话
      await selectConversation(newConversation)
      
      // 重置表单
      newChatForm.agentId = ''
      newChatForm.title = ''
      showNewChatDialog.value = false
      
      ElMessage.success('会话创建成功')
    }
  } catch (error) {
    console.error('创建会话失败:', error)
    ElMessage.error('创建会话失败')
  } finally {
    creating.value = false
  }
}

// 会话操作
const handleConversationAction = async (command: string) => {
  const [action, conversationId] = command.split(':')
  
  switch (action) {
    case 'rename':
      const conversation = conversations.value.find(c => c.id === conversationId)
      if (conversation) {
        renameTitle.value = conversation.title || ''
        renamingConversationId.value = conversationId
        showRenameDialog.value = true
      }
      break
      
    case 'clear':
      try {
        await ElMessageBox.confirm('确定要清空该会话的所有消息吗？', '确认清空', {
          type: 'warning'
        })
        
        await agentApi.clearConversationHistory(conversationId)
        
        if (conversationId === currentConversationId.value) {
          messages.value = []
          messageCount.value = 0
        }
        
        ElMessage.success('会话历史已清空')
      } catch (error) {
        if (error !== 'cancel') {
          console.error('清空会话失败:', error)
          ElMessage.error('清空会话失败')
        }
      }
      break
      
    case 'end':
      try {
        await agentApi.endConversation(conversationId)
        
        // 更新会话状态
        const index = conversations.value.findIndex(c => c.id === conversationId)
        if (index !== -1) {
          conversations.value[index].status = ConversationStatus.ENDED
        }
        
        ElMessage.success('会话已结束')
      } catch (error) {
        console.error('结束会话失败:', error)
        ElMessage.error('结束会话失败')
      }
      break
      
    case 'delete':
      try {
        await ElMessageBox.confirm('确定要删除该会话吗？删除后无法恢复。', '确认删除', {
          type: 'warning'
        })
        
        await agentApi.deleteConversation(conversationId)
        
        // 从列表中移除
        const index = conversations.value.findIndex(c => c.id === conversationId)
        if (index !== -1) {
          conversations.value.splice(index, 1)
        }
        
        // 如果删除的是当前会话，清空聊天区域
        if (conversationId === currentConversationId.value) {
          currentConversationId.value = ''
          currentConversation.value = null
          currentAgent.value = null
          messages.value = []
        }
        
        ElMessage.success('会话已删除')
      } catch (error) {
        if (error !== 'cancel') {
          console.error('删除会话失败:', error)
          ElMessage.error('删除会话失败')
        }
      }
      break
  }
}

// 确认重命名
const confirmRename = async () => {
  if (!renameTitle.value.trim() || !renamingConversationId.value) {
    return
  }
  
  renaming.value = true
  try {
    const response = await agentApi.updateConversationTitle(renamingConversationId.value, renameTitle.value.trim())
    if (response.code === 200) {
      // 更新会话列表
      const index = conversations.value.findIndex(c => c.id === renamingConversationId.value)
      if (index !== -1) {
        conversations.value[index].title = renameTitle.value.trim()
      }
      
      // 更新当前会话
      if (renamingConversationId.value === currentConversationId.value && currentConversation.value) {
        currentConversation.value.title = renameTitle.value.trim()
      }
      
      showRenameDialog.value = false
      ElMessage.success('重命名成功')
    }
  } catch (error) {
    console.error('重命名失败:', error)
    ElMessage.error('重命名失败')
  } finally {
    renaming.value = false
  }
}

// 清空当前会话
const clearCurrentConversation = async () => {
  if (!currentConversationId.value) {
    return
  }
  
  try {
    await ElMessageBox.confirm('确定要清空当前会话的所有消息吗？', '确认清空', {
      type: 'warning'
    })
    
    await agentApi.clearConversationHistory(currentConversationId.value)
    messages.value = []
    messageCount.value = 0
    
    ElMessage.success('会话历史已清空')
  } catch (error) {
    if (error !== 'cancel') {
      console.error('清空会话失败:', error)
      ElMessage.error('清空会话失败')
    }
  }
}

// 导出对话
const exportConversation = async () => {
  if (!currentConversation.value || messages.value.length === 0) {
    ElMessage.warning('没有可导出的对话内容')
    return
  }
  
  try {
    const content = messages.value.map(message => {
      const sender = message.messageType === MessageType.USER ? '用户' : currentAgent.value?.agentName || 'AI'
      const time = formatTime(message.createdAt)
      return `[${time}] ${sender}: ${message.content}`
    }).join('\n\n')
    
    const blob = new Blob([content], { type: 'text/plain;charset=utf-8' })
    const url = URL.createObjectURL(blob)
    
    const link = document.createElement('a')
    link.href = url
    link.download = `${currentConversation.value.title || '对话记录'}_${new Date().toISOString().slice(0, 10)}.txt`
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    
    URL.revokeObjectURL(url)
    ElMessage.success('对话已导出')
  } catch (error) {
    console.error('导出失败:', error)
    ElMessage.error('导出失败')
  }
}

// 工具函数
const formatTime = (time: string) => {
  const date = new Date(time)
  const now = new Date()
  const diff = now.getTime() - date.getTime()
  
  if (diff < 60000) { // 1分钟内
    return '刚刚'
  } else if (diff < 3600000) { // 1小时内
    return `${Math.floor(diff / 60000)}分钟前`
  } else if (diff < 86400000) { // 24小时内
    return `${Math.floor(diff / 3600000)}小时前`
  } else {
    return date.toLocaleDateString() + ' ' + date.toLocaleTimeString().slice(0, 5)
  }
}

const getConversationStatusType = (status: ConversationStatus) => {
  const typeMap = {
    [ConversationStatus.ACTIVE]: 'success',
    [ConversationStatus.ENDED]: 'warning',
    [ConversationStatus.DELETED]: 'danger'
  }
  return typeMap[status] || 'info'
}

const getConversationStatusText = (status: ConversationStatus) => {
  const textMap = {
    [ConversationStatus.ACTIVE]: '进行中',
    [ConversationStatus.ENDED]: '已结束',
    [ConversationStatus.DELETED]: '已删除'
  }
  return textMap[status] || '未知'
}

const getAgentStatusType = (status?: AgentStatus) => {
  if (!status) return 'info'
  
  const typeMap = {
    [AgentStatus.DRAFT]: 'info',
    [AgentStatus.PUBLISHED]: 'success',
    [AgentStatus.ARCHIVED]: 'warning'
  }
  return typeMap[status] || 'info'
}

const getAgentStatusText = (status?: AgentStatus) => {
  if (!status) return '未知'
  
  const textMap = {
    [AgentStatus.DRAFT]: '草稿',
    [AgentStatus.PUBLISHED]: '已发布',
    [AgentStatus.ARCHIVED]: '已归档'
  }
  return textMap[status] || '未知'
}

// =============== 生命周期 ===============
onMounted(async () => {
  await Promise.all([
    loadConversations(),
    loadAvailableAgents()
  ])
})

// 监听当前会话变化，自动滚动到底部
watch(messages, async () => {
  await nextTick()
  scrollToBottom()
}, { deep: true })
</script>

<style lang="scss" scoped>
.chat-container {
  display: flex;
  height: calc(100vh - 140px);
  background: #f5f7fa;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

// =============== 左侧会话列表 ===============
.conversation-sidebar {
  width: 320px;
  background: #fff;
  border-right: 1px solid #e4e7ed;
  display: flex;
  flex-direction: column;

  .sidebar-header {
    padding: 16px;
    border-bottom: 1px solid #e4e7ed;
    display: flex;
    align-items: center;
    justify-content: space-between;

    .sidebar-title {
      display: flex;
      align-items: center;
      gap: 8px;
      margin: 0;
      font-size: 16px;
      font-weight: 600;
      color: #303133;
    }
  }

  .conversation-search {
    padding: 12px 16px;
    border-bottom: 1px solid #e4e7ed;
  }

  .conversation-list {
    flex: 1;
    overflow-y: auto;
    padding: 8px 0;

    .conversation-item {
      display: flex;
      align-items: center;
      padding: 12px 16px;
      cursor: pointer;
      transition: background-color 0.2s;

      &:hover {
        background: #f5f7fa;
      }

      &.active {
        background: #e6f7ff;
        border-right: 3px solid #409eff;
      }

      .conversation-info {
        flex: 1;
        min-width: 0;

        .conversation-title {
          font-size: 14px;
          font-weight: 500;
          color: #303133;
          margin-bottom: 4px;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
        }

        .conversation-meta {
          display: flex;
          align-items: center;
          gap: 8px;
          font-size: 12px;
          color: #909399;

          .last-message-time {
            flex: 1;
          }
        }
      }

      .conversation-actions {
        opacity: 0;
        transition: opacity 0.2s;
      }

      &:hover .conversation-actions {
        opacity: 1;
      }
    }

    .empty-conversations {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 40px 20px;
      color: #909399;

      .el-icon {
        font-size: 48px;
        margin-bottom: 16px;
      }

      p {
        margin: 0 0 16px 0;
        font-size: 14px;
      }
    }
  }
}

// =============== 中间聊天区域 ===============
.chat-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  background: #fff;

  .chat-welcome {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;

    .welcome-content {
      text-align: center;
      color: #909399;

      .el-icon {
        font-size: 64px;
        margin-bottom: 16px;
        color: #c0c4cc;
      }

      h2 {
        margin: 0 0 8px 0;
        font-size: 24px;
        font-weight: 500;
        color: #606266;
      }

      p {
        margin: 0 0 24px 0;
        font-size: 14px;
        color: #909399;
      }
    }
  }

  .chat-content {
    flex: 1;
    display: flex;
    flex-direction: column;
    height: 100%;
  }

  .chat-header {
    padding: 16px 20px;
    border-bottom: 1px solid #e4e7ed;
    display: flex;
    align-items: center;
    justify-content: space-between;
    background: #fafafa;

    .chat-info {
      .chat-title {
        margin: 0 0 4px 0;
        font-size: 16px;
        font-weight: 600;
        color: #303133;
      }

      .chat-meta {
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 12px;
        color: #909399;

        .separator {
          color: #c0c4cc;
        }
      }
    }

    .chat-actions {
      display: flex;
      gap: 8px;
    }
  }

  .messages-container {
    flex: 1;
    overflow-y: auto;
    padding: 20px;
    background: #f8f9fa;

    .message-item {
      display: flex;
      margin-bottom: 24px;
      animation: fadeInUp 0.3s ease;

      &.user-message {
        justify-content: flex-end;

        .message-content {
          max-width: 70%;
          background: #409eff;
          color: #fff;
          border-radius: 18px 18px 4px 18px;
        }

        .user-text {
          padding: 12px 16px;
          line-height: 1.5;
        }
      }

      &.assistant-message {
        justify-content: flex-start;

        .message-content {
          max-width: 70%;
          background: #fff;
          border: 1px solid #e4e7ed;
          border-radius: 18px 18px 18px 4px;
        }
      }

      .message-avatar {
        margin: 0 12px;
        flex-shrink: 0;
      }

      .message-content {
        .message-header {
          display: flex;
          align-items: center;
          justify-content: space-between;
          padding: 8px 16px 4px 16px;
          font-size: 12px;

          .message-sender {
            font-weight: 500;
            color: #606266;
          }

          .message-time {
            color: #909399;
          }
        }

        .message-body {
          .assistant-content {
            padding: 8px 16px 12px 16px;
            line-height: 1.6;
            color: #303133;
            word-break: break-word;
          }

          .typing-indicator {
            display: flex;
            align-items: center;
            gap: 4px;
            padding: 12px 16px;

            span {
              width: 8px;
              height: 8px;
              border-radius: 50%;
              background: #409eff;
              animation: typing 1.4s infinite ease-in-out;

              &:nth-child(1) { animation-delay: -0.32s; }
              &:nth-child(2) { animation-delay: -0.16s; }
            }
          }

          .error-message {
            padding: 12px 16px;
            color: #f56c6c;
            display: flex;
            align-items: center;
            gap: 8px;
          }
        }

        .message-actions {
          padding: 4px 16px 8px 16px;
          display: flex;
          gap: 8px;
          opacity: 0;
          transition: opacity 0.2s;
        }

        &:hover .message-actions {
          opacity: 1;
        }
      }
    }

    .load-more {
      text-align: center;
      padding: 20px 0;
    }
  }

  .input-area {
    border-top: 1px solid #e4e7ed;
    background: #fff;
    padding: 16px 20px;

    .input-container {
      border: 1px solid #dcdfe6;
      border-radius: 8px;
      overflow: hidden;
      transition: border-color 0.2s;

      &:focus-within {
        border-color: #409eff;
      }

      :deep(.el-textarea__inner) {
        border: none;
        box-shadow: none;
        padding: 12px 16px;
        resize: none;
        font-size: 14px;
      }

      .input-actions {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 8px 16px;
        background: #fafafa;
        border-top: 1px solid #e4e7ed;

        .input-tools {
          display: flex;
          gap: 8px;
        }

        .send-area {
          display: flex;
          align-items: center;
          gap: 12px;

          .shortcut-hint {
            font-size: 12px;
            color: #909399;
          }
        }
      }
    }
  }
}

// =============== 对话框样式 ===============
.agent-option {
  display: flex;
  align-items: center;
  justify-content: space-between;

  .agent-name {
    flex: 1;
  }
}

// =============== 动画效果 ===============
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes typing {
  0%, 80%, 100% {
    transform: scale(0);
    opacity: 0.5;
  }
  40% {
    transform: scale(1);
    opacity: 1;
  }
}

// =============== 响应式设计 ===============
@media (max-width: 1024px) {
  .conversation-sidebar {
    width: 280px;
  }
  
  .message-item {
    &.user-message .message-content,
    &.assistant-message .message-content {
      max-width: 85%;
    }
  }
}

@media (max-width: 768px) {
  .chat-container {
    height: calc(100vh - 100px);
  }
  
  .conversation-sidebar {
    width: 100%;
    position: absolute;
    z-index: 100;
    height: 100%;
    transform: translateX(-100%);
    transition: transform 0.3s ease;
    
    &.show {
      transform: translateX(0);
    }
  }
  
  .message-item {
    margin-bottom: 16px;
    
    &.user-message .message-content,
    &.assistant-message .message-content {
      max-width: 90%;
    }
  }
}
</style>