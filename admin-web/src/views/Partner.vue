<template>
  <div class="partner">
    <div class="page-header">
      <div class="page-title">
        <h2>供应商合作管理</h2>
        <p>管理供应商合作伙伴，维护供应链合作关系。</p>
      </div>
      <div class="header-actions">
        <el-input v-model="keyword" placeholder="搜索供应商..." clearable style="width: 200px" @keyup.enter="fetchPartners" @clear="fetchPartners" />
        <el-button :disabled="!multipleSelection.length" @click="handleBatchDelete">批量删除</el-button>
        <el-button type="danger">
          <el-icon><Plus /></el-icon>新增供应商
        </el-button>
      </div>
    </div>
    <el-card shadow="hover">
      <el-table v-loading="loading" :data="tableData" stripe style="width: 100%" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" />
        <el-table-column prop="name" label="供应商名称" min-width="200" />
        <el-table-column prop="contactPerson" label="联系人" width="130" />
        <el-table-column prop="phone" label="联系电话" width="140" />
        <el-table-column prop="supplyType" label="供应类型" width="120">
          <template #default="{ row }">
            <el-tag>{{ row.supplyType }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="cooperationLevel" label="合作等级" width="100">
          <template #default="{ row }">
            <el-tag :type="levelMap[row.cooperationLevel]?.type">{{ levelMap[row.cooperationLevel]?.label }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === '合作中' ? 'success' : 'info'">{{ row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="180" fixed="right">
          <template #default>
            <el-button type="primary" link size="small">编辑</el-button>
            <el-button type="danger" link size="small">终止</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getAdminPartnerApplies, deletePartner } from '../api/admin'

const levelMap = {
  A: { label: 'A级', type: 'success' },
  B: { label: 'B级', type: 'primary' },
  C: { label: 'C级', type: 'warning' }
}

const loading = ref(false)
const tableData = ref([])
const keyword = ref('')
const multipleSelection = ref([])

async function fetchPartners() {
  loading.value = true
  try {
    const res = await getAdminPartnerApplies({ keyword: keyword.value })
    tableData.value = res.data || []
  } catch (e) {
    console.error('获取供应商列表失败', e)
  } finally {
    loading.value = false
  }
}

function handleSelectionChange(val) {
  multipleSelection.value = val
}

async function handleBatchDelete() {
  if (!multipleSelection.value.length) {
    ElMessage.warning('请先选择要删除的记录')
    return
  }
  try {
    await ElMessageBox.confirm(`确定删除选中的 ${multipleSelection.value.length} 条记录吗？`, '确认删除', {
      type: 'warning',
      confirmButtonText: '确定',
      cancelButtonText: '取消'
    })
    for (const row of multipleSelection.value) {
      await deletePartner(row.id)
    }
    ElMessage.success('批量删除成功')
    await fetchPartners()
  } catch (e) {
    // 用户取消或删除失败
  }
}

onMounted(() => {
  fetchPartners()
})
</script>

<style scoped>
.partner {
  max-width: 1400px;
}

.page-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  margin-bottom: 20px;
}

.page-title h2 {
  font-size: 22px;
  color: #303133;
  margin-bottom: 8px;
}

.page-title p {
  font-size: 14px;
  color: #909399;
}

.header-actions {
  display: flex;
  gap: 10px;
  align-items: center;
}
</style>