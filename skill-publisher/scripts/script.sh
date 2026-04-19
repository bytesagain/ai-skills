#!/usr/bin/env bash
# skill-publisher — BytesAgain skill 开发发布全流程工具（内部自用）
set -euo pipefail

SCRIPTS_DIR="/home/admin/.openclaw/workspace/scripts"
CRONS_DIR="/home/admin/crons"
SKILLS_REPO="/home/admin/skills-repo"
ENV_FILE="/home/admin/.openclaw/workspace/projects/crypto-content/.env"
CLAWHUB_CONFIG="$HOME/.config/clawhub/config.json"

_log() { echo "[$(date '+%H:%M:%S')] $*"; }

# 读取 token
_get_token() {
    local n="$1"
    grep "CLAWHUB_TOKEN_${n}=" "$ENV_FILE" | cut -d= -f2
}

# 切换账号
_switch_account() {
    local n="$1"
    local tok
    tok=$(_get_token "$n")
    [[ -z "$tok" ]] && { echo "❌ TOKEN_${n} 不存在"; exit 1; }
    echo "{\"registry\":\"https://clawhub.ai\",\"token\":\"$tok\"}" > "$CLAWHUB_CONFIG"
    clawhub whoami 2>&1 | grep -v "Checking token"
}

cmd_create() {
    local slug="${1:-}"; local desc="${2:-}"
    [[ -z "$slug" || -z "$desc" ]] && { echo "Usage: create <slug> \"<description>\""; exit 1; }
    _log "创建 $slug..."
    bash "$SCRIPTS_DIR/skill-developer.sh" create "$slug" "$desc"
    echo ""
    echo "⚠️  模板生成后必须手动修正（见 SKILL_STANDARD.md §11.17）："
    echo "   1. 完全重写 ## Commands 章节（模板是占位符 intro/theory/methods...）"
    echo "   2. 删除 frontmatter 里的 category: general"
    echo "   3. 删除末尾多余的 ---"
    echo "   4. 删除脚本里的 DATA_DIR 和 mkdir -p"
    echo "   5. 用 python3 插入 Triggers on 段落"
    echo ""
    echo "完成后运行: bash scripts/script.sh audit $slug"
}

cmd_audit() {
    local slug="${1:-}"
    [[ -z "$slug" ]] && { echo "Usage: audit <slug>"; exit 1; }
    bash "$SCRIPTS_DIR/skill-audit.sh" "$slug"
}

cmd_publish() {
    local slug="${1:-}"; local token_n="${2:-5}"; local version="${3:-1.0.0}"
    [[ -z "$slug" ]] && { echo "Usage: publish <slug> <token_number> [version]"; exit 1; }

    # 先做 audit
    _log "发布前自动审核..."
    if ! bash "$SCRIPTS_DIR/skill-audit.sh" "$slug" 2>&1 | grep -q "🟢"; then
        echo ""
        echo "❌ 审核未通过，修复后重试"
        exit 1
    fi

    _log "切换账号 TOKEN_${token_n}..."
    _switch_account "$token_n"

    _log "发布 $slug@$version..."
    clawhub publish "$SKILLS_REPO/$slug" --version "$version" --changelog "Published via skill-publisher"
    echo ""
    echo "✅ 发布成功！等待审核（5-10分钟）..."
    echo "   运行查状态: bash scripts/script.sh check $slug"
}

cmd_check() {
    local slug="${1:-}"; local owner="${2:-loutai0307-prog}"
    [[ -z "$slug" ]] && { echo "Usage: check <slug> [owner]"; exit 1; }

    _log "查询 $slug 审核状态..."
    result=$(curl -s "https://clawhub.ai/${owner}/${slug}" | python3 -c "
import sys, re
html = sys.stdin.read()
m = re.search(r'isSuspicious:(true|false)', html)
status = m.group(1) if m else '?'
ver = re.search(r'version:\"([^\"]+)\"', html)
v = ver.group(1) if ver else '?'
if status == 'false':
    print(f'✅ Benign v{v} — 可以同步网站')
elif status == 'true':
    # 找评语
    desc = re.findall(r'analysis-summary-text[^>]*>(.*?)</span>', html)
    reason = desc[0][:150] if desc else '详情见浏览器'
    import html as h
    print(f'🔴 Suspicious v{v}')
    print(f'   原因: {h.unescape(reason)}')
else:
    print(f'⏳ 审核中 v{v}（稍后再查）')
" 2>/dev/null)
    echo "$result"
    echo "   链接: https://clawhub.ai/${owner}/${slug}"
}

cmd_sync() {
    [[ $# -eq 0 ]] && { echo "Usage: sync <slug> [slug2 ...]"; exit 1; }
    _log "同步到网站数据库..."
    python3 "$CRONS_DIR/sync-new-skill.py" "$@"
}

cmd_full() {
    local slug="${1:-}"; local token_n="${2:-5}"
    [[ -z "$slug" ]] && { echo "Usage: full <slug> <token_number>"; exit 1; }

    echo "🚀 完整发布流程: $slug"
    echo ""

    # 1. Audit
    echo "── Step 1: 审核 ──"
    cmd_audit "$slug" || { echo "❌ 审核失败，流程中止"; exit 1; }

    # 2. Publish
    echo "── Step 2: 发布 ──"
    _switch_account "$token_n"
    clawhub publish "$SKILLS_REPO/$slug" --version 1.0.0 --changelog "Initial release"

    # 3. 等待审核
    echo ""
    echo "── Step 3: 等待审核（60秒）──"
    sleep 60

    # 4. 查状态
    echo "── Step 4: 审核状态 ──"
    cmd_check "$slug"

    # 5. 同步网站
    echo ""
    echo "── Step 5: 同步网站 ──"
    cmd_sync "$slug"

    echo ""
    echo "✅ 全流程完成！访问: https://bytesagain.com/skill/$slug"
}

cmd_accounts() {
    _log "查询所有账号状态..."
    for i in 2 3 4 5 7 8 9; do
        tok=$(_get_token "$i" 2>/dev/null || echo "")
        [[ -z "$tok" ]] && continue
        echo "{\"registry\":\"https://clawhub.ai\",\"token\":\"$tok\"}" > "$CLAWHUB_CONFIG"
        user=$(clawhub whoami 2>&1 | grep "✔" | awk '{print $2}' || echo "?")
        echo "  TOKEN_${i}: ${user}"
        sleep 2
    done
}

cmd_help() {
    cat << 'EOF'
skill-publisher — BytesAgain skill 开发发布全流程（内部自用）

Commands:
  create  <slug> "<desc>"          新建 skill 模板
  audit   <slug>                   发布前完整审核（6大项）
  publish <slug> <token_n> [ver]   审核+发布到 ClawHub
  check   <slug> [owner]           查 ClawHub 审核状态
  sync    <slug> [slug2 ...]       同步到网站数据库
  full    <slug> <token_n>         一键完整流程
  accounts                         查看所有账号
  help                             显示帮助

Token 对应账号:
  2=ckchzh  3=xueyetianya  4=bytesagain1
  5=loutai0307-prog  7=bytesagain3
  8=bytesagain-lab   9=PRESSBYTESAGAIN

标准文档: /home/admin/.openclaw/workspace/SKILL_STANDARD.md
关键章节: §11.16(高权限API) §11.17(模板缺陷) §11.9(命令对齐) §11.2(审核失败)

Powered by BytesAgain | bytesagain.com
EOF
}

case "${1:-help}" in
    create)   shift; cmd_create "$@" ;;
    audit)    shift; cmd_audit "$@" ;;
    publish)  shift; cmd_publish "$@" ;;
    check)    shift; cmd_check "$@" ;;
    sync)     shift; cmd_sync "$@" ;;
    full)     shift; cmd_full "$@" ;;
    accounts) cmd_accounts ;;
    help|*)   cmd_help ;;
esac
