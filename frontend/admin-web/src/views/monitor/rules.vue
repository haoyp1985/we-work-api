<template>
  <div class="monitor-rules">
    <!-- 测试内容 - 确认组件正常加载 -->
    <div style="padding: 20px; background: #fdf2f8; border: 2px solid #ec4899; border-radius: 8px; margin-bottom: 20px;">
      <h2 style="color: #ec4899; margin: 0 0 10px 0;">⚙️ 监控规则页面加载成功！</h2>
      <p style="margin: 0; color: #be185d;">监控规则模块正常工作。</p>
    </div>

    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-left">
        <h2 class="page-title">
          <el-icon><SetUp /></el-icon>
          监控规则
        </h2>
        <div class="header-info">
          <el-tag type="success" size="small">
            启用: {{ enabledRulesCount }}
          </el-tag>
          <el-tag type="info" size="small">
            禁用: {{ disabledRulesCount }}
          </el-tag>
          <el-tag type="warning" size="small">
            内置: {{ builtinRulesCount }}
          </el-tag>
        </div>
      </div>
      
      <div class="header-right">
        <el-button type="primary" @click="showCreateDialog = true">
          <el-icon><Plus /></el-icon>
          新建规则
        </el-button>
      </div>
    </div>

    <!-- 规则分类标签 -->
    <div class="rule-categories">
      <el-tabs v-model="activeCategory" @tab-change="handleCategoryChange">
        <el-tab-pane label="全部规则" name="all" />
        <el-tab-pane label="账号状态" name="account" />
        <el-tab-pane label="性能监控" name="performance" />
        <el-tab-pane label="系统资源" name="system" />
        <el-tab-pane label="业务逻辑" name="business" />
        <el-tab-pane label="自定义" name="custom" />
      </el-tabs>
    </div>

    <!-- 过滤和搜索 -->
    <el-card shadow="never" class="filter-card">
      <div class="filter-container">
        <div class="filter-left">
          <el-input
            v-model="searchKeyword"
            placeholder="搜索规则名称、描述"
            style="width: 250px;"
            clearable
            @input="handleSearch"
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>
          
          <el-select
            v-model="filters.ruleType"
            placeholder="规则类型"
            clearable
            style="width: 120px;"
            @change="handleFilterChange"
          >
            <el-option label="内置规则" value="BUILTIN" />
            <el-option label="自定义规则" value="CUSTOM" />
          </el-select>
          
          <el-select
            v-model="filters.alertLevel"
            placeholder="告警级别"
            clearable
            style="width: 120px;"
            @change="handleFilterChange"
          >
            <el-option label="严重" value="CRITICAL" />
            <el-option label="错误" value="ERROR" />
            <el-option label="警告" value="WARNING" />
            <el-option label="信息" value="INFO" />
          </el-select>
          
          <el-select
            v-model="filters.enabled"
            placeholder="状态"
            clearable
            style="width: 100px;"
            @change="handleFilterChange"
          >
            <el-option label="启用" :value="true" />
            <el-option label="禁用" :value="false" />
          </el-select>
        </div>
        
        <div class="filter-right">
          <el-button @click="resetFilters">
            <el-icon><RefreshRight /></el-icon>
            重置
          </el-button>
          <el-button @click="handleImportRules">
            <el-icon><Upload /></el-icon>
            导入规则
          </el-button>
          <el-button @click="handleExportRules">
            <el-icon><Download /></el-icon>
            导出规则
          </el-button>
        </div>
      </div>
    </el-card>

    <!-- 规则列表 -->
    <div class="rules-grid">
      <el-row :gutter="16">
        <el-col
          v-for="rule in filteredRules"
          :key="rule.id"
          :span="8"
          :xs="24"
          :sm="12"
          :md="8"
          style="margin-bottom: 16px;"
        >
          <el-card class="rule-card" :class="{ 'rule-disabled': !rule.enabled }">
            <template #header>
              <div class="rule-header">
                <div class="rule-title">
                  <span class="rule-name">{{ rule.ruleName }}</span>
                  <el-tag
                    :type="getAlertLevelType(rule.alertLevel)"
                    size="small"
                    effect="plain"
                  >
                    {{ getAlertLevelText(rule.alertLevel) }}
                  </el-tag>
                </div>
                <div class="rule-actions">
                  <el-switch
                    v-model="rule.enabled"
                    size="small"
                    @change="handleToggleRule(rule)"
                  />
                  <el-dropdown @command="(cmd: string) => handleRuleAction(cmd, rule)">
                    <el-button circle size="small" :icon="MoreFilled" />
                    <template #dropdown>
                      <el-dropdown-menu>
                        <el-dropdown-item command="edit" :disabled="rule.ruleType === 'BUILTIN'">
                          编辑
                        </el-dropdown-item>
                        <el-dropdown-item command="test">
                          测试
                        </el-dropdown-item>
                        <el-dropdown-item command="clone">
                          克隆
                        </el-dropdown-item>
                        <el-dropdown-item command="delete" :disabled="rule.ruleType === 'BUILTIN'">
                          删除
                        </el-dropdown-item>
                      </el-dropdown-menu>
                    </template>
                  </el-dropdown>
                </div>
              </div>
            </template>
            
            <div class="rule-content">
              <div class="rule-description">
                {{ rule.description || '暂无描述' }}
              </div>
              
              <div class="rule-details">
                <div class="detail-item">
                  <span class="detail-label">类型:</span>
                  <el-tag 
                    :type="rule.ruleType === 'BUILTIN' ? 'warning' : 'primary'" 
                    size="small"
                    effect="plain"
                  >
                    {{ rule.ruleType === 'BUILTIN' ? '内置' : '自定义' }}
                  </el-tag>
                </div>
                
                <div class="detail-item">
                  <span class="detail-label">优先级:</span>
                  <span class="detail-value">{{ rule.priority || 5 }}</span>
                </div>
                
                <div class="detail-item">
                  <span class="detail-label">告警类型:</span>
                  <span class="detail-value">{{ getAlertTypeText(rule.alertType) }}</span>
                </div>
                
                <div class="detail-item">
                  <span class="detail-label">更新时间:</span>
                  <span class="detail-value">{{ formatDateTime(rule.updatedAt, 'MM-DD HH:mm') }}</span>
                </div>
              </div>
              
              <!-- 规则表达式预览 -->
              <div class="rule-expression">
                <el-tooltip :content="rule.ruleExpression" placement="top">
                  <code>{{ truncateExpression(rule.ruleExpression) }}</code>
                </el-tooltip>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
      
      <!-- 空状态 -->
      <div v-if="filteredRules.length === 0" class="empty-rules">
        <el-empty description="暂无监控规则" :image-size="120">
          <el-button type="primary" @click="showCreateDialog = true">
            创建第一个规则
          </el-button>
        </el-empty>
      </div>
    </div>

    <!-- 创建/编辑规则弹窗 -->
    <el-dialog
      v-model="showCreateDialog"
      :title="editingRule ? '编辑规则' : '新建规则'"
      width="800px"
      :close-on-click-modal="false"
      @close="resetRuleForm"
    >
      <el-form
        ref="ruleFormRef"
        :model="ruleForm"
        :rules="ruleFormRules"
        label-width="100px"
      >
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="规则名称" prop="ruleName">
              <el-input v-model="ruleForm.ruleName" placeholder="请输入规则名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="告警级别" prop="alertLevel">
              <el-select v-model="ruleForm.alertLevel" style="width: 100%;">
                <el-option label="严重" value="CRITICAL" />
                <el-option label="错误" value="ERROR" />
                <el-option label="警告" value="WARNING" />
                <el-option label="信息" value="INFO" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="告警类型" prop="alertType">
              <el-select v-model="ruleForm.alertType" style="width: 100%;">
                <el-option
                  v-for="type in alertTypes"
                  :key="type.value"
                  :label="type.label"
                  :value="type.value"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="优先级" prop="priority">
              <el-input-number
                v-model="ruleForm.priority"
                :min="1"
                :max="10"
                style="width: 100%;"
              />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-form-item label="规则描述" prop="description">
          <el-input
            v-model="ruleForm.description"
            type="textarea"
            :rows="3"
            placeholder="请输入规则描述"
          />
        </el-form-item>
        
        <el-form-item label="规则表达式" prop="ruleExpression">
          <el-input
            v-model="ruleForm.ruleExpression"
            type="textarea"
            :rows="5"
            placeholder="请输入规则表达式，例如：account.healthScore < 60"
          />
          <div class="form-help">
            <el-link type="primary" @click="showExpressionHelp = true">
              查看表达式语法帮助
            </el-link>
          </div>
        </el-form-item>
        
        <el-form-item label="告警消息" prop="alertMessage">
          <el-input
            v-model="ruleForm.alertMessage"
            type="textarea"
            :rows="2"
            placeholder="请输入告警消息模板，支持变量：{accountName}, {healthScore}"
          />
        </el-form-item>
        
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="是否启用">
              <el-switch v-model="ruleForm.enabled" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="测试表达式">
              <el-button @click="testRuleExpression" :loading="testingRule">
                测试规则
              </el-button>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      
      <template #footer>
        <el-button @click="showCreateDialog = false">取消</el-button>
        <el-button type="primary" @click="saveRule" :loading="savingRule">
          {{ editingRule ? '更新' : '创建' }}
        </el-button>
      </template>
    </el-dialog>

    <!-- 表达式帮助弹窗 -->
    <el-dialog
      v-model="showExpressionHelp"
      title="规则表达式语法帮助"
      width="600px"
    >
      <div class="expression-help">
        <h4>可用字段</h4>
        <ul>
          <li><code>account.healthScore</code> - 账号健康分数 (0-100)</li>
          <li><code>account.status</code> - 账号状态 (ONLINE, OFFLINE, ERROR等)</li>
          <li><code>account.retryCount</code> - 重试次数</li>
          <li><code>account.lastHeartbeatTime</code> - 最后心跳时间</li>
          <li><code>system.cpuUsage</code> - CPU使用率</li>
          <li><code>system.memoryUsage</code> - 内存使用率</li>
        </ul>
        
        <h4>操作符</h4>
        <ul>
          <li><code>&gt;, &lt;, &gt;=, &lt;=, ==, !=</code> - 比较操作符</li>
          <li><code>&&, ||, !</code> - 逻辑操作符</li>
          <li><code>contains()</code> - 字符串包含</li>
          <li><code>duration()</code> - 时间间隔计算</li>
        </ul>
        
        <h4>示例</h4>
        <ul>
          <li><code>account.healthScore &lt; 60</code> - 健康分数低于60</li>
          <li><code>account.status == "OFFLINE"</code> - 账号离线</li>
          <li><code>account.retryCount &gt;= 3</code> - 重试次数达到3次</li>
          <li><code>duration(account.lastHeartbeatTime) &gt; 300</code> - 心跳超时5分钟</li>
        </ul>
      </div>
    </el-dialog>

    <!-- 规则测试结果弹窗 -->
    <el-dialog
      v-model="showTestResult"
      title="规则测试结果"
      width="500px"
    >
      <div class="test-result">
        <el-alert
          :title="testResult.success ? '测试通过' : '测试失败'"
          :type="testResult.success ? 'success' : 'error'"
          :description="testResult.message"
          show-icon
          :closable="false"
        />
        
        <div v-if="testResult.details" class="test-details">
          <h4>详细信息</h4>
          <pre>{{ testResult.details }}</pre>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, reactive } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  SetUp,
  Plus,
  Search,
  RefreshRight,
  Upload,
  Download,
  MoreFilled
} from '@element-plus/icons-vue'
import { formatDateTime } from '@/utils/format'
import { ALERT_LEVEL_CONFIG, ALERT_TYPE_CONFIG } from '@/constants/monitor'
import type { MonitorRule } from '@/types'
import { AlertLevel, AlertType, MonitorRuleType } from '@/types'

// 响应式数据
const loading = ref(false)
const searchKeyword = ref('')
const activeCategory = ref('all')

// 过滤器
const filters = reactive({
  ruleType: '',
  alertLevel: '',
  enabled: '',
  tenantId: ''
})

// 规则数据（模拟）
const monitorRules = ref<MonitorRule[]>([
  {
    id: '1',
    tenantId: 'tenant-001',
    ruleName: '账号健康分数预警',
    ruleType: MonitorRuleType.BUILTIN,
    alertType: AlertType.STATUS_MISMATCH,
    alertLevel: AlertLevel.WARNING,
    ruleExpression: 'account.healthScore < 70',
    alertMessage: '账号 {accountName} 健康分数为 {healthScore}，低于70分阈值',
    priority: 5,
    description: '当账号健康分数低于70分时触发告警',
    enabled: true,
    createdAt: '2024-01-01T00:00:00Z',
    updatedAt: '2024-01-15T10:30:00Z'
  },
  {
    id: '2',
    tenantId: 'tenant-001',
    ruleName: '账号离线告警',
    ruleType: MonitorRuleType.BUILTIN,
    alertType: AlertType.ACCOUNT_OFFLINE,
    alertLevel: AlertLevel.CRITICAL,
    ruleExpression: 'account.status == "OFFLINE"',
    alertMessage: '账号 {accountName} 已离线',
    priority: 8,
    description: '账号状态变为离线时立即告警',
    enabled: true,
    createdAt: '2024-01-01T00:00:00Z',
    updatedAt: '2024-01-10T15:20:00Z'
  },
  {
    id: '3',
    tenantId: 'tenant-001',
    ruleName: '心跳超时检测',
    ruleType: MonitorRuleType.CUSTOM,
    alertType: AlertType.HEARTBEAT_TIMEOUT,
    alertLevel: AlertLevel.ERROR,
    ruleExpression: 'duration(account.lastHeartbeatTime) > 300',
    alertMessage: '账号 {accountName} 心跳超时，已超过5分钟无响应',
    priority: 7,
    description: '当账号心跳超过5分钟无响应时告警',
    enabled: true,
    createdAt: '2024-01-05T00:00:00Z',
    updatedAt: '2024-01-12T09:15:00Z'
  },
  {
    id: '4',
    tenantId: 'tenant-001',
    ruleName: '重试次数过多',
    ruleType: MonitorRuleType.CUSTOM,
    alertType: AlertType.RETRY_LIMIT_REACHED,
    alertLevel: AlertLevel.WARNING,
    ruleExpression: 'account.retryCount >= 3',
    alertMessage: '账号 {accountName} 重试次数已达到 {retryCount} 次',
    priority: 6,
    description: '当账号重试次数达到或超过3次时告警',
    enabled: false,
    createdAt: '2024-01-08T00:00:00Z',
    updatedAt: '2024-01-14T14:45:00Z'
  }
])

// 弹窗状态
const showCreateDialog = ref(false)
const showExpressionHelp = ref(false)
const showTestResult = ref(false)
const editingRule = ref<MonitorRule | null>(null)
const savingRule = ref(false)
const testingRule = ref(false)

// 表单数据
const ruleForm = reactive({
  ruleName: '',
  alertLevel: AlertLevel.WARNING,
  alertType: '' as AlertType,
  priority: 5,
  description: '',
  ruleExpression: '',
  alertMessage: '',
  enabled: true
})

const testResult = reactive({
  success: false,
  message: '',
  details: ''
})

// 表单验证规则
const ruleFormRules = {
  ruleName: [
    { required: true, message: '请输入规则名称', trigger: 'blur' }
  ],
  alertLevel: [
    { required: true, message: '请选择告警级别', trigger: 'change' }
  ],
  alertType: [
    { required: true, message: '请选择告警类型', trigger: 'change' }
  ],
  ruleExpression: [
    { required: true, message: '请输入规则表达式', trigger: 'blur' }
  ],
  alertMessage: [
    { required: true, message: '请输入告警消息', trigger: 'blur' }
  ]
}

const ruleFormRef = ref()

// 配置数据
const alertTypes = Object.entries(ALERT_TYPE_CONFIG).map(([key, config]) => ({
  value: key,
  label: config.text
}))

// Computed
const filteredRules = computed(() => {
  let rules = monitorRules.value
  
  // 关键词搜索
  if (searchKeyword.value) {
    const keyword = searchKeyword.value.toLowerCase()
    rules = rules.filter(rule => 
      rule.ruleName.toLowerCase().includes(keyword) ||
      rule.description?.toLowerCase().includes(keyword)
    )
  }
  
  // 分类过滤
  if (activeCategory.value !== 'all') {
    // 这里可以根据分类进一步过滤
    // rules = rules.filter(rule => rule.category === activeCategory.value)
  }
  
  // 其他过滤器
  if (filters.ruleType) {
    rules = rules.filter(rule => rule.ruleType === filters.ruleType)
  }
  
  if (filters.alertLevel) {
    rules = rules.filter(rule => rule.alertLevel === filters.alertLevel)
  }
  
  if (filters.enabled !== '') {
    rules = rules.filter(rule => rule.enabled === (filters.enabled === 'true'))
  }
  
  return rules
})

const enabledRulesCount = computed(() => 
  monitorRules.value.filter(rule => rule.enabled).length
)

const disabledRulesCount = computed(() => 
  monitorRules.value.filter(rule => !rule.enabled).length
)

const builtinRulesCount = computed(() => 
  monitorRules.value.filter(rule => rule.ruleType === 'BUILTIN').length
)

// Methods
const loadRules = async () => {
  try {
    loading.value = true
    // 模拟API调用
    await new Promise(resolve => setTimeout(resolve, 500))
  } catch (error: any) {
    ElMessage.error('加载规则失败')
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  // 搜索逻辑在computed中处理
}

const handleFilterChange = () => {
  // 过滤逻辑在computed中处理
}

const handleCategoryChange = () => {
  // 分类变化处理
}

const resetFilters = () => {
  searchKeyword.value = ''
  Object.assign(filters, {
    ruleType: '',
    alertLevel: '',
    enabled: ''
  })
}

const handleToggleRule = async (rule: MonitorRule) => {
  try {
    // 调用API切换规则状态
    ElMessage.success(`规则已${rule.enabled ? '启用' : '禁用'}`)
  } catch (error: any) {
    rule.enabled = !rule.enabled // 回滚状态
    ElMessage.error('操作失败')
  }
}

const handleRuleAction = async (action: string, rule: MonitorRule) => {
  switch (action) {
    case 'edit':
      editRule(rule)
      break
    case 'test':
      await testRule(rule)
      break
    case 'clone':
      cloneRule(rule)
      break
    case 'delete':
      await deleteRule(rule)
      break
  }
}

const editRule = (rule: MonitorRule) => {
  editingRule.value = rule
  Object.assign(ruleForm, {
    ruleName: rule.ruleName,
    alertLevel: rule.alertLevel,
    alertType: rule.alertType,
    priority: rule.priority || 5,
    description: rule.description || '',
    ruleExpression: rule.ruleExpression,
    alertMessage: rule.alertMessage,
    enabled: rule.enabled
  })
  showCreateDialog.value = true
}

const cloneRule = (rule: MonitorRule) => {
  editingRule.value = null
  Object.assign(ruleForm, {
    ruleName: rule.ruleName + ' (副本)',
    alertLevel: rule.alertLevel,
    alertType: rule.alertType,
    priority: rule.priority || 5,
    description: rule.description || '',
    ruleExpression: rule.ruleExpression,
    alertMessage: rule.alertMessage,
    enabled: false
  })
  showCreateDialog.value = true
}

const deleteRule = async (rule: MonitorRule) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除规则"${rule.ruleName}"吗？此操作不可恢复。`,
      '删除确认',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    
    // 删除规则
    const index = monitorRules.value.findIndex(r => r.id === rule.id)
    if (index > -1) {
      monitorRules.value.splice(index, 1)
    }
    
    ElMessage.success('规则删除成功')
    
  } catch (error) {
    // 用户取消删除
  }
}

const testRule = async (rule: MonitorRule) => {
  try {
    testingRule.value = true
    
    // 模拟测试规则
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    testResult.success = Math.random() > 0.3 // 70%成功率
    testResult.message = testResult.success 
      ? '规则表达式语法正确，可以正常执行'
      : '规则表达式存在语法错误，请检查'
    testResult.details = testResult.success 
      ? '测试数据: account.healthScore = 65\n结果: true (触发告警)'
      : '错误位置: 第1行第15个字符\n错误信息: 未定义的字段'
    
    showTestResult.value = true
    
  } catch (error: any) {
    ElMessage.error('测试失败')
  } finally {
    testingRule.value = false
  }
}

const testRuleExpression = async () => {
  if (!ruleForm.ruleExpression) {
    ElMessage.warning('请输入规则表达式')
    return
  }
  
  await testRule({
    ruleExpression: ruleForm.ruleExpression
  } as MonitorRule)
}

const saveRule = async () => {
  try {
    await ruleFormRef.value?.validate()
    
    savingRule.value = true
    
    // 模拟保存
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    if (editingRule.value) {
      // 更新现有规则
      Object.assign(editingRule.value, ruleForm, {
        updatedAt: new Date().toISOString()
      })
      ElMessage.success('规则更新成功')
    } else {
      // 创建新规则
      const newRule: MonitorRule = {
        id: Date.now().toString(),
        tenantId: 'tenant-001',
        ruleType: MonitorRuleType.CUSTOM,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
        ...ruleForm
      }
      monitorRules.value.unshift(newRule)
      ElMessage.success('规则创建成功')
    }
    
    showCreateDialog.value = false
    resetRuleForm()
    
  } catch (error: any) {
    // 表单验证失败或保存失败
  } finally {
    savingRule.value = false
  }
}

const resetRuleForm = () => {
  editingRule.value = null
  Object.assign(ruleForm, {
    ruleName: '',
    alertLevel: AlertLevel.WARNING,
    alertType: '' as AlertType,
    priority: 5,
    description: '',
    ruleExpression: '',
    alertMessage: '',
    enabled: true
  })
  ruleFormRef.value?.clearValidate()
}

const handleImportRules = () => {
  ElMessage.info('导入功能开发中...')
}

const handleExportRules = () => {
  ElMessage.info('导出功能开发中...')
}

// 工具函数
const getAlertLevelType = (level: AlertLevel): 'primary' | 'success' | 'warning' | 'danger' | 'info' => {
  return ALERT_LEVEL_CONFIG[level]?.type || 'info'
}

const getAlertLevelText = (level: AlertLevel): string => {
  return ALERT_LEVEL_CONFIG[level]?.text || level
}

const getAlertTypeText = (type: AlertType): string => {
  return ALERT_TYPE_CONFIG[type]?.text || type
}

const truncateExpression = (expression: string): string => {
  return expression.length > 50 ? expression.substring(0, 50) + '...' : expression
}

// 生命周期
onMounted(() => {
  loadRules()
})
</script>

<style scoped lang="scss">
.monitor-rules {
  padding: 20px;
  background: var(--el-bg-color-page);
  
  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    padding: 20px;
    background: var(--el-bg-color);
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.06);
    
    .header-left {
      .page-title {
        display: flex;
        align-items: center;
        gap: 8px;
        margin: 0 0 12px 0;
        font-size: 24px;
        font-weight: 600;
        color: var(--el-text-color-primary);
      }
      
      .header-info {
        display: flex;
        gap: 8px;
      }
    }
  }
  
  .rule-categories {
    margin-bottom: 20px;
    background: var(--el-bg-color);
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.06);
    padding: 0 20px;
    
    :deep(.el-tabs__nav-wrap::after) {
      display: none;
    }
  }
  
  .filter-card {
    margin-bottom: 20px;
    border: none;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
    
    .filter-container {
      display: flex;
      justify-content: space-between;
      align-items: center;
      flex-wrap: wrap;
      gap: 12px;
      
      .filter-left {
        display: flex;
        gap: 12px;
        align-items: center;
        flex-wrap: wrap;
      }
      
      .filter-right {
        display: flex;
        gap: 8px;
      }
    }
  }
  
  .rules-grid {
    .rule-card {
      height: 100%;
      border: 1px solid var(--el-border-color-light);
      transition: all 0.3s ease;
      
      &:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
      }
      
      &.rule-disabled {
        opacity: 0.6;
        
        .rule-header .rule-name {
          text-decoration: line-through;
        }
      }
      
      .rule-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        
        .rule-title {
          flex: 1;
          
          .rule-name {
            display: block;
            font-weight: 600;
            color: var(--el-text-color-primary);
            margin-bottom: 4px;
            font-size: 16px;
          }
        }
        
        .rule-actions {
          display: flex;
          align-items: center;
          gap: 8px;
        }
      }
      
      .rule-content {
        .rule-description {
          color: var(--el-text-color-regular);
          font-size: 14px;
          line-height: 1.5;
          margin-bottom: 16px;
          min-height: 42px;
        }
        
        .rule-details {
          margin-bottom: 16px;
          
          .detail-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
            
            .detail-label {
              color: var(--el-text-color-secondary);
              font-size: 13px;
            }
            
            .detail-value {
              color: var(--el-text-color-primary);
              font-size: 13px;
              font-weight: 500;
            }
          }
        }
        
        .rule-expression {
          padding: 8px;
          background: var(--el-bg-color-page);
          border-radius: 4px;
          border-left: 3px solid var(--el-color-primary);
          
          code {
            font-family: 'Consolas', 'Monaco', monospace;
            font-size: 12px;
            color: var(--el-text-color-primary);
            white-space: pre-wrap;
            word-break: break-all;
          }
        }
      }
    }
    
    .empty-rules {
      grid-column: 1 / -1;
      padding: 60px 20px;
      text-align: center;
    }
  }
  
  .form-help {
    margin-top: 4px;
    font-size: 12px;
  }
  
  .expression-help {
    h4 {
      margin: 16px 0 8px 0;
      font-size: 16px;
      color: var(--el-text-color-primary);
      
      &:first-child {
        margin-top: 0;
      }
    }
    
    ul {
      margin: 0 0 16px 0;
      padding-left: 20px;
      
      li {
        margin-bottom: 4px;
        line-height: 1.5;
        
        code {
          background: var(--el-bg-color-page);
          padding: 2px 4px;
          border-radius: 2px;
          font-family: 'Consolas', 'Monaco', monospace;
          font-size: 13px;
        }
      }
    }
  }
  
  .test-result {
    .test-details {
      margin-top: 16px;
      
      h4 {
        margin: 0 0 8px 0;
        font-size: 14px;
        color: var(--el-text-color-primary);
      }
      
      pre {
        background: var(--el-bg-color-page);
        padding: 12px;
        border-radius: 4px;
        font-size: 12px;
        line-height: 1.4;
        white-space: pre-wrap;
        word-break: break-word;
      }
    }
  }
}

// 响应式布局
@media (max-width: 768px) {
  .monitor-rules {
    padding: 12px;
    
    .page-header {
      flex-direction: column;
      gap: 16px;
      align-items: flex-start;
    }
    
    .filter-container {
      .filter-left {
        width: 100%;
        
        .el-input,
        .el-select {
          width: 100% !important;
          margin-bottom: 8px;
        }
      }
      
      .filter-right {
        width: 100%;
        justify-content: flex-end;
      }
    }
    
    .rules-grid {
      :deep(.el-col) {
        width: 100% !important;
      }
    }
  }
}
</style>