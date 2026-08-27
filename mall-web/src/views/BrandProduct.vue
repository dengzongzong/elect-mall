<template>
  <div class="brand-product-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item :to="{ path: '/brand' }">品牌专区</el-breadcrumb-item>
          <el-breadcrumb-item>{{ brand?.name || '品牌详情' }}</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div class="brand-header">
        <div class="brand-logo-wrap">
          <img :src="brand?.logo" :alt="brand?.name" class="brand-logo-img" />
        </div>
        <div class="brand-info">
          <h2>{{ brand?.name }}</h2>
          <p class="brand-desc">{{ brand?.description || '浏览该品牌下的所有产品' }}</p>
        </div>
      </div>
      <div class="product-grid">
        <div class="product-card" v-for="p in products" :key="p.id" @click="$router.push(`/product/${p.id}`)">
          <div class="p-img"><el-icon><Cpu /></el-icon></div>
          <div class="p-info">
            <h4>{{ p.name }}</h4>
            <p class="p-model">{{ p.partNo }}</p>
            <p class="p-price" v-if="p.price">￥{{ p.price }}</p>
          </div>
        </div>
      </div>
      <div v-if="products.length === 0" class="empty-state">
        <el-icon><FolderDeleted /></el-icon>
        <p>该品牌暂无商品</p>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'
import { getBrands, getBrandProducts } from '../api/product'

const route = useRoute()
const brand = ref(null)
const products = ref([])

onMounted(async () => {
  const brandId = route.params.id
  try {
    const [brandRes, productRes] = await Promise.all([
      getBrands(),
      getBrandProducts(brandId).catch(() => null)
    ])
    const brandList = brandRes.data || brandRes || []
    brand.value = brandList.find(b => b.id == brandId) || null
    if (productRes) {
      products.value = productRes.data || productRes || []
    }
  } catch (e) {
    console.error('获取品牌数据失败', e)
  }
})
</script>

<style scoped>
.brand-product-page {
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

.brand-header {
  display: flex;
  align-items: center;
  gap: 20px;
  padding: 20px;
  background: #fff;
  border-radius: 8px;
  margin-bottom: 16px;
}

.brand-logo-wrap {
  width: 80px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  border: 1px solid #f0f0f0;
  border-radius: 6px;
  padding: 8px;
}

.brand-logo-img {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
}

.brand-info h2 {
  font-size: 18px;
  font-weight: 700;
  color: #333;
  margin-bottom: 4px;
}

.brand-desc {
  font-size: 12px;
  color: #888;
  line-height: 1.6;
}

.product-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 12px;
  background: #fff;
  border-radius: 8px;
  padding: 16px;
  margin-bottom: 20px;
}

.product-card {
  border: 1px solid #eee;
  border-radius: 6px;
  overflow: hidden;
  cursor: pointer;
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
}

.p-img .el-icon {
  font-size: 36px;
  color: #ddd;
}

.p-info {
  padding: 10px;
}

.p-info h4 {
  font-size: 13px;
  font-weight: 600;
  color: #333;
  margin-bottom: 4px;
}

.p-model {
  font-size: 12px;
  color: #999;
  margin-bottom: 4px;
}

.p-price {
  font-size: 14px;
  font-weight: 700;
  color: var(--theme-color);
}

.empty-state {
  text-align: center;
  padding: 80px 0;
  color: #ccc;
  background: #fff;
  border-radius: 8px;
}

.empty-state .el-icon {
  font-size: 48px;
  margin-bottom: 12px;
}
</style>