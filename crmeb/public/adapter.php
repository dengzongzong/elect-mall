<?php
/**
 * 适配器API入口
 * 用于处理管理后台API请求，绕过CRMEB的路由系统
 * 直接访问 mall_db 数据库，返回 Result<T> 格式
 */

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, token');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// 解析请求路径 - 支持 /admin/adapter/ 和 /api/adapter/
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$path = preg_replace('#^/(admin|api)/adapter/#', '', $path);
$path = trim($path, '/');
$method = $_SERVER['REQUEST_METHOD'];

// 数据库连接
function getDB() {
    static $db = null;
    if ($db === null) {
        try {
            $db = new PDO('mysql:host=127.0.0.1;dbname=mall_db;charset=utf8mb4', 'root', '123456');
            $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (Exception $e) {
            jsonResponse(500, '数据库连接失败');
            exit;
        }
    }
    return $db;
}

// 递归把超过 JS Number.MAX_SAFE_INTEGER(9007199254740991) 的整数转为字符串。
// 雪花ID为19位，若以 number 输出，前端 JSON.parse 后精度丢失，会导致
// id 碰撞、详情接口查不到数据等问题（新闻/商品列表均因此出现过「不存在」）。
function castBigIntToString($value) {
    if (is_array($value)) {
        return array_map('castBigIntToString', $value);
    }
    if (is_int($value) && abs($value) > 9007199254740991) {
        return (string)$value;
    }
    return $value;
}

function jsonResponse($code = 200, $msg = 'success', $data = null, $success = true) {
    $result = ['code' => $code, 'msg' => $msg, 'data' => castBigIntToString($data), 'success' => $success];
    if ($data === null && $code === 200) {
        unset($result['data']);
    }
    echo json_encode($result, JSON_UNESCAPED_UNICODE);
    exit;
}

function error($msg = '请求失败', $code = 500) {
    jsonResponse($code, $msg, null, false);
}

function success($data = null, $msg = '操作成功') {
    jsonResponse(200, $msg, $data);
}

function getInput() {
    $raw = file_get_contents('php://input');
    if ($raw) {
        return json_decode($raw, true) ?: [];
    }
    return [];
}

function getQuery() {
    return $_GET;
}

// 批量取订单明细，返回 [order_id => [item, ...]]
function getOrderItemsMap($db, $orderIds) {
    $orderIds = array_values(array_filter((array)$orderIds));
    if (empty($orderIds)) return [];
    $ph = implode(',', array_fill(0, count($orderIds), '?'));
    $stmt = $db->prepare("SELECT * FROM order_item WHERE order_id IN ($ph) ORDER BY id ASC");
    $stmt->execute($orderIds);
    $map = [];
    foreach ($stmt->fetchAll(PDO::FETCH_ASSOC) as $row) {
        $map[$row['order_id']][] = $row;
    }
    return $map;
}

// 添加token解析
function getTokenFromRequest() {
    $token = $_SERVER['HTTP_TOKEN'] ?? $_SERVER['HTTP_AUTHORIZATION'] ?? '';
    $token = str_replace('Bearer ', '', $token);
    return $token;
}

// 由于JWT库依赖问题，使用简单的token验证
function checkLogin() {
    $token = getTokenFromRequest();
    if (empty($token)) {
        error('未登录，请先登录', 401);
        return null;
    }
    // 从token中提取用户信息 (格式: admin_id_timestamp_hash)
    $parts = explode('_', $token);
    $adminId = $parts[0] ?? 0;
    if ($adminId <= 0) {
        error('token无效', 401);
        return null;
    }
    $db = getDB();
    $stmt = $db->prepare("SELECT id, username, nickname FROM admin_user WHERE id = ? AND status = 1");
    $stmt->execute([$adminId]);
    $admin = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$admin) {
        error('用户不存在或已禁用', 401);
        return null;
    }
    return $admin;
}

// 路由分发
$route = $path;
$action = '';

// 匹配路由: method path -> handler
$routes = [
    'POST auth/login' => function() {
        $data = getInput();
        $username = $data['username'] ?? '';
        $password = $data['password'] ?? '';
        if (empty($username) || empty($password)) error('用户名或密码不能为空');

        $db = getDB();
        $stmt = $db->prepare("SELECT id, username, nickname, password, status FROM admin_user WHERE username = ?");
        $stmt->execute([$username]);
        $admin = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$admin || !password_verify($password, $admin['password'])) {
            error('用户名或密码错误');
        }
        if ($admin['status'] != 1) error('账号已被禁用');

        // 生成简单token: admin_id_timestamp_hash
        $token = $admin['id'] . '_' . time() . '_' . md5($admin['id'] . $admin['password'] . time());

        success([
            'token' => $token,
            'admin' => ['id' => $admin['id'], 'username' => $admin['username'], 'nickname' => $admin['nickname']]
        ], '登录成功');
    },
    'GET dashboard' => function() {
        checkLogin();
        $db = getDB();
        $tables = ['product' => '商品', 'brand' => '品牌', 'category' => '分类', 'news' => '新闻', 'order' => '订单', 'user' => '用户'];
        $counts = [];
        foreach ($tables as $table => $label) {
            try {
                $stmt = $db->query("SELECT COUNT(*) as cnt FROM `$table`");
                $counts[$table] = (int)$stmt->fetch(PDO::FETCH_ASSOC)['cnt'];
            } catch (Exception $e) { $counts[$table] = 0; }
        }
        success([
            'productCount' => $counts['product'] ?? 0,
            'brandCount' => $counts['brand'] ?? 0,
            'categoryCount' => $counts['category'] ?? 0,
            'newsCount' => $counts['news'] ?? 0,
            'orderCount' => $counts['order'] ?? 0,
            'userCount' => $counts['user'] ?? 0,
            'totalProducts' => $counts['product'] ?? 0,
            'totalOrders' => $counts['order'] ?? 0,
            'totalUsers' => $counts['user'] ?? 0,
            'totalRevenue' => 0,
        ]);
    },
    'GET brand/list' => function() {
        checkLogin();
        $db = getDB();
        $stmt = $db->query("SELECT * FROM brand WHERE deleted = 0 ORDER BY sort ASC");
        success($stmt->fetchAll(PDO::FETCH_ASSOC));
    },
    'POST brand/add' => function() {
        checkLogin(); $data = getInput();
        $name = $data['name'] ?? ''; if (empty($name)) error('品牌名称不能为空');
        $db = getDB();
        $stmt = $db->prepare("INSERT INTO brand (name, logo, description, sort, status, is_cooperate, deleted, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, 0, NOW(), NOW())");
        $stmt->execute([$name, $data['logo'] ?? '', $data['description'] ?? '', $data['sort'] ?? 0, $data['status'] ?? 1, $data['isCooperate'] ?? $data['is_cooperate'] ?? 0]);
        success(['id' => $db->lastInsertId()], '保存成功');
    },
    'PUT brand/update' => function() {
        checkLogin(); $data = getInput();
        $id = $data['id'] ?? 0; if (!$id) error('参数错误');
        $db = getDB();
        $stmt = $db->prepare("UPDATE brand SET name=?, logo=?, description=?, sort=?, status=?, is_cooperate=?, updated_at=NOW() WHERE id=?");
        $stmt->execute([$data['name'] ?? '', $data['logo'] ?? '', $data['description'] ?? '', $data['sort'] ?? 0, $data['status'] ?? 1, $data['isCooperate'] ?? $data['is_cooperate'] ?? 0, $id]);
        success(null, '保存成功');
    },
    'GET brand/delete/{id}' => function($id) {
        checkLogin(); $db = getDB();
        $stmt = $db->prepare("UPDATE brand SET deleted = 1 WHERE id = ?");
        $stmt->execute([$id]);
        success(null, '删除成功');
    },
    'DELETE brand/delete' => function() {
        checkLogin(); $data = getInput();
        $id = $data['id'] ?? 0;
        if (!$id) error('参数错误');
        $db = getDB();
        $db->prepare("UPDATE brand SET deleted = 1 WHERE id = ?")->execute([$id]);
        success(null, '删除成功');
    },
    'GET category/list' => function() {
        checkLogin();
        $db = getDB();
        $stmt = $db->query("SELECT * FROM category ORDER BY parent_id ASC, sort ASC");
        $all = $stmt->fetchAll(PDO::FETCH_ASSOC);
        // 将id和parent_id转为字符串，防止JavaScript精度丢失（ID超过Number.MAX_SAFE_INTEGER）
        foreach ($all as &$item) {
            $item['id'] = (string)$item['id'];
            $item['parent_id'] = (string)$item['parent_id'];
            $item['children'] = [];
        }
        unset($item);
        $map = [];
        $tree = [];
        foreach ($all as &$item) {
            $map[$item['id']] = &$item;
        }
        unset($item);
        foreach ($map as $id => &$item) {
            if ($item['parent_id'] !== '0' && isset($map[$item['parent_id']])) {
                $map[$item['parent_id']]['children'][] = &$item;
            } else {
                $tree[] = &$item;
            }
        }
        unset($item);
        success($tree);
    },
    'POST category/add' => function() {
        checkLogin(); $data = getInput();
        $name = $data['name'] ?? ''; if (empty($name)) error('分类名称不能为空');
        $db = getDB();
        $stmt = $db->prepare("INSERT INTO category (name, description, parent_id, prefix, sort, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, NOW(), NOW())");
        $stmt->execute([$name, $data['description'] ?? '', $data['parentId'] ?? $data['parent_id'] ?? 0, $data['prefix'] ?? '', $data['sort'] ?? 0, $data['status'] ?? 1]);
        success(['id' => $db->lastInsertId()], '保存成功');
    },
    'PUT category/update' => function() {
        checkLogin(); $data = getInput();
        $id = $data['id'] ?? 0; if (!$id) error('参数错误');
        $db = getDB();
        // 只更新请求中显式传入的字段。
        // 之前是全字段覆盖，若调用方漏传 parentId（如后台「编辑详情」只提交 id/name/description），
        // parent_id 会被写成 0，导致子分类被挂到最顶层。
        $fieldMap = [
            'name' => 'name',
            'description' => 'description',
            'parentId' => 'parent_id',
            'parent_id' => 'parent_id',
            'prefix' => 'prefix',
            'sort' => 'sort',
            'status' => 'status',
        ];
        $columns = [];
        $params = [];
        foreach ($fieldMap as $key => $column) {
            if (!array_key_exists($key, $data)) continue;
            if (in_array($column, $columns, true)) continue;
            $columns[] = $column;
            $params[] = $data[$key];
        }
        if (!$columns) error('没有需要更新的字段');
        // 列名来自上面的白名单常量，不含用户输入，可安全拼接
        $sql = 'UPDATE category SET ' . implode(' = ?, ', $columns) . ' = ?, updated_at = NOW() WHERE id = ?';
        $params[] = $id;
        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        success(null, '保存成功');
    },
    'DELETE category/delete' => function() {
        checkLogin(); $data = getInput();
        $id = $data['id'] ?? 0; if (!$id) error('参数错误');
        $db = getDB();
        // 递归删除子分类
        $stmt = $db->prepare("SELECT id FROM category WHERE parent_id = ?");
        $delStmt = $db->prepare("DELETE FROM category WHERE id = ?");
        $idsToDelete = [$id];
        $queue = [$id];
        while ($queue) {
            $pid = array_shift($queue);
            $stmt->execute([$pid]);
            $children = $stmt->fetchAll(PDO::FETCH_COLUMN);
            foreach ($children as $cid) {
                $idsToDelete[] = $cid;
                $queue[] = $cid;
            }
        }
        // 从叶子节点开始删除（逆序避免外键约束）
        $idsToDelete = array_reverse($idsToDelete);
        foreach ($idsToDelete as $did) {
            $delStmt->execute([$did]);
        }
        success(null, '删除成功，共删除 ' . count($idsToDelete) . ' 条');
    },
    // 分类详情公开API
    'GET category/detail/{id}' => function($id) {
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM category WHERE id = ?");
        $stmt->execute([$id]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        if (!$row) error('分类不存在', 404);
        if ($row) {
            $row['id'] = (string)$row['id'];
            $row['parent_id'] = (string)$row['parent_id'];
        }
        success($row);
    },
    'GET news/list' => function() {
        checkLogin();
        $db = getDB();
        $stmt = $db->query("SELECT * FROM news ORDER BY id DESC");
        success($stmt->fetchAll(PDO::FETCH_ASSOC));
    },
    'POST news/add' => function() {
        checkLogin(); $data = getInput();
        $title = $data['title'] ?? ''; if (empty($title)) error('新闻标题不能为空');
        $db = getDB();
        $stmt = $db->prepare("INSERT INTO news (title, content, image, status, created_at, updated_at) VALUES (?, ?, ?, ?, NOW(), NOW())");
        $stmt->execute([$title, $data['content'] ?? '', $data['image'] ?? '', $data['status'] ?? 1]);
        success(['id' => $db->lastInsertId()], '保存成功');
    },
    'PUT news/update' => function() {
        checkLogin(); $data = getInput();
        $id = $data['id'] ?? 0; if (!$id) error('参数错误');
        $db = getDB();
        $stmt = $db->prepare("UPDATE news SET title=?, content=?, image=?, status=? WHERE id=?");
        $stmt->execute([$data['title'] ?? '', $data['content'] ?? '', $data['image'] ?? '', $data['status'] ?? 1, $id]);
        success(null, '保存成功');
    },
    'DELETE news/delete' => function() {
        checkLogin(); $data = getInput();
        $id = $data['id'] ?? 0; if (!$id) error('参数错误');
        $db = getDB();
        $db->prepare("DELETE FROM news WHERE id = ?")->execute([$id]);
        success(null, '删除成功');
    },
    'POST product/page' => function() {
        checkLogin(); $data = getInput();
        $page = (int)($data['page'] ?? 1); $size = (int)($data['size'] ?? 20); $offset = ($page - 1) * $size;
        $db = getDB();
        $total = (int)$db->query("SELECT COUNT(*) as total FROM product")->fetch(PDO::FETCH_ASSOC)['total'];
        $stmt = $db->prepare("SELECT p.*, c.name as category_name FROM product p LEFT JOIN category c ON p.category_id = c.id ORDER BY p.id DESC LIMIT ? OFFSET ?");
        $stmt->bindValue(1, $size, PDO::PARAM_INT);
        $stmt->bindValue(2, $offset, PDO::PARAM_INT);
        $stmt->execute();
        success(['records' => $stmt->fetchAll(PDO::FETCH_ASSOC), 'total' => $total, 'page' => $page, 'size' => $size, 'pages' => ceil($total / $size)]);
    },
    'POST product/add' => function() {
        checkLogin(); $data = getInput();
        $name = $data['name'] ?? ''; if (empty($name)) error('商品名称不能为空');
        $db = getDB();
        $stmt = $db->prepare("INSERT INTO product (name, category_id, part_no, price, stock, description, image_url, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())");
        $stmt->execute([$name, $data['categoryId'] ?? $data['category_id'] ?? null, $data['partNo'] ?? $data['part_no'] ?? '', $data['price'] ?? 0, $data['stock'] ?? 0, $data['description'] ?? '', $data['image'] ?? '', $data['status'] ?? 1]);
        success(['id' => $db->lastInsertId()], '保存成功');
    },
    'PUT product/update' => function() {
        checkLogin(); $data = getInput();
        $id = $data['id'] ?? 0; if (!$id) error('参数错误');
        $db = getDB();
        $stmt = $db->prepare("UPDATE product SET name=?, category_id=?, part_no=?, price=?, stock=?, description=?, image_url=?, status=?, updated_at=NOW() WHERE id=?");
        $stmt->execute([$data['name'] ?? '', $data['categoryId'] ?? $data['category_id'] ?? null, $data['partNo'] ?? $data['part_no'] ?? '', $data['price'] ?? 0, $data['stock'] ?? 0, $data['description'] ?? '', $data['image'] ?? '', $data['status'] ?? 1, $id]);
        success(null, '保存成功');
    },
    'DELETE product/delete' => function() {
        checkLogin(); $data = getInput();
        $id = $data['id'] ?? 0; if (!$id) error('参数错误');
        $db = getDB();
        $db->prepare("DELETE FROM product WHERE id = ?")->execute([$id]);
        success(null, '删除成功');
    },
    'GET order/page' => function() {
        checkLogin(); $params = getQuery();
        $page = (int)($params['page'] ?? 1); $size = (int)($params['size'] ?? 20); $offset = ($page - 1) * $size;
        $db = getDB();
        $total = (int)$db->query("SELECT COUNT(*) as total FROM `order`")->fetch(PDO::FETCH_ASSOC)['total'];
        $stmt = $db->prepare("SELECT * FROM `order` ORDER BY id DESC LIMIT ? OFFSET ?");
        $stmt->bindValue(1, $size, PDO::PARAM_INT); $stmt->bindValue(2, $offset, PDO::PARAM_INT); $stmt->execute();
        success(['records' => $stmt->fetchAll(PDO::FETCH_ASSOC), 'total' => $total, 'page' => $page, 'size' => $size, 'pages' => ceil($total / $size)]);
    },
    'POST order/audit' => function() {
        checkLogin(); $data = getInput();
        $db = getDB();
        $db->prepare("UPDATE `order` SET status='audited' WHERE id=?")->execute([$data['id'] ?? 0]);
        success(null, '审核成功');
    },
    'POST order/ship' => function() {
        checkLogin(); $data = getInput();
        $db = getDB();
        $db->prepare("UPDATE `order` SET status='shipped' WHERE id=?")->execute([$data['id'] ?? 0]);
        success(null, '发货成功');
    },
    'GET user/list' => function() {
        checkLogin(); $params = getQuery();
        $page = (int)($params['page'] ?? 1); $size = (int)($params['size'] ?? 20); $offset = ($page - 1) * $size;
        $db = getDB();
        $total = (int)$db->query("SELECT COUNT(*) as total FROM user")->fetch(PDO::FETCH_ASSOC)['total'];
        $stmt = $db->prepare("SELECT * FROM user ORDER BY id DESC LIMIT ? OFFSET ?");
        $stmt->bindValue(1, $size, PDO::PARAM_INT); $stmt->bindValue(2, $offset, PDO::PARAM_INT); $stmt->execute();
        success(['records' => $stmt->fetchAll(PDO::FETCH_ASSOC), 'total' => $total, 'page' => $page, 'size' => $size, 'pages' => ceil($total / $size)]);
    },
    'GET inquiry/page' => function() {
        checkLogin(); $params = getQuery();
        $page = (int)($params['page'] ?? 1); $size = (int)($params['size'] ?? 20); $offset = ($page - 1) * $size;
        $db = getDB();
        $total = (int)$db->query("SELECT COUNT(*) as total FROM inquiry")->fetch(PDO::FETCH_ASSOC)['total'];
        $stmt = $db->prepare("SELECT * FROM inquiry ORDER BY id DESC LIMIT ? OFFSET ?");
        $stmt->bindValue(1, $size, PDO::PARAM_INT); $stmt->bindValue(2, $offset, PDO::PARAM_INT); $stmt->execute();
        success(['records' => $stmt->fetchAll(PDO::FETCH_ASSOC), 'total' => $total, 'page' => $page, 'size' => $size, 'pages' => ceil($total / $size)]);
    },
    'POST inquiry/reply' => function() {
        checkLogin(); $data = getInput();
        $db = getDB();
        $db->prepare("UPDATE inquiry SET reply=?, status='replied' WHERE id=?")->execute([$data['reply'] ?? '', $data['id'] ?? 0]);
        success(null, '回复成功');
    },
    'GET partner/list' => function() {
        checkLogin();
        $db = getDB();
        success($db->query("SELECT * FROM partner_apply ORDER BY id DESC")->fetchAll(PDO::FETCH_ASSOC));
    },
    'GET feedback/list' => function() {
        checkLogin();
        $db = getDB();
        success($db->query("SELECT * FROM feedback ORDER BY id DESC")->fetchAll(PDO::FETCH_ASSOC));
    },
    'GET finance/data' => function() {
        checkLogin();
        success(['totalRevenue' => 0, 'totalOrders' => 0, 'avgOrderValue' => 0, 'dailyData' => []]);
    },
    'GET setting/list' => function() {
        checkLogin();
        $db = getDB();
        $data = $db->query("SELECT * FROM sys_config")->fetchAll(PDO::FETCH_ASSOC);
        $settings = [];
        foreach ($data as $row) { $settings[$row['config_key'] ?? $row['key']] = $row['config_value'] ?? $row['value']; }
        success($settings);
    },
    'POST setting/save' => function() {
        checkLogin(); $data = getInput();
        $db = getDB();
        foreach ($data as $key => $value) {
            if ($key === 'id') continue;
            $stmt = $db->prepare("INSERT INTO sys_config (config_key, config_value, created_at, updated_at) VALUES (?, ?, NOW(), NOW()) ON DUPLICATE KEY UPDATE config_value = ?, updated_at = NOW()");
            $stmt->execute([$key, $value, $value]);
        }
        success(null, '保存成功');
    },
    'POST upload' => function() {
        checkLogin();
        if (!isset($_FILES['file'])) error('请选择文件');
        $file = $_FILES['file'];
        $uploadDir = __DIR__ . '/uploads/';
        if (!is_dir($uploadDir)) mkdir($uploadDir, 0755, true);
        $filename = uniqid() . '_' . basename($file['name']);
        if (move_uploaded_file($file['tmp_name'], $uploadDir . $filename)) {
            success(['url' => '/uploads/' . $filename], '上传成功');
        }
        error('上传失败');
    },
    'GET bom/list' => function() {
        checkLogin(); $params = getQuery();
        $page = (int)($params['page'] ?? 1); $size = (int)($params['size'] ?? 20); $offset = ($page - 1) * $size;
        $db = getDB();
        $total = (int)$db->query("SELECT COUNT(*) as total FROM bom_record")->fetch(PDO::FETCH_ASSOC)['total'];
        $stmt = $db->prepare("SELECT * FROM bom_record ORDER BY id DESC LIMIT ? OFFSET ?");
        $stmt->bindValue(1, $size, PDO::PARAM_INT); $stmt->bindValue(2, $offset, PDO::PARAM_INT); $stmt->execute();
        success(['records' => $stmt->fetchAll(PDO::FETCH_ASSOC), 'total' => $total, 'page' => $page, 'size' => $size, 'pages' => ceil($total / $size)]);
    },
    'DELETE bom/delete' => function() {
        $data = getInput();
        $id = $data['id'] ?? 0; if (!$id) error('参数错误');
        $db = getDB();
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = (int)($parts[0] ?? 0);
        // 用户端：校验归属后删除
        $stmt = $db->prepare("SELECT id FROM user WHERE id = ?");
        $stmt->execute([$userId]);
        if ($stmt->fetch(PDO::FETCH_ASSOC)) {
            $db->prepare("DELETE FROM bom_record WHERE id = ? AND user_id = ?")->execute([$id, $userId]);
            $db->prepare("DELETE FROM bom_item WHERE bom_id = ?")->execute([$id]);
            success(null, '删除成功');
        }
        // 管理员兜底
        checkLogin();
        $db->prepare("DELETE FROM bom_record WHERE id = ?")->execute([$id]);
        $db->prepare("DELETE FROM bom_item WHERE bom_id = ?")->execute([$id]);
        success(null, '删除成功');
    },
    // 用户端 BOM 提交：解析料号并匹配 product 表
    'POST bom/submit' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        if ($userId <= 0) error('未登录', 401);
        $data = getInput();
        $db = getDB();
        // 支持 items 数组 或 逗号分隔的 partNo/quantity
        $items = $data['items'] ?? [];
        if (empty($items) && !empty($data['partNo'])) {
            $pnArr = array_map('trim', explode(',', (string)$data['partNo']));
            $qtyStr = trim((string)($data['quantity'] ?? ''));
            $qtyArr = $qtyStr ? array_map('trim', explode(',', $qtyStr)) : [];
            $items = [];
            foreach ($pnArr as $i => $pn) {
                if ($pn === '') continue;
                $items[] = ['partNo' => $pn, 'quantity' => $qtyArr[$i] ?? 1];
            }
        }
        if (empty($items)) error('请输入至少一个料号');
        $totalCount = 0; $matchCount = 0; $totalAmount = 0; $parsed = [];
        foreach ($items as $it) {
            $pn = trim((string)($it['partNo'] ?? ''));
            if ($pn === '') continue;
            $qty = max(1, (int)($it['quantity'] ?? 1));
            $totalCount++;
            $stmt = $db->prepare("SELECT id, name, price FROM product WHERE part_no = ? AND (deleted = 0 OR deleted IS NULL)");
            $stmt->execute([$pn]);
            $prod = $stmt->fetch(PDO::FETCH_ASSOC);
            if ($prod) {
                $matchCount++;
                $subtotal = round((float)$prod['price'] * $qty, 4);
                $totalAmount += $subtotal;
                $parsed[] = ['partNo' => $pn, 'quantity' => $qty, 'match_status' => 'matched', 'product_id' => $prod['id'], 'price' => $prod['price'], 'subtotal' => $subtotal, 'name' => $prod['name']];
            } else {
                $parsed[] = ['partNo' => $pn, 'quantity' => $qty, 'match_status' => 'unmatched', 'product_id' => 0, 'price' => 0, 'subtotal' => 0, 'name' => ''];
            }
        }
        $db->prepare("INSERT INTO bom_record (user_id, match_count, total_count, total_amount, status, created_at, updated_at) VALUES (?, ?, ?, ?, 'pending', NOW(), NOW())")
            ->execute([$userId, $matchCount, $totalCount, $totalAmount]);
        $bomId = $db->lastInsertId();
        foreach ($parsed as $p) {
            $db->prepare("INSERT INTO bom_item (bom_id, part_no, quantity, match_status, product_id, price, subtotal, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), NOW())")
                ->execute([$bomId, $p['partNo'], $p['quantity'], $p['match_status'], $p['product_id'], $p['price'], $p['subtotal']]);
        }
        success(['id' => $bomId, 'matchCount' => $matchCount, 'totalCount' => $totalCount, 'totalAmount' => $totalAmount, 'items' => $parsed], 'BOM已提交');
    },
    'GET bom/user/list' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        if ($userId <= 0) error('未登录', 401);
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM bom_record WHERE user_id = ? ORDER BY id DESC");
        $stmt->execute([$userId]);
        $records = $stmt->fetchAll(PDO::FETCH_ASSOC);
        if ($records) {
            $ids = array_column($records, 'id');
            $ph = implode(',', array_fill(0, count($ids), '?'));
            $stmt2 = $db->prepare("SELECT * FROM bom_item WHERE bom_id IN ($ph) ORDER BY id ASC");
            $stmt2->execute($ids);
            $map = [];
            foreach ($stmt2->fetchAll(PDO::FETCH_ASSOC) as $row) { $map[$row['bom_id']][] = $row; }
            foreach ($records as &$r) { $r['items'] = $map[$r['id']] ?? []; }
            unset($r);
        }
        success($records);
    },
    'GET cooperate/list' => function() {
        checkLogin();
        $db = getDB();
        success($db->query("SELECT * FROM cooperate_brand ORDER BY sort ASC")->fetchAll(PDO::FETCH_ASSOC));
    },
    'POST cooperate/add' => function() {
        checkLogin(); $data = getInput();
        $db = getDB();
        $stmt = $db->prepare("INSERT INTO cooperate_brand (name, logo, description, url, sort, status) VALUES (?, ?, ?, ?, ?, ?)");
        $stmt->execute([$data['name'] ?? '', $data['logo'] ?? '', $data['description'] ?? '', $data['url'] ?? '', $data['sort'] ?? 0, $data['status'] ?? 1]);
        success(['id' => $db->lastInsertId()], '保存成功');
    },
    'PUT cooperate/update' => function() {
        checkLogin(); $data = getInput();
        $id = $data['id'] ?? 0; if (!$id) error('参数错误');
        $db = getDB();
        $stmt = $db->prepare("UPDATE cooperate_brand SET name=?, logo=?, description=?, url=?, sort=?, status=? WHERE id=?");
        $stmt->execute([$data['name'] ?? '', $data['logo'] ?? '', $data['description'] ?? '', $data['url'] ?? '', $data['sort'] ?? 0, $data['status'] ?? 1, $id]);
        success(null, '保存成功');
    },
    'DELETE cooperate/delete' => function() {
        checkLogin(); $data = getInput();
        $id = $data['id'] ?? 0; if (!$id) error('参数错误');
        $db = getDB();
        $db->prepare("DELETE FROM cooperate_brand WHERE id = ?")->execute([$id]);
        success(null, '删除成功');
    },
    'GET datasheet/list' => function() {
        checkLogin(); $params = getQuery();
        $page = (int)($params['page'] ?? 1); $size = (int)($params['size'] ?? 20); $offset = ($page - 1) * $size;
        $db = getDB();
        $total = (int)$db->query("SELECT COUNT(*) as total FROM datasheet")->fetch(PDO::FETCH_ASSOC)['total'];
        $stmt = $db->prepare("SELECT * FROM datasheet ORDER BY id DESC LIMIT ? OFFSET ?");
        $stmt->bindValue(1, $size, PDO::PARAM_INT); $stmt->bindValue(2, $offset, PDO::PARAM_INT); $stmt->execute();
        success(['records' => $stmt->fetchAll(PDO::FETCH_ASSOC), 'total' => $total, 'page' => $page, 'size' => $size, 'pages' => ceil($total / $size)]);
    },
    'DELETE datasheet/delete' => function() {
        checkLogin(); $data = getInput();
        $id = $data['id'] ?? 0; if (!$id) error('参数错误');
        $db = getDB();
        $db->prepare("DELETE FROM datasheet WHERE id = ?")->execute([$id]);
        success(null, '删除成功');
    },
    'GET message/list' => function() {
        checkLogin(); $params = getQuery();
        $page = (int)($params['page'] ?? 1); $size = (int)($params['size'] ?? 20); $offset = ($page - 1) * $size;
        $db = getDB();
        $total = (int)$db->query("SELECT COUNT(*) as total FROM message")->fetch(PDO::FETCH_ASSOC)['total'];
        $stmt = $db->prepare("SELECT * FROM message ORDER BY id DESC LIMIT ? OFFSET ?");
        $stmt->bindValue(1, $size, PDO::PARAM_INT); $stmt->bindValue(2, $offset, PDO::PARAM_INT); $stmt->execute();
        success(['records' => $stmt->fetchAll(PDO::FETCH_ASSOC), 'total' => $total, 'page' => $page, 'size' => $size, 'pages' => ceil($total / $size)]);
    },
    'POST message/send' => function() {
        checkLogin(); $data = getInput();
        $db = getDB();
        $stmt = $db->prepare("INSERT INTO message (title, content, type, user_id, status, created_at) VALUES (?, ?, ?, ?, 0, NOW())");
        $stmt->execute([$data['title'] ?? '', $data['content'] ?? '', $data['type'] ?? 'system', $data['userId'] ?? $data['user_id'] ?? 0]);
        success(null, '发送成功');
    },

    // ====== 商城前端API路由 (mall-web) ======

    // 产品分类
    'GET product/categories' => function() {
        $db = getDB();
        $stmt = $db->query("SELECT * FROM category WHERE deleted = 0 OR deleted IS NULL ORDER BY parent_id ASC, sort ASC");
        $all = $stmt->fetchAll(PDO::FETCH_ASSOC);
        // 构建树形结构
        $map = [];
        $children = [];
        foreach ($all as $item) {
            $map[$item['id']] = $item;
            if (!isset($children[$item['id']])) $children[$item['id']] = [];
            if ($item['parent_id']) {
                if (!isset($children[$item['parent_id']])) $children[$item['parent_id']] = [];
                $children[$item['parent_id']][] = $item['id'];
            }
        }
        // 构建1级->2级品牌分组->3级产品细分
        $tree = [];
        $iconMap = ['Cpu', 'List', 'Connection', 'Monitor', 'Microphone', 'Coin', 'SetUp', 'Tools', 'Edit', 'Search', 'Folder', 'Document', 'Reading', 'DataBoard', 'CollectionTag', 'Aim', 'Bell', 'ChatDotSquare', 'ChromeFilled', 'Cloudy'];
        $iconIdx = 0;
        foreach ($all as $item) {
            if ($item['parent_id'] == 0) {
                $subs = [];
                foreach ($children[$item['id']] ?? [] as $l2id) {
                    $l2 = $map[$l2id];
                    $items = [];
                    foreach ($children[$l2id] ?? [] as $l3id) {
                        $l3 = $map[$l3id];
                        $items[] = ['name' => $l3['name'], 'id' => (string)$l3['id']];
                    }
                    $subs[] = ['name' => $l2['name'], 'id' => (string)$l2['id'], 'items' => $items];
                }
                $tree[] = [
                    // id 为19位雪花ID，超出 JS Number.MAX_SAFE_INTEGER，
                    // 必须以字符串输出，否则前端 JSON.parse 后精度丢失会导致多个分类id碰撞
                    'id' => (string)$item['id'],
                    'name' => $item['name'],
                    'icon' => $iconMap[$iconIdx % count($iconMap)],
                    'subs' => $subs,
                ];
                $iconIdx++;
            }
        }
        success($tree);
    },
    'GET product/categories/tree' => function() {
        $db = getDB();
        $stmt = $db->query("SELECT * FROM category ORDER BY parent_id ASC, sort ASC");
        $all = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $map = [];
        $tree = [];
        foreach ($all as $item) {
            // 同 product/categories：id 以字符串输出，避免 JS 大整数精度丢失
            $item['id'] = (string)$item['id'];
            $item['children'] = [];
            $map[$item['id']] = $item;
        }
        foreach ($map as $id => $item) {
            if ($item['parent_id'] && isset($map[$item['parent_id']])) {
                $map[$item['parent_id']]['children'][] = &$map[$id];
            } else {
                $tree[] = &$map[$id];
            }
        }
        success($tree);
    },
    'GET product/page' => function() {
        $params = getQuery();
        $page = (int)($params['page'] ?? 1); $size = (int)($params['size'] ?? 20); $offset = ($page - 1) * $size;
        $categoryId = $params['categoryId'] ?? $params['category_id'] ?? null;
        $keyword = $params['keyword'] ?? '';
        $db = getDB();
        $where = "WHERE 1=1";
        $bind = [];
        if ($categoryId) { $where .= " AND p.category_id = ?"; $bind[] = $categoryId; }
        if ($keyword) { $where .= " AND (p.name LIKE ? OR p.part_no LIKE ?)"; $bind[] = "%$keyword%"; $bind[] = "%$keyword%"; }
        $total = 0;
        $countStmt = $db->prepare("SELECT COUNT(*) as total FROM product p $where");
        $countStmt->execute($bind);
        $total = (int)$countStmt->fetch(PDO::FETCH_ASSOC)['total'];
        $stmt = $db->prepare("SELECT p.*, c.name as category_name FROM product p LEFT JOIN category c ON p.category_id = c.id $where ORDER BY p.id DESC LIMIT ? OFFSET ?");
        $paramIdx = 1;
        foreach ($bind as $v) { $stmt->bindValue($paramIdx++, $v); }
        $stmt->bindValue($paramIdx++, $size, PDO::PARAM_INT);
        $stmt->bindValue($paramIdx++, $offset, PDO::PARAM_INT);
        $stmt->execute();
        success(['records' => $stmt->fetchAll(PDO::FETCH_ASSOC), 'total' => $total, 'page' => $page, 'size' => $size, 'pages' => ceil($total / $size)]);
    },
    'GET product/recommend' => function() {
        $db = getDB();
        $stmt = $db->query("SELECT p.*, c.name as category_name FROM product p LEFT JOIN category c ON p.category_id = c.id WHERE p.status = 1 ORDER BY p.id DESC LIMIT 12");
        success($stmt->fetchAll(PDO::FETCH_ASSOC));
    },
    'GET product/{id}' => function($id) {
        $db = getDB();
        $stmt = $db->prepare("SELECT p.*, c.name as category_name FROM product p LEFT JOIN category c ON p.category_id = c.id WHERE p.id = ?");
        $stmt->execute([$id]);
        $product = $stmt->fetch(PDO::FETCH_ASSOC);
        if (!$product) error('商品不存在', 404);
        success($product);
    },
    'GET brand/list' => function() {
        $db = getDB();
        $stmt = $db->query("SELECT * FROM brand WHERE deleted = 0 AND status = 1 ORDER BY sort ASC");
        success($stmt->fetchAll(PDO::FETCH_ASSOC));
    },
    'GET brand/{brandId}/products' => function($brandId) {
        $params = getQuery();
        $page = (int)($params['page'] ?? 1); $size = (int)($params['size'] ?? 20); $offset = ($page - 1) * $size;
        $db = getDB();
        $countStmt = $db->prepare("SELECT COUNT(*) as total FROM product WHERE brand_id = ?");
        $countStmt->execute([$brandId]);
        $total = (int)$countStmt->fetch(PDO::FETCH_ASSOC)['total'];
        $stmt = $db->prepare("SELECT p.*, c.name as category_name FROM product p LEFT JOIN category c ON p.category_id = c.id WHERE p.brand_id = ? ORDER BY p.id DESC LIMIT ? OFFSET ?");
        $stmt->bindValue(1, $brandId, PDO::PARAM_INT);
        $stmt->bindValue(2, $size, PDO::PARAM_INT);
        $stmt->bindValue(3, $offset, PDO::PARAM_INT);
        $stmt->execute();
        success(['records' => $stmt->fetchAll(PDO::FETCH_ASSOC), 'total' => $total, 'page' => $page, 'size' => $size, 'pages' => ceil($total / $size)]);
    },

    // 认证
    'POST auth/send-code' => function() {
        $data = getInput();
        success(null, '验证码已发送');
    },
    'POST auth/phone-login' => function() {
        $data = getInput();
        $phone = $data['phone'] ?? '';
        if (empty($phone)) error('手机号不能为空');
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM user WHERE phone = ?");
        $stmt->execute([$phone]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        if (!$user) {
            $stmt = $db->prepare("INSERT INTO user (phone, nickname, created_at, updated_at) VALUES (?, ?, NOW(), NOW())");
            $stmt->execute([$phone, '用户' . substr($phone, -4)]);
            $userId = $db->lastInsertId();
            $user = ['id' => $userId, 'phone' => $phone, 'nickname' => '用户' . substr($phone, -4)];
        }
        $token = $user['id'] . '_' . time() . '_' . md5($user['id'] . time());
        success(['token' => $token, 'user' => $user], '登录成功');
    },
    'POST auth/wechat-login' => function() {
        $data = getInput();
        $code = $data['code'] ?? '';
        if (empty($code)) error('微信授权码不能为空');
        // 模拟微信登录
        $db = getDB();
        $openid = 'wx_' . md5($code);
        $stmt = $db->prepare("SELECT * FROM user WHERE openid = ?");
        $stmt->execute([$openid]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        if (!$user) {
            $stmt = $db->prepare("INSERT INTO user (openid, nickname, created_at, updated_at) VALUES (?, ?, NOW(), NOW())");
            $stmt->execute([$openid, '微信用户']);
            $userId = $db->lastInsertId();
            $user = ['id' => $userId, 'openid' => $openid, 'nickname' => '微信用户'];
        }
        $token = $user['id'] . '_' . time() . '_' . md5($user['id'] . time());
        success(['token' => $token, 'user' => $user], '登录成功');
    },
    'POST auth/bind-phone' => function() {
        $data = getInput();
        $phone = $data['phone'] ?? '';
        $code = $data['code'] ?? '';
        if (empty($phone)) error('手机号不能为空');
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        $db = getDB();
        $stmt = $db->prepare("UPDATE user SET phone = ? WHERE id = ?");
        $stmt->execute([$phone, $userId]);
        success(null, '绑定成功');
    },
    'POST auth/logout' => function() {
        success(null, '退出成功');
    },
    'GET auth/user-info' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        if ($userId <= 0) error('未登录', 401);
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM user WHERE id = ?");
        $stmt->execute([$userId]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        if (!$user) error('用户不存在', 404);
        success($user);
    },

    // 购物车
    'GET cart/list' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        if ($userId <= 0) error('未登录', 401);
        $db = getDB();
        $stmt = $db->prepare("SELECT c.*, p.name, p.price, p.image_url, p.part_no FROM cart c LEFT JOIN product p ON c.product_id = p.id WHERE c.user_id = ? ORDER BY c.id DESC");
        $stmt->execute([$userId]);
        success($stmt->fetchAll(PDO::FETCH_ASSOC));
    },
    'POST cart/add' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        if ($userId <= 0) error('未登录', 401);
        $data = getInput();
        $productId = $data['productId'] ?? $data['product_id'] ?? 0;
        $quantity = $data['quantity'] ?? 1;
        $db = getDB();
        // 检查是否已存在
        $stmt = $db->prepare("SELECT * FROM cart WHERE user_id = ? AND product_id = ?");
        $stmt->execute([$userId, $productId]);
        $existing = $stmt->fetch(PDO::FETCH_ASSOC);
        if ($existing) {
            $stmt = $db->prepare("UPDATE cart SET quantity = quantity + ? WHERE id = ?");
            $stmt->execute([$quantity, $existing['id']]);
        } else {
            $stmt = $db->prepare("INSERT INTO cart (user_id, product_id, quantity, created_at, updated_at) VALUES (?, ?, ?, NOW(), NOW())");
            $stmt->execute([$userId, $productId, $quantity]);
        }
        success(null, '添加成功');
    },
    'PUT cart/update' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        if ($userId <= 0) error('未登录', 401);
        $data = getInput();
        $id = $data['id'] ?? 0; $quantity = $data['quantity'] ?? 1;
        $db = getDB();
        $db->prepare("UPDATE cart SET quantity = ?, updated_at = NOW() WHERE id = ? AND user_id = ?")->execute([$quantity, $id, $userId]);
        success(null, '更新成功');
    },
    'DELETE cart/delete' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        if ($userId <= 0) error('未登录', 401);
        $data = getInput();
        $id = $data['id'] ?? 0;
        $db = getDB();
        $db->prepare("DELETE FROM cart WHERE id = ? AND user_id = ?")->execute([$id, $userId]);
        success(null, '删除成功');
    },
    'DELETE cart/clear' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        if ($userId <= 0) error('未登录', 401);
        $db = getDB();
        $db->prepare("DELETE FROM cart WHERE user_id = ?")->execute([$userId]);
        success(null, '清空成功');
    },

    // 订单
    'POST order/create' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        if ($userId <= 0) error('未登录', 401);
        $data = getInput();
        $db = getDB();

        // 以服务端购物车为准计算商品明细与金额（前端金额不可信）
        $stmt = $db->prepare("SELECT c.product_id, c.quantity, p.name, p.part_no, p.price
                              FROM cart c LEFT JOIN product p ON c.product_id = p.id
                              WHERE c.user_id = ? AND (c.deleted = 0 OR c.deleted IS NULL)");
        $stmt->execute([$userId]);
        $cartItems = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $calcTotal = 0;
        foreach ($cartItems as $ci) {
            $calcTotal += (float)$ci['price'] * (int)$ci['quantity'];
        }
        $total = $calcTotal > 0 ? $calcTotal : ($data['totalAmount'] ?? $data['total_amount'] ?? 0);

        $orderNo = 'ORD' . date('YmdHis') . rand(1000, 9999);
        // order 表收货地址列名为 receiver_address（另含 receiver_name/receiver_phone）
        $stmt = $db->prepare("INSERT INTO `order` (order_no, user_id, total_amount, status, receiver_address, receiver_name, receiver_phone, remark, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())");
        $stmt->execute([
            $orderNo, $userId, $total, 'pending',
            $data['address'] ?? '',
            $data['receiverName'] ?? $data['name'] ?? '',
            $data['receiverPhone'] ?? $data['phone'] ?? '',
            $data['remark'] ?? '',
        ]);
        $orderId = $db->lastInsertId();

        // 写入订单明细，并清空购物车
        foreach ($cartItems as $ci) {
            $subtotal = (float)$ci['price'] * (int)$ci['quantity'];
            $db->prepare("INSERT INTO order_item (order_id, product_id, part_no, product_name, quantity, price, subtotal, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), NOW())")
                ->execute([$orderId, $ci['product_id'], $ci['part_no'], $ci['name'], $ci['quantity'], $ci['price'], $subtotal]);
        }
        $db->prepare("DELETE FROM cart WHERE user_id = ?")->execute([$userId]);

        success(['id' => $orderId, 'order_no' => $orderNo, 'total' => $total, 'itemCount' => count($cartItems)], '下单成功');
    },
    'GET order/list' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        if ($userId <= 0) error('未登录', 401);
        $params = getQuery();
        $page = (int)($params['page'] ?? 1); $size = (int)($params['size'] ?? 20); $offset = ($page - 1) * $size;
        $db = getDB();
        $total = (int)$db->query("SELECT COUNT(*) as total FROM `order` WHERE user_id = $userId")->fetch(PDO::FETCH_ASSOC)['total'];
        $stmt = $db->prepare("SELECT * FROM `order` WHERE user_id = ? ORDER BY id DESC LIMIT ? OFFSET ?");
        $stmt->bindValue(1, $userId, PDO::PARAM_INT);
        $stmt->bindValue(2, $size, PDO::PARAM_INT);
        $stmt->bindValue(3, $offset, PDO::PARAM_INT);
        $stmt->execute();
        $records = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $itemsMap = getOrderItemsMap($db, array_column($records, 'id'));
        foreach ($records as &$r) { $r['items'] = $itemsMap[$r['id']] ?? []; }
        unset($r);
        success(['records' => $records, 'total' => $total, 'page' => $page, 'size' => $size, 'pages' => ceil($total / $size)]);
    },
    'GET order/{id}' => function($id) {
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM `order` WHERE id = ?");
        $stmt->execute([$id]);
        $order = $stmt->fetch(PDO::FETCH_ASSOC);
        if (!$order) error('订单不存在', 404);
        $itemsMap = getOrderItemsMap($db, [$order['id']]);
        $order['items'] = $itemsMap[$order['id']] ?? [];
        success($order);
    },
    'POST order/cancel' => function() {
        $data = getInput();
        $db = getDB();
        $db->prepare("UPDATE `order` SET status='cancelled' WHERE id=?")->execute([$data['id'] ?? 0]);
        success(null, '取消成功');
    },
    'POST order/confirm-receipt' => function() {
        $data = getInput();
        $db = getDB();
        $db->prepare("UPDATE `order` SET status='completed' WHERE id=?")->execute([$data['id'] ?? 0]);
        success(null, '确认收货成功');
    },

    // 上传付款凭证（multipart：id + voucher 文件，或 JSON：id + transferVoucher 文本）
    'POST order/upload-voucher' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        if ($userId <= 0) error('未登录', 401);
        $db = getDB();
        $json = json_decode(file_get_contents('php://input'), true) ?: [];
        // JSON body 不会填充 $_POST，需从 json 里取 id
        $orderId = $_POST['id'] ?? $json['id'] ?? 0;
        if (!$orderId) error('参数错误');
        // 校验订单归属
        $stmt = $db->prepare("SELECT id FROM `order` WHERE id = ? AND user_id = ?");
        $stmt->execute([$orderId, $userId]);
        if (!$stmt->fetch(PDO::FETCH_ASSOC)) error('订单不存在', 404);
        // 处理凭证图片
        $url = '';
        if (isset($_FILES['voucher']) && $_FILES['voucher']['error'] === UPLOAD_ERR_OK) {
            $file = $_FILES['voucher'];
            $uploadDir = __DIR__ . '/uploads/vouchers/';
            if (!is_dir($uploadDir)) mkdir($uploadDir, 0755, true);
            $ext = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
            $allowed = ['jpg', 'jpeg', 'png', 'gif', 'pdf', 'webp'];
            if (!in_array($ext, $allowed)) error('仅支持 jpg/png/gif/pdf/webp 格式');
            $filename = 'voucher_' . $orderId . '_' . uniqid() . '.' . $ext;
            if (move_uploaded_file($file['tmp_name'], $uploadDir . $filename)) {
                $url = '/uploads/vouchers/' . $filename;
            }
        }
        // 兼容 JSON 文本形式（转账流水号等）
        if (!$url) {
            $url = $json['transferVoucher'] ?? '';
        }
        if ($url === '') error('请上传凭证图片或填写凭证信息');
        $db->prepare("UPDATE `order` SET transfer_voucher = ?, updated_at = NOW() WHERE id = ? AND user_id = ?")->execute([$url, $orderId, $userId]);
        success(['url' => $url], '凭证上传成功');
    },

    // 支付（前端 Pay.vue 将 orderNo 作为 orderId 传入）
    'POST pay/unified-order' => function() {
        $data = getInput();
        $orderNo = $data['orderId'] ?? $data['orderNo'] ?? '';
        $method = $data['method'] ?? 'wechat';
        if (empty($orderNo)) error('订单号不能为空');
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM `order` WHERE order_no = ?");
        $stmt->execute([$orderNo]);
        $order = $stmt->fetch(PDO::FETCH_ASSOC);
        if (!$order) error('订单不存在', 404);
        // 标记为已支付，并记录支付方式
        $db->prepare("UPDATE `order` SET status='paid', payment_method=?, updated_at=NOW() WHERE order_no=?")
            ->execute([$method, $orderNo]);
        $payNo = 'PAY' . date('YmdHis') . rand(1000, 9999);
        success([
            'payNo' => $payNo,
            'tradeNo' => $payNo,
            'orderNo' => $orderNo,
            'amount' => $order['total_amount'],
            'method' => $method,
        ], '支付成功');
    },
    'POST pay/notify' => function() {
        $data = getInput();
        $orderNo = $data['orderNo'] ?? $data['orderId'] ?? '';
        $db = getDB();
        if (!empty($orderNo)) {
            $db->prepare("UPDATE `order` SET status='paid', updated_at=NOW() WHERE order_no=?")->execute([$orderNo]);
        }
        success(null, '回调成功');
    },

    // 用户地址
    'GET user/address/list' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        if ($userId <= 0) error('未登录', 401);
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM user_address WHERE user_id = ? ORDER BY is_default DESC, id DESC");
        $stmt->execute([$userId]);
        success($stmt->fetchAll(PDO::FETCH_ASSOC));
    },
    'POST user/address/add' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        if ($userId <= 0) error('未登录', 401);
        $data = getInput();
        $db = getDB();
        $stmt = $db->prepare("INSERT INTO user_address (user_id, name, phone, province, city, district, detail, is_default, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())");
        $stmt->execute([$userId, $data['name'] ?? '', $data['phone'] ?? '', $data['province'] ?? '', $data['city'] ?? '', $data['district'] ?? '', $data['detail'] ?? '', $data['isDefault'] ?? $data['is_default'] ?? 0]);
        success(['id' => $db->lastInsertId()], '添加成功');
    },
    'PUT user/address/update' => function() {
        $data = getInput();
        $id = $data['id'] ?? 0;
        if (!$id) error('参数错误');
        $db = getDB();
        $stmt = $db->prepare("UPDATE user_address SET name=?, phone=?, province=?, city=?, district=?, detail=?, is_default=?, updated_at=NOW() WHERE id=?");
        $stmt->execute([$data['name'] ?? '', $data['phone'] ?? '', $data['province'] ?? '', $data['city'] ?? '', $data['district'] ?? '', $data['detail'] ?? '', $data['isDefault'] ?? $data['is_default'] ?? 0, $id]);
        success(null, '更新成功');
    },
    'DELETE user/address/delete' => function() {
        $data = getInput();
        $id = $data['id'] ?? 0;
        $db = getDB();
        $db->prepare("DELETE FROM user_address WHERE id = ?")->execute([$id]);
        success(null, '删除成功');
    },

    // 常用型号管理
    'GET user/part-no/list' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        if ($userId <= 0) error('未登录', 401);
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM user_part_no WHERE user_id = ? AND (deleted = 0 OR deleted IS NULL) ORDER BY id DESC");
        $stmt->execute([$userId]);
        success($stmt->fetchAll(PDO::FETCH_ASSOC));
    },
    'POST user/part-no/add' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        if ($userId <= 0) error('未登录', 401);
        $data = getInput();
        $partNo = trim($data['partNo'] ?? $data['part_no'] ?? '');
        if ($partNo === '') error('型号不能为空');
        $db = getDB();
        // 已存在则跳过，避免重复
        $stmt = $db->prepare("SELECT id FROM user_part_no WHERE user_id = ? AND part_no = ? AND (deleted = 0 OR deleted IS NULL)");
        $stmt->execute([$userId, $partNo]);
        if (!$stmt->fetch(PDO::FETCH_ASSOC)) {
            $db->prepare("INSERT INTO user_part_no (user_id, part_no, created_at, updated_at) VALUES (?, ?, NOW(), NOW())")
                ->execute([$userId, $partNo]);
        }
        success(['id' => $db->lastInsertId()], '添加成功');
    },
    'DELETE user/part-no/delete' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        if ($userId <= 0) error('未登录', 401);
        $data = getInput();
        $id = $data['id'] ?? 0;
        if (!$id) error('参数错误');
        $db = getDB();
        $db->prepare("DELETE FROM user_part_no WHERE id = ? AND user_id = ?")->execute([$id, $userId]);
        success(null, '删除成功');
    },

    // 账户安全：绑定邮箱
    'PUT user/security/bind-email' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        if ($userId <= 0) error('未登录', 401);
        $data = getInput();
        $email = trim($data['email'] ?? '');
        if ($email === '' || !filter_var($email, FILTER_VALIDATE_EMAIL)) error('邮箱格式不正确');
        $db = getDB();
        $db->prepare("UPDATE user SET email = ?, updated_at = NOW() WHERE id = ?")->execute([$email, $userId]);
        success(null, '绑定成功');
    },

    // 用户收藏
    'GET user/favorite/list' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        if ($userId <= 0) error('未登录', 401);
        $db = getDB();
        $stmt = $db->prepare("SELECT f.*, p.name, p.price, p.image_url, p.part_no FROM favorite f LEFT JOIN product p ON f.product_id = p.id WHERE f.user_id = ? AND (f.deleted = 0 OR f.deleted IS NULL) ORDER BY f.id DESC");
        $stmt->execute([$userId]);
        success($stmt->fetchAll(PDO::FETCH_ASSOC));
    },
    'POST user/favorite/add' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        if ($userId <= 0) error('未登录', 401);
        $data = getInput();
        $db = getDB();
        $stmt = $db->prepare("INSERT INTO favorite (user_id, product_id, created_at, updated_at) VALUES (?, ?, NOW(), NOW())");
        $stmt->execute([$userId, $data['productId'] ?? $data['product_id'] ?? 0]);
        success(null, '收藏成功');
    },
    'DELETE user/favorite/delete' => function() {
        $data = getInput();
        $id = $data['id'] ?? 0;
        $db = getDB();
        $db->prepare("DELETE FROM favorite WHERE id = ?")->execute([$id]);
        success(null, '取消收藏');
    },

    // 余额
    'GET user/balance/log' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        if ($userId <= 0) error('未登录', 401);
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM user_balance_log WHERE user_id = ? AND (deleted = 0 OR deleted IS NULL) ORDER BY id DESC");
        $stmt->execute([$userId]);
        success($stmt->fetchAll(PDO::FETCH_ASSOC));
    },

    // 反馈
    'POST user/feedback/submit' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        $data = getInput();
        $db = getDB();
        $stmt = $db->prepare("INSERT INTO feedback (user_id, type, title, content, contact, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, 0, NOW(), NOW())");
        $stmt->execute([
            $userId,
            $data['type'] ?? 'other',
            $data['title'] ?? '',
            $data['content'] ?? '',
            $data['contact'] ?? '',
        ]);
        success(null, '提交成功');
    },

    // 消息
    'GET user/message/list' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM message WHERE user_id = ? OR user_id = 0 ORDER BY id DESC");
        $stmt->execute([$userId]);
        success($stmt->fetchAll(PDO::FETCH_ASSOC));
    },

    // 个人资料
    'PUT user/center/update-profile' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        if ($userId <= 0) error('未登录', 401);
        $data = getInput();
        $db = getDB();
        $stmt = $db->prepare("UPDATE user SET nickname=?, avatar=?, updated_at=NOW() WHERE id=?");
        $stmt->execute([$data['nickname'] ?? '', $data['avatar'] ?? '', $userId]);
        success(null, '更新成功');
    },

    // 内容 (新闻)
    'GET news/list' => function() {
        $db = getDB();
        $stmt = $db->query("SELECT * FROM news WHERE status = 1 ORDER BY id DESC");
        success($stmt->fetchAll(PDO::FETCH_ASSOC));
    },
    'GET news/{id}' => function($id) {
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM news WHERE id = ?");
        $stmt->execute([$id]);
        $news = $stmt->fetch(PDO::FETCH_ASSOC);
        if (!$news) error('新闻不存在', 404);
        success($news);
    },
    'POST news/toggle-like' => function() {
        $data = getInput();
        success(null, '操作成功');
    },
    'POST news/toggle-favorite' => function() {
        $data = getInput();
        success(null, '操作成功');
    },

    // 数据手册
    'GET datasheet/list' => function() {
        $params = getQuery();
        $page = (int)($params['page'] ?? 1); $size = (int)($params['size'] ?? 20); $offset = ($page - 1) * $size;
        $db = getDB();
        $total = (int)$db->query("SELECT COUNT(*) as total FROM datasheet")->fetch(PDO::FETCH_ASSOC)['total'];
        $stmt = $db->prepare("SELECT * FROM datasheet ORDER BY id DESC LIMIT ? OFFSET ?");
        $stmt->bindValue(1, $size, PDO::PARAM_INT);
        $stmt->bindValue(2, $offset, PDO::PARAM_INT);
        $stmt->execute();
        success(['records' => $stmt->fetchAll(PDO::FETCH_ASSOC), 'total' => $total, 'page' => $page, 'size' => $size, 'pages' => ceil($total / $size)]);
    },

    // 轮播图管理
    'GET carousel/list' => function() {
        checkLogin();
        $db = getDB();
        $stmt = $db->query("SELECT * FROM carousel ORDER BY sort ASC, id DESC");
        success($stmt->fetchAll(PDO::FETCH_ASSOC));
    },
    'GET carousel/public/list' => function() {
        $db = getDB();
        $stmt = $db->query("SELECT * FROM carousel WHERE status = 1 ORDER BY sort ASC, id DESC");
        success($stmt->fetchAll(PDO::FETCH_ASSOC));
    },
    'POST carousel/add' => function() {
        checkLogin();
        $data = getInput();
        $title = trim($data['title'] ?? '');
        if (empty($title)) error('轮播图标题不能为空');
        if (strlen($title) > 100) error('标题长度不能超过100个字符');
        $imageUrl = trim($data['image_url'] ?? '');
        if (empty($imageUrl)) error('图片URL不能为空，请上传图片或输入图片地址');
        // 验证图片URL格式，防止空值和恶意注入
        if (!preg_match('/^https?:\/\/.+/', $imageUrl)) {
            error('图片URL格式不正确，必须以 http:// 或 https:// 开头');
        }
        $title = htmlspecialchars($title, ENT_QUOTES);
        $link = trim($data['link'] ?? '');
        if (!empty($link) && !preg_match('/^https?:\/\//', $link)) {
            error('链接格式不正确，必须以 http:// 或 https:// 开头');
        }
        $db = getDB();
        $stmt = $db->prepare("INSERT INTO carousel (title, image_url, link, sort, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, NOW(), NOW())");
        $stmt->execute([$title, $imageUrl, $link, $data['sort'] ?? 0, $data['status'] ?? 1]);
        success(['id' => $db->lastInsertId()], '保存成功');
    },
    'PUT carousel/update' => function() {
        checkLogin();
        $data = getInput();
        $id = $data['id'] ?? 0;
        if (!$id) error('参数错误');
        $title = trim($data['title'] ?? '');
        if (empty($title)) error('轮播图标题不能为空');
        if (strlen($title) > 100) error('标题长度不能超过100个字符');
        $imageUrl = trim($data['image_url'] ?? '');
        if (empty($imageUrl)) error('图片URL不能为空，请上传图片或输入图片地址');
        if (!preg_match('/^https?:\/\/.+/', $imageUrl)) {
            error('图片URL格式不正确，必须以 http:// 或 https:// 开头');
        }
        $title = htmlspecialchars($title, ENT_QUOTES);
        $link = trim($data['link'] ?? '');
        if (!empty($link) && !preg_match('/^https?:\/\//', $link)) {
            error('链接格式不正确，必须以 http:// 或 https:// 开头');
        }
        $db = getDB();
        $stmt = $db->prepare("UPDATE carousel SET title=?, image_url=?, link=?, sort=?, status=?, updated_at=NOW() WHERE id=?");
        $stmt->execute([$title, $imageUrl, $link, $data['sort'] ?? 0, $data['status'] ?? 1, $id]);
        success(null, '保存成功');
    },
    'DELETE carousel/delete' => function() {
        checkLogin();
        $data = getInput();
        $id = $data['id'] ?? 0;
        if (!$id) error('参数错误');
        $db = getDB();
        $db->prepare("DELETE FROM carousel WHERE id = ?")->execute([$id]);
        success(null, '删除成功');
    },

    // 合作品牌
    'GET cooperate-brand/list' => function() {
        $db = getDB();
        $stmt = $db->query("SELECT * FROM cooperate_brand WHERE status = 1 ORDER BY sort ASC");
        success($stmt->fetchAll(PDO::FETCH_ASSOC));
    },

    // 合作伙伴申请
    'POST partner/apply' => function() {
        $data = getInput();
        $db = getDB();
        $stmt = $db->prepare("INSERT INTO partner_apply (company_name, contact_name, phone, email, description, created_at) VALUES (?, ?, ?, ?, ?, NOW())");
        $stmt->execute([$data['companyName'] ?? $data['company_name'] ?? '', $data['contactName'] ?? $data['contact_name'] ?? '', $data['phone'] ?? '', $data['email'] ?? '', $data['description'] ?? '']);
        success(null, '申请成功');
    },

    // 询价
    'POST inquiry/submit' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = (int)($parts[0] ?? 0);
        $data = getInput();
        $db = getDB();
        $inquiryNo = 'IQ' . date('YmdHis') . rand(1000, 9999);
        // 前端 Inquiry.vue 提交: { contact, phone, remark, items:[{partNo,brand,quantity,targetPrice}] }
        $stmt = $db->prepare("INSERT INTO inquiry (inquiry_no, user_id, contact, phone, remark, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, 'pending', NOW(), NOW())");
        $stmt->execute([
            $inquiryNo,
            $userId,
            $data['contact'] ?? $data['name'] ?? '',
            $data['phone'] ?? '',
            $data['remark'] ?? '',
        ]);
        $inquiryId = $db->lastInsertId();
        $items = $data['items'] ?? [];
        if (empty($items) && !empty($data['partNo'] ?? $data['part_no'] ?? '')) {
            $items = [[
                'partNo' => $data['partNo'] ?? $data['part_no'] ?? '',
                'quantity' => $data['quantity'] ?? 0,
                'targetPrice' => $data['targetPrice'] ?? null,
            ]];
        }
        foreach ($items as $it) {
            $db->prepare("INSERT INTO inquiry_item (inquiry_id, product_id, part_no, quantity, target_price, created_at, updated_at) VALUES (?, ?, ?, ?, ?, NOW(), NOW())")
                ->execute([
                    $inquiryId,
                    $it['productId'] ?? $it['product_id'] ?? 0,
                    $it['partNo'] ?? $it['part_no'] ?? '',
                    $it['quantity'] ?? 0,
                    $it['targetPrice'] ?? $it['target_price'] ?? null,
                ]);
        }
        success(['inquiry_no' => $inquiryNo, 'itemCount' => count($items)], '提交成功');
    },
    'GET inquiry/list' => function() {
        $token = getTokenFromRequest();
        $parts = explode('_', $token);
        $userId = $parts[0] ?? 0;
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM inquiry WHERE id > 0 ORDER BY id DESC");
        $stmt->execute();
        success($stmt->fetchAll(PDO::FETCH_ASSOC));
    },
];

// 匹配路由
$matched = false;
foreach ($routes as $routeDef => $handler) {
    $parts = explode(' ', $routeDef, 2);
    $routeMethod = $parts[0];
    $routePath = $parts[1] ?? '';

    if ($routeMethod !== $method) continue;

    // 将路由模式转为正则 (支持 {id} 参数)
    $pattern = preg_replace('/\{(\w+)\}/', '([^/]+)', $routePath);
    $pattern = '#^' . $pattern . '$#';

    if (preg_match($pattern, $path, $matches)) {
        array_shift($matches);
        $handler($matches[0] ?? null);
        $matched = true;
        break;
    }
}

if (!$matched) {
    jsonResponse(404, '路由未找到: ' . $method . ' ' . $path);
}