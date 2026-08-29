<template>
  <footer class="main-footer">
    <!-- 三栏链接区 -->
    <div class="footer-links">
      <div class="container">
        <div class="links-row">
          <!-- 信息 -->
          <div class="links-col">
            <h4 class="col-title">信息</h4>
            <ul>
              <li><a href="#">关于我们</a></li>
              <li><a href="#">商城</a></li>
              <li><a href="#">在商城上售卖</a></li>
              <li><a href="#">代发货</a></li>
              <li><a href="#">加入我们</a></li>
              <li><a href="#">站点地图</a></li>
              <li><a href="#">数字化解决方案</a></li>
              <li><a href="#">新闻编辑室</a></li>
            </ul>
          </div>

          <!-- 联系与支持 -->
          <div class="links-col">
            <h4 class="col-title">联系与支持</h4>
            <ul>
              <li><a href="#">联系我们</a></li>
              <li><a href="#">帮助和支持</a></li>
              <li><a href="#">订单状态</a></li>
              <li><a href="#">退货和订单问题</a></li>
              <li><a href="#">运费</a></li>
            </ul>
          </div>

          <!-- 关注我们 -->
          <div class="links-col subscribe-col">
            <h4 class="col-title">关注我们</h4>
            <p class="subscribe-tip">订阅获取最新技术资讯</p>

            <div class="subscribe-form">
              <el-input
                v-model="email"
                placeholder="输入您的电子邮件"
                class="subscribe-input"
                clearable
              />
              <el-button class="subscribe-btn" type="primary" @click="handleSubscribe">
                订阅
              </el-button>
            </div>

            <div class="agree-row">
              <el-checkbox v-model="agreed" size="small" />
              <span class="agree-text">
                我同意接收来自时运商城的营销电子邮件（可选）。请查看我们的<a href="#">隐私声明</a>。
              </span>
            </div>

            <div class="social-row">
              <a href="#" class="social-icon" aria-label="YouTube">
                <svg viewBox="0 0 24 24"><path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z"/></svg>
              </a>
              <a href="#" class="social-icon" aria-label="微信">
                <svg viewBox="0 0 24 24"><path d="M8.691 2.188C3.891 2.188 0 5.476 0 9.53c0 2.212 1.17 4.203 3.002 5.55a.59.59 0 0 1 .213.665l-.39 1.48c-.019.07-.048.141-.048.213 0 .163.13.295.29.295a.326.326 0 0 0 .167-.054l1.903-1.114a.864.864 0 0 1 .717-.098 10.16 10.16 0 0 0 2.837.403c.276 0 .543-.027.811-.05-.857-2.578.157-4.972 1.932-6.446 1.703-1.415 3.882-1.98 5.853-1.838-.576-3.583-4.196-6.348-8.596-6.348zM5.785 5.991c.642 0 1.162.529 1.162 1.18a1.17 1.17 0 0 1-1.162 1.178A1.17 1.17 0 0 1 4.623 7.17c0-.651.52-1.18 1.162-1.18zm5.813 0c.642 0 1.162.529 1.162 1.18a1.17 1.17 0 0 1-1.162 1.178 1.17 1.17 0 0 1-1.162-1.178c0-.651.52-1.18 1.162-1.18zm5.34 2.867c-1.797-.052-3.746.512-5.28 1.786-1.72 1.428-2.687 3.72-1.89 6.114.846 2.447 3.246 3.598 5.549 3.453.935-.05 1.891-.224 2.847-.583a.722.722 0 0 1 .598.082l1.584.926a.272.272 0 0 0 .14.045c.134 0 .24-.111.24-.247 0-.06-.023-.12-.038-.177l-.327-1.233a.582.582 0 0 1-.023-.156.49.49 0 0 1 .201-.398C23.024 18.48 24 16.82 24 14.98c0-3.21-2.931-5.837-6.656-6.088V8.89c-.135-.01-.27-.027-.407-.03zm-2.53 3.274c.535 0 .969.44.969.982a.976.976 0 0 1-.969.983.976.976 0 0 1-.969-.983c0-.542.434-.982.97-.982zm4.844 0c.535 0 .969.44.969.982a.976.976 0 0 1-.969.983.976.976 0 0 1-.969-.983c0-.542.434-.982.97-.982z"/></svg>
              </a>
              <a href="#" class="social-icon" aria-label="抖音">
                <svg viewBox="0 0 24 24"><path d="M19.59 6.69a4.83 4.83 0 0 1-3.77-4.25V2h-3.45v13.67a2.89 2.89 0 0 1-5.2 1.74 2.89 2.89 0 0 1 2.31-4.64 2.93 2.93 0 0 1 .88.13V9.4a6.84 6.84 0 0 0-.88-.07A6.33 6.33 0 0 0 5 20.1a6.34 6.34 0 0 0 10.86-4.43v-7a8.16 8.16 0 0 0 4.77 1.52v-3.4a4.85 4.85 0 0 1-1-.1z"/></svg>
              </a>
            </div>

            <a href="#" class="app-store-btn">
              <svg class="apple-logo" viewBox="0 0 24 24"><path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z"/></svg>
              <span class="app-store-text">
                <span>App Store</span>
                <strong>下载</strong>
              </span>
            </a>
          </div>
        </div>
      </div>
    </div>

    <!-- 会员/协会标志 -->
    <div class="footer-badges">
      <div class="container">
        <div class="badges-row">
          <div class="badge-item">
            <div class="badge-title">ECIA MEMBER</div>
            <div class="badge-sub">Supporting the Authorized Channel</div>
          </div>
          <div class="badge-item">
            <div class="badge-title">ERA</div>
            <div class="badge-sub">Electronics Representatives Association</div>
          </div>
        </div>
      </div>
    </div>

    <!-- 底部版权 -->
    <div class="footer-bottom">
      <div class="container">
        <div class="bottom-links">
          <a href="#">条款和条件</a>
          <a href="#">隐私声明</a>
          <a href="#">贸易合规</a>
          <a href="#">Cookie 设置</a>
        </div>
        <div class="bottom-info">
          <span>&copy; 2026 时运商城 保留所有权利。</span>
          <span class="support-address">本地支援：请配置公司地址</span>
        </div>
      </div>
    </div>
  </footer>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'

const email = ref('')
const agreed = ref(false)

function handleSubscribe() {
  if (!email.value || !email.value.trim()) {
    ElMessage.warning('请输入您的电子邮件')
    return
  }
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  if (!emailRegex.test(email.value.trim())) {
    ElMessage.warning('请输入有效的电子邮件地址')
    return
  }
  if (!agreed.value) {
    ElMessage.warning('请同意隐私声明后再订阅')
    return
  }
  ElMessage.success(`订阅成功：${email.value.trim()}`)
  email.value = ''
  agreed.value = false
}
</script>

<style scoped>
.main-footer {
  background: #fff;
  border-top: 1px solid #eee;
}

.container {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 20px;
}

/* 三栏链接区 */
.footer-links {
  padding: 50px 0 40px;
}

.links-row {
  display: flex;
  gap: 80px;
}

.links-col {
  flex: 1;
}

.subscribe-col {
  flex: 1.2;
}

.col-title {
  font-size: 14px;
  font-weight: 600;
  color: #333;
  margin-bottom: 18px;
}

.links-col ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.links-col li {
  margin-bottom: 10px;
}

.links-col a {
  font-size: 13px;
  color: #666;
  text-decoration: none;
  transition: color 0.2s;
}

.links-col a:hover {
  color: var(--theme-color);
}

/* 订阅区 */
.subscribe-tip {
  font-size: 13px;
  color: #666;
  margin: -4px 0 10px;
}

.subscribe-form {
  display: flex;
  margin-bottom: 10px;
}

.subscribe-input :deep(.el-input__wrapper) {
  border-radius: 0;
  border: 1px solid #ccc;
  border-right: none;
  box-shadow: none;
  height: 38px;
}

.subscribe-input :deep(.el-input__wrapper):hover,
.subscribe-input :deep(.el-input__wrapper).is-focus {
  box-shadow: none;
  border-color: #ccc;
}

.subscribe-btn {
  border-radius: 0;
  height: 38px;
  padding: 0 24px;
  background: var(--theme-color);
  border-color: var(--theme-color);
  font-size: 14px;
}

.subscribe-btn:hover {
  background: var(--theme-color-hover);
  border-color: var(--theme-color-hover);
}

.agree-row {
  display: flex;
  align-items: flex-start;
  gap: 6px;
  margin-bottom: 18px;
}

.agree-text {
  font-size: 11px;
  color: #999;
  line-height: 1.5;
}

.agree-text a {
  color: var(--theme-color);
  text-decoration: none;
}

/* 社交图标 */
.social-row {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 16px;
}

.social-icon {
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #333;
  border-radius: 6px;
  transition: background 0.2s;
}

.social-icon:hover {
  background: var(--theme-color);
}

.social-icon svg {
  width: 18px;
  height: 18px;
  fill: #fff;
}

/* App Store 按钮 */
.app-store-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  background: #000;
  color: #fff;
  padding: 8px 16px;
  border-radius: 6px;
  text-decoration: none;
  transition: background 0.2s;
}

.app-store-btn:hover {
  background: #333;
}

.apple-logo {
  width: 22px;
  height: 22px;
  fill: #fff;
}

.app-store-text {
  display: flex;
  flex-direction: column;
  line-height: 1.1;
}

.app-store-text span {
  font-size: 10px;
  color: #ddd;
}

.app-store-text strong {
  font-size: 14px;
  font-weight: 600;
}

/* 会员标志 */
.footer-badges {
  border-top: 1px solid #eee;
  border-bottom: 1px solid #eee;
  padding: 24px 0;
}

.badges-row {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 40px;
}

.badge-item {
  text-align: center;
  color: #333;
}

.badge-title {
  font-size: 16px;
  font-weight: 700;
  letter-spacing: 1px;
  line-height: 1.2;
}

.badge-sub {
  font-size: 11px;
  color: #666;
  margin-top: 2px;
}

/* 底部版权 */
.footer-bottom {
  padding: 18px 0 30px;
  text-align: center;
}

.bottom-links {
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  gap: 10px 20px;
  margin-bottom: 10px;
}

.bottom-links a {
  font-size: 12px;
  color: #666;
  text-decoration: none;
  transition: color 0.2s;
}

.bottom-links a:hover {
  color: var(--theme-color);
}

.bottom-info {
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  gap: 8px 20px;
  font-size: 11px;
  color: #999;
}

.support-address {
  color: #999;
}

/* 响应式 */
@media (max-width: 768px) {
  .links-row {
    flex-direction: column;
    gap: 40px;
  }

  .subscribe-form {
    flex-direction: column;
  }

  .subscribe-input :deep(.el-input__wrapper) {
    border-right: 1px solid #ccc;
    border-bottom: none;
  }

  .badges-row {
    flex-direction: column;
    gap: 20px;
  }
}
</style>
