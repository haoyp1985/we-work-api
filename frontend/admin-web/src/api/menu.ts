import { http } from '@/utils/request'
import type { MenuItem } from '@/types'

/**
 * 获取用户菜单
 */
export const getMenus = () => {
  return http.get<MenuItem[]>('/auth/menus')
}

/**
 * 获取所有菜单（管理员用）
 */
export const getAllMenus = () => {
  return http.get<MenuItem[]>('/system/menus')
}

/**
 * 创建菜单
 */
export const createMenu = (data: Partial<MenuItem>) => {
  return http.post<MenuItem>('/system/menus', data)
}

/**
 * 更新菜单
 */
export const updateMenu = (id: string, data: Partial<MenuItem>) => {
  return http.put<MenuItem>(`/system/menus/${id}`, data)
}

/**
 * 删除菜单
 */
export const deleteMenu = (id: string) => {
  return http.delete(`/system/menus/${id}`)
}