<template>
  <div class="home">
    <MainHeader />

    <!-- 主内容区域：分类侧边栏 + Banner -->
    <div class="container main-area">
      <div class="content-layout">
        <!-- 分类侧边栏 -->
        <div class="category-sidebar">
          <div class="category-list">
            <div class="category-item" v-for="cat in categories" :key="cat.id" @mouseenter="activeCat = cat.id">
              <router-link :to="`/category/${cat.id}`" class="cat-link">
                <el-icon><component :is="cat.icon" /></el-icon>
                <span class="cat-name">{{ cat.name }}</span>
                <el-icon class="arrow"><ArrowRight /></el-icon>
              </router-link>
              <div class="sub-category" v-show="activeCat === cat.id" @mouseleave="activeCat = null">
                <div class="sub-cat-grid">
                  <div class="sub-cat-group" v-for="group in cat.subs" :key="group.name">
                    <h5>{{ group.name }}</h5>
                    <a v-for="item in group.items" :key="item" href="#" @click.prevent="">{{ item }}</a>
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
            <el-carousel :interval="4000" height="400px" indicator-position="inside">
              <el-carousel-item v-for="(banner, idx) in banners" :key="idx">
                <div class="banner-slide" :style="{ background: banner.bg }">
                  <div class="banner-content">
                    <h2>{{ banner.title }}</h2>
                    <p>{{ banner.subtitle }}</p>
                    <el-button type="danger" size="large" round>立即查看</el-button>
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
          <div class="brand-item" v-for="brand in brands" :key="brand.name" @click="$router.push(`/brand/${brand.id}`)">
            <div class="brand-logo-placeholder">{{ brand.name }}</div>
          </div>
        </div>
      </div>
    </div>

    <!-- 热门产品 -->
    <div class="hot-products-section">
      <div class="container">
        <div class="section-header">
          <h3>热门产品</h3>
          <router-link to="/category/0" class="more-link">查看更多 <el-icon><ArrowRight /></el-icon></router-link>
        </div>
        <div class="product-grid">
          <div class="product-card" v-for="(product, idx) in hotProducts" :key="idx" @click="$router.push(`/product/${product.id}`)">
            <div class="product-img">
              <el-icon class="product-img-icon"><Cpu /></el-icon>
            </div>
            <div class="product-info">
              <h4 class="product-name">{{ product.name }}</h4>
              <p class="product-model">{{ product.model }}</p>
              <div class="product-price">
                <span class="price">￥{{ product.price }}</span>
                <span class="stock">库存: {{ product.stock }}</span>
              </div>
              <el-button type="danger" size="small" class="add-cart-btn" @click.stop="handleAddToCart(product)">加入购物车</el-button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 合作品牌介绍 -->
    <div class="cooperation-section">
      <div class="container">
        <div class="section-header">
          <h3>合作品牌专区</h3>
          <router-link to="/cooperate" class="more-link">了解更多 <el-icon><ArrowRight /></el-icon></router-link>
        </div>
        <div class="coop-grid">
          <div class="coop-card" v-for="c in coopBrands" :key="c.name">
            <div class="coop-img-placeholder">{{ c.name }}</div>
            <p>{{ c.desc }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- 新闻资讯 -->
    <div class="news-section">
      <div class="container">
        <div class="section-header">
          <h3>新闻资讯</h3>
          <router-link to="/news" class="more-link">更多资讯 <el-icon><ArrowRight /></el-icon></router-link>
        </div>
        <div class="news-list">
          <div class="news-item" v-for="news in newsList" :key="news.id" @click="$router.push(`/news/${news.id}`)">
            <div class="news-date">
              <span class="day">{{ news.day }}</span>
              <span class="month">{{ news.month }}</span>
            </div>
            <div class="news-content">
              <h4>{{ news.title }}</h4>
              <p>{{ news.summary }}</p>
            </div>
            <el-icon class="news-arrow"><ArrowRight /></el-icon>
          </div>
        </div>
      </div>
    </div>

    <MainFooter />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'
import { useCartStore } from '../stores/cart'
import { getCategories, getBrands, getProducts } from '../api/product'
import { getCooperateBrands, getNewsList } from '../api/content'

const cartStore = useCartStore()
const activeCat = ref(null)

const categories = ref([])
const brands = ref([])
const hotProducts = ref([])
const coopBrands = ref([])
const newsList = ref([])

const banners = [
  { title: '电子元器件一站式采购', subtitle: '海量型号现货供应，正品保障', bg: 'linear-gradient(135deg, #E60012 0%, #ff4d4f 100%)' },
  { title: '新品上线 - 32位MCU', subtitle: 'STM32/GD32/AT32 系列特惠促销', bg: 'linear-gradient(135deg, #1677ff 0%, #4096ff 100%)' },
  { title: 'BOM配单服务', subtitle: '上传BOM清单，快速报价，一站配齐', bg: 'linear-gradient(135deg, #389e0d 0%, #73d13d 100%)' },
  { title: '品牌专区特惠', subtitle: '三星、村田、TDK、国巨等一线品牌直供', bg: 'linear-gradient(135deg, #722ed1 0%, #b37feb 100%)' },
  { title: '新品首发 - 车规级器件', subtitle: 'AEC-Q100/200认证车规级元器件现货特卖', bg: 'linear-gradient(135deg, #c41d7f 0%, #ff85c0 100%)' },
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
    const [catRes, brandRes, productRes, coopRes, newsRes] = await Promise.allSettled([
      getCategories(),
      getBrands(),
      getProducts({ page: 1, size: 8, orderBy: 'created_at', orderDir: 'desc' }),
      getCooperateBrands(),
      getNewsList(),
    ])

    if (catRes.status === 'fulfilled' && catRes.value?.data) {
      categories.value = catRes.value.data
    }

    if (brandRes.status === 'fulfilled' && brandRes.value?.data) {
      brands.value = brandRes.value.data
    }

    if (productRes.status === 'fulfilled' && productRes.value?.data?.records) {
      hotProducts.value = productRes.value.data.records
    }

    if (coopRes.status === 'fulfilled' && coopRes.value?.data) {
      coopBrands.value = coopRes.value.data
    }

    if (newsRes.status === 'fulfilled' && newsRes.value?.data) {
      newsList.value = newsRes.value.data.map(n => ({
        id: n.id,
        title: n.title,
        summary: n.summary || '',
        day: n.createdAt ? new Date(n.createdAt).getDate().toString().padStart(2, '0') : '',
        month: n.createdAt ? new Date(n.createdAt).getFullYear() + '-' + String(new Date(n.createdAt).getMonth() + 1).padStart(2, '0') : '',
      }))
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
}

.category-list {
  padding: 4px 0;
  position: relative;
}

.category-item {
  position: static;
}

.cat-link {
  display: flex;
  align-items: center;
  gap: 8px;
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

.cat-link .el-icon {
  font-size: 16px;
  color: var(--theme-color);
}

.cat-name {
  flex: 1;
}

.cat-link .arrow {
  font-size: 12px;
  color: #ccc;
  opacity: 0;
  transition: opacity 0.2s;
}

.cat-link:hover .arrow {
  opacity: 1;
}

.sub-category {
  position: absolute;
  left: 240px;
  top: 0;
  width: 680px;
  background: #fff;
  box-shadow: 2px 4px 16px rgba(0, 0, 0, 0.1);
  border-radius: 0 4px 4px 0;
  z-index: 50;
  min-height: 400px;
  padding: 20px;
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
}

.sub-cat-group a:hover {
  color: var(--theme-color);
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
}

.brand-item:hover {
  border-color: var(--theme-color);
  box-shadow: 0 4px 12px rgba(230, 0, 18, 0.1);
}

.brand-logo-placeholder {
  font-size: 15px;
  font-weight: 600;
  color: #666;
  transition: color 0.3s;
}

.brand-item:hover .brand-logo-placeholder {
  color: var(--theme-color);
}

/* 热门产品 */
.hot-products-section {
  background: #fff;
  padding: 40px 0;
  margin-top: 20px;
}

.product-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.product-card {
  background: #fff;
  border: 1px solid #eee;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s;
}

.product-card:hover {
  border-color: var(--theme-color);
  box-shadow: 0 4px 16px rgba(230, 0, 18, 0.1);
  transform: translateY(-2px);
}

.product-img {
  height: 160px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fafafa;
}

.product-img-icon {
  font-size: 48px;
  color: #ddd;
}

.product-info {
  padding: 14px;
}

.product-name {
  font-size: 15px;
  font-weight: 600;
  color: #333;
  margin-bottom: 4px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.product-model {
  font-size: 12px;
  color: #999;
  margin-bottom: 8px;
}

.product-price {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 10px;
}

.price {
  font-size: 18px;
  font-weight: 700;
  color: var(--theme-color);
}

.stock {
  font-size: 12px;
  color: #999;
}

.add-cart-btn {
  width: 100%;
}

/* 合作品牌 */
.cooperation-section {
  background: #fff;
  padding: 40px 0;
  margin-top: 20px;
}

.coop-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.coop-card {
  text-align: center;
  padding: 30px 20px;
  border: 1px solid #eee;
  border-radius: 8px;
  transition: all 0.3s;
}

.coop-card:hover {
  border-color: var(--theme-color);
  box-shadow: 0 4px 12px rgba(230, 0, 18, 0.08);
}

.coop-img-placeholder {
  width: 80px;
  height: 80px;
  line-height: 80px;
  margin: 0 auto 16px;
  background: var(--theme-color-light);
  color: var(--theme-color);
  border-radius: 50%;
  font-size: 20px;
  font-weight: 700;
}

.coop-card p {
  font-size: 13px;
  color: #888;
  line-height: 1.6;
}

/* 新闻资讯 */
.news-section {
  background: #fff;
  padding: 40px 0;
  margin-top: 20px;
  margin-bottom: 20px;
}

.news-list {
  display: flex;
  flex-direction: column;
  gap: 0;
}

.news-item {
  display: flex;
  align-items: center;
  gap: 20px;
  padding: 20px 0;
  border-bottom: 1px solid #f5f5f5;
  cursor: pointer;
  transition: all 0.2s;
}

.news-item:last-child {
  border-bottom: none;
}

.news-item:hover {
  padding-left: 10px;
}

.news-date {
  display: flex;
  flex-direction: column;
  align-items: center;
  min-width: 60px;
}

.day {
  font-size: 28px;
  font-weight: 700;
  color: var(--theme-color);
  line-height: 1.2;
}

.month {
  font-size: 12px;
  color: #999;
}

.news-content {
  flex: 1;
}

.news-content h4 {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin-bottom: 6px;
  transition: color 0.2s;
}

.news-item:hover .news-content h4 {
  color: var(--theme-color);
}

.news-content p {
  font-size: 13px;
  color: #999;
  line-height: 1.5;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.news-arrow {
  color: #ccc;
  font-size: 16px;
  transition: color 0.2s;
}

.news-item:hover .news-arrow {
  color: var(--theme-color);
}

/* 响应式：小屏幕隐藏右侧广告 */
@media (max-width: 1024px) {
  .banner-ads {
    display: none;
  }
}
</style>