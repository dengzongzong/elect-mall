import request from './request'

/**
 * 管理员登录
 */
export function adminLogin(username, password) {
  return request.post('/auth/login', { username, password })
}

/**
 * 获取仪表盘数据
 */
export function getDashboard() {
  return request.get('/admin/dashboard')
}

/**
 * 获取商品列表（管理端）
 */
export function getAdminProducts(params) {
  return request.get('/admin/product/page', { params })
}

/**
 * 新增/编辑商品
 */
export function saveProduct(data) {
  if (data.id) {
    return request.put('/admin/product/update', data)
  }
  return request.post('/admin/product/add', data)
}

/**
 * 删除商品
 */
export function deleteProduct(id) {
  return request.delete('/admin/product/delete', { data: { id } })
}

/**
 * 获取订单列表（管理端）
 */
export function getAdminOrders(params) {
  return request.get('/admin/order/page', { params })
}

/**
 * 审核订单
 */
export function auditOrder(id) {
  return request.post('/admin/order/audit', { id })
}

/**
 * 发货
 */
export function shipOrder(id) {
  return request.post('/admin/order/ship', { id })
}

/**
 * 获取用户列表
 */
export function getAdminUsers(params) {
  return request.get('/admin/user/list', { params })
}

/**
 * 获取分类列表
 */
export function getAdminCategories() {
  return request.get('/admin/category/list')
}

/**
 * 保存分类
 */
export function saveCategory(data) {
  if (data.id) {
    return request.put('/admin/category/update', data)
  }
  return request.post('/admin/category/add', data)
}

/**
 * 删除分类
 */
export function deleteCategory(id) {
  return request.delete('/admin/category/delete', { data: { id } })
}

/**
 * 获取品牌列表
 */
export function getAdminBrands() {
  return request.get('/admin/brand/list')
}

/**
 * 保存品牌
 */
export function saveBrand(data) {
  if (data.id) {
    return request.put('/admin/brand/update', data)
  }
  return request.post('/admin/brand/add', data)
}

/**
 * 获取新闻列表
 */
export function getAdminNews() {
  return request.get('/admin/news/list')
}

/**
 * 保存新闻
 */
export function saveNews(data) {
  if (data.id) {
    return request.put('/admin/news/update', data)
  }
  return request.post('/admin/news/add', data)
}

/**
 * 删除新闻
 */
export function deleteNews(id) {
  return request.delete('/admin/news/delete', { data: { id } })
}

/**
 * 获取询价单列表
 */
export function getAdminInquiries(params) {
  return request.get('/admin/inquiry/page', { params })
}

/**
 * 回复询价单
 */
export function replyInquiry(id, reply) {
  return request.post('/admin/inquiry/reply', { id, reply })
}

/**
 * 获取合作伙伴申请列表
 */
export function getAdminPartnerApplies() {
  return request.get('/admin/partner/list')
}

/**
 * 获取反馈列表
 */
export function getAdminFeedbacks() {
  return request.get('/admin/feedback/list')
}

/**
 * 获取财务数据
 */
export function getFinanceData(params) {
  return request.get('/admin/finance/data', { params })
}

/**
 * 获取系统配置
 */
export function getSettings() {
  return request.get('/admin/setting/list')
}

/**
 * 保存系统配置
 */
export function saveSetting(data) {
  return request.post('/admin/setting/save', data)
}

/**
 * 上传文件
 */
export function uploadFile(file) {
  const formData = new FormData()
  formData.append('file', file)
  return request.post('/admin/upload', formData, {
    headers: { 'Content-Type': 'multipart/form-data' },
  })
}

/**
 * 获取 BOM 列表
 */
export function getAdminBomList(params) {
  return request.get('/admin/bom/list', { params })
}

/**
 * 删除 BOM
 */
export function deleteBom(id) {
  return request.delete('/admin/bom/delete', { data: { id } })
}

/**
 * 获取合作品牌列表
 */
export function getAdminCooperates() {
  return request.get('/admin/cooperate/list')
}

/**
 * 保存合作品牌
 */
export function saveCooperate(data) {
  if (data.id) {
    return request.put('/admin/cooperate/update', data)
  }
  return request.post('/admin/cooperate/add', data)
}

/**
 * 删除合作品牌
 */
export function deleteCooperate(id) {
  return request.delete('/admin/cooperate/delete', { data: { id } })
}

/**
 * 获取数据手册列表
 */
export function getAdminDatasheets(params) {
  return request.get('/admin/datasheet/list', { params })
}

/**
 * 删除数据手册
 */
export function deleteDatasheet(id) {
  return request.delete('/admin/datasheet/delete', { data: { id } })
}

/**
 * 获取消息通知列表
 */
export function getAdminMessages(params) {
  return request.get('/admin/message/list', { params })
}

/**
 * 发送通知
 */
export function sendMessage(data) {
  return request.post('/admin/message/send', data)
}