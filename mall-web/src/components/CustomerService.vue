<template>
  <div class="customer-service" :class="{ expanded: isExpanded }">
    <!-- 折叠状态 - 小按钮 -->
    <div v-if="!isExpanded" class="cs-collapsed" @click="isExpanded = true">
      <el-icon class="cs-icon"><Headset /></el-icon>
      <span class="cs-label">客服</span>
    </div>

    <!-- 展开状态 -->
    <div v-else class="cs-expanded">
      <div class="cs-header">
        <span>在线客服</span>
        <el-icon class="cs-close" @click="isExpanded = false"><Close /></el-icon>
      </div>
      <div class="cs-body">
        <div class="cs-item">
          <el-icon class="cs-item-icon"><Message /></el-icon>
          <div class="cs-item-content">
            <span class="cs-item-title">企业QQ咨询</span>
            <a href="https://wpa.qq.com/msgrd?v=3&uin=4008889999&site=qq&menu=yes" target="_blank" class="cs-link">点击咨询</a>
          </div>
        </div>
        <div class="cs-item">
          <el-icon class="cs-item-icon"><ChatLineSquare /></el-icon>
          <div class="cs-item-content">
            <span class="cs-item-title">微信客服</span>
            <div class="wechat-qr-placeholder">
              <el-icon class="qr-icon"><ChatLineSquare /></el-icon>
              <span>扫码联系客服</span>
            </div>
          </div>
        </div>
        <div class="cs-item">
          <el-icon class="cs-item-icon"><Phone /></el-icon>
          <div class="cs-item-content">
            <span class="cs-item-title">客服热线</span>
            <span class="cs-phone">400-888-9999</span>
            <span class="cs-time">工作日 9:00-18:00</span>
          </div>
        </div>
      </div>
      <div class="cs-footer">
        <div class="back-to-top" @click="scrollToTop">
          <el-icon><Top /></el-icon>
          <span>返回顶部</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const isExpanded = ref(false)

function scrollToTop() {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}
</script>

<style scoped>
.customer-service {
  position: fixed;
  right: 20px;
  bottom: 120px;
  z-index: 9999;
  font-size: 13px;
}

/* 折叠状态 */
.cs-collapsed {
  width: 48px;
  height: 48px;
  background: var(--theme-color);
  color: #fff;
  border-radius: 50%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  box-shadow: 0 4px 12px rgba(230, 0, 18, 0.3);
  transition: transform 0.3s;
  user-select: none;
}

.cs-collapsed:hover {
  transform: scale(1.08);
}

.cs-icon {
  font-size: 20px;
}

.cs-label {
  font-size: 10px;
  margin-top: 1px;
}

/* 展开状态 */
.cs-expanded {
  width: 220px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
  overflow: hidden;
}

.cs-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 14px 16px;
  background: var(--theme-color);
  color: #fff;
  font-size: 14px;
  font-weight: 600;
}

.cs-close {
  cursor: pointer;
  font-size: 16px;
  opacity: 0.8;
}

.cs-close:hover {
  opacity: 1;
}

.cs-body {
  padding: 12px 16px;
}

.cs-item {
  display: flex;
  gap: 10px;
  padding: 12px 0;
  border-bottom: 1px solid #f5f5f5;
}

.cs-item:last-child {
  border-bottom: none;
}

.cs-item-icon {
  font-size: 20px;
  color: var(--theme-color);
  flex-shrink: 0;
  margin-top: 2px;
}

.cs-item-content {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.cs-item-title {
  font-size: 13px;
  font-weight: 600;
  color: #333;
}

.cs-link {
  color: var(--theme-color);
  font-size: 13px;
  text-decoration: none;
}

.cs-link:hover {
  text-decoration: underline;
}

.wechat-qr-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  width: 120px;
  height: 90px;
  background: #fafafa;
  border: 1px dashed #ddd;
  border-radius: 4px;
  justify-content: center;
  margin-top: 4px;
}

.qr-icon {
  font-size: 28px;
  color: #ccc;
}

.wechat-qr-placeholder span {
  font-size: 11px;
  color: #bbb;
}

.cs-phone {
  font-size: 16px;
  font-weight: 700;
  color: var(--theme-color);
}

.cs-time {
  font-size: 11px;
  color: #999;
}

.cs-footer {
  border-top: 1px solid #f0f0f0;
}

.back-to-top {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  padding: 12px 0;
  cursor: pointer;
  color: #666;
  font-size: 13px;
  transition: color 0.2s;
}

.back-to-top:hover {
  color: var(--theme-color);
}
</style>