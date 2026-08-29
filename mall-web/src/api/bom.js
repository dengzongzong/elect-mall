import request from './request'

/**
 * 提交 BOM（items: [{ partNo, quantity }] 或 partNo/quantity 逗号分隔字符串）
 */
export function submitBom(data) {
  return request.post('/bom/submit', data)
}

/**
 * 获取当前用户 BOM 记录（含明细）
 */
export function getUserBomList() {
  return request.get('/bom/user/list')
}

/**
 * 删除 BOM 记录
 */
export function deleteBom(id) {
  return request.delete('/bom/delete', { data: { id } })
}
