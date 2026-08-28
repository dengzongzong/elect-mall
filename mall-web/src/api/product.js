import request from './request'

/**
 * 获取商品分类列表
 */
export function getCategories() {
  return request.get('/product/categories')
}

/**
 * 获取分类树
 */
export function getCategoryTree() {
  return request.get('/product/categories/tree')
}

/**
 * 分页查询商品
 */
export function getProducts(params) {
  return request.get('/product/page', { params })
}

/**
 * 获取商品详情
 */
export function getProductDetail(id) {
  return request.get(`/product/${id}`)
}

/**
 * 获取推荐商品
 */
export function getRecommendProducts(productId, limit = 8) {
  return request.get('/product/recommend', { params: { productId, limit } })
}

/**
 * 获取品牌列表
 */
export function getBrands() {
  return request.get('/brand/list')
}

/**
 * 获取分类详情（含富文本描述）
 */
export function getCategoryDetail(id) {
  return request.get(`/category/detail/${id}`)
}

/**
 * 获取品牌商品
 */
export function getBrandProducts(brandId, params) {
  return request.get(`/brand/${brandId}/products`, { params })
}