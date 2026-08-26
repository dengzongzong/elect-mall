import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useAppStore = defineStore('app', () => {
  // 侧边栏折叠状态
  const sidebarCollapsed = ref(false)

  // 用户信息
  const userInfo = ref(JSON.parse(localStorage.getItem('admin_user') || 'null'))

  // 计算属性：是否已登录
  const isLoggedIn = computed(() => !!localStorage.getItem('admin_token'))

  // 切换侧边栏折叠
  function toggleSidebar() {
    sidebarCollapsed.value = !sidebarCollapsed.value
  }

  // 设置用户信息
  function setUserInfo(info) {
    userInfo.value = info
    localStorage.setItem('admin_user', JSON.stringify(info))
  }

  // 退出登录
  function logout() {
    userInfo.value = null
    localStorage.removeItem('admin_token')
    localStorage.removeItem('admin_user')
  }

  return {
    sidebarCollapsed,
    userInfo,
    isLoggedIn,
    toggleSidebar,
    setUserInfo,
    logout
  }
})