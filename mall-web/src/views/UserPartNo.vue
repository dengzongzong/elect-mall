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
        <div class="partno-item" v-for="p in partNos" :key="p.id">
          <div class="partno-info">
            <span class="partno-name">{{ p.part_no }}</span>
          </div>
          <div class="partno-actions">
            <el-button size="small" @click="handleSearch(p.part_no)">搜索</el-button>
            <el-button size="small" @click="handleInquiry(p.part_no)">询价</el-button>
            <el-button size="small" type="danger" link @click="handleDelete(p.id)">删除</el-button>
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
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getPartNoList, addPartNo, deletePartNo } from '../api/user'

const router = useRouter()
const showInput = ref(false)
const newPartNo = ref('')
const adding = ref(false)

const partNos = ref([])

async function fetchPartNos() {
  try {
    const res = await getPartNoList()
    partNos.value = Array.isArray(res) ? res : []
  } catch (e) {
    partNos.value = []
  }
}

async function handleAdd() {
  const val = newPartNo.value.trim()
  if (!val) return
  adding.value = true
  try {
    await addPartNo(val)
    ElMessage.success('已添加')
    newPartNo.value = ''
    showInput.value = false
    await fetchPartNos()
  } catch (e) {
    ElMessage.error('添加失败')
  } finally {
    adding.value = false
  }
}

function handleSearch(partNo) {
  router.push({ path: '/category/0', query: { keyword: partNo } })
}

function handleInquiry(partNo) {
  router.push('/inquiry')
}

async function handleDelete(id) {
  try {
    await ElMessageBox.confirm('确定删除该型号吗？', '提示', { type: 'warning' })
  } catch {
    return
  }
  try {
    await deletePartNo(id)
    ElMessage.success('已删除')
    await fetchPartNos()
  } catch (e) {
    ElMessage.error('删除失败')
  }
}

onMounted(() => {
  fetchPartNos()
})
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