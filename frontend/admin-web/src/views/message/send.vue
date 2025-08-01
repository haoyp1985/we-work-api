<template>
  <div class="message-send">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-left">
        <h2 class="page-title">
          <el-icon><Promotion /></el-icon>
          消息发送
        </h2>
        <p class="page-description">支持文本、图片、视频等多种消息类型的群发</p>
      </div>
      
      <div class="header-right">
        <el-button @click="$router.push('/message/history')">
          <el-icon><Clock /></el-icon>
          发送历史
        </el-button>
        <el-button type="primary" @click="$router.push('/message/template')">
          <el-icon><DocumentCopy /></el-icon>
          消息模板
        </el-button>
      </div>
    </div>

    <el-row :gutter="20">
      <!-- 左侧：消息编辑区 -->
      <el-col :span="16" :xs="24">
        <el-card shadow="never" class="message-editor-card">
          <template #header>
            <div class="card-header">
              <span class="card-title">消息编辑</span>
              <div class="message-type-tabs">
                <el-radio-group v-model="messageForm.type" @change="handleTypeChange">
                  <el-radio-button value="text">文本消息</el-radio-button>
                  <el-radio-button value="image">图片消息</el-radio-button>
                  <el-radio-button value="video">视频消息</el-radio-button>
                  <el-radio-button value="file">文件消息</el-radio-button>
                  <el-radio-button value="link">链接消息</el-radio-button>
                </el-radio-group>
              </div>
            </div>
          </template>

          <el-form ref="formRef" :model="messageForm" :rules="formRules" label-width="80px">
            <!-- 文本消息 -->
            <div v-if="messageForm.type === 'text'" class="message-content">
              <el-form-item label="消息内容" prop="content">
                <el-input
                  v-model="messageForm.content"
                  type="textarea"
                  :rows="8"
                  placeholder="请输入要发送的消息内容..."
                  show-word-limit
                  :maxlength="2000"
                />
              </el-form-item>
              
              <div class="content-tools">
                <el-button size="small" @click="insertVariable('@昵称')">插入昵称</el-button>
                <el-button size="small" @click="insertVariable('@时间')">插入时间</el-button>
                <el-button size="small" @click="insertVariable('@公司')">插入公司</el-button>
                <el-button size="small" @click="showEmojiPanel = true">表情</el-button>
              </div>
            </div>

            <!-- 图片消息 -->
            <div v-if="messageForm.type === 'image'" class="message-content">
              <el-form-item label="上传图片" prop="mediaUrl">
                <el-upload
                  ref="imageUploadRef"
                  :auto-upload="false"
                  :on-change="handleImageChange"
                  :before-upload="beforeImageUpload"
                  accept="image/*"
                  list-type="picture-card"
                  :limit="9"
                >
                  <el-icon><Plus /></el-icon>
                </el-upload>
              </el-form-item>
              
              <el-form-item label="图片描述" prop="content">
                <el-input
                  v-model="messageForm.content"
                  type="textarea"
                  :rows="3"
                  placeholder="可选：为图片添加描述文字"
                  show-word-limit
                  :maxlength="500"
                />
              </el-form-item>
            </div>

            <!-- 视频消息 -->
            <div v-if="messageForm.type === 'video'" class="message-content">
              <el-form-item label="上传视频" prop="mediaUrl">
                <el-upload
                  ref="videoUploadRef"
                  :auto-upload="false"
                  :on-change="handleVideoChange"
                  :before-upload="beforeVideoUpload"
                  accept="video/*"
                  :limit="1"
                >
                  <el-button type="primary">
                    <el-icon><VideoCamera /></el-icon>
                    选择视频文件
                  </el-button>
                  <template #tip>
                    <div class="el-upload__tip">
                      支持 mp4, avi, mov 格式，文件大小不超过 100MB
                    </div>
                  </template>
                </el-upload>
              </el-form-item>
              
              <el-form-item label="视频描述" prop="content">
                <el-input
                  v-model="messageForm.content"
                  type="textarea"
                  :rows="3"
                  placeholder="可选：为视频添加描述文字"
                  show-word-limit
                  :maxlength="500"
                />
              </el-form-item>
            </div>

            <!-- 文件消息 -->
            <div v-if="messageForm.type === 'file'" class="message-content">
              <el-form-item label="上传文件" prop="mediaUrl">
                <el-upload
                  ref="fileUploadRef"
                  :auto-upload="false"
                  :on-change="handleFileChange"
                  :before-upload="beforeFileUpload"
                  :limit="1"
                >
                  <el-button type="primary">
                    <el-icon><Document /></el-icon>
                    选择文件
                  </el-button>
                  <template #tip>
                    <div class="el-upload__tip">
                      支持 pdf, doc, docx, xls, xlsx, ppt, pptx 等格式，文件大小不超过 50MB
                    </div>
                  </template>
                </el-upload>
              </el-form-item>
              
              <el-form-item label="文件描述" prop="content">
                <el-input
                  v-model="messageForm.content"
                  type="textarea"
                  :rows="3"
                  placeholder="可选：为文件添加描述文字"
                  show-word-limit
                  :maxlength="500"
                />
              </el-form-item>
            </div>

            <!-- 链接消息 -->
            <div v-if="messageForm.type === 'link'" class="message-content">
              <el-form-item label="链接地址" prop="linkUrl">
                <el-input
                  v-model="messageForm.linkUrl"
                  placeholder="请输入链接地址，如：https://www.example.com"
                />
              </el-form-item>
              
              <el-form-item label="链接标题" prop="linkTitle">
                <el-input
                  v-model="messageForm.linkTitle"
                  placeholder="请输入链接标题"
                />
              </el-form-item>
              
              <el-form-item label="链接描述" prop="content">
                <el-input
                  v-model="messageForm.content"
                  type="textarea"
                  :rows="3"
                  placeholder="请输入链接描述"
                  show-word-limit
                  :maxlength="500"
                />
              </el-form-item>
            </div>

            <!-- 发送设置 -->
            <el-divider />
            
            <el-form-item label="发送方式">
              <el-radio-group v-model="messageForm.sendMode">
                <el-radio value="immediate">立即发送</el-radio>
                <el-radio value="scheduled">定时发送</el-radio>
              </el-radio-group>
            </el-form-item>

            <el-form-item v-if="messageForm.sendMode === 'scheduled'" label="发送时间" prop="scheduledTime">
              <el-date-picker
                v-model="messageForm.scheduledTime"
                type="datetime"
                placeholder="选择发送时间"
                :disabled-date="disabledDate"
                :disabled-hours="disabledHours"
                :disabled-minutes="disabledMinutes"
                style="width: 100%;"
              />
            </el-form-item>

            <el-form-item label="发送频率">
              <el-select v-model="messageForm.sendRate" style="width: 200px;">
                <el-option label="正常速度（5条/秒）" value="normal" />
                <el-option label="较快（10条/秒）" value="fast" />
                <el-option label="较慢（2条/秒）" value="slow" />
                <el-option label="自定义" value="custom" />
              </el-select>
              
              <el-input-number
                v-if="messageForm.sendRate === 'custom'"
                v-model="messageForm.customRate"
                :min="1"
                :max="20"
                style="width: 120px; margin-left: 12px;"
              />
              <span v-if="messageForm.sendRate === 'custom'" style="margin-left: 8px;">条/秒</span>
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>

      <!-- 右侧：发送对象和预览 -->
      <el-col :span="8" :xs="24">
        <!-- 发送对象选择 -->
        <el-card shadow="never" class="target-card" style="margin-bottom: 20px;">
          <template #header>
            <span class="card-title">发送对象</span>
          </template>

          <div class="target-selection">
            <el-tabs v-model="targetTab" type="border-card">
              <el-tab-pane label="选择账号" name="accounts">
                <div class="account-selection">
                  <el-input
                    v-model="accountSearchKeyword"
                    placeholder="搜索账号"
                    size="small"
                    clearable
                    style="margin-bottom: 12px;"
                  >
                    <template #prefix>
                      <el-icon><Search /></el-icon>
                    </template>
                  </el-input>
                  
                  <div class="account-list">
                    <el-checkbox-group v-model="selectedAccounts">
                      <div v-for="account in filteredAccounts" :key="account.id" class="account-item">
                        <el-checkbox :value="account.id">
                          <div class="account-info">
                            <span class="account-name">{{ account.name }}</span>
                            <el-tag 
                              :type="account.status === 'online' ? 'success' : 'danger'" 
                              size="small"
                            >
                              {{ account.status === 'online' ? '在线' : '离线' }}
                            </el-tag>
                          </div>
                        </el-checkbox>
                      </div>
                    </el-checkbox-group>
                  </div>
                  
                  <div class="selection-actions">
                    <el-button size="small" @click="selectAllAccounts">全选</el-button>
                    <el-button size="small" @click="selectOnlineAccounts">选择在线</el-button>
                    <el-button size="small" @click="clearSelection">清空</el-button>
                  </div>
                </div>
              </el-tab-pane>
              
              <el-tab-pane label="导入群组" name="groups">
                <div class="group-selection">
                  <el-upload
                    :auto-upload="false"
                    :on-change="handleGroupFileChange"
                    accept=".txt,.csv"
                    :limit="1"
                  >
                    <el-button size="small" type="primary">
                      <el-icon><Upload /></el-icon>
                      导入群组
                    </el-button>
                    <template #tip>
                      <div class="el-upload__tip">
                        支持 txt, csv 格式的群组文件
                      </div>
                    </template>
                  </el-upload>
                  
                  <div v-if="importedContacts.length > 0" class="imported-contacts">
                    <p>已导入 {{ importedContacts.length }} 个联系人</p>
                    <el-button size="small" @click="clearImportedContacts">清空导入</el-button>
                  </div>
                </div>
              </el-tab-pane>
            </el-tabs>
            
            <div class="target-summary">
              <el-alert
                :title="`选中 ${totalTargets} 个发送对象`"
                type="info"
                :closable="false"
                show-icon
              />
            </div>
          </div>
        </el-card>

        <!-- 消息预览 -->
        <el-card shadow="never" class="preview-card">
          <template #header>
            <span class="card-title">消息预览</span>
          </template>

          <div class="message-preview">
            <div class="preview-device">
              <div class="device-header">
                <span class="device-title">企业微信</span>
              </div>
              
              <div class="message-bubble">
                <div v-if="messageForm.type === 'text'" class="text-message">
                  {{ messageForm.content || '请输入消息内容...' }}
                </div>
                
                <div v-if="messageForm.type === 'image'" class="image-message">
                  <div class="image-placeholder">
                    <el-icon><Picture /></el-icon>
                    <span>图片消息</span>
                  </div>
                  <div v-if="messageForm.content" class="image-caption">
                    {{ messageForm.content }}
                  </div>
                </div>
                
                <div v-if="messageForm.type === 'video'" class="video-message">
                  <div class="video-placeholder">
                    <el-icon><VideoCamera /></el-icon>
                    <span>视频消息</span>
                  </div>
                  <div v-if="messageForm.content" class="video-caption">
                    {{ messageForm.content }}
                  </div>
                </div>
                
                <div v-if="messageForm.type === 'file'" class="file-message">
                  <div class="file-placeholder">
                    <el-icon><Document /></el-icon>
                    <span>文件消息</span>
                  </div>
                  <div v-if="messageForm.content" class="file-caption">
                    {{ messageForm.content }}
                  </div>
                </div>
                
                <div v-if="messageForm.type === 'link'" class="link-message">
                  <div class="link-card">
                    <div class="link-title">{{ messageForm.linkTitle || '链接标题' }}</div>
                    <div class="link-desc">{{ messageForm.content || '链接描述' }}</div>
                    <div class="link-url">{{ messageForm.linkUrl || 'https://...' }}</div>
                  </div>
                </div>
              </div>
              
              <div class="preview-info">
                <p><strong>发送时间：</strong>{{ sendTimeText }}</p>
                <p><strong>发送对象：</strong>{{ totalTargets }} 人</p>
                <p><strong>预计耗时：</strong>{{ estimatedTime }}</p>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 底部操作栏 -->
    <div class="action-bar">
      <div class="action-left">
        <el-button @click="saveDraft">
          <el-icon><DocumentCopy /></el-icon>
          保存草稿
        </el-button>
        <el-button @click="saveAsTemplate">
          <el-icon><Collection /></el-icon>
          存为模板
        </el-button>
      </div>
      
      <div class="action-right">
        <el-button @click="previewSend" :disabled="!canSend">
          <el-icon><View /></el-icon>
          预览发送
        </el-button>
        <el-button type="primary" @click="handleSend" :loading="sending" :disabled="!canSend">
          <el-icon><Promotion /></el-icon>
          {{ messageForm.sendMode === 'scheduled' ? '定时发送' : '立即发送' }}
        </el-button>
      </div>
    </div>

    <!-- 发送确认弹窗 -->
    <el-dialog v-model="showSendConfirm" title="确认发送" width="500px">
      <div class="send-confirm">
        <el-alert
          title="请确认发送信息"
          type="warning"
          :closable="false"
          show-icon
        />
        
        <div class="confirm-details">
          <p><strong>消息类型：</strong>{{ messageTypeText }}</p>
          <p><strong>发送对象：</strong>{{ totalTargets }} 人</p>
          <p><strong>发送时间：</strong>{{ sendTimeText }}</p>
          <p><strong>预计耗时：</strong>{{ estimatedTime }}</p>
        </div>
        
        <el-alert
          title="发送后无法撤回，请谨慎操作"
          type="error"
          :closable="false"
        />
      </div>
      
      <template #footer>
        <el-button @click="showSendConfirm = false">取消</el-button>
        <el-button type="primary" @click="confirmSend" :loading="sending">
          确认发送
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { formatDateTime } from '@/utils/format'

// 响应式数据
const sending = ref(false)
const showSendConfirm = ref(false)
const showEmojiPanel = ref(false)
const targetTab = ref('accounts')
const accountSearchKeyword = ref('')
const selectedAccounts = ref<string[]>([])
const importedContacts = ref<any[]>([])
const formRef = ref()
const imageUploadRef = ref()
const videoUploadRef = ref()
const fileUploadRef = ref()

// 表单数据
const messageForm = reactive({
  type: 'text',
  content: '',
  mediaUrl: '',
  linkUrl: '',
  linkTitle: '',
  sendMode: 'immediate',
  scheduledTime: null,
  sendRate: 'normal',
  customRate: 5
})

// 表单验证规则
const formRules = {
  content: [
    { required: true, message: '请输入消息内容', trigger: 'blur' }
  ],
  linkUrl: [
    { required: true, message: '请输入链接地址', trigger: 'blur' },
    { type: 'url', message: '请输入正确的链接地址', trigger: 'blur' }
  ],
  linkTitle: [
    { required: true, message: '请输入链接标题', trigger: 'blur' }
  ],
  scheduledTime: [
    { required: true, message: '请选择发送时间', trigger: 'change' }
  ]
}

// 模拟账号数据
const accountList = ref([
  { id: '1', name: '客服01', status: 'online' },
  { id: '2', name: '销售02', status: 'online' },
  { id: '3', name: '运营03', status: 'offline' },
  { id: '4', name: '客服04', status: 'online' },
  { id: '5', name: '销售05', status: 'offline' }
])

// 计算属性
const filteredAccounts = computed(() => {
  if (!accountSearchKeyword.value) return accountList.value
  return accountList.value.filter(account => 
    account.name.toLowerCase().includes(accountSearchKeyword.value.toLowerCase())
  )
})

const totalTargets = computed(() => {
  return selectedAccounts.value.length + importedContacts.value.length
})

const canSend = computed(() => {
  if (totalTargets.value === 0) return false
  
  switch (messageForm.type) {
    case 'text':
      return !!messageForm.content.trim()
    case 'image':
    case 'video':
    case 'file':
      return !!messageForm.mediaUrl
    case 'link':
      return !!messageForm.linkUrl && !!messageForm.linkTitle
    default:
      return false
  }
})

const messageTypeText = computed(() => {
  const typeMap = {
    text: '文本消息',
    image: '图片消息',
    video: '视频消息',
    file: '文件消息',
    link: '链接消息'
  }
  return typeMap[messageForm.type] || '未知类型'
})

const sendTimeText = computed(() => {
  if (messageForm.sendMode === 'immediate') {
    return '立即发送'
  } else if (messageForm.scheduledTime) {
    return formatDateTime(messageForm.scheduledTime)
  }
  return '未设置'
})

const estimatedTime = computed(() => {
  if (totalTargets.value === 0) return '0秒'
  
  let rate = 5 // 默认速度
  switch (messageForm.sendRate) {
    case 'fast':
      rate = 10
      break
    case 'slow':
      rate = 2
      break
    case 'custom':
      rate = messageForm.customRate
      break
  }
  
  const seconds = Math.ceil(totalTargets.value / rate)
  if (seconds < 60) return `${seconds}秒`
  const minutes = Math.floor(seconds / 60)
  const remainSeconds = seconds % 60
  return remainSeconds > 0 ? `${minutes}分${remainSeconds}秒` : `${minutes}分钟`
})

// 方法
const handleTypeChange = () => {
  // 重置表单相关字段
  messageForm.content = ''
  messageForm.mediaUrl = ''
  messageForm.linkUrl = ''
  messageForm.linkTitle = ''
}

const insertVariable = (variable: string) => {
  messageForm.content += variable
}

const selectAllAccounts = () => {
  selectedAccounts.value = accountList.value.map(acc => acc.id)
}

const selectOnlineAccounts = () => {
  selectedAccounts.value = accountList.value
    .filter(acc => acc.status === 'online')
    .map(acc => acc.id)
}

const clearSelection = () => {
  selectedAccounts.value = []
}

const handleImageChange = (file: any) => {
  // 处理图片上传
  messageForm.mediaUrl = URL.createObjectURL(file.raw)
}

const beforeImageUpload = (file: any) => {
  const isImage = file.type.startsWith('image/')
  const isLt10M = file.size / 1024 / 1024 < 10
  
  if (!isImage) {
    ElMessage.error('只能上传图片文件!')
    return false
  }
  if (!isLt10M) {
    ElMessage.error('图片大小不能超过 10MB!')
    return false
  }
  return true
}

const handleVideoChange = (file: any) => {
  messageForm.mediaUrl = URL.createObjectURL(file.raw)
}

const beforeVideoUpload = (file: any) => {
  const isVideo = file.type.startsWith('video/')
  const isLt100M = file.size / 1024 / 1024 < 100
  
  if (!isVideo) {
    ElMessage.error('只能上传视频文件!')
    return false
  }
  if (!isLt100M) {
    ElMessage.error('视频大小不能超过 100MB!')
    return false
  }
  return true
}

const handleFileChange = (file: any) => {
  messageForm.mediaUrl = file.name
}

const beforeFileUpload = (file: any) => {
  const allowedTypes = [
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.ms-excel',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'application/vnd.ms-powerpoint',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation'
  ]
  
  const isAllowed = allowedTypes.includes(file.type)
  const isLt50M = file.size / 1024 / 1024 < 50
  
  if (!isAllowed) {
    ElMessage.error('文件类型不支持!')
    return false
  }
  if (!isLt50M) {
    ElMessage.error('文件大小不能超过 50MB!')
    return false
  }
  return true
}

const handleGroupFileChange = (file: any) => {
  // 处理群组文件导入
  ElMessage.success('群组文件导入成功')
  importedContacts.value = [
    { id: 'import-1', name: '导入联系人1' },
    { id: 'import-2', name: '导入联系人2' }
  ]
}

const clearImportedContacts = () => {
  importedContacts.value = []
}

const disabledDate = (time: Date) => {
  return time.getTime() < Date.now() - 8.64e7 // 不能选择过去的日期
}

const disabledHours = () => {
  const hours = []
  const now = new Date()
  const selectedDate = new Date(messageForm.scheduledTime)
  
  if (selectedDate.toDateString() === now.toDateString()) {
    for (let i = 0; i < now.getHours(); i++) {
      hours.push(i)
    }
  }
  
  return hours
}

const disabledMinutes = (hour: number) => {
  const minutes = []
  const now = new Date()
  const selectedDate = new Date(messageForm.scheduledTime)
  
  if (selectedDate.toDateString() === now.toDateString() && hour === now.getHours()) {
    for (let i = 0; i <= now.getMinutes(); i++) {
      minutes.push(i)
    }
  }
  
  return minutes
}

const saveDraft = () => {
  ElMessage.success('草稿保存成功')
}

const saveAsTemplate = () => {
  ElMessage.success('模板保存成功')
}

const previewSend = () => {
  ElMessage.info('预览功能开发中...')
}

const handleSend = async () => {
  if (!formRef.value) return
  
  try {
    await formRef.value.validate()
    showSendConfirm.value = true
  } catch (error) {
    ElMessage.error('请检查表单内容')
  }
}

const confirmSend = async () => {
  try {
    sending.value = true
    
    // 模拟发送API调用
    await new Promise(resolve => setTimeout(resolve, 2000))
    
    ElMessage.success('消息发送成功!')
    showSendConfirm.value = false
    
    // 重置表单
    Object.assign(messageForm, {
      type: 'text',
      content: '',
      mediaUrl: '',
      linkUrl: '',
      linkTitle: '',
      sendMode: 'immediate',
      scheduledTime: null,
      sendRate: 'normal',
      customRate: 5
    })
    selectedAccounts.value = []
    importedContacts.value = []
    
  } catch (error) {
    ElMessage.error('发送失败，请重试')
  } finally {
    sending.value = false
  }
}

// 生命周期
onMounted(() => {
  // 初始化
})
</script>

<style lang="scss" scoped>
.message-send {
  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 20px;
    
    .header-left {
      .page-title {
        display: flex;
        align-items: center;
        gap: 8px;
        margin: 0 0 8px 0;
        font-size: 20px;
        font-weight: 600;
        color: var(--el-text-color-primary);
      }
      
      .page-description {
        margin: 0;
        color: var(--el-text-color-regular);
        font-size: 14px;
      }
    }
    
    .header-right {
      display: flex;
      gap: 12px;
    }
  }
  
  .message-editor-card {
    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      
      .card-title {
        font-size: 16px;
        font-weight: 600;
      }
    }
    
    .message-content {
      .content-tools {
        margin-top: 12px;
        display: flex;
        gap: 8px;
        flex-wrap: wrap;
      }
    }
  }
  
  .target-card {
    .target-selection {
      .account-selection {
        .account-list {
          max-height: 300px;
          overflow-y: auto;
          margin-bottom: 12px;
          
          .account-item {
            margin-bottom: 8px;
            padding: 8px;
            border: 1px solid var(--el-border-color-lighter);
            border-radius: 4px;
            
            .account-info {
              display: flex;
              justify-content: space-between;
              align-items: center;
              width: 100%;
              
              .account-name {
                font-size: 14px;
              }
            }
          }
        }
        
        .selection-actions {
          display: flex;
          gap: 8px;
        }
      }
      
      .group-selection {
        .imported-contacts {
          margin-top: 12px;
          padding: 12px;
          background: var(--el-color-info-light-9);
          border-radius: 4px;
          
          p {
            margin: 0 0 8px 0;
            font-size: 14px;
          }
        }
      }
      
      .target-summary {
        margin-top: 16px;
      }
    }
  }
  
  .preview-card {
    .message-preview {
      .preview-device {
        background: #f5f5f5;
        border-radius: 8px;
        padding: 16px;
        
        .device-header {
          text-align: center;
          padding: 8px 0 16px 0;
          border-bottom: 1px solid #ddd;
          margin-bottom: 16px;
          
          .device-title {
            font-size: 14px;
            font-weight: 600;
            color: #666;
          }
        }
        
        .message-bubble {
          background: #fff;
          border-radius: 8px;
          padding: 12px;
          margin-bottom: 16px;
          box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
          
          .text-message {
            line-height: 1.5;
            word-break: break-word;
          }
          
          .image-message,
          .video-message,
          .file-message {
            .image-placeholder,
            .video-placeholder,
            .file-placeholder {
              display: flex;
              flex-direction: column;
              align-items: center;
              padding: 20px;
              background: #f0f0f0;
              border-radius: 4px;
              color: #666;
              margin-bottom: 8px;
              
              .el-icon {
                font-size: 24px;
                margin-bottom: 8px;
              }
            }
            
            .image-caption,
            .video-caption,
            .file-caption {
              font-size: 13px;
              color: #666;
            }
          }
          
          .link-message {
            .link-card {
              border: 1px solid #e0e0e0;
              border-radius: 4px;
              padding: 12px;
              
              .link-title {
                font-weight: 600;
                margin-bottom: 4px;
                color: #1976d2;
              }
              
              .link-desc {
                font-size: 13px;
                color: #666;
                margin-bottom: 8px;
              }
              
              .link-url {
                font-size: 12px;
                color: #999;
                word-break: break-all;
              }
            }
          }
        }
        
        .preview-info {
          font-size: 12px;
          color: #666;
          
          p {
            margin: 4px 0;
          }
        }
      }
    }
  }
  
  .action-bar {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    background: #fff;
    border-top: 1px solid var(--el-border-color);
    padding: 16px 24px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    z-index: 1000;
    
    .action-left,
    .action-right {
      display: flex;
      gap: 12px;
    }
  }
  
  .send-confirm {
    .confirm-details {
      margin: 16px 0;
      padding: 16px;
      background: #f8f9fa;
      border-radius: 4px;
      
      p {
        margin: 8px 0;
        font-size: 14px;
      }
    }
  }
}

// 为底部操作栏预留空间
:deep(.el-main) {
  padding-bottom: 80px;
}

// 响应式适配
@media (max-width: 1200px) {
  .message-send {
    .el-row {
      .el-col:last-child {
        margin-top: 20px;
      }
    }
  }
}

@media (max-width: 768px) {
  .message-send {
    .page-header {
      flex-direction: column;
      gap: 16px;
      
      .header-right {
        width: 100%;
        
        .el-button {
          flex: 1;
        }
      }
    }
    
    .action-bar {
      padding: 12px 16px;
      
      .action-left,
      .action-right {
        gap: 8px;
        
        .el-button {
          padding: 8px 12px;
          font-size: 12px;
        }
      }
    }
  }
}
</style>