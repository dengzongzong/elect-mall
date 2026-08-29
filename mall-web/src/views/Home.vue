<template>
  <div class="home">
    <MainHeader />

    <!-- 主内容区域：分类侧边栏 + Banner -->
    <div class="container main-area">
      <div class="content-layout">
        <!-- 分类侧边栏（含悬浮展开面板） -->
        <div class="category-sidebar" @mouseleave="activeCat = null">
          <div class="category-list">
            <div class="category-item" v-for="cat in categories" :key="cat.id"
              @mouseenter="activeCat = cat.id"
              @mouseleave="activeCat = null"
              :class="{ active: activeCat === cat.id }"
            >
              <router-link :to="`/category/${cat.id}`" class="cat-link">
                <span class="cat-name">{{ cat.name }}</span>
                <el-icon class="arrow"><ArrowRight /></el-icon>
              </router-link>
              <div class="sub-category" v-show="activeCat === cat.id" @mouseleave="activeCat = null">
                <div class="sub-cat-grid">
                  <div class="sub-cat-group" v-for="group in cat.subs" :key="group.name">
                    <h5>{{ group.name }}</h5>
                    <a v-for="item in group.items" :key="item.id || item" href="#" @click.prevent="">{{ displayItemName(item) }}</a>
                  </div>
                </div>
              </div>
            </div>
          </div>

        </div>

        <!-- Banner 轮播 + 固定广告 -->
        <div class="banner-wrapper">
          <!-- 左侧轮播 -->
          <div class="banner-carousel">
            <el-carousel :interval="4000" height="400px" indicator-position="none">
              <el-carousel-item v-for="(banner, idx) in banners" :key="idx">
                <div class="banner-slide" :style="{ background: bannerColors[idx % bannerColors.length] }">
                  <div class="banner-content">
                    <h2>{{ banner.title }}</h2>
                    <p>{{ banner.subtitle || banner.title }}</p>
                    <el-button v-if="banner.link" type="danger" size="large" round @click="goLink(banner.link)">立即查看</el-button>
                  </div>
                </div>
              </el-carousel-item>
            </el-carousel>
          </div>
          <!-- 右侧固定广告 -->
          <div class="banner-ads">
            <a
              v-for="(ad, idx) in sideAds"
              :key="idx"
              :href="ad.link"
              class="ad-item"
              :style="{ background: ad.bg }"
              target="_blank"
            >
              <div class="ad-content">
                <span class="ad-tag" :style="{ background: ad.tagBg }">{{ ad.tag }}</span>
                <h4 class="ad-title">{{ ad.title }}</h4>
                <p class="ad-desc">{{ ad.desc }}</p>
              </div>
            </a>
          </div>
        </div>
      </div>
    </div>

    <!-- 特色优势 -->
    <div class="features-section">
      <div class="container">
        <div class="features-grid">
          <div class="feature-card" v-for="f in features" :key="f.title">
            <el-icon class="feature-icon"><component :is="f.icon" /></el-icon>
            <div class="feature-info">
              <h4>{{ f.title }}</h4>
              <p>{{ f.desc }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 品牌墙 -->
    <div class="brand-wall-section">
      <div class="container">
        <div class="section-header">
          <h3>合作品牌</h3>
          <router-link to="/brand" class="more-link">查看全部 <el-icon><ArrowRight /></el-icon></router-link>
        </div>
        <div class="brand-grid">
          <div class="brand-item" v-for="brand in brands" :key="brand.id" @click="$router.push(`/brand/${brand.id}`)">
            <img v-if="brand.logo" :src="brand.logo" :alt="brand.name" class="brand-logo" @error="onBrandImgError($event, brand)" />
            <span v-else class="brand-logo-text">{{ brand.name }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 特色产品 -->
    <div class="featured-products-section">
      <div class="container">
        <div class="section-header">
          <h3>特色产品</h3>
          <router-link to="/category/0" class="more-link">查看更多 <el-icon><ArrowRight /></el-icon></router-link>
        </div>
        <div class="featured-product-grid">
          <div class="fp-card" v-for="product in featuredProducts" :key="product.id" @click="$router.push(`/product/${product.id}`)">
            <div class="fp-brand">
              <div class="fp-brand-logo">
                <img :src="getBrandLogo(product.brandId)" :alt="getBrandName(product.brandId)" @error="e => e.target.style.display='none'" />
              </div>
              <span class="fp-brand-tag">{{ getBrandName(product.brandId) }}</span>
            </div>
            <h4 class="fp-title">{{ product.name }}</h4>
            <div class="fp-img">
              <img v-if="product.imageUrl" :src="product.imageUrl" :alt="product.name" @error="e => e.target.style.display='none'" />
              <el-icon v-else class="fp-img-default"><Cpu /></el-icon>
            </div>
            <div class="fp-features">
              <div class="fp-feature" v-for="(feature, fi) in getFeatures(product)" :key="fi">
                <span class="fp-dot"></span>
                <span>{{ feature }}</span>
              </div>
            </div>
          </div>
        </div>
        <div class="fp-pagination">
          <span class="fp-dot-page" v-for="p in 3" :key="p" :class="{ active: p === 1 }"></span>
        </div>
      </div>
    </div>

    <!-- 新闻资讯 -->
    <div class="news-section">
      <div class="container">
        <div class="section-header">
          <h3>新品资讯</h3>
          <router-link to="/news" class="more-link">更多资讯 <el-icon><ArrowRight /></el-icon></router-link>
        </div>
        <div class="news-list">
          <div class="news-col" v-for="(col, colIdx) in newsCols" :key="colIdx">
            <div class="news-item" v-for="news in col" :key="news.id" @click="$router.push(`/news/${news.id}`)">
              <span class="news-dot">•</span>
              <span class="news-title">{{ news.title }}</span>
              <span class="news-date">{{ formatDate(news.created_at) }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <MainFooter />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'
import { useCartStore } from '../stores/cart'
import { getCategories, getBrands, getProducts } from '../api/product'
import { getNewsList, getCarousels } from '../api/content'

const cartStore = useCartStore()
const activeCat = ref(null)

const categories = ref([])
const brands = ref([])
const hotProducts = ref([])
const newsList = ref([])

const brandMap = computed(() => {
  const map = {}
  for (const b of brands.value) {
    map[b.id] = b
  }
  return map
})

const featuredProducts = computed(() => {
  return hotProducts.value.slice(0, 4)
})

const activePanel = computed(() => {
  if (activeCat.value === null) return null
  return categories.value.find(c => c.id === activeCat.value) || null
})

// 三级分类项：正常为 {name,id} 对象，若后端返回的是 JSON 字符串则解析后取 name，
// 避免直接渲染对象导致页面出现 {"name":"...","id":"..."}
function displayItemName(item) {
  if (typeof item === 'string') {
    try {
      const parsed = JSON.parse(item)
      return parsed.name || parsed
    } catch (e) {
      return item
    }
  }
  return (item && item.name) || item || ''
}

const newsCols = computed(() => {
  const list = newsList.value
  const half = Math.ceil(list.length / 2)
  return [list.slice(0, half), list.slice(half)]
})

function getBrandLogo(brandId) {
  const b = brandMap.value[brandId]
  return b ? b.logo : ''
}

function getBrandName(brandId) {
  const b = brandMap.value[brandId]
  return b ? b.name : ''
}

function onBrandImgError(event, brand) {
  const img = event.target
  if (img && img.parentNode) {
    img.style.display = 'none'
    const text = document.createElement('span')
    text.className = 'brand-logo-text'
    text.textContent = brand.name
    img.parentNode.appendChild(text)
  }
}

function getFeatures(product) {
  const desc = product.description || ''
  const lines = desc.split(/\n|，|,/).filter(l => l.trim().length > 6)
  if (lines.length >= 3) return lines.slice(0, 4)
  return [
    `型号：${product.partNo || ''}`,
    `库存：${product.stock || 0}`,
    `封装：${product.unit || 'SMD'}`,
    `品牌：${getBrandName(product.brandId)}`
  ]
}

function formatDate(dateStr) {
  if (!dateStr) return ''
  const d = new Date(dateStr)
  const y = d.getFullYear()
  const m = String(d.getMonth() + 1).padStart(2, '0')
  const day = String(d.getDate()).padStart(2, '0')
  return `${y}/${m}/${day}`
}

function goLink(url) {
  window.open(url, '_blank')
}

const banners = ref([])
const bannerColors = [
  'linear-gradient(135deg, #E60012 0%, #ff4d4f 100%)',
  'linear-gradient(135deg, #1677ff 0%, #4096ff 100%)',
  'linear-gradient(135deg, #389e0d 0%, #73d13d 100%)',
  'linear-gradient(135deg, #722ed1 0%, #b37feb 100%)',
  'linear-gradient(135deg, #c41d7f 0%, #ff85c0 100%)',
  'linear-gradient(135deg, #fa8c16 0%, #ffc53d 100%)',
  'linear-gradient(135deg, #13c2c2 0%, #5cdbd3 100%)',
  'linear-gradient(135deg, #2f54eb 0%, #85a5ff 100%)',
]

const sideAds = [
  { title: 'BOM 配单报价', desc: '上传BOM清单，2小时快速报价', tag: '热门服务', tagBg: '#E60012', link: '#', bg: 'linear-gradient(135deg, #1a1a2e 0%, #16213e 100%)' },
  { title: '免费样品申请', desc: '工程师专享，免费样品送到家', tag: '限时活动', tagBg: '#fa8c16', link: '#', bg: 'linear-gradient(135deg, #2d1b00 0%, #4a2800 100%)' },
  { title: '技术资料下载', desc: '数据手册、参考设计、应用笔记', tag: '资源中心', tagBg: '#1677ff', link: '#', bg: 'linear-gradient(135deg, #001529 0%, #003a70 100%)' },
  { title: '在线技术支持', desc: '资深工程师在线答疑，快速响应', tag: '技术支持', tagBg: '#52c41a', link: '#', bg: 'linear-gradient(135deg, #092b00 0%, #1a5200 100%)' },
]

const features = [
  { icon: 'CircleCheck', title: '品质保证', desc: '100%原装正品，专业检测' },
  { icon: 'Clock', title: '极速发货', desc: '当天16:00前下单，当天发货' },
  { icon: 'Cpu', title: '型号齐全', desc: '50万+现货型号，一应俱全' },
  { icon: 'List', title: '一站式采购', desc: 'BOM配单，批量采购更省心' },
]

async function fetchHomeData() {
  try {
    const [catRes, brandRes, productRes, newsRes, carouselRes] = await Promise.allSettled([
      getCategories(),
      getBrands(),
      getProducts({ page: 1, size: 8, orderBy: 'created_at', orderDir: 'desc' }),
      getNewsList(),
      getCarousels(),
    ])

    if (catRes.status === 'fulfilled' && catRes.value) {
      categories.value = catRes.value
    }

    if (brandRes.status === 'fulfilled' && brandRes.value) {
      brands.value = (brandRes.value || []).filter(b => b.is_cooperate == 1 || b.is_cooperate === true)
    }

    if (productRes.status === 'fulfilled' && productRes.value?.records) {
      hotProducts.value = productRes.value.records
    }

    if (newsRes.status === 'fulfilled' && newsRes.value) {
      newsList.value = newsRes.value.map(n => ({
        id: n.id,
        title: n.title,
        image: n.image || '',
        views: n.like_count || 0,
        day: n.created_at ? new Date(n.created_at).getDate().toString().padStart(2, '0') : '',
        month: n.created_at ? new Date(n.created_at).getFullYear() + '-' + String(new Date(n.created_at).getMonth() + 1).padStart(2, '0') : '',
      }))
    }

    if (carouselRes.status === 'fulfilled' && carouselRes.value) {
      banners.value = carouselRes.value
    }
  } catch (e) {
    // 静默忽略，组件使用空数据
  }
}

onMounted(() => {
  fetchHomeData()
})

function handleAddToCart(product) {
  cartStore.addItem({
    id: product.id,
    name: product.name,
    price: product.price,
    stock: product.stock,
    quantity: 1,
    image: '',
  })
  ElMessage.success('已加入购物车')
}
</script>

<style scoped>
.home {
  background: #f5f5f5;
  min-height: 100vh;
}

.container {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 20px;
}

/* 主区域 */
.main-area {
  padding-top: 16px;
  padding-bottom: 0;
}

.content-layout {
  display: flex;
  gap: 16px;
  position: relative;
}

/* 分类侧边栏 */
.category-sidebar {
  width: 240px;
  flex-shrink: 0;
  background: #fff;
  border-radius: 4px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
  height: 400px;
  overflow: visible;
  position: relative;
}

.category-list {
  padding: 4px 0;
  position: relative;
}

.category-item {
  position: static;
}

.category-item.active .cat-link {
  background: var(--theme-color-light);
  color: var(--theme-color);
  font-weight: 600;
}

.cat-link {
  display: flex;
  align-items: center;
  padding: 8px 16px;
  font-size: 13px;
  color: #333;
  transition: all 0.2s;
  text-decoration: none;
}

.cat-link:hover {
  background: var(--theme-color-light);
  color: var(--theme-color);
}

.cat-name {
  flex: 1;
}

/* 子分类展开面板 */
.sub-category {
  position: absolute;
  left: 240px;
  top: 0;
  width: 680px;
  background: #fff;
  box-shadow: 2px 4px 16px rgba(0, 0, 0, 0.12);
  border-radius: 0 4px 4px 0;
  z-index: 50;
  min-height: 400px;
  padding: 20px;
  user-select: none;
  -webkit-user-select: none;
}

.sub-cat-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.sub-cat-group h5 {
  font-size: 14px;
  font-weight: 600;
  color: #333;
  margin-bottom: 10px;
  padding-bottom: 6px;
  border-bottom: 2px solid var(--theme-color);
  display: inline-block;
}

.sub-cat-group a {
  display: block;
  font-size: 13px;
  color: #888;
  line-height: 28px;
  transition: color 0.2s;
  text-decoration: none;
}

.sub-cat-group a:hover {
  color: var(--theme-color);
}

.group-item:hover {
  color: var(--theme-color);
}

.panel-empty {
  color: #bbb;
  font-size: 13px;
  padding: 20px 0;
  text-align: center;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.15s;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* Banner 容器 */
.banner-wrapper {
  flex: 1;
  display: flex;
  gap: 10px;
  height: 400px;
}

/* 左侧轮播 */
.banner-carousel {
  flex: 1;
  border-radius: 4px;
  overflow: hidden;
  min-width: 0;
}

.banner-carousel .el-carousel,
.banner-carousel .el-carousel__container {
  height: 100% !important;
}

.banner-slide {
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 60px;
}

.banner-content {
  text-align: center;
  color: #fff;
}

.banner-content h2 {
  font-size: 36px;
  font-weight: 700;
  margin-bottom: 12px;
  letter-spacing: 2px;
}

.banner-content p {
  font-size: 18px;
  margin-bottom: 24px;
  opacity: 0.9;
}

/* 右侧固定广告 */
.banner-ads {
  width: 240px;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.ad-item {
  flex: 1;
  border-radius: 4px;
  display: block;
  text-decoration: none;
  overflow: hidden;
  position: relative;
  transition: transform 0.3s, box-shadow 0.3s;
}

.ad-item:hover {
  transform: scale(1.02);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
}

.ad-content {
  height: 100%;
  padding: 14px 16px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  color: #fff;
}

.ad-tag {
  display: inline-block;
  font-size: 11px;
  padding: 2px 8px;
  border-radius: 2px;
  margin-bottom: 6px;
  width: fit-content;
  font-weight: 500;
}

.ad-title {
  font-size: 14px;
  font-weight: 700;
  margin-bottom: 4px;
  line-height: 1.3;
}

.ad-desc {
  font-size: 12px;
  opacity: 0.8;
  line-height: 1.4;
}

/* 特色优势 */
.features-section {
  background: #fff;
  padding: 40px 0;
  margin-top: 20px;
}

.features-grid {
  display: flex;
  justify-content: space-between;
  gap: 30px;
}

.feature-card {
  display: flex;
  align-items: center;
  gap: 16px;
  flex: 1;
  padding: 20px;
  background: #fafafa;
  border-radius: 8px;
  transition: box-shadow 0.3s;
}

.feature-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.feature-icon {
  font-size: 40px;
  color: var(--theme-color);
}

.feature-info h4 {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin-bottom: 4px;
}

.feature-info p {
  font-size: 13px;
  color: #999;
}

/* 通用区块样式 */
.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 24px;
}

.section-header h3 {
  font-size: 22px;
  font-weight: 700;
  color: #333;
  position: relative;
  padding-left: 14px;
}

.section-header h3::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 4px;
  height: 22px;
  background: var(--theme-color);
  border-radius: 2px;
}

.more-link {
  color: #999;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 4px;
  transition: color 0.2s;
  text-decoration: none;
}

.more-link:hover {
  color: var(--theme-color);
}

/* 品牌墙 */
.brand-wall-section {
  background: #fff;
  padding: 40px 0;
  margin-top: 20px;
}

.brand-grid {
  display: grid;
  grid-template-columns: repeat(6, 1fr);
  gap: 16px;
}

.brand-item {
  height: 80px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fafafa;
  border: 1px solid #eee;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.3s;
  padding: 8px;
}

.brand-item:hover {
  border-color: var(--theme-color);
  box-shadow: 0 4px 12px rgba(230, 0, 18, 0.1);
}

.brand-logo {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
}

.brand-logo-text {
  font-size: 14px;
  font-weight: 600;
  color: #666;
  transition: color 0.3s;
  text-align: center;
}

.brand-item:hover .brand-logo-text {
  color: var(--theme-color);
}

/* 特色产品 */
.featured-products-section {
  background: #fff;
  padding: 40px 0;
  margin-top: 20px;
}

.featured-product-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.fp-card {
  border: 1px solid #eee;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s;
  background: #fff;
  display: flex;
  flex-direction: column;
}

.fp-card:hover {
  border-color: var(--theme-color);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  transform: translateY(-2px);
}

.fp-brand {
  padding: 16px 16px 8px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.fp-brand-logo {
  height: 28px;
  display: flex;
  align-items: center;
}

.fp-brand-logo img {
  max-height: 100%;
  max-width: 80px;
  object-fit: contain;
}

.fp-brand-tag {
  font-size: 11px;
  color: #999;
  background: #f5f5f5;
  padding: 2px 8px;
  border-radius: 3px;
  white-space: nowrap;
}

.fp-title {
  font-size: 14px;
  font-weight: 600;
  color: #333;
  padding: 4px 16px 12px;
  line-height: 1.4;
}

.fp-img {
  height: 140px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fafafa;
  margin: 0 16px;
  border-radius: 6px;
  overflow: hidden;
}

.fp-img img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s;
}

.fp-card:hover .fp-img img {
  transform: scale(1.05);
}

.fp-img-default {
  font-size: 40px;
  color: #ddd;
}

.fp-features {
  padding: 14px 16px 16px;
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.fp-feature {
  font-size: 12px;
  color: #666;
  line-height: 1.5;
  display: flex;
  align-items: flex-start;
  gap: 6px;
}

.fp-dot {
  width: 4px;
  height: 4px;
  background: #ccc;
  border-radius: 50%;
  margin-top: 7px;
  flex-shrink: 0;
}

.fp-pagination {
  display: flex;
  justify-content: center;
  gap: 8px;
  margin-top: 24px;
}

.fp-dot-page {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #ddd;
  cursor: pointer;
  transition: all 0.2s;
}

.fp-dot-page.active {
  background: var(--theme-color);
  width: 24px;
  border-radius: 4px;
}

/* 新闻资讯 - 唯样原厂动态风格 */
.news-section {
  background: #fff;
  padding: 40px 0;
  margin-top: 20px;
  margin-bottom: 20px;
}

.news-list {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0 40px;
}

.news-col {
  display: flex;
  flex-direction: column;
}

.news-item {
  display: flex;
  align-items: center;
  padding: 8px 0;
  border-bottom: 1px dashed #f0f0f0;
  cursor: pointer;
  font-size: 14px;
  line-height: 1.4;
  transition: color 0.2s;
}

.news-item:last-child {
  border-bottom: none;
}

.news-item:hover {
  color: var(--theme-color);
}

.news-dot {
  flex-shrink: 0;
  color: var(--theme-color);
  font-size: 14px;
  margin-right: 8px;
  line-height: 1;
}

.news-title {
  flex: 1;
  color: #333;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  font-size: 13px;
}

.news-item:hover .news-title {
  color: var(--theme-color);
}

.news-date {
  flex-shrink: 0;
  margin-left: 12px;
  color: #999;
  font-size: 12px;
  white-space: nowrap;
}

/* 响应式：小屏幕隐藏右侧广告 */
@media (max-width: 1024px) {
  .banner-ads {
    display: none;
  }
}
</style>

<style>
/* 全局：阻止分类侧边栏文字选中 */
.category-sidebar,
.category-sidebar *,
.category-panel,
.category-panel * {
  user-select: none !important;
  -webkit-user-select: none !important;
  -moz-user-select: none !important;
  -ms-user-select: none !important;
}
</style>