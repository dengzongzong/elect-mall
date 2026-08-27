import request from './request'

/**
 * 统一下单（支付）
 */
export function unifiedOrder(orderId, method) {
  return request.post('/pay/unified-order', { orderId, method })
}

/**
 * 模拟支付回调
 */
export function mockPayNotify(payNo, tradeNo, amount) {
  return request.post('/pay/notify', { payNo, tradeNo, amount })
}