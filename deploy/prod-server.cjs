/**
 * 生产模式静态服务器（零依赖，Node 原生模块）
 *
 * 用途：托管 npm run build 产出的 dist 静态文件，并把 API 请求反向代理到 PHP 后端。
 * 适用于「本地验证生产构建产物」以及「服务器上不使用 nginx 时的简易部署」。
 * 生产环境更推荐用 nginx（见 deploy/nginx/ 下的配置）。
 *
 * 用法：
 *   node deploy/prod-server.cjs --mall 8080 --admin 8081 --backend http://localhost:8000
 *
 * 参数：
 *   --mall <port>      商城前端端口，默认 8080，传 0 表示不启动
 *   --admin <port>     管理后台端口，默认 8081，传 0 表示不启动
 *   --backend <url>    PHP 后端地址，默认 http://localhost:8000
 */

const http = require('http')
const fs = require('fs')
const path = require('path')

const ROOT = path.resolve(__dirname, '..')

function getArg(name, def) {
  const i = process.argv.indexOf(name)
  if (i === -1) return def
  const v = process.argv[i + 1]
  return v === undefined ? def : v
}

const MALL_DIST = path.join(ROOT, 'mall-web', 'dist')
const ADMIN_DIST = path.join(ROOT, 'admin-web', 'dist')
const BACKEND = getArg('--backend', 'http://localhost:8000')
const MALL_PORT = Number(getArg('--mall', 8080))
const ADMIN_PORT = Number(getArg('--admin', 8081))

const MIME = {
  '.html': 'text/html; charset=utf-8',
  '.htm': 'text/html; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.mjs': 'application/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
  '.webp': 'image/webp',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
  '.ttf': 'font/ttf',
  '.eot': 'application/vnd.ms-fontobject',
  '.map': 'application/json; charset=utf-8',
  '.txt': 'text/plain; charset=utf-8',
  '.pdf': 'application/pdf',
}

function send(res, code, body, headers = {}) {
  res.writeHead(code, { 'Cache-Control': 'no-cache', ...headers })
  res.end(body)
}

/** 静态文件服务，找不到时按 spaFallback 回退到 index.html */
function serveStatic(root, urlPath, res, spaFallback) {
  let decoded
  try {
    decoded = decodeURIComponent(urlPath.split('?')[0])
  } catch (e) {
    decoded = urlPath.split('?')[0]
  }

  // 防目录穿越
  const safePath = path.normalize(decoded).replace(/^(\.\.[/\\])+/, '')
  let filePath = path.join(root, safePath)

  if (!filePath.startsWith(root)) {
    return send(res, 403, 'Forbidden', { 'Content-Type': 'text/plain' })
  }

  // 目录路径：尝试其下的 index.html（例如访问 / 时）
  if (fs.existsSync(filePath) && fs.statSync(filePath).isDirectory()) {
    filePath = path.join(filePath, 'index.html')
  }

  if (!fs.existsSync(filePath)) {
    if (spaFallback) {
      filePath = path.join(root, 'index.html')
    } else {
      return send(res, 404, 'Not Found', { 'Content-Type': 'text/plain; charset=utf-8' })
    }
  }

  if (!fs.existsSync(filePath)) {
    return send(res, 404, 'dist 未构建，请先执行 npm run build', {
      'Content-Type': 'text/plain; charset=utf-8',
    })
  }

  const ext = path.extname(filePath).toLowerCase()
  const type = MIME[ext] || 'application/octet-stream'
  fs.readFile(filePath, (err, data) => {
    if (err) return send(res, 500, 'Read Error', { 'Content-Type': 'text/plain' })
    res.writeHead(200, { 'Content-Type': type, 'Cache-Control': 'no-cache' })
    res.end(data)
  })
}

/** 把请求反向代理到 PHP 后端 */
function proxyToBackend(req, res, rewriteFn) {
  const chunks = []
  req.on('data', (c) => chunks.push(c))
  req.on('end', () => {
    const body = Buffer.concat(chunks)
    const targetPath = rewriteFn(req.url)
    const backendUrl = new URL(targetPath, BACKEND)

    const headers = { ...req.headers }
    headers.host = backendUrl.host
    delete headers['accept-encoding']

    const proxyReq = http.request(
      {
        hostname: backendUrl.hostname,
        port: backendUrl.port,
        path: backendUrl.pathname + backendUrl.search,
        method: req.method,
        headers,
      },
      (proxyRes) => {
        res.writeHead(proxyRes.statusCode || 502, proxyRes.headers)
        proxyRes.pipe(res)
      }
    )

    proxyReq.on('error', (err) => {
      send(res, 502, `Backend unreachable (${BACKEND}): ${err.message}`, {
        'Content-Type': 'text/plain; charset=utf-8',
      })
    })

    if (body.length) proxyReq.write(body)
    proxyReq.end()
  })
}

function createServer({ name, root, port, proxyPrefix, rewrite, spaFallback }) {
  const server = http.createServer((req, res) => {
    if (req.url.startsWith(proxyPrefix)) {
      return proxyToBackend(req, res, rewrite)
    }
    serveStatic(root, req.url, res, spaFallback)
  })

  server.listen(port, () => {
    console.log(`[${name}] http://localhost:${port}  ->  ${root}`)
    console.log(`[${name}] API ${proxyPrefix}/*  ->  ${BACKEND}`)
  })

  server.on('error', (err) => {
    console.error(`[${name}] 启动失败: ${err.message}`)
  })
  return server
}

console.log('=== elect-mall 生产模式启动 ===')
console.log(`后端地址: ${BACKEND}`)
if (!fs.existsSync(path.join(MALL_DIST, 'index.html'))) {
  console.warn('[warn] mall-web/dist 不存在，请先执行: cd mall-web && npm run build')
}
if (!fs.existsSync(path.join(ADMIN_DIST, 'index.html'))) {
  console.warn('[warn] admin-web/dist 不存在，请先执行: cd admin-web && npm run build')
}

if (MALL_PORT) {
  createServer({
    name: 'mall-web ',
    root: MALL_DIST,
    port: MALL_PORT,
    proxyPrefix: '/api/',
    rewrite: (u) => u.replace(/^\/api\//, '/api/adapter/'),
    spaFallback: false, // hash 路由，无需 fallback
  })
}

if (ADMIN_PORT) {
  createServer({
    name: 'admin-web',
    root: ADMIN_DIST,
    port: ADMIN_PORT,
    proxyPrefix: '/admin/',
    rewrite: (u) => u.replace(/^\/admin\//, '/admin/adapter/'),
    spaFallback: true, // history 路由，需回退到 index.html
  })
}
