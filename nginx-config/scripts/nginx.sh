#!/usr/bin/env bash
# Nginx Config Generator — generates real nginx configuration files
# Usage: nginx.sh <command> [options]

set -euo pipefail

CMD="${1:-help}"; shift 2>/dev/null || true

# Parse flags into variables
parse_args() {
    DOMAIN="" BACKEND="" ROOT="" PORT="80" SSL_PORT="443"
    CERT_PATH="/etc/letsencrypt/live" WORKERS="auto"
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --domain)   DOMAIN="$2"; shift 2 ;;
            --backend)  BACKEND="$2"; shift 2 ;;
            --root)     ROOT="$2"; shift 2 ;;
            --port)     PORT="$2"; shift 2 ;;
            --ssl-port) SSL_PORT="$2"; shift 2 ;;
            --cert)     CERT_PATH="$2"; shift 2 ;;
            --workers)  WORKERS="$2"; shift 2 ;;
            *) shift ;;
        esac
    done
}

parse_args "$@"

gen_reverse_proxy() {
    local domain="${DOMAIN:-example.com}"
    local backend="${BACKEND:-localhost:3000}"
    cat <<NGINX
# ============================================
# Nginx Reverse Proxy Configuration
# Domain: ${domain}
# Backend: ${backend}
# Generated: $(date '+%Y-%m-%d %H:%M:%S')
# ============================================

upstream backend_pool {
    server ${backend};
    # 如需负载均衡，添加更多 server：
    # server localhost:3001;
    # server localhost:3002;
    keepalive 64;
}

server {
    listen 80;
    listen [::]:80;
    server_name ${domain} www.${domain};

    # 重定向到 HTTPS（如果启用了 SSL 取消注释）
    # return 301 https://\$host\$request_uri;

    # 访问日志
    access_log /var/log/nginx/${domain}.access.log;
    error_log  /var/log/nginx/${domain}.error.log;

    # 安全头
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # 反向代理
    location / {
        proxy_pass http://backend_pool;
        proxy_http_version 1.1;

        # WebSocket 支持
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";

        # 传递真实客户端信息
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        # 超时设置
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;

        # 缓冲设置
        proxy_buffering on;
        proxy_buffer_size 4k;
        proxy_buffers 8 4k;
    }

    # 静态文件缓存（可选）
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|woff2?|ttf|svg)$ {
        proxy_pass http://backend_pool;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # 健康检查端点
    location /health {
        proxy_pass http://backend_pool;
        access_log off;
    }

    # 禁止访问隐藏文件
    location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
    }
}
NGINX
}

gen_ssl() {
    local domain="${DOMAIN:-example.com}"
    local backend="${BACKEND:-localhost:3000}"
    local cert_path="${CERT_PATH}/live/${domain}"
    cat <<NGINX
# ============================================
# Nginx SSL/HTTPS Configuration
# Domain: ${domain}
# Generated: $(date '+%Y-%m-%d %H:%M:%S')
# ============================================
# 先用 certbot 获取证书：
#   sudo certbot certonly --nginx -d ${domain} -d www.${domain}

# HTTP → HTTPS 重定向
server {
    listen 80;
    listen [::]:80;
    server_name ${domain} www.${domain};
    return 301 https://\$host\$request_uri;
}

# HTTPS 主配置
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name ${domain} www.${domain};

    # SSL 证书
    ssl_certificate     ${cert_path}/fullchain.pem;
    ssl_certificate_key ${cert_path}/privkey.pem;
    ssl_trusted_certificate ${cert_path}/chain.pem;

    # SSL 协议和加密套件（现代配置）
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;

    # SSL 会话缓存
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:50m;
    ssl_session_tickets off;

    # OCSP Stapling
    ssl_stapling on;
    ssl_stapling_verify on;
    resolver 8.8.8.8 8.8.4.4 valid=300s;
    resolver_timeout 5s;

    # HSTS（严格传输安全）
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;

    # 安全头
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;

    # 日志
    access_log /var/log/nginx/${domain}.ssl.access.log;
    error_log  /var/log/nginx/${domain}.ssl.error.log;

    # 反向代理（如有后端）
    location / {
        proxy_pass http://${backend};
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    # 禁止访问隐藏文件
    location ~ /\. {
        deny all;
    }
}
NGINX
}

gen_static() {
    local domain="${DOMAIN:-example.com}"
    local root="${ROOT:-/var/www/html}"
    cat <<NGINX
# ============================================
# Nginx Static File Server
# Domain: ${domain}
# Root: ${root}
# Generated: $(date '+%Y-%m-%d %H:%M:%S')
# ============================================

server {
    listen ${PORT};
    listen [::]:${PORT};
    server_name ${domain};

    root ${root};
    index index.html index.htm;

    # 字符集
    charset utf-8;

    # 日志
    access_log /var/log/nginx/${domain}.access.log;
    error_log  /var/log/nginx/${domain}.error.log;

    # Gzip 压缩
    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_min_length 1000;
    gzip_types
        text/plain
        text/css
        text/javascript
        application/javascript
        application/json
        application/xml
        image/svg+xml
        font/woff2;

    # 主页面 — 尝试文件 → 目录 → 404
    location / {
        try_files \$uri \$uri/ =404;
    }

    # 静态资源缓存
    location ~* \.(jpg|jpeg|png|gif|ico|webp|avif)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
        access_log off;
    }

    location ~* \.(css|js)$ {
        expires 7d;
        add_header Cache-Control "public";
    }

    location ~* \.(woff2?|ttf|otf|eot|svg)$ {
        expires 30d;
        add_header Cache-Control "public";
        add_header Access-Control-Allow-Origin "*";
    }

    # SPA 回退（Vue/React 等前端项目取消注释）
    # location / {
    #     try_files \$uri \$uri/ /index.html;
    # }

    # 安全：禁止访问隐藏文件和备份文件
    location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
    }
    location ~* \.(bak|swp|old|orig)$ {
        deny all;
    }

    # 自定义错误页
    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }
}
NGINX
}

gen_security() {
    cat <<'NGINX'
# ============================================
# Nginx 安全加固配置
# 放入 /etc/nginx/conf.d/security.conf
# 或 include 到主配置中
# ============================================

# ---- 全局安全设置 ----

# 隐藏 Nginx 版本号
server_tokens off;

# 防止点击劫持
add_header X-Frame-Options "SAMEORIGIN" always;

# 防止 MIME 类型嗅探
add_header X-Content-Type-Options "nosniff" always;

# XSS 保护
add_header X-XSS-Protection "1; mode=block" always;

# 引用策略
add_header Referrer-Policy "strict-origin-when-cross-origin" always;

# 内容安全策略（按需调整）
add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' data:; connect-src 'self' https:; frame-ancestors 'self';" always;

# 权限策略
add_header Permissions-Policy "camera=(), microphone=(), geolocation=(), payment=()" always;

# ---- 请求限制 ----

# 限制请求体大小（防大文件攻击）
client_max_body_size 10m;

# 限制缓冲区大小（防缓冲区溢出攻击）
client_body_buffer_size 1k;
client_header_buffer_size 1k;
large_client_header_buffers 4 8k;

# 超时设置（防慢速攻击）
client_body_timeout 10;
client_header_timeout 10;
send_timeout 10;
keepalive_timeout 65;

# ---- 速率限制 ----

# 在 http 块中定义（放 nginx.conf 的 http{} 中）
# limit_req_zone $binary_remote_addr zone=general:10m rate=10r/s;
# limit_req_zone $binary_remote_addr zone=login:10m rate=3r/m;
# limit_conn_zone $binary_remote_addr zone=addr:10m;

# 在 server/location 中使用：
# limit_req zone=general burst=20 nodelay;
# limit_req zone=login burst=3 nodelay;
# limit_conn addr 10;

# ---- 禁止危险访问 ----

# 禁止访问隐藏文件（.git, .env 等）
location ~ /\. {
    deny all;
    access_log off;
    log_not_found off;
}

# 禁止访问备份和临时文件
location ~* \.(bak|config|sql|fla|psd|ini|log|sh|inc|swp|dist|old|orig)$ {
    deny all;
    access_log off;
    log_not_found off;
}

# 禁止访问 WordPress xmlrpc（如果不用 WordPress 可删除）
# location = /xmlrpc.php {
#     deny all;
# }

# ---- IP 黑名单示例 ----
# deny 192.168.1.100;
# deny 10.0.0.0/8;

# ---- SSL 安全配置（如果启用 HTTPS）----
# ssl_protocols TLSv1.2 TLSv1.3;
# ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384;
# ssl_prefer_server_ciphers off;
# ssl_session_timeout 1d;
# ssl_session_cache shared:SSL:50m;
# ssl_session_tickets off;
# ssl_stapling on;
# ssl_stapling_verify on;
NGINX
}

gen_load_balancer() {
    local domain="${DOMAIN:-example.com}"
    cat <<NGINX
# ============================================
# Nginx 负载均衡配置
# Domain: ${domain}
# Generated: $(date '+%Y-%m-%d %H:%M:%S')
# ============================================

upstream app_cluster {
    # 负载均衡策略：
    # (默认) 轮询 round-robin
    # least_conn;    # 最少连接
    # ip_hash;       # IP 哈希（会话保持）
    # hash \$request_uri consistent;  # URI 一致性哈希

    server 127.0.0.1:3001 weight=3;
    server 127.0.0.1:3002 weight=2;
    server 127.0.0.1:3003 weight=1;
    server 127.0.0.1:3004 backup;  # 备用服务器

    keepalive 32;
}

server {
    listen 80;
    server_name ${domain};

    location / {
        proxy_pass http://app_cluster;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        # 健康检查 — 失败3次后标记为不可用，30秒后重试
        proxy_next_upstream error timeout http_500 http_502 http_503;
        proxy_next_upstream_tries 3;
    }

    # 健康检查端点
    location /health {
        proxy_pass http://app_cluster;
        access_log off;
    }
}
NGINX
}

case "$CMD" in
    reverse-proxy|proxy)
        gen_reverse_proxy ;;
    ssl|https)
        gen_ssl ;;
    static|serve)
        gen_static ;;
    security|harden)
        gen_security ;;
    load-balancer|lb)
        gen_load_balancer ;;
    *)
        cat <<'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🔧 Nginx Config Generator — 使用指南
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  命令                 说明
  ─────────────────────────────────────────
  reverse-proxy        反向代理配置
    --domain NAME        域名 (默认: example.com)
    --backend HOST:PORT  后端地址 (默认: localhost:3000)

  ssl                  SSL/HTTPS 配置
    --domain NAME        域名
    --backend HOST:PORT  后端地址
    --cert PATH          证书路径

  static               静态文件服务器
    --domain NAME        域名
    --root PATH          网站根目录 (默认: /var/www/html)
    --port NUM           监听端口 (默认: 80)

  security             安全加固配置（直接输出）

  load-balancer        负载均衡配置
    --domain NAME        域名

  示例：
    nginx.sh reverse-proxy --domain mysite.com --backend localhost:8080
    nginx.sh ssl --domain mysite.com
    nginx.sh static --root /var/www/mysite --domain mysite.com
    nginx.sh security
    nginx.sh load-balancer --domain api.mysite.com
EOF
        ;;
esac
