#!/usr/bin/env bash
# CI/CD Pipeline Generator - Generates CI/CD configs for various platforms
# Usage: cicd.sh <command> [options]
set -euo pipefail

DATE=$(date +"%Y-%m-%d")

show_help() {
  cat <<'EOF'
CI/CD Pipeline Generator - CI/CD流水线生成器

Commands:
  github --lang <language> [--test] [--deploy] [--docker]
      Generate GitHub Actions workflow YAML

  gitlab --lang <language> [--test] [--deploy] [--docker]
      Generate GitLab CI YAML

  docker --lang <language> [--port 3000] [--multi-stage]
      Generate Dockerfile

  compose --services "web,db,redis" [--lang node]
      Generate docker-compose.yml

  help
      Show this help message

Languages (--lang):
  node, python, go, java, rust, ruby, php, dotnet

Options:
  --lang        Programming language
  --test        Include test stage (default: yes)
  --deploy      Include deployment stage
  --docker      Include Docker build step
  --port        Application port (default: 3000)
  --multi-stage Use multi-stage Docker build
  --services    Comma-separated services for docker-compose
  --node-ver    Node.js version (default: 20)
  --python-ver  Python version (default: 3.12)
  --go-ver      Go version (default: 1.22)
  --java-ver    Java version (default: 21)
EOF
}

LANG_NAME=""
TEST="yes"
DEPLOY=""
DOCKER=""
PORT="3000"
MULTI_STAGE=""
SERVICES=""
NODE_VER="20"
PYTHON_VER="3.12"
GO_VER="1.22"
JAVA_VER="21"

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --lang) LANG_NAME="$2"; shift 2 ;;
      --test) TEST="yes"; shift ;;
      --deploy) DEPLOY="yes"; shift ;;
      --docker) DOCKER="yes"; shift ;;
      --port) PORT="$2"; shift 2 ;;
      --multi-stage) MULTI_STAGE="yes"; shift ;;
      --services) SERVICES="$2"; shift 2 ;;
      --node-ver) NODE_VER="$2"; shift 2 ;;
      --python-ver) PYTHON_VER="$2"; shift 2 ;;
      --go-ver) GO_VER="$2"; shift 2 ;;
      --java-ver) JAVA_VER="$2"; shift 2 ;;
      *) shift ;;
    esac
  done
}

generate_github() {
  parse_args "$@"

  if [[ -z "$LANG_NAME" ]]; then
    echo "Error: --lang is required"
    echo "Usage: cicd.sh github --lang node"
    exit 1
  fi

  echo "# ============================================================"
  echo "# GitHub Actions CI/CD Pipeline"
  echo "# Language: ${LANG_NAME}"
  echo "# Generated: ${DATE}"
  echo "# File: .github/workflows/ci.yml"
  echo "# ============================================================"
  echo ""

  cat <<EOF
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  CI: true
EOF

  case "$LANG_NAME" in
    node|nodejs|javascript|typescript)
      cat <<EOF

jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18, ${NODE_VER}]

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js \${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: \${{ matrix.node-version }}
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run linter
        run: npm run lint --if-present

      - name: Run tests
        run: npm test

      - name: Run build
        run: npm run build --if-present

      - name: Upload coverage
        if: matrix.node-version == '${NODE_VER}'
        uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: coverage/
          retention-days: 5
EOF
      ;;
    python)
      cat <<EOF

jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ['3.11', '${PYTHON_VER}']

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Python \${{ matrix.python-version }}
        uses: actions/setup-python@v5
        with:
          python-version: \${{ matrix.python-version }}
          cache: 'pip'

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt
          pip install flake8 pytest pytest-cov

      - name: Lint with flake8
        run: |
          flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
          flake8 . --count --exit-zero --max-complexity=10 --max-line-length=120 --statistics

      - name: Run tests with coverage
        run: pytest --cov=./ --cov-report=xml

      - name: Upload coverage
        if: matrix.python-version == '${PYTHON_VER}'
        uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: coverage.xml
          retention-days: 5
EOF
      ;;
    go|golang)
      cat <<EOF

jobs:
  lint-and-test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Go
        uses: actions/setup-go@v5
        with:
          go-version: '${GO_VER}'
          cache: true

      - name: Download dependencies
        run: go mod download

      - name: Run go vet
        run: go vet ./...

      - name: Run golangci-lint
        uses: golangci/golangci-lint-action@v4
        with:
          version: latest

      - name: Run tests
        run: go test -v -race -coverprofile=coverage.out ./...

      - name: Build
        run: go build -v ./...

      - name: Upload coverage
        uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: coverage.out
          retention-days: 5
EOF
      ;;
    java)
      cat <<EOF

jobs:
  lint-and-test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Java ${JAVA_VER}
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '${JAVA_VER}'
          cache: 'maven'

      - name: Build and test
        run: mvn -B verify

      - name: Upload test results
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: test-results
          path: target/surefire-reports/
          retention-days: 5
EOF
      ;;
    rust)
      cat <<EOF

jobs:
  lint-and-test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Rust
        uses: dtolnay/rust-toolchain@stable
        with:
          components: rustfmt, clippy

      - name: Cache cargo
        uses: actions/cache@v4
        with:
          path: |
            ~/.cargo/registry
            ~/.cargo/git
            target
          key: \${{ runner.os }}-cargo-\${{ hashFiles('**/Cargo.lock') }}

      - name: Check formatting
        run: cargo fmt --all -- --check

      - name: Run clippy
        run: cargo clippy -- -D warnings

      - name: Run tests
        run: cargo test --verbose
EOF
      ;;
    *)
      echo ""
      echo "# NOTE: Template for '${LANG_NAME}' - customize as needed"
      cat <<EOF

jobs:
  build-and-test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Build
        run: echo "Add your build commands here"

      - name: Test
        run: echo "Add your test commands here"
EOF
      ;;
  esac

  # Add Docker build job if requested
  if [[ -n "$DOCKER" ]]; then
    cat <<EOF

  docker-build:
    needs: [lint-and-test]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: \${{ secrets.DOCKERHUB_USERNAME }}
          password: \${{ secrets.DOCKERHUB_TOKEN }}

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: |
            \${{ secrets.DOCKERHUB_USERNAME }}/\${{ github.event.repository.name }}:latest
            \${{ secrets.DOCKERHUB_USERNAME }}/\${{ github.event.repository.name }}:\${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
EOF
  fi

  # Add deploy job if requested
  if [[ -n "$DEPLOY" ]]; then
    cat <<EOF

  deploy:
    needs: [lint-and-test${DOCKER:+, docker-build}]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    environment: production

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Deploy to production
        run: |
          echo "Add your deployment commands here"
          # Examples:
          # ssh deploy@server 'cd /app && git pull && docker-compose up -d'
          # aws ecs update-service --cluster prod --service app --force-new-deployment
          # kubectl rollout restart deployment/app
EOF
  fi
}

generate_gitlab() {
  parse_args "$@"

  if [[ -z "$LANG_NAME" ]]; then
    echo "Error: --lang is required"
    echo "Usage: cicd.sh gitlab --lang python"
    exit 1
  fi

  echo "# ============================================================"
  echo "# GitLab CI/CD Pipeline"
  echo "# Language: ${LANG_NAME}"
  echo "# Generated: ${DATE}"
  echo "# File: .gitlab-ci.yml"
  echo "# ============================================================"
  echo ""

  cat <<EOF
stages:
  - lint
  - test
  - build
  - deploy

variables:
  CI: "true"
EOF

  case "$LANG_NAME" in
    node|nodejs|javascript|typescript)
      cat <<EOF

default:
  image: node:${NODE_VER}-alpine
  cache:
    key: \${CI_COMMIT_REF_SLUG}
    paths:
      - node_modules/

install:
  stage: .pre
  script:
    - npm ci
  artifacts:
    paths:
      - node_modules/
    expire_in: 1 hour

lint:
  stage: lint
  script:
    - npm run lint --if-present

test:
  stage: test
  script:
    - npm test
  coverage: '/Lines\s*:\s*(\d+\.?\d*)%/'
  artifacts:
    reports:
      junit: junit.xml
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml
    expire_in: 7 days

build:
  stage: build
  script:
    - npm run build --if-present
  artifacts:
    paths:
      - dist/
    expire_in: 7 days
EOF
      ;;
    python)
      cat <<EOF

default:
  image: python:${PYTHON_VER}-slim
  cache:
    key: \${CI_COMMIT_REF_SLUG}
    paths:
      - .cache/pip
      - venv/

.setup-python: &setup-python
  before_script:
    - python -m venv venv
    - source venv/bin/activate
    - pip install --cache-dir .cache/pip -r requirements.txt

lint:
  stage: lint
  <<: *setup-python
  script:
    - pip install flake8 black isort
    - flake8 . --max-line-length=120
    - black --check .
    - isort --check-only .

test:
  stage: test
  <<: *setup-python
  script:
    - pip install pytest pytest-cov
    - pytest --cov=./ --cov-report=xml --junitxml=report.xml
  coverage: '/(?i)total.*? (100(?:\.0+)?\%|[1-9]?\d(?:\.\d+)?\%)$/'
  artifacts:
    reports:
      junit: report.xml
      coverage_report:
        coverage_format: cobertura
        path: coverage.xml
    expire_in: 7 days

build:
  stage: build
  <<: *setup-python
  script:
    - python -m build
  artifacts:
    paths:
      - dist/
    expire_in: 7 days
EOF
      ;;
    go|golang)
      cat <<EOF

default:
  image: golang:${GO_VER}-alpine

lint:
  stage: lint
  script:
    - go vet ./...
    - go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    - golangci-lint run

test:
  stage: test
  script:
    - go test -v -race -coverprofile=coverage.out ./...
    - go tool cover -func=coverage.out
  coverage: '/total:\s+\(statements\)\s+(\d+\.\d+)%/'
  artifacts:
    paths:
      - coverage.out
    expire_in: 7 days

build:
  stage: build
  script:
    - CGO_ENABLED=0 go build -ldflags="-s -w" -o app .
  artifacts:
    paths:
      - app
    expire_in: 7 days
EOF
      ;;
    *)
      cat <<EOF

lint:
  stage: lint
  script:
    - echo "Add your lint commands for ${LANG_NAME}"

test:
  stage: test
  script:
    - echo "Add your test commands for ${LANG_NAME}"

build:
  stage: build
  script:
    - echo "Add your build commands for ${LANG_NAME}"
EOF
      ;;
  esac

  # Add deploy stage
  if [[ -n "$DEPLOY" ]]; then
    cat <<EOF

deploy-production:
  stage: deploy
  environment:
    name: production
    url: https://\${PRODUCTION_URL}
  rules:
    - if: \$CI_COMMIT_BRANCH == "main"
      when: manual
  script:
    - echo "Add your deployment commands here"
EOF
  fi
}

generate_dockerfile() {
  parse_args "$@"

  if [[ -z "$LANG_NAME" ]]; then
    echo "Error: --lang is required"
    echo "Usage: cicd.sh docker --lang node --port 3000"
    exit 1
  fi

  echo "# ============================================================"
  echo "# Dockerfile"
  echo "# Language: ${LANG_NAME}"
  echo "# Generated: ${DATE}"
  echo "# ============================================================"
  echo ""

  case "$LANG_NAME" in
    node|nodejs|javascript|typescript)
      if [[ -n "$MULTI_STAGE" ]]; then
        cat <<EOF
# Stage 1: Build
FROM node:${NODE_VER}-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production && cp -R node_modules /tmp/node_modules
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:${NODE_VER}-alpine AS production
WORKDIR /app

# Create non-root user
RUN addgroup -g 1001 appgroup && \\
    adduser -u 1001 -G appgroup -s /bin/sh -D appuser

# Copy production dependencies and built files
COPY --from=builder /tmp/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./

# Security: run as non-root
USER appuser

EXPOSE ${PORT}

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \\
    CMD wget --no-verbose --tries=1 --spider http://localhost:${PORT}/health || exit 1

CMD ["node", "dist/index.js"]
EOF
      else
        cat <<EOF
FROM node:${NODE_VER}-alpine
WORKDIR /app

# Create non-root user
RUN addgroup -g 1001 appgroup && \\
    adduser -u 1001 -G appgroup -s /bin/sh -D appuser

# Install dependencies
COPY package*.json ./
RUN npm ci --only=production

# Copy application code
COPY . .

# Security: run as non-root
USER appuser

EXPOSE ${PORT}

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \\
    CMD wget --no-verbose --tries=1 --spider http://localhost:${PORT}/health || exit 1

CMD ["node", "index.js"]
EOF
      fi
      ;;
    python)
      if [[ -n "$MULTI_STAGE" ]]; then
        cat <<EOF
# Stage 1: Build
FROM python:${PYTHON_VER}-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt
COPY . .

# Stage 2: Production
FROM python:${PYTHON_VER}-slim AS production
WORKDIR /app

# Create non-root user
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# Copy installed packages
COPY --from=builder /install /usr/local
COPY --from=builder /app .

USER appuser

EXPOSE ${PORT}

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \\
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:${PORT}/health')" || exit 1

CMD ["python", "app.py"]
EOF
      else
        cat <<EOF
FROM python:${PYTHON_VER}-slim
WORKDIR /app

RUN groupadd -r appgroup && useradd -r -g appgroup appuser

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

USER appuser

EXPOSE ${PORT}

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \\
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:${PORT}/health')" || exit 1

CMD ["python", "app.py"]
EOF
      fi
      ;;
    go|golang)
      cat <<EOF
# Stage 1: Build
FROM golang:${GO_VER}-alpine AS builder
WORKDIR /app

# Install dependencies
COPY go.mod go.sum ./
RUN go mod download

# Build binary
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /app/server .

# Stage 2: Production (scratch for smallest image)
FROM alpine:3.19 AS production

# Install ca-certificates for HTTPS
RUN apk --no-cache add ca-certificates tzdata

# Create non-root user
RUN addgroup -g 1001 appgroup && \\
    adduser -u 1001 -G appgroup -s /bin/sh -D appuser

WORKDIR /app

# Copy binary from builder
COPY --from=builder /app/server .

USER appuser

EXPOSE ${PORT}

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \\
    CMD wget --no-verbose --tries=1 --spider http://localhost:${PORT}/health || exit 1

CMD ["./server"]
EOF
      ;;
    java)
      cat <<EOF
# Stage 1: Build
FROM maven:3.9-eclipse-temurin-${JAVA_VER} AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn package -DskipTests -B

# Stage 2: Production
FROM eclipse-temurin:${JAVA_VER}-jre-alpine AS production
WORKDIR /app

RUN addgroup -g 1001 appgroup && \\
    adduser -u 1001 -G appgroup -s /bin/sh -D appuser

COPY --from=builder /app/target/*.jar app.jar

USER appuser

EXPOSE ${PORT}

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \\
    CMD wget --no-verbose --tries=1 --spider http://localhost:${PORT}/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]
EOF
      ;;
    *)
      cat <<EOF
# Generic Dockerfile for ${LANG_NAME}
# Customize this template for your project

FROM ubuntu:22.04
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \\
    ca-certificates \\
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -r appgroup && useradd -r -g appgroup appuser

COPY . .

USER appuser

EXPOSE ${PORT}

CMD ["echo", "Configure your CMD here"]
EOF
      ;;
  esac
}

generate_compose() {
  parse_args "$@"

  if [[ -z "$SERVICES" ]]; then
    SERVICES="web,db,redis"
  fi

  echo "# ============================================================"
  echo "# Docker Compose Configuration"
  echo "# Generated: ${DATE}"
  echo "# File: docker-compose.yml"
  echo "# ============================================================"
  echo ""

  IFS=',' read -ra svc_array <<< "$SERVICES"

  cat <<EOF
version: '3.8'

services:
EOF

  for svc in "${svc_array[@]}"; do
    svc=$(echo "$svc" | xargs)
    case "$svc" in
      web|app|api)
        cat <<EOF
  ${svc}:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "${PORT}:${PORT}"
    environment:
      - NODE_ENV=production
      - PORT=${PORT}
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/app
      - REDIS_URL=redis://redis:6379
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "wget", "--spider", "-q", "http://localhost:${PORT}/health"]
      interval: 30s
      timeout: 5s
      retries: 3
    networks:
      - app-network

EOF
        ;;
      db|postgres|postgresql|mysql)
        local db_image="postgres:16-alpine"
        local db_port="5432"
        local db_env=""
        if [[ "$svc" == "mysql" ]]; then
          db_image="mysql:8.0"
          db_port="3306"
        fi
        cat <<EOF
  db:
    image: ${db_image}
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=app
    ports:
      - "${db_port}:${db_port}"
    volumes:
      - db-data:/var/lib/postgresql/data
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - app-network

EOF
        ;;
      redis)
        cat <<EOF
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5
    command: redis-server --appendonly yes --maxmemory 256mb --maxmemory-policy allkeys-lru
    networks:
      - app-network

EOF
        ;;
      nginx)
        cat <<EOF
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./certs:/etc/nginx/certs:ro
    depends_on:
      - web
    restart: unless-stopped
    networks:
      - app-network

EOF
        ;;
      *)
        cat <<EOF
  ${svc}:
    image: ${svc}:latest
    restart: unless-stopped
    networks:
      - app-network

EOF
        ;;
    esac
  done

  cat <<EOF
volumes:
  db-data:
    driver: local
  redis-data:
    driver: local

networks:
  app-network:
    driver: bridge
EOF
}

# Main command router
CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in
  github|gh)
    generate_github "$@"
    ;;
  gitlab|gl)
    generate_gitlab "$@"
    ;;
  docker|dockerfile)
    generate_dockerfile "$@"
    ;;
  compose|docker-compose)
    generate_compose "$@"
    ;;
  help|--help|-h)
    show_help
    ;;
  *)
    echo "Error: Unknown command '$CMD'"
    echo "Run 'cicd.sh help' for usage information."
    exit 1
    ;;
esac
