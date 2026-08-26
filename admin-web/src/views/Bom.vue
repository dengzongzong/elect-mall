<template>
  <div class="bom">
    <div class="page-header">
      <div class="page-title">
        <h2>BOM管理</h2>
        <p>管理物料清单（Bill of Materials），支持BOM导入、匹配和报价。</p>
      </div>
      <div class="page-actions">
        <el-button type="danger">
          <el-icon><Upload /></el-icon>导入BOM
        </el-button>
        <el-button type="primary">
          <el-icon><Plus /></el-icon>新建BOM
        </el-button>
      </div>
    </div>
    <el-card shadow="hover">
      <el-table :data="tableData" stripe style="width: 100%">
        <el-table-column prop="id" label="BOM编号" width="140" />
        <el-table-column prop="name" label="BOM名称" min-width="200" />
        <el-table-column prop="itemCount" label="物料数量" width="100" />
        <el-table-column prop="totalPrice" label="预估总价" width="120">
          <template #default="{ row }">
            ¥{{ row.totalPrice }}
          </template>
        </el-table-column>
        <el-table-column prop="creator" label="创建人" width="120" />
        <el-table-column prop="createTime" label="创建时间" width="180" />
        <el-table-column label="操作" width="200" fixed="right">
          <template #default>
            <el-button type="primary" link size="small">查看详情</el-button>
            <el-button type="success" link size="small">一键询价</el-button>
            <el-button type="danger" link size="small">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const tableData = ref([
  { id: 'BOM-2024001', name: '智能家居控制板', itemCount: 45, totalPrice: 128.50, creator: '张三', createTime: '2024-12-01 10:30:00' },
  { id: 'BOM-2024002', name: '电机驱动模块', itemCount: 28, totalPrice: 56.80, creator: '李四', createTime: '2024-12-05 14:20:00' },
  { id: 'BOM-2024003', name: '电源管理板', itemCount: 36, totalPrice: 92.30, creator: '王五', createTime: '2024-12-10 09:15:00' }
])
</script>

<style scoped>
.bom {
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

.page-actions {
  display: flex;
  gap: 12px;
}
</style>