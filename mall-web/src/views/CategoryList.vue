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
              <span class="sort-item" :class="{ active: sortBy === 'default' }" @click="handleSort('default')">默认</span>
              <span class="sort-item" :class="{ active: sortBy === 'price' }" @click="handleSort('price')">价格</span>
              <span class="sort-item" :class="{ active: sortBy === 'sales' }" @click="handleSort('sales')">销量</span>
              <span class="sort-item" :class="{ active: sortBy === 'newest' }" @click="handleSort('newest')">最新</span>
            </div>
          </div>
          <div v-if="loading" class="loading-area">
            <el-skeleton :rows="3" animated />
          </div>
          <div v-else-if="products.length === 0" class="empty-area">
            <el-empty description="暂无商品" />
          </div>
          <div v-else class="product-grid">
            <div class="product-card" v-for="p in products" :key="p.id" @click="$router.push(`/product/${p.id}`)">
              <div class="p-img"><el-icon><Cpu /></el-icon></div>
              <div class="p-info">
                <h4>{{ p.name }}</h4>
                <p class="p-model">{{ p.partNo || p.model || '' }}</p>
                <p class="p-price">￥{{ p.price }}</p>
                <p class="p-stock">库存: {{ p.stock }}</p>
              </div>
            </div>
          </div>
          <div class="pagination-wrap" v-if="totalRecords > 12">
            <el-pagination background layout="prev, pager, next" :total="totalRecords" :page-size="12" @current-change="handlePageChange" />
          </div>
        </main>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'
import { getCategories, getProducts, getBrands } from '../api/product'

const route = useRoute()
const priceMin = ref('')
const priceMax = ref('')
const sortBy = ref('default')
const currentPage = ref(1)
const totalRecords = ref(0)

const categories = ref([])
const brands = ref([])
const products = ref([])
const loading = ref(false)

const categoryName = computed(() => {
  const cat = categories.value.find(c => c.id == route.params.id)
  return cat ? cat.name : '全部商品'
})

async function fetchData() {
  loading.value = true
  try {
    const [catRes, brandRes] = await Promise.allSettled([
      getCategories(),
      getBrands(),
    ])
    if (catRes.status === 'fulfilled' && catRes.value) {
      categories.value = catRes.value
    }
    if (brandRes.status === 'fulfilled' && brandRes.value) {
      brands.value = brandRes.value
    }
  } catch (e) {
    // ignore
  }
  await fetchProducts()
}

async function fetchProducts() {
  loading.value = true
  try {
    const params = {
      page: currentPage.value,
      size: 12,
    }
    if (route.params.id && route.params.id !== '0') {
      params.categoryId = route.params.id
    }
    // 价格筛选
    if (priceMin.value) params.priceMin = priceMin.value
    if (priceMax.value) params.priceMax = priceMax.value
    // 排序
    if (sortBy.value === 'price') {
      params.orderBy = 'price'
      params.orderDir = 'asc'
    } else if (sortBy.value === 'sales') {
      params.orderBy = 'sales'
      params.orderDir = 'desc'
    } else if (sortBy.value === 'newest') {
      params.orderBy = 'created_at'
      params.orderDir = 'desc'
    }

    const res = await getProducts(params)
    if (res) {
      if (res.records) {
        products.value = res.records
        totalRecords.value = res.total || 0
      } else {
        products.value = res
      }
    }
  } catch (e) {
    // ignore
  } finally {
    loading.value = false
  }
}

function handleFilter() {
  currentPage.value = 1
  fetchProducts()
}

function handleSort(val) {
  sortBy.value = val
  currentPage.value = 1
  fetchProducts()
}

function handlePageChange(page) {
  currentPage.value = page
  fetchProducts()
}

watch(() => route.params.id, () => {
  currentPage.value = 1
  fetchProducts()
})

onMounted(() => {
  fetchData()
})
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