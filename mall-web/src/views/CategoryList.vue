<template>
  <div class="category-list-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>产品分类</el-breadcrumb-item>
          <el-breadcrumb-item v-if="categoryName">{{ categoryName }}</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div class="page-layout">
        <!-- 左侧筛选面板 -->
        <aside class="filter-panel">
          <div class="filter-section">
            <h4>产品分类</h4>
            <div class="filter-list">
              <div class="filter-item" v-for="cat in categories" :key="cat.id" :class="{ active: route.params.id == cat.id }">
                <router-link :to="`/category/${cat.id}`">{{ cat.name }}</router-link>
              </div>
            </div>
          </div>
          <div class="filter-section">
            <h4>品牌</h4>
            <div class="filter-list">
              <div class="filter-item" v-for="brand in brands" :key="brand">
                <a href="#">{{ brand }}</a>
              </div>
            </div>
          </div>
          <div class="filter-section">
            <h4>库存状态</h4>
            <div class="filter-list">
              <div class="filter-item"><a href="#">现货</a></div>
              <div class="filter-item"><a href="#">可订货</a></div>
            </div>
          </div>
          <div class="filter-section">
            <h4>价格区间</h4>
            <div class="price-range">
              <el-input v-model="priceMin" placeholder="最低价" size="small" />
              <span class="range-sep">-</span>
              <el-input v-model="priceMax" placeholder="最高价" size="small" />
            </div>
            <el-button type="danger" size="small" class="price-btn" @click="handleFilter">确定</el-button>
          </div>
        </aside>
        <!-- 右侧产品列表 -->
        <main class="product-main">
          <div class="list-toolbar">
            <span class="result-count">共 {{ products.length }} 个商品</span>
            <div class="sort-options">
              <span class="sort-item" :class="{ active: sortBy === 'default' }" @click="sortBy = 'default'">默认</span>
              <span class="sort-item" :class="{ active: sortBy === 'price' }" @click="sortBy = 'price'">价格</span>
              <span class="sort-item" :class="{ active: sortBy === 'sales' }" @click="sortBy = 'sales'">销量</span>
              <span class="sort-item" :class="{ active: sortBy === 'newest' }" @click="sortBy = 'newest'">最新</span>
            </div>
          </div>
          <div class="product-grid">
            <div class="product-card" v-for="p in products" :key="p.id" @click="$router.push(`/product/${p.id}`)">
              <div class="p-img"><el-icon><Cpu /></el-icon></div>
              <div class="p-info">
                <h4>{{ p.name }}</h4>
                <p class="p-model">{{ p.model }}</p>
                <p class="p-price">￥{{ p.price }}</p>
                <p class="p-stock">库存: {{ p.stock }}</p>
              </div>
            </div>
          </div>
          <div class="pagination-wrap">
            <el-pagination background layout="prev, pager, next" :total="120" />
          </div>
        </main>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'

const route = useRoute()
const priceMin = ref('')
const priceMax = ref('')
const sortBy = ref('default')

const categoryName = computed(() => {
  const cat = categories.value.find(c => c.id == route.params.id)
  return cat ? cat.name : ''
})

const categories = ref([
  { id: 1, name: 'MCU微控制器' },
  { id: 2, name: '传感器' },
  { id: 3, name: '电源管理' },
  { id: 4, name: '模拟器件' },
  { id: 5, name: '连接器' },
  { id: 6, name: '无源器件' },
  { id: 7, name: '分立半导体' },
  { id: 8, name: '存储器' },
  { id: 9, name: '无线模块' },
  { id: 10, name: '开发工具' },
])

const brands = ['ST', 'TI', 'NXP', 'Microchip', 'Infineon', 'ADI', 'Maxim', 'ON']

const products = ref([
  { id: 1, name: 'STM32F103C8T6', model: 'ARM Cortex-M3 72MHz', price: 8.50, stock: 9999 },
  { id: 2, name: 'STM32F407VGT6', model: 'ARM Cortex-M4 168MHz', price: 35.00, stock: 5000 },
  { id: 3, name: 'ESP32-WROOM-32', model: 'WiFi+BT 双核', price: 18.00, stock: 8888 },
  { id: 4, name: 'LM2596S-ADJ', model: 'DC-DC 可调降压', price: 3.20, stock: 15000 },
  { id: 5, name: 'AMS1117-3.3', model: '3.3V LDO 稳压', price: 0.35, stock: 30000 },
  { id: 6, name: 'DS18B20', model: '数字温度传感器', price: 2.80, stock: 12000 },
  { id: 7, name: 'W25Q64JVSSIQ', model: '64M-bit SPI Flash', price: 1.50, stock: 20000 },
  { id: 8, name: 'AT24C02C-SSHM-T', model: '2Kb I2C EEPROM', price: 0.60, stock: 50000 },
  { id: 9, name: 'IRF520NPBF', model: 'N沟道 MOS管 100V', price: 1.20, stock: 8000 },
  { id: 10, name: 'S8050', model: 'NPN 三极管 40V', price: 0.08, stock: 100000 },
  { id: 11, name: 'BMP280', model: '气压传感器', price: 4.50, stock: 6000 },
  { id: 12, name: 'MP1584EN', model: 'DC-DC 降压 3A', price: 2.80, stock: 9000 },
])

function handleFilter() {
  // 价格筛选逻辑
}
</script>

<style scoped>
.category-list-page {
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

.page-layout {
  display: flex;
  gap: 20px;
  padding-bottom: 40px;
}

.filter-panel {
  width: 220px;
  flex-shrink: 0;
  background: #fff;
  border-radius: 8px;
  padding: 20px;
  height: fit-content;
}

.filter-section {
  margin-bottom: 24px;
}

.filter-section h4 {
  font-size: 14px;
  font-weight: 600;
  color: #333;
  margin-bottom: 12px;
  padding-bottom: 8px;
  border-bottom: 1px solid #f0f0f0;
}

.filter-item {
  line-height: 32px;
}

.filter-item a {
  font-size: 13px;
  color: #666;
  transition: color 0.2s;
}

.filter-item.active a,
.filter-item a:hover {
  color: var(--theme-color);
}

.price-range {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 10px;
}

.range-sep {
  color: #ccc;
}

.price-btn {
  width: 100%;
}

.product-main {
  flex: 1;
}

.list-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 20px;
  background: #fff;
  border-radius: 8px;
  margin-bottom: 16px;
}

.result-count {
  font-size: 13px;
  color: #999;
}

.sort-options {
  display: flex;
  gap: 16px;
}

.sort-item {
  font-size: 13px;
  color: #666;
  cursor: pointer;
  padding: 4px 0;
  transition: color 0.2s;
}

.sort-item.active,
.sort-item:hover {
  color: var(--theme-color);
  font-weight: 600;
}

.product-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
}

.product-card {
  background: #fff;
  border-radius: 8px;
  padding: 16px;
  cursor: pointer;
  border: 1px solid #eee;
  transition: all 0.3s;
}

.product-card:hover {
  border-color: var(--theme-color);
  box-shadow: 0 4px 12px rgba(230, 0, 18, 0.08);
}

.p-img {
  height: 100px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fafafa;
  border-radius: 4px;
  margin-bottom: 12px;
}

.p-img .el-icon {
  font-size: 36px;
  color: #ddd;
}

.p-info h4 {
  font-size: 14px;
  font-weight: 600;
  color: #333;
  margin-bottom: 4px;
}

.p-model {
  font-size: 12px;
  color: #999;
  margin-bottom: 6px;
}

.p-price {
  font-size: 16px;
  font-weight: 700;
  color: var(--theme-color);
}

.p-stock {
  font-size: 12px;
  color: #999;
}

.pagination-wrap {
  margin-top: 24px;
  display: flex;
  justify-content: center;
}
</style>