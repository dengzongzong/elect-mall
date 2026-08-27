import request from './request'

/**
 * 创建订单
 */
export function createOrder(address, remark) {
  return request.post('/order/create', { address, remark })
}

/**
 * 获取用户订单列表
 */
export function getOrderList() {
  return request.get('/order/list')
}

/**
 * 获取订单详情
 */
export function getOrderDetail(id) {
  return request.get(`/order/${id}`)
}

/**
 * 取消订单
 */
export function cancelOrder(id) {
  return request.post('/order/cancel', { id })
}

/**
 * 确认收货
 */
export function confirmReceipt(id) {
  return request.post('/order/confirm-receipt', { id })
}

/**
 * 上传转账凭证
 */
export function uploadVoucher(id, transferVoucher) {
  return request.post('/order/upload-voucher', { id, transferVoucher })
}