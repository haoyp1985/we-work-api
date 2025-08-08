<script setup lang="ts">
import { onMounted, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import { ElMessage } from "element-plus";
import { useAccountStore } from "@/stores/modules/account";
import { accountApi } from "@/api/account";

const route = useRoute();
const router = useRouter();
const store = useAccountStore();

const accountId = route.params.id as string;
const loading = ref(false);
const logsLoading = ref(false);
const statusLogs = ref<any[]>([]);

onMounted(async () => {
  if (!accountId) {
    ElMessage.error("缺少账号ID");
    router.back();
    return;
  }
  loading.value = true;
  try {
    await store.fetchAccountById(accountId);
    logsLoading.value = true;
    const res = await accountApi.getStatusLogsByAccountId(accountId, 50);
    if (res.code === 200) statusLogs.value = res.data || [];
  } finally {
    loading.value = false;
    logsLoading.value = false;
  }
});
</script>

<template>
  <div class="account-detail" v-loading="loading">
    <el-card shadow="never" class="base-card">
      <template #header>
        <div class="header">
          <h2>账号详情</h2>
          <el-button @click="$router.back()">返回</el-button>
        </div>
      </template>
      <el-descriptions :column="2" border v-if="store.currentAccount">
        <el-descriptions-item label="账号名称">{{ store.currentAccount.accountName }}</el-descriptions-item>
        <el-descriptions-item label="状态">{{ store.currentAccount.status }}</el-descriptions-item>
        <el-descriptions-item label="企微GUID">{{ store.currentAccount.weWorkGuid }}</el-descriptions-item>
        <el-descriptions-item label="类型">{{ (store.currentAccount as any).accountType }}</el-descriptions-item>
        <el-descriptions-item label="最后在线">{{ store.currentAccount.lastOnlineAt }}</el-descriptions-item>
        <el-descriptions-item label="更新时间">{{ store.currentAccount.updatedAt }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ store.currentAccount.remark }}</el-descriptions-item>
      </el-descriptions>
    </el-card>

    <el-card shadow="never" class="log-card" v-loading="logsLoading">
      <template #header><h3>最近状态变更</h3></template>
      <el-table :data="statusLogs">
        <el-table-column prop="id" label="日志ID" width="200" />
        <el-table-column prop="oldStatus" label="原状态" width="140" />
        <el-table-column prop="newStatus" label="新状态" width="140" />
        <el-table-column prop="reason" label="原因" min-width="200" />
        <el-table-column prop="errorMsg" label="错误信息" min-width="200" />
        <el-table-column prop="operatorId" label="操作人" width="180" />
        <el-table-column prop="createdAt" label="时间" width="180" />
      </el-table>
    </el-card>
  </div>
</template>

<style scoped lang="scss">
.account-detail { padding: 20px; }
.header { display: flex; justify-content: space-between; align-items: center; }
.base-card { margin-bottom: 12px; }
</style>


