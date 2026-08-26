<template>
  <div class="user-partno">
    <div class="section-card">
      <div class="card-header">
        <h4>常用型号</h4>
        <el-button type="danger" @click="showInput = true">添加型号</el-button>
      </div>
      <div class="partno-input" v-if="showInput">
        <el-input v-model="newPartNo" placeholder="输入型号" style="width: 300px" class="partno-input-field" />
        <el-button type="danger" @click="handleAdd">添加</el-button>
        <el-button @click="showInput = false">取消</el-button>
      </div>
      <div class="partno-list">
        <div class="partno-item" v-for="(p, idx) in partNos" :key="idx">
          <div class="partno-info">
            <span class="partno-name">{{ p }}</span>
          </div>
          <div class="partno-actions">
            <el-button size="small" @click="handleSearch(p)">搜索</el-button>
            <el-button size="small" @click="handleInquiry(p)">询价</el-button>
            <el-button size="small" type="danger" link @click="handleDelete(idx)">删除</el-button>
          </div>
        </div>
      </div>
      <div class="empty-state" v-if="partNos.length === 0">
        <el-icon><Document /></el-icon>
        <p>暂无常用型号</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'

const router = useRouter()
const showInput = ref(false)
const newPartNo = ref('')

const partNos = ref([
  'STM32F103C8T6',
  'ESP32-WROOM-32',
  'LM2596S-ADJ',
  'AMS1117-3.3',
  'DS18B20',
])

function handleAdd() {
  if (newPartNo.value.trim()) {
    partNos.value.unshift(newPartNo.value.trim())
    newPartNo.value = ''
    showInput.value = false
    ElMessage.success('已添加')
  }
}

function handleSearch(partNo) {
  router.push({ path: '/category/0', query: { keyword: partNo } })
}

function handleInquiry(partNo) {
  router.push('/inquiry')
}

function handleDelete(idx) {
  partNos.value.splice(idx, 1)
  ElMessage.success('已删除')
}
</script>

<style scoped>
.section-card {
  background: #fff;
  border-radius: 8px;
  padding: 30px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  padding-bottom: 12px;
  border-bottom: 1px solid #f0f0f0;
}

.card-header h4 {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin: 0;
}

.partno-input {
  margin-bottom: 16px;
  display: flex;
  gap: 10px;
  align-items: center;
}

.partno-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 14px 0;
  border-bottom: 1px solid #f5f5f5;
}

.partno-name {
  font-size: 15px;
  font-weight: 600;
  color: #333;
}

.partno-actions {
  display: flex;
  gap: 8px;
}

.empty-state {
  text-align: center;
  padding: 60px 0;
  color: #ccc;
}

.empty-state .el-icon {
  font-size: 48px;
  margin-bottom: 12px;
}
</style>