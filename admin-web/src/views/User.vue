<template>
  <div class="user">
    <div class="page-header">
      <div class="page-title">
        <h2>用户管理</h2>
        <p>管理商城注册用户信息，包括用户审核、权限管理等。</p>
      </div>
      <el-button type="danger">
        <el-icon><Plus /></el-icon>新增用户
      </el-button>
    </div>
    <el-card shadow="hover">
      <el-table :data="tableData" stripe style="width: 100%">
        <el-table-column prop="id" label="用户ID" width="100" />
        <el-table-column prop="username" label="用户名" width="150" />
        <el-table-column prop="email" label="邮箱" min-width="200" />
        <el-table-column prop="phone" label="手机号" width="140" />
        <el-table-column prop="userType" label="用户类型" width="120">
          <template #default="{ row }">
            <el-tag :type="row.userType === '企业用户' ? 'primary' : 'success'">{{ row.userType }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === '激活' ? 'success' : 'info'">{{ row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="regTime" label="注册时间" width="180" />
        <el-table-column label="操作" width="180" fixed="right">
          <template #default>
            <el-button type="primary" link size="small">编辑</el-button>
            <el-button type="warning" link size="small">禁用</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const tableData = ref([
  { id: 1001, username: 'zhangsan', email: 'zhangsan@example.com', phone: '138****1234', userType: '企业用户', status: '激活', regTime: '2024-06-15 10:30:00' },
  { id: 1002, username: 'lisi', email: 'lisi@example.com', phone: '139****5678', userType: '个人用户', status: '激活', regTime: '2024-07-20 14:20:00' },
  { id: 1003, username: 'wangwu', email: 'wangwu@example.com', phone: '136****9012', userType: '企业用户', status: '禁用', regTime: '2024-08-10 09:15:00' },
  { id: 1004, username: 'zhaoliu', email: 'zhaoliu@example.com', phone: '137****3456', userType: '个人用户', status: '激活', regTime: '2024-09-05 16:45:00' }
])
</script>

<style scoped>
.user {
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