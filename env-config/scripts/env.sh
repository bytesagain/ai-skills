#!/usr/bin/env bash
# Env Config — .env file manager and generator
# Usage: env.sh <command> [options]

set -euo pipefail

CMD="${1:-help}"; shift 2>/dev/null || true

# Parse flags
PROJECT="node" FILE=".env" OUTPUT="" KEY="" VALUE=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --project)  PROJECT="$2"; shift 2 ;;
        --file)     FILE="$2"; shift 2 ;;
        --output)   OUTPUT="$2"; shift 2 ;;
        --key)      KEY="$2"; shift 2 ;;
        --value)    VALUE="$2"; shift 2 ;;
        *) shift ;;
    esac
done

gen_init() {
    case "$PROJECT" in
        node|express|nodejs)
            cat <<'ENV'
# ============================================
# Node.js / Express 环境变量
# 复制为 .env 使用，切勿提交到 Git！
# ============================================

# ---- 应用配置 ----
NODE_ENV=development
PORT=3000
HOST=0.0.0.0
APP_NAME=my-app
APP_URL=http://localhost:3000
LOG_LEVEL=debug

# ---- 数据库 ----
DB_HOST=localhost
DB_PORT=5432
DB_NAME=myapp_dev
DB_USER=postgres
DB_PASSWORD=changeme
DB_SSL=false
# DATABASE_URL=postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}

# ---- Redis ----
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=
# REDIS_URL=redis://localhost:6379

# ---- JWT / 认证 ----
JWT_SECRET=change-this-to-a-random-64-char-string
JWT_EXPIRES_IN=7d
REFRESH_TOKEN_EXPIRES_IN=30d

# ---- 邮件 ----
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=
SMTP_PASSWORD=
SMTP_FROM=noreply@example.com

# ---- 存储 (S3/OSS) ----
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_REGION=us-east-1
AWS_S3_BUCKET=

# ---- 第三方 API ----
OPENAI_API_KEY=
STRIPE_SECRET_KEY=
STRIPE_WEBHOOK_SECRET=

# ---- CORS ----
CORS_ORIGINS=http://localhost:3000,http://localhost:5173

# ---- 速率限制 ----
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX=100
ENV
            ;;
        python|django|flask|fastapi)
            cat <<'ENV'
# ============================================
# Python (Django/Flask/FastAPI) 环境变量
# 复制为 .env 使用
# ============================================

# ---- 应用配置 ----
APP_ENV=development
DEBUG=True
SECRET_KEY=change-this-to-a-random-secret-key
ALLOWED_HOSTS=localhost,127.0.0.1

# ---- 数据库 ----
DB_ENGINE=django.db.backends.postgresql
DB_NAME=myapp_dev
DB_USER=postgres
DB_PASSWORD=changeme
DB_HOST=localhost
DB_PORT=5432
DATABASE_URL=postgresql://postgres:changeme@localhost:5432/myapp_dev

# ---- Redis ----
REDIS_URL=redis://localhost:6379/0
CELERY_BROKER_URL=redis://localhost:6379/1

# ---- 邮件 ----
EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=
EMAIL_HOST_PASSWORD=

# ---- 存储 ----
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_STORAGE_BUCKET_NAME=
AWS_S3_REGION_NAME=us-east-1

# ---- API Keys ----
OPENAI_API_KEY=
SENTRY_DSN=

# ---- CORS ----
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080
ENV
            ;;
        react|vue|vite|nextjs|nuxt)
            cat <<'ENV'
# ============================================
# 前端项目 (React/Vue/Next.js/Nuxt) 环境变量
# VITE_* 或 NEXT_PUBLIC_* 前缀暴露给浏览器
# ============================================

# ---- 应用配置 ----
# Vite 项目用 VITE_ 前缀
VITE_APP_TITLE=My App
VITE_APP_VERSION=1.0.0

# Next.js 项目用 NEXT_PUBLIC_ 前缀
# NEXT_PUBLIC_APP_TITLE=My App

# ---- API 配置 ----
VITE_API_BASE_URL=http://localhost:3000/api
VITE_API_TIMEOUT=10000

# ---- 认证 ----
VITE_AUTH_DOMAIN=
VITE_AUTH_CLIENT_ID=

# ---- 分析/监控 ----
VITE_GA_TRACKING_ID=
VITE_SENTRY_DSN=

# ---- 功能开关 ----
VITE_FEATURE_DARK_MODE=true
VITE_FEATURE_I18N=false

# ---- 构建配置（不暴露给浏览器）----
GENERATE_SOURCEMAP=false
ANALYZE=false
ENV
            ;;
        go|golang)
            cat <<'ENV'
# ============================================
# Go 项目环境变量
# ============================================

# ---- 应用 ----
APP_ENV=development
APP_PORT=8080
APP_HOST=0.0.0.0
APP_DEBUG=true
APP_NAME=myapp

# ---- 数据库 ----
DB_DRIVER=postgres
DB_HOST=localhost
DB_PORT=5432
DB_NAME=myapp_dev
DB_USER=postgres
DB_PASSWORD=changeme
DB_SSLMODE=disable
DB_MAX_CONNS=25
DB_MAX_IDLE_CONNS=5

# ---- Redis ----
REDIS_ADDR=localhost:6379
REDIS_PASSWORD=
REDIS_DB=0

# ---- JWT ----
JWT_SECRET=change-me
JWT_EXPIRY=24h

# ---- 日志 ----
LOG_LEVEL=debug
LOG_FORMAT=json
ENV
            ;;
        docker|compose)
            cat <<'ENV'
# ============================================
# Docker Compose 环境变量
# ============================================

# ---- 项目 ----
COMPOSE_PROJECT_NAME=myproject
COMPOSE_FILE=docker-compose.yml

# ---- 应用 ----
APP_PORT=3000
APP_ENV=production

# ---- 数据库 ----
POSTGRES_USER=postgres
POSTGRES_PASSWORD=changeme
POSTGRES_DB=myapp
POSTGRES_PORT=5432

# ---- Redis ----
REDIS_PORT=6379
REDIS_PASSWORD=

# ---- Nginx ----
NGINX_PORT=80
NGINX_SSL_PORT=443

# ---- 日志 ----
LOG_DRIVER=json-file
LOG_MAX_SIZE=10m
LOG_MAX_FILE=3
ENV
            ;;
        *)
            cat <<ENV
# ============================================
# 通用环境变量模板
# 项目类型: ${PROJECT}
# ============================================

APP_ENV=development
APP_PORT=3000
APP_SECRET=change-this-secret

DB_HOST=localhost
DB_PORT=5432
DB_NAME=myapp
DB_USER=root
DB_PASSWORD=changeme

REDIS_URL=redis://localhost:6379
LOG_LEVEL=debug
ENV
            ;;
    esac
}

gen_gitignore() {
    cat <<'GITIGNORE'
# ---- 环境变量文件 ----
.env
.env.local
.env.*.local
.env.development
.env.production
.env.staging

# 保留示例文件
!.env.example
!.env.sample
GITIGNORE
}

validate_env() {
    local file="${FILE:-.env}"
    if [[ ! -f "$file" ]]; then
        echo "❌ 文件不存在: $file"
        exit 1
    fi

    local errors=0
    local warnings=0
    local line_num=0
    local keys=()

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  🔍 验证 .env 文件: $file"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    while IFS= read -r line || [[ -n "$line" ]]; do
        line_num=$((line_num + 1))

        # Skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

        # Check format: KEY=VALUE
        if ! echo "$line" | grep -qE '^[A-Za-z_][A-Za-z0-9_]*=' 2>/dev/null; then
            echo "❌ 第${line_num}行: 格式错误 → $line"
            errors=$((errors + 1))
            continue
        fi

        local key="${line%%=*}"
        local value="${line#*=}"

        # Check duplicate keys
        local existing_key
        for existing_key in "${keys[@]+"${keys[@]}"}"; do
            if [[ "$existing_key" == "$key" ]]; then
                echo "⚠️  第${line_num}行: 重复的键 → $key"
                warnings=$((warnings + 1))
            fi
        done
        keys+=("$key")

        # Check empty values
        if [[ -z "$value" ]]; then
            echo "⚠️  第${line_num}行: 空值 → $key"
            warnings=$((warnings + 1))
        fi

        # Check common security issues
        case "$key" in
            *PASSWORD*|*SECRET*|*KEY*|*TOKEN*)
                if [[ "$value" == "changeme" || "$value" == "password" || "$value" == "123456" || "$value" == "secret" ]]; then
                    echo "🔐 第${line_num}行: 不安全的默认值 → $key=$value"
                    warnings=$((warnings + 1))
                fi
                ;;
        esac

    done < "$file"

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  📊 结果: ${line_num}行 | ❌ ${errors}个错误 | ⚠️ ${warnings}个警告"
    if [[ $errors -eq 0 && $warnings -eq 0 ]]; then
        echo "  ✅ 文件格式正确！"
    fi
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

encrypt_env() {
    local file="${FILE:-.env}"
    if [[ ! -f "$file" ]]; then
        echo "❌ 文件不存在: $file"
        exit 1
    fi
    echo "# ============================================"
    echo "# Base64 编码 — ${file}"
    echo "# 用 env.sh decrypt --file <file> 解码"
    echo "# 注意：Base64 不是加密，仅做简单混淆！"
    echo "# ============================================"
    base64 < "$file"
    echo ""
    echo "# ✅ 已编码 $(wc -l < "$file") 行"
}

decrypt_env() {
    local file="${FILE:-.env}"
    if [[ ! -f "$file" ]]; then
        echo "❌ 文件不存在: $file"
        exit 1
    fi
    # Strip comment lines, then decode
    grep -v '^#' "$file" | base64 -d 2>/dev/null || {
        echo "❌ 解码失败：文件可能不是有效的 Base64 编码"
        exit 1
    }
}

gen_compare() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  📋 .env vs .env.example 对比"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    local env_file=".env"
    local example_file=".env.example"

    [[ -f "$env_file" ]] || { echo "❌ 缺少 .env"; exit 1; }
    [[ -f "$example_file" ]] || { echo "❌ 缺少 .env.example"; exit 1; }

    # Extract keys
    local env_keys example_keys
    env_keys=$(grep -E '^[A-Za-z_]' "$env_file" | cut -d= -f1 | sort)
    example_keys=$(grep -E '^[A-Za-z_]' "$example_file" | cut -d= -f1 | sort)

    echo ""
    echo "🔑 .env.example 中有但 .env 中缺少的键："
    comm -23 <(echo "$example_keys") <(echo "$env_keys") | while read -r key; do
        echo "  ⚠️  $key"
    done || echo "  ✅ 无缺失"

    echo ""
    echo "➕ .env 中有但 .env.example 中没有的键："
    comm -13 <(echo "$example_keys") <(echo "$env_keys") | while read -r key; do
        echo "  ℹ️  $key"
    done || echo "  ✅ 无多余"
}

case "$CMD" in
    init|generate|gen)
        gen_init ;;
    validate|check|lint)
        validate_env ;;
    encrypt|encode)
        encrypt_env ;;
    decrypt|decode)
        decrypt_env ;;
    gitignore)
        gen_gitignore ;;
    compare|diff)
        gen_compare ;;
    *)
        cat <<'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ⚙️ Env Config — .env 文件管理工具
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  命令                说明
  ──────────────────────────────────────────
  init               生成 .env 模板
    --project TYPE     项目类型:
                       node, python, react, vue, go, docker
                       (默认: node)

  validate           验证 .env 文件格式
    --file PATH        文件路径 (默认: .env)

  encrypt            Base64 编码 .env 文件
    --file PATH        文件路径

  decrypt            Base64 解码还原
    --file PATH        文件路径

  gitignore          生成 .gitignore 片段

  compare            对比 .env 与 .env.example

  示例:
    env.sh init --project node
    env.sh init --project python
    env.sh init --project react
    env.sh validate --file .env
    env.sh encrypt --file .env > .env.encoded
    env.sh decrypt --file .env.encoded
EOF
        ;;
esac
