<template>
  <div class="category">
    <div class="page-header">
      <div class="page-title">
        <h2>分类管理</h2>
        <p>管理电子元器件的分类体系，支持多级分类结构。</p>
      </div>
      <el-button type="danger">
        <el-icon><Plus /></el-icon>新增分类
      </el-button>
    </div>
    <el-card shadow="hover">
      <el-table :data="tableData" stripe row-key="id" default-expand-all style="width: 100%">
        <el-table-column prop="name" label="分类名称" min-width="200" />
        <el-table-column prop="code" label="分类编码" width="150" />
        <el-table-column prop="sort" label="排序" width="80" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === '启用' ? 'success' : 'info'">{{ row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default>
            <el-button type="primary" link size="small">编辑</el-button>
            <el-button type="success" link size="small">新增子类</el-button>
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
  {
    id: 1,
    name: '集成电路',
    code: 'IC',
    sort: 1,
    status: '启用',
    children: [
      { id: 11, name: '微控制器(MCU)', code: 'MCU', sort: 1, status: '启用' },
      { id: 12, name: '存储器', code: 'MEM', sort: 2, status: '启用' },
      { id: 13, name: '放大器', code: 'AMP', sort: 3, status: '启用' }
    ]
  },
  {
    id: 2,
    name: '被动元件',
    code: 'PASSIVE',
    sort: 2,
    status: '启用',
    children: [
      { id: 21, name: '电阻', code: 'RES', sort: 1, status: '启用' },
      { id: 22, name: '电容', code: 'CAP', sort: 2, status: '启用' },
      { id: 23, name: '电感', code: 'IND', sort: 3, status: '启用' }
    ]
  },
  {
    id: 3,
    name: '连接器',
    code: 'CONN',
    sort: 3,
    status: '启用'
  },
  {
    id: 4,
    name: '传感器',
    code: 'SENSOR',
    sort: 4,
    status: '启用'
  }
])
</script>

<style scoped>
.category {
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