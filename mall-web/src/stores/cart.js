import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
// 注意：store 内部也导出 clearCart，此处必须取别名，避免递归调用自身
import {
  getCartList,
  addToCart,
  updateCartQuantity,
  deleteCartItem,
  clearCart as clearCartRequest,
} from '../api/cart'

// 购物车：以服务端数据为准，localStorage 仅作首屏即时展示的缓存，
// 未登录时退化为纯本地购物车。
export const useCartStore = defineStore('cart', () => {
  const items = ref(JSON.parse(localStorage.getItem('cartItems') || '[]'))
  const loading = ref(false)

  const count = computed(() => {
    return items.value.reduce((sum, item) => sum + (Number(item.quantity) || 0), 0)
  })

  const total = computed(() => {
    return items.value.reduce((sum, item) => sum + (Number(item.price) || 0) * (Number(item.quantity) || 0), 0)
  })

  const isLogin = () => !!localStorage.getItem('token')

  function saveToLocal() {
    localStorage.setItem('cartItems', JSON.stringify(items.value))
  }

  // 从服务端拉取并覆盖本地（购物车行 id 用于删改，productId 才是商品 id）
  async function syncFromServer() {
    if (!isLogin()) return
    loading.value = true
    try {
      const res = await getCartList()
      const list = Array.isArray(res) ? res : []
      items.value = list.map((r) => ({
        id: r.id,
        productId: r.product_id,
        name: r.name,
        partNo: r.part_no,
        image: r.image_url || '',
        price: Number(r.price) || 0,
        quantity: Number(r.quantity) || 1,
        stock: Number(r.stock) || 9999,
      }))
      saveToLocal()
    } catch (e) {
      // 拉取失败时保留现有数据
    } finally {
      loading.value = false
    }
  }

  function mergeLocal(product) {
    const quantity = product.quantity || 1
    const existing = items.value.find((item) => item.productId === product.id || item.id === product.id)
    if (existing) {
      existing.quantity = (Number(existing.quantity) || 0) + quantity
    } else {
      items.value.push({
        id: product.id,
        productId: product.id,
        name: product.name,
        partNo: product.part_no || '',
        image: product.image || '',
        price: Number(product.price) || 0,
        quantity,
        stock: product.stock || 9999,
      })
    }
    saveToLocal()
  }

  async function addItem(product) {
    mergeLocal(product)
    if (!isLogin()) return
    try {
      await addToCart(product.id, product.quantity || 1)
      await syncFromServer()
    } catch (e) {
      // 接口失败时保留本地乐观结果
    }
  }

  async function removeItem(id) {
    const prev = items.value
    items.value = items.value.filter((item) => item.id !== id)
    saveToLocal()
    if (!isLogin()) return
    try {
      await deleteCartItem(id)
      await syncFromServer()
    } catch (e) {
      items.value = prev
      saveToLocal()
    }
  }

  async function updateQuantity(id, quantity) {
    const item = items.value.find((i) => i.id === id)
    if (item) {
      item.quantity = quantity
      saveToLocal()
    }
    if (!isLogin()) return
    try {
      await updateCartQuantity(id, quantity)
      await syncFromServer()
    } catch (e) {
      // 失败保留本地值
    }
  }

  async function clearCart() {
    const prev = items.value
    items.value = []
    saveToLocal()
    if (!isLogin()) return
    try {
      await clearCartRequest()
      await syncFromServer()
    } catch (e) {
      items.value = prev
      saveToLocal()
    }
  }

  return {
    items,
    count,
    total,
    loading,
    syncFromServer,
    addItem,
    removeItem,
    updateQuantity,
    clearCart,
    saveToLocal,
  }
})
