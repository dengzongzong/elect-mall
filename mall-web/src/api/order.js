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

/**
 * 上传转账凭证（图片文件，multipart）
 * 用 fetch 直发，避免 axios 的 JSON Content-Type 干扰 multipart 边界
 */
export async function uploadVoucherFile(orderId, file) {
  const fd = new FormData()
  fd.append('id', orderId)
  fd.append('voucher', file)
  const token = localStorage.getItem('token')
  const res = await fetch('/api/adapter/order/upload-voucher', {
    method: 'POST',
    headers: token ? { Authorization: `Bearer ${token}` } : {},
    body: fd,
  })
  return res.json()
}