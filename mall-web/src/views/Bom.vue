<template>
  <div class="bom-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>BOM配单</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div class="page-card">
        <div class="bom-header">
          <h3>BOM配单服务</h3>
          <p>上传BOM清单，快速获取报价，一站配齐所有元器件</p>
        </div>
        <div class="bom-body">
          <div class="bom-upload">
            <el-upload drag action="#" :auto-upload="false" :on-change="handleFileChange">
              <el-icon class="upload-icon"><Upload /></el-icon>
              <div class="upload-text">
                <span>将BOM文件拖拽到此处，或 <em>点击上传</em></span>
              </div>
              <template #tip>
                <div class="upload-tip">
                  支持 Excel (.xlsx, .xls)、CSV、TXT 格式，最大 10MB
                </div>
              </template>
            </el-upload>
          </div>
          <div class="bom-or">
            <span>或</span>
          </div>
          <div class="bom-manual">
            <el-button type="danger" @click="showManualInput = true">手动输入BOM</el-button>
          </div>
          <div class="bom-form" v-if="showManualInput">
            <el-form :model="bomForm" label-width="100px">
              <el-form-item label="型号">
                <el-input v-model="bomForm.partNo" placeholder="输入型号，多个用逗号分隔" />
              </el-form-item>
              <el-form-item label="数量">
                <el-input v-model="bomForm.quantity" placeholder="输入对应数量" />
              </el-form-item>
              <el-form-item>
                <el-button type="danger" @click="handleSubmitBom">提交查询</el-button>
                <el-button @click="showManualInput = false">取消</el-button>
              </el-form-item>
            </el-form>
          </div>
          <div class="bom-features">
            <div class="bf-item">
              <el-icon><CircleCheck /></el-icon>
              <span>智能识别型号</span>
            </div>
            <div class="bf-item">
              <el-icon><Lightning /></el-icon>
              <span>快速报价，2小时内响应</span>
            </div>
            <div class="bf-item">
              <el-icon><ShoppingCart /></el-icon>
              <span>一站式配齐，减少采购成本</span>
            </div>
            <div class="bf-item">
              <el-icon><Refund /></el-icon>
              <span>原装正品保证</span>
            </div>
          </div>
        </div>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'

const showManualInput = ref(false)

const bomForm = reactive({
  partNo: '',
  quantity: '',
})

function handleFileChange(file) {
  ElMessage.success(`已上传文件: ${file.name}`)
}

function handleSubmitBom() {
  ElMessage.success('BOM查询已提交，我们将尽快与您联系')
}
</script>

<style scoped>
.bom-page {
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

.bom-header {
  text-align: center;
  margin-bottom: 40px;
}

.bom-header h3 {
  font-size: 26px;
  font-weight: 700;
  color: #333;
  margin-bottom: 10px;
}

.bom-header p {
  font-size: 15px;
  color: #888;
}

.bom-body {
  max-width: 600px;
  margin: 0 auto;
}

.bom-upload {
  margin-bottom: 20px;
}

.upload-icon {
  font-size: 48px;
  color: #ccc;
  margin-bottom: 12px;
}

.upload-text {
  font-size: 14px;
  color: #666;
}

.upload-text em {
  color: var(--theme-color);
  font-style: normal;
  font-weight: 600;
}

.upload-tip {
  font-size: 12px;
  color: #bbb;
  margin-top: 8px;
}

.bom-or {
  text-align: center;
  margin: 20px 0;
  position: relative;
}

.bom-or::before,
.bom-or::after {
  content: '';
  position: absolute;
  top: 50%;
  width: 45%;
  height: 1px;
  background: #eee;
}

.bom-or::before { left: 0; }
.bom-or::after { right: 0; }

.bom-or span {
  background: #fff;
  padding: 0 16px;
  color: #ccc;
  font-size: 13px;
  position: relative;
  z-index: 1;
}

.bom-manual {
  text-align: center;
  margin-bottom: 24px;
}

.bom-form {
  background: #fafafa;
  padding: 24px;
  border-radius: 8px;
  margin-bottom: 24px;
}

.bom-features {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
  margin-top: 30px;
}

.bf-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px;
  background: #fafafa;
  border-radius: 6px;
  font-size: 14px;
  color: #666;
}

.bf-item .el-icon {
  color: var(--theme-color);
  font-size: 20px;
}
</style>