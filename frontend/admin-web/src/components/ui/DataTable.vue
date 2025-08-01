<template>
  <div class="data-table">
    <!-- 表格工具栏 -->
    <div v-if="showToolbar" class="table-toolbar">
      <div class="toolbar-left">
        <slot name="toolbar-left">
          <div v-if="showSelection && selectedRows.length > 0" class="selection-info">
            <span class="selection-text">
              已选择 <strong>{{ selectedRows.length }}</strong> 项
            </span>
            <el-button 
              link 
              size="small"
              @click="clearSelection"
            >
              取消选择
            </el-button>
          </div>
        </slot>
      </div>
      
      <div class="toolbar-right">
        <slot name="toolbar-right">
          <!-- 批量操作按钮 -->
          <div v-if="batchActions.length > 0 && selectedRows.length > 0" class="batch-actions">
            <el-dropdown @command="handleBatchAction">
              <el-button type="primary">
                批量操作
                <el-icon class="el-icon--right">
                  <ArrowDown />
                </el-icon>
              </el-button>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item
                    v-for="action in batchActions"
                    :key="action.key"
                    :command="action.key"
                    :disabled="action.disabled"
                  >
                    <el-icon v-if="action.icon">
                      <component :is="action.icon" />
                    </el-icon>
                    {{ action.label }}
                  </el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </div>
          
          <!-- 表格配置 -->
          <el-tooltip content="表格设置" placement="top">
            <el-button 
              circle 
              @click="showColumnSettings = true"
              :icon="Setting"
            />
          </el-tooltip>
          
          <!-- 刷新按钮 -->
          <el-tooltip content="刷新数据" placement="top">
            <el-button 
              circle 
              :loading="loading"
              @click="handleRefresh"
              :icon="Refresh"
            />
          </el-tooltip>
        </slot>
      </div>
    </div>

    <!-- 表格主体 -->
    <el-table
      ref="tableRef"
      :data="tableData"
      :loading="loading"
      :border="border"
      :stripe="stripe"
      :size="size"
      :height="height"
      :max-height="maxHeight"
      :row-key="rowKey"
      :default-sort="defaultSort"
      :show-summary="showSummary"
      :sum-text="sumText"
      :summary-method="props.summaryMethod"
      @selection-change="handleSelectionChange"
      @sort-change="handleSortChange"
      @row-click="handleRowClick"
      v-bind="$attrs"
      class="enhanced-table"
    >
      <!-- 选择列 -->
      <el-table-column
        v-if="showSelection"
        type="selection"
        width="55"
        align="center"
        fixed="left"
      />
      
      <!-- 序号列 -->
      <el-table-column
        v-if="showIndex"
        type="index"
        label="序号"
        width="80"
        align="center"
        fixed="left"
        :index="getRowIndex"
      />
      
      <!-- 动态列 -->
      <el-table-column
        v-for="column in visibleColumns"
        :key="column.prop"
        :prop="column.prop"
        :label="column.label"
        :width="column.width"
        :min-width="column.minWidth"
        :fixed="column.fixed"
        :sortable="column.sortable"
        :show-overflow-tooltip="column.showOverflowTooltip"
        :align="column.align"
        :class-name="column.className"
      >
        <template #default="scope">
          <slot
            :name="column.prop"
            :row="scope.row"
            :column="column"
            :index="scope.$index"
          >
            <!-- 状态渲染 -->
            <template v-if="column.type === 'status'">
              <el-tag
                :type="getStatusTagType(scope.row[column.prop], column.statusMap)"
                :effect="column.tagEffect || 'light'"
                size="small"
              >
                {{ getStatusText(scope.row[column.prop], column.statusMap) }}
              </el-tag>
            </template>
            
            <!-- 时间渲染 -->
            <template v-else-if="column.type === 'datetime'">
              {{ formatDateTime(scope.row[column.prop], column.format) }}
            </template>
            
            <!-- 数字渲染 -->
            <template v-else-if="column.type === 'number'">
              {{ formatNumber(scope.row[column.prop], column.precision, column.unit) }}
            </template>
            
            <!-- 百分比渲染 -->
            <template v-else-if="column.type === 'percentage'">
              <el-progress
                :percentage="scope.row[column.prop]"
                :color="getProgressColor(scope.row[column.prop])"
                :stroke-width="6"
                :show-text="false"
                style="width: 80px;"
              />
              <span class="percentage-text">{{ scope.row[column.prop] }}%</span>
            </template>
            
            <!-- 操作按钮 -->
            <template v-else-if="column.type === 'actions'">
              <div class="table-actions">
                <template v-for="action in column.actions" :key="action.key">
                  <el-button
                    v-if="!action.hidden || !action.hidden(scope.row)"
                    :type="action.type || 'primary'"
                    :size="action.size || 'small'"
                    :disabled="action.disabled && action.disabled(scope.row)"
                    :loading="action.loading && action.loading(scope.row)"
                    link
                    @click="handleAction(action, scope.row, scope.$index)"
                  >
                    <el-icon v-if="action.icon">
                      <component :is="action.icon" />
                    </el-icon>
                    {{ action.label }}
                  </el-button>
                </template>
              </div>
            </template>
            
            <!-- 默认文本渲染 -->
            <template v-else>
              <span v-if="column.formatter">
                {{ column.formatter(scope.row, column, scope.row[column.prop]) }}
              </span>
              <span v-else>
                {{ scope.row[column.prop] }}
              </span>
            </template>
          </slot>
        </template>
      </el-table-column>
      
      <!-- 空状态 -->
      <template #empty>
        <slot name="empty">
          <el-empty description="暂无数据" :image-size="80" />
        </slot>
      </template>
    </el-table>

    <!-- 分页器 -->
    <div v-if="showPagination" class="table-pagination">
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :page-sizes="props.pageSizes"
        :total="props.total"
        :background="true"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>

    <!-- 列设置弹窗 -->
    <el-dialog
      v-model="showColumnSettings"
      title="列设置"
      width="400px"
      :close-on-click-modal="false"
    >
      <div class="column-settings">
        <div class="settings-header">
          <el-checkbox
            v-model="allColumnsVisible"
            :indeterminate="isIndeterminate"
            @change="handleCheckAllChange"
          >
            全选
          </el-checkbox>
          <el-button link @click="resetColumnSettings">
            重置
          </el-button>
        </div>
        
        <el-checkbox-group v-model="visibleColumnProps" @change="handleColumnVisibilityChange">
          <div v-for="column in columns" :key="column.prop" class="column-item">
            <el-checkbox :label="column.prop">
              {{ column.label }}
            </el-checkbox>
          </div>
        </el-checkbox-group>
      </div>
      
      <template #footer>
        <el-button @click="showColumnSettings = false">取消</el-button>
        <el-button type="primary" @click="showColumnSettings = false">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { ArrowDown, Setting, Refresh } from '@element-plus/icons-vue'
import dayjs from 'dayjs'

// Types
interface TableColumn {
  prop: string
  label: string
  width?: string | number
  minWidth?: string | number
  fixed?: boolean | string
  sortable?: boolean
  showOverflowTooltip?: boolean
  align?: 'left' | 'center' | 'right'
  className?: string
  type?: 'text' | 'status' | 'datetime' | 'number' | 'percentage' | 'actions'
  formatter?: (row: any, column: any, cellValue: any) => string
  hidden?: boolean
  
  // 状态类型特有属性
  statusMap?: Record<string, { text: string; type: string }>
  tagEffect?: 'dark' | 'light' | 'plain'
  
  // 时间类型特有属性
  format?: string
  
  // 数字类型特有属性
  precision?: number
  unit?: string
  
  // 操作类型特有属性
  actions?: TableAction[]
}

interface TableAction {
  key: string
  label: string
  type?: 'primary' | 'success' | 'warning' | 'danger' | 'info'
  size?: 'large' | 'default' | 'small'
  icon?: any
  hidden?: (row: any) => boolean
  disabled?: (row: any) => boolean
  loading?: (row: any) => boolean
}

interface BatchAction {
  key: string
  label: string
  icon?: any
  disabled?: boolean
}

// Props
interface Props {
  data: any[]
  columns: TableColumn[]
  loading?: boolean
  border?: boolean
  stripe?: boolean
  size?: 'large' | 'default' | 'small'
  height?: string | number
  maxHeight?: string | number
  rowKey?: string
  defaultSort?: { prop: string; order: 'ascending' | 'descending' }
  
  // 功能开关
  showToolbar?: boolean
  showSelection?: boolean
  showIndex?: boolean
  showPagination?: boolean
  showSummary?: boolean
  
  // 分页
  currentPage?: number
  pageSize?: number
  total?: number
  pageSizes?: number[]
  
  // 批量操作
  batchActions?: BatchAction[]
  
  // 汇总
  sumText?: string
  summaryMethod?: (data: { columns: any[]; data: any[] }) => string[]
}

const props = withDefaults(defineProps<Props>(), {
  loading: false,
  border: true,
  stripe: false,
  size: 'default',
  showToolbar: true,
  showSelection: false,
  showIndex: false,
  showPagination: true,
  showSummary: false,
  currentPage: 1,
  pageSize: 20,
  total: 0,
  pageSizes: () => [10, 20, 50, 100],
  batchActions: () => [],
  sumText: '合计'
})

// Emits
const emit = defineEmits<{
  'update:currentPage': [page: number]
  'update:pageSize': [size: number]
  selectionChange: [selection: any[]]
  sortChange: [sort: { prop: string; order: string }]
  rowClick: [row: any, column: any, event: Event]
  action: [action: TableAction, row: any, index: number]
  batchAction: [action: string, rows: any[]]
  refresh: []
}>()

// Refs
const tableRef = ref()
const showColumnSettings = ref(false)
const selectedRows = ref<any[]>([])
const visibleColumnProps = ref<string[]>([])

// 内部分页状态
const currentPage = ref(1)
const pageSize = ref(20)

// Computed
const tableData = computed(() => props.data)

const visibleColumns = computed(() => {
  return props.columns.filter(column => 
    !column.hidden && visibleColumnProps.value.includes(column.prop)
  )
})

const allColumnsVisible = computed({
  get: () => visibleColumnProps.value.length === props.columns.length,
  set: (val: any) => {
    const checked = Boolean(val)
    if (checked) {
      visibleColumnProps.value = props.columns.map(col => col.prop)
    } else {
      visibleColumnProps.value = []
    }
  }
})

const isIndeterminate = computed(() => {
  const visibleCount = visibleColumnProps.value.length
  return visibleCount > 0 && visibleCount < props.columns.length
})

// Methods
const handleSelectionChange = (selection: any[]) => {
  selectedRows.value = selection
  emit('selectionChange', selection)
}

const handleSortChange = (sort: any) => {
  emit('sortChange', sort)
}

const handleRowClick = (row: any, column: any, event: Event) => {
  emit('rowClick', row, column, event)
}

const handleAction = (action: TableAction, row: any, index: number) => {
  emit('action', action, row, index)
}

const handleBatchAction = (actionKey: string) => {
  emit('batchAction', actionKey, selectedRows.value)
}

const handleRefresh = () => {
  emit('refresh')
}

const handleSizeChange = (size: number) => {
  pageSize.value = size
  emit('update:pageSize', size)
}

const handleCurrentChange = (page: number) => {
  currentPage.value = page
  emit('update:currentPage', page)
}

const clearSelection = () => {
  tableRef.value?.clearSelection()
}

const getRowIndex = (index: number) => {
  return (currentPage.value - 1) * pageSize.value + index + 1
}

const getStatusTagType = (status: string, statusMap?: Record<string, any>) => {
  return statusMap?.[status]?.type || 'info'
}

const getStatusText = (status: string, statusMap?: Record<string, any>) => {
  return statusMap?.[status]?.text || status
}

const formatDateTime = (value: string, format = 'YYYY-MM-DD HH:mm:ss') => {
  if (!value) return '-'
  return dayjs(value).format(format)
}

const formatNumber = (value: number, precision = 0, unit = '') => {
  if (value === null || value === undefined) return '-'
  const formatted = precision > 0 ? value.toFixed(precision) : value.toString()
  return formatted + unit
}

const getProgressColor = (percentage: number) => {
  if (percentage < 30) return '#f56c6c'
  if (percentage < 70) return '#e6a23c'
  return '#67c23a'
}

const handleCheckAllChange = (val: any) => {
  const checked = Boolean(val)
  visibleColumnProps.value = checked ? props.columns.map(col => col.prop) : []
}

const handleColumnVisibilityChange = () => {
  // 列可见性变化处理
}

const resetColumnSettings = () => {
  visibleColumnProps.value = props.columns.map(col => col.prop)
}

// 初始化可见列
const initVisibleColumns = () => {
  visibleColumnProps.value = props.columns
    .filter(col => !col.hidden)
    .map(col => col.prop)
}

// Watchers
watch(() => props.columns, () => {
  initVisibleColumns()
}, { immediate: true })

// 同步props到内部状态
watch(() => props.currentPage, (newPage) => {
  if (newPage !== undefined) {
    currentPage.value = newPage
  }
}, { immediate: true })

watch(() => props.pageSize, (newSize) => {
  if (newSize !== undefined) {
    pageSize.value = newSize
  }
}, { immediate: true })

// 暴露方法
defineExpose({
  clearSelection,
  getSelectedRows: () => selectedRows.value,
  getTableRef: () => tableRef.value
})
</script>

<style scoped lang="scss">
.data-table {
  .table-toolbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
    
    .toolbar-left {
      .selection-info {
        display: flex;
        align-items: center;
        gap: 12px;
        
        .selection-text {
          color: var(--el-text-color-regular);
          font-size: 14px;
        }
      }
    }
    
    .toolbar-right {
      display: flex;
      gap: 8px;
      align-items: center;
      
      .batch-actions {
        margin-right: 8px;
      }
    }
  }
  
  .enhanced-table {
    .table-actions {
      display: flex;
      gap: 8px;
      align-items: center;
    }
    
    .percentage-text {
      margin-left: 8px;
      font-size: 12px;
      color: var(--el-text-color-secondary);
    }
  }
  
  .table-pagination {
    margin-top: 16px;
    display: flex;
    justify-content: flex-end;
  }
  
  .column-settings {
    .settings-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 16px;
      padding-bottom: 12px;
      border-bottom: 1px solid var(--el-border-color-lighter);
    }
    
    .column-item {
      margin-bottom: 8px;
    }
  }
}
</style>