<template>
  <div class="user-feedback">
    <div class="section-card">
      <h4>投诉建议</h4>
      <p class="feedback-tip">如果您有任何问题或建议，请填写以下表单，我们将尽快处理</p>
      <el-form :model="form" label-width="80px" size="large">
        <el-form-item label="类型">
          <el-select v-model="form.type" style="width: 300px">
            <el-option label="商品问题" value="product" />
            <el-option label="物流问题" value="logistics" />
            <el-option label="售后服务" value="service" />
            <el-option label="网站建议" value="suggestion" />
            <el-option label="其他" value="other" />
          </el-select>
        </el-form-item>
        <el-form-item label="标题">
          <el-input v-model="form.title" placeholder="请输入标题" style="width: 500px" />
        </el-form-item>
        <el-form-item label="内容">
          <el-input v-model="form.content" type="textarea" :rows="5" placeholder="请详细描述您的问题或建议" style="width: 500px" />
        </el-form-item>
        <el-form-item label="联系方式">
          <el-input v-model="form.contact" placeholder="手机号或邮箱，以便我们回复您" style="width: 300px" />
        </el-form-item>
        <el-form-item>
          <el-button type="danger" @click="handleSubmit">提交</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { reactive } from 'vue'
import { ElMessage } from 'element-plus'

const form = reactive({
  type: 'product',
  title: '',
  content: '',
  contact: '',
})

function handleSubmit() {
  ElMessage.success('感谢您的反馈，我们会尽快处理！')
  handleReset()
}

function handleReset() {
  form.type = 'product'
  form.title = ''
  form.content = ''
  form.contact = ''
}
</script>

<style scoped>
.section-card {
  background: #fff;
  border-radius: 8px;
  padding: 30px;
}

.section-card h4 {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin-bottom: 8px;
  padding-bottom: 12px;
  border-bottom: 1px solid #f0f0f0;
}

.feedback-tip {
  font-size: 14px;
  color: #999;
  margin-bottom: 24px;
}
</style>