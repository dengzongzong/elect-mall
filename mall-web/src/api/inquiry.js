import request from './request'

/**
 * 提交询价单
 */
export function submitInquiry(data) {
  return request.post('/inquiry/submit', data)
}

/**
 * 获取用户询价单列表
 */
export function getInquiryList() {
  return request.get('/inquiry/list')
}