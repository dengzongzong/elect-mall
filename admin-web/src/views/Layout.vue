<template>
  <div class="layout-container">
    <!-- 左侧侧边栏 -->
    <el-aside :width="sidebarCollapsed ? '64px' : '220px'" class="layout-aside">
      <div class="logo-area">
        <img src="/logo.jpg" alt="得捷" class="logo-img" :class="{ collapsed: sidebarCollapsed }" />
      </div>
      <el-menu
        :default-active="activeMenu"
        :collapse="sidebarCollapsed"
        :router="true"
        background-color="#1d1e1f"
        text-color="#bfcbd9"
        active-text-color="#E60012"
        class="sidebar-menu"
      >
        <el-menu-item index="/dashboard">
          <el-icon><Odometer /></el-icon>
          <template #title>工作台</template>
        </el-menu-item>
        <el-menu-item index="/category">
          <el-icon><Collection /></el-icon>
          <template #title>分类管理</template>
        </el-menu-item>
        <el-menu-item index="/product">
          <el-icon><Goods /></el-icon>
          <template #title>商品管理</template>
        </el-menu-item>
        <el-menu-item index="/brand">
          <el-icon><Trophy /></el-icon>
          <template #title>品牌管理</template>
        </el-menu-item>
        <el-menu-item index="/bom">
          <el-icon><List /></el-icon>
          <template #title>BOM管理</template>
        </el-menu-item>
        <el-menu-item index="/inquiry">
          <el-icon><ChatLineRound /></el-icon>
          <template #title>询价管理</template>
        </el-menu-item>
        <el-menu-item index="/order">
          <el-icon><ShoppingCart /></el-icon>
          <template #title>订单管理</template>
        </el-menu-item>
        <el-menu-item index="/user">
          <el-icon><User /></el-icon>
          <template #title>用户管理</template>
        </el-menu-item>
        <el-menu-item index="/finance">
          <el-icon><Money /></el-icon>
          <template #title>财务管理</template>
        </el-menu-item>
        <el-sub-menu index="content">
          <template #title>
            <el-icon><Document /></el-icon>
            <span>内容管理</span>
          </template>
          <el-menu-item index="/news">
            <el-icon><News /></el-icon>
            <template #title>新闻管理</template>
          </el-menu-item>
          <el-menu-item index="/datasheet">
            <el-icon><Notebook /></el-icon>
            <template #title>数据手册</template>
          </el-menu-item>
          <el-menu-item index="/cooperate">
            <el-icon><Link /></el-icon>
            <template #title>合作品牌</template>
          </el-menu-item>
          <el-menu-item index="/partner">
            <el-icon><Handshake /></el-icon>
            <template #title>供应商合作</template>
          </el-menu-item>
        </el-sub-menu>
        <el-menu-item index="/message">
          <el-icon><Message /></el-icon>
          <template #title>消息通知</template>
        </el-menu-item>
        <el-menu-item index="/feedback">
          <el-icon><WarningFilled /></el-icon>
          <template #title>投诉反馈</template>
        </el-menu-item>
        <el-menu-item index="/carousel">
          <el-icon><Picture /></el-icon>
          <template #title>轮播图管理</template>
        </el-menu-item>
        <el-menu-item index="/homeblock">
          <el-icon><Grid /></el-icon>
          <template #title>首页配置</template>
        </el-menu-item>
        <el-menu-item index="/setting">
          <el-icon><Setting /></el-icon>
          <template #title>系统设置</template>
        </el-menu-item>
      </el-menu>
    </el-aside>

    <!-- 右侧主区域 -->
    <div class="layout-main">
      <!-- 顶部导航栏 -->
      <el-header class="layout-header">
        <div class="header-left">
          <el-icon class="collapse-btn" @click="toggleSidebar">
            <Fold v-if="!sidebarCollapsed" />
            <Expand v-else />
          </el-icon>
          <el-breadcrumb class="header-breadcrumb" separator="/">
            <el-breadcrumb-item :to="{ path: '/dashboard' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>{{ currentTitle }}</el-breadcrumb-item>
          </el-breadcrumb>
        </div>
        <div class="header-right">
          <el-icon class="header-icon"><Bell /></el-icon>
          <el-dropdown trigger="click" @command="handleCommand">
            <span class="user-info">
              <el-avatar :size="32" :icon="UserFilled" class="user-avatar" />
              <span class="username">{{ userInfo?.username || '管理员' }}</span>
              <el-icon class="el-icon--right"><ArrowDown /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="profile">
                  <el-icon><User /></el-icon>个人中心
                </el-dropdown-item>
                <el-dropdown-item command="logout" divided>
                  <el-icon><SwitchButton /></el-icon>退出登录
                </el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>

      <!-- 主内容区 -->
      <el-main class="layout-content">
        <router-view />
      </el-main>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAppStore } from '../stores/app'
import { ElMessageBox } from 'element-plus'

const router = useRouter()
const route = useRoute()
const appStore = useAppStore()

const sidebarCollapsed = computed(() => appStore.sidebarCollapsed)
const userInfo = computed(() => appStore.userInfo)

const currentTitle = computed(() => {
  return route.meta?.title || ''
})

const activeMenu = computed(() => {
  return route.path
})

function toggleSidebar() {
  appStore.toggleSidebar()
}

function handleCommand(command) {
  if (command === 'logout') {
    ElMessageBox.confirm('确定要退出登录吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }).then(() => {
      appStore.logout()
      router.push('/login')
    }).catch(() => {})
  } else if (command === 'profile') {
    // 预留：个人中心
  }
}
</script>

<style scoped>
.layout-container {
  height: 100vh;
  display: flex;
}

.layout-aside {
  background-color: #1d1e1f;
  overflow-y: auto;
  overflow-x: hidden;
  transition: width 0.3s ease;
}

.layout-aside::-webkit-scrollbar {
  width: 4px;
}

.layout-aside::-webkit-scrollbar-thumb {
  background-color: #434343;
  border-radius: 2px;
}

.logo-area {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-bottom: 1px solid #2a2b2c;
  overflow: hidden;
}

.logo-img {
  height: 32px;
  width: auto;
  transition: all 0.3s ease;
}

.logo-img.collapsed {
  height: 24px;
}

.sidebar-menu {
  border-right: none;
}

.layout-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.layout-header {
  height: 60px;
  background-color: #fff;
  border-bottom: 1px solid #e6e6e6;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
}

.header-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.collapse-btn {
  font-size: 20px;
  cursor: pointer;
  color: #606266;
}

.collapse-btn:hover {
  color: #E60012;
}

.header-breadcrumb {
  font-size: 14px;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 16px;
}

.header-icon {
  font-size: 20px;
  color: #606266;
  cursor: pointer;
}

.header-icon:hover {
  color: #E60012;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 4px 8px;
  border-radius: 4px;
  transition: background-color 0.2s;
}

.user-info:hover {
  background-color: #f5f5f5;
}

.user-avatar {
  background-color: #E60012;
}

.username {
  font-size: 14px;
  color: #303133;
}

.layout-content {
  background-color: #f0f2f5;
  padding: 20px;
  overflow-y: auto;
  flex: 1;
}
</style>