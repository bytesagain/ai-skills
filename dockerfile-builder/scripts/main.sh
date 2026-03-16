#!/usr/bin/env bash
# Dockerfile Builder — Generate optimized Dockerfiles for various languages
# Usage: bash main.sh --lang <language> [--app-name <name>] [--port <port>] [--multi-stage] [--output <file>]
set -euo pipefail

LANG_TARGET=""
APP_NAME="myapp"
PORT="3000"
MULTI_STAGE="false"
OUTPUT=""
INCLUDE_DOCKERIGNORE="false"
INCLUDE_COMPOSE="false"

show_help() {
    cat << 'HELPEOF'
Dockerfile Builder — Generate optimized, production-ready Dockerfiles

Usage: bash main.sh --lang <language> [options]

Options:
  --lang <lang>        Target language/framework (required)
  --app-name <name>    Application name (default: myapp)
  --port <port>        Exposed port (default: 3000)
  --multi-stage        Use multi-stage build
  --dockerignore       Also generate .dockerignore
  --compose            Also generate docker-compose.yml
  --output <file>      Output file (default: stdout)
  --help               Show this help

Supported Languages:
  node, python, go, java, rust, ruby, php, dotnet, static

Examples:
  bash main.sh --lang node --port 3000 --multi-stage
  bash main.sh --lang python --app-name api --port 8000 --dockerignore
  bash main.sh --lang go --multi-stage --compose --output Dockerfile
  bash main.sh --lang rust --multi-stage
  bash main.sh --lang static --port 80

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELPEOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --lang) LANG_TARGET="$2"; shift 2;;
        --app-name) APP_NAME="$2"; shift 2;;
        --port) PORT="$2"; shift 2;;
        --multi-stage) MULTI_STAGE="true"; shift;;
        --dockerignore) INCLUDE_DOCKERIGNORE="true"; shift;;
        --compose) INCLUDE_COMPOSE="true"; shift;;
        --output) OUTPUT="$2"; shift 2;;
        --help|-h) show_help; exit 0;;
        *) echo "Unknown option: $1"; show_help; exit 1;;
    esac
done

[ -z "$LANG_TARGET" ] && { echo "Error: --lang is required"; show_help; exit 1; }

generate_dockerfile() {
    python3 << PYEOF
import sys, textwrap

lang = "$LANG_TARGET"
app = "$APP_NAME"
port = "$PORT"
multi = "$MULTI_STAGE" == "true"

templates = {}

# ──── Node.js ────
templates["node"] = {
    "single": textwrap.dedent("""
        FROM node:20-alpine
        
        LABEL maintainer="BytesAgain <hello@bytesagain.com>"
        LABEL description="{app} — Node.js application"
        
        # Create app directory
        WORKDIR /app
        
        # Install dependencies first (cache layer)
        COPY package*.json ./
        RUN npm ci --only=production && npm cache clean --force
        
        # Copy application code
        COPY . .
        
        # Create non-root user
        RUN addgroup -g 1001 -S appgroup && \\
            adduser -S appuser -u 1001 -G appgroup
        USER appuser
        
        EXPOSE {port}
        
        HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \\
            CMD wget --no-verbose --tries=1 --spider http://localhost:{port}/health || exit 1
        
        CMD ["node", "index.js"]
    """).strip(),
    "multi": textwrap.dedent("""
        # ── Build Stage ──
        FROM node:20-alpine AS builder
        WORKDIR /app
        COPY package*.json ./
        RUN npm ci
        COPY . .
        RUN npm run build
        
        # ── Production Stage ──
        FROM node:20-alpine AS production
        
        LABEL maintainer="BytesAgain <hello@bytesagain.com>"
        LABEL description="{app} — Node.js application (optimized)"
        
        WORKDIR /app
        
        COPY package*.json ./
        RUN npm ci --only=production && npm cache clean --force
        
        COPY --from=builder /app/dist ./dist
        
        RUN addgroup -g 1001 -S appgroup && \\
            adduser -S appuser -u 1001 -G appgroup
        USER appuser
        
        EXPOSE {port}
        
        HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \\
            CMD wget --no-verbose --tries=1 --spider http://localhost:{port}/health || exit 1
        
        CMD ["node", "dist/index.js"]
    """).strip()
}

# ──── Python ────
templates["python"] = {
    "single": textwrap.dedent("""
        FROM python:3.12-slim
        
        LABEL maintainer="BytesAgain <hello@bytesagain.com>"
        LABEL description="{app} — Python application"
        
        # Prevent Python from writing bytecode and buffering stdout/stderr
        ENV PYTHONDONTWRITEBYTECODE=1 \\
            PYTHONUNBUFFERED=1
        
        WORKDIR /app
        
        # Install dependencies first (cache layer)
        COPY requirements.txt .
        RUN pip install --no-cache-dir --upgrade pip && \\
            pip install --no-cache-dir -r requirements.txt
        
        # Copy application code
        COPY . .
        
        # Create non-root user
        RUN groupadd --gid 1001 appgroup && \\
            useradd --uid 1001 --gid appgroup --shell /bin/false appuser
        USER appuser
        
        EXPOSE {port}
        
        HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \\
            CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:{port}/health')" || exit 1
        
        CMD ["python", "app.py"]
    """).strip(),
    "multi": textwrap.dedent("""
        # ── Build Stage ──
        FROM python:3.12-slim AS builder
        WORKDIR /app
        COPY requirements.txt .
        RUN pip install --no-cache-dir --prefix=/install -r requirements.txt
        
        # ── Production Stage ──
        FROM python:3.12-slim AS production
        
        LABEL maintainer="BytesAgain <hello@bytesagain.com>"
        LABEL description="{app} — Python application (optimized)"
        
        ENV PYTHONDONTWRITEBYTECODE=1 \\
            PYTHONUNBUFFERED=1
        
        WORKDIR /app
        COPY --from=builder /install /usr/local
        COPY . .
        
        RUN groupadd --gid 1001 appgroup && \\
            useradd --uid 1001 --gid appgroup --shell /bin/false appuser
        USER appuser
        
        EXPOSE {port}
        CMD ["python", "app.py"]
    """).strip()
}

# ──── Go ────
templates["go"] = {
    "single": textwrap.dedent("""
        FROM golang:1.22-alpine
        
        LABEL maintainer="BytesAgain <hello@bytesagain.com>"
        LABEL description="{app} — Go application"
        
        WORKDIR /app
        COPY go.mod go.sum ./
        RUN go mod download
        COPY . .
        RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o /{app}
        
        EXPOSE {port}
        CMD ["/{app}"]
    """).strip(),
    "multi": textwrap.dedent("""
        # ── Build Stage ──
        FROM golang:1.22-alpine AS builder
        WORKDIR /app
        COPY go.mod go.sum ./
        RUN go mod download
        COPY . .
        RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o /app-binary
        
        # ── Production Stage ──
        FROM scratch
        
        LABEL maintainer="BytesAgain <hello@bytesagain.com>"
        LABEL description="{app} — Go application (scratch image)"
        
        COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
        COPY --from=builder /app-binary /{app}
        
        EXPOSE {port}
        ENTRYPOINT ["/{app}"]
    """).strip()
}

# ──── Java ────
templates["java"] = {
    "single": textwrap.dedent("""
        FROM eclipse-temurin:21-jdk-alpine
        
        LABEL maintainer="BytesAgain <hello@bytesagain.com>"
        LABEL description="{app} — Java application"
        
        WORKDIR /app
        COPY . .
        RUN ./mvnw package -DskipTests
        
        EXPOSE {port}
        CMD ["java", "-jar", "target/{app}.jar"]
    """).strip(),
    "multi": textwrap.dedent("""
        # ── Build Stage ──
        FROM eclipse-temurin:21-jdk-alpine AS builder
        WORKDIR /app
        COPY . .
        RUN ./mvnw package -DskipTests
        
        # ── Production Stage ──
        FROM eclipse-temurin:21-jre-alpine AS production
        
        LABEL maintainer="BytesAgain <hello@bytesagain.com>"
        LABEL description="{app} — Java application (JRE only)"
        
        WORKDIR /app
        COPY --from=builder /app/target/{app}.jar ./{app}.jar
        
        RUN addgroup -g 1001 -S appgroup && \\
            adduser -S appuser -u 1001 -G appgroup
        USER appuser
        
        EXPOSE {port}
        
        HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \\
            CMD wget --no-verbose --tries=1 --spider http://localhost:{port}/actuator/health || exit 1
        
        ENTRYPOINT ["java", "-jar", "{app}.jar"]
    """).strip()
}

# ──── Rust ────
templates["rust"] = {
    "single": textwrap.dedent("""
        FROM rust:1.77-alpine
        
        LABEL maintainer="BytesAgain <hello@bytesagain.com>"
        LABEL description="{app} — Rust application"
        
        RUN apk add --no-cache musl-dev
        WORKDIR /app
        COPY . .
        RUN cargo build --release
        
        EXPOSE {port}
        CMD ["./target/release/{app}"]
    """).strip(),
    "multi": textwrap.dedent("""
        # ── Build Stage ──
        FROM rust:1.77-alpine AS builder
        RUN apk add --no-cache musl-dev
        WORKDIR /app
        COPY Cargo.toml Cargo.lock ./
        RUN mkdir src && echo "fn main(){{}}" > src/main.rs && cargo build --release && rm -rf src
        COPY . .
        RUN cargo build --release
        
        # ── Production Stage ──
        FROM alpine:3.19
        
        LABEL maintainer="BytesAgain <hello@bytesagain.com>"
        LABEL description="{app} — Rust application (minimal)"
        
        RUN apk add --no-cache ca-certificates && \\
            addgroup -g 1001 -S appgroup && \\
            adduser -S appuser -u 1001 -G appgroup
        
        COPY --from=builder /app/target/release/{app} /usr/local/bin/{app}
        USER appuser
        
        EXPOSE {port}
        ENTRYPOINT ["{app}"]
    """).strip()
}

# ──── Ruby ────
templates["ruby"] = {
    "single": textwrap.dedent("""
        FROM ruby:3.3-alpine
        
        LABEL maintainer="BytesAgain <hello@bytesagain.com>"
        LABEL description="{app} — Ruby application"
        
        RUN apk add --no-cache build-base
        WORKDIR /app
        COPY Gemfile Gemfile.lock ./
        RUN bundle install --without development test
        COPY . .
        
        EXPOSE {port}
        CMD ["ruby", "app.rb"]
    """).strip(),
    "multi": templates.get("ruby", {}).get("single", "# Ruby multi-stage: same as single for simplicity")
}
templates["ruby"]["multi"] = templates["ruby"]["single"]

# ──── PHP ────
templates["php"] = {
    "single": textwrap.dedent("""
        FROM php:8.3-fpm-alpine
        
        LABEL maintainer="BytesAgain <hello@bytesagain.com>"
        LABEL description="{app} — PHP application"
        
        RUN docker-php-ext-install pdo pdo_mysql opcache
        WORKDIR /var/www/html
        COPY . .
        RUN chown -R www-data:www-data /var/www/html
        
        EXPOSE {port}
        CMD ["php-fpm"]
    """).strip(),
    "multi": textwrap.dedent("""
        FROM php:8.3-fpm-alpine
        LABEL maintainer="BytesAgain <hello@bytesagain.com>"
        RUN docker-php-ext-install pdo pdo_mysql opcache
        WORKDIR /var/www/html
        COPY . .
        RUN chown -R www-data:www-data /var/www/html
        EXPOSE {port}
        CMD ["php-fpm"]
    """).strip()
}

# ──── .NET ────
templates["dotnet"] = {
    "single": textwrap.dedent("""
        FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
        WORKDIR /app
        COPY *.csproj ./
        RUN dotnet restore
        COPY . .
        RUN dotnet publish -c Release -o out
        
        FROM mcr.microsoft.com/dotnet/aspnet:8.0
        LABEL maintainer="BytesAgain <hello@bytesagain.com>"
        WORKDIR /app
        COPY --from=build /app/out .
        EXPOSE {port}
        ENTRYPOINT ["dotnet", "{app}.dll"]
    """).strip(),
    "multi": textwrap.dedent("""
        FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
        WORKDIR /app
        COPY *.csproj ./
        RUN dotnet restore
        COPY . .
        RUN dotnet publish -c Release -o out
        
        FROM mcr.microsoft.com/dotnet/aspnet:8.0
        LABEL maintainer="BytesAgain <hello@bytesagain.com>"
        WORKDIR /app
        COPY --from=build /app/out .
        EXPOSE {port}
        ENTRYPOINT ["dotnet", "{app}.dll"]
    """).strip()
}

# ──── Static (nginx) ────
templates["static"] = {
    "single": textwrap.dedent("""
        FROM nginx:alpine
        
        LABEL maintainer="BytesAgain <hello@bytesagain.com>"
        LABEL description="{app} — Static site"
        
        COPY . /usr/share/nginx/html
        COPY nginx.conf /etc/nginx/conf.d/default.conf 2>/dev/null || true
        
        EXPOSE {port}
        CMD ["nginx", "-g", "daemon off;"]
    """).strip(),
    "multi": textwrap.dedent("""
        # ── Build Stage (e.g., React/Vue) ──
        FROM node:20-alpine AS builder
        WORKDIR /app
        COPY package*.json ./
        RUN npm ci
        COPY . .
        RUN npm run build
        
        # ── Serve Stage ──
        FROM nginx:alpine
        LABEL maintainer="BytesAgain <hello@bytesagain.com>"
        COPY --from=builder /app/dist /usr/share/nginx/html
        EXPOSE {port}
        CMD ["nginx", "-g", "daemon off;"]
    """).strip()
}

if lang not in templates:
    print("# Error: Unsupported language '{}'".format(lang))
    print("# Supported: {}".format(", ".join(sorted(templates.keys()))))
    sys.exit(1)

stage = "multi" if multi else "single"
dockerfile = templates[lang][stage].format(app=app, port=port)

print("# Generated by Dockerfile Builder (BytesAgain)")
print("# Language: {} | App: {} | Port: {} | Multi-stage: {}".format(lang, app, port, multi))
print("")
print(dockerfile)
PYEOF
}

generate_dockerignore() {
    python3 << PYEOF
import textwrap
lang = "$LANG_TARGET"

common = """
.git
.gitignore
.dockerignore
Dockerfile
docker-compose*.yml
README.md
LICENSE
.env
.env.*
*.log
.DS_Store
Thumbs.db
"""

lang_specific = {
    "node": "node_modules/\nnpm-debug.log*\n.npm\ncoverage/\n.nyc_output\ndist/\n",
    "python": "__pycache__/\n*.pyc\n*.pyo\n.venv/\nvenv/\n*.egg-info/\n.pytest_cache/\n.mypy_cache/\n",
    "go": "vendor/\n*.test\n*.out\n",
    "java": "target/\n*.class\n.idea/\n*.iml\n.gradle/\nbuild/\n",
    "rust": "target/\n*.rs.bk\n",
    "ruby": ".bundle/\nvendor/bundle\nlog/\ntmp/\n",
    "php": "vendor/\n.phpunit.cache\nstorage/\n",
    "dotnet": "bin/\nobj/\n*.user\n.vs/\n",
    "static": "node_modules/\nsrc/\n"
}

print("# .dockerignore — Generated by BytesAgain Dockerfile Builder")
print(common.strip())
extra = lang_specific.get(lang, "")
if extra:
    print("\n# {} specific".format(lang))
    print(extra.strip())
PYEOF
}

generate_compose() {
    cat << COMPEOF
# docker-compose.yml — Generated by BytesAgain Dockerfile Builder
version: '3.8'

services:
  $APP_NAME:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: $APP_NAME
    ports:
      - "$PORT:$PORT"
    restart: unless-stopped
    environment:
      - NODE_ENV=production
    volumes:
      - app-data:/app/data
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:$PORT/health"]
      interval: 30s
      timeout: 3s
      retries: 3

volumes:
  app-data:
COMPEOF
}

# ──── Main Output ────
output_content() {
    echo "# ════════════════════════════════════════"
    echo "# Dockerfile Builder Output"
    echo "# Language: $LANG_TARGET | App: $APP_NAME | Port: $PORT"
    echo "# ════════════════════════════════════════"
    echo ""
    echo "## Dockerfile"
    echo '```dockerfile'
    generate_dockerfile
    echo '```'

    if [ "$INCLUDE_DOCKERIGNORE" = "true" ]; then
        echo ""
        echo "## .dockerignore"
        echo '```'
        generate_dockerignore
        echo '```'
    fi

    if [ "$INCLUDE_COMPOSE" = "true" ]; then
        echo ""
        echo "## docker-compose.yml"
        echo '```yaml'
        generate_compose
        echo '```'
    fi

    echo ""
    echo "---"
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

if [ -n "$OUTPUT" ]; then
    output_content > "$OUTPUT"
    echo "✅ Output saved to $OUTPUT"
else
    output_content
fi
