<?php

use think\facade\Route;

Route::get('surl/:id', function(\app\Request $request){
    return app()->make(\app\api\controller\v1\PublicController::class)->getSchemeUrl($request->param('id'));
});

/**
 * 适配器路由 - 无需经过CRMEB miss路由
 */
Route::group('api/adapter', function () {
    Route::get('product/categories', 'api/adapter.ProductController/categories');
    Route::get('product/categories/tree', 'api/adapter.ProductController/categoryTree');
    Route::get('product/page', 'api/adapter.ProductController/page');
    Route::get('product/recommend', 'api/adapter.ProductController/recommend');
    Route::get('product/:id', 'api/adapter.ProductController/detail');
    Route::get('brand/list', 'api/adapter.ProductController/brands');
    Route::get('brand/:brandId/products', 'api/adapter.ProductController/brandProducts');
    Route::post('auth/send-code', 'api/adapter.AuthController/sendCode');
    Route::post('auth/phone-login', 'api/adapter.AuthController/phoneLogin');
    Route::post('auth/wechat-login', 'api/adapter.AuthController/wechatLogin');
    Route::post('auth/bind-phone', 'api/adapter.AuthController/bindPhone');
    Route::post('auth/logout', 'api/adapter.AuthController/logout');
    Route::get('auth/user-info', 'api/adapter.AuthController/userInfo');
    Route::get('cart/list', 'api/adapter.CartController/list');
    Route::post('cart/add', 'api/adapter.CartController/add');
    Route::put('cart/update', 'api/adapter.CartController/update');
    Route::delete('cart/delete', 'api/adapter.CartController/delete');
    Route::delete('cart/clear', 'api/adapter.CartController/clear');
    Route::post('order/create', 'api/adapter.OrderController/create');
    Route::get('order/list', 'api/adapter.OrderController/list');
    Route::get('order/:id', 'api/adapter.OrderController/detail');
    Route::post('order/cancel', 'api/adapter.OrderController/cancel');
    Route::post('order/confirm-receipt', 'api/adapter.OrderController/confirmReceipt');
    Route::get('user/address/list', 'api/adapter.UserController/addressList');
    Route::post('user/address/add', 'api/adapter.UserController/addressAdd');
    Route::put('user/address/update', 'api/adapter.UserController/addressUpdate');
    Route::delete('user/address/delete', 'api/adapter.UserController/addressDelete');
    Route::get('user/favorite/list', 'api/adapter.UserController/favoriteList');
    Route::post('user/favorite/add', 'api/adapter.UserController/favoriteAdd');
    Route::delete('user/favorite/delete', 'api/adapter.UserController/favoriteDelete');
    Route::get('user/balance/log', 'api/adapter.UserController/balanceLog');
    Route::post('user/feedback/submit', 'api/adapter.UserController/submitFeedback');
    Route::get('user/message/list', 'api/adapter.UserController/messageList');
    Route::put('user/center/update-profile', 'api/adapter.UserController/updateProfile');
    Route::get('news/list', 'api/adapter.ContentController/newsList');
    Route::get('news/:id', 'api/adapter.ContentController/newsDetail');
    Route::post('news/toggle-like', 'api/adapter.ContentController/toggleNewsLike');
    Route::post('news/toggle-favorite', 'api/adapter.ContentController/toggleNewsFavorite');
    Route::get('datasheet/list', 'api/adapter.ContentController/datasheetList');
    Route::get('cooperate-brand/list', 'api/adapter.ContentController/cooperateBrands');
    Route::post('partner/apply', 'api/adapter.ContentController/partnerApply');
    Route::post('inquiry/submit', 'api/adapter.ContentController/submitInquiry');
    Route::get('inquiry/list', 'api/adapter.ContentController/inquiryList');
})->middleware(\app\http\middleware\AllowOriginMiddleware::class);

/**
 * 管理后台适配器路由
 */
Route::group('admin/adapter', function () {
    Route::post('auth/login', 'adminapi/adapter.AdminController/login');
    Route::get('dashboard', 'adminapi/adapter.AdminController/dashboard');
    Route::get('brand/list', 'adminapi/adapter.AdminController/brandList');
    Route::post('brand/add', 'adminapi/adapter.AdminController/brandAdd');
    Route::put('brand/update', 'adminapi/adapter.AdminController/brandUpdate');
    Route::get('brand/delete/:id', 'adminapi/adapter.AdminController/brandDelete');
    Route::get('category/list', 'adminapi/adapter.AdminController/categoryList');
    Route::post('category/add', 'adminapi/adapter.AdminController/categoryAdd');
    Route::put('category/update', 'adminapi/adapter.AdminController/categoryUpdate');
    Route::delete('category/delete', 'adminapi/adapter.AdminController/categoryDelete');
    Route::get('news/list', 'adminapi/adapter.AdminController/newsList');
    Route::post('news/add', 'adminapi/adapter.AdminController/newsAdd');
    Route::put('news/update', 'adminapi/adapter.AdminController/newsUpdate');
    Route::delete('news/delete', 'adminapi/adapter.AdminController/newsDelete');
    Route::post('product/page', 'adminapi/adapter.AdminController/productPage');
    Route::post('product/add', 'adminapi/adapter.AdminController/productAdd');
    Route::put('product/update', 'adminapi/adapter.AdminController/productUpdate');
    Route::delete('product/delete', 'adminapi/adapter.AdminController/productDelete');
    Route::get('order/page', 'adminapi/adapter.AdminController/orderPage');
    Route::post('order/audit', 'adminapi/adapter.AdminController/orderAudit');
    Route::post('order/ship', 'adminapi/adapter.AdminController/orderShip');
    Route::get('user/list', 'adminapi/adapter.AdminController/userList');
    Route::get('inquiry/page', 'adminapi/adapter.AdminController/inquiryPage');
    Route::post('inquiry/reply', 'adminapi/adapter.AdminController/inquiryReply');
    Route::get('partner/list', 'adminapi/adapter.AdminController/partnerList');
    Route::get('feedback/list', 'adminapi/adapter.AdminController/feedbackList');
    Route::get('finance/data', 'adminapi/adapter.AdminController/financeData');
    Route::get('setting/list', 'adminapi/adapter.AdminController/settingList');
    Route::post('setting/save', 'adminapi/adapter.AdminController/settingSave');
    Route::post('upload', 'adminapi/adapter.AdminController/upload');
    Route::get('bom/list', 'adminapi/adapter.AdminController/bomList');
    Route::delete('bom/delete', 'adminapi/adapter.AdminController/bomDelete');
    Route::get('cooperate/list', 'adminapi/adapter.AdminController/cooperateList');
    Route::post('cooperate/add', 'adminapi/adapter.AdminController/cooperateAdd');
    Route::put('cooperate/update', 'adminapi/adapter.AdminController/cooperateUpdate');
    Route::delete('cooperate/delete', 'adminapi/adapter.AdminController/cooperateDelete');
    Route::get('datasheet/list', 'adminapi/adapter.AdminController/datasheetList');
    Route::delete('datasheet/delete', 'adminapi/adapter.AdminController/datasheetDelete');
    Route::get('message/list', 'adminapi/adapter.AdminController/messageList');
    Route::post('message/send', 'adminapi/adapter.AdminController/messageSend');
})->middleware(\app\http\middleware\AllowOriginMiddleware::class);

Route::miss(function () {
    $appRequest = request()->pathinfo();
    if ($appRequest === null) {
        $appName = '';
    } else {
        $appRequest = str_replace('//', '/', $appRequest);
        $appName = explode('/', $appRequest)[0] ?? '';
    }

    switch (strtolower($appName)) {
        case config('app.admin_prefix', 'admin'):
        case 'kefu':
        case 'app':
            return view(app()->getRootPath() . 'public' . DS . config('app.admin_prefix', 'admin') . DS . 'index.html');
        case 'home':
            if (request()->isMobile()) {
                return redirect(app()->route->buildUrl('/'));
            } else {
                return view(app()->getRootPath() . 'public' . DS . 'home' . DS . 'index.html');
            }
        case 'pages':
            return view(app()->getRootPath() . 'public' . DS . 'index.html');
        default:
            if (!request()->isMobile()) {
                if (is_dir(app()->getRootPath() . 'public' . DS . 'home') && !request()->get('mdType')) {
                    return view(app()->getRootPath() . 'public' . DS . 'home' . DS . 'index.html');
                } else {
                    if (request()->get('type')) {
                        return view(app()->getRootPath() . 'public' . DS . 'index.html');
                    } else {
                        return view(app()->getRootPath() . 'public' . DS . 'mobile.html', ['siteName' => sys_config('site_name'), 'siteUrl' => sys_config('site_url') . '/pages/index/index']);
                    }
                }
            } else {
                return view(app()->getRootPath() . 'public' . DS . 'index.html');
            }
    }
});