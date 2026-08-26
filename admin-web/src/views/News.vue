<template>
  <div class="news">
    <div class="page-header">
      <div class="page-title">
        <h2>新闻管理</h2>
        <p>发布和管理商城新闻资讯、行业动态等内容。</p>
      </div>
      <el-button type="danger">
        <el-icon><Edit /></el-icon>发布新闻
      </el-button>
    </div>
    <el-card shadow="hover">
      <el-table :data="tableData" stripe style="width: 100%">
        <el-table-column prop="id" label="编号" width="80" />
        <el-table-column prop="title" label="新闻标题" min-width="280" />
        <el-table-column prop="author" label="作者" width="120" />
        <el-table-column prop="category" label="分类" width="120" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === '已发布' ? 'success' : 'info'">{{ row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="publishTime" label="发布时间" width="180" />
        <el-table-column prop="views" label="浏览量" width="90" />
        <el-table-column label="操作" width="180" fixed="right">
          <template #default>
            <el-button type="primary" link size="small">编辑</el-button>
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
  { id: 1, title: '2024年全球半导体市场展望', author: '管理员', category: '行业动态', status: '已发布', publishTime: '2024-12-10 09:00:00', views: 1250 },
  { id: 2, title: '新品上市：STM32U5系列超低功耗MCU', author: '管理员', category: '新品资讯', status: '已发布', publishTime: '2024-12-08 14:30:00', views: 890 },
  { id: 3, title: '关于冬季物流配送调整的通知', author: '管理员', category: '商城公告', status: '草稿', publishTime: '-', views: 0 }
])
</script>

<style scoped>
.news {
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