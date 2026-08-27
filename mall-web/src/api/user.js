import request from './request'

/**
 * 获取用户地址列表
 */
export function getAddressList() {
  return request.get('/user/address/list')
}

/**
 * 新增地址
 */
export function addAddress(data) {
  return request.post('/user/address/add', data)
}

/**
 * 更新地址
 */
export function updateAddress(data) {
  return request.put('/user/address/update', data)
}

/**
 * 删除地址
 */
export function deleteAddress(id) {
  return request.delete('/user/address/delete', { data: { id } })
}

/**
 * 获取用户收藏列表
 */
export function getFavoriteList() {
  return request.get('/user/favorite/list')
}

/**
 * 添加收藏
 */
export function addFavorite(productId) {
  return request.post('/user/favorite/add', { productId })
}

/**
 * 删除收藏
 */
export function deleteFavorite(id) {
  return request.delete('/user/favorite/delete', { data: { id } })
}

/**
 * 获取余额流水
 */
export function getBalanceLog() {
  return request.get('/user/balance/log')
}

/**
 * 提交反馈
 */
export function submitFeedback(data) {
  return request.post('/user/feedback/submit', data)
}

/**
 * 获取用户消息列表
 */
export function getMessageList() {
  return request.get('/user/message/list')
}

/**
 * 更新用户资料
 */
export function updateUserProfile(data) {
  return request.put('/user/center/update-profile', data)
}