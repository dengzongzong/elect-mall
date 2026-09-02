#!/usr/bin/env bash
# =============================================================
#  elect-mall 真实生产环境部署脚本（在开发者本地机器运行）
#
#  ⚠️ 重要：本脚本对应的是「项目实际生产环境」，与仓库根目录
#  DEPLOY.md 里描述的 Nginx + php-fpm + GitHub Actions 通用方案不同。
#
#  实际架构（腾讯云 CentOS 7，部署目录 /root/elect-mall）：
#    - elect-mall-backend  : systemd 守护 `php -S 127.0.0.1:8000 adapter.php`
#                            （单文件 PHP 后端，仅本机，库 root/123456）
#    - elect-mall-frontend : systemd 守护零依赖 Node
#                            `deploy/prod-server.cjs`，监听 8080(商城)/8081(后台)，
#                            并把 /api/* 代理到 :8000/api/adapter/、
#                            /admin/* 代理到 :8000/admin/adapter/
#  服务器无法访问 GitHub，故采用「本地构建 → scp 上传 → 覆盖 → systemd 重启」。
#  systemd 的 Restart=always 只负责进程挂掉后自动拉起，代码更新必须手动 restart。
#
#  用法（需本地装有 node>=16 / npm，并已配好到服务器的 SSH 密钥登录）：
#    bash deploy/deploy-remote.sh                # 构建前端 + 上传 + 重启 frontend
#    bash deploy/deploy-remote.sh --backend      # 同时重启 backend（仅改了 adapter.php 时加）
#    SKIP_BUILD=1   bash deploy/deploy-remote.sh # 跳过前端构建（dist 已是最新）
#    SKIP_INSTALL=1 bash deploy/deploy-remote.sh # 不执行 npm install（依赖已装好）
#
#  可通过环境变量覆盖连接信息：
#    SERVER_HOST / SERVER_USER / SERVER_PORT / REMOTE_DIR
# =============================================================
set -euo pipefail

# ---------- 可配置变量 ----------
SERVER_HOST="${SERVER_HOST:-134.175.246.242}"
SERVER_USER="${SERVER_USER:-root}"
SERVER_PORT="${SERVER_PORT:-22}"
REMOTE_DIR="${REMOTE_DIR:-/root/elect-mall}"
# 注意：ssh 用 -p 指定端口，但 scp 的端口参数是大写 -P；
# 为让同一组参数在 ssh 与 scp 下都正确，统一用 -o Port= （两者都识别）。
SSH_OPTS=(-o StrictHostKeyChecking=no -o ConnectTimeout=10 -o Port="$SERVER_PORT")

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"   # 代码根目录

WITH_BACKEND=0
SKIP_BUILD="${SKIP_BUILD:-0}"
SKIP_INSTALL="${SKIP_INSTALL:-0}"
for a in "$@"; do
  case "$a" in
    --backend)      WITH_BACKEND=1 ;;
    --skip-build)   SKIP_BUILD=1 ;;
    --skip-install) SKIP_INSTALL=1 ;;
  esac
done

TARBALL="/tmp/elect-mall-deploy-$(date +%Y%m%d-%H%M%S).tar.gz"
REMOTE_TARBALL="/tmp/$(basename "$TARBALL")"

log() { echo -e "\n==> $*"; }
die() { echo "错误：$*" >&2; exit 1; }

# ---------- 1. 本地构建前端 ----------
build_frontend() {
  local dir="$1"
  if [ "$SKIP_BUILD" = "1" ]; then
    echo "    跳过构建：$dir（SKIP_BUILD=1）"
    [ -d "$LOCAL_DIR/$dir/dist" ] || die "$dir/dist 不存在，不能跳过构建"
    return
  fi
  log "构建前端：$dir"
  ( cd "$LOCAL_DIR/$dir" && rm -rf dist && \
    { [ "$SKIP_INSTALL" = "1" ] || npm install; } && \
    npm run build ) || die "$dir 构建失败"
  [ -f "$LOCAL_DIR/$dir/dist/index.html" ] || die "$dir 构建后未发现 dist/index.html"
}

build_frontend mall-web
build_frontend admin-web

# ---------- 2. 打包最小部署集（不传 node_modules / crmeb 框架本体） ----------
log "打包最小部署集 -> $TARBALL"
( cd "$LOCAL_DIR" && tar czf "$TARBALL" \
    crmeb/public/adapter.php \
    mall-web/dist \
    admin-web/dist \
    deploy/prod-server.cjs \
    mall_db_schema.sql install.sql ) || die "打包失败"
echo "    产物大小：$(du -h "$TARBALL" | cut -f1)"

# ---------- 3. 上传并覆盖到服务器 ----------
log "上传到 ${SERVER_USER}@${SERVER_HOST}:/tmp/"
scp "${SSH_OPTS[@]}" "$TARBALL" "${SERVER_USER}@${SERVER_HOST}:${REMOTE_TARBALL}" || die "上传失败"

log "在服务器解压覆盖到 $REMOTE_DIR"
ssh "${SSH_OPTS[@]}" "${SERVER_USER}@${SERVER_HOST}" \
  "cd '$REMOTE_DIR' && tar xzf '$REMOTE_TARBALL' && rm -f '$REMOTE_TARBALL'" || die "解压覆盖失败"

# ---------- 4. 重启 systemd 服务 ----------
log "重启 systemd 服务"
ssh "${SSH_OPTS[@]}" "${SERVER_USER}@${SERVER_HOST}" 'systemctl restart elect-mall-frontend' \
  || die "重启 frontend 失败"
if [ "$WITH_BACKEND" = "1" ]; then
  ssh "${SSH_OPTS[@]}" "${SERVER_USER}@${SERVER_HOST}" 'systemctl restart elect-mall-backend' \
    || die "重启 backend 失败"
  echo "    （已同时重启 backend：本次改动了 adapter.php）"
else
  echo "    未重启 backend（若改了 crmeb/public/adapter.php，请加 --backend 重新运行）"
fi

# ---------- 5. 验证 ----------
log "验证服务存活"
sleep 2
ssh "${SSH_OPTS[@]}" "${SERVER_USER}@${SERVER_HOST}" \
  'systemctl is-active elect-mall-frontend elect-mall-backend' || true
MALL=$(curl -s -o /dev/null -w '%{http_code}' --max-time 8 "http://${SERVER_HOST}:8080/" || echo 000)
ADMIN=$(curl -s -o /dev/null -w '%{http_code}' --max-time 8 "http://${SERVER_HOST}:8081/" || echo 000)
echo "    商城(8080): $MALL    后台(8081): $ADMIN"

log "部署完成 ✅"
echo "  商城：http://${SERVER_HOST}:8080/"
echo "  后台：http://${SERVER_HOST}:8081/   (账号 admin / Admin@123456)"
