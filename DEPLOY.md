# 生产环境部署指南

> ⚠️ **文档与真实环境不一致提示**：本文件描述的是「通用/理想」部署方案（Nginx + php-fpm + GitHub Actions）。
> **本项目实际生产环境**采用更轻量的架构：腾讯云 CentOS 7 上由 systemd 守护两个服务——
> `elect-mall-backend`（`php -S 127.0.0.1:8000` 跑 `crmeb/public/adapter.php`）与
> `elect-mall-frontend`（零依赖 Node `deploy/prod-server.cjs` 在 8080/8081 提供静态文件并反向代理），
> 部署目录为 `/root/elect-mall`，数据库 `root/123456`，且服务器无法访问 GitHub，
> 故走「本地构建 → scp 上传 → 覆盖 → systemd 重启」流程。
> **真实部署请直接用 `deploy/deploy-remote.sh`**（脚本头部有完整说明），不要照抄下面的 Nginx / Actions 步骤。

## 系统架构

```
用户浏览器 → Nginx (80/443)
                  ├── /api/* → 反向代理 → PHP-FPM (CRMEB后端 localhost:9000)
                  ├── /admin/* → 反向代理 → PHP-FPM (CRMEB后台)
                  ├── /* → mall-web 静态文件 (dist/)
                  └── /admin-web/* → admin-web 静态文件 (dist/)
```

## 环境要求

| 组件 | 版本要求 |
|------|---------|
| 服务器 | Linux (CentOS 7+ / Ubuntu 20.04+) |
| PHP | 7.1 ~ 8.1 |
| MySQL | 5.7+ (推荐 8.0) |
| Redis | 5.0+ |
| Nginx | 1.18+ |
| Node.js | 18+ (仅构建时需要) |
| Composer | 2.x |

---

## 一、服务器环境搭建

### 1. 安装 PHP + Nginx + MySQL + Redis

**Ubuntu/Debian:**
```bash
# 安装 PHP 8.0 及扩展
sudo apt update
sudo apt install -y nginx php8.0-fpm php8.0-mysql php8.0-curl \
    php8.0-gd php8.0-mbstring php8.0-xml php8.0-bcmath php8.0-zip \
    php8.0-redis php8.0-simplexml mysql-server redis-server composer

# 启动服务
sudo systemctl start nginx php8.0-fpm mysql redis-server
sudo systemctl enable nginx php8.0-fpm mysql redis-server
```

**CentOS/RHEL:**
```bash
# 安装 EPEL 和 Remi 仓库
sudo yum install -y epel-release
sudo yum install -y https://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum install -y --enablerepo=remi-php80 php php-fpm php-mysqlnd \
    php-curl php-gd php-mbstring php-xml php-bcmath php-zip \
    php-redis php-simplexml nginx mysql-server redis composer

sudo systemctl start nginx php-fpm mysqld redis
sudo systemctl enable nginx php-fpm mysqld redis
```

### 2. 配置 MySQL

```bash
mysql -u root -p
```

```sql
CREATE DATABASE IF NOT EXISTS crmeb_mall
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

-- 创建专用用户（推荐）
CREATE USER 'crmeb'@'localhost' IDENTIFIED BY 'your_strong_password';
GRANT ALL PRIVILEGES ON crmeb_mall.* TO 'crmeb'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

---

## 二、部署代码

### 1. 拉取代码

```bash
# 部署目录
mkdir -p /var/www/elect-mall
cd /var/www/elect-mall

# 拉取代码（生产环境用 --depth=1 减少历史记录）
git clone --depth=1 https://github.com/dengzongzong/elect-mall.git .
```

### 2. 构建前端

```bash
# 构建商城前端
cd /var/www/elect-mall/mall-web
npm install
npm run build

# 构建管理后台前端
cd /var/www/elect-mall/admin-web
npm install
npm run build
```

### 3. 安装 PHP 后端依赖

```bash
cd /var/www/elect-mall/crmeb
composer install --no-dev --optimize-autoloader --no-interaction
```

### 4. 配置环境变量

```bash
cd /var/www/elect-mall/crmeb
cp .env .env.production
```

编辑 `.env.production`：

```ini
APP_DEBUG = false

[DATABASE]
TYPE = mysql
HOSTNAME = 127.0.0.1
DATABASE = crmeb_mall
USERNAME = crmeb
PASSWORD = your_strong_password
HOSTPORT = 3306
CHARSET = utf8
PREFIX = eb_

[REDIS]
REDIS_HOSTNAME = 127.0.0.1
REDIS_PORT = 6379
REDIS_PASSWORD =
REDIS_SELECT = 0

[CACHE]
DRIVER = redis

[UPLOAD]
UPLOAD_TYPE = local
```

### 5. 导入数据库

```bash
mysql -u crmeb -p crmeb_mall < /var/www/elect-mall/crmeb/public/install/crmeb.sql
mysql -u crmeb -p crmeb_mall < /var/www/elect-mall/crmeb/crmeb_mall_ext.sql
```

### 6. 设置目录权限

```bash
cd /var/www/elect-mall/crmeb
chmod -R 777 runtime
chmod -R 777 public/uploads
chmod -R 777 crmeb
chmod -R 777 public/install
```

---

## 三、Nginx 配置

### 创建 Nginx 站点配置

`/etc/nginx/sites-available/elect-mall.conf`（Ubuntu）
或 `/etc/nginx/conf.d/elect-mall.conf`（CentOS）

```nginx
server {
    listen 80;
    server_name your-domain.com;  # 替换为你的域名
    root /var/www/elect-mall;
    index index.php index.html;

    # 开启gzip压缩
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml text/javascript image/svg+xml;
    gzip_min_length 1k;
    gzip_vary on;

    # ==========================================
    # 1. CRMEB PHP 后端
    # ==========================================
    location /api/ {
        alias /var/www/elect-mall/crmeb/public/;
        try_files $uri $uri/ /index.php?$query_string;

        location ~ \.php$ {
            fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $request_filename;
            include fastcgi_params;
            fastcgi_param PATH_INFO $fastcgi_path_info;
        }
    }

    # CRMEB 管理后台
    location /admin/ {
        alias /var/www/elect-mall/crmeb/public/;
        try_files $uri $uri/ /index.php?$query_string;

        location ~ \.php$ {
            fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $request_filename;
            include fastcgi_params;
            fastcgi_param PATH_INFO $fastcgi_path_info;
        }
    }

    # ==========================================
    # 2. mall-web 前端（商城首页）
    # ==========================================
    location / {
        root /var/www/elect-mall/mall-web/dist;
        index index.html;
        try_files $uri $uri/ /index.html;
    }

    # ==========================================
    # 3. admin-web 管理后台前端
    # ==========================================
    location /admin-web/ {
        alias /var/www/elect-mall/admin-web/dist/;
        index index.html;
        try_files $uri $uri/ /admin-web/index.html;
    }

    # ==========================================
    # 4. CRMEB 上传文件
    # ==========================================
    location /uploads/ {
        root /var/www/elect-mall/crmeb/public/;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # ==========================================
    # 5. 安全相关
    # ==========================================
    # 隐藏版本号
    server_tokens off;

    # 禁止访问 .env 和 .git 等敏感文件
    location ~ /\.(env|git|htaccess) {
        deny all;
    }

    # 禁止访问 vendor 目录
    location ~ /vendor/ {
        deny all;
    }

    # 禁止访问 runtime 目录
    location ~ /runtime/ {
        deny all;
    }
}
```

### 启用站点

```bash
# Ubuntu
sudo ln -s /etc/nginx/sites-available/elect-mall.conf /etc/nginx/sites-enabled/

# 测试配置并重启
sudo nginx -t
sudo systemctl reload nginx
```

---

## 四、HTTPS 配置（推荐）

### 使用 Let's Encrypt 免费证书

```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com

# 证书自动续期
sudo certbot renew --dry-run
```

### 强制 HTTPS 重定向

在 Nginx 配置中增加：

```nginx
server {
    listen 80;
    server_name your-domain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name your-domain.com;

    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;

    # ... 其余配置同上面 ...
}
```

---

## 五、配置 CRMEB 系统

### 1. 访问后台初始化

访问 `http://your-domain.com/admin`，使用默认管理员登录：

- 账号：`admin`
- 密码：`123456`

### 2. 后台必要配置

登录后台后，完成以下配置：

| 配置项 | 路径 | 说明 |
|--------|------|------|
| 网站名称 | 设置 → 系统设置 → 基础配置 | 修改为商城名称 |
| 上传配置 | 设置 → 系统设置 → 上传配置 | 保持本地存储或配置云存储 |
| 短信配置 | 设置 → 系统设置 → 短信配置 | 用于手机验证码登录 |
| 支付配置 | 设置 → 系统设置 → 支付配置 | 微信支付/支付宝 |

### 3. 添加商品分类和商品

通过后台的「商品管理 → 商品分类」和「商品管理 → 商品列表」添加商品数据。

---

## 六、部署验证

### 检查清单

| 检查项 | 验证方法 | 预期结果 |
|--------|---------|---------|
| PHP 后端 | `curl http://localhost:8000/api/adapter/product/categories` | 返回 JSON 数据 |
| 商城首页 | 浏览器访问 `http://your-domain.com/` | 正常显示商城首页 |
| 管理后台 | 浏览器访问 `http://your-domain.com/admin/` | 显示管理员登录页 |
| CRMEB后台 | 浏览器访问 `http://your-domain.com/admin` | 显示CRMEB管理后台登录页 |
| API 接口 | `curl https://your-domain.com/api/adapter/product/page` | 返回商品列表数据 |

### 常见问题排查

**500 Internal Server Error**
```bash
# 查看 PHP 错误日志
tail -f /var/log/php8.0-fpm.log
tail -f /var/www/elect-mall/crmeb/runtime/log/*.log
```

**404 Not Found**
```bash
# 检查 Nginx 配置是否正确
nginx -t
# 检查目录权限
ls -la /var/www/elect-mall/crmeb/public/
```

**数据库连接失败**
```bash
# 测试数据库连接
mysql -u crmeb -p -h 127.0.0.1 crmeb_mall -e "SELECT 1"
```

---

## 七、部署脚本（一键部署）

`/var/www/elect-mall/deploy.sh`：

```bash
#!/bin/bash
set -e

echo "===== 开始部署 ====="

cd /var/www/elect-mall

# 拉取最新代码
git pull origin master

# 安装 PHP 依赖
cd crmeb
composer install --no-dev --optimize-autoloader --no-interaction

# 清理缓存
rm -rf runtime/cache runtime/log/*.log

# 构建前端
cd ../mall-web
npm install --production
npm run build

cd ../admin-web
npm install --production
npm run build

# 设置权限
cd ..
chmod -R 777 crmeb/runtime
chmod -R 777 crmeb/public/uploads

# 重载 Nginx
sudo nginx -t && sudo systemctl reload nginx

echo "===== 部署完成 ====="
```

```bash
chmod +x /var/www/elect-mall/deploy.sh
```

之后每次更新只需：
```bash
cd /var/www/elect-mall && ./deploy.sh
```

---

## 八、GitHub Actions 自动部署

工作流文件 `.github/workflows/deploy.yml` 已配置完整的 CI/CD 流水线，每次推送代码到 `master` 分支时会自动触发：

### 自动部署流程

```
git push → GitHub Actions
                    ├── Job 1: Build
                    │     ├── 安装 PHP 依赖 (composer install)
                    │     ├── 构建 mall-web (npm run build)
                    │     ├── 构建 admin-web (npm run build)
                    │     └── 上传构建产物 (artifacts)
                    │
                    └── Job 2: Deploy (仅 push 到 master 触发)
                          ├── 下载构建产物
                          ├── SSH 连接到生产服务器
                          ├── 备份当前版本
                          ├── 解压部署新版本
                          ├── 恢复 .env 配置
                          ├── 设置目录权限
                          └── 重载 PHP-FPM / Nginx
```

### 配置 GitHub Secrets

在 GitHub 仓库的 `Settings → Secrets and variables → Actions` 中添加以下 **4 个 Secrets**：

| Secret 名称 | 说明 | 示例 |
|-------------|------|------|
| `SERVER_HOST` | 服务器 IP 或域名 | `123.45.67.89` 或 `shop.yourdomain.com` |
| `SERVER_USER` | SSH 登录用户名 | `root` 或 `ubuntu` |
| `SERVER_SSH_KEY` | SSH 私钥（**不要用公钥**） | 以 `-----BEGIN OPENSSL...` 开头 |
| `SERVER_PATH` | 部署目录（可选，默认 `/var/www/elect-mall`） | `/var/www/elect-mall` |

### 生成 SSH 密钥对

如果还没有 SSH 密钥，在服务器上执行：

```bash
# 在服务器上生成密钥对
ssh-keygen -t ed25519 -f ~/.ssh/github_actions -N ""

# 将公钥添加到 authorized_keys
cat ~/.ssh/github_actions.pub >> ~/.ssh/authorized_keys

# 显示私钥内容（复制到 GitHub Secrets）
cat ~/.ssh/github_actions
```

将输出的私钥内容（含 `-----BEGIN OPENSSH PRIVATE KEY-----`）粘贴到 GitHub Secrets 的 `SERVER_SSH_KEY` 中。

### 测试自动部署

配置完成后，正常推送代码即可触发：

```bash
git add .
git commit -m "feat: xxx"
git push origin master
```

然后到 GitHub 仓库的 `Actions` 标签页查看部署进度。

### 部署状态查看

| 状态 | 含义 |
|------|------|
| ✅ 绿色勾 | 构建+部署成功 |
| ❌ 红色叉 | 部署失败，点击查看日志排查 |
| 🟡 黄色圆圈 | 正在部署中 |

### 常见问题

**SSH 连接失败**
```bash
# 在服务器上检查 SSH 服务状态
sudo systemctl status sshd

# 检查防火墙是否放行 22 端口
sudo ufw status
```

**权限不足**
```bash
# 确保 SSH 用户有 sudo 权限（无密码）
echo "your_user ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/deploy

# 或手动设置目录权限后去掉 sudo 命令
```

**部署目录不存在**
```bash
# 手动创建目录
sudo mkdir -p /var/www/elect-mall
sudo chown -R your_user:your_user /var/www/elect-mall
```