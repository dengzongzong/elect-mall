<?php
/**
 * PHP内置服务器路由脚本
 * 拦截适配器API请求，绕过CRMEB框架
 */
$uri = $_SERVER['REQUEST_URI'];
$path = parse_url($uri, PHP_URL_PATH);

// 拦截处理适配器API请求
if (strpos($path, '/admin/adapter/') === 0) {
    require __DIR__ . '/adapter.php';
    return true;
}

if (strpos($path, '/api/adapter/') === 0) {
    require __DIR__ . '/adapter.php';
    return true;
}

// 其他请求由CRMEB正常处理
return false;