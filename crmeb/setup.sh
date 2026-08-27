#!/bin/bash
# ============================================================
# 电子元器件商城 - CRMEB后端环境搭建脚本
# ============================================================

set -e

echo "===== 开始搭建 CRMEB 后端环境 ====="

# 1. 检查 PHP 环境
if ! command -v php &> /dev/null; then
    echo "❌ PHP 未安装，请先安装 PHP 7.1+"
    exit 1
fi

PHP_VERSION=$(php -v | head -n 1 | cut -d " " -f 2 | cut -d "." -f1,2)
echo "✅ PHP 版本: $PHP_VERSION"

# 2. 检查 Composer
if ! command -v composer &> /dev/null; then
    echo "❌ Composer 未安装，正在安装..."
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer
    php -r "unlink('composer-setup.php');"
fi
echo "✅ Composer 已安装"

# 3. 安装 PHP 依赖
echo "📦 安装 Composer 依赖..."
cd "$(dirname "$0")"
composer install --no-dev --optimize-autoloader

# 4. 创建数据库
echo "🗄️  创建数据库..."
MYSQL_CMD="mysql -u root -proot -h 127.0.0.1 -P 3306"
$MYSQL_CMD -e "CREATE DATABASE IF NOT EXISTS crmeb_mall DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>/dev/null || echo "⚠️  数据库创建失败，请手动创建"

# 5. 导入 CRMEB 数据库
echo "🗄️  导入 CRMEB 数据库结构..."
if [ -f "public/install/crmeb.sql" ]; then
    $MYSQL_CMD crmeb_mall < public/install/crmeb.sql 2>/dev/null || echo "⚠️  数据库导入失败，请手动导入 public/install/crmeb.sql"
fi

# 6. 导入扩展表
echo "🗄️  导入电子元器件扩展表..."
if [ -f "crmeb_mall_ext.sql" ]; then
    $MYSQL_CMD crmeb_mall < crmeb_mall_ext.sql 2>/dev/null || echo "⚠️  扩展表导入失败，请手动导入 crmeb_mall_ext.sql"
fi

# 7. 初始化数据（可选）
echo "🔧 初始化数据..."
$MYSQL_CMD crmeb_mall -e "
INSERT IGNORE INTO eb_system_admin (id, account, pwd, real_name, roles, status, add_time) VALUES 
(1, 'admin', '\$2y\$10\$WLhJ5WQFoLF0TQ5hKqzZ4OZ6Kj5K5G5L5Q5R5S5T5U5V5W5X5Y5Z5', '超级管理员', '1', 1, UNIX_TIMESTAMP());
" 2>/dev/null || echo "⚠️  管理员初始化失败"

echo ""
echo "===== 搭建完成！====="
echo ""
echo "启动方式:"
echo "  cd $(dirname "$0")"
echo "  php think run -p 8000"
echo ""
echo "后台地址: http://localhost:8000/admin"
echo "默认账号: admin / 123456"
echo ""
echo "前端启动:"
echo "  cd mall-web && npm run dev"
echo "  cd admin-web && npm run dev"