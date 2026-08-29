<template>
  <div class="user-favorite">
    <div class="section-card">
      <h4>我的收藏</h4>
      <div class="favorite-grid" v-if="favorites.length > 0">
        <div class="favorite-item" v-for="f in favorites" :key="f.id" @click="$router.push(`/product/${f.product_id}`)">
          <div class="fav-img"><el-icon><Cpu /></el-icon></div>
          <div class="fav-info">
            <h5>{{ f.name }}</h5>
            <p class="fav-model">{{ f.part_no }}</p>
            <p class="fav-price">￥{{ f.price }}</p>
          </div>
          <el-button link type="danger" class="fav-remove" @click.stop="handleRemove(f.id)">删除</el-button>
        </div>
      </div>
      <div class="empty-state" v-else>
        <el-icon><Star /></el-icon>
        <p>暂无收藏的商品</p>
        <el-button type="danger" @click="$router.push('/')">去逛逛</el-button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getFavoriteList, deleteFavorite } from '../api/user'

const favorites = ref([])
const loading = ref(false)

async function fetchFavorites() {
  loading.value = true
  try {
    const res = await getFavoriteList()
    favorites.value = Array.isArray(res) ? res : []
  } catch (e) {
    favorites.value = []
  } finally {
    loading.value = false
  }
}

async function handleRemove(id) {
  try {
    await deleteFavorite(id)
    ElMessage.success('已取消收藏')
    await fetchFavorites()
  } catch (e) {
    ElMessage.error('取消收藏失败')
  }
}

onMounted(() => {
  fetchFavorites()
})
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
  margin-bottom: 24px;
  padding-bottom: 12px;
  border-bottom: 1px solid #f0f0f0;
}

.favorite-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
}

.favorite-item {
  display: flex;
  flex-direction: column;
  border: 1px solid #eee;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  position: relative;
  transition: all 0.3s;
}

.favorite-item:hover {
  border-color: var(--theme-color);
  box-shadow: 0 4px 12px rgba(230, 0, 18, 0.08);
}

.fav-img {
  height: 120px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fafafa;
}

.fav-img .el-icon {
  font-size: 36px;
  color: #ddd;
}

.fav-info {
  padding: 12px;
}

.fav-info h5 {
  font-size: 14px;
  font-weight: 600;
  color: #333;
  margin-bottom: 4px;
}

.fav-model {
  font-size: 12px;
  color: #999;
  margin-bottom: 6px;
}

.fav-price {
  font-size: 16px;
  font-weight: 700;
  color: var(--theme-color);
}

.fav-remove {
  position: absolute;
  top: 8px;
  right: 8px;
  opacity: 0;
  transition: opacity 0.2s;
}

.favorite-item:hover .fav-remove {
  opacity: 1;
}

.empty-state {
  text-align: center;
  padding: 60px 0;
  color: #ccc;
}

.empty-state .el-icon {
  font-size: 48px;
  margin-bottom: 12px;
}

.empty-state p {
  font-size: 15px;
  margin-bottom: 16px;
}
</style>