<template>
  <div class="datasheet">
    <div class="page-header">
      <div class="page-title">
        <h2>数据手册管理</h2>
        <p>管理电子元器件的数据手册（Datasheet），支持上传和下载。</p>
      </div>
      <el-button type="danger">
        <el-icon><Upload /></el-icon>上传手册
      </el-button>
    </div>
    <el-card shadow="hover">
      <el-table :data="tableData" stripe style="width: 100%">
        <el-table-column prop="id" label="编号" width="80" />
        <el-table-column prop="name" label="文档名称" min-width="250" />
        <el-table-column prop="product" label="适用产品" width="200" />
        <el-table-column prop="fileSize" label="文件大小" width="120" />
        <el-table-column prop="uploadTime" label="上传时间" width="180" />
        <el-table-column prop="downloads" label="下载次数" width="100" />
        <el-table-column label="操作" width="150" fixed="right">
          <template #default>
            <el-button type="primary" link size="small">下载</el-button>
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
  { id: 1, name: 'STM32F103C8T6_Datasheet_EN.pdf', product: 'STM32F103C8T6', fileSize: '2.5 MB', uploadTime: '2024-12-01 10:00:00', downloads: 350 },
  { id: 2, name: 'AMS1117_Datasheet_CN.pdf', product: 'AMS1117-3.3', fileSize: '1.2 MB', uploadTime: '2024-12-05 14:30:00', downloads: 180 },
  { id: 3, name: 'ESP32_WROOM_32_Technical_Reference.pdf', product: 'ESP32-WROOM-32', fileSize: '5.8 MB', uploadTime: '2024-12-10 09:15:00', downloads: 220 }
])
</script>

<style scoped>
.datasheet {
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