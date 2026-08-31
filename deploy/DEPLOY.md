# elect-mall 部署文档

## 一、部署架构

```
浏览器
  │
  ├─ www.你的域名.com      → nginx → mall-web/dist 静态文件
  │                              └─ /api/*   反向代理 → PHP 后端
  │
  └─ admin.你的域名.com    → nginx → admin-web/dist 静态文件
                                 └─ /admin/* 反向代理 → PHP 后端

PHP 后端 (crmeb/public/adapter.php, 127.0.0.1:8000) → MySQL (mall_db)
```

三个组成部分：

| 组件 | 技术 | 产物/入口 | 说明 |
|---|---|---|---|
| 商城前端 | Vue3 + Vite | `mall-web/dist` | hash 路由，纯静态 |
| 管理后台 | Vue3 + Vite | `admin-web/dist` | history 路由，需 nginx `try_files` |
| 后端 API | PHP 单文件 | `crmeb/public/adapter.php` | 需常驻（php -S 或 php-fpm）+ MySQL |

> **重要**：后台的接口前缀是 `/admin`，与后台页面共用域名会冲突，
> 所以后台**必须独立域名或独立端口**，不要挂成 `www域名/admin` 这种子路径。

---

## 二、服务器环境要求

| 软件 | 版本要求 | 用途 |
|---|---|---|
| Linux | Ubuntu 20.04+ / CentOS 7+ | 推荐 Ubuntu 22.04 |
| nginx | 1.18+ | 静态托管 + 反向代理 |
| PHP | 7.4+（推荐 8.1） | 后端运行时，需 `pdo_mysql`、`json` 扩展 |
| MySQL | 5.7+ / 8.0+ | 数据库 |
| Node.js | 18+ | 仅用于**构建**前端，运行时不需要 |

最低配置参考：2 核 4G、40G 硬盘（小流量内部系统 1 核 2G 也可）。

### 安装软件（Ubuntu 22.04）

```bash
sudo apt update
sudo apt install -y nginx mysql-server php8.1-cli php8.1-fpm php8.1-mysql curl
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
```

### 安装软件（CentOS 7/8）

```bash
sudo yum install -y epel-release nginx mysql-server php-cli php-fpm php-mysqlnd
curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -
sudo yum install -y nodejs
```

---

## 三、首次部署步骤

以下假设项目放在 `/var/www/elect-mall`，请按实际替换。

### 3.1 放置代码

```bash
sudo mkdir -p /var/www
cd /var/www
sudo git clone <你的仓库地址> elect-mall
cd elect-mall
```

### 3.2 初始化数据库

```bash
# 登录 MySQL
sudo mysql -u root -p

# 建库建用户（请修改密码）
CREATE DATABASE mall_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'mall_user'@'localhost' IDENTIFIED BY '改成强密码';
GRANT ALL PRIVILEGES ON mall_db.* TO 'mall_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;

# 导入表结构与初始数据
sudo mysql -u mall_user -p mall_db < /var/www/elect-mall/install.sql
```

> `install.sql` 包含全部表结构与初始数据（含默认管理员账号）。
> 若只需要表结构，用 `mall_db_schema.sql`。

**默认后台账号**：`admin` / `admin123`，上线后请立即修改密码。

### 3.3 配置并启动后端

后端数据库连接已支持环境变量（adapter.php 内 `getDB()` 会读取），默认值是本地的 `root/123456`，部署时必须覆盖。

```bash
# 安装 systemd 服务
sudo cp /var/www/elect-mall/deploy/systemd/elect-mall-backend.service /etc/systemd/system/

# 编辑数据库账号密码
sudo vi /etc/systemd/system/elect-mall-backend.service
# 修改 Environment=DB_USER / DB_PASS 为你自己的

sudo systemctl daemon-reload
sudo systemctl enable --now elect-mall-backend
sudo systemctl status elect-mall-backend
```

验证后端是否存活：

```bash
curl http://127.0.0.1:8000/api/adapter/product/categories
# 应返回 {"code":200,...}
```

> **生产建议**：`php -S` 是单进程开发服务器，并发能力弱。
> 正式环境建议改用 php-fpm，配置见 `nginx/elect-mall.conf` 文件末尾的注释片段——
> 改完后就不再需要这个 systemd 服务了。

### 3.4 构建前端

```bash
cd /var/www/elect-mall/mall-web
npm install && npm run build      # 产物 mall-web/dist

cd /var/www/elect-mall/admin-web
npm install && npm run build      # 产物 admin-web/dist
```

### 3.5 配置 nginx

```bash
sudo cp /var/www/elect-mall/deploy/nginx/elect-mall.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/elect-mall.conf /etc/nginx/sites-enabled/

# 修改域名与路径
sudo vi /etc/nginx/sites-available/elect-mall.conf
#   1) server_name 改成你的真实域名
#   2) root 改成 /var/www/elect-mall/mall-web/dist 和 .../admin-web/dist

sudo nginx -t                     # 校验
sudo systemctl reload nginx
```

### 3.6 配置 HTTPS（推荐）

```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d www.你的域名.com -d admin.你的域名.com
```

### 3.7 完成

访问验证：

- 商城：`http://www.你的域名.com`
- 后台：`http://admin.你的域名.com`（账号 admin / admin123）

---

## 四、日常更新（代码改动后重新部署）

直接跑一键脚本：

```bash
cd /var/www/elect-mall
sudo ./deploy/deploy.sh
```

脚本会自动：拉代码 → 构建两个前端 → 校验 nginx 配置 → 重载 nginx 与后端服务。

只改了后端 PHP 时不需要重新构建前端，重启后端即可：

```bash
sudo systemctl restart elect-mall-backend
```

---

## 五、本地构建启动（不装 nginx 也能跑生产产物）

项目自带一个零依赖的静态服务器，可托管构建产物并代理 API：

```bash
# 1) 构建
cd mall-web  && npm run build
cd ../admin-web && npm run build

# 2) 启动 PHP 后端（另开一个终端）
cd crmeb/public
php -S localhost:8000 adapter.php

# 3) 启动静态服务（再开一个终端）
cd ../..
node deploy/prod-server.cjs --mall 8080 --admin 8081 --backend http://localhost:8000
```

参数说明：

| 参数 | 默认 | 说明 |
|---|---|---|
| `--mall` | 8080 | 商城端口，传 0 不启动 |
| `--admin` | 8081 | 后台端口，传 0 不启动 |
| `--backend` | http://localhost:8000 | PHP 后端地址 |

访问：`http://localhost:8080`（商城）、`http://localhost:8081`（后台）。

> 开发调试仍推荐 `npm run dev`（支持热更新，端口同样是 8080/8081），
> 上面这套只用于**验证生产构建产物**。

---

## 六、常见问题排查

| 现象 | 原因与处理 |
|---|---|
| 商城页面空白 | nginx 的 `root` 是否指向 `mall-web/dist`；F12 看 JS 是否 404 |
| 后台刷新 404 | nginx 缺 `try_files $uri $uri/ /index.html;`（history 路由必需） |
| 接口 502 | 后端没起来：`systemctl status elect-mall-backend`；或 nginx 里 `proxy_pass` 端口不对 |
| 接口报「数据库连接失败」 | 检查 systemd 里的 `DB_USER`/`DB_PASS`，或 php-fpm 的 `fastcgi_param` 是否配置 |
| 后台能登录但列表为空 | 后端正常但库里没数据，确认已导入 `install.sql` |
| 改了 PHP 不生效 | `php -S` 模式需重启后端服务才会加载新代码 |
| 上传的图片/头像 404 | 检查 `crmeb/public/uploads` 目录权限，需让 PHP 进程可写 |

查看日志：

```bash
sudo journalctl -u elect-mall-backend -f     # 后端日志
sudo tail -f /var/log/nginx/elect-mall-*.error.log   # nginx 错误日志
```

---

## 七、上线安全检查清单

- [ ] 修改后台默认密码（admin / admin123）
- [ ] 数据库不要用 root 账号，改用专用账号 + 强密码
- [ ] 配置 HTTPS
- [ ] 后台域名限制内网/白名单访问（配置里已留好 `allow/deny` 注释）
- [ ] 关闭 MySQL 外网端口（3306 不要对公网开放）
- [ ] 定期备份数据库：`mysqldump -u mall_user -p mall_db > backup_$(date +%F).sql`
- [ ] 生产环境把 `php -S` 换成 php-fpm
