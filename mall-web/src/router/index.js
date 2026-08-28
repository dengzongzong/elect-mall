import { createRouter, createWebHashHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('../views/Home.vue'),
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue'),
  },
  {
    path: '/bindPhone',
    name: 'BindPhone',
    component: () => import('../views/BindPhone.vue'),
  },
  {
    path: '/category/:id',
    name: 'CategoryList',
    component: () => import('../views/CategoryList.vue'),
  },
  {
    path: '/category/detail/:id',
    name: 'CategoryDetail',
    component: () => import('../views/CategoryDetail.vue'),
  },
  {
    path: '/product/:id',
    name: 'ProductDetail',
    component: () => import('../views/ProductDetail.vue'),
  },
  {
    path: '/product-compare',
    name: 'ProductCompare',
    component: () => import('../views/ProductCompare.vue'),
  },
  {
    path: '/brand',
    name: 'Brand',
    component: () => import('../views/Brand.vue'),
  },
  {
    path: '/brand/:id',
    name: 'BrandProduct',
    component: () => import('../views/BrandProduct.vue'),
  },
  {
    path: '/bom',
    name: 'Bom',
    component: () => import('../views/Bom.vue'),
  },
  {
    path: '/inquiry',
    name: 'Inquiry',
    component: () => import('../views/Inquiry.vue'),
  },
  {
    path: '/datasheet',
    name: 'Datasheet',
    component: () => import('../views/Datasheet.vue'),
  },
  {
    path: '/cooperate',
    name: 'Cooperate',
    component: () => import('../views/Cooperate.vue'),
  },
  {
    path: '/partner',
    name: 'Partner',
    component: () => import('../views/Partner.vue'),
  },
  {
    path: '/news',
    name: 'News',
    component: () => import('../views/News.vue'),
  },
  {
    path: '/news/:id',
    name: 'NewsDetail',
    component: () => import('../views/NewsDetail.vue'),
  },
  {
    path: '/cart',
    name: 'Cart',
    component: () => import('../views/Cart.vue'),
  },
  {
    path: '/checkout',
    name: 'Checkout',
    component: () => import('../views/Checkout.vue'),
  },
  {
    path: '/pay/:orderNo',
    name: 'Pay',
    component: () => import('../views/Pay.vue'),
  },
  {
    path: '/order/list',
    name: 'OrderList',
    component: () => import('../views/OrderList.vue'),
  },
  {
    path: '/order/:id',
    name: 'OrderDetail',
    component: () => import('../views/OrderDetail.vue'),
  },
  {
    path: '/user',
    component: () => import('../views/UserCenter.vue'),
    redirect: '/user/profile',
    children: [
      {
        path: 'profile',
        name: 'UserProfile',
        component: () => import('../views/UserProfile.vue'),
      },
      {
        path: 'address',
        name: 'UserAddress',
        component: () => import('../views/UserAddress.vue'),
      },
      {
        path: 'security',
        name: 'UserSecurity',
        component: () => import('../views/UserSecurity.vue'),
      },
      {
        path: 'balance',
        name: 'UserBalance',
        component: () => import('../views/UserBalance.vue'),
      },
      {
        path: 'favorite',
        name: 'UserFavorite',
        component: () => import('../views/UserFavorite.vue'),
      },
      {
        path: 'partNo',
        name: 'UserPartNo',
        component: () => import('../views/UserPartNo.vue'),
      },
      {
        path: 'message',
        name: 'UserMessage',
        component: () => import('../views/UserMessage.vue'),
      },
      {
        path: 'feedback',
        name: 'UserFeedback',
        component: () => import('../views/UserFeedback.vue'),
      },
    ],
  },
]

const router = createRouter({
  history: createWebHashHistory(),
  routes,
  scrollBehavior() {
    return { top: 0 }
  },
})

export default router