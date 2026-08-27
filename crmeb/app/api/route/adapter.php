<?php
// +----------------------------------------------------------------------
// | 电子元器件商城 - API适配路由
// +----------------------------------------------------------------------
// | 将现有前端API路径映射到CRMEB后端服务
// +----------------------------------------------------------------------

use think\facade\Route;

/**
 * 产品相关API
 * 对应前端: /api/product/*
 * 映射到: 适配器 + CRMEB原生服务
 */
Route::group('adapter', function () {

    // ====== 产品 ======
    Route::get('product/categories', 'adapter.ProductController/categories');
    Route::get('product/categories/tree', 'adapter.ProductController/categoryTree');
    Route::get('product/page', 'adapter.ProductController/page');
    Route::get('product/recommend', 'adapter.ProductController/recommend');
    Route::get('product/:id', 'adapter.ProductController/detail');

    // ====== 品牌 ======
    Route::get('brand/list', 'adapter.ProductController/brands');
    Route::get('brand/:brandId/products', 'adapter.ProductController/brandProducts');

    // ====== 认证 ======
    Route::post('auth/send-code', 'adapter.AuthController/sendCode');
    Route::post('auth/phone-login', 'adapter.AuthController/phoneLogin');
    Route::post('auth/wechat-login', 'adapter.AuthController/wechatLogin');
    Route::post('auth/bind-phone', 'adapter.AuthController/bindPhone');
    Route::post('auth/logout', 'adapter.AuthController/logout');
    Route::get('auth/user-info', 'adapter.AuthController/userInfo');

    // ====== 购物车 ======
    Route::get('cart/list', 'adapter.CartController/list');
    Route::post('cart/add', 'adapter.CartController/add');
    Route::put('cart/update', 'adapter.CartController/update');
    Route::delete('cart/delete', 'adapter.CartController/delete');
    Route::delete('cart/clear', 'adapter.CartController/clear');

    // ====== 订单 ======
    Route::post('order/create', 'adapter.OrderController/create');
    Route::get('order/list', 'adapter.OrderController/list');
    Route::get('order/:id', 'adapter.OrderController/detail');
    Route::post('order/cancel', 'adapter.OrderController/cancel');
    Route::post('order/confirm-receipt', 'adapter.OrderController/confirmReceipt');

    // ====== 用户 ======
    Route::get('user/address/list', 'adapter.UserController/addressList');
    Route::post('user/address/add', 'adapter.UserController/addressAdd');
    Route::put('user/address/update', 'adapter.UserController/addressUpdate');
    Route::delete('user/address/delete', 'adapter.UserController/addressDelete');
    Route::get('user/favorite/list', 'adapter.UserController/favoriteList');
    Route::post('user/favorite/add', 'adapter.UserController/favoriteAdd');
    Route::delete('user/favorite/delete', 'adapter.UserController/favoriteDelete');
    Route::get('user/balance/log', 'adapter.UserController/balanceLog');
    Route::post('user/feedback/submit', 'adapter.UserController/submitFeedback');
    Route::get('user/message/list', 'adapter.UserController/messageList');
    Route::put('user/center/update-profile', 'adapter.UserController/updateProfile');

    // ====== 内容 ======
    Route::get('news/list', 'adapter.ContentController/newsList');
    Route::get('news/:id', 'adapter.ContentController/newsDetail');
    Route::post('news/toggle-like', 'adapter.ContentController/toggleNewsLike');
    Route::post('news/toggle-favorite', 'adapter.ContentController/toggleNewsFavorite');
    Route::get('datasheet/list', 'adapter.ContentController/datasheetList');
    Route::get('cooperate-brand/list', 'adapter.ContentController/cooperateBrands');
    Route::post('partner/apply', 'adapter.ContentController/partnerApply');
    Route::post('inquiry/submit', 'adapter.ContentController/submitInquiry');
    Route::get('inquiry/list', 'adapter.ContentController/inquiryList');

})->middleware(\app\http\middleware\AllowOriginMiddleware::class)
    ->middleware(\app\api\middleware\StationOpenMiddleware::class);