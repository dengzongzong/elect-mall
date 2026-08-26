<template>
  <div class="compare-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>产品对比</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div class="page-card">
        <h3>产品对比</h3>
        <p class="page-tip">选择2-4个产品进行参数对比</p>
        <div class="compare-grid">
          <div class="compare-slot" v-for="i in 4" :key="i">
            <div class="slot-placeholder" @click="handleAddProduct">
              <el-icon><Plus /></el-icon>
              <span>添加产品</span>
            </div>
          </div>
        </div>
        <div class="compare-table" v-if="false">
          <!-- 对比表格 -->
        </div>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'

function handleAddProduct() {
  // 打开产品选择弹窗
}
</script>

<style scoped>
.compare-page {
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
  padding: 30px;
  margin-bottom: 40px;
}

.page-card h3 {
  font-size: 20px;
  font-weight: 700;
  color: #333;
  margin-bottom: 8px;
}

.page-tip {
  font-size: 14px;
  color: #999;
  margin-bottom: 24px;
}

.compare-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.slot-placeholder {
  height: 200px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 8px;
  border: 2px dashed #ddd;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s;
  color: #ccc;
}

.slot-placeholder:hover {
  border-color: var(--theme-color);
  color: var(--theme-color);
}

.slot-placeholder .el-icon {
  font-size: 36px;
}

.slot-placeholder span {
  font-size: 14px;
}
</style>