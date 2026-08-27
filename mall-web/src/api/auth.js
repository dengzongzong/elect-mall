import request from './request'

/**
 * 发送短信验证码
 */
export function sendCode(phone) {
  return request.post('/auth/send-code', { phone })
}

/**
 * 手机号验证码登录
 */
export function phoneLogin(phone, code) {
  return request.post('/auth/phone-login', { phone, code })
}

/**
 * 微信登录
 */
export function wechatLogin(code) {
  return request.post('/auth/wechat-login', { code })
}

/**
 * 绑定手机号
 */
export function bindPhone(phone, code, tempToken) {
  return request.post('/auth/bind-phone', { phone, code, tempToken })
}

/**
 * 退出登录
 */
export function logout() {
  return request.post('/auth/logout')
}

/**
 * 获取当前用户信息
 */
export function getUserInfo() {
  return request.get('/auth/user-info')
}