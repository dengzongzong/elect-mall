<template>
  <div class="partner-page">
    <MainHeader />

    <!-- Banner -->
    <div class="partner-banner">
      <div class="container">
        <div class="banner-text">
          <h1>合作共赢</h1>
          <p>诚邀优秀原厂 / 代理商入驻</p>
          <el-button type="danger" size="large" round @click="scrollToForm">我要合作</el-button>
        </div>
      </div>
    </div>

    <div class="container">
      <!-- 入驻优势 -->
      <div class="section">
        <h2 class="section-title">入驻优势</h2>
        <div class="advantages-grid">
          <div class="advantage-card" v-for="adv in advantages" :key="adv.title">
            <div class="adv-icon">
              <el-icon :size="36"><component :is="adv.icon" /></el-icon>
            </div>
            <h4>{{ adv.title }}</h4>
            <p>{{ adv.desc }}</p>
          </div>
        </div>
      </div>

      <!-- 合作流程 -->
      <div class="section">
        <h2 class="section-title">合作流程</h2>
        <div class="process-steps">
          <div class="step-item" v-for="(step, idx) in processSteps" :key="idx">
            <div class="step-number">{{ idx + 1 }}</div>
            <div class="step-content">
              <h4>{{ step.title }}</h4>
              <p>{{ step.desc }}</p>
            </div>
            <div class="step-arrow" v-if="idx < processSteps.length - 1">
              <el-icon><ArrowRight /></el-icon>
            </div>
          </div>
        </div>
      </div>

      <!-- 联系信息 -->
      <div class="section">
        <h2 class="section-title">联系我们</h2>
        <div class="contact-cards">
          <div class="contact-item" v-for="c in contacts" :key="c.label">
            <el-icon :size="24"><component :is="c.icon" /></el-icon>
            <div>
              <span class="contact-label">{{ c.label }}</span>
              <span class="contact-value">{{ c.value }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- 合作申请表单 -->
      <div class="section" ref="formSection">
        <h2 class="section-title">合作申请</h2>
        <div class="form-card">
          <el-form :model="applyForm" label-width="100px" size="large">
            <el-form-item label="公司名称" required>
              <el-input v-model="applyForm.companyName" placeholder="请输入公司全称" />
            </el-form-item>
            <el-form-item label="主营品类" required>
              <el-input v-model="applyForm.category" placeholder="如：电容电阻、MCU、传感器等" />
            </el-form-item>
            <el-form-item label="联系人" required>
              <el-input v-model="applyForm.contact" placeholder="请输入联系人姓名" />
            </el-form-item>
            <el-form-item label="联系电话" required>
              <el-input v-model="applyForm.phone" placeholder="请输入手机号" />
            </el-form-item>
            <el-form-item label="联系邮箱">
              <el-input v-model="applyForm.email" placeholder="请输入邮箱地址" />
            </el-form-item>
            <el-form-item label="留言">
              <el-input v-model="applyForm.message" type="textarea" :rows="4" placeholder="请描述您的合作意向..." />
            </el-form-item>
            <el-form-item>
              <el-button type="danger" @click="handleSubmit" :loading="submitting">提交申请</el-button>
              <el-button @click="resetForm">重置</el-button>
            </el-form-item>
          </el-form>
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

const formSection = ref(null)
const submitting = ref(false)

const advantages = [
  { icon: 'Checked', title: '原厂授权', desc: '原厂原装产品，正品保障，一对一专属客服跟单' },
  { icon: 'Timer', title: '极速发货', desc: '自营现货，高效智能的仓储管理，极速发货' },
  { icon: 'Grid', title: '品类齐全', desc: '线上线下全面整合资源，品类齐全，一站采购' },
  { icon: 'TrendCharts', title: '营销推广', desc: '专业的运营推广团队，大数据分析及营销服务' },
  { icon: 'Connection', title: '资源整合', desc: '线上线下全面整合资源，拓展销售渠道' },
  { icon: 'DataBoard', title: '数据服务', desc: '大数据分析，精准营销，提升销售转化率' },
]

const processSteps = [
  { title: '提交申请', desc: '填写公司信息、主营品类及联系方式，提交入驻申请' },
  { title: '资质审核', desc: '平台收到申请后，1-3个工作日内完成资质审核' },
  { title: '签订协议', desc: '审核通过后，双方签订合作协议，明确合作条款' },
  { title: '正式入驻', desc: '完成入驻流程，开始上架商品，开展合作' },
]

const contacts = [
  { icon: 'User', label: '联系人', value: '黄先生' },
  { icon: 'Phone', label: '联系电话', value: '13692180318' },
  { icon: 'Message', label: '电子邮箱', value: 'partner@example.com' },
  { icon: 'ChatDotSquare', label: '企业QQ', value: '444849432' },
]

const applyForm = reactive({
  companyName: '',
  category: '',
  contact: '',
  phone: '',
  email: '',
  message: '',
})

function scrollToForm() {
  if (formSection.value) {
    formSection.value.scrollIntoView({ behavior: 'smooth' })
  }
}

function handleSubmit() {
  if (!applyForm.companyName || !applyForm.category || !applyForm.contact || !applyForm.phone) {
    ElMessage.warning('请填写完整信息（公司名称、主营品类、联系人、联系电话为必填）')
    return
  }
  submitting.value = true
  setTimeout(() => {
    submitting.value = false
    ElMessage.success('合作申请已提交，我们将在1-3个工作日内与您联系')
    resetForm()
  }, 1000)
}

function resetForm() {
  applyForm.companyName = ''
  applyForm.category = ''
  applyForm.contact = ''
  applyForm.phone = ''
  applyForm.email = ''
  applyForm.message = ''
}
</script>

<style scoped>
.partner-page {
  background: #f5f5f5;
  min-height: 100vh;
}

.container {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 20px;
}

/* Banner */
.partner-banner {
  background: linear-gradient(135deg, #E60012 0%, #ff4d4f 100%);
  padding: 60px 0;
  text-align: center;
  color: #fff;
}

.banner-text h1 {
  font-size: 42px;
  font-weight: 700;
  margin-bottom: 12px;
  letter-spacing: 4px;
}

.banner-text p {
  font-size: 18px;
  opacity: 0.9;
  margin-bottom: 28px;
}

/* Section */
.section {
  background: #fff;
  border-radius: 8px;
  padding: 40px;
  margin-top: 20px;
  margin-bottom: 20px;
}

.section-title {
  font-size: 24px;
  font-weight: 700;
  color: #333;
  text-align: center;
  margin-bottom: 32px;
  position: relative;
  padding-bottom: 16px;
}

.section-title::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 60px;
  height: 3px;
  background: var(--theme-color, #E60012);
  border-radius: 2px;
}

/* Advantages */
.advantages-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 24px;
}

.advantage-card {
  text-align: center;
  padding: 32px 20px;
  border: 1px solid #eee;
  border-radius: 8px;
  transition: all 0.3s;
}

.advantage-card:hover {
  border-color: var(--theme-color, #E60012);
  box-shadow: 0 4px 16px rgba(230, 0, 18, 0.1);
  transform: translateY(-2px);
}

.adv-icon {
  width: 64px;
  height: 64px;
  line-height: 64px;
  margin: 0 auto 16px;
  background: #fff0f0;
  color: var(--theme-color, #E60012);
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.advantage-card h4 {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin-bottom: 8px;
}

.advantage-card p {
  font-size: 13px;
  color: #888;
  line-height: 1.6;
}

/* Process */
.process-steps {
  display: flex;
  align-items: flex-start;
  gap: 0;
  justify-content: space-between;
}

.step-item {
  display: flex;
  align-items: flex-start;
  gap: 16px;
  flex: 1;
  position: relative;
}

.step-number {
  width: 44px;
  height: 44px;
  line-height: 44px;
  text-align: center;
  background: var(--theme-color, #E60012);
  color: #fff;
  font-size: 18px;
  font-weight: 700;
  border-radius: 50%;
  flex-shrink: 0;
}

.step-content {
  flex: 1;
  text-align: left;
}

.step-content h4 {
  font-size: 15px;
  font-weight: 600;
  color: #333;
  margin-bottom: 4px;
}

.step-content p {
  font-size: 13px;
  color: #888;
  line-height: 1.5;
}

.step-arrow {
  display: flex;
  align-items: center;
  justify-content: center;
  color: #ddd;
  font-size: 20px;
  padding: 0 12px;
  margin-top: 10px;
}

/* Contact */
.contact-cards {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.contact-item {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 20px;
  background: #fafafa;
  border-radius: 8px;
  color: var(--theme-color, #E60012);
}

.contact-item div {
  display: flex;
  flex-direction: column;
  text-align: left;
}

.contact-label {
  font-size: 12px;
  color: #999;
}

.contact-value {
  font-size: 15px;
  font-weight: 600;
  color: #333;
}

/* Form */
.form-card {
  max-width: 700px;
  margin: 0 auto;
  padding: 30px;
  background: #fafafa;
  border-radius: 8px;
}

@media (max-width: 768px) {
  .advantages-grid {
    grid-template-columns: 1fr 1fr;
  }
  .process-steps {
    flex-direction: column;
    gap: 20px;
  }
  .step-arrow {
    transform: rotate(90deg);
  }
  .contact-cards {
    grid-template-columns: 1fr 1fr;
  }
}
</style>