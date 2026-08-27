<?php
// +----------------------------------------------------------------------
// | 电子元器件商城 - 管理后台API适配控制器
// +----------------------------------------------------------------------
// | 将admin-web前端API路径映射到mall_db数据库
// +----------------------------------------------------------------------

namespace app\adminapi\controller\adapter;

use think\Exception;
use think\facade\Cache;
use Firebase\JWT\JWT;
use Firebase\JWT\Key;

class AdminController
{
    private $db;
    private $jwtKey = 'elect-mall-jwt-secret-key-2024';
    private $tokenPrefix = 'admin_token_';

    public function __construct()
    {
        $host = '127.0.0.1';
        $dbname = 'mall_db';
        $user = 'root';
        $pass = '123456';
        try {
            $this->db = new \PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $user, $pass);
            $this->db->setAttribute(\PDO::ATTR_ERRMODE, \PDO::ERRMODE_EXCEPTION);
        } catch (\Exception $e) {
            $this->json(500, 'Database connection failed');
        }
    }

    private function json($code = 200, $msg = 'success', $data = null, $success = true)
    {
        $result = ['code' => $code, 'msg' => $msg, 'data' => $data, 'success' => $success];
        if ($data === null && $code === 200) {
            unset($result['data']);
        }
        return json($result);
    }

    private function error($msg = '请求失败', $code = 500)
    {
        return $this->json($code, $msg, null, false);
    }

    private function success($data = null, $msg = '操作成功')
    {
        return $this->json(200, $msg, $data);
    }

    private function getTokenFromRequest()
    {
        $header = request()->header('token', '');
        if (empty($header)) {
            $header = request()->header('authorization', '');
            $header = str_replace('Bearer ', '', $header);
        }
        return $header;
    }

    private function checkLogin()
    {
        $token = $this->getTokenFromRequest();
        if (empty($token)) {
            return $this->error('未登录，请先登录', 401);
        }
        // 验证JWT token
        try {
            $decoded = JWT::decode($token, new Key($this->jwtKey, 'HS256'));
            $adminId = $decoded->id ?? 0;
            if ($adminId <= 0) {
                return $this->error('token无效', 401);
            }
            // 检查用户是否存在
            $stmt = $this->db->prepare("SELECT id, username, nickname FROM admin_user WHERE id = ? AND status = 1");
            $stmt->execute([$adminId]);
            $admin = $stmt->fetch(\PDO::FETCH_ASSOC);
            if (!$admin) {
                return $this->error('用户不存在或已禁用', 401);
            }
            return $admin;
        } catch (\Exception $e) {
            return $this->error('token无效或已过期', 401);
        }
    }

    // ====== 认证 ======

    public function login()
    {
        $data = request()->post();
        $username = $data['username'] ?? '';
        $password = $data['password'] ?? '';

        if (empty($username) || empty($password)) {
            return $this->error('用户名或密码不能为空');
        }

        $stmt = $this->db->prepare("SELECT id, username, nickname, password, status FROM admin_user WHERE username = ?");
        $stmt->execute([$username]);
        $admin = $stmt->fetch(\PDO::FETCH_ASSOC);

        if (!$admin) {
            return $this->error('用户名或密码错误');
        }

        if ($admin['status'] != 1) {
            return $this->error('账号已被禁用');
        }

        // 验证密码 (BCrypt)
        if (!password_verify($password, $admin['password'])) {
            return $this->error('用户名或密码错误');
        }

        // 生成JWT token
        $payload = [
            'id' => $admin['id'],
            'username' => $admin['username'],
            'iat' => time(),
            'exp' => time() + 86400 * 7, // 7天
        ];
        $token = JWT::encode($payload, $this->jwtKey, 'HS256');

        return $this->success([
            'token' => $token,
            'admin' => [
                'id' => $admin['id'],
                'username' => $admin['username'],
                'nickname' => $admin['nickname'],
            ]
        ], '登录成功');
    }

    public function dashboard()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;

        $counts = [];
        $tables = ['product' => '商品', 'brand' => '品牌', 'category' => '分类', 'news' => '新闻', 'order' => '订单', 'user' => '用户'];
        foreach ($tables as $table => $label) {
            try {
                $stmt = $this->db->query("SELECT COUNT(*) as cnt FROM $table");
                $counts[$table] = (int)$stmt->fetch(\PDO::FETCH_ASSOC)['cnt'];
            } catch (\Exception $e) {
                $counts[$table] = 0;
            }
        }

        return $this->success([
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
    }

    // ====== 品牌管理 ======

    public function brandList()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;

        $stmt = $this->db->query("SELECT * FROM brand WHERE deleted = 0 ORDER BY sort ASC");
        $data = $stmt->fetchAll(\PDO::FETCH_ASSOC);
        return $this->success($data);
    }

    public function brandAdd()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;

        $data = request()->post();
        $name = $data['name'] ?? '';
        if (empty($name)) return $this->error('品牌名称不能为空');

        $stmt = $this->db->prepare("INSERT INTO brand (name, logo, description, sort, status, deleted) VALUES (?, ?, ?, ?, ?, 0)");
        $stmt->execute([
            $name,
            $data['logo'] ?? '',
            $data['description'] ?? '',
            $data['sort'] ?? 0,
            $data['status'] ?? 1,
        ]);
        return $this->success(['id' => $this->db->lastInsertId()], '保存成功');
    }

    public function brandUpdate()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;

        $data = request()->put();
        $id = $data['id'] ?? 0;
        if (!$id) return $this->error('参数错误');

        $stmt = $this->db->prepare("UPDATE brand SET name=?, logo=?, description=?, sort=?, status=? WHERE id=?");
        $stmt->execute([
            $data['name'] ?? '',
            $data['logo'] ?? '',
            $data['description'] ?? '',
            $data['sort'] ?? 0,
            $data['status'] ?? 1,
            $id,
        ]);
        return $this->success(null, '保存成功');
    }

    public function brandDelete($id)
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;

        $stmt = $this->db->prepare("UPDATE brand SET deleted = 1 WHERE id = ?");
        $stmt->execute([$id]);
        return $this->success(null, '删除成功');
    }

    // ====== 分类管理 ======

    public function categoryList()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;

        $stmt = $this->db->query("SELECT * FROM category ORDER BY sort ASC");
        $data = $stmt->fetchAll(\PDO::FETCH_ASSOC);
        return $this->success($data);
    }

    public function categoryAdd()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;

        $data = request()->post();
        $name = $data['name'] ?? '';
        if (empty($name)) return $this->error('分类名称不能为空');

        $stmt = $this->db->prepare("INSERT INTO category (name, parent_id, prefix, sort, status) VALUES (?, ?, ?, ?, ?)");
        $stmt->execute([
            $name,
            $data['parentId'] ?? $data['parent_id'] ?? 0,
            $data['prefix'] ?? '',
            $data['sort'] ?? 0,
            $data['status'] ?? 1,
        ]);
        return $this->success(['id' => $this->db->lastInsertId()], '保存成功');
    }

    public function categoryUpdate()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;

        $data = request()->put();
        $id = $data['id'] ?? 0;
        if (!$id) return $this->error('参数错误');

        $stmt = $this->db->prepare("UPDATE category SET name=?, parent_id=?, prefix=?, sort=?, status=? WHERE id=?");
        $stmt->execute([
            $data['name'] ?? '',
            $data['parentId'] ?? $data['parent_id'] ?? 0,
            $data['prefix'] ?? '',
            $data['sort'] ?? 0,
            $data['status'] ?? 1,
            $id,
        ]);
        return $this->success(null, '保存成功');
    }

    public function categoryDelete()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;

        $data = request()->delete();
        $id = $data['id'] ?? 0;
        if (!$id) return $this->error('参数错误');

        $stmt = $this->db->prepare("DELETE FROM category WHERE id = ?");
        $stmt->execute([$id]);
        return $this->success(null, '删除成功');
    }

    // ====== 新闻管理 ======

    public function newsList()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;

        $stmt = $this->db->query("SELECT * FROM news ORDER BY id DESC");
        $data = $stmt->fetchAll(\PDO::FETCH_ASSOC);
        return $this->success($data);
    }

    public function newsAdd()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;

        $data = request()->post();
        $title = $data['title'] ?? '';
        if (empty($title)) return $this->error('新闻标题不能为空');

        $stmt = $this->db->prepare("INSERT INTO news (title, content, image, status) VALUES (?, ?, ?, ?)");
        $stmt->execute([
            $title,
            $data['content'] ?? '',
            $data['image'] ?? '',
            $data['status'] ?? 1,
        ]);
        return $this->success(['id' => $this->db->lastInsertId()], '保存成功');
    }

    public function newsUpdate()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;

        $data = request()->put();
        $id = $data['id'] ?? 0;
        if (!$id) return $this->error('参数错误');

        $stmt = $this->db->prepare("UPDATE news SET title=?, content=?, image=?, status=? WHERE id=?");
        $stmt->execute([
            $data['title'] ?? '',
            $data['content'] ?? '',
            $data['image'] ?? '',
            $data['status'] ?? 1,
            $id,
        ]);
        return $this->success(null, '保存成功');
    }

    public function newsDelete()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;

        $data = request()->delete();
        $id = $data['id'] ?? 0;
        if (!$id) return $this->error('参数错误');

        $stmt = $this->db->prepare("DELETE FROM news WHERE id = ?");
        $stmt->execute([$id]);
        return $this->success(null, '删除成功');
    }

    // ====== 商品管理 ======

    public function productPage()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;

        $data = request()->post();
        $page = (int)($data['page'] ?? 1);
        $size = (int)($data['size'] ?? 20);
        $offset = ($page - 1) * $size;

        $countStmt = $this->db->query("SELECT COUNT(*) as total FROM product");
        $total = (int)$countStmt->fetch(\PDO::FETCH_ASSOC)['total'];

        $stmt = $this->db->prepare("SELECT p.*, c.name as category_name FROM product p LEFT JOIN category c ON p.category_id = c.id ORDER BY p.id DESC LIMIT ? OFFSET ?");
        $stmt->execute([$size, $offset]);
        $records = $stmt->fetchAll(\PDO::FETCH_ASSOC);

        return $this->success([
            'records' => $records,
            'total' => $total,
            'page' => $page,
            'size' => $size,
            'pages' => ceil($total / $size),
        ]);
    }

    public function productAdd()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;

        $data = request()->post();
        $name = $data['name'] ?? '';
        if (empty($name)) return $this->error('商品名称不能为空');

        $stmt = $this->db->prepare("INSERT INTO product (name, category_id, part_no, price, stock, description, image, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())");
        $stmt->execute([
            $name,
            $data['categoryId'] ?? $data['category_id'] ?? null,
            $data['partNo'] ?? $data['part_no'] ?? '',
            $data['price'] ?? 0,
            $data['stock'] ?? 0,
            $data['description'] ?? '',
            $data['image'] ?? '',
            $data['status'] ?? 1,
        ]);
        return $this->success(['id' => $this->db->lastInsertId()], '保存成功');
    }

    public function productUpdate()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;

        $data = request()->put();
        $id = $data['id'] ?? 0;
        if (!$id) return $this->error('参数错误');

        $stmt = $this->db->prepare("UPDATE product SET name=?, category_id=?, part_no=?, price=?, stock=?, description=?, image=?, status=?, updated_at=NOW() WHERE id=?");
        $stmt->execute([
            $data['name'] ?? '',
            $data['categoryId'] ?? $data['category_id'] ?? null,
            $data['partNo'] ?? $data['part_no'] ?? '',
            $data['price'] ?? 0,
            $data['stock'] ?? 0,
            $data['description'] ?? '',
            $data['image'] ?? '',
            $data['status'] ?? 1,
            $id,
        ]);
        return $this->success(null, '保存成功');
    }

    public function productDelete()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;

        $data = request()->delete();
        $id = $data['id'] ?? 0;
        if (!$id) return $this->error('参数错误');

        $stmt = $this->db->prepare("DELETE FROM product WHERE id = ?");
        $stmt->execute([$id]);
        return $this->success(null, '删除成功');
    }

    // ====== 订单管理 ======

    public function orderPage()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;

        $params = request()->get();
        $page = (int)($params['page'] ?? 1);
        $size = (int)($params['size'] ?? 20);
        $offset = ($page - 1) * $size;

        $countStmt = $this->db->query("SELECT COUNT(*) as total FROM `order`");
        $total = (int)$countStmt->fetch(\PDO::FETCH_ASSOC)['total'];

        $stmt = $this->db->prepare("SELECT * FROM `order` ORDER BY id DESC LIMIT ? OFFSET ?");
        $stmt->execute([$size, $offset]);
        $records = $stmt->fetchAll(\PDO::FETCH_ASSOC);

        return $this->success([
            'records' => $records,
            'total' => $total,
            'page' => $page,
            'size' => $size,
            'pages' => ceil($total / $size),
        ]);
    }

    public function orderAudit()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;
        $data = request()->post();
        $id = $data['id'] ?? 0;
        $stmt = $this->db->prepare("UPDATE `order` SET status='audited' WHERE id=?");
        $stmt->execute([$id]);
        return $this->success(null, '审核成功');
    }

    public function orderShip()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;
        $data = request()->post();
        $id = $data['id'] ?? 0;
        $stmt = $this->db->prepare("UPDATE `order` SET status='shipped' WHERE id=?");
        $stmt->execute([$id]);
        return $this->success(null, '发货成功');
    }

    // ====== 用户管理 ======

    public function userList()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;

        $params = request()->get();
        $page = (int)($params['page'] ?? 1);
        $size = (int)($params['size'] ?? 20);
        $offset = ($page - 1) * $size;

        $countStmt = $this->db->query("SELECT COUNT(*) as total FROM user");
        $total = (int)$countStmt->fetch(\PDO::FETCH_ASSOC)['total'];

        $stmt = $this->db->prepare("SELECT * FROM user ORDER BY id DESC LIMIT ? OFFSET ?");
        $stmt->execute([$size, $offset]);
        $records = $stmt->fetchAll(\PDO::FETCH_ASSOC);

        return $this->success([
            'records' => $records,
            'total' => $total,
            'page' => $page,
            'size' => $size,
            'pages' => ceil($total / $size),
        ]);
    }

    // ====== 询价单 ======

    public function inquiryPage()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;

        $params = request()->get();
        $page = (int)($params['page'] ?? 1);
        $size = (int)($params['size'] ?? 20);
        $offset = ($page - 1) * $size;

        $countStmt = $this->db->query("SELECT COUNT(*) as total FROM inquiry");
        $total = (int)$countStmt->fetch(\PDO::FETCH_ASSOC)['total'];

        $stmt = $this->db->prepare("SELECT * FROM inquiry ORDER BY id DESC LIMIT ? OFFSET ?");
        $stmt->execute([$size, $offset]);
        $records = $stmt->fetchAll(\PDO::FETCH_ASSOC);

        return $this->success([
            'records' => $records,
            'total' => $total,
            'page' => $page,
            'size' => $size,
            'pages' => ceil($total / $size),
        ]);
    }

    public function inquiryReply()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;
        $data = request()->post();
        $id = $data['id'] ?? 0;
        $reply = $data['reply'] ?? '';
        $stmt = $this->db->prepare("UPDATE inquiry SET reply=?, status='replied' WHERE id=?");
        $stmt->execute([$reply, $id]);
        return $this->success(null, '回复成功');
    }

    // ====== 合作伙伴 ======

    public function partnerList()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;
        $stmt = $this->db->query("SELECT * FROM partner_apply ORDER BY id DESC");
        return $this->success($stmt->fetchAll(\PDO::FETCH_ASSOC));
    }

    // ====== 反馈 ======

    public function feedbackList()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;
        $stmt = $this->db->query("SELECT * FROM feedback ORDER BY id DESC");
        return $this->success($stmt->fetchAll(\PDO::FETCH_ASSOC));
    }

    // ====== 财务 ======

    public function financeData()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;
        $params = request()->get();
        $days = (int)($params['days'] ?? 30);

        return $this->success([
            'totalRevenue' => 0,
            'totalOrders' => 0,
            'avgOrderValue' => 0,
            'dailyData' => [],
        ]);
    }

    // ====== 系统设置 ======

    public function settingList()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;
        $stmt = $this->db->query("SELECT * FROM sys_config");
        $data = $stmt->fetchAll(\PDO::FETCH_ASSOC);
        $settings = [];
        foreach ($data as $row) {
            $settings[$row['key']] = $row['value'];
        }
        return $this->success($settings);
    }

    public function settingSave()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;
        $data = request()->post();
        foreach ($data as $key => $value) {
            if ($key === 'id') continue;
            $stmt = $this->db->prepare("INSERT INTO sys_config (`key`, `value`) VALUES (?, ?) ON DUPLICATE KEY UPDATE `value` = ?");
            $stmt->execute([$key, $value, $value]);
        }
        return $this->success(null, '保存成功');
    }

    // ====== 上传 ======

    public function upload()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;

        $file = request()->file('file');
        if (!$file) return $this->error('请选择文件');

        $info = $file->move('uploads');
        if ($info) {
            return $this->success(['url' => '/uploads/' . $info->getSaveName()], '上传成功');
        }
        return $this->error('上传失败');
    }

    // ====== BOM管理 ======

    public function bomList()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;
        $params = request()->get();
        $page = (int)($params['page'] ?? 1);
        $size = (int)($params['size'] ?? 20);
        $offset = ($page - 1) * $size;

        $countStmt = $this->db->query("SELECT COUNT(*) as total FROM bom_record");
        $total = (int)$countStmt->fetch(\PDO::FETCH_ASSOC)['total'];

        $stmt = $this->db->prepare("SELECT * FROM bom_record ORDER BY id DESC LIMIT ? OFFSET ?");
        $stmt->execute([$size, $offset]);
        $records = $stmt->fetchAll(\PDO::FETCH_ASSOC);

        return $this->success([
            'records' => $records,
            'total' => $total,
            'page' => $page,
            'size' => $size,
            'pages' => ceil($total / $size),
        ]);
    }

    public function bomDelete()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;
        $data = request()->delete();
        $id = $data['id'] ?? 0;
        $this->db->prepare("DELETE FROM bom_record WHERE id = ?")->execute([$id]);
        $this->db->prepare("DELETE FROM bom_item WHERE record_id = ?")->execute([$id]);
        return $this->success(null, '删除成功');
    }

    // ====== 合作品牌 ======

    public function cooperateList()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;
        $stmt = $this->db->query("SELECT * FROM cooperate_brand ORDER BY sort ASC");
        return $this->success($stmt->fetchAll(\PDO::FETCH_ASSOC));
    }

    public function cooperateAdd()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;
        $data = request()->post();
        $stmt = $this->db->prepare("INSERT INTO cooperate_brand (name, logo, description, url, sort, status) VALUES (?, ?, ?, ?, ?, ?)");
        $stmt->execute([$data['name'] ?? '', $data['logo'] ?? '', $data['description'] ?? '', $data['url'] ?? '', $data['sort'] ?? 0, $data['status'] ?? 1]);
        return $this->success(['id' => $this->db->lastInsertId()], '保存成功');
    }

    public function cooperateUpdate()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;
        $data = request()->put();
        $id = $data['id'] ?? 0;
        $stmt = $this->db->prepare("UPDATE cooperate_brand SET name=?, logo=?, description=?, url=?, sort=?, status=? WHERE id=?");
        $stmt->execute([$data['name'] ?? '', $data['logo'] ?? '', $data['description'] ?? '', $data['url'] ?? '', $data['sort'] ?? 0, $data['status'] ?? 1, $id]);
        return $this->success(null, '保存成功');
    }

    public function cooperateDelete()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;
        $data = request()->delete();
        $id = $data['id'] ?? 0;
        $this->db->prepare("DELETE FROM cooperate_brand WHERE id = ?")->execute([$id]);
        return $this->success(null, '删除成功');
    }

    // ====== 数据手册 ======

    public function datasheetList()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;
        $params = request()->get();
        $page = (int)($params['page'] ?? 1);
        $size = (int)($params['size'] ?? 20);
        $offset = ($page - 1) * $size;

        $countStmt = $this->db->query("SELECT COUNT(*) as total FROM datasheet");
        $total = (int)$countStmt->fetch(\PDO::FETCH_ASSOC)['total'];
        $stmt = $this->db->prepare("SELECT * FROM datasheet ORDER BY id DESC LIMIT ? OFFSET ?");
        $stmt->execute([$size, $offset]);

        return $this->success([
            'records' => $stmt->fetchAll(\PDO::FETCH_ASSOC),
            'total' => $total,
            'page' => $page,
            'size' => $size,
            'pages' => ceil($total / $size),
        ]);
    }

    public function datasheetDelete()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;
        $data = request()->delete();
        $id = $data['id'] ?? 0;
        $this->db->prepare("DELETE FROM datasheet WHERE id = ?")->execute([$id]);
        return $this->success(null, '删除成功');
    }

    // ====== 消息通知 ======

    public function messageList()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;
        $params = request()->get();
        $page = (int)($params['page'] ?? 1);
        $size = (int)($params['size'] ?? 20);
        $offset = ($page - 1) * $size;

        $countStmt = $this->db->query("SELECT COUNT(*) as total FROM message");
        $total = (int)$countStmt->fetch(\PDO::FETCH_ASSOC)['total'];
        $stmt = $this->db->prepare("SELECT * FROM message ORDER BY id DESC LIMIT ? OFFSET ?");
        $stmt->execute([$size, $offset]);

        return $this->success([
            'records' => $stmt->fetchAll(\PDO::FETCH_ASSOC),
            'total' => $total,
            'page' => $page,
            'size' => $size,
            'pages' => ceil($total / $size),
        ]);
    }

    public function messageSend()
    {
        $admin = $this->checkLogin();
        if ($admin instanceof \think\Response) return $admin;
        $data = request()->post();
        $stmt = $this->db->prepare("INSERT INTO message (title, content, type, user_id, status, created_at) VALUES (?, ?, ?, ?, 0, NOW())");
        $stmt->execute([$data['title'] ?? '', $data['content'] ?? '', $data['type'] ?? 'system', $data['userId'] ?? $data['user_id'] ?? 0]);
        return $this->success(null, '发送成功');
    }
}