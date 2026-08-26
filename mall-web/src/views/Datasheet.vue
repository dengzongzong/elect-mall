<template>
  <div class="datasheet-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>数据手册</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div class="page-card">
        <h3>数据手册下载</h3>
        <p class="page-tip">搜索并下载元器件数据手册 (PDF)</p>
        <div class="search-box">
          <el-input v-model="keyword" placeholder="输入型号搜索数据手册..." size="large" class="ds-search-input" @keyup.enter="handleSearch">
            <template #prefix><el-icon><Search /></el-icon></template>
            <template #append>
              <el-button type="danger" @click="handleSearch">搜索</el-button>
            </template>
          </el-input>
        </div>
        <div class="ds-list">
          <div class="ds-item" v-for="d in datasheets" :key="d.id">
            <div class="ds-info">
              <h4>{{ d.model }}</h4>
              <p>{{ d.manufacturer }} | {{ d.type }}</p>
            </div>
            <el-button type="primary" plain size="small">
              <el-icon><Download /></el-icon> 下载PDF
            </el-button>
          </div>
        </div>
        <div class="pagination-wrap">
          <el-pagination background layout="prev, pager, next" :total="50" />
        </div>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { ref } from 'vue'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'

const keyword = ref('')

const datasheets = ref([
  { id: 1, model: 'STM32F103C8T6', manufacturer: 'ST', type: 'MCU数据手册' },
  { id: 2, model: 'ESP32-WROOM-32', manufacturer: 'Espressif', type: '模块数据手册' },
  { id: 3, model: 'LM2596S-ADJ', manufacturer: 'TI', type: '电源管理' },
  { id: 4, model: 'AMS1117-3.3', manufacturer: 'AMS', type: 'LDO稳压器' },
  { id: 5, model: 'DS18B20', manufacturer: 'Maxim', type: '温度传感器' },
  { id: 6, model: 'W25Q64JVSSIQ', manufacturer: 'Winbond', type: '存储器' },
  { id: 7, model: 'AT24C02C-SSHM-T', manufacturer: 'Microchip', type: 'EEPROM' },
  { id: 8, model: 'IRF520NPBF', manufacturer: 'Infineon', type: 'MOSFET' },
])

function handleSearch() {
  // 搜索逻辑
}
</script>

<style scoped>
.datasheet-page {
  background: #f5f5f5;
  min-height: 100vh;
}

.container {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 20px;
}

.breadcrumb {
  padding: 16px 0;
}

.page-card {
  background: #fff;
  border-radius: 8px;
  padding: 40px;
  margin-bottom: 40px;
}

.page-card h3 {
  font-size: 22px;
  font-weight: 700;
  color: #333;
  margin-bottom: 8px;
}

.page-tip {
  font-size: 14px;
  color: #999;
  margin-bottom: 24px;
}

.search-box {
  margin-bottom: 30px;
}

.ds-search-input :deep(.el-input-group__append) {
  background: var(--theme-color);
  border-color: var(--theme-color);
}

.ds-search-input :deep(.el-input-group__append .el-button) {
  color: #fff;
}

.ds-list {
  display: flex;
  flex-direction: column;
}

.ds-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 0;
  border-bottom: 1px solid #f5f5f5;
  transition: background 0.2s;
}

.ds-item:hover {
  background: #fafafa;
  padding-left: 10px;
  padding-right: 10px;
  border-radius: 4px;
}

.ds-info h4 {
  font-size: 15px;
  font-weight: 600;
  color: #333;
  margin-bottom: 4px;
}

.ds-info p {
  font-size: 13px;
  color: #999;
}

.pagination-wrap {
  display: flex;
  justify-content: center;
  margin-top: 24px;
}
</style>