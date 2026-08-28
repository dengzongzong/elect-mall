<template>
  <div class="news-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>新品资讯</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div class="page-layout">
        <div class="news-content">
          <div class="news-list">
            <div class="news-item" v-for="news in newsList" :key="news.id" @click="$router.push(`/news/${news.id}`)">
              <div class="news-item-img">
                <img :src="news.image" :alt="news.title" @error="e => e.target.style.display='none'" />
              </div>
              <div class="news-item-info">
                <h3>{{ news.title }}</h3>
                <p class="news-item-desc">{{ news.summary }}</p>
                <div class="news-item-meta">
                  <span class="news-item-date">
                    <el-icon><Calendar /></el-icon> {{ news.month }}
                  </span>
                  <span class="news-item-views">
                    <el-icon><View /></el-icon> {{ news.views }}人浏览
                  </span>
                </div>
              </div>
            </div>
          </div>
          <div class="pagination-wrap" v-if="totalPages > 0">
            <el-pagination background layout="prev, pager, next" :total="total" :page-size="pageSize" :current-page="currentPage" @current-change="changePage" />
          </div>
        </div>
        <aside class="news-sidebar">
          <div class="sidebar-section">
            <h4>最新资讯</h4>
            <div class="sidebar-news-item" v-for="n in latestNews" :key="n.id" @click="$router.push(`/news/${n.id}`)">
              <p>{{ n.title }}</p>
              <span class="sidebar-date">{{ n.shortDate }}</span>
            </div>
          </div>
        </aside>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'
import { getNewsList } from '../api/content'

const newsList = ref([])
const latestNews = ref([])
const currentPage = ref(1)
const pageSize = 5
const total = ref(0)

const totalPages = computed(() => Math.ceil(total.value / pageSize))

const allNews = ref([])

onMounted(async () => {
  try {
    const res = await getNewsList()
    const data = res.data || res || []
    allNews.value = data.map(formatNews)
    total.value = data.length
    updatePage()
  } catch (e) {
    console.error('获取新闻列表失败', e)
  }
})

function formatNews(n) {
  const date = n.created_at ? new Date(n.created_at) : new Date()
  const month = date.getFullYear() + '-' + String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const shortDate = n.created_at ? n.created_at.substring(0, 10) : ''
  return {
    id: n.id,
    title: n.title,
    image: n.image || '',
    summary: (n.content || '').replace(/[*#\-\n]/g, '').substring(0, 120) + '...',
    views: n.like_count || 0,
    month: shortDate,
    day,
    shortDate,
  }
}

function updatePage() {
  const start = (currentPage.value - 1) * pageSize
  const end = start + pageSize
  newsList.value = allNews.value.slice(start, end)
  latestNews.value = allNews.value.slice(0, 5)
}

function changePage(page) {
  currentPage.value = page
  updatePage()
}
</script>

<style scoped>
.news-page {
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
  gap: 24px;
  padding-bottom: 40px;
}

.news-content {
  flex: 1;
  min-width: 0;
}

.news-list {
  background: #fff;
  border-radius: 8px;
  overflow: hidden;
}

.news-item {
  display: flex;
  gap: 20px;
  padding: 24px;
  border-bottom: 1px solid #f5f5f5;
  cursor: pointer;
  transition: all 0.2s;
}

.news-item:last-child {
  border-bottom: none;
}

.news-item:hover {
  background: #fafafa;
}

.news-item-img {
  width: 180px;
  height: 120px;
  flex-shrink: 0;
  border-radius: 6px;
  overflow: hidden;
  background: #f5f5f5;
}

.news-item-img img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s;
}

.news-item:hover .news-item-img img {
  transform: scale(1.05);
}

.news-item-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  min-width: 0;
}

.news-item-info h3 {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin-bottom: 8px;
  line-height: 1.4;
  transition: color 0.2s;
}

.news-item:hover .news-item-info h3 {
  color: var(--theme-color);
}

.news-item-desc {
  font-size: 13px;
  color: #888;
  line-height: 1.6;
  margin-bottom: 10px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.news-item-meta {
  display: flex;
  gap: 16px;
  font-size: 12px;
  color: #bbb;
}

.news-item-meta .el-icon {
  font-size: 12px;
  vertical-align: middle;
}

.pagination-wrap {
  display: flex;
  justify-content: center;
  margin-top: 24px;
}

/* 侧边栏 */
.news-sidebar {
  width: 300px;
  flex-shrink: 0;
}

.sidebar-section {
  background: #fff;
  border-radius: 8px;
  padding: 20px;
}

.sidebar-section h4 {
  font-size: 15px;
  font-weight: 600;
  color: #333;
  margin-bottom: 16px;
  padding-bottom: 10px;
  border-bottom: 2px solid var(--theme-color);
}

.sidebar-news-item {
  padding: 10px 0;
  border-bottom: 1px solid #f5f5f5;
  cursor: pointer;
  transition: color 0.2s;
}

.sidebar-news-item:last-child {
  border-bottom: none;
}

.sidebar-news-item p {
  font-size: 13px;
  color: #555;
  line-height: 1.5;
  margin-bottom: 4px;
}

.sidebar-news-item:hover p {
  color: var(--theme-color);
}

.sidebar-date {
  font-size: 12px;
  color: #bbb;
}

@media (max-width: 768px) {
  .page-layout {
    flex-direction: column;
  }

  .news-sidebar {
    width: 100%;
  }

  .news-item-img {
    width: 120px;
    height: 90px;
  }
}
</style>