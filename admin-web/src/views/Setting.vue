<template>
  <div class="setting">
    <div class="page-header">
      <h2>系统设置</h2>
      <p>管理系统配置，包括短信通知、支付方式、安全设置等。</p>
    </div>
    <el-row :gutter="20">
      <el-col :span="16">
        <el-card shadow="hover" class="setting-card">
          <template #header>
            <span>短信通知配置</span>
          </template>
          <el-form :model="smsConfig" label-width="140px" class="setting-form">
            <el-form-item label="短信服务商">
              <el-select v-model="smsConfig.provider" placeholder="请选择短信服务商">
                <el-option label="阿里云短信" value="aliyun" />
                <el-option label="腾讯云短信" value="tencent" />
                <el-option label="七牛云短信" value="qiniu" />
              </el-select>
            </el-form-item>
            <el-form-item label="AccessKey">
              <el-input v-model="smsConfig.accessKey" placeholder="请输入AccessKey" />
            </el-form-item>
            <el-form-item label="SecretKey">
              <el-input v-model="smsConfig.secretKey" type="password" placeholder="请输入SecretKey" show-password />
            </el-form-item>
            <el-form-item label="短信签名">
              <el-input v-model="smsConfig.signName" placeholder="例如：电子元器件商城" />
            </el-form-item>
            <el-form-item label="订单通知模板">
              <el-input v-model="smsConfig.orderTemplate" placeholder="请输入短信模板ID" />
            </el-form-item>
            <el-form-item label="验证码模板">
              <el-input v-model="smsConfig.codeTemplate" placeholder="请输入短信模板ID" />
            </el-form-item>
            <el-form-item>
              <el-button type="danger" @click="handleSave">保存配置</el-button>
              <el-button @click="handleTest">发送测试</el-button>
            </el-form-item>
          </el-form>
        </el-card>
        <el-card shadow="hover" class="setting-card">
          <template #header>
            <span>支付方式配置</span>
          </template>
          <el-form :model="paymentConfig" label-width="140px" class="setting-form">
            <el-form-item label="支付宝">
              <el-switch v-model="paymentConfig.alipay" />
            </el-form-item>
            <el-form-item label="微信支付">
              <el-switch v-model="paymentConfig.wechat" />
            </el-form-item>
            <el-form-item label="银行转账">
              <el-switch v-model="paymentConfig.bankTransfer" />
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>
      <el-col :span="8">
        <el-card shadow="hover" class="setting-card">
          <template #header>
            <span>系统信息</span>
          </template>
          <div class="sys-info">
            <div class="sys-info-item">
              <span class="label">系统版本</span>
              <span class="value">v1.0.0</span>
            </div>
            <div class="sys-info-item">
              <span class="label">服务器时间</span>
              <span class="value">2024-12-15 14:30:00</span>
            </div>
            <div class="sys-info-item">
              <span class="label">运行时长</span>
              <span class="value">15天 6小时</span>
            </div>
            <div class="sys-info-item">
              <span class="label">在线用户</span>
              <span class="value">23</span>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { reactive } from 'vue'
import { ElMessage } from 'element-plus'

const smsConfig = reactive({
  provider: 'aliyun',
  accessKey: '',
  secretKey: '',
  signName: '电子元器件商城',
  orderTemplate: '',
  codeTemplate: ''
})

const paymentConfig = reactive({
  alipay: true,
  wechat: true,
  bankTransfer: false
})

function handleSave() {
  ElMessage.success('配置保存成功')
}

function handleTest() {
  ElMessage.info('测试短信已发送')
}
</script>

<style scoped>
.setting {
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

.setting-card {
  margin-bottom: 20px;
  border-radius: 8px;
}

.setting-form {
  max-width: 600px;
}

.sys-info {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.sys-info-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 14px;
}

.sys-info-item .label {
  color: #909399;
}

.sys-info-item .value {
  color: #303133;
  font-weight: 500;
}
</style>