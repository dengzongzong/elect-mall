<template>
  <div class="dashboard">
    <div class="page-header">
      <h2>工作台</h2>
      <p>欢迎回来，{{ userInfo?.username || '管理员' }}！以下是系统概览数据。</p>
    </div>
    <el-row :gutter="20" class="stats-row">
      <el-col :span="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon" style="background-color: #E60012;">
              <el-icon :size="28"><ShoppingCart /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">1,286</div>
              <div class="stat-label">今日订单</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon" style="background-color: #1890ff;">
              <el-icon :size="28"><Coin /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">¥ 3,568,200</div>
              <div class="stat-label">今日销售额</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon" style="background-color: #52c41a;">
              <el-icon :size="28"><User /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">342</div>
              <div class="stat-label">新注册用户</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon" style="background-color: #faad14;">
              <el-icon :size="28"><Goods /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">15,680</div>
              <div class="stat-label">商品总数</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
    <el-row :gutter="20" class="content-row">
      <el-col :span="16">
        <el-card shadow="hover" class="chart-card">
          <template #header>
            <span>销售趋势（近7日）</span>
          </template>
          <div class="placeholder-chart">
            <el-empty description="销售趋势图表区域" />
          </div>
        </el-card>
      </el-col>
      <el-col :span="8">
        <el-card shadow="hover" class="todo-card">
          <template #header>
            <span>待办事项</span>
          </template>
          <div class="todo-list">
            <div class="todo-item">
              <el-tag size="small" type="danger">待处理</el-tag>
              <span>新订单等待确认 (12)</span>
            </div>
            <div class="todo-item">
              <el-tag size="small" type="warning">待审核</el-tag>
              <span>用户投诉反馈 (5)</span>
            </div>
            <div class="todo-item">
              <el-tag size="small" type="info">待处理</el-tag>
              <span>询价单待回复 (8)</span>
            </div>
            <div class="todo-item">
              <el-tag size="small" type="success">待处理</el-tag>
              <span>供应商合作申请 (3)</span>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useAppStore } from '../stores/app'

const appStore = useAppStore()
const userInfo = computed(() => appStore.userInfo)
</script>

<style scoped>
.dashboard {
  max-width: 1400px;
}

.page-header {
  margin-bottom: 24px;
}

.page-header h2 {
  font-size: 22px;
  color: #303133;
  margin-bottom: 8px;
}

.page-header p {
  font-size: 14px;
  color: #909399;
}

.stats-row {
  margin-bottom: 24px;
}

.stat-card {
  border-radius: 8px;
  cursor: pointer;
}

.stat-content {
  display: flex;
  align-items: center;
  gap: 16px;
}

.stat-icon {
  width: 56px;
  height: 56px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  flex-shrink: 0;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
  color: #303133;
  margin-bottom: 4px;
}

.stat-label {
  font-size: 14px;
  color: #909399;
}

.content-row {
  margin-bottom: 24px;
}

.chart-card,
.todo-card {
  border-radius: 8px;
}

.placeholder-chart {
  height: 280px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.todo-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.todo-item {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 14px;
  color: #606266;
}
</style>