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

/**
 * 获取常用型号列表
 */
export function getPartNoList() {
  return request.get('/user/part-no/list')
}

/**
 * 新增常用型号
 */
export function addPartNo(partNo) {
  return request.post('/user/part-no/add', { partNo })
}

/**
 * 删除常用型号
 */
export function deletePartNo(id) {
  return request.delete('/user/part-no/delete', { data: { id } })
}

/**
 * 绑定邮箱
 */
export function bindEmail(email) {
  return request.put('/user/security/bind-email', { email })
}