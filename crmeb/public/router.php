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

// 直接拦截 /api/category/ 路由
if (strpos($path, '/api/category/') === 0) {
    $_SERVER['REQUEST_URI'] = str_replace('/api/', '/api/adapter/', $_SERVER['REQUEST_URI']);
    require __DIR__ . '/adapter.php';
    return true;
}

// 拦截根路径，跳转到商城前端
if ($path === '/' || $path === '') {
    header('Location: http://localhost:8080');
    exit;
}

// 拦截CRMEB前端页面路径（pages/*），返回404提示
if (strpos($path, '/pages/') === 0) {
    http_response_code(404);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode(['code' => 404, 'msg' => '前端页面请通过 http://localhost:8080 访问', 'data' => null, 'success' => false], JSON_UNESCAPED_UNICODE);
    exit;
}

// 其他请求由CRMEB正常处理
return false;