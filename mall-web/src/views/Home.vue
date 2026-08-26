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

        <!-- Banner 轮播 -->
        <div class="banner-area">
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
import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'
import { useCartStore } from '../stores/cart'

const cartStore = useCartStore()
const activeCat = ref(null)

const categories = [
  { id: 1, name: 'MCU微控制器', icon: 'Cpu', subs: [{ name: 'ARM Cortex-M', items: ['STM32系列', 'GD32系列', 'AT32系列', 'MM32系列'] }, { name: '8051系列', items: ['STC系列', '新唐系列', 'Silicon Labs'] }] },
  { id: 2, name: '传感器', icon: 'DataAnalysis', subs: [{ name: '温度传感器', items: ['DS18B20', 'LM75', 'SHT30'] }, { name: '压力传感器', items: ['BMP280', 'MS5611', 'HP203B'] }] },
  { id: 3, name: '电源管理', icon: 'Battery', subs: [{ name: 'DC-DC', items: ['LM2596', 'MP1584', 'TPS5430'] }, { name: 'LDO', items: ['AMS1117', 'LM1117', 'XC6206'] }] },
  { id: 4, name: '模拟器件', icon: 'TrendCharts', subs: [{ name: '运放', items: ['LM358', 'LM324', 'OPA2333'] }, { name: 'ADC/DAC', items: ['ADS1115', 'MCP3008', 'DAC8552'] }] },
  { id: 5, name: '连接器', icon: 'Connection', subs: [{ name: '排针排母', items: ['2.54mm排针', '2.0mm排母', '1.27mm排针'] }, { name: 'USB连接器', items: ['Type-C', 'Micro USB', 'Mini USB'] }] },
  { id: 6, name: '无源器件', icon: 'SetUp', subs: [{ name: '电阻', items: ['贴片电阻', '插件电阻', '精密电阻'] }, { name: '电容', items: ['MLCC', '铝电解', '钽电容'] }] },
  { id: 7, name: '分立半导体', icon: 'Monitor', subs: [{ name: '三极管', items: ['S8050', 'S8550', '2N2222'] }, { name: 'MOS管', items: ['IRF520', 'AO3400', 'SI2302'] }] },
  { id: 8, name: '存储器', icon: 'Folder', subs: [{ name: 'Flash', items: ['W25Q64', 'W25Q128', 'GD25Q64'] }, { name: 'EEPROM', items: ['AT24C02', 'AT24C256', 'M24C02'] }] },
  { id: 9, name: '无线模块', icon: 'Wifi', subs: [{ name: 'WiFi/BT', items: ['ESP8266', 'ESP32', 'CC3200'] }, { name: 'LoRa/NB-IoT', items: ['SX1278', 'ASR6505', 'BC95'] }] },
  { id: 10, name: '开发工具', icon: 'Tools', subs: [{ name: '开发板', items: ['STM32开发板', 'Arduino', 'ESP32开发板'] }, { name: '调试器', items: ['J-Link', 'ST-Link', 'DAP-Link'] }] },
]

const banners = [
  { title: '电子元器件一站式采购', subtitle: '海量型号现货供应，正品保障', bg: 'linear-gradient(135deg, #E60012 0%, #ff4d4f 100%)' },
  { title: '新品上线 - 32位MCU', subtitle: 'STM32/GD32/AT32 系列特惠促销', bg: 'linear-gradient(135deg, #1677ff 0%, #4096ff 100%)' },
  { title: 'BOM配单服务', subtitle: '上传BOM清单，快速报价，一站配齐', bg: 'linear-gradient(135deg, #389e0d 0%, #73d13d 100%)' },
]

const features = [
  { icon: 'CircleCheck', title: '品质保证', desc: '100%原装正品，专业检测' },
  { icon: 'Clock', title: '极速发货', desc: '当天16:00前下单，当天发货' },
  { icon: 'Cpu', title: '型号齐全', desc: '50万+现货型号，一应俱全' },
  { icon: 'List', title: '一站式采购', desc: 'BOM配单，批量采购更省心' },
]

const brands = [
  { id: 1, name: 'ST意法半导体' },
  { id: 2, name: 'TI德州仪器' },
  { id: 3, name: 'NXP恩智浦' },
  { id: 4, name: 'Microchip' },
  { id: 5, name: 'Infineon英飞凌' },
  { id: 6, name: 'ADI亚德诺' },
  { id: 7, name: 'Maxim美信' },
  { id: 8, name: 'ON安森美' },
  { id: 9, name: 'Renesas瑞萨' },
  { id: 10, name: 'NVIDIA英伟达' },
  { id: 11, name: 'Xilinx赛灵思' },
  { id: 12, name: 'Broadcom博通' },
]

const hotProducts = [
  { id: 1001, name: 'STM32F103C8T6', model: 'ARM Cortex-M3 MCU', price: 8.50, stock: 9999 },
  { id: 1002, name: 'ESP32-WROOM-32', model: 'WiFi+BT双模模块', price: 18.00, stock: 5000 },
  { id: 1003, name: 'LM2596S-ADJ', model: 'DC-DC降压模块', price: 3.20, stock: 8888 },
  { id: 1004, name: 'AMS1117-3.3', model: '3.3V LDO稳压器', price: 0.35, stock: 20000 },
  { id: 1005, name: 'DS18B20', model: '数字温度传感器', price: 2.80, stock: 12000 },
  { id: 1006, name: 'W25Q64JVSSIQ', model: '64M-bit SPI Flash', price: 1.50, stock: 15000 },
  { id: 1007, name: 'AT24C02C-SSHM-T', model: '2Kb I2C EEPROM', price: 0.60, stock: 30000 },
  { id: 1008, name: 'IRF520NPBF', model: 'N沟道MOS管', price: 1.20, stock: 8000 },
]

const coopBrands = [
  { name: 'ST', desc: '意法半导体，全球领先的MCU与传感器供应商' },
  { name: 'TI', desc: '德州仪器，模拟器件与嵌入式处理领导者' },
  { name: 'NXP', desc: '恩智浦半导体，汽车电子与安全连接方案' },
  { name: 'Microchip', desc: 'Microchip Technology，MCU与混合信号器件' },
]

const newsList = [
  { id: 1, title: '2024年电子元器件市场趋势分析', summary: '全球半导体市场预计2024年将增长13%，中国市场表现强劲...', day: '15', month: '2024-03' },
  { id: 2, title: 'STM32H7系列新品发布，性能提升50%', summary: 'ST最新推出STM32H7R/S系列，基于Arm Cortex-M7内核...', day: '12', month: '2024-03' },
  { id: 3, title: 'BOM配单服务升级，支持批量上传Excel', summary: '电子元器件商城BOM配单功能全面升级，支持Excel批量导入...', day: '08', month: '2024-03' },
  { id: 4, title: '车规级芯片供应紧张，国产替代方案推荐', summary: '随着汽车电子化率提升，车规级芯片需求持续增长...', day: '05', month: '2024-03' },
  { id: 5, title: '电子元器件商城入驻品牌突破500家', summary: '平台持续扩大合作品牌范围，目前已有超过500家品牌入驻...', day: '01', month: '2024-03' },
]

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

/* Banner */
.banner-area {
  flex: 1;
  border-radius: 4px;
  overflow: hidden;
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
</style>