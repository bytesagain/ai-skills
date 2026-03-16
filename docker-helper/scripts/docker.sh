#!/usr/bin/env bash
# docker-helper script
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true

show_help() {
    cat << 'EOF'
Docker Helper - Docker助手

用法: bash docker.sh <command> [args]

命令:
  dockerfile <language>     生成Dockerfile模板(node/python/java/go/nginx/php)
  compose <services>        生成docker-compose(逗号分隔: node,redis,postgres)
  command                   Docker命令速查表
  debug                     容器调试排错指南
  optimize                  镜像优化建议
  registry <type>           仓库配置(dockerhub/aliyun/harbor/ghcr)
  help                      显示此帮助信息

示例:
  bash docker.sh dockerfile python
  bash docker.sh compose "node,redis,mysql"
  bash docker.sh command
  bash docker.sh registry aliyun

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
}

cmd_dockerfile() {
    local lang="${1:-}"
    if [ -z "$lang" ]; then
        echo "错误: 请指定语言/框架"
        echo "支持: node, python, java, go, nginx, php"
        exit 1
    fi
    python3 - "$lang" << 'PYEOF'
import sys

lang = sys.argv[1].lower()

templates = {
    'node': '''# Node.js Dockerfile
# Multi-stage build

# ---- Build Stage ----
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

# ---- Production Stage ----
FROM node:18-alpine
WORKDIR /app
RUN addgroup -g 1001 -S appgroup && \\
    adduser -S appuser -u 1001 -G appgroup
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
USER appuser
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s \\
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1
CMD ["node", "dist/index.js"]''',

    'python': '''# Python Dockerfile
# Multi-stage build

# ---- Build Stage ----
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# ---- Production Stage ----
FROM python:3.11-slim
WORKDIR /app
RUN groupadd -r appgroup && useradd -r -g appgroup appuser
COPY --from=builder /install /usr/local
COPY . .
RUN chown -R appuser:appgroup /app
USER appuser
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=3s \\
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1
CMD ["python", "app.py"]''',

    'java': '''# Java Dockerfile
# Multi-stage build

# ---- Build Stage ----
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn package -DskipTests

# ---- Production Stage ----
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
RUN addgroup -g 1001 -S appgroup && \\
    adduser -S appuser -u 1001 -G appgroup
COPY --from=builder /app/target/*.jar app.jar
USER appuser
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s \\
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1
ENTRYPOINT ["java", "-jar", "app.jar"]''',

    'go': '''# Go Dockerfile
# Multi-stage build

# ---- Build Stage ----
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /app/server .

# ---- Production Stage ----
FROM alpine:3.19
WORKDIR /app
RUN addgroup -g 1001 -S appgroup && \\
    adduser -S appuser -u 1001 -G appgroup
RUN apk --no-cache add ca-certificates
COPY --from=builder /app/server .
USER appuser
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s \\
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1
CMD ["./server"]''',

    'nginx': '''# Nginx Dockerfile

FROM nginx:1.25-alpine
# Remove default config
RUN rm /etc/nginx/conf.d/default.conf
# Copy custom config
COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d/ /etc/nginx/conf.d/
# Copy static files
COPY dist/ /usr/share/nginx/html/
# Non-root user
RUN chown -R nginx:nginx /usr/share/nginx/html && \\
    chown -R nginx:nginx /var/cache/nginx && \\
    chown -R nginx:nginx /var/log/nginx && \\
    touch /var/run/nginx.pid && \\
    chown -R nginx:nginx /var/run/nginx.pid
USER nginx
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s \\
  CMD wget --no-verbose --tries=1 --spider http://localhost:80/ || exit 1
CMD ["nginx", "-g", "daemon off;"]''',

    'php': '''# PHP Dockerfile

FROM php:8.2-fpm-alpine
WORKDIR /var/www/html
# Install extensions
RUN docker-php-ext-install pdo pdo_mysql opcache
# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# Copy application
COPY . .
RUN composer install --no-dev --optimize-autoloader
# Permissions
RUN chown -R www-data:www-data /var/www/html/storage
EXPOSE 9000
CMD ["php-fpm"]''',
}

if lang in templates:
    print("# {} Dockerfile\n".format(lang.capitalize()))
    print(templates[lang])
    print("\n# .dockerignore (recommended):")
    ignore_common = '''node_modules
.git
.env
*.log
.DS_Store
docker-compose*.yml
Dockerfile*
README.md'''
    print(ignore_common)
else:
    print("不支持的语言/框架: {}".format(lang))
    print("支持: {}".format(', '.join(sorted(templates.keys()))))
    sys.exit(1)
PYEOF
}

cmd_compose() {
    local services="${1:-}"
    if [ -z "$services" ]; then
        echo "错误: 请指定服务，逗号分隔"
        echo "支持: node, python, java, go, nginx, redis, mysql, postgres, mongo, rabbitmq, elasticsearch"
        exit 1
    fi
    python3 - "$services" << 'PYEOF'
import sys

services = [s.strip().lower() for s in sys.argv[1].split(',')]

service_templates = {
    'node': '''  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    volumes:
      - ./:/app
      - /app/node_modules
    restart: unless-stopped''',

    'python': '''  app:
    build: .
    ports:
      - "8000:8000"
    environment:
      - PYTHONUNBUFFERED=1
    volumes:
      - ./:/app
    restart: unless-stopped''',

    'java': '''  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=prod
    restart: unless-stopped''',

    'go': '''  app:
    build: .
    ports:
      - "8080:8080"
    restart: unless-stopped''',

    'nginx': '''  nginx:
    image: nginx:1.25-alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./dist:/usr/share/nginx/html:ro
    restart: unless-stopped''',

    'redis': '''  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    command: redis-server --appendonly yes
    restart: unless-stopped''',

    'mysql': '''  mysql:
    image: mysql:8.0
    ports:
      - "3306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD:-rootpass}
      MYSQL_DATABASE: ${MYSQL_DATABASE:-mydb}
      MYSQL_USER: ${MYSQL_USER:-user}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD:-password}
    volumes:
      - mysql_data:/var/lib/mysql
    restart: unless-stopped''',

    'postgres': '''  postgres:
    image: postgres:16-alpine
    ports:
      - "5432:5432"
    environment:
      POSTGRES_DB: ${POSTGRES_DB:-mydb}
      POSTGRES_USER: ${POSTGRES_USER:-user}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-password}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped''',

    'mongo': '''  mongo:
    image: mongo:7
    ports:
      - "27017:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: ${MONGO_USER:-root}
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_PASSWORD:-password}
    volumes:
      - mongo_data:/data/db
    restart: unless-stopped''',

    'rabbitmq': '''  rabbitmq:
    image: rabbitmq:3-management-alpine
    ports:
      - "5672:5672"
      - "15672:15672"
    environment:
      RABBITMQ_DEFAULT_USER: ${RABBITMQ_USER:-guest}
      RABBITMQ_DEFAULT_PASS: ${RABBITMQ_PASS:-guest}
    volumes:
      - rabbitmq_data:/var/lib/rabbitmq
    restart: unless-stopped''',

    'elasticsearch': '''  elasticsearch:
    image: elasticsearch:8.11.0
    ports:
      - "9200:9200"
    environment:
      - discovery.type=single-node
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
      - xpack.security.enabled=false
    volumes:
      - es_data:/usr/share/elasticsearch/data
    restart: unless-stopped''',
}

volume_map = {
    'redis': 'redis_data',
    'mysql': 'mysql_data',
    'postgres': 'postgres_data',
    'mongo': 'mongo_data',
    'rabbitmq': 'rabbitmq_data',
    'elasticsearch': 'es_data',
}

print("version: '3.8'\n")
print("services:")

volumes_needed = []
for svc in services:
    if svc in service_templates:
        print(service_templates[svc])
        print()
        if svc in volume_map:
            volumes_needed.append(volume_map[svc])
    else:
        print("  # 未知服务: {}".format(svc))

# Add depends_on for app services
app_services = [s for s in services if s in ('node', 'python', 'java', 'go')]
db_services = [s for s in services if s in ('mysql', 'postgres', 'mongo', 'redis')]

if app_services and db_services:
    print("# 提示: 建议在app服务中添加depends_on:")
    print("#   depends_on:")
    for db in db_services:
        svc_name = db
        print("#     - {}".format(svc_name))
    print()

if volumes_needed:
    print("volumes:")
    for v in volumes_needed:
        print("  {}:".format(v))
PYEOF
}

cmd_command() {
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                    Docker 命令速查表                          ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  ── 容器管理 ──                                              ║
║  docker run -d --name app image      启动容器(后台)          ║
║  docker run -it image sh             交互式启动              ║
║  docker start/stop/restart <name>    启停重启                ║
║  docker rm <name>                    删除容器                ║
║  docker rm -f $(docker ps -aq)       删除所有容器            ║
║                                                              ║
║  ── 查看信息 ──                                              ║
║  docker ps                           运行中的容器            ║
║  docker ps -a                        所有容器                ║
║  docker logs -f <name>               查看日志                ║
║  docker inspect <name>               详细信息                ║
║  docker stats                        资源使用                ║
║  docker top <name>                   容器进程                ║
║                                                              ║
║  ── 镜像管理 ──                                              ║
║  docker images                       列出镜像                ║
║  docker build -t name:tag .          构建镜像                ║
║  docker pull image:tag               拉取镜像                ║
║  docker push image:tag               推送镜像                ║
║  docker rmi <image>                  删除镜像                ║
║  docker image prune                  清理无用镜像            ║
║                                                              ║
║  ── 网络与卷 ──                                              ║
║  docker network ls                   列出网络                ║
║  docker network create mynet         创建网络                ║
║  docker volume ls                    列出卷                  ║
║  docker volume create myvol          创建卷                  ║
║                                                              ║
║  ── 常用参数 ──                                              ║
║  -d          后台运行                                        ║
║  -p 8080:80  端口映射                                        ║
║  -v /h:/c    目录挂载                                        ║
║  -e KEY=VAL  环境变量                                        ║
║  --rm        退出后自动删除                                  ║
║  --network   指定网络                                        ║
║                                                              ║
║  ── 清理 ──                                                  ║
║  docker system prune                 清理所有无用资源        ║
║  docker system prune -a              清理包括未使用镜像      ║
║  docker system df                    查看磁盘占用            ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
}

cmd_debug() {
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                  Docker 调试排错指南                          ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  ── 容器无法启动 ──                                          ║
║  1. docker logs <container>          查看错误日志            ║
║  2. docker inspect <container>       检查配置                ║
║  3. docker run -it image sh          交互式排查              ║
║                                                              ║
║  ── 容器内调试 ──                                            ║
║  docker exec -it <container> sh      进入容器                ║
║  docker exec <c> cat /etc/hosts      查看hosts               ║
║  docker exec <c> env                 查看环境变量            ║
║  docker exec <c> ps aux              查看进程                ║
║                                                              ║
║  ── 网络问题 ──                                              ║
║  docker network inspect <net>        查看网络配置            ║
║  docker exec <c> ping <other>        测试连通性              ║
║  docker exec <c> nslookup <svc>      DNS解析                ║
║  docker port <container>             查看端口映射            ║
║                                                              ║
║  ── 性能问题 ──                                              ║
║  docker stats                        实时资源监控            ║
║  docker stats --no-stream            单次快照                ║
║  docker system events                系统事件                ║
║                                                              ║
║  ── 磁盘问题 ──                                              ║
║  docker system df                    磁盘使用摘要            ║
║  docker volume ls -f dangling=true   悬空卷                  ║
║  docker image prune -a               清理无用镜像            ║
║                                                              ║
║  ── 常见错误 ──                                              ║
║  "port already allocated"            端口被占用              ║
║    → lsof -i :PORT / 改用其他端口                            ║
║  "no space left on device"           磁盘满                  ║
║    → docker system prune -a                                  ║
║  "permission denied"                 权限问题                ║
║    → 检查文件权限 / USER指令                                 ║
║  "network not found"                 网络不存在              ║
║    → docker network create <name>                            ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
}

cmd_optimize() {
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                  Docker 镜像优化指南                          ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  ── 1. 选择更小的基础镜像 ──                                 ║
║  ubuntu:22.04    ~77MB                                       ║
║  debian:slim     ~52MB                                       ║
║  alpine:3.19     ~7MB   ← 推荐                              ║
║  distroless      ~2MB   ← 最小(无shell)                     ║
║  scratch         0MB    ← Go静态编译专用                     ║
║                                                              ║
║  ── 2. 多阶段构建 ──                                         ║
║  FROM node:18 AS builder                                     ║
║  RUN npm run build                                           ║
║  FROM node:18-alpine                                         ║
║  COPY --from=builder /app/dist ./dist                        ║
║                                                              ║
║  ── 3. 合并RUN指令 ──                                        ║
║  ✗ RUN apt-get update                                        ║
║    RUN apt-get install -y curl                               ║
║    RUN apt-get clean                                         ║
║  ✓ RUN apt-get update && \                                   ║
║      apt-get install -y --no-install-recommends curl && \    ║
║      apt-get clean && rm -rf /var/lib/apt/lists/*            ║
║                                                              ║
║  ── 4. 利用构建缓存 ──                                       ║
║  COPY package.json .    ← 先复制依赖文件                     ║
║  RUN npm install        ← 依赖不变则用缓存                   ║
║  COPY . .               ← 最后复制代码                       ║
║                                                              ║
║  ── 5. 使用.dockerignore ──                                  ║
║  node_modules/                                               ║
║  .git/                                                       ║
║  *.log                                                       ║
║  .env                                                        ║
║                                                              ║
║  ── 6. 检查镜像大小 ──                                       ║
║  docker images                        查看大小               ║
║  docker history <image>               查看各层大小           ║
║  dive <image>                         可视化分析(需安装)     ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
}

cmd_registry() {
    local reg_type="${1:-}"
    if [ -z "$reg_type" ]; then
        echo "错误: 请指定仓库类型"
        echo "支持: dockerhub, aliyun, harbor, ghcr"
        exit 1
    fi
    python3 - "$reg_type" << 'PYEOF'
import sys

reg = sys.argv[1].lower()

configs = {
    'dockerhub': {
        'name': 'Docker Hub',
        'login': 'docker login',
        'push': '''# 登录
docker login -u <username>

# 标记镜像
docker tag myapp:latest <username>/myapp:latest

# 推送
docker push <username>/myapp:latest

# 拉取
docker pull <username>/myapp:latest''',
        'notes': '''注意:
- 免费账户: 1个私有仓库
- 自动构建已不再免费
- 拉取限制: 匿名100次/6h, 登录200次/6h'''
    },
    'aliyun': {
        'name': '阿里云容器镜像服务(ACR)',
        'login': 'docker login --username=<阿里云账号> registry.cn-hangzhou.aliyuncs.com',
        'push': '''# 登录
docker login --username=<阿里云账号> registry.cn-<region>.aliyuncs.com

# 标记镜像
docker tag myapp:latest registry.cn-<region>.aliyuncs.com/<namespace>/myapp:latest

# 推送
docker push registry.cn-<region>.aliyuncs.com/<namespace>/myapp:latest

# 拉取
docker pull registry.cn-<region>.aliyuncs.com/<namespace>/myapp:latest''',
        'notes': '''区域列表:
- cn-hangzhou    杭州
- cn-shanghai    上海
- cn-beijing     北京
- cn-shenzhen    深圳
- cn-hongkong    香港

注意:
- 免费版: 3个命名空间, 300个仓库
- 推荐用作国内Docker Hub加速'''
    },
    'harbor': {
        'name': 'Harbor (私有仓库)',
        'login': 'docker login <harbor-host>',
        'push': '''# 登录
docker login <harbor-host>

# 标记镜像
docker tag myapp:latest <harbor-host>/<project>/myapp:latest

# 推送
docker push <harbor-host>/<project>/myapp:latest

# docker-compose部署Harbor:
# 下载: github.com/goharbor/harbor/releases
# 解压后编辑 harbor.yml, 然后执行:
# ./install.sh''',
        'notes': '''Harbor特点:
- 开源私有仓库
- 支持镜像签名和漏洞扫描
- 基于角色的访问控制
- 镜像复制(跨数据中心)
- 审计日志'''
    },
    'ghcr': {
        'name': 'GitHub Container Registry',
        'login': 'echo $PAT | docker login ghcr.io -u <username> --password-stdin',
        'push': '''# 创建PAT (需container权限)
# Settings > Developer settings > Personal access tokens

# 登录
echo $GITHUB_TOKEN | docker login ghcr.io -u <username> --password-stdin

# 标记镜像
docker tag myapp:latest ghcr.io/<username>/myapp:latest

# 推送
docker push ghcr.io/<username>/myapp:latest

# GitHub Actions中使用:
# - name: Login to GHCR
#   uses: docker/login-action@v3
#   with:
#     registry: ghcr.io
#     username: ${{ github.actor }}
#     password: ${{ secrets.GITHUB_TOKEN }}''',
        'notes': '''注意:
- 需要Personal Access Token(PAT)
- 默认私有, 可设为公开
- 与GitHub仓库关联
- Actions中可用GITHUB_TOKEN'''
    },
}

if reg in configs:
    c = configs[reg]
    print("=" * 50)
    print("  {} 配置指南".format(c['name']))
    print("=" * 50)
    print("\n登录命令:")
    print("  {}".format(c['login']))
    print("\n操作步骤:")
    print(c['push'])
    print("\n{}".format(c['notes']))
else:
    print("不支持的仓库类型: {}".format(reg))
    print("支持: {}".format(', '.join(sorted(configs.keys()))))
    sys.exit(1)
PYEOF
}

case "$CMD" in
    dockerfile)
        cmd_dockerfile "$@"
        ;;
    compose)
        cmd_compose "$@"
        ;;
    command)
        cmd_command
        ;;
    debug)
        cmd_debug
        ;;
    optimize)
        cmd_optimize
        ;;
    registry)
        cmd_registry "$@"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "未知命令: $CMD"
        echo ""
        show_help
        exit 1
        ;;
esac
