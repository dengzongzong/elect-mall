<template>
  <div class="partner-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>合作伙伴</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div class="page-card">
        <h3>合作伙伴</h3>
        <p class="page-tip">与行业领先企业携手，共同服务客户</p>
        <div class="partner-grid">
          <div class="partner-item" v-for="p in partners" :key="p.name">
            <div class="partner-logo">{{ p.name.charAt(0) }}</div>
            <span class="partner-name">{{ p.name }}</span>
          </div>
        </div>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'

const partners = [
  '华为技术', '中兴通讯', '海康威视', '大疆创新', '小米科技',
  'OPPO', 'vivo', '比亚迪电子', '富士康科技', '立讯精密',
  '歌尔股份', '京东方', '中芯国际', '华大半导体', '紫光展锐',
  '兆易创新', '汇顶科技', '韦尔股份', '卓胜微', '圣邦微电子',
]
</script>

<style scoped>
.partner-page {
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

.partner-grid {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 20px;
}

.partner-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  padding: 24px 16px;
  border: 1px solid #eee;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s;
}

.partner-item:hover {
  border-color: var(--theme-color);
  box-shadow: 0 4px 12px rgba(230, 0, 18, 0.08);
}

.partner-logo {
  width: 56px;
  height: 56px;
  line-height: 56px;
  text-align: center;
  background: #f5f5f5;
  color: #666;
  font-size: 20px;
  font-weight: 700;
  border-radius: 50%;
  transition: all 0.3s;
}

.partner-item:hover .partner-logo {
  background: var(--theme-color-light);
  color: var(--theme-color);
}

.partner-name {
  font-size: 14px;
  color: #333;
  font-weight: 500;
}
</style>