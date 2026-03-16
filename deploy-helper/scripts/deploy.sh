#!/usr/bin/env bash
# Deploy Helper — Powered by BytesAgain
set -euo pipefail

COMMAND="${1:-help}"
ARG="${2:-node}"
BRAND="Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"

case "$COMMAND" in

docker)
  python3 - "$ARG" << 'PYEOF'
import sys
ptype = sys.argv[1] if len(sys.argv) > 1 else "node"

dockerfiles = {
    "node": """# ===== Node.js Multi-stage Dockerfile =====
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force
COPY . .
RUN npm run build 2>/dev/null || true

FROM node:18-alpine
RUN addgroup -g 1001 -S appgroup && adduser -S appuser -u 1001 -G appgroup
WORKDIR /app
COPY --from=builder --chown=appuser:appgroup /app .
USER appuser
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost:3000/health || exit 1
CMD ["node", "index.js"]""",

    "python": """# ===== Python Multi-stage Dockerfile =====
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.11-slim
RUN useradd --create-home appuser
WORKDIR /app
COPY --from=builder /install /usr/local
COPY --chown=appuser:appuser . .
USER appuser
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://localhost:8000/health || exit 1
CMD ["python", "app.py"]""",

    "go": """# ===== Go Multi-stage Dockerfile =====
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /app/server .

FROM alpine:3.18
RUN adduser -D -g '' appuser
COPY --from=builder /app/server /usr/local/bin/server
USER appuser
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost:8080/health || exit 1
CMD ["server"]""",

    "static": """# ===== Static Site Dockerfile =====
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost/ || exit 1
CMD ["nginx", "-g", "daemon off;"]"""
}

df = dockerfiles.get(ptype, dockerfiles["node"])
print(df)
PYEOF
  echo ""
  echo "# $BRAND"
  ;;

compose)
  python3 - "$ARG" << 'PYEOF'
import sys
ptype = sys.argv[1] if len(sys.argv) > 1 else "node"

port_map = {"node": "3000", "python": "8000", "go": "8080", "java": "8080", "static": "80"}
port = port_map.get(ptype, "3000")

print("""# ===== docker-compose.yml =====
version: '3.8'

services:
  app:
    build: .
    ports:
      - "{port}:{port}"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgres://user:pass@db:5432/appdb
      - REDIS_URL=redis://redis:6379
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    restart: unless-stopped
    networks:
      - app-network

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: appdb
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d appdb"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - app-network

  redis:
    image: redis:7-alpine
    command: redis-server --appendonly yes
    volumes:
      - redisdata:/data
    networks:
      - app-network

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - app
    networks:
      - app-network

volumes:
  pgdata:
  redisdata:

networks:
  app-network:
    driver: bridge""".format(port=port))
PYEOF
  echo ""
  echo "# $BRAND"
  ;;

nginx)
  python3 - "$ARG" << 'PYEOF'
import sys
ptype = sys.argv[1] if len(sys.argv) > 1 else "node"

port_map = {"node": "3000", "python": "8000", "go": "8080", "java": "8080"}

if ptype == "static":
    print("""# ===== Nginx Config: Static Site =====
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;

    # Gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml;
    gzip_min_length 1000;

    # Cache static assets
    location ~* \\.(js|css|png|jpg|jpeg|gif|ico|svg|woff2)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # SPA fallback
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
}""")
else:
    port = port_map.get(ptype, "3000")
    print("""# ===== Nginx Config: Reverse Proxy =====
upstream app_backend {{
    server app:{port};
    keepalive 32;
}}

server {{
    listen 80;
    server_name _;

    # Gzip
    gzip on;
    gzip_types text/plain text/css application/json application/javascript;
    gzip_min_length 1000;

    # Proxy to app
    location / {{
        proxy_pass http://app_backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }}

    # Static assets (if served by Nginx)
    location /static/ {{
        alias /app/static/;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }}

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
}}""".format(port=port))
PYEOF
  echo ""
  echo "# $BRAND"
  ;;

ci)
  python3 - "$ARG" << 'PYEOF'
import sys
platform = sys.argv[1] if len(sys.argv) > 1 else "github"

if platform == "github":
    print("""# ===== GitHub Actions CI/CD =====
name: CI/CD Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Lint
        run: npm run lint 2>/dev/null || echo "No lint script"

      - name: Test
        run: npm test

  build:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4

      - name: Build Docker image
        run: docker build -t app:${{ github.sha }} .

      - name: Push to registry
        run: |
          echo "Push to your container registry here"
          # docker push registry.example.com/app:${{ github.sha }}

  deploy:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Deploy
        run: |
          echo "Deploy to your server here"
          # ssh deploy@server 'cd /app && docker-compose pull && docker-compose up -d'""")

elif platform == "gitlab":
    print("""# ===== GitLab CI/CD =====
stages:
  - test
  - build
  - deploy

variables:
  DOCKER_IMAGE: $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA

test:
  stage: test
  image: node:18-alpine
  cache:
    paths:
      - node_modules/
  script:
    - npm ci
    - npm run lint 2>/dev/null || true
    - npm test

build:
  stage: build
  image: docker:24
  services:
    - docker:24-dind
  script:
    - docker build -t $DOCKER_IMAGE .
    - docker push $DOCKER_IMAGE
  only:
    - main

deploy:
  stage: deploy
  script:
    - echo "Deploy $DOCKER_IMAGE to production"
  only:
    - main
  when: manual""")

elif platform == "jenkins":
    print("""// ===== Jenkinsfile =====
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "app:${env.BUILD_NUMBER}"
    }

    stages {
        stage('Install') {
            steps {
                sh 'npm ci'
            }
        }

        stage('Test') {
            steps {
                sh 'npm test'
            }
        }

        stage('Build') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                sh 'echo "Deploying ${DOCKER_IMAGE}"'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}""")
else:
    print("Supported platforms: github, gitlab, jenkins")
PYEOF
  echo ""
  echo "# $BRAND"
  ;;

vercel)
  python3 - "$ARG" << 'PYEOF'
import sys, json
ptype = sys.argv[1] if len(sys.argv) > 1 else "node"

configs = {
    "node": {
        "version": 2,
        "builds": [{"src": "index.js", "use": "@vercel/node"}],
        "routes": [{"src": "/api/(.*)", "dest": "index.js"}],
        "env": {"NODE_ENV": "production"}
    },
    "static": {
        "version": 2,
        "builds": [{"src": "package.json", "use": "@vercel/static-build", "config": {"distDir": "dist"}}],
        "routes": [{"handle": "filesystem"}, {"src": "/(.*)", "dest": "/index.html"}]
    },
    "python": {
        "version": 2,
        "builds": [{"src": "api/*.py", "use": "@vercel/python"}],
        "routes": [{"src": "/api/(.*)", "dest": "api/$1.py"}]
    }
}

config = configs.get(ptype, configs["node"])
print("// ===== vercel.json =====")
print(json.dumps(config, indent=2))
PYEOF
  echo ""
  echo "// $BRAND"
  ;;

netlify)
  python3 - "$ARG" << 'PYEOF'
import sys
ptype = sys.argv[1] if len(sys.argv) > 1 else "static"

configs = {
    "static": """# ===== netlify.toml =====
[build]
  command = "npm run build"
  publish = "dist"

[build.environment]
  NODE_VERSION = "18"

# SPA redirect
[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

# Cache headers for assets
[[headers]]
  for = "/assets/*"
  [headers.values]
    Cache-Control = "public, max-age=2592000, immutable"

# Security headers
[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "SAMEORIGIN"
    X-Content-Type-Options = "nosniff"
    X-XSS-Protection = "1; mode=block" """,

    "node": """# ===== netlify.toml =====
[build]
  command = "npm run build"
  publish = "dist"
  functions = "netlify/functions"

[build.environment]
  NODE_VERSION = "18"

[dev]
  command = "npm run dev"
  port = 3000

[[redirects]]
  from = "/api/*"
  to = "/.netlify/functions/:splat"
  status = 200

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200"""
}

config = configs.get(ptype, configs["static"])
print(config)
PYEOF
  echo ""
  echo "# $BRAND"
  ;;

k8s)
  python3 - "$ARG" << 'PYEOF'
import sys
ptype = sys.argv[1] if len(sys.argv) > 1 else "node"
port_map = {"node": "3000", "python": "8000", "go": "8080", "java": "8080", "static": "80"}
port = port_map.get(ptype, "3000")

print("""# ===== Kubernetes Manifests =====
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
  labels:
    app: app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: app
  template:
    metadata:
      labels:
        app: app
    spec:
      containers:
        - name: app
          image: registry.example.com/app:latest
          ports:
            - containerPort: {port}
          env:
            - name: NODE_ENV
              value: "production"
            - name: DATABASE_URL
              valueFrom:
                secretKeyRef:
                  name: app-secrets
                  key: database-url
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
            limits:
              cpu: 500m
              memory: 512Mi
          readinessProbe:
            httpGet:
              path: /health
              port: {port}
            initialDelaySeconds: 5
            periodSeconds: 10
          livenessProbe:
            httpGet:
              path: /health
              port: {port}
            initialDelaySeconds: 15
            periodSeconds: 20
---
apiVersion: v1
kind: Service
metadata:
  name: app-service
spec:
  selector:
    app: app
  ports:
    - port: 80
      targetPort: {port}
  type: ClusterIP
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  tls:
    - hosts:
        - app.example.com
      secretName: app-tls
  rules:
    - host: app.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: app-service
                port:
                  number: 80""".format(port=port))
PYEOF
  echo ""
  echo "# $BRAND"
  ;;

ssl)
  python3 - "$ARG" << 'PYEOF'
import sys
domain = sys.argv[1] if len(sys.argv) > 1 else "example.com"

print("""# ===== SSL/TLS Configuration for {domain} =====

# --- Step 1: Install Certbot ---
# Ubuntu/Debian:
sudo apt update && sudo apt install -y certbot python3-certbot-nginx

# --- Step 2: Obtain Certificate ---
sudo certbot --nginx -d {domain} -d www.{domain}

# --- Step 3: Nginx SSL Config ---
server {{
    listen 443 ssl http2;
    server_name {domain} www.{domain};

    ssl_certificate /etc/letsencrypt/live/{domain}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/{domain}/privkey.pem;

    # Strong SSL settings
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
    ssl_prefer_server_ciphers off;

    # HSTS
    add_header Strict-Transport-Security "max-age=63072000" always;

    # OCSP stapling
    ssl_stapling on;
    ssl_stapling_verify on;

    location / {{
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-Proto $scheme;
    }}
}}

# HTTP -> HTTPS redirect
server {{
    listen 80;
    server_name {domain} www.{domain};
    return 301 https://$server_name$request_uri;
}}

# --- Step 4: Auto-renewal (cron) ---
# sudo crontab -e
# 0 3 * * * certbot renew --quiet --post-hook "systemctl reload nginx"

# --- Step 5: Verify ---
# sudo certbot certificates
# curl -vI https://{domain}
# Test at: https://www.ssllabs.com/ssltest/analyze.html?d={domain}""".format(domain=domain))
PYEOF
  echo ""
  echo "# $BRAND"
  ;;

help|*)
  cat << 'HELPEOF'
╔══════════════════════════════════════════════════╗
║          🚀 Deploy Helper                        ║
╠══════════════════════════════════════════════════╣
║  docker   <type>    — Dockerfile                 ║
║  compose  <type>    — docker-compose.yml         ║
║  nginx    <type>    — Nginx config               ║
║  ci       <platform>— CI/CD pipeline             ║
║  vercel   <type>    — vercel.json                ║
║  netlify  <type>    — netlify.toml               ║
║  k8s      <type>    — Kubernetes manifests       ║
║  ssl      <domain>  — SSL certificate config     ║
║                                                  ║
║  Types: node, python, go, java, static           ║
║  CI platforms: github, gitlab, jenkins           ║
╚══════════════════════════════════════════════════╝
HELPEOF
  echo "$BRAND"
  ;;

esac
