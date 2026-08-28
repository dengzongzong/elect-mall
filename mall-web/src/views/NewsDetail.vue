<template>
  <div class="news-detail-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item :to="{ path: '/news' }">新品资讯</el-breadcrumb-item>
          <el-breadcrumb-item>{{ news.title }}</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div class="detail-layout">
        <article class="news-article">
          <div class="article-img" v-if="news.image">
            <img :src="news.image" :alt="news.title" />
          </div>
          <h1 class="article-title">{{ news.title }}</h1>
          <div class="article-meta">
            <span><el-icon><Calendar /></el-icon> {{ news.date }}</span>
            <span><el-icon><View /></el-icon> {{ news.views }} 次浏览</span>
            <span><el-icon><Star /></el-icon> {{ news.likes }} 点赞</span>
          </div>
          <div class="article-content" v-html="renderedContent"></div>
          <div class="article-nav">
            <router-link to="/news" class="back-btn">
              <el-icon><ArrowLeft /></el-icon> 返回列表
            </router-link>
          </div>
        </article>
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
import { useRoute } from 'vue-router'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'
import { getNewsList, getNewsDetail } from '../api/content'

const route = useRoute()
const news = ref({ title: '加载中...', content: '', image: '', views: 0, likes: 0, date: '' })
const latestNews = ref([])

const renderedContent = computed(() => {
  const content = news.value.content || ''
  return content
    .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
    .replace(/\n/g, '<br>')
    .replace(/- /g, '&nbsp;&nbsp;• ')
})

onMounted(async () => {
  const newsId = route.params.id
  try {
    const [detailRes, listRes] = await Promise.all([
      getNewsDetail(newsId),
      getNewsList(),
    ])
    const detail = detailRes || {}
    if (detail && detail.id) {
      const date = detail.created_at ? detail.created_at.substring(0, 10) : ''
      news.value = {
        id: detail.id,
        title: detail.title,
        content: detail.content || '',
        image: detail.image || '',
        views: detail.like_count || 0,
        likes: detail.like_count || 0,
        date,
      }
    }
    const list = listRes || []
    latestNews.value = list
      .filter(n => n.id != newsId)
      .slice(0, 5)
      .map(n => ({
        id: n.id,
        title: n.title,
        shortDate: n.created_at ? n.created_at.substring(0, 10) : '',
      }))
  } catch (e) {
    console.error('获取新闻详情失败', e)
  }
})
</script>

<style scoped>
.news-detail-page {
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

.detail-layout {
  display: flex;
  gap: 24px;
  padding-bottom: 40px;
}

.news-article {
  flex: 1;
  background: #fff;
  border-radius: 8px;
  padding: 32px;
  min-width: 0;
}

.article-img {
  width: 100%;
  height: 300px;
  border-radius: 8px;
  overflow: hidden;
  margin-bottom: 24px;
  background: #f5f5f5;
}

.article-img img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.article-title {
  font-size: 22px;
  font-weight: 700;
  color: #333;
  margin-bottom: 16px;
  line-height: 1.4;
}

.article-meta {
  display: flex;
  gap: 20px;
  font-size: 13px;
  color: #999;
  padding-bottom: 20px;
  border-bottom: 1px solid #f0f0f0;
  margin-bottom: 24px;
}

.article-meta .el-icon {
  font-size: 13px;
  vertical-align: middle;
  margin-right: 2px;
}

.article-content {
  font-size: 14px;
  color: #444;
  line-height: 1.8;
}

.article-content strong {
  color: #333;
}

.article-nav {
  margin-top: 32px;
  padding-top: 20px;
  border-top: 1px solid #f0f0f0;
}

.back-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  color: #666;
  font-size: 14px;
  transition: color 0.2s;
  text-decoration: none;
}

.back-btn:hover {
  color: var(--theme-color);
}

.news-sidebar {
  width: 300px;
  flex-shrink: 0;
}

.sidebar-section {
  background: #fff;
  border-radius: 8px;
  padding: 20px;
  position: sticky;
  top: 16px;
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
  .detail-layout {
    flex-direction: column;
  }

  .news-sidebar {
    width: 100%;
  }

  .article-img {
    height: 200px;
  }
}
</style>