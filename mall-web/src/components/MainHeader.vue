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
        <div class="nav-category" @mouseenter="onCategoryEnter" @mouseleave="onCategoryLeave" @mousedown.prevent>
          <span class="category-btn">
            全部产品分类
          </span>
          <transition name="fade">
            <div v-show="showMegaMenu" class="mega-menu" @mouseenter="onMegaMenuEnter" @mouseleave="onMegaMenuLeave" @mousedown.prevent>
              <!-- 左侧：1级大类 -->
              <div class="mega-left">
                <div class="mega-left-inner">
                  <div
                    class="mega-l1-item"
                    v-for="cat in categories"
                    :key="cat.id"
                    :class="{ active: activeL1Id === cat.id }"
                    @mouseenter="activeL1Id = cat.id"
                    @click="goToCategory(cat.id)"
                    @mousedown.prevent
                  >
                    <span class="l1-name">{{ cat.name }}</span>
                    <span v-if="cat.subs && cat.subs.length > 0" class="expand-arrow">></span>
                  </div>
                </div>
              </div>
              <!-- 二级：品牌列表 -->
              <div v-if="activeL1" class="mega-level" :style="{ top: getLevel2Top() }">
                <div class="mega-level-inner">
                  <div
                    class="mega-l2-item"
                    v-for="sub in activeL1.subs"
                    :key="sub.id"
                    :class="{ active: activeL2Id === sub.id }"
                    @mouseenter="activeL2Id = sub.id"
                    @click="goToCategoryDetail(sub)"
                    @mousedown.prevent
                  >
                    <span class="l2-name">{{ sub.name }}</span>
                    <span v-if="sub.items && sub.items.length > 0" class="expand-arrow">></span>
                  </div>
                </div>
              </div>
              <!-- 仅两级：一级大类 -> 二级品牌，不再展示第三级面板 -->
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
const showMegaMenu = ref(false)
const activeL1Id = ref(null)
const activeL2Id = ref(null)

// 防抖工具函数
function debounce(fn, delay) {
  let timer = null
  return function(...args) {
    clearTimeout(timer)
    timer = setTimeout(() => fn.apply(this, args), delay)
  }
}

// 防抖关闭菜单：当鼠标离开菜单区域时延迟关闭，避免快速移入移出导致闪烁
const debounceHideMenu = debounce(() => {
  showMegaMenu.value = false
}, 150)

// 当前激活的一级分类
const activeL1 = computed(() => {
  return categories.value.find(c => c.id === activeL1Id.value) || null
})

// 当前激活的二级分类
const activeL2 = computed(() => {
  if (!activeL1.value) return null
  return activeL1.value.subs.find(s => s.id === activeL2Id.value) || null
})

// 计算二级面板的top偏移（根据一级菜单项的位置）
function getLevel2Top() {
  if (!activeL1.value) return '0px'
  const idx = categories.value.findIndex(c => c.id === activeL1Id.value)
  return `${idx * 46}px`
}

function onCategoryEnter() {
  showMegaMenu.value = true
}

function onCategoryLeave() {
  debounceHideMenu()
}

function onMegaMenuEnter() {
  showMegaMenu.value = true
}

function onMegaMenuLeave() {
  activeL1Id.value = null
  activeL2Id.value = null
  debounceHideMenu()
}

async function fetchCategories() {
  try {
    const res = await getCategories()
    categories.value = res || []
  } catch (e) {
    categories.value = []
  }
}

function goToCategory(catId) {
  showMegaMenu.value = false
  activeL1Id.value = null
  activeL2Id.value = null
  router.push({ path: `/category/${catId}` })
}

function resolveItem(item) {
  if (typeof item === 'string') {
    try {
      return JSON.parse(item)
    } catch (e) {
      return { name: item, id: item }
    }
  }
  return item || {}
}

function goToCategoryDetail(item) {
  showMegaMenu.value = false
  activeL1Id.value = null
  activeL2Id.value = null
  const resolved = resolveItem(item)
  router.push(`/category/detail/${resolved.id}`)
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
  // 已登录时以服务端购物车为准，保证角标数量准确
  cartStore.syncFromServer()
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
  height: 56px;
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
  user-select: none !important;
  -webkit-user-select: none !important;
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
  min-width: 220px;
  width: auto;
  min-height: 480px;
  background: #fff;
  box-shadow: 0 6px 24px rgba(0, 0, 0, 0.15);
  z-index: 200;
  border-radius: 0 0 4px 4px;
  display: flex;
  flex-direction: row;
  align-items: stretch;
  user-select: none !important;
  -webkit-user-select: none !important;
  -moz-user-select: none !important;
  -ms-user-select: none !important;
}

.mega-left {
  width: 220px;
  flex-shrink: 0;
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
  user-select: none;
  -webkit-user-select: none;
  height: 46px;
  line-height: 26px;
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

.expand-arrow {
  font-size: 12px;
  color: #bbb;
  font-weight: bold;
  line-height: 1;
}

.mega-l1-item.active .expand-arrow {
  color: var(--theme-color);
}

/* 二级和三级浮动面板 */
.mega-level {
  position: absolute;
  left: 220px;
  top: 0;
  width: 220px;
  min-height: 100%;
  background: #fff;
  box-shadow: 2px 0 12px rgba(0, 0, 0, 0.1);
  border-radius: 0 0 4px 4px;
  z-index: 210;
}

.mega-level-inner {
  padding: 4px 0;
}

.mega-l2-item {
  display: flex;
  align-items: center;
  padding: 10px 16px 10px 20px;
  cursor: pointer;
  font-size: 13px;
  color: #333;
  transition: all 0.15s;
  height: 46px;
  line-height: 26px;
  user-select: none;
  -webkit-user-select: none;
}

.mega-l2-item:hover {
  background: #fafafa;
}

.mega-l2-item.active {
  background: #fafafa;
  color: var(--theme-color);
  font-weight: 600;
}

.l2-name {
  flex: 1;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
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

<style>
/* 全局：阻止导航栏文字选中 */
.header-nav,
.header-nav *,
.nav-category,
.nav-category * {
  user-select: none !important;
  -webkit-user-select: none !important;
  -moz-user-select: none !important;
  -ms-user-select: none !important;
}
</style>