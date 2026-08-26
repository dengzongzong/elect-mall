<template>
  <div class="cooperate">
    <div class="page-header">
      <div class="page-title">
        <h2>合作品牌管理</h2>
        <p>管理与商城合作的原厂品牌信息，维护品牌合作关系。</p>
      </div>
      <el-button type="danger">
        <el-icon><Plus /></el-icon>新增合作
      </el-button>
    </div>
    <el-card shadow="hover">
      <el-table :data="tableData" stripe style="width: 100%">
        <el-table-column prop="name" label="品牌名称" min-width="180" />
        <el-table-column prop="region" label="所属地区" width="120" />
        <el-table-column prop="contact" label="联系人" width="130" />
        <el-table-column prop="cooperationType" label="合作类型" width="120">
          <template #default="{ row }">
            <el-tag>{{ row.cooperationType }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="合作状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === '合作中' ? 'success' : 'info'">{{ row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="startDate" label="合作开始" width="120" />
        <el-table-column label="操作" width="180" fixed="right">
          <template #default>
            <el-button type="primary" link size="small">编辑</el-button>
            <el-button type="danger" link size="small">终止合作</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const tableData = ref([
  { name: 'STMicroelectronics', region: '欧洲', contact: 'Jean Martin', cooperationType: '原厂直供', status: '合作中', startDate: '2023-06-01' },
  { name: 'Texas Instruments', region: '北美', contact: 'John Smith', cooperationType: '授权代理', status: '合作中', startDate: '2023-08-15' },
  { name: 'Murata Manufacturing', region: '亚洲', contact: '田中一郎', cooperationType: '原厂直供', status: '合作中', startDate: '2024-01-10' },
  { name: 'NXP Semiconductors', region: '欧洲', contact: 'Peter van den Berg', cooperationType: '授权代理', status: '已终止', startDate: '2022-03-20' }
])
</script>

<style scoped>
.cooperate {
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