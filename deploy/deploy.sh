#!/usr/bin/env bash
# =============================================================
#  elect-mall 一键部署脚本（Linux 服务器）
#
#  用法：
#    chmod +x deploy/deploy.sh
#    sudo APP_DIR=/var/www/elect-mall ./deploy/deploy.sh
#
#  前置条件（首次部署需先手工完成，见 DEPLOY.md）：
#    1. 已安装 nginx、php(>=7.4)、mysql(>=8.0)、node(>=18)
#    2. 已创建数据库并导入 install.sql
#    3. 已放置 nginx 配置与 systemd 服务
# =============================================================
set -euo pipefail

APP_DIR="${APP_DIR:-/var/www/elect-mall}"
NGINX_SITE="${NGINX_SITE:-/etc/nginx/sites-available/elect-mall.conf}"
NGINX_ENABLED="/etc/nginx/sites-enabled/elect-mall.conf"
BACKEND_SERVICE="${BACKEND_SERVICE:-elect-mall-backend}"

log() { echo -e "\n==> $*"; }

if [ ! -d "$APP_DIR" ]; then
  echo "错误：目录 $APP_DIR 不存在。请先克隆代码，或用 APP_DIR=... 指定正确路径。"
  exit 1
fi

cd "$APP_DIR"

log "1/5 拉取最新代码"
git pull || echo "（跳过 git pull，非 git 目录或无更新）"

log "2/5 构建商城前端 mall-web"
cd "$APP_DIR/mall-web"
npm install
npm run build
echo "    产物：$APP_DIR/mall-web/dist"

log "3/5 构建管理后台 admin-web"
cd "$APP_DIR/admin-web"
npm install
npm run build
echo "    产物：$APP_DIR/admin-web/dist"

log "4/5 安装/校验 nginx 配置"
if [ -f "$APP_DIR/deploy/nginx/elect-mall.conf" ] && [ -d "$(dirname "$NGINX_SITE")" ]; then
  if [ ! -f "$NGINX_SITE" ]; then
    cp "$APP_DIR/deploy/nginx/elect-mall.conf" "$NGINX_SITE"
    ln -sf "$NGINX_SITE" "$NGINX_ENABLED"
    echo "    已安装 nginx 配置（请记得替换配置里的域名与路径后 reload）"
  else
    echo "    nginx 配置已存在，未覆盖：$NGINX_SITE"
  fi
  nginx -t && echo "    nginx 配置校验通过"
else
  echo "    跳过（未找到 nginx 配置目录）"
fi

log "5/5 重载服务"
if command -v systemctl >/dev/null 2>&1; then
  systemctl reload nginx 2>/dev/null || echo "    nginx 未运行，请手动启动"
  if systemctl list-unit-files | grep -q "$BACKEND_SERVICE"; then
    systemctl restart "$BACKEND_SERVICE"
    echo "    已重启后端 $BACKEND_SERVICE"
  else
    echo "    未找到后端服务 $BACKEND_SERVICE，若用 php -S 请自行重启"
  fi
fi

log "部署完成"
echo "  商城：http://你的商城域名"
echo "  后台：http://你的后台域名"
echo ""
echo "若页面样式/接口异常，检查："
echo "  1) nginx 配置里的 root 路径是否指向 */dist"
echo "  2) 后端是否存活：curl http://127.0.0.1:8000/api/adapter/product/categories"
echo "  3) 浏览器 F12 看 /api、/admin 请求是否 502"
