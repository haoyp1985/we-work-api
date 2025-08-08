<script setup lang="ts">
import { ref, reactive, computed, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import { ElMessage, ElMessageBox, type FormInstance, type FormRules } from "element-plus";
import { useAccountStore } from "@/stores/modules/account";
import type { AccountCreateForm, AccountUpdateForm, AccountType, AccountConfig } from "@/types/account";

const route = useRoute();
const router = useRouter();
const store = useAccountStore();

const isEdit = computed(() => route.name === "AccountEdit");
const accountId = computed(() => route.params.id as string);

const formRef = ref<FormInstance>();
const loading = ref(false);
const saving = ref(false);

// 表单模型
type LocalFormModel = (AccountCreateForm & Partial<AccountUpdateForm>) & { config: AccountConfig };
const formModel = reactive<LocalFormModel>({
  accountName: "",
  accountType: "ENTERPRISE" as AccountType,
  weWorkGuid: "",
  mobile: "",
  email: "",
  config: {
    messageSending: { enabled: true, maxPerDay: 2000, maxPerHour: 500, maxPerMinute: 60, interval: 1, retryCount: 3 },
    autoReply: { enabled: false, replyContent: "", replyDelay: 1, keywords: [] },
    friendManagement: { autoAcceptFriend: false, maxFriendCount: 5000, autoGreeting: false, greetingContent: "" },
    groupManagement: { autoJoinGroup: false, maxGroupCount: 100, autoReplyInGroup: false, groupReplyContent: "" },
    monitoring: { heartbeatInterval: 5, statusCheckInterval: 5, enableScreenshot: false, logLevel: "INFO" },
    security: { enableProxy: false, enableEncryption: true, maxLoginRetry: 5, loginTimeout: 30 },
  },
  tags: [],
  remark: "",
});

// 为模板提供稳定的配置引用，避免可选链引发的类型告警
const monitoring = computed(() => formModel.config!.monitoring);
const messageSending = computed(() => formModel.config!.messageSending);

// 规则
const rules: FormRules = {
  accountName: [
    { required: true, message: "请输入账号名称", trigger: "blur" },
    { min: 2, max: 50, message: "长度 2-50", trigger: "blur" },
  ],
  accountType: [{ required: true, message: "请选择账号类型", trigger: "change" }],
  weWorkGuid: [{ max: 50, message: "GUID 最长 50", trigger: "blur" }],
  email: [{ type: "email", message: "邮箱格式不正确", trigger: "blur" }],
};

const accountTypeOptions: Array<{ label: string; value: AccountType }> = [
  { label: "个人号", value: "PERSONAL" },
  { label: "企业号", value: "ENTERPRISE" },
  { label: "服务号", value: "SERVICE" },
];

// 加载（编辑）
const loadDetail = async () => {
  if (!isEdit.value || !accountId.value) return;
  loading.value = true;
  try {
    const data = await store.fetchAccountById(accountId.value);
    // 映射到表单
    formModel.accountName = data.accountName;
    formModel.accountType = (data as any).accountType || "ENTERPRISE";
    formModel.weWorkGuid = data.weWorkGuid;
    formModel.mobile = data.mobile;
    formModel.email = data.email;
    formModel.config = (data as any).config || formModel.config;
    formModel.tags = data.tags || [];
    formModel.remark = data.remark || "";
  } finally {
    loading.value = false;
  }
};

// 保存
const handleSubmit = async () => {
  if (!formRef.value) return;
  await formRef.value.validate();
  saving.value = true;
  try {
    if (isEdit.value && accountId.value) {
      const payload: AccountUpdateForm = {
        accountName: formModel.accountName,
        mobile: formModel.mobile,
        email: formModel.email,
        config: formModel.config,
        tags: formModel.tags,
        remark: formModel.remark,
      };
      await store.updateAccount(accountId.value, payload);
      ElMessage.success("更新成功");
    } else {
      const payload: AccountCreateForm = {
        accountName: formModel.accountName,
        accountType: formModel.accountType,
        weWorkGuid: formModel.weWorkGuid,
        mobile: formModel.mobile,
        email: formModel.email,
        config: formModel.config,
        tags: formModel.tags,
        remark: formModel.remark,
      };
      await store.createAccount(payload);
      ElMessage.success("创建成功");
    }
    router.push({ name: "AccountList" });
  } catch (e) {
    console.error(e);
  } finally {
    saving.value = false;
  }
};

const handleCancel = () => {
  router.back();
};

onMounted(() => {
  loadDetail();
});
</script>

<template>
  <div class="account-form-container" v-loading="loading">
    <el-card shadow="never">
      <template #header>
        <div class="form-header">
          <div class="titles">
            <h2>{{ isEdit ? "编辑账号" : "新增账号" }}</h2>
            <p class="subtitle">配置企微账号的基本信息、能力与监控参数</p>
          </div>
          <div class="actions">
            <el-button @click="handleCancel">取消</el-button>
            <el-button type="primary" :loading="saving" @click="handleSubmit">{{ isEdit ? "保存" : "创建" }}</el-button>
          </div>
        </div>
      </template>

      <el-form ref="formRef" :model="formModel" :rules="rules" label-width="110px" status-icon>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="账号名称" prop="accountName">
              <el-input v-model="formModel.accountName" placeholder="请输入账号名称" maxlength="50" show-word-limit />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="账号类型" prop="accountType">
              <el-select v-model="formModel.accountType" placeholder="请选择">
                <el-option v-for="opt in accountTypeOptions" :key="opt.value" :label="opt.label" :value="opt.value" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="企微GUID">
              <el-input v-model="formModel.weWorkGuid" placeholder="可选" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="手机">
              <el-input v-model="formModel.mobile" placeholder="可选" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="邮箱">
              <el-input v-model="formModel.email" placeholder="可选" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="备注">
              <el-input v-model="formModel.remark" placeholder="可选" />
            </el-form-item>
          </el-col>
        </el-row>

        <template v-if="formModel.config">
        <el-divider>监控配置</el-divider>
        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="心跳间隔(min)">
              <el-input-number v-model="formModel.config!.monitoring.heartbeatInterval" :min="1" :max="60" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="状态检查(min)">
              <el-input-number v-model="formModel.config!.monitoring.statusCheckInterval" :min="1" :max="60" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="日志级别">
              <el-select v-model="formModel.config!.monitoring.logLevel">
                <el-option label="DEBUG" value="DEBUG" />
                <el-option label="INFO" value="INFO" />
                <el-option label="WARN" value="WARN" />
                <el-option label="ERROR" value="ERROR" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-divider>消息发送</el-divider>
        <el-row :gutter="20">
          <el-col :span="6">
            <el-form-item label="启用发送">
              <el-switch v-model="formModel.config!.messageSending.enabled" />
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="日上限">
              <el-input-number v-model="formModel.config!.messageSending.maxPerDay" :min="0" :max="100000" />
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="小时上限">
              <el-input-number v-model="formModel.config!.messageSending.maxPerHour" :min="0" :max="10000" />
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="分钟上限">
              <el-input-number v-model="formModel.config!.messageSending.maxPerMinute" :min="0" :max="1000" />
            </el-form-item>
          </el-col>
        </el-row>
        </template>
      </el-form>
    </el-card>
  </div>
</template>

<style scoped lang="scss">
.account-form-container {
  padding: 20px;
}

.form-header {
  display: flex;
  justify-content: space-between;
  align-items: center;

  .subtitle {
    margin: 4px 0 0 0;
    color: #909399;
    font-size: 12px;
  }
}
</style>
