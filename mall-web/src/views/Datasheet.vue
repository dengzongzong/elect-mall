<template>
  <div class="datasheet-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>数据手册</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div class="page-card">
        <h3>数据手册下载</h3>
        <p class="page-tip">搜索并下载元器件数据手册 (PDF)</p>
        <div class="search-box">
          <el-input v-model="keyword" placeholder="输入型号搜索数据手册..." size="large" class="ds-search-input" @keyup.enter="handleSearch">
            <template #prefix><el-icon><Search /></el-icon></template>
            <template #append>
              <el-button type="danger" @click="handleSearch">搜索</el-button>
            </template>
          </el-input>
        </div>
        <div class="ds-list">
          <div class="ds-item" v-for="d in filteredDatasheets" :key="d.id">
            <div class="ds-info">
              <h4>{{ d.title }}</h4>
              <p>{{ d.sub_category || '通用数据手册' }}</p>
            </div>
            <el-button type="primary" plain size="small" @click="handleDownload(d)">
              <el-icon><Download /></el-icon> {{ d.pdf_url ? '下载PDF' : '暂无PDF' }}
            </el-button>
          </div>
          <div class="empty-state" v-if="filteredDatasheets.length === 0">
            <p>{{ keyword ? '未找到匹配的数据手册' : '暂无数据手册' }}</p>
          </div>
        </div>
        <div class="pagination-wrap">
          <el-pagination
            background
            layout="prev, pager, next"
            :total="filteredDatasheets.length"
            :page-size="10"
          />
        </div>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'
import { getDatasheetList } from '../api/content'

const keyword = ref('')
const datasheets = ref([])

const filteredDatasheets = computed(() => {
  const kw = keyword.value.trim().toLowerCase()
  if (!kw) return datasheets.value
  return datasheets.value.filter((d) => {
    const title = (d.title || '').toLowerCase()
    const sub = (d.sub_category || '').toLowerCase()
    return title.includes(kw) || sub.includes(kw)
  })
})

async function fetchDatasheets() {
  try {
    const res = await getDatasheetList()
    datasheets.value = res?.records || (Array.isArray(res) ? res : [])
  } catch (e) {
    datasheets.value = []
  }
}

function handleSearch() {
  // 由 computed 过滤实时生效，仅触发一次即可
  fetchDatasheets()
}

function handleDownload(d) {
  if (d.pdf_url) {
    window.open(d.pdf_url, '_blank')
  } else {
    ElMessage.info('该数据手册暂未提供 PDF 下载')
  }
}

onMounted(() => {
  fetchDatasheets()
})
</script>

<style scoped>
.datasheet-page {
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
  margin-bottom: 24px;
}

.search-box {
  margin-bottom: 30px;
}

.ds-search-input :deep(.el-input-group__append) {
  background: var(--theme-color);
  border-color: var(--theme-color);
}

.ds-search-input :deep(.el-input-group__append .el-button) {
  color: #fff;
}

.ds-list {
  display: flex;
  flex-direction: column;
}

.ds-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 0;
  border-bottom: 1px solid #f5f5f5;
  transition: background 0.2s;
}

.ds-item:hover {
  background: #fafafa;
  padding-left: 10px;
  padding-right: 10px;
  border-radius: 4px;
}

.ds-info h4 {
  font-size: 15px;
  font-weight: 600;
  color: #333;
  margin-bottom: 4px;
}

.ds-info p {
  font-size: 13px;
  color: #999;
}

.pagination-wrap {
  display: flex;
  justify-content: center;
  margin-top: 24px;
}

.empty-state {
  padding: 40px 0;
  text-align: center;
  color: #999;
  font-size: 14px;
}
</style>