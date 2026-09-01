<template>
  <div class="bom-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>BOM配单</el-breadcrumb-item>
        </el-breadcrumb>
      </div>

      <!-- 顶部说明 -->
      <div class="page-hero">
        <div class="hero-inner">
          <h2 class="hero-title">智能 BOM 配单</h2>
          <p class="hero-sub">粘贴物料清单或上传 BOM 文件，快速匹配库存、获取报价，一站配齐所有元器件</p>
        </div>
      </div>

      <div class="page-card">
        <!-- 录入方式选项卡 -->
        <el-tabs v-model="activeTab" class="bom-tabs">
          <!-- 方式一：粘贴文本 -->
          <el-tab-pane label="粘贴物料清单" name="paste">
            <div class="paste-area">
              <el-input
                v-model="pasteText"
                type="textarea"
                :rows="10"
                placeholder="每行一个型号，型号与数量用空格或逗号分隔，例如：&#10;100nF-0402-X7R-50V 100&#10;10uF-0603-X5R-6.3V 50&#10;1kΩ-0603-1% 200"
              />
              <div class="paste-actions">
                <el-button type="danger" :loading="submitting" @click="handleParseAndSubmit">开始处理</el-button>
                <el-button @click="clearPaste">清空</el-button>
                <span class="paste-hint">已识别 <em>{{ parsedItems.length }}</em> 个料号</span>
              </div>
            </div>
          </el-tab-pane>

          <!-- 方式二：上传文件 -->
          <el-tab-pane label="上传 BOM 文件" name="upload">
            <div class="upload-area">
              <el-upload
                drag
                action="#"
                :auto-upload="false"
                :on-change="handleFileChange"
                accept=".csv,.xls,.xlsx,.txt"
              >
                <el-icon class="upload-icon"><Upload /></el-icon>
                <div class="upload-text">
                  <span>将 BOM 文件拖拽到此处，或 <em>点击上传</em></span>
                </div>
                <template #tip>
                  <div class="upload-tip">
                    支持 Excel (.xlsx, .xls)、CSV、TXT 格式，最大 10MB。
                    <a :href="templateUrl" target="_blank" class="tpl-link">下载 BOM 模板</a>
                  </div>
                </template>
              </el-upload>
            </div>
          </el-tab-pane>
        </el-tabs>

        <!-- 选项 -->
        <div class="bom-options">
          <el-switch v-model="onlySelf" active-text="只匹配自营商品" />
        </div>

        <!-- 提交结果 -->
        <div class="bom-result" v-if="lastResult">
          <div class="result-head">
            <h4>配单结果</h4>
            <el-button size="small" type="primary" plain @click="addAllToCart" v-if="matchedItems.length">全部加入购物车</el-button>
          </div>
          <p class="result-summary">
            共 <em>{{ lastResult.totalCount }}</em> 个料号，匹配到 <em>{{ lastResult.matchCount }}</em> 个，
            预估金额 <em class="amount">￥{{ Number(lastResult.totalAmount || 0).toFixed(2) }}</em>
          </p>
          <table class="result-table" v-if="displayItems.length">
            <thead>
              <tr>
                <th>型号</th>
                <th>数量</th>
                <th>商品名称</th>
                <th>匹配状态</th>
                <th>单价</th>
                <th>小计</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(it, idx) in displayItems" :key="idx">
                <td>{{ it.partNo }}</td>
                <td>{{ it.quantity }}</td>
                <td class="pname">{{ it.name || '-' }}</td>
                <td>
                  <span :class="['match-tag', it.match_status]">{{ it.match_status === 'matched' ? '已匹配' : '未匹配' }}</span>
                </td>
                <td>￥{{ Number(it.price || 0).toFixed(4) }}</td>
                <td>￥{{ Number(it.subtotal || 0).toFixed(2) }}</td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- 历史 BOM 记录 -->
        <div class="bom-history" v-if="records.length > 0">
          <div class="result-head">
            <h4>我的 BOM 记录</h4>
            <router-link to="/user/bom" class="history-link">管理 BOM 列表 ›</router-link>
          </div>
          <div class="record-item" v-for="r in records" :key="r.id">
            <div class="record-main">
              <span class="record-no">#{{ r.id }}</span>
              <span>匹配 {{ r.match_count }}/{{ r.total_count }}</span>
              <span>金额 ￥{{ Number(r.total_amount || 0).toFixed(2) }}</span>
              <span class="record-time">{{ r.created_at }}</span>
            </div>
            <div class="record-actions">
              <el-button size="small" @click="toggleRecord(r)">{{ r.showItems ? '收起' : '明细' }}</el-button>
              <el-button size="small" type="danger" link @click="handleDeleteRecord(r.id)">删除</el-button>
            </div>
            <div class="record-items" v-if="r.showItems">
              <div class="ri" v-for="it in r.items" :key="it.id">
                <span>{{ it.part_no }}</span>
                <span>x{{ it.quantity }}</span>
                <span>{{ it.match_status === 'matched' ? '已匹配' : '未匹配' }}</span>
                <span>￥{{ Number(it.subtotal || 0).toFixed(2) }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- 特点 -->
        <div class="bom-features">
          <div class="bf-item"><el-icon><CircleCheck /></el-icon><span>智能识别型号</span></div>
          <div class="bf-item"><el-icon><Lightning /></el-icon><span>快速报价，2 小时内响应</span></div>
          <div class="bf-item"><el-icon><ShoppingCart /></el-icon><span>一站式配齐，减少采购成本</span></div>
          <div class="bf-item"><el-icon><Refund /></el-icon><span>原装正品保证</span></div>
        </div>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'
import { submitBom, getUserBomList, deleteBom } from '../api/bom'

const router = useRouter()
const activeTab = ref('paste')
const pasteText = ref('')
const onlySelf = ref(true)
const submitting = ref(false)
const lastResult = ref(null)
const records = ref([])

const templateUrl = '/bom-template.csv'

// 解析粘贴文本：每行 型号 [分隔符] 数量
const parsedItems = computed(() => {
  const lines = pasteText.value.split('\n').map(l => l.trim()).filter(l => l)
  const items = []
  for (const line of lines) {
    // 支持 空格 / Tab / 逗号(中英文) 分隔
    const parts = line.split(/[\s,，\t]+/).filter(Boolean)
    if (!parts.length) continue
    const partNo = parts[0]
    const qty = parseInt(parts[1], 10)
    items.push({ partNo, quantity: isNaN(qty) ? 1 : qty })
  }
  return items
})

const matchedItems = computed(() => (lastResult.value?.items || []).filter(i => i.match_status === 'matched'))
const displayItems = computed(() => {
  const items = lastResult.value?.items || []
  return onlySelf.value ? items.filter(i => i.match_status === 'matched') : items
})

function clearPaste() {
  pasteText.value = ''
}

async function handleParseAndSubmit() {
  if (!parsedItems.value.length) {
    ElMessage.warning('请先粘贴包含型号和数量的物料清单')
    return
  }
  submitting.value = true
  try {
    const res = await submitBom({ items: parsedItems.value })
    lastResult.value = res || null
    ElMessage.success(`提交成功，匹配 ${res.matchCount}/${res.totalCount}`)
    await fetchRecords()
  } catch (e) {
    if (e.message && e.message.includes('未登录')) {
      router.push('/login')
    } else {
      ElMessage.error('提交失败，请重试')
    }
  } finally {
    submitting.value = false
  }
}

function handleFileChange(file) {
  ElMessage.info(`已选择文件: ${file.name}。当前版本暂支持「粘贴物料清单」方式提交，文件解析即将开放`)
}

function addAllToCart() {
  ElMessage.info('加入购物车功能开发中')
}

async function fetchRecords() {
  try {
    const res = await getUserBomList()
    records.value = (Array.isArray(res) ? res : []).map((r) => ({ ...r, showItems: false }))
  } catch (e) {
    records.value = []
  }
}

function toggleRecord(r) {
  r.showItems = !r.showItems
}

async function handleDeleteRecord(id) {
  try {
    await ElMessageBox.confirm('确定删除该条 BOM 记录吗？', '提示', { type: 'warning' })
  } catch {
    return
  }
  try {
    await deleteBom(id)
    ElMessage.success('已删除')
    await fetchRecords()
  } catch (e) {
    ElMessage.error('删除失败')
  }
}

onMounted(() => {
  fetchRecords()
})
</script>

<style scoped>
.bom-page {
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

.page-hero {
  background: linear-gradient(135deg, #A8071A 0%, #E60012 100%);
  border-radius: 8px;
  margin-bottom: 16px;
  padding: 22px 28px;
}

.hero-title {
  color: #fff;
  font-size: 20px;
  font-weight: 700;
  margin-bottom: 6px;
}

.hero-sub {
  color: rgba(255, 255, 255, 0.85);
  font-size: 13px;
}

.page-card {
  background: #fff;
  border-radius: 8px;
  padding: 28px;
  margin-bottom: 40px;
}

.bom-tabs {
  margin-bottom: 16px;
}

.paste-area .el-textarea {
  margin-bottom: 12px;
}

.paste-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.paste-hint {
  font-size: 13px;
  color: #999;
}

.paste-hint em {
  color: var(--theme-color);
  font-style: normal;
  font-weight: 600;
}

.upload-area {
  padding: 10px 0;
}

.upload-icon {
  font-size: 48px;
  color: #ccc;
  margin-bottom: 12px;
}

.upload-text {
  font-size: 14px;
  color: #666;
}

.upload-text em {
  color: var(--theme-color);
  font-style: normal;
  font-weight: 600;
}

.upload-tip {
  font-size: 12px;
  color: #bbb;
  margin-top: 8px;
}

.tpl-link {
  color: var(--theme-color);
  margin-left: 6px;
}

.bom-options {
  margin: 12px 0 20px;
}

/* 结果 */
.bom-result,
.bom-history {
  background: #fafafa;
  border-radius: 8px;
  padding: 20px 24px;
  margin-bottom: 24px;
}

.result-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 12px;
}

.result-head h4 {
  font-size: 15px;
  font-weight: 600;
  color: #333;
}

.history-link {
  font-size: 13px;
  color: var(--theme-color);
  text-decoration: none;
}

.result-summary {
  font-size: 14px;
  color: #666;
  margin-bottom: 12px;
}

.result-summary em {
  color: var(--theme-color);
  font-style: normal;
  font-weight: 600;
}

.result-summary .amount {
  font-size: 16px;
}

.result-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 13px;
}

.result-table th,
.result-table td {
  border: 1px solid #eee;
  padding: 8px 10px;
  text-align: left;
}

.result-table th {
  background: #f0f0f0;
  font-weight: 600;
}

.pname {
  max-width: 280px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.match-tag {
  display: inline-block;
  padding: 1px 8px;
  border-radius: 2px;
  font-size: 12px;
}

.match-tag.matched {
  color: #52c41a;
  background: #f6ffed;
}

.match-tag.unmatched {
  color: #ff4d4f;
  background: #fff1f0;
}

.record-item {
  padding: 12px 0;
  border-bottom: 1px solid #f0f0f0;
}

.record-item:last-child {
  border-bottom: none;
}

.record-main {
  display: flex;
  gap: 16px;
  align-items: center;
  font-size: 13px;
  color: #666;
}

.record-no {
  font-weight: 600;
  color: #333;
}

.record-time {
  color: #bbb;
  margin-left: auto;
}

.record-actions {
  margin-top: 8px;
}

.record-items {
  margin-top: 8px;
  padding: 8px 12px;
  background: #fff;
  border-radius: 4px;
}

.record-items .ri {
  display: flex;
  gap: 16px;
  font-size: 12px;
  color: #666;
  padding: 4px 0;
}

.bom-features {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-top: 30px;
}

.bf-item {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 12px;
  background: #fafafa;
  border-radius: 6px;
  font-size: 13px;
  color: #666;
}

.bf-item .el-icon {
  color: var(--theme-color);
  font-size: 18px;
}

@media (max-width: 768px) {
  .bom-features {
    grid-template-columns: repeat(2, 1fr);
  }
}
</style>
