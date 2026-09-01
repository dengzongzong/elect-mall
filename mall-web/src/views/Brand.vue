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

      <!-- 顶部说明 -->
      <div class="page-hero">
        <div class="hero-inner">
          <h2 class="hero-title">授权代理品牌列表</h2>
          <p class="hero-sub">TDK、国巨(YAGEO)、基美(KEMET)、村田(Murata) 等全球领先原厂授权代理</p>
        </div>
      </div>

      <!-- 精选品牌 -->
      <div class="featured-section">
        <div class="section-header">
          <h3>精选品牌</h3>
        </div>
        <div class="featured-grid">
          <div
            class="featured-brand"
            v-for="brand in featuredBrands"
            :key="brand.id"
            @click="goToBrand(brand)"
          >
            <div class="featured-logo">
              <img :src="brand.logo" :alt="brand.name" @error="onLogoError($event)" />
            </div>
            <span class="featured-name">{{ brand.name }}</span>
          </div>
        </div>
      </div>

      <!-- 筛选工具栏 -->
      <div class="toolbar">
        <div class="toolbar-left">
          <span class="toolbar-label">按分类选品牌：</span>
          <el-select v-model="selectedCategory" placeholder="全部分类" clearable size="default" class="cat-select">
            <el-option label="全部分类" value="" />
            <el-option
              v-for="cat in categoryOptions"
              :key="cat.id"
              :label="cat.name"
              :value="cat.name"
            />
          </el-select>
        </div>
        <div class="toolbar-right">
          <el-input
            v-model="keyword"
            placeholder="搜索品牌名称"
            clearable
            class="search-input"
            @keyup.enter="onSearch"
            @clear="onSearch"
          >
            <template #append>
              <el-button @click="onSearch">
                <el-icon><Search /></el-icon>
                搜索
              </el-button>
            </template>
          </el-input>
        </div>
      </div>

      <!-- 字母索引 -->
      <div class="letter-index" v-if="!keyword && !selectedCategory">
        <span class="letter-all" :class="{ active: activeLetter === '' }" @click="activeLetter = ''">全部</span>
        <span
          class="letter-item"
          v-for="l in letters"
          :key="l"
          :class="{ active: activeLetter === l, disabled: !availableLetters.includes(l) }"
          @click="availableLetters.includes(l) && (activeLetter = l)"
        >{{ l }}</span>
      </div>

      <!-- 品牌列表 -->
      <div class="brand-list-section">
        <div class="brand-group" v-for="group in filteredBrands" :key="group.letter" :ref="el => setGroupRef(el, group.letter)">
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
                <img :src="brand.logo" :alt="brand.name" @error="onLogoError($event)" />
              </div>
              <span class="brand-name">{{ brand.name }}</span>
              <span class="brand-count" v-if="brand.product_count > 0">{{ brand.product_count }} 件商品</span>
              <span class="brand-count muted" v-else>敬请期待</span>
              <span class="brand-tag" v-if="brand.is_cooperate === 1">授权代理品牌</span>
            </div>
          </div>
        </div>
        <div v-if="filteredBrands.length === 0" class="empty-state">
          <el-icon><FolderDelete /></el-icon>
          <p>没有找到匹配的品牌</p>
        </div>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { ref, computed, onMounted, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'
import { getBrands, getCategoryTree } from '../api/product'

const router = useRouter()
const brands = ref([])
const categories = ref([])
const activeLetter = ref('')
const keyword = ref('')
const selectedCategory = ref('')
const groupRefs = {}

const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')

function setGroupRef(el, letter) {
  if (el) groupRefs[letter] = el
}

const featuredBrands = computed(() => brands.value.slice(0, 35))

const categoryOptions = computed(() =>
  categories.value.map(c => ({ id: c.id, name: c.name }))
)

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

const availableLetters = computed(() => brandGroups.value.map(g => g.letter))

function matchFilter(brand) {
  if (keyword.value) {
    const kw = keyword.value.toLowerCase()
    const hay = (brand.name + ' ' + (brand.description || '')).toLowerCase()
    if (!hay.includes(kw)) return false
  }
  if (selectedCategory.value) {
    const cat = selectedCategory.value
    const hay = (brand.name + ' ' + (brand.description || '')).toLowerCase()
    if (!hay.includes(cat.toLowerCase())) return false
  }
  return true
}

const filteredBrands = computed(() => {
  let groups = brandGroups.value

  if (keyword.value || selectedCategory.value) {
    return groups
      .map(g => ({ ...g, items: g.items.filter(matchFilter) }))
      .filter(g => g.items.length > 0)
  }

  if (!activeLetter.value) return groups
  return groups.filter(g => g.letter === activeLetter.value)
})

function onSearch() {
  activeLetter.value = ''
  nextTick(() => {
    const first = filteredBrands.value[0]
    if (first && groupRefs[first.letter]) {
      groupRefs[first.letter].scrollIntoView({ behavior: 'smooth', block: 'start' })
    }
  })
}

function goToBrand(brand) {
  router.push(`/brand/${brand.id}`)
}

function onLogoError(event) {
  event.target.style.display = 'none'
  const parent = event.target.parentElement
  if (parent && !parent.querySelector('.logo-text')) {
    const span = document.createElement('span')
    span.className = 'logo-text'
    span.textContent = 'LOGO'
    parent.appendChild(span)
  }
}

    onMounted(async () => {
  try {
    const [brandRes, catRes] = await Promise.all([
      getBrands(),
      getCategoryTree().catch(() => null)
    ])
    brands.value = brandRes.data || brandRes || []
    if (catRes) {
      const cats = catRes.data || catRes || []
      // 扁平化全部类目（一级+二级），作为分类筛选项
      const flat = []
      cats.forEach(top => {
        flat.push({ id: top.id, name: top.name })
        if (top.children && top.children.length) {
          top.children.forEach(sub => flat.push({ id: sub.id, name: sub.name }))
        }
      })
      categories.value = flat
    }
  } catch (e) {
    console.error('获取品牌列表失败', e)
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

/* 顶部说明 */
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

/* 筛选工具栏 */
.toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 12px;
  background: #fff;
  border-radius: 8px;
  padding: 14px 18px;
  margin-bottom: 16px;
}

.toolbar-left {
  display: flex;
  align-items: center;
  gap: 10px;
}

.toolbar-label {
  font-size: 13px;
  color: #666;
}

.cat-select {
  width: 200px;
}

.search-input {
  width: 320px;
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

.letter-all {
  height: 32px;
  padding: 0 12px;
  display: inline-flex;
  align-items: center;
  font-size: 12px;
  color: #666;
  cursor: pointer;
  border-radius: 4px;
  transition: all 0.2s;
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

.letter-item.disabled {
  color: #ccc;
  cursor: not-allowed;
}

.letter-all:hover,
.letter-item:hover:not(.disabled),
.letter-all.active,
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
  scroll-margin-top: 80px;
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
  gap: 6px;
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

.logo-text {
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

.brand-count {
  font-size: 11px;
  color: var(--theme-color);
  font-weight: 600;
}

.brand-count.muted {
  color: #bbb;
  font-weight: 400;
}

.brand-tag {
  font-size: 10px;
  color: #fff;
  background: #e6a23c;
  padding: 1px 6px;
  border-radius: 3px;
  line-height: 1.4;
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
