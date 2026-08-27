<template>
  <div class="brand-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>品牌专区</el-breadcrumb-item>
        </el-breadcrumb>
      </div>

      <!-- 精选品牌 -->
      <div class="featured-section">
        <div class="section-header">
          <h3>品牌精选</h3>
        </div>
        <div class="featured-grid">
          <div
            class="featured-brand"
            v-for="brand in featuredBrands"
            :key="brand.id"
            @click="goToBrand(brand)"
          >
            <div class="featured-logo">
              <img :src="brand.logo" :alt="brand.name" @error="onLogoError($event, brand)" />
            </div>
            <span class="featured-name">{{ brand.name }}</span>
          </div>
        </div>
      </div>

      <!-- 字母索引 -->
      <div class="letter-index">
        <span class="letter-item" :class="{ active: activeLetter === '' }" @click="activeLetter = ''">全部</span>
        <span class="letter-item" v-for="l in letters" :key="l" :class="{ active: activeLetter === l }" @click="activeLetter = l">{{ l }}</span>
      </div>

      <!-- 品牌列表 -->
      <div class="brand-list-section">
        <div class="brand-group" v-for="group in filteredBrands" :key="group.letter">
          <div class="group-header">
            <span class="group-letter">{{ group.letter }}</span>
            <span class="group-count">{{ group.items.length }}个品牌</span>
          </div>
          <div class="brand-items">
            <div
              class="brand-item"
              v-for="brand in group.items"
              :key="brand.id"
              @click="goToBrand(brand)"
            >
              <div class="brand-logo">
                <img :src="brand.logo" :alt="brand.name" @error="onLogoError($event, brand)" />
              </div>
              <span class="brand-name">{{ brand.name }}</span>
            </div>
          </div>
        </div>
        <div v-if="filteredBrands.length === 0" class="empty-state">
          <el-icon><FolderDelete /></el-icon>
          <p>暂无该字母开头的品牌</p>
        </div>
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

const router = useRouter()
const activeLetter = ref('')
const brands = ref([])
const loading = ref(true)

const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')

const featuredBrands = computed(() => brands.value.slice(0, 35))

const brandGroups = computed(() => {
  const groups = {}
  const list = brands.value

  for (const brand of list) {
    const firstChar = (brand.name || '')[0].toUpperCase()
    const letter = /[A-Z]/.test(firstChar) ? firstChar : '#'
    if (!groups[letter]) {
      groups[letter] = { letter, items: [] }
    }
    groups[letter].items.push(brand)
  }

  const sorted = Object.keys(groups).sort((a, b) => {
    if (a === '#') return 1
    if (b === '#') return -1
    return a.localeCompare(b)
  })

  return sorted.map(k => groups[k])
})

const filteredBrands = computed(() => {
  if (!activeLetter.value) return brandGroups.value
  return brandGroups.value.filter(g => g.letter === activeLetter.value)
})

function goToBrand(brand) {
  router.push(`/brand/${brand.id}`)
}

function onLogoError(event, brand) {
  event.target.style.display = 'none'
  const fallback = event.target.parentElement.querySelector('.logo-fallback')
  if (fallback) {
    fallback.style.display = 'flex'
  }
}

onMounted(async () => {
  try {
    const res = await getBrands()
    brands.value = res.data || res || []
  } catch (e) {
    console.error('获取品牌列表失败', e)
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.brand-page {
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

/* 精选品牌 */
.featured-section {
  background: #fff;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 16px;
}

.section-header h3 {
  font-size: 14px;
  font-weight: 700;
  color: #333;
  margin-bottom: 16px;
  padding-left: 10px;
  border-left: 3px solid var(--theme-color);
}

.featured-grid {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 20px;
}

.featured-brand {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  padding: 16px 8px;
  border: 1px solid #f0f0f0;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.3s;
}

.featured-brand:hover {
  border-color: var(--theme-color);
  box-shadow: 0 4px 16px rgba(230, 0, 18, 0.08);
  transform: translateY(-2px);
}

.featured-logo {
  width: 80px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.featured-logo img {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
}

.featured-name {
  font-size: 12px;
  color: #555;
  text-align: center;
  line-height: 1.4;
}

/* 字母索引 */
.letter-index {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  padding: 12px 16px;
  background: #fff;
  border-radius: 8px;
  margin-bottom: 16px;
}

.letter-item {
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  color: #666;
  cursor: pointer;
  border-radius: 4px;
  transition: all 0.2s;
}

.letter-item:hover,
.letter-item.active {
  background: var(--theme-color);
  color: #fff;
}

/* 品牌列表 */
.brand-list-section {
  background: #fff;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 40px;
}

.brand-group {
  margin-bottom: 24px;
}

.brand-group:last-child {
  margin-bottom: 0;
}

.group-header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 12px;
  padding-bottom: 8px;
  border-bottom: 1px solid #f0f0f0;
}

.group-letter {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  background: var(--theme-color);
  color: #fff;
  font-size: 13px;
  font-weight: 700;
  border-radius: 4px;
}

.group-count {
  font-size: 12px;
  color: #999;
}

.brand-items {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 12px;
}

.brand-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  padding: 16px 8px;
  border: 1px solid #f0f0f0;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s;
}

.brand-item:hover {
  border-color: var(--theme-color);
  box-shadow: 0 4px 12px rgba(230, 0, 18, 0.06);
  transform: translateY(-1px);
}

.brand-logo {
  width: 64px;
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

.brand-name {
  font-size: 12px;
  color: #555;
  text-align: center;
  line-height: 1.3;
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
  .featured-grid,
  .brand-items {
    grid-template-columns: repeat(6, 1fr);
  }
}

@media (max-width: 992px) {
  .featured-grid,
  .brand-items {
    grid-template-columns: repeat(4, 1fr);
  }
}

@media (max-width: 768px) {
  .featured-grid,
  .brand-items {
    grid-template-columns: repeat(3, 1fr);
  }
}
</style>