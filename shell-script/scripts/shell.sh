#!/usr/bin/env bash
# Shell Script Generator — generates real shell scripts and checks
# Usage: shell.sh <command> [options]

set -euo pipefail

CMD="${1:-help}"; shift 2>/dev/null || true

# Parse flags
TYPE="backup" NAME="" SOURCE="" DEST="" REMOTE="" FILE="" CRON=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --type)   TYPE="$2"; shift 2 ;;
        --name)   NAME="$2"; shift 2 ;;
        --source) SOURCE="$2"; shift 2 ;;
        --dest)   DEST="$2"; shift 2 ;;
        --remote) REMOTE="$2"; shift 2 ;;
        --file)   FILE="$2"; shift 2 ;;
        --cron)   CRON="$2"; shift 2 ;;
        *) shift ;;
    esac
done

gen_backup() {
    local source="${SOURCE:-/var/www}"
    local dest="${DEST:-/backup}"
    local name="${NAME:-backup}"
    cat <<SCRIPT
#!/usr/bin/env bash
# ============================================
# 自动备份脚本
# 源目录: ${source}
# 备份到: ${dest}
# 生成时间: $(date '+%Y-%m-%d %H:%M:%S')
# ============================================
# Cron 示例（每天凌晨 3 点）:
#   0 3 * * * /path/to/backup.sh >> /var/log/backup.log 2>&1

set -euo pipefail

# ---- 配置 ----
BACKUP_SOURCE="${source}"
BACKUP_DEST="${dest}"
BACKUP_NAME="${name}"
KEEP_DAYS=30             # 保留天数
DATE=\$(date '+%Y%m%d_%H%M%S')
BACKUP_FILE="\${BACKUP_DEST}/\${BACKUP_NAME}_\${DATE}.tar.gz"
LOG_FILE="/var/log/\${BACKUP_NAME}_backup.log"

# ---- 颜色输出 ----
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "\$(date '+%Y-%m-%d %H:%M:%S') \${GREEN}[INFO]\${NC} \$*"; }
warn() { echo -e "\$(date '+%Y-%m-%d %H:%M:%S') \${YELLOW}[WARN]\${NC} \$*"; }
err()  { echo -e "\$(date '+%Y-%m-%d %H:%M:%S') \${RED}[ERROR]\${NC} \$*" >&2; }

# ---- 前置检查 ----
if [[ ! -d "\$BACKUP_SOURCE" ]]; then
    err "源目录不存在: \$BACKUP_SOURCE"
    exit 1
fi

mkdir -p "\$BACKUP_DEST"

# ---- 执行备份 ----
log "开始备份: \$BACKUP_SOURCE → \$BACKUP_FILE"
START_TIME=\$(date +%s)

if tar -czf "\$BACKUP_FILE" -C "\$(dirname "\$BACKUP_SOURCE")" "\$(basename "\$BACKUP_SOURCE")" 2>/dev/null; then
    END_TIME=\$(date +%s)
    DURATION=\$((END_TIME - START_TIME))
    SIZE=\$(du -h "\$BACKUP_FILE" | cut -f1)
    log "✅ 备份完成！文件: \$BACKUP_FILE (大小: \$SIZE, 耗时: \${DURATION}秒)"
else
    err "❌ 备份失败！"
    exit 1
fi

# ---- 清理旧备份 ----
DELETED=\$(find "\$BACKUP_DEST" -name "\${BACKUP_NAME}_*.tar.gz" -mtime +\$KEEP_DAYS -type f -print -delete | wc -l)
if [[ \$DELETED -gt 0 ]]; then
    log "🧹 已清理 \$DELETED 个过期备份（>\${KEEP_DAYS}天）"
fi

# ---- 备份统计 ----
TOTAL=\$(find "\$BACKUP_DEST" -name "\${BACKUP_NAME}_*.tar.gz" -type f | wc -l)
TOTAL_SIZE=\$(du -sh "\$BACKUP_DEST" | cut -f1)
log "📊 当前备份数: \$TOTAL, 总大小: \$TOTAL_SIZE"

# ---- 可选：通知 ----
# curl -s -X POST "https://hooks.slack.com/services/YOUR/WEBHOOK" \\
#   -H 'Content-type: application/json' \\
#   -d "{\"text\": \"✅ 备份完成: \$BACKUP_FILE (\$SIZE)\"}"

exit 0
SCRIPT
}

gen_deploy() {
    local name="${NAME:-myapp}"
    local remote="${REMOTE:-user@server}"
    cat <<SCRIPT
#!/usr/bin/env bash
# ============================================
# 部署脚本
# 项目: ${name}
# 生成时间: $(date '+%Y-%m-%d %H:%M:%S')
# ============================================

set -euo pipefail

# ---- 配置 ----
APP_NAME="${name}"
DEPLOY_USER="deploy"
DEPLOY_HOST="${remote}"
DEPLOY_PATH="/var/www/\${APP_NAME}"
BRANCH="main"
RESTART_CMD="pm2 restart \${APP_NAME}"
# RESTART_CMD="systemctl restart \${APP_NAME}"
# RESTART_CMD="docker-compose -f \${DEPLOY_PATH}/docker-compose.yml up -d --build"

# ---- 颜色 ----
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log()   { echo -e "\${BLUE}[部署]\${NC} \$*"; }
ok()    { echo -e "\${GREEN}[✅]\${NC} \$*"; }
warn()  { echo -e "\${YELLOW}[⚠️]\${NC} \$*"; }
fail()  { echo -e "\${RED}[❌]\${NC} \$*" >&2; exit 1; }

# ---- Step 1: 预检查 ----
log "Step 1/6: 预检查..."

# 检查 Git 状态
if [[ -n \$(git status --porcelain 2>/dev/null) ]]; then
    warn "工作目录有未提交的更改！"
    read -p "继续部署？(y/N) " -n 1 -r
    echo
    [[ \$REPLY =~ ^[Yy]\$ ]] || exit 0
fi

CURRENT_BRANCH=\$(git rev-parse --abbrev-ref HEAD)
if [[ "\$CURRENT_BRANCH" != "\$BRANCH" ]]; then
    warn "当前分支: \$CURRENT_BRANCH (预期: \$BRANCH)"
    read -p "继续？(y/N) " -n 1 -r
    echo
    [[ \$REPLY =~ ^[Yy]\$ ]] || exit 0
fi

GIT_HASH=\$(git rev-parse --short HEAD)
GIT_MSG=\$(git log -1 --pretty=%B | head -1)
log "部署版本: \$GIT_HASH - \$GIT_MSG"

# ---- Step 2: 测试 ----
log "Step 2/6: 运行测试..."
if command -v npm &>/dev/null && [[ -f "package.json" ]]; then
    npm test 2>/dev/null && ok "测试通过" || fail "测试失败，终止部署"
elif command -v pytest &>/dev/null; then
    pytest --quiet 2>/dev/null && ok "测试通过" || fail "测试失败"
else
    warn "未找到测试框架，跳过"
fi

# ---- Step 3: 构建 ----
log "Step 3/6: 构建项目..."
if [[ -f "package.json" ]]; then
    npm run build 2>/dev/null && ok "构建完成" || fail "构建失败"
elif [[ -f "Makefile" ]]; then
    make build && ok "构建完成" || fail "构建失败"
else
    ok "无构建步骤"
fi

# ---- Step 4: 上传 ----
log "Step 4/6: 上传文件..."
rsync -avz --delete \
    --exclude='.git' \
    --exclude='node_modules' \
    --exclude='.env' \
    --exclude='__pycache__' \
    --exclude='.venv' \
    ./ "\${DEPLOY_USER}@\${DEPLOY_HOST}:\${DEPLOY_PATH}/" \
    && ok "文件同步完成" || fail "文件同步失败"

# ---- Step 5: 远程安装依赖 ----
log "Step 5/6: 安装依赖..."
ssh "\${DEPLOY_USER}@\${DEPLOY_HOST}" << REMOTE
    cd "\${DEPLOY_PATH}"
    if [[ -f "package.json" ]]; then
        npm ci --production
    elif [[ -f "requirements.txt" ]]; then
        pip install -r requirements.txt
    elif [[ -f "go.mod" ]]; then
        go build -o app .
    fi
REMOTE
ok "依赖安装完成"

# ---- Step 6: 重启服务 ----
log "Step 6/6: 重启服务..."
ssh "\${DEPLOY_USER}@\${DEPLOY_HOST}" "\${RESTART_CMD}" \
    && ok "服务重启成功" || fail "服务重启失败"

# ---- 完成 ----
echo ""
echo -e "\${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\${NC}"
echo -e "\${GREEN}  🚀 部署完成！\${NC}"
echo -e "\${GREEN}  应用: \${APP_NAME}\${NC}"
echo -e "\${GREEN}  版本: \${GIT_HASH}\${NC}"
echo -e "\${GREEN}  服务器: \${DEPLOY_HOST}\${NC}"
echo -e "\${GREEN}  时间: \$(date '+%Y-%m-%d %H:%M:%S')\${NC}"
echo -e "\${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\${NC}"
SCRIPT
}

gen_monitor() {
    local name="${NAME:-myapp}"
    cat <<SCRIPT
#!/usr/bin/env bash
# ============================================
# 服务监控脚本
# 生成时间: $(date '+%Y-%m-%d %H:%M:%S')
# ============================================
# Cron: */5 * * * * /path/to/monitor.sh

set -euo pipefail

# ---- 配置 ----
APP_NAME="${name}"
CHECK_URL="http://localhost:3000/health"
CHECK_TIMEOUT=5
RESTART_CMD="pm2 restart \${APP_NAME}"
# ALERT_WEBHOOK="https://hooks.slack.com/services/..."
MAX_CPU=90
MAX_MEM=85
MAX_DISK=90

LOG="/var/log/\${APP_NAME}_monitor.log"

log() { echo "\$(date '+%Y-%m-%d %H:%M:%S') \$*" >> "\$LOG"; }

# ---- HTTP 健康检查 ----
HTTP_CODE=\$(curl -s -o /dev/null -w "%{http_code}" --max-time \$CHECK_TIMEOUT "\$CHECK_URL" 2>/dev/null || echo "000")
if [[ "\$HTTP_CODE" != "200" ]]; then
    log "❌ 健康检查失败 (HTTP \$HTTP_CODE)，正在重启..."
    \$RESTART_CMD
    log "🔄 已执行重启命令"
    # 通知（可选）
    # curl -s -X POST "\$ALERT_WEBHOOK" -d "{\"text\": \"⚠️ \$APP_NAME 健康检查失败，已自动重启\"}"
else
    log "✅ 健康检查通过"
fi

# ---- 系统资源检查 ----
CPU=\$(top -bn1 | grep "Cpu(s)" | awk '{print int(\$2)}' 2>/dev/null || echo 0)
MEM=\$(free | awk '/Mem:/ {printf("%d", \$3/\$2 * 100)}' 2>/dev/null || echo 0)
DISK=\$(df / | awk 'NR==2 {print int(\$5)}' 2>/dev/null || echo 0)

[[ \$CPU -gt \$MAX_CPU ]] && log "⚠️ CPU 使用率过高: \${CPU}%"
[[ \$MEM -gt \$MAX_MEM ]] && log "⚠️ 内存使用率过高: \${MEM}%"
[[ \$DISK -gt \$MAX_DISK ]] && log "⚠️ 磁盘使用率过高: \${DISK}%"
SCRIPT
}

gen_setup() {
    cat <<'SCRIPT'
#!/usr/bin/env bash
# ============================================
# 服务器初始化脚本 (Ubuntu/Debian)
# ============================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

log() { echo -e "${GREEN}[设置]${NC} $*"; }
need_root() { [[ $EUID -eq 0 ]] || { echo "请用 sudo 运行"; exit 1; }; }

need_root

log "更新系统..."
apt-get update -y && apt-get upgrade -y

log "安装基础工具..."
apt-get install -y \
    curl wget git vim htop tree \
    build-essential \
    ufw fail2ban \
    nginx certbot python3-certbot-nginx

log "配置防火墙..."
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 'Nginx Full'
ufw --force enable

log "配置 fail2ban..."
cat > /etc/fail2ban/jail.local <<EOF
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 5
bantime = 3600
EOF
systemctl restart fail2ban

log "配置 SSH 安全..."
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd

log "创建交换空间 (2GB)..."
if [[ ! -f /swapfile ]]; then
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi

log "设置时区..."
timedatectl set-timezone Asia/Shanghai

log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log "✅ 服务器初始化完成！"
log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
SCRIPT
}

lint_script() {
    local file="${FILE}"
    if [[ -z "$file" ]]; then
        echo "用法: shell.sh lint --file <script.sh>"
        exit 1
    fi
    if [[ ! -f "$file" ]]; then
        echo "❌ 文件不存在: $file"
        exit 1
    fi

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  🔍 Shell 脚本检查: $file"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    local issues=0

    # Check shebang
    local first_line
    first_line=$(head -1 "$file")
    if [[ "$first_line" != "#!/"* ]]; then
        echo "⚠️  缺少 shebang (#!/usr/bin/env bash)"
        ((issues++))
    fi

    # Check set -e
    if ! grep -q 'set -e' "$file"; then
        echo "⚠️  建议添加 set -euo pipefail（遇错即停）"
        ((issues++))
    fi

    # Check unquoted variables
    local unquoted
    unquoted=$(grep -nE '\$[A-Za-z_]+[^"'"'"']' "$file" | grep -v '^#' | head -10 || true)
    if [[ -n "$unquoted" ]]; then
        echo "⚠️  可能有未引号包裹的变量："
        echo "$unquoted" | head -5 | sed 's/^/   /'
        ((issues++))
    fi

    # Check for common issues
    grep -nE 'rm -rf /' "$file" && echo "🚨 危险: 检测到 rm -rf / ！" && ((issues++))
    grep -nE 'eval ' "$file" && echo "⚠️  使用了 eval，注意安全风险" && ((issues++))

    # Check executable permission
    if [[ ! -x "$file" ]]; then
        echo "ℹ️  文件没有执行权限，运行: chmod +x $file"
    fi

    # Try bash syntax check
    if bash -n "$file" 2>/dev/null; then
        echo "✅ 语法检查通过（bash -n）"
    else
        echo "❌ 语法错误："
        bash -n "$file" 2>&1 | sed 's/^/   /'
        ((issues++))
    fi

    echo ""
    if [[ $issues -eq 0 ]]; then
        echo "✅ 未发现明显问题"
    else
        echo "📊 发现 $issues 个潜在问题"
    fi
}

case "$CMD" in
    template|gen)
        case "$TYPE" in
            backup)  gen_backup ;;
            deploy)  gen_deploy ;;
            monitor) gen_monitor ;;
            setup)   gen_setup ;;
            *)
                echo "可用模板: backup, deploy, monitor, setup"
                echo "用法: shell.sh template --type <type>"
                ;;
        esac
        ;;
    lint|check)
        lint_script ;;
    *)
        cat <<'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📜 Shell Script Generator — 使用指南
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  命令                  说明
  ──────────────────────────────────────────
  template              生成脚本模板
    --type backup         备份脚本（含定时清理、日志）
    --type deploy         部署脚本（含测试、构建、同步）
    --type monitor        监控脚本（HTTP检查+系统资源）
    --type setup          服务器初始化脚本

    --name NAME           项目名
    --source PATH         源目录 (backup)
    --dest PATH           目标目录 (backup)
    --remote USER@HOST    远程服务器 (deploy)

  lint                  脚本语法检查
    --file PATH           要检查的脚本文件

  示例:
    shell.sh template --type backup --source /var/www --dest /backup
    shell.sh template --type deploy --name myapp --remote deploy@prod
    shell.sh template --type monitor --name myapp
    shell.sh template --type setup
    shell.sh lint --file deploy.sh
EOF
        ;;
esac
