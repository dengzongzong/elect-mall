import axios from 'axios'
import { ElMessage } from 'element-plus'

const request = axios.create({
  baseURL: '/api',
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json',
  },
})

// 请求拦截器 - 添加 token
request.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token')
    if (token) {
      // CRMEB使用 Bearer 格式 token
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// 响应拦截器 - 适配 CRMEB 响应格式
// CRMEB格式: { status: 200, msg: "success", data: {...} }
// 兼容旧格式: { code: 200, message: "success", data: {...} }
request.interceptors.response.use(
  (response) => {
    const res = response.data

    // 兼容 CRMEB 格式 (status/msg) 和旧格式 (code/message)
    const code = res.status !== undefined ? res.status : res.code
    const msg = res.msg || res.message || ''

    if (code !== undefined && code !== 200) {
      // 401 未授权 - 跳转登录
      if (code === 401 || code === 410) {
        localStorage.removeItem('token')
        localStorage.removeItem('userInfo')
        if (window.location.hash !== '#/login') {
          window.location.href = '/#/login'
        }
        return Promise.reject(new Error(msg || '未登录'))
      }
      ElMessage.error(msg || '请求失败')
      return Promise.reject(new Error(msg || '请求失败'))
    }

    // 标准化返回数据
    return res.data !== undefined ? res.data : res
  },
  (error) => {
    if (error.response) {
      const { status } = error.response
      if (status === 401) {
        localStorage.removeItem('token')
        localStorage.removeItem('userInfo')
        if (window.location.hash !== '#/login') {
          window.location.href = '/#/login'
        }
      } else if (status === 403) {
        ElMessage.error('没有权限访问')
      } else if (status === 404) {
        ElMessage.error('请求的资源不存在')
      } else if (status >= 500) {
        ElMessage.error('服务器错误，请稍后重试')
      }
    } else if (error.message.includes('timeout')) {
      ElMessage.error('请求超时，请检查网络连接')
    } else {
      ElMessage.error('网络异常，请检查网络连接')
    }
    return Promise.reject(error)
  }
)

export default request