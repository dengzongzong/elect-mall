import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useCartStore = defineStore('cart', () => {
  const items = ref(JSON.parse(localStorage.getItem('cartItems') || '[]'))

  const count = computed(() => {
    return items.value.reduce((sum, item) => sum + item.quantity, 0)
  })

  const total = computed(() => {
    return items.value.reduce((sum, item) => sum + item.price * item.quantity, 0)
  })

  function addItem(product) {
    const existing = items.value.find((item) => item.id === product.id)
    if (existing) {
      existing.quantity += product.quantity || 1
    } else {
      items.value.push({
        id: product.id,
        name: product.name,
        image: product.image,
        price: product.price,
        quantity: product.quantity || 1,
        stock: product.stock || 0,
      })
    }
    saveToLocal()
  }

  function removeItem(id) {
    items.value = items.value.filter((item) => item.id !== id)
    saveToLocal()
  }

  function updateQuantity(id, quantity) {
    const item = items.value.find((item) => item.id === id)
    if (item) {
      item.quantity = quantity
      saveToLocal()
    }
  }

  function clearCart() {
    items.value = []
    saveToLocal()
  }

  function saveToLocal() {
    localStorage.setItem('cartItems', JSON.stringify(items.value))
  }

  return {
    items,
    count,
    total,
    addItem,
    removeItem,
    updateQuantity,
    clearCart,
  }
})