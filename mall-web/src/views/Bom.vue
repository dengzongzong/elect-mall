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
      <div class="page-card">
        <div class="bom-header">
          <h3>BOM配单服务</h3>
          <p>上传BOM清单，快速获取报价，一站配齐所有元器件</p>
        </div>
        <div class="bom-body">
          <div class="bom-upload">
            <el-upload drag action="#" :auto-upload="false" :on-change="handleFileChange">
              <el-icon class="upload-icon"><Upload /></el-icon>
              <div class="upload-text">
                <span>将BOM文件拖拽到此处，或 <em>点击上传</em></span>
              </div>
              <template #tip>
                <div class="upload-tip">
                  支持 Excel (.xlsx, .xls)、CSV、TXT 格式，最大 10MB
                </div>
              </template>
            </el-upload>
          </div>
          <div class="bom-or">
            <span>或</span>
          </div>
          <div class="bom-manual">
            <el-button type="danger" @click="showManualInput = true">手动输入BOM</el-button>
          </div>
          <div class="bom-form" v-if="showManualInput">
            <el-form :model="bomForm" label-width="100px">
              <el-form-item label="型号">
                <el-input v-model="bomForm.partNo" placeholder="输入型号，多个用逗号分隔" />
              </el-form-item>
              <el-form-item label="数量">
                <el-input v-model="bomForm.quantity" placeholder="输入对应数量" />
              </el-form-item>
              <el-form-item>
                <el-button type="danger" :loading="submitting" @click="handleSubmitBom">提交查询</el-button>
                <el-button @click="showManualInput = false">取消</el-button>
              </el-form-item>
            </el-form>
          </div>
          <!-- BOM 提交结果 -->
          <div class="bom-result" v-if="lastResult">
            <h4>提交结果</h4>
            <p class="result-summary">
              共 {{ lastResult.totalCount }} 个料号，匹配到 <em>{{ lastResult.matchCount }}</em> 个，预估金额
              <em class="amount">￥{{ Number(lastResult.totalAmount || 0).toFixed(2) }}</em>
            </p>
            <table class="result-table">
              <thead>
                <tr>
                  <th>料号</th>
                  <th>数量</th>
                  <th>匹配状态</th>
                  <th>单价</th>
                  <th>小计</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(it, idx) in lastResult.items" :key="idx">
                  <td>{{ it.partNo }}</td>
                  <td>{{ it.quantity }}</td>
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
            <h4>我的 BOM 记录</h4>
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
          <div class="bom-features">
            <div class="bf-item">
              <el-icon><CircleCheck /></el-icon>
              <span>智能识别型号</span>
            </div>
            <div class="bf-item">
              <el-icon><Lightning /></el-icon>
              <span>快速报价，2小时内响应</span>
            </div>
            <div class="bf-item">
              <el-icon><ShoppingCart /></el-icon>
              <span>一站式配齐，减少采购成本</span>
            </div>
            <div class="bf-item">
              <el-icon><Refund /></el-icon>
              <span>原装正品保证</span>
            </div>
          </div>
        </div>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'
import { submitBom, getUserBomList, deleteBom } from '../api/bom'

const showManualInput = ref(false)
const submitting = ref(false)
const lastResult = ref(null)
const records = ref([])

const bomForm = reactive({
  partNo: '',
  quantity: '',
})

function handleFileChange(file) {
  ElMessage.info(`已选择文件: ${file.name}。当前暂支持手动输入料号提交，文件解析即将开放`)
}

async function handleSubmitBom() {
  const partNo = bomForm.partNo.trim()
  if (!partNo) {
    ElMessage.warning('请输入型号')
    return
  }
  submitting.value = true
  try {
    const res = await submitBom({ partNo, quantity: bomForm.quantity })
    lastResult.value = res || null
    ElMessage.success(`提交成功，匹配 ${res.matchCount}/${res.totalCount}`)
    showManualInput.value = false
    await fetchRecords()
  } catch (e) {
    ElMessage.error('提交失败，请重试')
  } finally {
    submitting.value = false
  }
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

.page-card {
  background: #fff;
  border-radius: 8px;
  padding: 40px;
  margin-bottom: 40px;
}

.bom-header {
  text-align: center;
  margin-bottom: 40px;
}

.bom-header h3 {
  font-size: 26px;
  font-weight: 700;
  color: #333;
  margin-bottom: 10px;
}

.bom-header p {
  font-size: 15px;
  color: #888;
}

.bom-body {
  max-width: 600px;
  margin: 0 auto;
}

.bom-upload {
  margin-bottom: 20px;
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

.bom-or {
  text-align: center;
  margin: 20px 0;
  position: relative;
}

.bom-or::before,
.bom-or::after {
  content: '';
  position: absolute;
  top: 50%;
  width: 45%;
  height: 1px;
  background: #eee;
}

.bom-or::before { left: 0; }
.bom-or::after { right: 0; }

.bom-or span {
  background: #fff;
  padding: 0 16px;
  color: #ccc;
  font-size: 13px;
  position: relative;
  z-index: 1;
}

.bom-manual {
  text-align: center;
  margin-bottom: 24px;
}

.bom-form {
  background: #fafafa;
  padding: 24px;
  border-radius: 8px;
  margin-bottom: 24px;
}

.bom-features {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
  margin-top: 30px;
}

.bf-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px;
  background: #fafafa;
  border-radius: 6px;
  font-size: 14px;
  color: #666;
}

.bf-item .el-icon {
  color: var(--theme-color);
  font-size: 20px;
}

.bom-result,
.bom-history {
  background: #fafafa;
  border-radius: 8px;
  padding: 20px 24px;
  margin-bottom: 24px;
}

.bom-result h4,
.bom-history h4 {
  font-size: 15px;
  font-weight: 600;
  color: #333;
  margin-bottom: 12px;
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
</style>