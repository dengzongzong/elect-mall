import request from './request'

/**
 * 获取新闻资讯列表
 */
export function getNewsList() {
  return request.get('/news/list')
}

/**
 * 获取新闻资讯详情
 */
export function getNewsDetail(id) {
  return request.get(`/news/${id}`)
}

/**
 * 点赞/取消点赞资讯
 */
export function toggleNewsLike(newsId) {
  return request.post('/news/toggle-like', { newsId })
}

/**
 * 收藏/取消收藏资讯
 */
export function toggleNewsFavorite(newsId) {
  return request.post('/news/toggle-favorite', { newsId })
}

/**
 * 获取数据手册列表
 */
export function getDatasheetList() {
  return request.get('/datasheet/list')
}

/**
 * 获取合作品牌列表
 */
export function getCooperateBrands() {
  return request.get('/cooperate-brand/list')
}

/**
 * 提交合作伙伴申请
 */
export function submitPartnerApply(data) {
  return request.post('/partner/apply', data)
}

/**
 * 获取轮播图列表
 */
export function getCarousels() {
  return request.get('/carousel/public/list')
}