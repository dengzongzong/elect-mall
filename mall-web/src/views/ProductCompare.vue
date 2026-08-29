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
          <template v-for="(p, idx) in compareList" :key="p.id">
            <div class="compare-slot filled">
              <div class="slot-product" @click="$router.push(`/product/${p.id}`)">
                <div class="slot-img"><el-icon :size="30"><Cpu /></el-icon></div>
                <div class="slot-title">{{ p.part_no || p.name }}</div>
                <div class="slot-price">￥{{ Number(p.price || 0).toFixed(4) }}</div>
              </div>
              <el-button class="slot-remove" type="danger" link size="small" @click="handleRemove(idx)">移除</el-button>
            </div>
          </template>
          <div class="compare-slot" v-for="i in (4 - compareList.length)" :key="'slot' + i">
            <div class="slot-placeholder" @click="openDialog">
              <el-icon><Plus /></el-icon>
              <span>添加产品</span>
            </div>
          </div>
        </div>

        <div class="compare-table" v-if="compareList.length >= 2">
          <table>
            <tbody>
              <tr>
                <td class="attr-name">图片</td>
                <td v-for="p in compareList" :key="'img' + p.id">
                  <div class="cell-img"><el-icon :size="28"><Cpu /></el-icon></div>
                </td>
              </tr>
              <tr>
                <td class="attr-name">品牌</td>
                <td v-for="p in compareList" :key="'b' + p.id">{{ p.brand_name || '-' }}</td>
              </tr>
              <tr>
                <td class="attr-name">型号</td>
                <td v-for="p in compareList" :key="'pn' + p.id">{{ p.part_no || '-' }}</td>
              </tr>
              <tr>
                <td class="attr-name">名称</td>
                <td v-for="p in compareList" :key="'n' + p.id">{{ p.name || '-' }}</td>
              </tr>
              <tr>
                <td class="attr-name">单价</td>
                <td v-for="p in compareList" :key="'p' + p.id" class="price-cell">￥{{ Number(p.price || 0).toFixed(4) }}</td>
              </tr>
              <tr>
                <td class="attr-name">库存</td>
                <td v-for="p in compareList" :key="'s' + p.id">{{ p.stock ?? '-' }}</td>
              </tr>
              <tr>
                <td class="attr-name">起订量</td>
                <td v-for="p in compareList" :key="'m' + p.id">{{ p.min_order ?? '-' }}</td>
              </tr>
              <tr>
                <td class="attr-name">单位</td>
                <td v-for="p in compareList" :key="'u' + p.id">{{ p.unit || '-' }}</td>
              </tr>
              <tr>
                <td class="attr-name">重量</td>
                <td v-for="p in compareList" :key="'w' + p.id">{{ p.weight != null ? p.weight + 'g' : '-' }}</td>
              </tr>
              <tr>
                <td class="attr-name">分类</td>
                <td v-for="p in compareList" :key="'c' + p.id">{{ p.category_name || '-' }}</td>
              </tr>
              <tr>
                <td class="attr-name">数据手册</td>
                <td v-for="p in compareList" :key="'d' + p.id">
                  <a v-if="p.datasheet_url" :href="p.datasheet_url" target="_blank">查看</a>
                  <span v-else>-</span>
                </td>
              </tr>
              <tr>
                <td class="attr-name">描述</td>
                <td v-for="p in compareList" :key="'desc' + p.id" class="desc-cell">{{ p.description || '-' }}</td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="empty-tip" v-else>至少添加 2 个产品后展示对比</div>
      </div>
    </div>
    <MainFooter />

    <!-- 添加产品弹窗 -->
    <el-dialog v-model="dialogVisible" title="添加产品对比" width="720px">
      <div class="dialog-search">
        <el-input
          v-model="keyword"
          placeholder="输入型号或名称搜索"
          size="large"
          @keyup.enter="handleSearch"
        >
          <template #append>
            <el-button type="danger" @click="handleSearch">搜索</el-button>
          </template>
        </el-input>
      </div>
      <div class="dialog-results" v-loading="searching">
        <div
          class="result-item"
          v-for="p in searchResults"
          :key="p.id"
          @click="handleAdd(p)"
        >
          <div class="result-info">
            <span class="result-part">{{ p.part_no }}</span>
            <span class="result-name">{{ p.name }}</span>
          </div>
          <span class="result-price">￥{{ Number(p.price || 0).toFixed(4) }}</span>
          <el-button
            v-if="isAdded(p.id)"
            type="success"
            link
            size="small"
            @click.stop
          >已添加</el-button>
        </div>
        <div class="empty-state" v-if="searchResults.length === 0 && searched">
          <p>未找到相关产品</p>
        </div>
        <div class="empty-state" v-if="searchResults.length === 0 && !searched">
          <p>输入关键词搜索，可对比 2-4 个产品</p>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'
import { getProducts, compareProducts } from '../api/product'

const MAX = 4

const compareList = ref([])
const dialogVisible = ref(false)
const keyword = ref('')
const searchResults = ref([])
const searching = ref(false)
const searched = ref(false)

function isAdded(id) {
  return compareList.value.some((p) => String(p.id) === String(id))
}

async function handleSearch() {
  const kw = keyword.value.trim()
  if (!kw) {
    ElMessage.warning('请输入搜索关键词')
    return
  }
  searching.value = true
  searched.value = true
  try {
    const res = await getProducts({ page: 1, size: 10, keyword: kw })
    searchResults.value = res?.records || []
  } catch (e) {
    searchResults.value = []
  } finally {
    searching.value = false
  }
}

async function handleAdd(p) {
  if (isAdded(p.id)) {
    ElMessage.info('该产品已在对比列表中')
    return
  }
  if (compareList.value.length >= MAX) {
    ElMessage.warning(`最多对比 ${MAX} 个产品`)
    return
  }
  // 先加入再批量拉详情
  compareList.value.push({ id: p.id })
  await refreshCompare()
  dialogVisible.value = false
  keyword.value = ''
  searchResults.value = []
  searched.value = false
}

async function refreshCompare() {
  if (compareList.value.length === 0) return
  const ids = compareList.value.map((p) => p.id)
  try {
    const res = await compareProducts(ids)
    const list = Array.isArray(res) ? res : []
    // 按当前添加顺序排列
    const map = {}
    list.forEach((p) => { map[p.id] = p })
    compareList.value = ids.map((id) => map[id]).filter(Boolean)
  } catch (e) {
    ElMessage.error('获取对比数据失败')
  }
}

async function handleRemove(idx) {
  compareList.value.splice(idx, 1)
  await refreshCompare()
}

function openDialog() {
  if (compareList.value.length >= MAX) {
    ElMessage.warning(`最多对比 ${MAX} 个产品`)
    return
  }
  dialogVisible.value = true
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
  margin-bottom: 30px;
}

.compare-slot {
  position: relative;
  border-radius: 8px;
}

.slot-placeholder {
  height: 160px;
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
  font-size: 32px;
}

.slot-placeholder span {
  font-size: 14px;
}

.slot-product {
  height: 160px;
  border: 1px solid #eee;
  border-radius: 8px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 6px;
  cursor: pointer;
  transition: all 0.2s;
}

.slot-product:hover {
  border-color: var(--theme-color);
}

.slot-img {
  color: #ddd;
}

.slot-title {
  font-size: 13px;
  font-weight: 600;
  color: #333;
  max-width: 90%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.slot-price {
  font-size: 14px;
  color: var(--theme-color);
  font-weight: 600;
}

.slot-remove {
  position: absolute;
  top: 4px;
  right: 4px;
}

.compare-table {
  overflow-x: auto;
}

.compare-table table {
  width: 100%;
  border-collapse: collapse;
  font-size: 13px;
}

.compare-table td {
  border: 1px solid #eee;
  padding: 10px 12px;
  vertical-align: top;
}

.compare-table .attr-name {
  background: #fafafa;
  font-weight: 600;
  color: #666;
  width: 120px;
  white-space: nowrap;
}

.cell-img {
  display: flex;
  justify-content: center;
  color: #ddd;
}

.price-cell {
  color: var(--theme-color);
  font-weight: 600;
}

.desc-cell {
  max-width: 260px;
  color: #666;
  line-height: 1.6;
}

.empty-tip {
  text-align: center;
  color: #bbb;
  padding: 30px 0;
  font-size: 14px;
}

.dialog-search {
  margin-bottom: 16px;
}

.dialog-results {
  max-height: 360px;
  overflow-y: auto;
  min-height: 100px;
}

.result-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 14px;
  border-bottom: 1px solid #f5f5f5;
  cursor: pointer;
  transition: background 0.2s;
}

.result-item:hover {
  background: #fafafa;
}

.result-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.result-part {
  font-weight: 600;
  color: #333;
  font-size: 13px;
}

.result-name {
  font-size: 12px;
  color: #999;
}

.result-price {
  color: var(--theme-color);
  font-weight: 600;
}

.empty-state {
  text-align: center;
  color: #bbb;
  padding: 30px 0;
  font-size: 13px;
}
</style>
