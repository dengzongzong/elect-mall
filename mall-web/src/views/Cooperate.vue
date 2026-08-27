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
      <div class="content">
        <div class="coop-list">
          <div class="coop-item" v-for="brand in coopBrands" :key="brand.id">
            <div class="coop-show-img">
              <img :src="brand.showImage" :alt="brand.brandName" />
            </div>
            <div class="coop-info">
              <div class="coop-logo">
                <img :src="brand.logo" :alt="brand.brandName" @error="onLogoError" />
              </div>
              <h3 class="coop-name">{{ brand.brandName }}</h3>
              <p class="coop-desc">
                <template v-for="(line, idx) in descLines(brand.description)" :key="idx">
                  <span>{{ line }}</span><br>
                </template>
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'
import { getCooperateBrands } from '../api/content'

const coopBrands = ref([])

function descLines(desc) {
  if (!desc) return ['']
  return desc.split('\n').filter(line => line.trim())
}

function onLogoError(event) {
  event.target.style.backgroundColor = '#f5f5f5'
}

onMounted(async () => {
  try {
    const res = await getCooperateBrands()
    coopBrands.value = res.data || res || []
  } catch (e) {
    console.error('获取合作品牌列表失败', e)
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

.content {
  padding-bottom: 40px;
}

.coop-list {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.coop-item {
  background: #fff;
  border-radius: 8px;
  overflow: hidden;
}

.coop-show-img {
  width: 100%;
  max-height: 400px;
  overflow: hidden;
  background: #f5f5f5;
}

.coop-show-img img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.coop-info {
  padding: 32px;
}

.coop-logo {
  width: 200px;
  height: 60px;
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  background: #fafafa;
  border-radius: 6px;
  padding: 8px 16px;
}

.coop-logo img {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
}

.coop-name {
  font-size: 18px;
  font-weight: 700;
  color: #333;
  margin-bottom: 12px;
  line-height: 1.4;
}

.coop-desc {
  font-size: 14px;
  color: #666;
  line-height: 1.8;
}

.coop-desc span {
  display: block;
  margin-bottom: 8px;
}
</style>