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
  return request.get('/dashboard')
}

/**
 * 获取商品列表（管理端）
 */
export function getAdminProducts(params) {
  return request.post('/product/page', params)
}

/**
 * 新增/编辑商品
 */
export function saveProduct(data) {
  if (data.id) {
    return request.put('/product/update', data)
  }
  return request.post('/product/add', data)
}

/**
 * 删除商品
 */
export function deleteProduct(id) {
  return request.delete('/product/delete', { data: { id } })
}

/**
 * 获取订单列表（管理端）
 */
export function getAdminOrders(params) {
  return request.get('/order/page', { params })
}

/**
 * 审核订单
 */
export function auditOrder(id) {
  return request.post('/order/audit', { id })
}

/**
 * 发货
 */
export function shipOrder(id) {
  return request.post('/order/ship', { id })
}

/**
 * 获取用户列表
 */
export function getAdminUsers(params) {
  return request.get('/user/list', { params })
}

/**
 * 获取分类列表
 */
export function getAdminCategories() {
  return request.get('/category/list')
}

/**
 * 保存分类
 */
export function saveCategory(data) {
  if (data.id) {
    return request.put('/category/update', data)
  }
  return request.post('/category/add', data)
}

/**
 * 删除分类
 */
export function deleteCategory(id) {
  return request.delete('/category/delete', { data: { id } })
}

/**
 * 获取品牌列表
 */
export function getAdminBrands() {
  return request.get('/brand/list')
}

/**
 * 保存品牌
 */
export function saveBrand(data) {
  if (data.id) {
    return request.put('/brand/update', data)
  }
  return request.post('/brand/add', data)
}

/**
 * 获取新闻列表
 */
export function getAdminNews() {
  return request.get('/news/list')
}

/**
 * 保存新闻
 */
export function saveNews(data) {
  if (data.id) {
    return request.put('/news/update', data)
  }
  return request.post('/news/add', data)
}

/**
 * 删除新闻
 */
export function deleteNews(id) {
  return request.delete('/news/delete', { data: { id } })
}

/**
 * 获取询价单列表
 */
export function getAdminInquiries(params) {
  return request.get('/inquiry/page', { params })
}

/**
 * 回复询价单
 */
export function replyInquiry(id, reply) {
  return request.post('/inquiry/reply', { id, reply })
}

/**
 * 获取合作伙伴申请列表
 */
export function getAdminPartnerApplies() {
  return request.get('/partner/list')
}

/**
 * 获取反馈列表
 */
export function getAdminFeedbacks() {
  return request.get('/feedback/list')
}

/**
 * 获取财务数据
 */
export function getFinanceData(params) {
  return request.get('/finance/data', { params })
}

/**
 * 获取系统配置
 */
export function getSettings() {
  return request.get('/setting/list')
}

/**
 * 保存系统配置
 */
export function saveSetting(data) {
  return request.post('/setting/save', data)
}

/**
 * 上传文件
 */
export function uploadFile(file) {
  const formData = new FormData()
  formData.append('file', file)
  return request.post('/upload', formData, {
    headers: { 'Content-Type': 'multipart/form-data' },
  })
}

/**
 * 获取 BOM 列表
 */
export function getAdminBomList(params) {
  return request.get('/bom/list', { params })
}

/**
 * 删除 BOM
 */
export function deleteBom(id) {
  return request.delete('/bom/delete', { data: { id } })
}

/**
 * 获取合作品牌列表
 */
export function getAdminCooperates() {
  return request.get('/cooperate/list')
}

/**
 * 保存合作品牌
 */
export function saveCooperate(data) {
  if (data.id) {
    return request.put('/cooperate/update', data)
  }
  return request.post('/cooperate/add', data)
}

/**
 * 删除合作品牌
 */
export function deleteCooperate(id) {
  return request.delete('/cooperate/delete', { data: { id } })
}

/**
 * 获取数据手册列表
 */
export function getAdminDatasheets(params) {
  return request.get('/datasheet/list', { params })
}

/**
 * 删除数据手册
 */
export function deleteDatasheet(id) {
  return request.delete('/datasheet/delete', { data: { id } })
}

/**
 * 获取消息通知列表
 */
export function getAdminMessages(params) {
  return request.get('/message/list', { params })
}

/**
 * 发送通知
 */
export function sendMessage(data) {
  return request.post('/message/send', data)
}