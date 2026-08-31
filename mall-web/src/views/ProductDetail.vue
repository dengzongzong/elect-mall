<template>
  <div class="product-detail-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator=">">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item :to="{ path: `/category/${product?.category_id || 1}` }">{{ product?.category_name || '分类' }}</el-breadcrumb-item>
          <el-breadcrumb-item>{{ product?.name || product?.partNo || '加载中...' }}</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div v-if="loading" class="loading-area">
        <el-skeleton :rows="8" animated />
      </div>
      <div v-else-if="!product" class="empty-area">
        <el-empty description="商品不存在" />
      </div>
      <template v-else>
        <!-- 顶部商品主信息区：左图 / 中信息 / 右购买 -->
        <div class="product-main">
          <div class="product-gallery">
            <div class="main-image">
              <img v-if="product.imageUrl" :src="product.imageUrl" :alt="product.name" class="main-img" />
              <el-icon v-else class="product-img-icon"><Cpu /></el-icon>
            </div>
          </div>

          <div class="product-meta">
            <div class="product-title-area">
              <h1 class="product-title">{{ product.name || product.partNo }}</h1>
              <p class="product-subtitle">{{ product.description || '' }}</p>
            </div>

            <div class="meta-info">
              <div class="meta-row">
                <span class="meta-label">制造商编号</span>
                <span class="meta-value">{{ product.partNo || '-' }}</span>
              </div>
              <div class="meta-row">
                <span class="meta-label">制 造 商</span>
                <span class="meta-value brand-value">
                  <router-link v-if="product.brandName" :to="`/category/${product.category_id || 1}`">{{ product.brandName }}</router-link>
                  <span v-else>-</span>
                  <el-tag v-if="product.brandName" type="success" size="small" class="auth-tag">授权代理品牌</el-tag>
                </span>
              </div>
              <div class="meta-row">
                <span class="meta-label">供货</span>
                <span class="meta-value">自营</span>
              </div>
              <div class="meta-row">
                <span class="meta-label">无铅情况/RoHs</span>
                <span class="meta-value">无铅/符合RoHs</span>
              </div>
              <div class="meta-row">
                <span class="meta-label">描述</span>
                <span class="meta-value">{{ product.description || '-' }}</span>
              </div>
            </div>

            <div class="spec-preview">
              <h3>参数信息</h3>
              <table class="spec-table">
                <tbody>
                  <tr v-for="(label, key) in specLabels" :key="key">
                    <td class="spec-name">{{ label }}</td>
                    <td class="spec-val">{{ specValue(key) }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <div class="product-buy">
            <div class="buy-card">
              <div class="buy-row stock-row">
                <span class="buy-label">库存：</span>
                <span class="buy-stock">{{ product.stock || 0 }}</span>
                <span class="buy-unit">PCS</span>
              </div>
              <div class="buy-row">
                <span class="buy-label">单价（含税）</span>
              </div>
              <div class="tier-price-box">
                <div class="tier-row header">
                  <span>数量</span>
                  <span>单价</span>
                </div>
                <div
                  v-for="(tier, idx) in tierPrices" :key="idx"
                  :class="['tier-row', { active: quantity >= tier.min_qty }]"
                >
                  <span>{{ formatTierQty(tier.min_qty) }}+</span>
                  <span class="tier-price">￥{{ tier.price }}</span>
                </div>
                <div v-if="!tierPrices.length" class="tier-row active">
                  <span>1+</span>
                  <span class="tier-price">￥{{ product.price }}</span>
                </div>
              </div>
              <div class="buy-row qty-row">
                <span class="buy-label">购买数量：</span>
                <el-input-number v-model="quantity" :min="1" :max="9999" size="default" />
              </div>
              <div class="buy-row total-row">
                <span class="buy-label">合计：</span>
                <span class="buy-total">￥{{ totalAmount }}</span>
              </div>
              <div class="buy-actions">
                <el-button type="danger" size="large" class="buy-btn" @click="handleBuyNow">立即购买</el-button>
                <el-button type="primary" size="large" class="cart-btn" @click="handleAddCart">加入购物车</el-button>
              </div>
              <div class="buy-actions secondary">
                <el-button :type="favorited ? 'danger' : 'default'" plain @click="handleToggleFavorite">
                  <el-icon><Star /></el-icon>{{ favorited ? '已收藏' : '收藏' }}
                </el-button>
              </div>
              <div class="buy-tips">
                <p>最小起订量：{{ product.minOrder || 1 }} PCS</p>
                <p>交期：3-5 天</p>
              </div>
            </div>
          </div>
        </div>

        <!-- 下方数据手册 + 详细参数 -->
        <div class="detail-section">
          <div class="detail-left">
            <div class="detail-card datasheet-card">
              <h3 class="card-title">数据手册</h3>
              <div class="datasheet-content">
                <p v-if="!product.datasheet_url">暂无数据手册，可联系客服索取。</p>
                <a v-else :href="product.datasheet_url" target="_blank" class="datasheet-link">
                  <el-button type="primary" plain>下载数据手册 (PDF)</el-button>
                </a>
              </div>
            </div>
            <div class="detail-card param-card">
              <h3 class="card-title">参数信息</h3>
              <table class="full-param-table">
                <tbody>
                  <tr v-for="(label, key) in specLabels" :key="key">
                    <td class="param-name">{{ label }}</td>
                    <td class="param-val">{{ specValue(key) }}</td>
                    <td class="param-op">
                      <el-checkbox v-if="key !== 'category' && key !== 'brand'" size="small" />
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
          <div class="detail-right">
            <div class="detail-card recommend-card">
              <h3 class="card-title">相关商品</h3>
              <div v-if="recommendList.length" class="recommend-list">
                <div v-for="item in recommendList" :key="item.id" class="recommend-item" @click="$router.push(`/product/${item.id}`)">
                  <img v-if="item.image_url" :src="item.image_url" class="recommend-img" />
                  <div class="recommend-info">
                    <div class="recommend-name">{{ item.name || item.part_no }}</div>
                    <div class="recommend-price">￥{{ item.price }}</div>
                  </div>
                </div>
              </div>
              <el-empty v-else description="暂无相关商品" />
            </div>
          </div>
        </div>
      </template>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Cpu, Star } from '@element-plus/icons-vue'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'
import { useCartStore } from '../stores/cart'
import { getProductDetail, getBrands, getRecommendProducts } from '../api/product'
import { getFavoriteList, addFavorite, deleteFavorite } from '../api/user'

const route = useRoute()
const router = useRouter()
const cartStore = useCartStore()
const quantity = ref(1)
const product = ref(null)
const loading = ref(true)
const brandMap = ref({})
const recommendList = ref([])

const favorited = ref(false)
const favoritedId = ref(null)
const favoriting = ref(false)

const specLabels = {
  category: '商品目录',
  package: '封装/外壳',
  power: '功率',
  tolerance: '偏差',
  resistance: '电阻',
  voltage: '电压',
  feature: '产品特性',
  weight: '重量',
  brand: '品牌'
}

function specValue(key) {
  if (!product.value) return '-'
  const specs = product.value.specs || {}
  switch (key) {
    case 'category': return product.value.category_name || product.value.categoryName || '-'
    case 'brand': return product.value.brandName || '-'
    case 'weight':
      if (product.value.weight) return `${product.value.weight} g`
      return specs['重量'] || specs['weight'] || '-'
    default:
      return specs[key] || specs[specLabels[key]] || '-'
  }
}

async function checkFavorite() {
  if (!localStorage.getItem('token') || !product.value) return
  try {
    const res = await getFavoriteList()
    const list = Array.isArray(res) ? res : []
    const hit = list.find(
      (f) => String(f.product_id ?? f.productId) === String(product.value.id)
    )
    favorited.value = !!hit
    favoritedId.value = hit ? hit.id : null
  } catch (e) {
    favorited.value = false
    favoritedId.value = null
  }
}

async function fetchProduct() {
  loading.value = true
  try {
    const [detailRes, brandRes, recRes] = await Promise.all([
      getProductDetail(route.params.id),
      getBrands().catch(() => ({ data: [] })),
      getRecommendProducts().catch(() => ({ data: [] }))
    ])
    let data = null
    if (detailRes.data) {
      data = detailRes.data
    } else if (detailRes.success !== false) {
      data = detailRes
    }
    const brands = brandRes.data || brandRes || []
    const map = {}
    for (const b of brands) {
      map[b.id] = b
    }
    brandMap.value = map
    if (data) {
      const brand = map[data.brand_id] || {}
      data.brandName = brand.name || ''
      data.brandLogo = brand.logo || ''
      // 统一字段名：后端返回 part_no，模板使用 partNo
      data.partNo = data.part_no || data.partNo || ''
      data.imageUrl = data.image_url || data.imageUrl || ''
    }
    product.value = data
    recommendList.value = (recRes.data || recRes || []).filter(p => p.id !== data?.id).slice(0, 6)
    await checkFavorite()
  } catch (e) {
    ElMessage.error('获取商品详情失败')
  } finally {
    loading.value = false
  }
}

const tierPrices = computed(() => {
  return Array.isArray(product.value?.tier_prices) ? product.value.tier_prices : []
})

const currentTierPrice = computed(() => {
  if (!tierPrices.value.length) return Number(product.value?.price) || 0
  const tiers = [...tierPrices.value].sort((a, b) => (b.min_qty || 0) - (a.min_qty || 0))
  for (const t of tiers) {
    if (quantity.value >= (t.min_qty || 0)) return Number(t.price) || Number(product.value?.price) || 0
  }
  return Number(product.value?.price) || 0
})

const totalAmount = computed(() => {
  return (currentTierPrice.value * quantity.value).toFixed(4)
})

function formatTierQty(qty) {
  return Number(qty || 0).toLocaleString()
}

async function handleAddCart() {
  if (!product.value) return
  await cartStore.addItem({
    id: product.value.id,
    name: product.value.name,
    part_no: product.value.part_no || product.value.partNo,
    price: currentTierPrice.value,
    quantity: quantity.value,
    stock: product.value.stock || 0,
    image: product.value.image_url || '',
  })
  ElMessage.success('已加入购物车')
}

function handleBuyNow() {
  if (!product.value) return
  handleAddCart().then(() => {
    router.push('/cart')
  })
}

async function handleToggleFavorite() {
  if (!product.value) return
  favoriting.value = true
  try {
    if (favorited.value) {
      await deleteFavorite(favoritedId.value)
      favorited.value = false
      favoritedId.value = null
      ElMessage.success('已取消收藏')
    } else {
      await addFavorite(product.value.id)
      ElMessage.success('已收藏')
      await checkFavorite()
    }
  } catch (e) {
    ElMessage.error('操作失败，请稍后重试')
  } finally {
    favoriting.value = false
  }
}

onMounted(() => {
  fetchProduct()
})
</script>

<style scoped>
.product-detail-page {
  background: #f5f5f5;
  min-height: 100vh;
}

.container {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 20px 40px;
}

.breadcrumb {
  padding: 16px 0;
}

.loading-area,
.empty-area {
  background: #fff;
  border-radius: 8px;
  padding: 40px;
  margin-bottom: 20px;
}

.product-main {
  display: flex;
  gap: 20px;
  background: #fff;
  border-radius: 8px;
  padding: 24px;
  margin-bottom: 20px;
}

.product-gallery {
  width: 320px;
  flex-shrink: 0;
}

.main-image {
  height: 320px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fafafa;
  border: 1px solid #eee;
  border-radius: 8px;
  overflow: hidden;
}

.main-img {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
}

.product-img-icon {
  font-size: 80px;
  color: #ddd;
}

.product-meta {
  flex: 1;
  min-width: 0;
}

.product-title-area {
  margin-bottom: 16px;
}

.product-title {
  font-size: 20px;
  font-weight: 700;
  color: #333;
  margin: 0 0 8px;
}

.product-subtitle {
  font-size: 13px;
  color: #888;
  margin: 0;
}

.meta-info {
  margin-bottom: 16px;
}

.meta-row {
  display: flex;
  padding: 8px 0;
  border-bottom: 1px dashed #eee;
}

.meta-label {
  width: 100px;
  color: #999;
  font-size: 13px;
  flex-shrink: 0;
}

.meta-value {
  flex: 1;
  color: #333;
  font-size: 13px;
}

.brand-value a {
  color: var(--theme-color);
  text-decoration: none;
  margin-right: 8px;
}

.auth-tag {
  margin-left: 8px;
}

.spec-preview h3 {
  font-size: 15px;
  color: #333;
  margin: 0 0 10px;
  padding-left: 8px;
  border-left: 3px solid var(--theme-color);
}

.spec-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 13px;
}

.spec-table td {
  padding: 8px 10px;
  border: 1px solid #f0f0f0;
}

.spec-table .spec-name {
  width: 110px;
  background: #fafafa;
  color: #666;
}

.spec-table .spec-val {
  color: #333;
}

.product-buy {
  width: 300px;
  flex-shrink: 0;
}

.buy-card {
  border: 1px solid #eee;
  border-radius: 8px;
  padding: 20px;
  background: #fafafa;
}

.buy-row {
  display: flex;
  align-items: center;
  margin-bottom: 12px;
  font-size: 13px;
}

.buy-label {
  color: #666;
  margin-right: 6px;
}

.buy-stock {
  color: #52c41a;
  font-size: 20px;
  font-weight: 700;
}

.buy-unit {
  color: #666;
  margin-left: 4px;
}

.tier-price-box {
  border: 1px solid #e8e8e8;
  border-radius: 4px;
  overflow: hidden;
  margin-bottom: 16px;
  background: #fff;
}

.tier-row {
  display: flex;
  justify-content: space-between;
  padding: 8px 12px;
  border-bottom: 1px solid #f0f0f0;
  font-size: 13px;
  color: #333;
}

.tier-row:last-child {
  border-bottom: none;
}

.tier-row.header {
  background: #f5f5f5;
  color: #666;
  font-weight: 600;
}

.tier-row.active {
  background: #fff7f7;
}

.tier-row .tier-price {
  color: var(--theme-color);
  font-weight: 700;
}

.qty-row {
  align-items: center;
}

.total-row .buy-total {
  color: var(--theme-color);
  font-size: 20px;
  font-weight: 700;
}

.buy-actions {
  display: flex;
  gap: 10px;
  margin-bottom: 12px;
}

.buy-actions.secondary {
  margin-bottom: 16px;
}

.buy-btn {
  flex: 1;
}

.cart-btn {
  flex: 1;
}

.buy-tips {
  font-size: 12px;
  color: #999;
  line-height: 1.8;
}

.detail-section {
  display: flex;
  gap: 20px;
}

.detail-left {
  flex: 1;
  min-width: 0;
}

.detail-right {
  width: 280px;
  flex-shrink: 0;
}

.detail-card {
  background: #fff;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 20px;
}

.card-title {
  font-size: 16px;
  font-weight: 700;
  color: #333;
  margin: 0 0 16px;
  padding-bottom: 10px;
  border-bottom: 2px solid var(--theme-color);
  display: inline-block;
}

.full-param-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 13px;
}

.full-param-table td {
  padding: 10px 12px;
  border: 1px solid #f0f0f0;
}

.full-param-table .param-name {
  width: 140px;
  background: #fafafa;
  color: #666;
}

.full-param-table .param-val {
  color: #333;
}

.full-param-table .param-op {
  width: 60px;
  text-align: center;
}

.datasheet-content {
  padding: 10px 0;
}

.datasheet-link {
  text-decoration: none;
}

.recommend-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.recommend-item {
  display: flex;
  gap: 10px;
  cursor: pointer;
  padding: 8px;
  border-radius: 4px;
  transition: background 0.2s;
}

.recommend-item:hover {
  background: #f5f5f5;
}

.recommend-img {
  width: 60px;
  height: 60px;
  object-fit: contain;
  background: #fafafa;
  border: 1px solid #eee;
  border-radius: 4px;
}

.recommend-info {
  flex: 1;
  min-width: 0;
}

.recommend-name {
  font-size: 13px;
  color: #333;
  margin-bottom: 6px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.recommend-price {
  font-size: 14px;
  color: var(--theme-color);
  font-weight: 700;
}

@media (max-width: 1024px) {
  .product-main {
    flex-direction: column;
  }
  .product-gallery,
  .product-buy {
    width: 100%;
  }
  .detail-section {
    flex-direction: column;
  }
  .detail-right {
    width: 100%;
  }
}
</style>
