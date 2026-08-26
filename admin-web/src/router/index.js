import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue'),
    meta: { requiresAuth: false }
  },
  {
    path: '/',
    name: 'Layout',
    component: () => import('../views/Layout.vue'),
    meta: { requiresAuth: true },
    redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: () => import('../views/Dashboard.vue'),
        meta: { title: '工作台' }
      },
      {
        path: 'product',
        name: 'Product',
        component: () => import('../views/Product.vue'),
        meta: { title: '商品管理' }
      },
      {
        path: 'category',
        name: 'Category',
        component: () => import('../views/Category.vue'),
        meta: { title: '分类管理' }
      },
      {
        path: 'brand',
        name: 'Brand',
        component: () => import('../views/Brand.vue'),
        meta: { title: '品牌管理' }
      },
      {
        path: 'bom',
        name: 'Bom',
        component: () => import('../views/Bom.vue'),
        meta: { title: 'BOM管理' }
      },
      {
        path: 'inquiry',
        name: 'Inquiry',
        component: () => import('../views/Inquiry.vue'),
        meta: { title: '询价管理' }
      },
      {
        path: 'order',
        name: 'Order',
        component: () => import('../views/Order.vue'),
        meta: { title: '订单管理' }
      },
      {
        path: 'user',
        name: 'User',
        component: () => import('../views/User.vue'),
        meta: { title: '用户管理' }
      },
      {
        path: 'finance',
        name: 'Finance',
        component: () => import('../views/Finance.vue'),
        meta: { title: '财务管理' }
      },
      {
        path: 'news',
        name: 'News',
        component: () => import('../views/News.vue'),
        meta: { title: '新闻管理' }
      },
      {
        path: 'datasheet',
        name: 'Datasheet',
        component: () => import('../views/Datasheet.vue'),
        meta: { title: '数据手册' }
      },
      {
        path: 'cooperate',
        name: 'Cooperate',
        component: () => import('../views/Cooperate.vue'),
        meta: { title: '合作品牌' }
      },
      {
        path: 'partner',
        name: 'Partner',
        component: () => import('../views/Partner.vue'),
        meta: { title: '供应商合作' }
      },
      {
        path: 'message',
        name: 'Message',
        component: () => import('../views/Message.vue'),
        meta: { title: '消息通知' }
      },
      {
        path: 'feedback',
        name: 'Feedback',
        component: () => import('../views/Feedback.vue'),
        meta: { title: '投诉反馈' }
      },
      {
        path: 'setting',
        name: 'Setting',
        component: () => import('../views/Setting.vue'),
        meta: { title: '系统设置' }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 导航守卫
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('admin_token')
  if (to.meta.requiresAuth !== false && !token) {
    next('/login')
  } else if (to.path === '/login' && token) {
    next('/dashboard')
  } else {
    next()
  }
})

export default router