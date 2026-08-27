<template>
  <header class="main-header">
    <!-- 顶部工具栏 -->
    <div class="header-top">
      <div class="container">
        <div class="header-top-left">
          <span class="welcome-text">欢迎来到电子元器件商城</span>
        </div>
        <div class="header-top-right">
          <template v-if="!userStore.isLoggedIn">
            <router-link to="/login" class="top-link">登录</router-link>
            <span class="divider">|</span>
            <router-link to="/login" class="top-link">注册</router-link>
          </template>
          <template v-else>
            <el-dropdown>
              <span class="top-link user-dropdown">
                <el-icon><User /></el-icon>
                {{ userStore.userInfo.nickname || userStore.userInfo.phone || '用户' }}
                <el-icon><ArrowDown /></el-icon>
              </span>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item @click="$router.push('/user/profile')">个人中心</el-dropdown-item>
                  <el-dropdown-item @click="$router.push('/user/balance')">账户余额</el-dropdown-item>
                  <el-dropdown-item @click="$router.push('/order/list')">我的订单</el-dropdown-item>
                  <el-dropdown-item divided @click="handleLogout">退出登录</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </template>
        </div>
      </div>
    </div>

    <!-- 中间搜索区域 -->
    <div class="header-middle">
      <div class="container">
        <div class="logo-area">
          <router-link to="/" class="logo">
            <span class="logo-icon">EC</span>
            <span class="logo-text">电子元器件商城</span>
          </router-link>
        </div>
        <div class="search-area">
          <div class="search-box">
            <el-input
              v-model="searchKeyword"
              placeholder="搜索型号、品牌、关键词..."
              class="search-input"
              clearable
              @keyup.enter="handleSearch"
            >
              <template #prefix>
                <el-icon><Search /></el-icon>
              </template>
            </el-input>
            <el-button type="primary" class="search-btn" @click="handleSearch">搜索</el-button>
          </div>
          <div class="hot-keywords">
            <span class="hot-label">热门：</span>
            <a href="#" class="keyword" @click.prevent="searchKeyword = 'STM32'">STM32</a>
            <a href="#" class="keyword" @click.prevent="searchKeyword = 'ESP32'">ESP32</a>
            <a href="#" class="keyword" @click.prevent="searchKeyword = '电阻'">电阻</a>
            <a href="#" class="keyword" @click.prevent="searchKeyword = '电容'">电容</a>
            <a href="#" class="keyword" @click.prevent="searchKeyword = '传感器'">传感器</a>
          </div>
        </div>
        <div class="header-actions">
          <div class="action-item" @click="$router.push('/inquiry')">
            <el-icon><Document /></el-icon>
            <span>我的询价</span>
          </div>
          <div class="action-item cart-action" @click="$router.push('/cart')">
            <el-badge :value="cartStore.count" :max="99" class="cart-badge">
              <el-icon><ShoppingCart /></el-icon>
            </el-badge>
            <span>购物车</span>
          </div>
          <div class="action-item" @click="$router.push('/order/list')">
            <el-icon><Tickets /></el-icon>
            <span>我的订单</span>
          </div>
          <div class="action-item phone-item">
            <el-icon><Phone /></el-icon>
            <span>400-888-9999</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 主导航栏 -->
    <div class="header-nav">
      <div class="container">
        <div class="nav-category" @mouseenter="showCategory = true" @mouseleave="showCategory = false">
          <span class="category-btn">
            <el-icon><Grid /></el-icon>
            全部产品分类
          </span>
          <transition name="fade">
            <div v-show="showCategory" class="category-dropdown">
              <div class="category-list">
                <div class="category-item" v-for="cat in categories" :key="cat.id" @click="$router.push(`/category/${cat.id}`)">
                  <el-icon><component :is="cat.icon" /></el-icon>
                  <span>{{ cat.name }}</span>
                  <el-icon class="arrow-right"><ArrowRight /></el-icon>
                </div>
              </div>
            </div>
          </transition>
        </div>
        <div class="nav-links">
          <router-link to="/" class="nav-link" :class="{ active: $route.path === '/' }">首页</router-link>
          <router-link to="/brand" class="nav-link" :class="{ active: $route.path.startsWith('/brand') }">品牌专区</router-link>
          <router-link to="/bom" class="nav-link" :class="{ active: $route.path === '/bom' }">BOM配单</router-link>
          <router-link to="/inquiry" class="nav-link" :class="{ active: $route.path === '/inquiry' }">商品询价</router-link>
          <router-link to="/datasheet" class="nav-link" :class="{ active: $route.path === '/datasheet' }">数据手册</router-link>
          <router-link to="/news" class="nav-link" :class="{ active: $route.path.startsWith('/news') }">资讯中心</router-link>
          <router-link to="/cooperate" class="nav-link" :class="{ active: $route.path === '/cooperate' }">合作品牌</router-link>
          <router-link to="/partner" class="nav-link" :class="{ active: $route.path === '/partner' }">供应商合作</router-link>
        </div>
      </div>
    </div>
  </header>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '../stores/user'
import { useCartStore } from '../stores/cart'

const router = useRouter()
const userStore = useUserStore()
const cartStore = useCartStore()

const searchKeyword = ref('')
const showCategory = ref(false)

const categories = [
  { id: 1, name: 'MCU微控制器', icon: 'Cpu' },
  { id: 2, name: '传感器', icon: 'DataAnalysis' },
  { id: 3, name: '电源管理', icon: 'Battery' },
  { id: 4, name: '模拟器件', icon: 'TrendCharts' },
  { id: 5, name: '连接器', icon: 'Connection' },
  { id: 6, name: '无源器件', icon: 'SetUp' },
  { id: 7, name: '分立半导体', icon: 'Monitor' },
  { id: 8, name: '存储器', icon: 'Folder' },
  { id: 9, name: '无线模块', icon: 'Wifi' },
  { id: 10, name: '开发工具', icon: 'Tools' },
]

function handleSearch() {
  if (searchKeyword.value.trim()) {
    router.push({ path: '/category/0', query: { keyword: searchKeyword.value.trim() } })
  }
}

function handleLogout() {
  userStore.logout()
  router.push('/')
}

onMounted(() => {
  // 初始化购物车显示
})
</script>

<style scoped>
.main-header {
  background: #fff;
  position: sticky;
  top: 0;
  z-index: 1000;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.container {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 20px;
}

/* 顶部工具栏 */
.header-top {
  background: #f8f8f8;
  height: 36px;
  line-height: 36px;
  font-size: 12px;
  border-bottom: 1px solid #eee;
}

.header-top .container {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.welcome-text {
  color: #999;
}

.top-link {
  color: #666;
  cursor: pointer;
  padding: 0 8px;
  transition: color 0.2s;
}

.top-link:hover {
  color: var(--theme-color);
}

.divider {
  color: #ddd;
}

.user-dropdown {
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  gap: 4px;
}

/* 中间搜索区域 */
.header-middle {
  height: 80px;
  display: flex;
  align-items: center;
  background: #fff;
}

.header-middle .container {
  display: flex;
  align-items: center;
  width: 100%;
  gap: 40px;
}

.logo-area {
  flex-shrink: 0;
}

.logo {
  display: flex;
  align-items: center;
  gap: 10px;
  text-decoration: none;
}

.logo-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 44px;
  height: 44px;
  background: var(--theme-color);
  color: #fff;
  font-size: 16px;
  font-weight: 700;
  border-radius: 8px;
  letter-spacing: 1px;
}

.logo-text {
  font-size: 22px;
  font-weight: 700;
  color: #333;
  letter-spacing: 2px;
}

.search-area {
  flex: 1;
  max-width: 560px;
}

.search-box {
  display: flex;
  gap: 0;
}

.search-input :deep(.el-input__wrapper) {
  border-radius: 4px 0 0 4px;
  border: 2px solid var(--theme-color);
  border-right: none;
  box-shadow: none;
  height: 42px;
}

.search-input :deep(.el-input__wrapper):hover,
.search-input :deep(.el-input__wrapper).is-focus {
  box-shadow: none;
  border-color: var(--theme-color);
}

.search-btn {
  border-radius: 0 4px 4px 0;
  height: 42px;
  width: 80px;
  font-size: 15px;
  background: var(--theme-color);
  border-color: var(--theme-color);
}

.search-btn:hover {
  background: var(--theme-color-hover);
  border-color: var(--theme-color-hover);
}

.hot-keywords {
  margin-top: 6px;
  font-size: 12px;
  color: #999;
  display: flex;
  align-items: center;
  gap: 4px;
}

.hot-label {
  color: #bbb;
}

.keyword {
  color: #666;
  padding: 0 4px;
  transition: color 0.2s;
}

.keyword:hover {
  color: var(--theme-color);
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 24px;
  flex-shrink: 0;
}

.action-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2px;
  cursor: pointer;
  color: #666;
  font-size: 12px;
  transition: color 0.2s;
  position: relative;
}

.action-item:hover {
  color: var(--theme-color);
}

.action-item .el-icon {
  font-size: 22px;
}

.phone-item .el-icon {
  font-size: 20px;
  color: var(--theme-color);
}

.phone-item span {
  color: var(--theme-color);
  font-weight: 600;
  font-size: 14px;
}

.cart-badge :deep(.el-badge__content) {
  background: var(--theme-color);
}

.cart-action {
  color: var(--theme-color);
}

/* 主导航栏 */
.header-nav {
  background: var(--theme-color);
  height: 44px;
  line-height: 44px;
}

.header-nav .container {
  display: flex;
  align-items: center;
  height: 100%;
}

.nav-category {
  position: relative;
  width: 200px;
  flex-shrink: 0;
}

.category-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  height: 44px;
  padding: 0 16px;
  background: var(--theme-color-hover);
  color: #fff;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  user-select: none;
}

.category-dropdown {
  position: absolute;
  top: 100%;
  left: 0;
  width: 240px;
  background: #fff;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
  z-index: 100;
  border-radius: 0 0 4px 4px;
}

.category-list {
  padding: 8px 0;
}

.category-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 16px;
  cursor: pointer;
  transition: all 0.2s;
  font-size: 14px;
  color: #333;
}

.category-item:hover {
  background: var(--theme-color-light);
  color: var(--theme-color);
}

.category-item .arrow-right {
  margin-left: auto;
  font-size: 12px;
  opacity: 0;
  transition: opacity 0.2s;
}

.category-item:hover .arrow-right {
  opacity: 1;
}

.nav-links {
  display: flex;
  align-items: center;
  gap: 0;
  margin-left: 20px;
  height: 100%;
}

.nav-link {
  display: inline-flex;
  align-items: center;
  height: 100%;
  padding: 0 20px;
  color: rgba(255, 255, 255, 0.9);
  font-size: 14px;
  transition: all 0.2s;
  text-decoration: none;
  position: relative;
}

.nav-link:hover,
.nav-link.active {
  background: rgba(255, 255, 255, 0.15);
  color: #fff;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>