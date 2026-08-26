<template>
  <div class="feedback">
    <div class="page-header">
      <div class="page-title">
        <h2>投诉反馈管理</h2>
        <p>处理用户投诉和反馈意见，维护良好的客户关系。</p>
      </div>
      <el-tag type="danger" size="large" effect="dark">待处理: 5</el-tag>
    </div>
    <el-card shadow="hover">
      <el-table :data="tableData" stripe style="width: 100%">
        <el-table-column prop="id" label="编号" width="80" />
        <el-table-column prop="username" label="用户" width="130" />
        <el-table-column prop="type" label="类型" width="100">
          <template #default="{ row }">
            <el-tag :type="row.type === '投诉' ? 'danger' : 'warning'">{{ row.type }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="title" label="标题" min-width="250" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === '已处理' ? 'success' : 'danger'">{{ row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="提交时间" width="180" />
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <el-button v-if="row.status === '待处理'" type="danger" link size="small">立即处理</el-button>
            <el-button v-else type="primary" link size="small">查看详情</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const tableData = ref([
  { id: 1, username: 'zhangsan', type: '投诉', title: '订单发货延迟，已超过承诺时间', status: '待处理', createTime: '2024-12-15 10:30:00' },
  { id: 2, username: 'lisi', type: '反馈', title: '建议增加数据手册在线阅读功能', status: '已处理', createTime: '2024-12-14 14:20:00' },
  { id: 3, username: 'wangwu', type: '投诉', title: '收到的商品与描述不符', status: '待处理', createTime: '2024-12-13 09:15:00' },
  { id: 4, username: 'zhaoliu', type: '反馈', title: '搜索功能体验优化建议', status: '待处理', createTime: '2024-12-12 16:45:00' }
])
</script>

<style scoped>
.feedback {
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