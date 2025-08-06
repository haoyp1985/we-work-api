/**
 * 用户状态管理模块
 * WeWork Management Platform - Frontend
 */

import { defineStore } from "pinia";
import { ref, computed } from "vue";
import { authApi } from "@/api/auth";
import { getToken, setToken, removeToken } from "@/utils/auth";
import router from "@/router";
import type {
  User,
  Role,
  Permission,
  LoginForm,
  LoginResponse,
} from "@/types/user";

export const useUserStore = defineStore("user", () => {
  // ===== State =====
  const userInfo = ref<User>({
    id: "",
    tenantId: "",
    username: "",
    nickname: "",
    email: "",
    phone: "",
    avatar: "",
    status: "active",
    createdAt: "",
    updatedAt: "",
  });

  const roles = ref<Role[]>([]);
  const permissions = ref<Permission[]>([]);
  const token = ref<string>(getToken() || "");
  const isLoggedIn = ref<boolean>(!!getToken());

  // ===== Getters =====
  const permissionCodes = computed(() =>
    permissions.value.map((permission) => permission.permissionCode),
  );

  const roleCodes = computed(() => roles.value.map((role) => role.roleCode));

  const isAdmin = computed(
    () =>
      roleCodes.value.includes("SUPER_ADMIN") ||
      roleCodes.value.includes("TENANT_ADMIN"),
  );

  const menuPermissions = computed(() =>
    permissions.value.filter(
      (permission) => permission.permissionType === "MENU",
    ),
  );

  const buttonPermissions = computed(() =>
    permissions.value.filter(
      (permission) => permission.permissionType === "BUTTON",
    ),
  );

  // ===== Actions =====

  /**
   * 用户登录
   */
  const login = async (loginForm: LoginForm): Promise<LoginResponse> => {
    try {
      const response = await authApi.login(loginForm);

      if (response.code === 200) {
        const {
          token: newToken,
          userInfo: userData,
          roles: userRoles,
          permissions: userPermissions,
        } = response.data;

        // 设置token
        token.value = newToken;
        setToken(newToken);

        // 设置用户信息
        userInfo.value = userData;
        roles.value = userRoles;
        permissions.value = userPermissions;
        isLoggedIn.value = true;

        return response.data;
      } else {
        throw new Error(response.message || "登录失败");
      }
    } catch (error) {
      console.error("登录失败:", error);
      throw error;
    }
  };

  /**
   * 获取用户信息
   */
  const getUserInfo = async (): Promise<User> => {
    try {
      const response = await authApi.getUserInfo();

      if (response.code === 200) {
        const {
          userInfo: userData,
          roles: userRoles,
          permissions: userPermissions,
        } = response.data;

        userInfo.value = userData;
        roles.value = userRoles;
        permissions.value = userPermissions;

        return userData;
      } else {
        throw new Error(response.message || "获取用户信息失败");
      }
    } catch (error) {
      console.error("获取用户信息失败:", error);
      // 清除无效token
      logout();
      throw error;
    }
  };

  /**
   * 刷新Token
   */
  const refreshToken = async (): Promise<string> => {
    try {
      const response = await authApi.refreshToken();

      if (response.code === 200) {
        const newToken = response.data.token;
        token.value = newToken;
        setToken(newToken);
        return newToken;
      } else {
        throw new Error("Token刷新失败");
      }
    } catch (error) {
      console.error("Token刷新失败:", error);
      logout();
      throw error;
    }
  };

  /**
   * 用户登出
   */
  const logout = async (): Promise<void> => {
    try {
      // 调用后端登出接口
      if (token.value) {
        await authApi.logout();
      }
    } catch (error) {
      console.error("登出接口调用失败:", error);
    } finally {
      // 清除本地状态
      clearUserState();

      // 跳转到登录页
      router.push("/login");
    }
  };

  /**
   * 清除用户状态
   */
  const clearUserState = (): void => {
    userInfo.value = {
      id: "",
      tenantId: "",
      username: "",
      nickname: "",
      email: "",
      phone: "",
      avatar: "",
      status: "active",
      createdAt: "",
      updatedAt: "",
    };
    roles.value = [];
    permissions.value = [];
    token.value = "";
    isLoggedIn.value = false;
    removeToken();
  };

  /**
   * 检查是否有指定权限
   */
  const hasPermission = (permissionCode: string): boolean => {
    // 超级管理员拥有所有权限
    if (isAdmin.value) {
      return true;
    }

    return permissionCodes.value.includes(permissionCode);
  };

  /**
   * 检查是否有指定角色
   */
  const hasRole = (roleCode: string): boolean => {
    return roleCodes.value.includes(roleCode);
  };

  /**
   * 检查是否有任一权限
   */
  const hasAnyPermission = (permissionCodeList: string[]): boolean => {
    if (isAdmin.value) {
      return true;
    }

    return permissionCodeList.some((code) =>
      permissionCodes.value.includes(code),
    );
  };

  /**
   * 检查是否有任一角色
   */
  const hasAnyRole = (roleCodeList: string[]): boolean => {
    return roleCodeList.some((code) => roleCodes.value.includes(code));
  };

  /**
   * 更新用户资料
   */
  const updateProfile = async (profileData: Partial<User>): Promise<User> => {
    try {
      const response = await authApi.updateProfile(profileData);

      if (response.code === 200) {
        // 更新本地用户信息
        userInfo.value = { ...userInfo.value, ...response.data };
        return response.data;
      } else {
        throw new Error(response.message || "更新用户资料失败");
      }
    } catch (error) {
      console.error("更新用户资料失败:", error);
      throw error;
    }
  };

  /**
   * 修改密码
   */
  const changePassword = async (
    oldPassword: string,
    newPassword: string,
  ): Promise<void> => {
    try {
      const response = await authApi.changePassword({
        oldPassword,
        newPassword,
      });

      if (response.code !== 200) {
        throw new Error(response.message || "修改密码失败");
      }
    } catch (error) {
      console.error("修改密码失败:", error);
      throw error;
    }
  };

  /**
   * 上传头像
   */
  const uploadAvatar = async (file: File): Promise<string> => {
    try {
      const response = await authApi.uploadAvatar(file);

      if (response.code === 200) {
        // 更新用户头像
        userInfo.value.avatar = response.data.avatarUrl;
        return response.data.avatarUrl;
      } else {
        throw new Error(response.message || "上传头像失败");
      }
    } catch (error) {
      console.error("上传头像失败:", error);
      throw error;
    }
  };

  // 初始化时检查token
  const initializeAuth = async (): Promise<void> => {
    const savedToken = getToken();
    if (savedToken) {
      token.value = savedToken;
      isLoggedIn.value = true;

      try {
        await getUserInfo();
      } catch (error) {
        // 如果获取用户信息失败，清除认证状态
        clearUserState();
      }
    }
  };

  return {
    // State
    userInfo,
    roles,
    permissions,
    token,
    isLoggedIn,

    // Getters
    permissionCodes,
    roleCodes,
    isAdmin,
    menuPermissions,
    buttonPermissions,

    // Actions
    login,
    logout,
    getUserInfo,
    refreshToken,
    clearUserState,
    hasPermission,
    hasRole,
    hasAnyPermission,
    hasAnyRole,
    updateProfile,
    changePassword,
    uploadAvatar,
    initializeAuth,
  };
});
