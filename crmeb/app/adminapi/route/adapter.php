<?php
// +----------------------------------------------------------------------
// | 电子元器件商城 - 管理后台API适配路由
// +----------------------------------------------------------------------
// | 将admin-web前端API路径映射到PHP后端服务
// +----------------------------------------------------------------------

use think\facade\Route;
use app\http\middleware\AllowOriginMiddleware;

Route::group('adapter', function () {

    // ====== 认证 ======
    Route::post('auth/login', 'adapter.AdminController/login');
    Route::get('dashboard', 'adapter.AdminController/dashboard');

    // ====== 品牌管理 ======
    Route::get('brand/list', 'adapter.AdminController/brandList');
    Route::post('brand/add', 'adapter.AdminController/brandAdd');
    Route::put('brand/update', 'adapter.AdminController/brandUpdate');
    Route::get('brand/delete/:id', 'adapter.AdminController/brandDelete');

    // ====== 分类管理 ======
    Route::get('category/list', 'adapter.AdminController/categoryList');
    Route::post('category/add', 'adapter.AdminController/categoryAdd');
    Route::put('category/update', 'adapter.AdminController/categoryUpdate');
    Route::delete('category/delete', 'adapter.AdminController/categoryDelete');

    // ====== 新闻管理 ======
    Route::get('news/list', 'adapter.AdminController/newsList');
    Route::post('news/add', 'adapter.AdminController/newsAdd');
    Route::put('news/update', 'adapter.AdminController/newsUpdate');
    Route::delete('news/delete', 'adapter.AdminController/newsDelete');

    // ====== 商品管理 ======
    Route::post('product/page', 'adapter.AdminController/productPage');
    Route::post('product/add', 'adapter.AdminController/productAdd');
    Route::put('product/update', 'adapter.AdminController/productUpdate');
    Route::delete('product/delete', 'adapter.AdminController/productDelete');

    // ====== 订单管理 ======
    Route::get('order/page', 'adapter.AdminController/orderPage');
    Route::post('order/audit', 'adapter.AdminController/orderAudit');
    Route::post('order/ship', 'adapter.AdminController/orderShip');

    // ====== 用户管理 ======
    Route::get('user/list', 'adapter.AdminController/userList');

    // ====== 询价单 ======
    Route::get('inquiry/page', 'adapter.AdminController/inquiryPage');
    Route::post('inquiry/reply', 'adapter.AdminController/inquiryReply');

    // ====== 合作伙伴 ======
    Route::get('partner/list', 'adapter.AdminController/partnerList');

    // ====== 反馈 ======
    Route::get('feedback/list', 'adapter.AdminController/feedbackList');

    // ====== 财务 ======
    Route::get('finance/data', 'adapter.AdminController/financeData');

    // ====== 系统设置 ======
    Route::get('setting/list', 'adapter.AdminController/settingList');
    Route::post('setting/save', 'adapter.AdminController/settingSave');

    // ====== 上传 ======
    Route::post('upload', 'adapter.AdminController/upload');

    // ====== BOM管理 ======
    Route::get('bom/list', 'adapter.AdminController/bomList');
    Route::delete('bom/delete', 'adapter.AdminController/bomDelete');

    // ====== 合作品牌 ======
    Route::get('cooperate/list', 'adapter.AdminController/cooperateList');
    Route::post('cooperate/add', 'adapter.AdminController/cooperateAdd');
    Route::put('cooperate/update', 'adapter.AdminController/cooperateUpdate');
    Route::delete('cooperate/delete', 'adapter.AdminController/cooperateDelete');

    // ====== 数据手册 ======
    Route::get('datasheet/list', 'adapter.AdminController/datasheetList');
    Route::delete('datasheet/delete', 'adapter.AdminController/datasheetDelete');

    // ====== 消息通知 ======
    Route::get('message/list', 'adapter.AdminController/messageList');
    Route::post('message/send', 'adapter.AdminController/messageSend');

})->middleware(AllowOriginMiddleware::class);