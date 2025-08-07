/**
 * 用户状态管理模块
 * WeWork Management Platform - Frontend
 */

import { defineStore } from "pinia";
import { ref, computed } from "vue";
import * as authApi from "@/api/auth";
import { 
  getToken, 
  setToken, 
  removeToken, 
  getRefreshToken,
  setRefreshToken,
  removeRefreshToken,
  setUserInfoCache,
  clearAuth
} from "@/utils/auth";
import router from "@/router";
import type {
  UserInfo,
  Role,
  Permission,
  LoginRequest,
  LoginResponse,
  UserStatus
} from "@/types/api";

export const useUserStore = defineStore("user", () => {
  // ===== State =====
  const userInfo = ref<UserInfo>({
    id: "",
    username: "",
    realName: "",
    email: "",
    phone: "",
    avatar: "",
    status: UserStatus.ACTIVE,
    roles: [],
    permissions: [],
    tenantId: "",
    organizationId: "",
    createdAt: "",
    updatedAt: "",
    lastLoginAt: ""
  });

  const token = ref<string>(getToken() || "");
  const refreshTokenValue = ref<string>(getRefreshToken() || "");
  const isLoggedIn = ref<boolean>(!!getToken());

  // ===== Getters =====
  const permissionCodes = computed(() => userInfo.value.permissions);

  const roleCodes = computed(() => 
    userInfo.value.roles.map((role) => role.code)
  );

  const isAdmin = computed(
    () =>
      roleCodes.value.includes("SUPER_ADMIN") ||
      roleCodes.value.includes("TENANT_ADMIN"),
  );

  // 删除了单独的menuPermissions和buttonPermissions计算属性
  // 因为权限信息现在直接存储在userInfo中

  // ===== Actions =====

  /**
   * 用户登录
   */
  const login = async (loginForm: LoginRequest): Promise<LoginResponse> => {
    try {
      const response = await authApi.login(loginForm);
      const data = response.data;

      // 设置token
      token.value = data.token;
      refreshTokenValue.value = data.refreshToken;
      setToken(data.token);
      setRefreshToken(data.refreshToken);

      // 设置用户信息
      userInfo.value = data.userInfo;
      setUserInfoCache(data.userInfo);
      isLoggedIn.value = true;

      return data;
    } catch (error) {
      console.error("登录失败:", error);
      throw error;
    }
  };

  /**
   * 获取用户信息
   */
  const getUserInfo = async (): Promise<UserInfo> => {
    try {
      const response = await authApi.getCurrentUser();
      const userData = response.data;

      userInfo.value = userData;
      return userData;
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
   * 刷新Token
   */
  const refreshAccessToken = async (): Promise<string> => {
    try {
      const response = await authApi.refreshToken(refreshTokenValue.value);
      const data = response.data;

      token.value = data.token;
      refreshTokenValue.value = data.refreshToken;
      setToken(data.token);
      setRefreshToken(data.refreshToken);
      
      return data.token;
    } catch (error) {
      console.error("Token刷新失败:", error);
      // Token刷新失败，清除登录状态
      logout();
      throw error;
    }
  };

  /**
   * 清除用户状态
   */
  const clearUserState = (): void => {
    userInfo.value = {
      id: "",
      username: "",
      realName: "",
      email: "",
      phone: "",
      avatar: "",
      status: UserStatus.ACTIVE,
      roles: [],
      permissions: [],
      tenantId: "",
      organizationId: "",
      createdAt: "",
      updatedAt: "",
      lastLoginAt: ""
    };
    token.value = "";
    refreshTokenValue.value = "";
    isLoggedIn.value = false;
    clearAuth();
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
  const updateProfile = async (profileData: Partial<UserInfo>): Promise<UserInfo> => {
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
    token,
    refreshToken: refreshTokenValue,
    isLoggedIn,

    // Getters
    permissionCodes,
    roleCodes,
    isAdmin,

    // Actions
    login,
    logout,
    getUserInfo,
    refreshAccessToken,
    clearUserState,
    hasPermission,
    hasRole,
    initializeAuth,
  };
});
