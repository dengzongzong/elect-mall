import request from './request'

/**
 * 获取购物车列表
 */
export function getCartList() {
  return request.get('/cart/list')
}

/**
 * 添加商品到购物车
 */
export function addToCart(productId, quantity) {
  return request.post('/cart/add', { productId, quantity })
}

/**
 * 更新购物车商品数量
 */
export function updateCartQuantity(id, quantity) {
  return request.put('/cart/update', { id, quantity })
}

/**
 * 删除购物车商品
 */
export function deleteCartItem(id) {
  return request.delete('/cart/delete', { data: { id } })
}

/**
 * 清空购物车
 */
export function clearCart() {
  return request.delete('/cart/clear')
}