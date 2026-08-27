<template>
  <div class="partner">
    <div class="page-header">
      <div class="page-title">
        <h2>供应商合作管理</h2>
        <p>管理供应商合作伙伴，维护供应链合作关系。</p>
      </div>
      <el-button type="danger">
        <el-icon><Plus /></el-icon>新增供应商
      </el-button>
    </div>
    <el-card shadow="hover">
      <el-table v-loading="loading" :data="tableData" stripe style="width: 100%">
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
import { getAdminPartnerApplies } from '../api/admin'

const levelMap = {
  A: { label: 'A级', type: 'success' },
  B: { label: 'B级', type: 'primary' },
  C: { label: 'C级', type: 'warning' }
}

const loading = ref(false)
const tableData = ref([])

async function fetchPartners() {
  loading.value = true
  try {
    const res = await getAdminPartnerApplies()
    tableData.value = res.data || []
  } catch (e) {
    console.error('获取供应商列表失败', e)
  } finally {
    loading.value = false
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
</style>