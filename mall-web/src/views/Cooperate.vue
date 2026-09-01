<template>
  <div class="cooperate-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>授权供应商</el-breadcrumb-item>
        </el-breadcrumb>
      </div>

      <!-- 顶部说明 -->
      <div class="page-hero">
        <div class="hero-inner">
          <h2 class="hero-title">品牌授权代理</h2>
          <p class="hero-sub">原厂授权 · 正品保障，与全球领先电子元器件制造商深度合作</p>
        </div>
      </div>

      <!-- 授权品牌网格墙 -->
      <div class="section-card">
        <div class="section-header">
          <h3>授权代理品牌</h3>
          <span class="section-sub">点击进入品牌专区查看全系产品</span>
        </div>
        <div class="brand-wall">
          <div
            class="brand-card"
            v-for="brand in authBrands"
            :key="brand.id"
            @click="goBrand(brand)"
          >
            <div class="brand-logo">
              <img :src="brand.logo" :alt="brand.name" @error="onLogoError($event)" />
            </div>
            <span class="brand-name">{{ brand.name }}</span>
            <span class="brand-badge">授权代理</span>
          </div>
        </div>
        <div v-if="authBrands.length === 0" class="empty-state">
          <el-icon><FolderDelete /></el-icon>
          <p>暂无授权品牌</p>
        </div>
      </div>

      <!-- 合作伙伴 -->
      <div class="section-card">
        <div class="section-header">
          <h3>合作伙伴</h3>
          <span class="section-sub">长期战略合作的授权分销商</span>
        </div>
        <div class="partner-list">
          <div class="partner-item" v-for="p in partners" :key="p.id">
            <div class="partner-show">
              <img :src="p.show_image" :alt="p.brand_name" @error="onShowError($event)" />
            </div>
            <div class="partner-info">
              <div class="partner-logo">
                <img :src="p.logo" :alt="p.brand_name" @error="onLogoError($event)" />
              </div>
              <h4 class="partner-name">{{ p.brand_name }}</h4>
              <p class="partner-desc">{{ p.description }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- 服务优势条 -->
      <div class="advantage-bar">
        <div class="adv-item"><span class="adv-key">优</span><div class="adv-text"><b>原厂授权</b><span>正品保障</span></div></div>
        <div class="adv-item"><span class="adv-key">快</span><div class="adv-text"><b>自营现货</b><span>极速发货</span></div></div>
        <div class="adv-item"><span class="adv-key">全</span><div class="adv-text"><b>品类齐全</b><span>一站采购</span></div></div>
        <div class="adv-item"><span class="adv-key">省</span><div class="adv-text"><b>满299包邮</b><span>省心省事</span></div></div>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'
import { getBrands } from '../api/product'
import { getCooperateBrands } from '../api/content'

const router = useRouter()
const brands = ref([])
const partners = ref([])

const authBrands = computed(() =>
  brands.value.filter(b => b.is_cooperate === 1 || b.is_cooperate === true)
)

function goBrand(brand) {
  router.push(`/brand/${brand.id}`)
}

function onLogoError(event) {
  event.target.style.display = 'none'
  const parent = event.target.parentElement
  if (parent && !parent.querySelector('.logo-fallback')) {
    const span = document.createElement('span')
    span.className = 'logo-fallback'
    span.textContent = 'LOGO'
    parent.appendChild(span)
  }
}

function onShowError(event) {
  event.target.parentElement.style.background = '#f5f5f5'
}

onMounted(async () => {
  try {
    const [brandRes, coopRes] = await Promise.all([
      getBrands(),
      getCooperateBrands().catch(() => null)
    ])
    brands.value = brandRes.data || brandRes || []
    if (coopRes) {
      partners.value = coopRes.data || coopRes || []
    }
  } catch (e) {
    console.error('获取授权品牌/合作伙伴失败', e)
  }
})
</script>

<style scoped>
.cooperate-page {
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

.page-hero {
  background: linear-gradient(135deg, #A8071A 0%, #E60012 100%);
  border-radius: 8px;
  margin-bottom: 16px;
  padding: 22px 28px;
}

.hero-title {
  color: #fff;
  font-size: 20px;
  font-weight: 700;
  margin-bottom: 6px;
}

.hero-sub {
  color: rgba(255, 255, 255, 0.85);
  font-size: 13px;
}

.section-card {
  background: #fff;
  border-radius: 8px;
  padding: 24px;
  margin-bottom: 16px;
}

.section-header {
  display: flex;
  align-items: baseline;
  gap: 12px;
  margin-bottom: 20px;
  padding-bottom: 12px;
  border-bottom: 1px solid #f0f0f0;
}

.section-header h3 {
  font-size: 16px;
  font-weight: 700;
  color: #333;
  padding-left: 10px;
  border-left: 3px solid var(--theme-color);
}

.section-sub {
  font-size: 12px;
  color: #999;
}

/* 授权品牌网格墙 */
.brand-wall {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 12px;
}

.brand-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  padding: 16px 8px;
  border: 1px solid #f0f0f0;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s;
  position: relative;
}

.brand-card:hover {
  border-color: var(--theme-color);
  box-shadow: 0 4px 12px rgba(230, 0, 18, 0.06);
  transform: translateY(-1px);
}

.brand-logo {
  width: 72px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.brand-logo img {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
}

.logo-fallback {
  font-size: 12px;
  color: #bbb;
  letter-spacing: 1px;
}

.brand-name {
  font-size: 12px;
  color: #555;
  text-align: center;
  line-height: 1.3;
}

.brand-badge {
  position: absolute;
  top: 6px;
  right: 6px;
  font-size: 10px;
  color: #fff;
  background: #e6a23c;
  padding: 1px 5px;
  border-radius: 3px;
}

/* 合作伙伴 */
.partner-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.partner-item {
  display: flex;
  gap: 20px;
  border: 1px solid #f0f0f0;
  border-radius: 8px;
  overflow: hidden;
}

.partner-show {
  width: 320px;
  flex-shrink: 0;
  background: #f5f5f5;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px;
}

.partner-show img {
  max-width: 100%;
  max-height: 200px;
  object-fit: contain;
}

.partner-info {
  padding: 20px;
  flex: 1;
}

.partner-logo {
  width: 160px;
  height: 50px;
  margin-bottom: 12px;
  display: flex;
  align-items: center;
}

.partner-logo img {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
}

.partner-name {
  font-size: 16px;
  font-weight: 700;
  color: #333;
  margin-bottom: 8px;
}

.partner-desc {
  font-size: 13px;
  color: #666;
  line-height: 1.8;
}

/* 服务优势条 */
.advantage-bar {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  background: #fff;
  border-radius: 8px;
  padding: 24px;
  margin-bottom: 40px;
}

.adv-item {
  display: flex;
  align-items: center;
  gap: 12px;
}

.adv-key {
  width: 44px;
  height: 44px;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--theme-color);
  color: #fff;
  font-size: 20px;
  font-weight: 700;
  border-radius: 8px;
}

.adv-text {
  display: flex;
  flex-direction: column;
}

.adv-text b {
  font-size: 14px;
  color: #333;
}

.adv-text span {
  font-size: 12px;
  color: #999;
}

.empty-state {
  text-align: center;
  padding: 60px 0;
  color: #ccc;
}

.empty-state .el-icon {
  font-size: 48px;
  margin-bottom: 12px;
}

@media (max-width: 1200px) {
  .brand-wall { grid-template-columns: repeat(6, 1fr); }
}

@media (max-width: 992px) {
  .brand-wall { grid-template-columns: repeat(4, 1fr); }
  .partner-item { flex-direction: column; }
  .partner-show { width: 100%; }
  .advantage-bar { grid-template-columns: repeat(2, 1fr); }
}

@media (max-width: 768px) {
  .brand-wall { grid-template-columns: repeat(3, 1fr); }
}
</style>
