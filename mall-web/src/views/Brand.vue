<template>
  <div class="brand-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>品牌专区</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <!-- 字母索引 -->
      <div class="letter-index">
        <span class="letter-item" :class="{ active: activeLetter === '' }" @click="activeLetter = ''">全部</span>
        <span class="letter-item" v-for="l in letters" :key="l" :class="{ active: activeLetter === l }" @click="activeLetter = l">{{ l }}</span>
      </div>
      <!-- 品牌列表 -->
      <div class="brand-list">
        <div class="brand-group" v-for="group in filteredBrands" :key="group.letter">
          <h4 class="group-letter">{{ group.letter }}</h4>
          <div class="brand-items">
            <div class="brand-item" v-for="brand in group.items" :key="brand.id" @click="$router.push(`/brand/${brand.id}`)">
              <div class="brand-logo">{{ brand.name.charAt(0) }}</div>
              <span class="brand-name">{{ brand.name }}</span>
            </div>
          </div>
        </div>
        <div v-if="filteredBrands.length === 0" class="empty-state">
          <el-icon><FolderDeleted /></el-icon>
          <p>暂无该字母开头的品牌</p>
        </div>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'

const activeLetter = ref('')

const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')

const brandGroups = ref([
  { letter: 'A', items: [{ id: 6, name: 'ADI亚德诺' }] },
  { letter: 'B', items: [{ id: 12, name: 'Broadcom博通' }] },
  { letter: 'I', items: [{ id: 5, name: 'Infineon英飞凌' }] },
  { letter: 'M', items: [{ id: 4, name: 'Microchip' }, { id: 8, name: 'Maxim美信' }] },
  { letter: 'N', items: [{ id: 3, name: 'NXP恩智浦' }, { id: 10, name: 'NVIDIA英伟达' }] },
  { letter: 'O', items: [{ id: 8, name: 'ON安森美' }] },
  { letter: 'R', items: [{ id: 9, name: 'Renesas瑞萨' }] },
  { letter: 'S', items: [{ id: 1, name: 'ST意法半导体' }] },
  { letter: 'T', items: [{ id: 2, name: 'TI德州仪器' }] },
  { letter: 'X', items: [{ id: 11, name: 'Xilinx赛灵思' }] },
])

const filteredBrands = computed(() => {
  if (!activeLetter.value) return brandGroups.value
  return brandGroups.value.filter(g => g.letter === activeLetter.value)
})
</script>

<style scoped>
.brand-page {
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

.letter-index {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  padding: 16px 20px;
  background: #fff;
  border-radius: 8px;
  margin-bottom: 20px;
}

.letter-item {
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  color: #666;
  cursor: pointer;
  border-radius: 4px;
  transition: all 0.2s;
}

.letter-item:hover,
.letter-item.active {
  background: var(--theme-color);
  color: #fff;
}

.brand-list {
  background: #fff;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 40px;
}

.brand-group {
  margin-bottom: 24px;
}

.brand-group:last-child {
  margin-bottom: 0;
}

.group-letter {
  font-size: 20px;
  font-weight: 700;
  color: var(--theme-color);
  margin-bottom: 12px;
  padding-bottom: 8px;
  border-bottom: 2px solid var(--theme-color-light);
}

.brand-items {
  display: grid;
  grid-template-columns: repeat(6, 1fr);
  gap: 16px;
}

.brand-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  padding: 20px;
  border: 1px solid #eee;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s;
}

.brand-item:hover {
  border-color: var(--theme-color);
  box-shadow: 0 4px 12px rgba(230, 0, 18, 0.08);
}

.brand-logo {
  width: 60px;
  height: 60px;
  line-height: 60px;
  text-align: center;
  background: var(--theme-color-light);
  color: var(--theme-color);
  font-size: 24px;
  font-weight: 700;
  border-radius: 50%;
}

.brand-name {
  font-size: 13px;
  color: #333;
  text-align: center;
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
</style>