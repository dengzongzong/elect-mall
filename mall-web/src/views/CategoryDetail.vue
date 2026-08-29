<template>
  <div class="category-detail">
    <MainHeader />
    <div class="container">
      <!-- 面包屑导航 -->
      <div class="breadcrumb" v-if="category">
        <el-breadcrumb>
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item :to="{ path: '/category/0' }">全部产品分类</el-breadcrumb-item>
          <el-breadcrumb-item v-if="parent">{{ parent.name }}</el-breadcrumb-item>
          <el-breadcrumb-item>{{ category.name }}</el-breadcrumb-item>
        </el-breadcrumb>
      </div>

      <!-- 分类标题 -->
      <div class="category-header" v-if="category">
        <h1>{{ category.name }}</h1>
        <p class="category-desc" v-if="category.prefix">{{ category.prefix }}</p>
      </div>

      <!-- 富文本详情内容 -->
      <div class="detail-content" v-loading="loading">
        <div v-if="category && category.description" class="rich-content" v-html="category.description"></div>
        <div v-else-if="!loading" class="empty-content">
          <el-empty description="该分类暂无详情内容" />
        </div>
      </div>

      <!-- 返回按钮 -->
      <div class="back-section">
        <el-button @click="$router.back()" plain>
          <el-icon><ArrowLeft /></el-icon>返回上一级
        </el-button>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'
import { getCategoryDetail, getCategories } from '../api/product'

const route = useRoute()
const router = useRouter()
const loading = ref(true)
const category = ref(null)
const parent = ref(null)

async function fetchDetail() {
  loading.value = true
  try {
    const id = route.params.id
    const res = await getCategoryDetail(id)
    category.value = res

    // 获取父分类信息
    if (category.value && category.value.parent_id !== '0') {
      const catRes = await getCategories()
      const allCats = catRes || []
      const found = allCats.find(c => String(c.id) === String(category.value.parent_id))
      if (found) parent.value = found
    }
  } catch (e) {
    // 自动跳回分类列表
    if (route.params.id) {
      router.replace(`/category/${route.params.id}`)
    }
  } finally {
    loading.value = false
  }
}

onMounted(() => { fetchDetail() })
</script>

<style scoped>
.category-detail {
  padding: 20px 0 60px;
  background: #f5f5f5;
  min-height: 600px;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.breadcrumb {
  margin-bottom: 20px;
}

.category-header {
  background: #fff;
  padding: 30px;
  border-radius: 8px;
  margin-bottom: 20px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.06);
}

.category-header h1 {
  font-size: 24px;
  color: #303133;
  margin: 0 0 8px;
}

.category-desc {
  font-size: 14px;
  color: #909399;
  margin: 0;
}

.detail-content {
  background: #fff;
  border-radius: 8px;
  padding: 30px;
  min-height: 300px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.06);
}

.rich-content {
  line-height: 1.8;
  color: #333;
  font-size: 14px;
}

.rich-content :deep(img) {
  max-width: 100%;
  height: auto;
  border-radius: 4px;
  margin: 10px 0;
  border: 1px solid #eee;
}

.rich-content :deep(table) {
  width: 100%;
  border-collapse: collapse;
  margin: 15px 0;
  font-size: 13px;
}

.rich-content :deep(table th),
.rich-content :deep(table td) {
  border: 1px solid #ddd;
  padding: 10px 12px;
  text-align: left;
}

.rich-content :deep(table th) {
  background: #f5f7fa;
  font-weight: 600;
  color: #303133;
}

.rich-content :deep(table tr:nth-child(even)) {
  background: #fafafa;
}

.rich-content :deep(table tr:hover) {
  background: #f0f5ff;
}

.rich-content :deep(p) {
  margin: 10px 0;
}

.rich-content :deep(h1),
.rich-content :deep(h2),
.rich-content :deep(h3) {
  margin: 20px 0 10px;
  color: #303133;
}

.rich-content :deep(ul),
.rich-content :deep(ol) {
  padding-left: 20px;
  margin: 10px 0;
}

.rich-content :deep(li) {
  margin: 4px 0;
}

.rich-content :deep(a) {
  color: #1677ff;
  text-decoration: none;
}

.rich-content :deep(a:hover) {
  text-decoration: underline;
}

.rich-content :deep(blockquote) {
  border-left: 4px solid #1677ff;
  padding: 10px 15px;
  margin: 10px 0;
  background: #f0f5ff;
  color: #555;
}

.empty-content {
  display: flex;
  justify-content: center;
  padding: 60px 0;
}

.back-section {
  margin-top: 20px;
  text-align: center;
}
</style>