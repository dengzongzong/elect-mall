<template>
  <div class="news-detail-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item :to="{ path: '/news' }">新闻资讯</el-breadcrumb-item>
          <el-breadcrumb-item>{{ news.title }}</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div class="detail-layout">
        <article class="news-article">
          <h1 class="article-title">{{ news.title }}</h1>
          <div class="article-meta">
            <span>{{ news.source }}</span>
            <span>{{ news.date }}</span>
            <span>{{ news.views }} 次阅读</span>
          </div>
          <div class="article-content">
            <p class="article-summary">{{ news.summary }}</p>
            <p>详细内容正在加载中...</p>
            <p>随着电子元器件行业的快速发展，市场需求不断增长。我们的平台致力于为客户提供最新、最全面的行业资讯和技术动态。</p>
            <p>请持续关注我们的新闻栏目，获取更多有价值的信息。</p>
          </div>
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
            </div>
          </div>
        </aside>
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

const news = ref({
  id: route.params.id,
  title: '2024年电子元器件市场趋势分析',
  source: '行业研究',
  date: '2024-03-15',
  views: 1256,
  summary: '全球半导体市场预计2024年将增长13%，中国市场表现强劲，AI芯片和汽车电子成为主要增长驱动力...',
})

const latestNews = [
  { id: 1, title: '2024年电子元器件市场趋势分析' },
  { id: 2, title: 'STM32H7系列新品发布，性能提升50%' },
  { id: 3, title: 'BOM配单服务升级，支持批量上传Excel' },
  { id: 4, title: '车规级芯片供应紧张，国产替代方案推荐' },
  { id: 5, title: 'RISC-V生态快速发展，国产MCU迎来新机遇' },
]
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
  padding: 40px;
}

.article-title {
  font-size: 26px;
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

.article-content {
  font-size: 15px;
  color: #444;
  line-height: 1.8;
}

.article-content p {
  margin-bottom: 16px;
}

.article-summary {
  font-size: 16px;
  font-weight: 600;
  color: #555;
  background: #fafafa;
  padding: 16px 20px;
  border-radius: 6px;
  border-left: 4px solid var(--theme-color);
}

.article-nav {
  margin-top: 40px;
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
}

.sidebar-section h4 {
  font-size: 16px;
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
  color: #666;
  line-height: 1.5;
}

.sidebar-news-item:hover p {
  color: var(--theme-color);
}
</style>