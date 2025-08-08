<script setup lang="ts">
import { ref, reactive, computed, onMounted } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";
import { Plus, Refresh, RefreshLeft, VideoPlay, VideoPause, Warning, Search } from "@element-plus/icons-vue";
import { useRouter } from "vue-router";
import { useAccountStore } from "@/stores/modules/account";
import { accountApi } from "@/api/account";
import type { WeWorkAccount, AccountSearchForm, AccountStatus } from "@/types/account";

const router = useRouter();
const store = useAccountStore();

// 搜索表单
const searchForm = reactive<Partial<AccountSearchForm>>({
  accountName: "",
  status: undefined,
  pageNum: 1,
  pageSize: 20,
});

const loading = computed(() => store.loading);
const dataSource = computed(() => store.accountList);
const pagination = computed(() => store.pagination);
const statistics = computed(() => store.statistics);

const multipleSelection = ref<WeWorkAccount[]>([]);

// 状态选项
const statusOptions: Array<{ label: string; value: AccountStatus }> = [
  { label: "在线", value: "ONLINE" },
  { label: "离线", value: "OFFLINE" },
  { label: "异常", value: "ERROR" },
  { label: "初始化中", value: "INITIALIZING" },
  { label: "等待扫码", value: "WAITING_QR" },
  { label: "等待确认", value: "WAITING_CONFIRM" },
  { label: "验证中", value: "VERIFYING" },
  { label: "恢复中", value: "RECOVERING" },
];

const statusTagType = (status?: AccountStatus) => {
  const map: Record<AccountStatus, "success" | "warning" | "danger" | "info"> = {
    ONLINE: "success",
    OFFLINE: "info",
    ERROR: "danger",
    INITIALIZING: "info",
    WAITING_QR: "warning",
    WAITING_CONFIRM: "warning",
    VERIFYING: "warning",
    RECOVERING: "warning",
  } as any;
  return status ? map[status] : "info";
};

// 行选择
const handleSelectionChange = (rows: WeWorkAccount[]) => {
  multipleSelection.value = rows;
};

// 列表加载
const fetchList = async () => {
  await store.fetchAccountList(searchForm);
};

const handleSearch = async () => {
  searchForm.pageNum = 1;
  await fetchList();
};

const handleReset = async () => {
  searchForm.accountName = "";
  searchForm.status = undefined;
  searchForm.pageNum = 1;
  searchForm.pageSize = 20;
  await fetchList();
};

const handlePageChange = async (page: number) => {
  searchForm.pageNum = page;
  await fetchList();
};

const handleSizeChange = async (size: number) => {
  searchForm.pageSize = size;
  searchForm.pageNum = 1;
  await fetchList();
};

// 单项操作
const login = async (row: WeWorkAccount) => {
  await accountApi.loginAccount(row.id);
  ElMessage.success("已触发登录");
  await store.refreshAccountStatus(row.id);
};
const logout = async (row: WeWorkAccount) => {
  await accountApi.logoutAccount(row.id);
  ElMessage.success("已触发登出");
  await store.refreshAccountStatus(row.id);
};
const restart = async (row: WeWorkAccount) => {
  await accountApi.restartAccount(row.id);
  ElMessage.success("已触发重启");
  await store.refreshAccountStatus(row.id);
};
const refreshStatus = async (row: WeWorkAccount) => {
  await store.refreshAccountStatus(row.id);
  ElMessage.success("状态已刷新");
};

// 批量运维
const batchHeartbeat = async () => {
  const res = await accountApi.batchHeartbeat();
  if (res.code === 200) {
    ElMessage.success("已触发批量心跳检测");
    await fetchList();
  }
};

const autoRecover = async () => {
  const confirm = await ElMessageBox.confirm(
    "将尝试自动恢复异常账号，是否继续？",
    "自动恢复",
    { type: "warning" },
  ).catch(() => false);
  if (!confirm) return;
  const res = await accountApi.autoRecoverErrorAccounts();
  if (res.code === 200) {
    ElMessage.success("已触发自动恢复");
    await fetchList();
  }
};

// 新建
const goCreate = () => router.push({ name: "AccountCreate" });

onMounted(async () => {
  await fetchList();
  await store.fetchAccountStatistics();
});
</script>

<template>
  <div class="account-list-container">
    <!-- 概览统计 -->
    <div class="stat-grid">
      <el-card shadow="never" class="stat-card">
        <div class="stat-title">总数</div>
        <div class="stat-value">{{ statistics.totalCount }}</div>
      </el-card>
      <el-card shadow="never" class="stat-card success">
        <div class="stat-title">在线</div>
        <div class="stat-value">{{ statistics.onlineCount }}</div>
      </el-card>
      <el-card shadow="never" class="stat-card info">
        <div class="stat-title">离线</div>
        <div class="stat-value">{{ statistics.offlineCount }}</div>
      </el-card>
      <el-card shadow="never" class="stat-card danger">
        <div class="stat-title">异常</div>
        <div class="stat-value">{{ statistics.errorCount }}</div>
      </el-card>
    </div>

    <!-- 搜索栏 -->
    <el-card shadow="never" class="search-card">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="账号名称">
          <el-input v-model="searchForm.accountName" placeholder="请输入关键词" clearable />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="全部" clearable style="width: 160px">
            <el-option v-for="opt in statusOptions" :key="opt.value" :label="opt.label" :value="opt.value" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :icon="Search" @click="handleSearch">搜索</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
        <el-form-item>
          <el-button type="success" :icon="Plus" @click="goCreate">新增账号</el-button>
          <el-button :icon="Refresh" @click="batchHeartbeat">批量心跳</el-button>
          <el-button type="warning" :icon="Warning" @click="autoRecover">自动恢复</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 列表表格 -->
    <el-card shadow="never">
      <el-table :data="dataSource" v-loading="loading" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="48" />
        <el-table-column prop="accountName" label="账号名称" min-width="180" show-overflow-tooltip />
        <el-table-column prop="weWorkGuid" label="企微GUID" min-width="180" show-overflow-tooltip />
        <el-table-column label="状态" width="120">
          <template #default="{ row }">
            <el-tag :type="statusTagType(row.status)">{{ row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="lastOnlineAt" label="最后在线" width="160" />
        <el-table-column prop="updatedAt" label="更新时间" width="160" />
        <el-table-column label="操作" width="300" fixed="right">
          <template #default="{ row }">
            <el-button link type="primary" :icon="VideoPlay" @click="login(row)">登录</el-button>
            <el-button link type="primary" :icon="VideoPause" @click="logout(row)">登出</el-button>
            <el-button link type="warning" :icon="RefreshLeft" @click="restart(row)">重启</el-button>
            <el-button link @click="refreshStatus(row)">刷新状态</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="table-footer">
        <el-pagination
          background
          layout="total, sizes, prev, pager, next, jumper"
          :total="pagination.total"
          :current-page="pagination.pageNum"
          :page-size="pagination.pageSize"
          :page-sizes="[10, 20, 50, 100]"
          @current-change="handlePageChange"
          @size-change="handleSizeChange"
        />
      </div>
    </el-card>
  </div>
</template>

<style scoped lang="scss">
.account-list-container {
  padding: 20px;
}

.stat-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 12px;
  margin-bottom: 12px;
}
.stat-card {
  .stat-title {
    color: #909399;
    font-size: 12px;
  }
  .stat-value {
    font-size: 22px;
    font-weight: 600;
    margin-top: 4px;
  }
  &.success .stat-value { color: #67c23a; }
  &.info .stat-value { color: #909399; }
  &.danger .stat-value { color: #f56c6c; }
}

.search-card {
  margin-bottom: 12px;
}

.table-footer {
  display: flex;
  justify-content: flex-end;
  padding-top: 12px;
}
</style>
