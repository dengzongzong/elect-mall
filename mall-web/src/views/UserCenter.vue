<template>
  <div class="user-center-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>个人中心</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div class="user-layout">
        <!-- 侧边导航 -->
        <aside class="user-sidebar">
          <div class="user-info-card">
            <div class="user-avatar">
              <el-icon :size="40"><UserFilled /></el-icon>
            </div>
            <div class="user-name">{{ userStore.userInfo.nickname || '用户' }}</div>
            <div class="user-level">普通会员</div>
          </div>
          <el-menu
            :default-active="activeMenu"
            router
            class="user-menu"
            @select="handleMenuSelect"
          >
            <el-menu-item index="/user/profile">
              <el-icon><User /></el-icon>
              <span>个人资料</span>
            </el-menu-item>
            <el-menu-item index="/user/address">
              <el-icon><Location /></el-icon>
              <span>收货地址</span>
            </el-menu-item>
            <el-menu-item index="/user/security">
              <el-icon><Lock /></el-icon>
              <span>账户安全</span>
            </el-menu-item>
            <el-menu-item index="/user/balance">
              <el-icon><Money /></el-icon>
              <span>账户余额</span>
            </el-menu-item>
            <el-menu-item index="/user/favorite">
              <el-icon><Star /></el-icon>
              <span>我的收藏</span>
            </el-menu-item>
            <el-menu-item index="/user/partNo">
              <el-icon><Document /></el-icon>
              <span>常用型号</span>
            </el-menu-item>
            <el-menu-item index="/user/message">
              <el-icon><Message /></el-icon>
              <span>我的消息</span>
            </el-menu-item>
            <el-menu-item index="/user/feedback">
              <el-icon><Edit /></el-icon>
              <span>投诉建议</span>
            </el-menu-item>
          </el-menu>
        </aside>
        <!-- 主内容区 -->
        <main class="user-main">
          <router-view />
        </main>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'
import { useUserStore } from '../stores/user'

const route = useRoute()
const userStore = useUserStore()

const activeMenu = computed(() => {
  return route.path
})

function handleMenuSelect(index) {
  // handled by router
}
</script>

<style scoped>
.user-center-page {
  background: #f5f5f5;
  min-height: 100vh;
}

.container {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 20px;
}

.breadcrumb {
  padding: 16px 0;
}

.user-layout {
  display: flex;
  gap: 24px;
  padding-bottom: 40px;
}

.user-sidebar {
  width: 220px;
  flex-shrink: 0;
}

.user-info-card {
  background: #fff;
  border-radius: 8px;
  padding: 30px 20px;
  text-align: center;
  margin-bottom: 16px;
}

.user-avatar {
  width: 64px;
  height: 64px;
  line-height: 64px;
  margin: 0 auto 12px;
  background: var(--theme-color-light);
  color: var(--theme-color);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.user-name {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin-bottom: 4px;
}

.user-level {
  font-size: 12px;
  color: #999;
  background: #f5f5f5;
  display: inline-block;
  padding: 2px 12px;
  border-radius: 10px;
}

.user-menu {
  border-right: none;
  border-radius: 8px;
  overflow: hidden;
}

.user-menu .el-menu-item {
  height: 44px;
  line-height: 44px;
  font-size: 14px;
}

.user-menu .el-menu-item.is-active {
  color: var(--theme-color);
  background: var(--theme-color-light);
  border-right: 3px solid var(--theme-color);
}

.user-main {
  flex: 1;
  min-height: 500px;
}
</style>