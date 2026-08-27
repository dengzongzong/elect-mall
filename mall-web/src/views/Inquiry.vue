<template>
  <div class="inquiry-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>商品询价</el-breadcrumb-item>
        </el-breadcrumb>
      </div>

      <div class="page-card">
        <h3>商品询价</h3>
        <p class="page-tip">填写询价商品清单及联系方式，我们会在1个工作日内为您报价</p>

        <!-- 询价商品清单 -->
        <div class="inquiry-section">
          <h4 class="section-title">询价商品清单</h4>

          <!-- 表头 -->
          <div class="table-header">
            <span class="col-part-no">料号 <span class="required">*</span></span>
            <span class="col-brand">品牌</span>
            <span class="col-qty">数量 <span class="required">*</span></span>
            <span class="col-price">目标价</span>
            <span class="col-action">操作</span>
          </div>

          <!-- 商品行 -->
          <div class="table-body">
            <div class="table-row" v-for="(item, idx) in inquiryItems" :key="idx">
              <span class="col-part-no">
                <el-input v-model="item.partNo" placeholder="输入料号" size="default" />
              </span>
              <span class="col-brand">
                <el-input v-model="item.brand" placeholder="品牌" size="default" />
              </span>
              <span class="col-qty">
                <el-input-number v-model="item.quantity" :min="1" :max="999999" size="default" controls-position="right" />
              </span>
              <span class="col-price">
                <el-input v-model="item.targetPrice" placeholder="选填" size="default">
                  <template #prefix>¥</template>
                </el-input>
              </span>
              <span class="col-action">
                <el-button type="danger" link @click="removeRow(idx)" v-if="inquiryItems.length > 1">
                  <el-icon><Delete /></el-icon>
                </el-button>
              </span>
            </div>
          </div>

          <el-button type="primary" plain size="default" @click="addRow" class="add-row-btn">
            <el-icon><Plus /></el-icon> 添加行
          </el-button>
        </div>

        <!-- 联系方式 -->
        <div class="inquiry-section">
          <h4 class="section-title">联系方式</h4>
          <el-form :model="contactForm" label-width="100px" size="large">
            <el-form-item label="联系人" required>
              <el-input v-model="contactForm.contact" placeholder="请输入联系人姓名" />
            </el-form-item>
            <el-form-item label="联系电话" required>
              <el-input v-model="contactForm.phone" placeholder="请输入手机号" />
            </el-form-item>
            <el-form-item label="备注">
              <el-input v-model="contactForm.remark" type="textarea" :rows="3" placeholder="其他要求或备注（可选）" />
            </el-form-item>
          </el-form>
        </div>

        <!-- 提交按钮 -->
        <div class="submit-bar">
          <div class="submit-info">
            <el-icon><InfoFilled /></el-icon>
            <span>提交询价后，客服人员将在1个工作日内通过电话或邮件联系您</span>
          </div>
          <el-button type="danger" size="large" @click="handleSubmit" :loading="submitting">
            提交询价
          </el-button>
        </div>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'
import { useUserStore } from '../stores/user'

const router = useRouter()
const userStore = useUserStore()
const submitting = ref(false)

const inquiryItems = reactive([
  { partNo: '', brand: '', quantity: 1, targetPrice: '' },
])

const contactForm = reactive({
  contact: '',
  phone: '',
  remark: '',
})

function addRow() {
  inquiryItems.push({ partNo: '', brand: '', quantity: 1, targetPrice: '' })
}

function removeRow(idx) {
  if (inquiryItems.length > 1) {
    inquiryItems.splice(idx, 1)
  }
}

function handleSubmit() {
  // 检查登录
  if (!userStore.isLoggedIn) {
    ElMessage.warning('请先登录后再提交询价')
    router.push('/login')
    return
  }

  // 验证必填项
  const hasEmptyPartNo = inquiryItems.some(item => !item.partNo.trim())
  if (hasEmptyPartNo) {
    ElMessage.warning('请填写完整的料号信息')
    return
  }

  if (!contactForm.contact.trim()) {
    ElMessage.warning('请输入联系人姓名')
    return
  }

  if (!contactForm.phone.trim()) {
    ElMessage.warning('请输入联系电话')
    return
  }

  // 提交询价
  submitting.value = true
  setTimeout(() => {
    submitting.value = false
    ElMessage.success('询价已提交，客服人员将在1个工作日内与您联系')
    // 重置表单
    inquiryItems.splice(0, inquiryItems.length, { partNo: '', brand: '', quantity: 1, targetPrice: '' })
    contactForm.contact = ''
    contactForm.phone = ''
    contactForm.remark = ''
  }, 1000)
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
}

.page-card h3 {
  font-size: 24px;
  font-weight: 700;
  color: #333;
  margin-bottom: 8px;
}

.page-tip {
  font-size: 14px;
  color: #999;
  margin-bottom: 32px;
}

/* Section */
.inquiry-section {
  margin-bottom: 32px;
  padding-bottom: 32px;
  border-bottom: 1px solid #f0f0f0;
}

.inquiry-section:last-of-type {
  border-bottom: none;
  margin-bottom: 0;
  padding-bottom: 0;
}

.section-title {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin-bottom: 16px;
  padding-left: 12px;
  border-left: 3px solid var(--theme-color, #E60012);
}

.required {
  color: #E60012;
}

/* Table header */
.table-header {
  display: flex;
  align-items: center;
  padding: 12px 16px;
  background: #fafafa;
  border-radius: 4px;
  font-size: 13px;
  color: #666;
  font-weight: 600;
  margin-bottom: 8px;
}

.col-part-no { flex: 3; }
.col-brand { flex: 2; }
.col-qty { flex: 1.5; }
.col-price { flex: 1.5; }
.col-action { width: 50px; text-align: center; }

/* Table rows */
.table-body {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.table-row {
  display: flex;
  align-items: center;
  padding: 8px 16px;
  background: #fff;
  border: 1px solid #f0f0f0;
  border-radius: 4px;
  transition: border-color 0.2s;
}

.table-row:hover {
  border-color: #ddd;
}

.table-row .col-part-no,
.table-row .col-brand,
.table-row .col-qty,
.table-row .col-price {
  padding-right: 12px;
}

.add-row-btn {
  margin-top: 12px;
}

/* Submit bar */
.submit-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20px 24px;
  background: #fafafa;
  border-radius: 8px;
  margin-top: 24px;
}

.submit-info {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  color: #888;
}

.submit-info .el-icon {
  color: var(--theme-color, #E60012);
  font-size: 18px;
}

@media (max-width: 768px) {
  .page-card {
    padding: 20px;
  }

  .table-header,
  .table-row {
    flex-wrap: wrap;
    gap: 8px;
  }

  .col-part-no { flex: 1 1 100%; }
  .col-brand { flex: 1; }
  .col-qty { flex: 1; }
  .col-price { flex: 1; }
}
</style>