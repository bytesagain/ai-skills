#!/usr/bin/env bash
# wp-manager — WordPress site management toolkit
set -euo pipefail
VERSION="2.0.0"
DATA_DIR="${WP_MANAGER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/wp-manager}"
mkdir -p "$DATA_DIR"

show_help() {
    cat << EOF
wp-manager v$VERSION — WordPress management toolkit

Usage: wp-manager <command> [args]

Content:
  list-posts [n]         List recent posts
  list-pages [n]         List recent pages
  search <query>         Search content

Site:
  status                 Site health check
  info                   Site info
  security-scan          Security checklist
  performance            Performance tips
  sitemap                Sitemap info
  robots                 Robots.txt template
  help                   Show this help
EOF
}

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

cmd_status() {
    echo "  === WordPress Health Check ==="
    local url="${WP_URL:-https://bytesagain.com}"
    local code=$(curl -s -o /dev/null -w "%{http_code}" "$url" --max-time 10 2>/dev/null || echo "000")
    if [ "$code" = "200" ]; then echo "  Site: UP ($code)"
    else echo "  Site: DOWN ($code)"; fi
    echo "  URL: $url"
}

cmd_info() {
    local url="${WP_URL:-https://bytesagain.com}"
    echo "  === Site Info ==="
    curl -s "$url/wp-json/" 2>/dev/null | python3 -c "
import json,sys
d=json.load(sys.stdin)
print('  Name: ' + d.get('name',''))
print('  URL:  ' + d.get('url',''))
print('  Desc: ' + d.get('description',''))
" 2>/dev/null || echo "  Could not fetch"
}

cmd_list_posts() {
    local n="${1:-10}"
    local url="${WP_URL:-https://bytesagain.com}"
    echo "  === Recent Posts ==="
    curl -s "$url/wp-json/wp/v2/posts?per_page=$n&_fields=id,title,status,date" 2>/dev/null | python3 -c "
import json,sys
for p in json.load(sys.stdin):
    t=p.get('title',{}).get('rendered','?')
    print('  [{}] {} {} ({})'.format(p['id'],p['date'][:10],t,p['status']))
" 2>/dev/null || echo "  Could not fetch"
}

cmd_list_pages() {
    local n="${1:-10}"
    local url="${WP_URL:-https://bytesagain.com}"
    echo "  === Pages ==="
    curl -s "$url/wp-json/wp/v2/pages?per_page=$n&_fields=id,title,status" 2>/dev/null | python3 -c "
import json,sys
for p in json.load(sys.stdin):
    t=p.get('title',{}).get('rendered','?')
    print('  [{}] {} ({})'.format(p['id'],t,p['status']))
" 2>/dev/null || echo "  Could not fetch"
}

cmd_search() {
    local query="${1:?Usage: wp-manager search <query>}"
    local url="${WP_URL:-https://bytesagain.com}"
    curl -s "$url/wp-json/wp/v2/search?search=$query&per_page=10" 2>/dev/null | python3 -c "
import json,sys
for r in json.load(sys.stdin):
    print('  [{}] {} - {}'.format(r.get('id','?'),r.get('type','?'),r.get('title','?')))
" 2>/dev/null
}

cmd_security_scan() {
    echo "  === Security Checklist ==="
    echo "  [ ] WP + plugins updated?"
    echo "  [ ] Strong admin password?"
    echo "  [ ] Login attempts limited?"
    echo "  [ ] DISALLOW_FILE_EDIT set?"
    echo "  [ ] SSL/HTTPS enabled?"
    echo "  [ ] XML-RPC disabled?"
    echo "  [ ] Debug off in production?"
    echo "  [ ] Regular backups?"
    echo "  [ ] Unused themes removed?"
}

cmd_performance() {
    echo "  === Performance Tips ==="
    echo "  1. Enable caching plugin"
    echo "  2. Optimize images (WebP, lazy load)"
    echo "  3. Minimize CSS/JS"
    echo "  4. Use CDN (Cloudflare)"
    echo "  5. Reduce plugins"
    echo "  6. PHP 8.x"
    echo "  7. Clean post revisions"
}

cmd_sitemap() {
    local url="${WP_URL:-https://bytesagain.com}"
    echo "  Sitemap: $url/wp-sitemap.xml"
    echo "  Yoast:   $url/sitemap_index.xml"
    echo "  Submit to Google Search Console + Bing"
}

cmd_robots() {
    echo "  User-agent: *"
    echo "  Allow: /"
    echo "  Disallow: /wp-admin/"
    echo "  Allow: /wp-admin/admin-ajax.php"
    echo "  Sitemap: https://bytesagain.com/wp-sitemap.xml"
}

case "${1:-help}" in
    list-posts)     shift; cmd_list_posts "$@" ;;
    list-pages)     shift; cmd_list_pages "$@" ;;
    search)         shift; cmd_search "$@" ;;
    status)         cmd_status ;;
    info)           cmd_info ;;
    security-scan)  cmd_security_scan ;;
    performance)    cmd_performance ;;
    sitemap)        cmd_sitemap ;;
    robots)         cmd_robots ;;
    help|-h)        show_help ;;
    version|-v)     echo "wp-manager v$VERSION" ;;
    *)              echo "Unknown: $1"; show_help; exit 1 ;;
esac
