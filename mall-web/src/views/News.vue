<template>
  <div class="news-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>新闻资讯</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div class="page-card">
        <h3>新闻资讯</h3>
        <p class="page-tip">了解电子元器件行业最新动态</p>
        <div class="news-list">
          <div class="news-item" v-for="news in newsList" :key="news.id" @click="$router.push(`/news/${news.id}`)">
            <div class="news-date">
              <span class="day">{{ news.day }}</span>
              <span class="month">{{ news.month }}</span>
            </div>
            <div class="news-content">
              <h4>{{ news.title }}</h4>
              <p class="news-summary">{{ news.summary }}</p>
              <div class="news-meta">
                <span>{{ news.source }}</span>
                <span>{{ news.views }} 次阅读</span>
              </div>
            </div>
            <el-icon class="news-arrow"><ArrowRight /></el-icon>
          </div>
        </div>
        <div class="pagination-wrap">
          <el-pagination background layout="prev, pager, next" :total="30" />
        </div>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'

const newsList = [
  { id: 1, title: '2024年电子元器件市场趋势分析', summary: '全球半导体市场预计2024年将增长13%，中国市场表现强劲，AI芯片和汽车电子成为主要增长驱动力...', day: '15', month: '2024-03', source: '行业研究', views: 1256 },
  { id: 2, title: 'STM32H7系列新品发布，性能提升50%', summary: 'ST最新推出STM32H7R/S系列，基于Arm Cortex-M7内核，主频提升至600MHz，集成神经网络加速器...', day: '12', month: '2024-03', source: '厂商动态', views: 2340 },
  { id: 3, title: 'BOM配单服务升级，支持批量上传Excel', summary: '电子元器件商城BOM配单功能全面升级，支持Excel批量导入，自动识别型号，快速报价...', day: '08', month: '2024-03', source: '平台公告', views: 876 },
  { id: 4, title: '车规级芯片供应紧张，国产替代方案推荐', summary: '随着汽车电子化率提升，车规级芯片需求持续增长，国产替代方案逐渐成熟，推荐多款国产车规级芯片...', day: '05', month: '2024-03', source: '行业分析', views: 1890 },
  { id: 5, title: '电子元器件商城入驻品牌突破500家', summary: '平台持续扩大合作品牌范围，目前已有超过500家品牌入驻，涵盖MCU、传感器、电源管理等全品类...', day: '01', month: '2024-03', source: '平台公告', views: 654 },
  { id: 6, title: 'RISC-V生态快速发展，国产MCU迎来新机遇', summary: 'RISC-V开源指令集架构快速发展，国产MCU厂商纷纷推出RISC-V产品，生态建设加速推进...', day: '28', month: '2024-02', source: '技术前沿', views: 1567 },
]
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

.page-card {
  background: #fff;
  border-radius: 8px;
  padding: 40px;
  margin-bottom: 40px;
}

.page-card h3 {
  font-size: 22px;
  font-weight: 700;
  color: #333;
  margin-bottom: 8px;
}

.page-tip {
  font-size: 14px;
  color: #999;
  margin-bottom: 30px;
}

.news-list {
  display: flex;
  flex-direction: column;
}

.news-item {
  display: flex;
  align-items: flex-start;
  gap: 20px;
  padding: 24px 0;
  border-bottom: 1px solid #f5f5f5;
  cursor: pointer;
  transition: all 0.2s;
}

.news-item:last-child {
  border-bottom: none;
}

.news-item:hover {
  padding-left: 10px;
}

.news-date {
  display: flex;
  flex-direction: column;
  align-items: center;
  min-width: 60px;
  padding-top: 4px;
}

.day {
  font-size: 28px;
  font-weight: 700;
  color: var(--theme-color);
  line-height: 1.2;
}

.month {
  font-size: 12px;
  color: #999;
}

.news-content {
  flex: 1;
}

.news-content h4 {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin-bottom: 8px;
  transition: color 0.2s;
}

.news-item:hover .news-content h4 {
  color: var(--theme-color);
}

.news-summary {
  font-size: 14px;
  color: #888;
  line-height: 1.6;
  margin-bottom: 10px;
}

.news-meta {
  display: flex;
  gap: 16px;
  font-size: 12px;
  color: #bbb;
}

.news-arrow {
  color: #ccc;
  font-size: 16px;
  margin-top: 8px;
  transition: color 0.2s;
}

.news-item:hover .news-arrow {
  color: var(--theme-color);
}

.pagination-wrap {
  display: flex;
  justify-content: center;
  margin-top: 30px;
}
</style>