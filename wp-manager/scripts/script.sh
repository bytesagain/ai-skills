#!/usr/bin/env bash
# wp-manager — WordPress site management toolkit
# Full CRUD for pages/posts with cookie auth
set -euo pipefail
VERSION="4.0.0"
DATA_DIR="${WP_MANAGER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/wp-manager}"
mkdir -p "$DATA_DIR"

WP_URL="${WP_URL:-https://bytesagain.com}"
WP_USER="${WP_USER:-ckchzh}"
COOKIE_JAR="$DATA_DIR/cookies.txt"
SESSION_FILE="$DATA_DIR/session.json"

# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }
_info() { echo "[INFO] $*"; }
_error() { echo "[ERROR] $*" >&2; }
die() { _error "$@"; exit 1; }

# ============================================================
#  Auth — login + nonce management
# ============================================================
cmd_login() {
    local password="${1:-}"
    if [ -z "$password" ]; then
        # Try from env file
        local env_file="/home/admin/.openclaw/workspace/projects/crypto-content/.env"
        if [ -f "$env_file" ]; then
            password=$(grep "^WP_PASS=" "$env_file" | cut -d= -f2)
        fi
    fi
    [ -z "$password" ] && die "Usage: wp-manager login <password> or set WP_PASS in .env"

    rm -f "$COOKIE_JAR"
    local http_code
    http_code=$(curl -sk -c "$COOKIE_JAR" -X POST "$WP_URL/wp-login.php" \
        --data-urlencode "log=$WP_USER" \
        --data-urlencode "pwd=$password" \
        --data-urlencode "wp-submit=Log In" \
        --data-urlencode "redirect_to=$WP_URL/wp-admin/" \
        -L -o /dev/null -w "%{http_code}" --max-time 15 2>/dev/null)

    if [ "$http_code" = "200" ] && grep -q "wordpress_logged_in" "$COOKIE_JAR" 2>/dev/null; then
        # Get REST nonce
        local nonce
        nonce=$(curl -sk -b "$COOKIE_JAR" "$WP_URL/wp-admin/admin-ajax.php?action=rest-nonce" --max-time 10 2>/dev/null)
        if [ -n "$nonce" ] && [ "$nonce" != "0" ]; then
            echo "{\"nonce\":\"$nonce\",\"time\":$(date +%s),\"user\":\"$WP_USER\"}" > "$SESSION_FILE"
            _info "Login OK (nonce: ${nonce:0:6}...)"
            _log "login" "success"
        else
            die "Login succeeded but nonce failed"
        fi
    else
        die "Login failed (HTTP $http_code)"
    fi
}

_ensure_auth() {
    # Check if session is valid (less than 10 min old)
    if [ -f "$SESSION_FILE" ] && [ -f "$COOKIE_JAR" ]; then
        local session_time
        session_time=$(python3 -c "import json; print(json.load(open('$SESSION_FILE')).get('time',0))" 2>/dev/null || echo 0)
        local now=$(date +%s)
        local age=$(( now - session_time ))
        if [ "$age" -lt 600 ]; then
            return 0
        fi
    fi
    # Auto-login
    _info "Session expired, re-logging in..."
    cmd_login
}

_get_nonce() {
    python3 -c "import json; print(json.load(open('$SESSION_FILE'))['nonce'])" 2>/dev/null
}

_wp_get() {
    _ensure_auth
    local endpoint="$1"
    curl -sk -b "$COOKIE_JAR" -H "X-WP-Nonce: $(_get_nonce)" \
        "$WP_URL/wp-json/wp/v2/$endpoint" --max-time 15 2>/dev/null
}

_wp_post() {
    _ensure_auth
    local endpoint="$1"
    shift
    curl -sk -b "$COOKIE_JAR" -H "X-WP-Nonce: $(_get_nonce)" \
        -X POST "$WP_URL/wp-json/wp/v2/$endpoint" "$@" --max-time 15 2>/dev/null
}

_wp_delete() {
    _ensure_auth
    local endpoint="$1"
    curl -sk -b "$COOKIE_JAR" -H "X-WP-Nonce: $(_get_nonce)" \
        -X DELETE "$WP_URL/wp-json/wp/v2/$endpoint" --max-time 15 2>/dev/null
}

# ============================================================
#  Content — list, search, create, delete
# ============================================================
cmd_status() {
    echo "=== WordPress Status ==="
    local code
    code=$(curl -sk -o /dev/null -w "%{http_code}" "$WP_URL" --max-time 10 2>/dev/null || echo "000")
    if [ "$code" = "200" ]; then echo "Site: UP ($code)"
    else echo "Site: DOWN ($code)"; fi
    echo "URL: $WP_URL"
    if [ -f "$SESSION_FILE" ]; then
        local age=$(( $(date +%s) - $(python3 -c "import json; print(json.load(open('$SESSION_FILE')).get('time',0))" 2>/dev/null || echo 0) ))
        echo "Session: ${age}s old"
    else
        echo "Session: not logged in"
    fi
}

cmd_list_pages() {
    local count="${1:-20}"
    local page="${2:-1}"
    _wp_get "pages?per_page=$count&page=$page&_fields=id,slug,title,status,date" | \
        python3 << 'PYEOF'
import json, sys
try:
    data = json.load(sys.stdin)
    if isinstance(data, list):
        print("=== Pages (showing %d) ===" % len(data))
        for p in data:
            t = p.get("title", {}).get("rendered", "?")
            print("  [%d] %-40s %s (%s)" % (p["id"], p.get("slug","")[:40], p.get("date","")[:10], p.get("status","")))
    else:
        print("Error: %s" % str(data)[:100])
except:
    print("Failed to parse response")
PYEOF
}

cmd_list_all_pages() {
    echo "=== Fetching all pages ==="
    local page=1
    local total=0
    > "$DATA_DIR/all-pages.jsonl"
    while true; do
        local data
        data=$(_wp_get "pages?per_page=100&page=$page&_fields=id,slug,status")
        local count
        count=$(echo "$data" | python3 -c 'import json,sys; print(len(json.load(sys.stdin)))' 2>/dev/null || echo 0)
        [ "$count" = "0" ] || [ -z "$count" ] && break
        echo "$data" | python3 -c '
import json, sys
for p in json.load(sys.stdin):
    print(json.dumps({"id":p["id"],"slug":p.get("slug",""),"status":p.get("status","")}))
' >> "$DATA_DIR/all-pages.jsonl"
        total=$((total + count))
        echo "  Page $page: $count pages (total: $total)"
        page=$((page + 1))
        sleep 0.5
    done
    echo "Total: $total pages saved to $DATA_DIR/all-pages.jsonl"
}

cmd_list_posts() {
    local count="${1:-10}"
    _wp_get "posts?per_page=$count&_fields=id,slug,title,status,date" | \
        python3 << 'PYEOF'
import json, sys
try:
    data = json.load(sys.stdin)
    if isinstance(data, list):
        print("=== Posts (%d) ===" % len(data))
        for p in data:
            t = p.get("title", {}).get("rendered", "?")
            print("  [%d] %s %s (%s)" % (p["id"], p.get("date","")[:10], t[:50], p.get("status","")))
except:
    print("Failed to parse response")
PYEOF
}

cmd_search() {
    local query="${1:?Usage: wp-manager search <query>}"
    _wp_get "search?search=$query&per_page=20" | python3 << 'PYEOF'
import json, sys
for r in json.load(sys.stdin):
    print("  [%s] %s — %s" % (r.get("id","?"), r.get("type","?"), r.get("title","?")))
PYEOF
}

cmd_create_page() {
    local title="${1:?Usage: wp-manager create-page <title> [content] [slug] [status]}"
    local content="${2:-}"
    local slug="${3:-}"
    local status="${4:-publish}"

    local args="-d title=$title -d status=$status"
    [ -n "$content" ] && args="$args --data-urlencode content=$content"
    [ -n "$slug" ] && args="$args -d slug=$slug"

    _wp_post "pages" -d "title=$title" -d "status=$status" \
        ${content:+--data-urlencode "content=$content"} \
        ${slug:+-d "slug=$slug"} | \
        python3 -c 'import json,sys; d=json.load(sys.stdin); print("Created: [%d] %s" % (d.get("id",0), d.get("slug","?")))' 2>/dev/null
    _log "create-page" "$title"
}

cmd_delete_page() {
    local page_id="${1:?Usage: wp-manager delete-page <id> [force]}"
    local force="${2:-true}"
    local result
    result=$(_wp_delete "pages/$page_id?force=$force")
    echo "$result" | python3 -c '
import json, sys
try:
    d = json.load(sys.stdin)
    if d.get("deleted"):
        print("Deleted: [%d] %s" % (d.get("previous",{}).get("id",0), d.get("previous",{}).get("slug","?")))
    else:
        print("Failed: %s" % str(d)[:100])
except:
    print("Delete response error")
' 2>/dev/null
    _log "delete-page" "id=$page_id"
}

cmd_delete_batch() {
    local file="${1:?Usage: wp-manager delete-batch <ids-file>}"
    [ ! -f "$file" ] && die "File not found: $file"
    local total=0
    local deleted=0
    while IFS= read -r page_id; do
        [ -z "$page_id" ] && continue
        total=$((total + 1))
        local result
        result=$(_wp_delete "pages/$page_id?force=true")
        if echo "$result" | grep -q '"deleted":true'; then
            deleted=$((deleted + 1))
            echo "  ✅ Deleted $page_id"
        else
            echo "  ❌ Failed $page_id"
        fi
        sleep 0.5
    done < "$file"
    echo "=== Deleted: $deleted / $total ==="
    _log "delete-batch" "$deleted/$total from $file"
}

# ============================================================
#  Duplicate detection — find and clean duplicate pages
# ============================================================
cmd_find_duplicates() {
    echo "=== Scanning for duplicate pages ==="
    # First fetch all pages
    cmd_list_all_pages

    python3 << 'PYEOF'
import json, re, os
from collections import defaultdict

data_dir = os.environ.get("DATA_DIR", os.path.expanduser("~/.local/share/wp-manager"))
pages_file = os.path.join(data_dir, "all-pages.jsonl")

if not os.path.isfile(pages_file):
    print("No pages data. Run list-all-pages first.")
    exit(1)

pages = []
with open(pages_file) as f:
    for line in f:
        if line.strip():
            pages.append(json.loads(line))

print("Total pages: %d" % len(pages))

# Group by base slug (remove trailing -N suffix)
groups = defaultdict(list)
for p in pages:
    slug = p.get("slug", "")
    m = re.match(r"(.+?)(-\d+)$", slug)
    if m:
        base = m.group(1)
        groups[base].append({"slug": slug, "id": p["id"], "copy": True})
    else:
        groups[slug].append({"slug": slug, "id": p["id"], "copy": False})

dupes = {k: v for k, v in groups.items() if len(v) > 1}
if not dupes:
    print("No duplicate pages found!")
    exit(0)

print("\nDuplicate groups: %d" % len(dupes))
delete_ids = []
for base in sorted(dupes.keys()):
    items = dupes[base]
    copies = [p for p in items if p["copy"]]
    for p in copies:
        delete_ids.append(p["id"])
    names = ", ".join("%s(id=%d)" % (p["slug"], p["id"]) for p in items)
    print("  %s: %s" % (base, names))

print("\nTotal pages to delete: %d" % len(delete_ids))

# Save delete IDs
ids_file = os.path.join(data_dir, "duplicate-ids.txt")
with open(ids_file, "w") as f:
    for pid in delete_ids:
        f.write("%d\n" % pid)
print("Delete IDs saved to: %s" % ids_file)
print("Run: wp-manager delete-batch %s" % ids_file)
PYEOF
}

cmd_clean_duplicates() {
    local ids_file="$DATA_DIR/duplicate-ids.txt"
    if [ ! -f "$ids_file" ]; then
        echo "No duplicate IDs found. Run find-duplicates first."
        return 1
    fi
    local count=$(wc -l < "$ids_file")
    echo "About to delete $count duplicate pages. Continue? (y/n)"
    read -r confirm
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        cmd_delete_batch "$ids_file"
    else
        echo "Cancelled."
    fi
}

# ============================================================
#  Blacklist cleanup — remove pages for blacklisted skills
# ============================================================
cmd_clean_blacklisted() {
    local bl_file="${1:-/home/admin/.openclaw/workspace/blacklist.txt}"
    echo "=== Cleaning pages for blacklisted skills ==="

    if [ ! -f "$DATA_DIR/all-pages.jsonl" ]; then
        echo "Fetching all pages first..."
        cmd_list_all_pages
    fi

    export BL_FILE="$bl_file"
    python3 << 'PYEOF'
import json, re, os

data_dir = os.environ.get("DATA_DIR", os.path.expanduser("~/.local/share/wp-manager"))
pages_file = os.path.join(data_dir, "all-pages.jsonl")
bl_file = os.environ.get("BL_FILE", "")

bl = set()
if os.path.isfile(bl_file):
    bl = set(l.strip() for l in open(bl_file) if l.strip())

pages = []
with open(pages_file) as f:
    for line in f:
        if line.strip():
            pages.append(json.loads(line))

# Find pages whose slug matches blacklisted skills
delete_ids = []
for p in pages:
    slug = p.get("slug", "")
    # Extract skill name: "skill-xxx" or "skill-xxx-N" -> "xxx"
    m = re.match(r"skill-(.+?)(-\d+)?$", slug)
    if m:
        skill_name = m.group(1)
        if skill_name in bl:
            delete_ids.append(p["id"])
            print("  Found: %s (id=%d) -> skill=%s" % (slug, p["id"], skill_name))

print("\nBlacklisted pages to delete: %d" % len(delete_ids))

ids_file = os.path.join(data_dir, "blacklisted-ids.txt")
with open(ids_file, "w") as f:
    for pid in delete_ids:
        f.write("%d\n" % pid)
print("Delete IDs saved to: %s" % ids_file)
if delete_ids:
    print("Run: wp-manager delete-batch %s" % ids_file)
PYEOF
}

# ============================================================
#  Site tools
# ============================================================
cmd_info() {
    _wp_get "" | python3 << 'PYEOF'
import json, sys
try:
    d = json.load(sys.stdin)
    print("=== Site Info ===")
    print("  Name: %s" % d.get("name", "?"))
    print("  URL:  %s" % d.get("url", "?"))
    print("  Desc: %s" % d.get("description", "?"))
except:
    print("Could not fetch site info")
PYEOF
}

cmd_page_count() {
    echo "=== Page Count ==="
    if [ -f "$DATA_DIR/all-pages.jsonl" ]; then
        local count=$(wc -l < "$DATA_DIR/all-pages.jsonl")
        echo "  Cached: $count pages"
        echo "  (run list-all-pages to refresh)"
    else
        echo "  No cached data. Run list-all-pages first."
    fi
}

cmd_sitemap() {
    echo "  Sitemap: $WP_URL/wp-sitemap.xml"
    echo "  Yoast:   $WP_URL/sitemap_index.xml"
}

# ============================================================
#  Help
# ============================================================
show_help() {
    cat << EOF
wp-manager v$VERSION — WordPress management toolkit

Usage: wp-manager <command> [args]

Auth:
  login [password]         Login (auto-reads .env if no password)
  status                   Site + session status

Content:
  list-pages [n] [page]    List pages (paginated)
  list-all-pages           Fetch ALL pages to local cache
  list-posts [n]           List recent posts
  search <query>           Search content
  create-page <title> [content] [slug] [status]
  delete-page <id>         Delete a page by ID
  delete-batch <file>      Delete pages from ID list file

Cleanup:
  find-duplicates          Find duplicate pages (saves IDs)
  clean-duplicates         Delete found duplicates (interactive)
  clean-blacklisted [file] Find+save pages for blacklisted skills

Site:
  info                     Site info
  page-count               Cached page count
  sitemap                  Sitemap URLs

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
}

export DATA_DIR
case "${1:-help}" in
    login)              shift; cmd_login "$@" ;;
    status)             cmd_status ;;
    list-pages|lp)      shift; cmd_list_pages "$@" ;;
    list-all-pages|lap) cmd_list_all_pages ;;
    list-posts)         shift; cmd_list_posts "$@" ;;
    search)             shift; cmd_search "$@" ;;
    create-page|cp)     shift; cmd_create_page "$@" ;;
    delete-page|dp)     shift; cmd_delete_page "$@" ;;
    delete-batch|db)    shift; cmd_delete_batch "$@" ;;
    find-duplicates|fd) cmd_find_duplicates ;;
    clean-duplicates|cd) cmd_clean_duplicates ;;
    clean-blacklisted|cb) shift; cmd_clean_blacklisted "$@" ;;
    info)               cmd_info ;;
    page-count|pc)      cmd_page_count ;;
    sitemap)            cmd_sitemap ;;
    help|-h)            show_help ;;
    version|-v)         echo "wp-manager v$VERSION" ;;
    *)                  echo "Unknown: $1"; show_help; exit 1 ;;
esac
