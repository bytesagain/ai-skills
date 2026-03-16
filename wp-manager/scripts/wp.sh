#!/bin/bash
# wp.sh — WordPress REST API manager
# Cookie-based auth, no plugins required
# Usage: wp.sh <command> [args...]

set -euo pipefail

COOKIE="/tmp/wp-session.txt"
NONCE_FILE="/tmp/wp-nonce.txt"

# Load env if available
if [ -f .env ]; then source .env 2>/dev/null; fi

WP_URL="${WP_URL:-}"
WP_USER="${WP_USER:-}"
WP_PASS="${WP_PASS:-}"

get_nonce() {
  [ -f "$NONCE_FILE" ] && cat "$NONCE_FILE" || echo ""
}

api() {
  local method="$1" endpoint="$2"
  shift 2
  local nonce
  nonce=$(get_nonce)
  curl -s -b "$COOKIE" \
    -X "$method" \
    -H "X-WP-Nonce: $nonce" \
    "$@" \
    "${WP_URL}/wp-json/wp/v2/${endpoint}"
}

cmd="${1:-help}"
shift 2>/dev/null || true

case "$cmd" in

  login)
    [ -z "$WP_URL" ] && { echo "❌ Set WP_URL, WP_USER, WP_PASS in .env"; exit 1; }
    rm -f "$COOKIE"
    curl -s -c "$COOKIE" \
      --data-urlencode "log=${WP_USER}" \
      --data-urlencode "pwd=${WP_PASS}" \
      --data-urlencode "wp-submit=Log In" \
      --data-urlencode "redirect_to=/wp-admin/" \
      --data-urlencode "testcookie=1" \
      -H "Cookie: wordpress_test_cookie=WP+Cookie+check" \
      -L -o /dev/null \
      "${WP_URL}/wp-login.php"
    # Extract nonce
    NONCE=$(curl -s -b "$COOKIE" "${WP_URL}/wp-admin/post-new.php" | grep -o '"nonce":"[^"]*' | head -1 | cut -d'"' -f4)
    if [ -z "$NONCE" ]; then
      echo "❌ Login failed — check credentials"
      exit 1
    fi
    echo "$NONCE" > "$NONCE_FILE"
    echo "✅ Logged in | Nonce: $NONCE"
    ;;

  posts)
    api GET "posts?per_page=${1:-10}&status=publish,draft" | python3 -c '
import sys, json
posts = json.load(sys.stdin)
if isinstance(posts, dict) and "message" in posts:
    print("❌", posts["message"]); sys.exit(1)
print("{:<5} {:<50} {:<10} {:<20}".format("ID","Title","Status","Date"))
print("-" * 90)
for p in posts:
    title = p["title"]["rendered"][:48]
    print("{:<5} {:<50} {:<10} {:<20}".format(p["id"], title, p["status"], p["date"][:10]))
'
    ;;

  post)
    api GET "posts/${1:?post ID required}" | python3 -c '
import sys, json
p = json.load(sys.stdin)
if "message" in p: print("❌", p["message"]); sys.exit(1)
print("ID:", p["id"])
print("Title:", p["title"]["rendered"])
print("Status:", p["status"])
print("Date:", p["date"])
print("Link:", p["link"])
print("---")
print(p["content"]["rendered"][:2000])
'
    ;;

  publish)
    TITLE="${1:?title required}"
    CONTENT="${2:?content required}"
    api POST "posts" \
      -H "Content-Type: application/json" \
      -d "$(python3 -c "import json; print(json.dumps({'title':'''$TITLE''','content':'''$CONTENT''','status':'publish'}))" 2>/dev/null || echo "{\"title\":\"$TITLE\",\"content\":\"$CONTENT\",\"status\":\"publish\"}")" | python3 -c '
import sys, json
p = json.load(sys.stdin)
if "id" in p: print("✅ Published:", p["title"]["rendered"], "| ID:", p["id"], "| URL:", p["link"])
else: print("❌", p.get("message","?"))
'
    ;;

  draft)
    TITLE="${1:?title required}"
    CONTENT="${2:?content required}"
    api POST "posts" \
      -H "Content-Type: application/json" \
      -d "{\"title\":\"$TITLE\",\"content\":\"$CONTENT\",\"status\":\"draft\"}" | python3 -c '
import sys, json
p = json.load(sys.stdin)
if "id" in p: print("✅ Draft saved:", p["title"]["rendered"], "| ID:", p["id"])
else: print("❌", p.get("message","?"))
'
    ;;

  edit)
    POST_ID="${1:?post ID required}"
    CONTENT="${2:?content required}"
    api POST "posts/$POST_ID" \
      -H "Content-Type: application/json" \
      -d "{\"content\":\"$CONTENT\"}" | python3 -c '
import sys, json
p = json.load(sys.stdin)
if "id" in p: print("✅ Updated post", p["id"])
else: print("❌", p.get("message","?"))
'
    ;;

  delete)
    POST_ID="${1:?post ID required}"
    api DELETE "posts/$POST_ID" | python3 -c '
import sys, json
p = json.load(sys.stdin)
if "id" in p: print("✅ Trashed post", p["id"])
else: print("❌", p.get("message","?"))
'
    ;;

  pages)
    api GET "pages?per_page=${1:-10}&status=publish,draft" | python3 -c '
import sys, json
pages = json.load(sys.stdin)
if isinstance(pages, dict) and "message" in pages:
    print("❌", pages["message"]); sys.exit(1)
print("{:<5} {:<50} {:<10}".format("ID","Title","Status"))
print("-" * 70)
for p in pages:
    title = p["title"]["rendered"][:48]
    print("{:<5} {:<50} {:<10}".format(p["id"], title, p["status"]))
'
    ;;

  page-publish)
    TITLE="${1:?title required}"
    CONTENT="${2:?content required}"
    api POST "pages" \
      -H "Content-Type: application/json" \
      -d "{\"title\":\"$TITLE\",\"content\":\"$CONTENT\",\"status\":\"publish\"}" | python3 -c '
import sys, json
p = json.load(sys.stdin)
if "id" in p: print("✅ Page published:", p["title"]["rendered"], "| ID:", p["id"], "| URL:", p["link"])
else: print("❌", p.get("message","?"))
'
    ;;

  media)
    if [ "${1:-}" = "upload" ]; then
      FILE="${2:?file path required}"
      FNAME=$(basename "$FILE")
      MIME=$(file -b --mime-type "$FILE" 2>/dev/null || echo "application/octet-stream")
      api POST "media" \
        -H "Content-Disposition: attachment; filename=$FNAME" \
        -H "Content-Type: $MIME" \
        --data-binary "@$FILE" | python3 -c '
import sys, json
m = json.load(sys.stdin)
if "id" in m: print("✅ Uploaded:", m.get("title",{}).get("rendered","?"), "| ID:", m["id"], "| URL:", m.get("source_url","?"))
else: print("❌", m.get("message","?"))
'
    else
      api GET "media?per_page=${1:-10}" | python3 -c '
import sys, json
items = json.load(sys.stdin)
if isinstance(items, dict) and "message" in items:
    print("❌", items["message"]); sys.exit(1)
print("{:<5} {:<30} {:<15} {}".format("ID","Title","Type","URL"))
print("-" * 100)
for m in items:
    title = m.get("title",{}).get("rendered","?")[:28]
    print("{:<5} {:<30} {:<15} {}".format(m["id"], title, m.get("mime_type","?"), m.get("source_url","?")))
'
    fi
    ;;

  plugins)
    api GET "plugins" | python3 -c '
import sys, json
plugins = json.load(sys.stdin)
if isinstance(plugins, dict) and "message" in plugins:
    print("❌", plugins["message"]); sys.exit(1)
print("{:<40} {:<10} {:<12}".format("Plugin","Status","Version"))
print("-" * 65)
for p in plugins:
    print("{:<40} {:<10} {:<12}".format(p.get("plugin","?")[:38], p.get("status","?"), p.get("version","?")))
'
    ;;

  plugin-activate)
    SLUG="${1:?plugin slug required}"
    api POST "plugins/$SLUG" \
      -H "Content-Type: application/json" \
      -d '{"status":"active"}' | python3 -c '
import sys, json
p = json.load(sys.stdin)
if "plugin" in p: print("✅ Activated:", p["plugin"])
else: print("❌", p.get("message","?"))
'
    ;;

  plugin-deactivate)
    SLUG="${1:?plugin slug required}"
    api POST "plugins/$SLUG" \
      -H "Content-Type: application/json" \
      -d '{"status":"inactive"}' | python3 -c '
import sys, json
p = json.load(sys.stdin)
if "plugin" in p: print("✅ Deactivated:", p["plugin"])
else: print("❌", p.get("message","?"))
'
    ;;

  plugin-delete)
    SLUG="${1:?plugin slug required}"
    api DELETE "plugins/$SLUG" | python3 -c '
import sys, json
p = json.load(sys.stdin)
if p.get("deleted"): print("✅ Deleted:", p.get("previous",{}).get("plugin","?"))
else: print("❌", p.get("message","?"))
'
    ;;

  settings)
    api GET "settings" | python3 -c '
import sys, json
s = json.load(sys.stdin)
if "message" in s: print("❌", s["message"]); sys.exit(1)
for k in ["title","description","url","timezone_string","date_format","time_format","posts_per_page","show_on_front","page_on_front"]:
    if k in s: print("{:<20} {}".format(k, s[k]))
'
    ;;

  set-title)
    api POST "settings" \
      -H "Content-Type: application/json" \
      -d "{\"title\":\"${1:?title required}\"}" | python3 -c '
import sys, json
s = json.load(sys.stdin)
print("✅ Title:", s.get("title","?"))
'
    ;;

  set-tagline)
    api POST "settings" \
      -H "Content-Type: application/json" \
      -d "{\"description\":\"${1:?tagline required}\"}" | python3 -c '
import sys, json
s = json.load(sys.stdin)
print("✅ Tagline:", s.get("description","?"))
'
    ;;

  set-homepage)
    if [ "${1:-}" = "page" ]; then
      PAGE_ID="${2:?page ID required}"
      api POST "settings" \
        -H "Content-Type: application/json" \
        -d "{\"show_on_front\":\"page\",\"page_on_front\":$PAGE_ID}" > /dev/null
      echo "✅ Homepage set to page #$PAGE_ID"
    else
      api POST "settings" \
        -H "Content-Type: application/json" \
        -d '{"show_on_front":"posts"}' > /dev/null
      echo "✅ Homepage set to latest posts"
    fi
    ;;

  templates)
    api GET "templates" | python3 -c '
import sys, json
tpls = json.load(sys.stdin)
if isinstance(tpls, dict) and "message" in tpls:
    print("❌", tpls["message"]); sys.exit(1)
print("{:<40} {:<15} {:<10}".format("ID","Slug","Source"))
print("-" * 70)
for t in tpls:
    print("{:<40} {:<15} {:<10}".format(t.get("id","?")[:38], t.get("slug","?"), t.get("source","?")))
'
    ;;

  template)
    api GET "templates/${1:?template ID required}" | python3 -c '
import sys, json
t = json.load(sys.stdin)
if "message" in t: print("❌", t["message"]); sys.exit(1)
print("ID:", t.get("id"))
print("Slug:", t.get("slug"))
print("Source:", t.get("source"))
print("---")
print(t.get("content",{}).get("raw","(empty)"))
'
    ;;

  template-update)
    TPL_ID="${1:?template ID required}"
    CONTENT="${2:?content required}"
    api POST "templates/$TPL_ID" \
      -H "Content-Type: application/json" \
      -d "{\"content\":\"$CONTENT\"}" | python3 -c '
import sys, json
t = json.load(sys.stdin)
if "id" in t: print("✅ Template updated:", t["id"])
else: print("❌", t.get("message","?"))
'
    ;;

  template-parts)
    api GET "template-parts" | python3 -c '
import sys, json
parts = json.load(sys.stdin)
if isinstance(parts, dict) and "message" in parts:
    print("❌", parts["message"]); sys.exit(1)
print("{:<40} {:<15} {:<10} {:<10}".format("ID","Slug","Area","Source"))
print("-" * 80)
for p in parts:
    print("{:<40} {:<15} {:<10} {:<10}".format(p.get("id","?")[:38], p.get("slug","?"), p.get("area","?"), p.get("source","?")))
'
    ;;

  template-part)
    api GET "template-parts/${1:?part ID required}" | python3 -c '
import sys, json
t = json.load(sys.stdin)
if "message" in t: print("❌", t["message"]); sys.exit(1)
print("ID:", t.get("id"))
print("Area:", t.get("area"))
print("Source:", t.get("source"))
print("---")
print(t.get("content",{}).get("raw","(empty)"))
'
    ;;

  template-part-update)
    PART_ID="${1:?part ID required}"
    CONTENT="${2:?content required}"
    api POST "template-parts/$PART_ID" \
      -H "Content-Type: application/json" \
      -d "{\"content\":\"$CONTENT\"}" | python3 -c '
import sys, json
t = json.load(sys.stdin)
if "id" in t: print("✅ Template part updated:", t["id"])
else: print("❌", t.get("message","?"))
'
    ;;

  seo-check)
    TARGET_URL="${1:?URL required}"
    export TARGET_URL
    python3 <<'PYEOF'
# -*- coding: utf-8 -*-
import os

url = os.environ.get("TARGET_URL", "")
print("")
print("=" * 60)
print("  🔍 SEO 健康检查 — {}".format(url))
print("=" * 60)
print("")

checks = [
    ("标题长度", "建议 30-60 字符", "检查 <title> 标签长度，过短缺乏关键词，过长被搜索引擎截断"),
    ("Meta Description", "建议 120-160 字符", "描述应包含核心关键词，吸引用户点击"),
    ("H1 标签", "每页仅 1 个 H1", "H1 是页面主标题，应包含主关键词，不可重复"),
    ("图片 Alt 属性", "所有 <img> 应有 alt", "alt 帮助搜索引擎理解图片内容，也提升无障碍体验"),
    ("URL 结构", "简短、含关键词、用连字符分隔", "避免中文 URL / 过长参数串"),
    ("内部链接", "建议每篇文章 3-5 个内链", "帮助爬虫发现更多页面，提升整站权重"),
    ("外部链接", "引用高质量外部资源", "适当外链提升可信度，但避免指向低质站点"),
    ("关键词密度", "建议 1%-3%", "自然融入关键词，避免堆砌（keyword stuffing）"),
    ("移动端适配", "必须响应式设计", "Google Mobile-First Indexing 优先索引移动版"),
    ("页面速度", "LCP < 2.5s, FID < 100ms", "Core Web Vitals 直接影响排名"),
    ("SSL 证书", "必须 HTTPS", "Chrome 标记 HTTP 为'不安全'，影响用户信任"),
    ("Canonical 标签", "避免重复内容", "指定首选 URL，防止搜索引擎收录多个重复页面"),
    ("Sitemap.xml", "提交到 Google Search Console", "帮助爬虫高效发现所有页面"),
    ("Robots.txt", "确保未屏蔽重要页面", "检查 /robots.txt 配置是否正确"),
    ("结构化数据", "使用 Schema.org 标记", "帮助搜索引擎理解内容，获得富摘要（Rich Snippets）"),
    ("Open Graph 标签", "og:title, og:description, og:image", "社交媒体分享时展示正确的标题、描述和图片"),
]

print("  📋 检查清单（共 {} 项）：".format(len(checks)))
print("")
for i, (name, standard, detail) in enumerate(checks, 1):
    print("  {:>2}. ✅ {}".format(i, name))
    print("      标准：{}".format(standard))
    print("      说明：{}".format(detail))
    print("")

print("  " + "─" * 56)
print("")
print("  💡 快速检测工具：")
print("     • Google PageSpeed Insights: https://pagespeed.web.dev/")
print("     • Google Search Console: https://search.google.com/search-console")
print("     • Schema Markup Validator: https://validator.schema.org/")
print("     • GTmetrix: https://gtmetrix.com/")
print("     • Screaming Frog SEO Spider（本地爬取分析）")
print("")
print("  📌 WordPress SEO 插件推荐：")
print("     • Yoast SEO — 最流行的 SEO 插件")
print("     • Rank Math — 功能强大，免费版够用")
print("     • All in One SEO — 简单易用")
print("")
print("  🔧 快速修复清单：")
print("     1. 安装 SEO 插件，填写每篇文章的 Meta Title / Description")
print("     2. 设置 XML Sitemap 并提交到 Google Search Console")
print("     3. 检查所有图片是否有 alt 属性")
print("     4. 确保网站启用 HTTPS")
print("     5. 使用面包屑导航提升结构化")
print("")
PYEOF
    ;;

  security)
    python3 <<'PYEOF'
# -*- coding: utf-8 -*-
print("")
print("=" * 60)
print("  🛡️ WordPress 安全检查清单")
print("=" * 60)
print("")

categories = [
    ("🔐 登录安全", [
        ("修改默认用户名", "不要使用 admin 作为用户名，创建新管理员后删除 admin 账户"),
        ("强密码策略", "密码至少 16 位，包含大小写字母+数字+特殊字符，推荐用密码管理器"),
        ("限制登录尝试", "安装 Limit Login Attempts 插件，5次失败锁定30分钟"),
        ("双因素认证(2FA)", "安装 WP 2FA 或 Google Authenticator 插件"),
        ("修改登录URL", "使用 WPS Hide Login 将 /wp-admin 改为自定义路径"),
        ("reCAPTCHA", "登录页面添加验证码，防止暴力破解"),
    ]),
    ("📁 文件与权限", [
        ("wp-config.php 权限", "设为 400 或 440，禁止 Web 访问"),
        (".htaccess 权限", "设为 444"),
        ("目录权限", "目录 755，文件 644，wp-content/uploads 不可执行 PHP"),
        ("禁止目录浏览", "在 .htaccess 添加 Options -Indexes"),
        ("禁止编辑主题/插件", "wp-config.php 中添加 define('DISALLOW_FILE_EDIT', true)"),
        ("保护 wp-includes", "通过 .htaccess 禁止直接访问"),
    ]),
    ("🔄 更新策略", [
        ("WordPress 核心更新", "开启自动小版本更新，大版本手动审核后更新"),
        ("插件更新", "每周检查一次，优先更新安全相关插件"),
        ("主题更新", "使用子主题，父主题及时更新"),
        ("PHP 版本", "保持 PHP 8.0+，旧版本有已知漏洞"),
        ("删除未用插件/主题", "停用 ≠ 安全，未使用的必须删除"),
    ]),
    ("🌐 网络安全", [
        ("SSL/HTTPS", "全站强制 HTTPS，获取 Let's Encrypt 免费证书"),
        ("WAF 防火墙", "使用 Wordfence 或 Sucuri 防火墙"),
        ("隐藏 WordPress 版本", "移除 <meta name=\"generator\"> 标签"),
        ("禁用 XML-RPC", "若不需要，添加规则禁止 xmlrpc.php 访问"),
        ("禁用 REST API 枚举", "防止通过 /wp-json/wp/v2/users 泄露用户名"),
        ("HTTP 安全头", "添加 X-Frame-Options, X-Content-Type-Options, CSP 等头"),
    ]),
    ("💾 备份与恢复", [
        ("自动备份", "使用 UpdraftPlus 或 BlogVault 每日自动备份"),
        ("异地存储", "备份到 S3、Google Drive 等远端，不只存在服务器上"),
        ("定期恢复测试", "每季度测试一次备份恢复流程"),
        ("数据库备份", "数据库单独备份，保留最近30天"),
    ]),
    ("📊 监控与审计", [
        ("活动日志", "安装 WP Activity Log 记录所有管理操作"),
        ("文件完整性监控", "Wordfence 可监控核心文件是否被篡改"),
        ("登录通知", "异常登录时发送邮件通知"),
        ("恶意软件扫描", "每周全站扫描一次"),
    ]),
]

total = 0
for cat_name, items in categories:
    total += len(items)
    print("  {}".format(cat_name))
    print("  " + "─" * 50)
    for name, desc in items:
        print("    ☐ {}".format(name))
        print("      {}".format(desc))
    print("")

print("  📊 共 {} 项安全检查".format(total))
print("")
print("  🚨 优先修复：")
print("     1. 修改默认 admin 用户名")
print("     2. 开启 2FA 双因素认证")
print("     3. 限制登录尝试次数")
print("     4. 安装 WAF 防火墙")
print("     5. 设置自动备份")
print("")
print("  🔧 推荐安全插件：")
print("     • Wordfence Security — 防火墙+恶意软件扫描")
print("     • Sucuri Security — 专业安全监控")
print("     • iThemes Security — 一站式安全加固")
print("     • UpdraftPlus — 自动备份")
print("")
PYEOF
    ;;

  speed)
    python3 <<'PYEOF'
# -*- coding: utf-8 -*-
print("")
print("=" * 60)
print("  ⚡ WordPress 网站速度优化指南")
print("=" * 60)
print("")

categories = [
    ("🗄️ 缓存优化", [
        ("页面缓存", "安装 WP Super Cache 或 W3 Total Cache，将动态PHP页面缓存为静态HTML", "影响度：⭐⭐⭐⭐⭐"),
        ("对象缓存", "启用 Redis 或 Memcached 缓存数据库查询结果", "影响度：⭐⭐⭐⭐"),
        ("浏览器缓存", "设置 Expires / Cache-Control 头，静态资源缓存 30天+", "影响度：⭐⭐⭐⭐"),
        ("OPcache", "PHP OPcache 缓存编译后的字节码，减少 PHP 解析时间", "影响度：⭐⭐⭐⭐"),
    ]),
    ("🖼️ 图片优化", [
        ("压缩图片", "使用 ShortPixel 或 Imagify 无损/有损压缩，减少 50-80% 体积", "影响度：⭐⭐⭐⭐⭐"),
        ("WebP 格式", "将 JPEG/PNG 转为 WebP，体积减少 25-35%", "影响度：⭐⭐⭐⭐"),
        ("懒加载", "图片和 iframe 延迟加载（WordPress 5.5+ 原生支持）", "影响度：⭐⭐⭐⭐"),
        ("响应式图片", "使用 srcset 根据屏幕尺寸加载不同大小的图片", "影响度：⭐⭐⭐"),
        ("CDN 图片", "通过 CDN 分发图片，减少服务器负载", "影响度：⭐⭐⭐⭐"),
    ]),
    ("📦 代码优化", [
        ("合并 CSS/JS", "使用 Autoptimize 合并和压缩 CSS、JavaScript 文件", "影响度：⭐⭐⭐⭐"),
        ("延迟加载 JS", "非关键 JS 使用 defer/async 属性，不阻塞渲染", "影响度：⭐⭐⭐⭐"),
        ("移除未用 CSS", "使用 PurgeCSS 或手动移除不需要的样式", "影响度：⭐⭐⭐"),
        ("压缩 HTML", "启用 Gzip/Brotli 压缩，减少传输体积 60-80%", "影响度：⭐⭐⭐⭐"),
        ("减少 HTTP 请求", "合并文件、使用 CSS Sprites、内联关键 CSS", "影响度：⭐⭐⭐"),
    ]),
    ("🌐 CDN 与服务器", [
        ("使用 CDN", "Cloudflare(免费) / BunnyCDN / KeyCDN，全球加速静态资源", "影响度：⭐⭐⭐⭐⭐"),
        ("选择好主机", "SiteGround / Cloudways / Kinsta，避免廉价共享主机", "影响度：⭐⭐⭐⭐⭐"),
        ("PHP 版本", "使用 PHP 8.1+，比 7.4 快 10-20%", "影响度：⭐⭐⭐⭐"),
        ("HTTP/2 或 HTTP/3", "确保服务器支持 HTTP/2 多路复用", "影响度：⭐⭐⭐"),
        ("服务器地理位置", "选择靠近目标用户的机房", "影响度：⭐⭐⭐"),
    ]),
    ("🔌 插件优化", [
        ("审计插件数量", "保持 20 个以内活跃插件，删除未使用的", "影响度：⭐⭐⭐⭐"),
        ("替换重量级插件", "用轻量替代方案替换臃肿插件", "影响度：⭐⭐⭐⭐"),
        ("插件性能检测", "使用 Query Monitor 检测慢查询插件", "影响度：⭐⭐⭐"),
    ]),
    ("🗃️ 数据库优化", [
        ("清理修订版本", "限制文章修订版本数量：define('WP_POST_REVISIONS', 5)", "影响度：⭐⭐⭐"),
        ("清理垃圾数据", "使用 WP-Optimize 清理过期瞬态、垃圾评论、修订版本", "影响度：⭐⭐⭐"),
        ("优化数据库表", "定期执行 OPTIMIZE TABLE 命令", "影响度：⭐⭐"),
    ]),
]

for cat_name, items in categories:
    print("  {}".format(cat_name))
    print("  " + "─" * 50)
    for name, desc, impact in items:
        print("    ⚡ {} ({})".format(name, impact))
        print("      {}".format(desc))
    print("")

print("  " + "─" * 56)
print("")
print("  📊 Core Web Vitals 目标：")
print("     • LCP（最大内容绘制）< 2.5 秒")
print("     • FID（首次输入延迟）< 100 毫秒")
print("     • CLS（累计布局偏移）< 0.1")
print("")
print("  🛠️ 测速工具：")
print("     • Google PageSpeed Insights")
print("     • GTmetrix (gtmetrix.com)")
print("     • WebPageTest (webpagetest.org)")
print("     • Query Monitor 插件（WordPress 后台）")
print("")
print("  📌 优化顺序建议（投入产出比从高到低）：")
print("     1. 启用页面缓存 → 立竿见影")
print("     2. 接入 CDN → 全球加速")
print("     3. 压缩图片 → 减少最大的带宽消耗")
print("     4. 合并+延迟加载 JS/CSS → 减少请求和阻塞")
print("     5. 升级 PHP 版本和主机 → 基础设施优化")
print("")
PYEOF
    ;;

  backup)
    python3 <<'PYEOF'
# -*- coding: utf-8 -*-
print("")
print("=" * 60)
print("  💾 WordPress 备份策略 & 脚本模板")
print("=" * 60)
print("")

print("  📋 备份策略建议：")
print("  " + "─" * 50)
print("")

strategies = [
    ("每日备份", "数据库", "保留最近 30 天", "cron 每天凌晨 3:00 自动执行"),
    ("每周备份", "完整站点（文件+数据库）", "保留最近 12 周", "cron 每周日凌晨 2:00"),
    ("每月备份", "完整站点+服务器配置", "保留最近 12 个月", "手动触发或 cron"),
    ("发布前备份", "数据库快照", "保留到确认正常后删除", "重大更新/插件升级前执行"),
]

for name, scope, retention, trigger in strategies:
    print("    📦 {}".format(name))
    print("       范围：{}".format(scope))
    print("       保留：{}".format(retention))
    print("       触发：{}".format(trigger))
    print("")

print("  " + "─" * 50)
print("  📂 备份内容说明：")
print("")
print("    1. 数据库（最重要）：所有文章、页面、评论、设置")
print("    2. wp-content/uploads/：媒体文件（图片、视频、文档）")
print("    3. wp-content/themes/：主题文件（尤其是自定义修改）")
print("    4. wp-content/plugins/：插件文件")
print("    5. wp-config.php：站点配置")
print("    6. .htaccess：URL重写规则")
print("")

print("  " + "─" * 50)
print("  🔧 Bash 备份脚本模板：")
print("")
print('    #!/bin/bash')
print('    # WordPress 自动备份脚本')
print('    # 用法: 添加到 cron: 0 3 * * * /path/to/wp-backup.sh')
print('    ')
print('    set -euo pipefail')
print('    ')
print('    # === 配置 ===')
print('    WP_DIR="/var/www/html"           # WordPress 安装目录')
print('    DB_NAME="wordpress"              # 数据库名')
print('    DB_USER="wp_user"                # 数据库用户名')
print('    DB_PASS="your_password"          # 数据库密码')
print('    BACKUP_DIR="/backup/wordpress"   # 备份存储目录')
print('    RETENTION=30                     # 保留天数')
print('    REMOTE="s3://my-bucket/wp-backup" # 远程存储（可选）')
print('    ')
print('    DATE=$(date +%Y%m%d_%H%M%S)')
print('    BACKUP_PATH="${BACKUP_DIR}/${DATE}"')
print('    ')
print('    mkdir -p "$BACKUP_PATH"')
print('    ')
print('    # 1. 备份数据库')
print('    echo "📦 备份数据库..."')
print('    mysqldump -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" \\')
print('      | gzip > "${BACKUP_PATH}/database.sql.gz"')
print('    ')
print('    # 2. 备份文件')
print('    echo "📦 备份文件..."')
print('    tar -czf "${BACKUP_PATH}/wp-content.tar.gz" \\')
print('      -C "$WP_DIR" wp-content wp-config.php .htaccess')
print('    ')
print('    # 3. 上传到远程（可选）')
print('    # aws s3 sync "$BACKUP_PATH" "$REMOTE/$DATE/"')
print('    ')
print('    # 4. 清理旧备份')
print('    echo "🗑️ 清理 ${RETENTION} 天前的备份..."')
print('    find "$BACKUP_DIR" -maxdepth 1 -type d \\')
print('      -mtime +$RETENTION -exec rm -rf {} +')
print('    ')
print('    echo "✅ 备份完成: $BACKUP_PATH"')
print('    echo "   数据库: $(du -h ${BACKUP_PATH}/database.sql.gz | cut -f1)"')
print('    echo "   文件: $(du -h ${BACKUP_PATH}/wp-content.tar.gz | cut -f1)"')
print("")

print("  " + "─" * 50)
print("  🔌 推荐备份插件：")
print("")
print("    • UpdraftPlus（免费版支持 Google Drive、Dropbox、S3）")
print("    • BlogVault（实时增量备份，自带一键恢复）")
print("    • BackWPup（免费，支持多种远端存储）")
print("    • Jetpack Backup（Automattic 官方，实时备份）")
print("")
print("  ⚠️ 备份注意事项：")
print("     1. 备份文件不要只存在 Web 服务器上")
print("     2. 定期测试恢复流程（至少每季度一次）")
print("     3. 大型站点考虑增量备份减少存储开销")
print("     4. 数据库密码等敏感信息不要硬编码，用环境变量")
print("     5. 备份完成后发送邮件/通知确认")
print("")
PYEOF
    ;;

  sync-skills)
    # Sync ClawHub published skills to WP pages
    export WP_URL WP_USER WP_PASS
    python3 << 'SYNCEOF'
import json, os, sys, time, subprocess

WP_URL = os.environ.get("WP_URL", "")
COOKIE = "/tmp/wp-session.txt"
NONCE_FILE = "/tmp/wp-nonce.txt"
V3 = "/tmp/slug-account-map-v3.json"
WP_DB = "/tmp/wp-skill-pages.json"
SKILLS = "/home/admin/skills-repo"

if not os.path.isfile(V3):
    print("No v3 map. Run publisher first.")
    sys.exit(1)

nonce = ""
if os.path.isfile(NONCE_FILE):
    with open(NONCE_FILE) as f:
        nonce = f.read().strip()

if not nonce:
    print("Not logged in. Run: wp.sh login")
    sys.exit(1)

with open(V3) as f:
    v3 = json.load(f)

wp_pages = {}
if os.path.isfile(WP_DB):
    with open(WP_DB) as f:
        wp_pages = json.load(f)

missing = [s for s in v3 if s not in wp_pages]
print("Published: {} | WP pages: {} | Missing: {}".format(len(v3), len(wp_pages), len(missing)))

if not missing:
    print("All synced!")
    sys.exit(0)

created = 0
for slug in missing:
    # Build page content from SKILL.md
    sm_path = os.path.join(SKILLS, slug, "SKILL.md")
    summary = ""
    if os.path.isfile(sm_path):
        with open(sm_path) as f:
            lines = f.read().split("\n")
        # Skip frontmatter
        in_fm = False
        clean = []
        for line in lines:
            if line.strip() == "---":
                in_fm = not in_fm
                continue
            if not in_fm:
                clean.append(line)
        summary = "\n".join(clean[:10]).strip()
    
    display = slug.replace("-", " ").title()
    content = "<!-- wp:paragraph --><p>{}</p><!-- /wp:paragraph -->".format(
        summary.replace("\n", "</p><!-- /wp:paragraph --><!-- wp:paragraph --><p>") if summary else display
    )
    content += '<!-- wp:paragraph --><p><a href="https://clawhub.ai/skills/{slug}">Install {display} on ClawHub &rarr;</a></p><!-- /wp:paragraph -->'.format(
        slug=slug, display=display)
    content += '<!-- wp:paragraph --><p><em>Powered by BytesAgain | bytesagain.com</em></p><!-- /wp:paragraph -->'
    
    # Create page via REST API
    import urllib.request
    data = json.dumps({
        "title": display,
        "slug": "skill-" + slug,
        "content": content,
        "status": "publish"
    }).encode()
    
    try:
        req = urllib.request.Request(
            "{}/wp-json/wp/v2/pages".format(WP_URL),
            data=data,
            headers={
                "Content-Type": "application/json",
                "X-WP-Nonce": nonce,
                "Cookie": open(COOKIE).read().strip() if os.path.isfile(COOKIE) else ""
            }
        )
        # Use curl instead for cookie handling
        cmd = [
            "curl", "-s", "-X", "POST",
            "-b", COOKIE,
            "-H", "X-WP-Nonce: " + nonce,
            "-H", "Content-Type: application/json",
            "-d", json.dumps({"title": display, "slug": "skill-" + slug, "content": content, "status": "publish"}),
            "{}/wp-json/wp/v2/pages".format(WP_URL)
        ]
        result = subprocess.check_output(cmd, timeout=15).decode()
        page = json.loads(result)
        
        if "id" in page:
            wp_pages[slug] = {"id": page["id"], "url": page.get("link", "")}
            created += 1
            sys.stdout.write(".")
            sys.stdout.flush()
        else:
            print("\n  Skip {}: {}".format(slug, page.get("message", "?")))
    except Exception as e:
        print("\n  Error {}: {}".format(slug, str(e)[:50]))
    
    time.sleep(5)  # Avoid 429

# Save
with open(WP_DB, "w") as f:
    json.dump(wp_pages, f, indent=2)

print("\nCreated {} pages. Total: {}".format(created, len(wp_pages)))
SYNCEOF
    ;;

  help|*)
    echo "📝 WP Manager — WordPress REST API CLI"
    echo ""
    echo "Usage: wp.sh <command> [args]"
    echo ""
    echo "Setup:  Set WP_URL, WP_USER, WP_PASS in .env"
    echo ""
    echo "Commands:"
    echo "  login                       Authenticate & get nonce"
    echo "  posts [count]               List recent posts"
    echo "  post <id>                   Get post details"
    echo "  publish \"Title\" \"Content\"   Publish new post"
    echo "  draft \"Title\" \"Content\"     Save draft"
    echo "  edit <id> \"Content\"         Update post"
    echo "  delete <id>                 Trash post"
    echo "  pages [count]               List pages"
    echo "  page-publish \"T\" \"C\"        Publish page"
    echo "  media [count]               List media"
    echo "  media upload <file>         Upload media file"
    echo "  plugins                     List plugins"
    echo "  plugin-activate <slug>      Activate plugin"
    echo "  plugin-deactivate <slug>    Deactivate plugin"
    echo "  plugin-delete <slug>        Delete plugin"
    echo "  settings                    View site settings"
    echo "  set-title \"Title\"           Update site title"
    echo "  set-tagline \"Tagline\"       Update tagline"
    echo "  set-homepage posts|page <id> Set homepage type"
    echo "  templates                   List templates"
    echo "  template <id>               Get template"
    echo "  template-update <id> \"C\"    Update template"
    echo "  template-parts              List template parts"
    echo "  template-part <id>          Get template part"
    echo "  template-part-update <id> \"C\" Update part"
    echo ""
    echo "SEO & Ops:"
    echo "  seo-check \"URL\"             SEO health check (16 items)"
    echo "  security                    WordPress security checklist"
    echo "  speed                       Site speed optimization guide"
    echo "  backup                      Backup strategy + script template"
    echo ""
    echo "Skills Sync:"
    echo "  sync-skills                 Sync ClawHub skills to WP pages"
    ;;
esac

echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
