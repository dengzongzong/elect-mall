<template>
  <div class="inquiry-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>我要询价</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div class="page-card">
        <h3>我要询价</h3>
        <p class="page-tip">填写以下信息，我们会尽快为您报价</p>
        <el-form :model="inquiryForm" label-width="100px" size="large">
          <el-form-item label="型号">
            <el-input v-model="inquiryForm.partNo" placeholder="请输入产品型号" />
          </el-form-item>
          <el-form-item label="品牌">
            <el-input v-model="inquiryForm.brand" placeholder="请输入品牌（可选）" />
          </el-form-item>
          <el-form-item label="数量">
            <el-input-number v-model="inquiryForm.quantity" :min="1" />
          </el-form-item>
          <el-form-item label="封装">
            <el-input v-model="inquiryForm.package" placeholder="请输入封装（可选）" />
          </el-form-item>
          <el-form-item label="备注">
            <el-input v-model="inquiryForm.remark" type="textarea" :rows="3" placeholder="其他要求（可选）" />
          </el-form-item>
          <el-form-item label="联系方式">
            <el-input v-model="inquiryForm.contact" placeholder="请输入手机号或邮箱" />
          </el-form-item>
          <el-form-item>
            <el-button type="danger" @click="handleSubmit">提交询价</el-button>
            <el-button>重置</el-button>
          </el-form-item>
        </el-form>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { reactive } from 'vue'
import { ElMessage } from 'element-plus'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'

const inquiryForm = reactive({
  partNo: '',
  brand: '',
  quantity: 1,
  package: '',
  remark: '',
  contact: '',
})

function handleSubmit() {
  ElMessage.success('询价已提交，客服人员将尽快与您联系')
}
</script>

<style scoped>
.inquiry-page {
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
  max-width: 700px;
}

.page-card h3 {
  font-size: 22px;
  font-weight: 700;
  color: #333;
  margin-bottom: 8px;
}

.page-tip {
  color: #999;
  font-size: 14px;
  margin-bottom: 30px;
}
</style>