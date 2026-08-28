<template>
  <div class="right-sidebar" :class="{ collapsed: isCollapsed }">
    <div class="toggle-btn" @click="toggleSidebar">
      <el-icon><Close /></el-icon>
    </div>
    <div class="sidebar-items">
      <div class="sidebar-item" @click="handleGo('/cart')">
        <el-icon><ShoppingCart /></el-icon>
        <span>购物车</span>
      </div>
      <div class="sidebar-item" @click="handleGo('/user/profile')">
        <el-icon><User /></el-icon>
        <span>会员中心</span>
      </div>
      <div class="sidebar-item" @click="handleGo('/user/favorite')">
        <el-icon><Star /></el-icon>
        <span>我的收藏</span>
      </div>
      <div class="sidebar-item" @click="handleGo('/history')">
        <el-icon><Clock /></el-icon>
        <span>浏览历史</span>
      </div>
      <div class="sidebar-item" @click="handleGo('/feedback')">
        <el-icon><Edit /></el-icon>
        <span>意见反馈</span>
      </div>
      <div class="sidebar-item" @click="handleOpenWechat">
        <el-icon><ChatLineRound /></el-icon>
        <span>活动咨询</span>
      </div>
      <div class="sidebar-item go-top" @click="scrollToTop">
        <el-icon><Top /></el-icon>
        <span>返回顶部</span>
      </div>
    </div>

    <!-- 微信二维码弹窗 -->
    <el-dialog v-model="wechatDialogVisible" title="活动咨询-微信" width="300" center>
      <div class="wechat-qr-container">
        <p class="wechat-tip">扫码添加微信咨询</p>
        <img src="/wechat-qrcode.jpg" alt="微信二维码" class="wechat-qr" />
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const isCollapsed = ref(false)
const wechatDialogVisible = ref(false)

function toggleSidebar() {
  isCollapsed.value = !isCollapsed.value
}

function handleGo(path) {
  router.push(path)
}

function handleOpenWechat() {
  wechatDialogVisible.value = true
}

function scrollToTop() {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}
</script>

<style scoped>
.right-sidebar {
  position: fixed;
  right: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 60px;
  background: #fff;
  border-radius: 8px 0 0 8px;
  box-shadow: -2px 0 12px rgba(0, 0, 0, 0.08);
  z-index: 999;
  transition: all 0.3s ease;
}

.right-sidebar.collapsed {
  right: 0;
}

.toggle-btn {
  position: absolute;
  left: -20px;
  top: 0;
  width: 20px;
  height: 40px;
  background: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px 0 0 8px;
  box-shadow: -2px 0 8px rgba(0, 0, 0, 0.06);
  cursor: pointer;
  color: #666;
}

.toggle-btn:hover {
  color: var(--theme-color);
}

.sidebar-items {
  display: flex;
  flex-direction: column;
}

.sidebar-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 12px 0;
  gap: 4px;
  cursor: pointer;
  color: #666;
  font-size: 12px;
  transition: all 0.2s;
}

.sidebar-item:hover {
  color: var(--theme-color);
  background: var(--theme-color-light);
}

.sidebar-item .el-icon {
  font-size: 24px;
}

.sidebar-item span {
  white-space: nowrap;
  user-select: none;
}

.go-top {
  border-top: 1px solid #f0f0f0;
  margin-top: 4px;
  padding-top: 12px;
}

.wechat-qr-container {
  text-align: center;
  padding: 10px 0;
}

.wechat-tip {
  color: #666;
  margin-bottom: 16px;
  font-size: 14px;
}

.wechat-qr {
  width: 200px;
  height: 200px;
  border: 1px solid #eee;
  border-radius: 4px;
}

/* 移动端隐藏 */
@media (max-width: 768px) {
  .right-sidebar {
    display: none;
  }
}
</style>