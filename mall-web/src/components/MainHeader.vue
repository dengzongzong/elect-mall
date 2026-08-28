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
            <img src="/logo.jpg" alt="得捷" class="logo-img" />
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
        <div class="nav-category" @mouseenter="showMegaMenu = true" @mouseleave="showMegaMenu = false">
          <span class="category-btn">
            <el-icon><Grid /></el-icon>
            全部产品分类
          </span>
          <transition name="fade">
            <div v-show="showMegaMenu" class="mega-menu" @mouseenter="showMegaMenu = true" @mouseleave="showMegaMenu = false">
              <!-- 左侧：1级大类 -->
              <div class="mega-left">
                <div class="mega-left-inner">
                  <div
                    class="mega-l1-item"
                    v-for="cat in categories"
                    :key="cat.id"
                    :class="{ active: activeCategoryId === cat.id }"
                    @mouseenter="activeCategoryId = cat.id"
                    @click="goToCategory(cat.id)"
                  >
                    <span class="l1-name">{{ cat.name }}</span>
                    <el-icon class="l1-arrow"><ArrowRight /></el-icon>
                  </div>
                </div>
              </div>
              <!-- 中栏：2级品牌 + 3级细分 -->
              <div class="mega-center" v-if="activeCategory">
                <div class="mega-center-inner">
                  <div class="mega-brand-group" v-for="(sub, idx) in activeCategory.subs" :key="idx">
                    <div class="brand-name">{{ sub.name }}</div>
                    <div class="brand-items" v-if="sub.items.length">
                      <span
                        class="brand-item"
                        v-for="item in sub.items"
                        :key="item"
                        @click="goToCategory(activeCategory.id, item)"
                      >{{ item }}</span>
                    </div>
                  </div>
                  <div v-if="!activeCategory.subs.length" class="mega-empty">暂无细分分类</div>
                  <div class="view-all">
                    <router-link :to="`/category/${activeCategory.id}`" class="view-all-link">查看全部 <el-icon><ArrowRight /></el-icon></router-link>
                  </div>
                </div>
              </div>
              <!-- 右栏：品牌推荐 -->
              <div class="mega-right">
                <div class="mega-right-title">推荐品牌</div>
                <div class="brand-grid">
                  <div class="brand-logo-item" v-for="brand in featuredBrands" :key="brand.id" @click="$router.push(`/brand/${brand.id}`)">
                    <img :src="brand.logo" :alt="brand.name" class="brand-logo" @error="onBrandImgError" />
                    <span class="brand-logo-name">{{ brand.name }}</span>
                  </div>
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
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '../stores/user'
import { useCartStore } from '../stores/cart'
import { getCategories } from '../api/product'

const router = useRouter()
const userStore = useUserStore()
const cartStore = useCartStore()

const categories = ref([])
const featuredBrands = ref([])
const showMegaMenu = ref(false)
const activeCategoryId = ref(null)

const activeCategory = computed(() => {
  return categories.value.find(c => c.id === activeCategoryId.value) || null
})

async function fetchCategories() {
  try {
    const res = await getCategories()
    categories.value = res || []
    if (categories.value.length && !activeCategoryId.value) {
      activeCategoryId.value = categories.value[0].id
    }
  } catch (e) {
    categories.value = []
  }
}

function goToCategory(catId, subName) {
  showMegaMenu.value = false
  const query = subName ? { keyword: subName } : {}
  router.push({ path: `/category/${catId}`, query })
}

function onBrandImgError(e) {
  e.target.style.display = 'none'
  e.target.nextElementSibling.style.display = 'block'
}

const searchKeyword = ref('')

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
  fetchCategories()
  // 获取推荐品牌（前端硬编码一些知名品牌供展示）
  featuredBrands.value = [
    { id: 1, name: 'muRata', logo: '/logo.jpg' },
    { id: 2, name: 'TDK', logo: '/logo.jpg' },
    { id: 3, name: 'Taiyo Yuden', logo: '/logo.jpg' },
    { id: 4, name: 'SAMSUNG', logo: '/logo.jpg' },
    { id: 5, name: 'Yageo', logo: '/logo.jpg' },
    { id: 6, name: 'FH(风华)', logo: '/logo.jpg' },
  ]
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
  text-decoration: none;
}

.logo-img {
  height: 40px;
  width: auto;
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
  height: 44px;
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

/* Mega Menu */
.mega-menu {
  position: absolute;
  top: 100%;
  left: 0;
  width: 960px;
  background: #fff;
  box-shadow: 0 6px 24px rgba(0, 0, 0, 0.15);
  z-index: 200;
  display: flex;
  min-height: 460px;
  border-radius: 0 0 4px 4px;
}

.mega-left {
  width: 220px;
  flex-shrink: 0;
  border-right: 1px solid #eee;
  overflow-y: auto;
  background: #fafafa;
}

.mega-left-inner {
  padding: 4px 0;
}

.mega-l1-item {
  display: flex;
  align-items: center;
  padding: 10px 16px 10px 20px;
  cursor: pointer;
  font-size: 13px;
  color: #333;
  transition: all 0.15s;
  position: relative;
  border-left: 4px solid transparent;
}

.mega-l1-item:hover {
  background: #fff;
}

.mega-l1-item.active {
  background: #fff;
  border-left-color: var(--theme-color);
  color: var(--theme-color);
  font-weight: 600;
}

.l1-name {
  flex: 1;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.l1-arrow {
  font-size: 14px;
  color: #bbb;
  flex-shrink: 0;
}

.mega-l1-item.active .l1-arrow {
  color: var(--theme-color);
}

.mega-center {
  width: 460px;
  flex-shrink: 0;
  border-right: 1px solid #eee;
  overflow-y: auto;
}

.mega-center-inner {
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.mega-brand-group {
  break-inside: avoid;
}

.brand-name {
  font-size: 13px;
  font-weight: 600;
  color: #333;
  margin-bottom: 4px;
  padding-bottom: 4px;
  border-bottom: 1px solid #f0f0f0;
}

.brand-items {
  display: flex;
  flex-wrap: wrap;
  gap: 2px 16px;
}

.brand-item {
  font-size: 12px;
  color: #666;
  cursor: pointer;
  transition: color 0.15s;
  white-space: nowrap;
  line-height: 1.8;
}

.brand-item:hover {
  color: var(--theme-color);
}

.view-all {
  margin-top: 4px;
  padding-top: 8px;
  border-top: 1px solid #f0f0f0;
}

.view-all-link {
  font-size: 13px;
  color: var(--theme-color);
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  gap: 4px;
}

.view-all-link:hover {
  text-decoration: underline;
}

.mega-empty {
  color: #bbb;
  font-size: 13px;
  padding: 20px 0;
}

.mega-right {
  width: 280px;
  flex-shrink: 0;
  padding: 20px;
  overflow-y: auto;
}

.mega-right-title {
  font-size: 14px;
  font-weight: 600;
  color: #333;
  margin-bottom: 12px;
  padding-bottom: 8px;
  border-bottom: 2px solid var(--theme-color);
}

.brand-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
}

.brand-logo-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  cursor: pointer;
  padding: 10px 8px;
  border: 1px solid #f0f0f0;
  border-radius: 4px;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.brand-logo-item:hover {
  border-color: var(--theme-color);
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
}

.brand-logo {
  width: 64px;
  height: 32px;
  object-fit: contain;
}

.brand-logo-name {
  font-size: 11px;
  color: #888;
  text-align: center;
  line-height: 1.3;
  display: none;
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
  transition: opacity 0.15s;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>