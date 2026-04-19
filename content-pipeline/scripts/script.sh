#!/usr/bin/env bash
# content-pipeline — use-cases + article + tweet draft from a skill list
# Requires: XAI_API_KEY, SUPABASE_URL, SUPABASE_KEY, SITE_DIR, X_API_*
set -euo pipefail

SITE_DIR="${SITE_DIR:-/home/admin/bytesagain-next}"
USECASES_FILE="$SITE_DIR/lib/use-cases.ts"
DRAFT_FILE="/tmp/x-drafts-$(date +%Y-%m-%d).json"
SITE_BASE="https://bytesagain.com"

_check() {
    local var="$1"
    if [[ -z "${!var:-}" ]]; then
        echo "Error: $var not set" >&2
        exit 1
    fi
}

# ── Step 1: use-cases ────────────────────────────────────────────────────────

cmd_usecase() {
    local slugs="" topic=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --slugs) slugs="$2"; shift 2 ;;
            --topic) topic="$2"; shift 2 ;;
            *) shift ;;
        esac
    done
    [[ -z "$slugs" || -z "$topic" ]] && { echo "Error: --slugs and --topic required" >&2; exit 1; }
    _check SITE_DIR

    SLUGS="$slugs" TOPIC="$topic" USECASES_FILE="$USECASES_FILE" \
    python3 -u - << 'PYEOF'
import os, json, re, subprocess, sys

slugs_raw = os.environ["SLUGS"]
topic     = os.environ["TOPIC"]
uc_file   = os.environ["USECASES_FILE"]
site_dir  = os.environ.get("SITE_DIR", "/home/admin/bytesagain-next")

slug_list = [s.strip() for s in slugs_raw.split(",") if s.strip()]

# Fetch skill names from ClawHub API
import urllib.request
skill_info = {}
for slug in slug_list:
    try:
        req = urllib.request.Request(
            f"https://clawhub.ai/api/v1/skills/{slug}",
            headers={"User-Agent": "content-pipeline/1.0"}
        )
        with urllib.request.urlopen(req, timeout=10) as r:
            data = json.loads(r.read())
        skill_info[slug] = data.get("name", slug.replace("-", " ").title())
    except Exception:
        skill_info[slug] = slug.replace("-", " ").title()

# Build use-case slug from topic
uc_slug = re.sub(r'[^a-z0-9]+', '-', topic.lower()).strip('-')[:60]

# Check if already exists
with open(uc_file) as f:
    content = f.read()
if f"slug: '{uc_slug}'" in content:
    print(f"  ⏭️  use-case '{uc_slug}' already exists, skipping")
    print(f"USE_CASE_SLUG={uc_slug}")
    sys.exit(0)

# Build skills array
skills_ts = ", ".join([
    f"{{ slug: '{s}', name: '{skill_info[s]}', reason: '{skill_info[s]}' }}"
    for s in slug_list
])

# Icon selection
icons = {"ecommerce": "🛒", "ai": "🤖", "crypto": "💰", "image": "📸",
         "code": "💻", "legal": "⚖️", "data": "📊", "write": "✍️"}
icon = "🔧"
for kw, em in icons.items():
    if kw in topic.lower():
        icon = em
        break

# Generate title and description from topic
title = topic.strip()
if not title[0].isupper():
    title = title[0].upper() + title[1:]
description = f"Use AI skills to {topic.lower()} — fast, accurate, and ready to deploy."

new_entry = f"""  {{
    slug: '{uc_slug}',
    title: '{title}',
    description: '{description}',
    icon: '{icon}',
    skills: [{skills_ts}],
  }},"""

# Insert before closing bracket
new_content = content.rstrip()
if new_content.endswith("]"):
    new_content = new_content[:-1] + "\n" + new_entry + "\n]"
else:
    new_content += "\n" + new_entry

with open(uc_file, "w") as f:
    f.write(new_content)

print(f"  ✅ Added use-case: {uc_slug}")
print(f"USE_CASE_SLUG={uc_slug}")

# Git commit and push
result = subprocess.run(
    ["git", "-C", site_dir, "add", "lib/use-cases.ts"],
    capture_output=True, text=True
)
result = subprocess.run(
    ["git", "-C", site_dir, "commit", "-m", f"feat: add use-case {uc_slug}"],
    capture_output=True, text=True
)
if result.returncode != 0:
    print(f"  ⚠️  git commit: {result.stderr.strip()}")
else:
    push = subprocess.run(
        ["git", "-C", site_dir, "push", "origin", "main"],
        capture_output=True, text=True
    )
    if push.returncode == 0:
        print("  ✅ Pushed → Vercel deploy triggered")
    else:
        print(f"  ⚠️  git push failed: {push.stderr.strip()}")
PYEOF
}

# ── Step 2: article ──────────────────────────────────────────────────────────

cmd_article() {
    local slugs="" topic="" article_slug=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --slugs)        slugs="$2";        shift 2 ;;
            --topic)        topic="$2";        shift 2 ;;
            --article-slug) article_slug="$2"; shift 2 ;;
            *) shift ;;
        esac
    done
    [[ -z "$slugs" || -z "$topic" ]] && { echo "Error: --slugs and --topic required" >&2; exit 1; }
    _check XAI_API_KEY
    _check SUPABASE_URL
    _check SUPABASE_KEY

    SLUGS="$slugs" TOPIC="$topic" ARTICLE_SLUG="$article_slug" \
    XAI_API_KEY="${XAI_API_KEY}" SB_URL="${SUPABASE_URL}" SB_KEY="${SUPABASE_KEY}" \
    SITE_BASE="$SITE_BASE" \
    python3 -u - << 'PYEOF'
import os, json, re, urllib.request, urllib.parse, sys
from datetime import datetime

slugs_raw    = os.environ["SLUGS"]
topic        = os.environ["TOPIC"]
article_slug = os.environ.get("ARTICLE_SLUG", "").strip()
api_key      = os.environ["XAI_API_KEY"]
sb_url       = os.environ["SB_URL"]
sb_key       = os.environ["SB_KEY"]
site_base    = os.environ["SITE_BASE"]

slug_list = [s.strip() for s in slugs_raw.split(",") if s.strip()]

# Auto-generate article slug
if not article_slug:
    article_slug = re.sub(r'[^a-z0-9]+', '-', topic.lower()).strip('-')[:60]

# Check if article already exists
check_url = f"{sb_url}/rest/v1/articles?slug=eq.{urllib.parse.quote(article_slug)}&select=slug"
req = urllib.request.Request(check_url, headers={
    "apikey": sb_key, "Authorization": f"Bearer {sb_key}"
})
with urllib.request.urlopen(req, timeout=10) as r:
    existing = json.loads(r.read())

if existing:
    art_url = f"{site_base}/article/{article_slug}"
    print(f"  ⏭️  Article '{article_slug}' already exists")
    print(f"ARTICLE_URL={art_url}")
    sys.exit(0)

# Fetch skill info for article context
skill_names = []
for slug in slug_list:
    try:
        req = urllib.request.Request(
            f"https://clawhub.ai/api/v1/skills/{slug}",
            headers={"User-Agent": "content-pipeline/1.0"}
        )
        with urllib.request.urlopen(req, timeout=10) as r:
            data = json.loads(r.read())
        skill_names.append(f"{data.get('name', slug)} (bytesagain.com/skill/{slug})")
    except Exception:
        skill_names.append(f"{slug} (bytesagain.com/skill/{slug})")

skills_context = "\n".join([f"- {s}" for s in skill_names])

# Generate article with Grok
prompt = f"""Write a comprehensive blog article about: {topic}

Featured skills (link to these in the article):
{skills_context}

Requirements:
- 600-900 words
- HTML format (use <h2>, <p>, <ul>, <li>, <strong> — no <html>/<body>/<head> wrapper)
- Include an introduction, 2-3 sections with H2 headers, and a conclusion
- Naturally link to each skill using: <a href="https://bytesagain.com/skill/SLUG">Skill Name</a>
- End with a call to action mentioning bytesagain.com
- SEO-optimized, natural writing style, no filler phrases"""

payload = json.dumps({
    "model": "grok-3-mini",
    "messages": [{"role": "user", "content": prompt}],
    "temperature": 0.7,
    "max_tokens": 1500
}).encode()

req = urllib.request.Request(
    "https://api.x.ai/v1/chat/completions",
    data=payload,
    headers={"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"}
)
with urllib.request.urlopen(req, timeout=60) as r:
    result = json.loads(r.read())

html_content = result["choices"][0]["message"]["content"].strip()

# Generate title
title = topic.strip()
if not title[0].isupper():
    title = title[0].upper() + title[1:]

# Generate excerpt
excerpt_prompt = f"Write a 1-sentence SEO meta description (max 160 chars) for an article titled: {title}"
payload2 = json.dumps({
    "model": "grok-3-mini",
    "messages": [{"role": "user", "content": excerpt_prompt}],
    "max_tokens": 60
}).encode()
req2 = urllib.request.Request(
    "https://api.x.ai/v1/chat/completions",
    data=payload2,
    headers={"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"}
)
with urllib.request.urlopen(req2, timeout=15) as r:
    exc_result = json.loads(r.read())
excerpt = exc_result["choices"][0]["message"]["content"].strip().strip('"')[:160]

# Write to Supabase
now = datetime.utcnow().isoformat() + "Z"
article_data = {
    "slug": article_slug,
    "title": title,
    "content": html_content,
    "excerpt": excerpt,
    "status": "published",
    "created_at": now,
    "updated_at": now,
}

post_req = urllib.request.Request(
    f"{sb_url}/rest/v1/articles",
    data=json.dumps(article_data).encode(),
    headers={
        "apikey": sb_key,
        "Authorization": f"Bearer {sb_key}",
        "Content-Type": "application/json",
        "Prefer": "return=minimal"
    },
    method="POST"
)
with urllib.request.urlopen(post_req, timeout=15) as r:
    status = r.status

if status in (200, 201):
    art_url = f"{site_base}/article/{article_slug}"
    print(f"  ✅ Article written: {article_slug}")
    print(f"ARTICLE_URL={art_url}")
else:
    print(f"  ❌ Supabase write failed: {status}", file=sys.stderr)
    sys.exit(1)
PYEOF
}

# ── Step 3: tweet ────────────────────────────────────────────────────────────

cmd_tweet() {
    local url="" topic=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --url)   url="$2";   shift 2 ;;
            --topic) topic="$2"; shift 2 ;;
            *) shift ;;
        esac
    done
    [[ -z "$url" || -z "$topic" ]] && { echo "Error: --url and --topic required" >&2; exit 1; }
    _check XAI_API_KEY

    TWEET_URL="$url" TOPIC="$topic" \
    API_KEY="${XAI_API_KEY}" DRAFT_FILE="$DRAFT_FILE" \
    python3 -u - << 'PYEOF'
import os, json, urllib.request
from datetime import datetime

api_key    = os.environ["API_KEY"]
tweet_url  = os.environ["TWEET_URL"]
topic      = os.environ["TOPIC"]
draft_file = os.environ["DRAFT_FILE"]

prompt = f"""Write a tweet for this article: {topic}
Article URL: {tweet_url}

Rules:
- Max 240 characters including the URL
- Hook first line (question or surprising stat)
- 1-2 lines of value
- End with the URL on its own line
- No hashtags
- Natural, not salesy"""

payload = json.dumps({
    "model": "grok-3-mini",
    "messages": [{"role": "user", "content": prompt}],
    "temperature": 0.8,
    "max_tokens": 120
}).encode()

req = urllib.request.Request(
    "https://api.x.ai/v1/chat/completions",
    data=payload,
    headers={"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"}
)
with urllib.request.urlopen(req, timeout=20) as r:
    result = json.loads(r.read())

tweet_text = result["choices"][0]["message"]["content"].strip()

# Load existing drafts or create new
try:
    with open(draft_file) as f:
        drafts = json.load(f)
    if not isinstance(drafts, list):
        drafts = list(drafts.values()) if isinstance(drafts, dict) else []
except Exception:
    drafts = []

drafts.append({
    "text": tweet_text,
    "topic": topic,
    "url": tweet_url,
    "created_at": datetime.utcnow().isoformat()
})

with open(draft_file, "w") as f:
    json.dump(drafts, f, ensure_ascii=False, indent=2)

print(f"  ✅ Tweet draft saved to {draft_file}")
print(f"\n--- Draft ---\n{tweet_text}\n-------------")
PYEOF
}

# ── Full pipeline ────────────────────────────────────────────────────────────

cmd_run() {
    local slugs="" topic="" article_slug=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --slugs)        slugs="$2";        shift 2 ;;
            --topic)        topic="$2";        shift 2 ;;
            --article-slug) article_slug="$2"; shift 2 ;;
            *) shift ;;
        esac
    done
    [[ -z "$slugs" || -z "$topic" ]] && { echo "Error: --slugs and --topic required" >&2; exit 1; }

    echo "🚀 Content Pipeline: $topic"
    echo "   Skills: $slugs"
    echo ""

    echo "▶ Step 1: use-cases.ts"
    cmd_usecase --slugs "$slugs" --topic "$topic"
    echo ""

    echo "▶ Step 2: article"
    article_output=$(cmd_article --slugs "$slugs" --topic "$topic" --article-slug "$article_slug" 2>&1)
    echo "$article_output"
    article_url=$(echo "$article_output" | grep "^ARTICLE_URL=" | cut -d= -f2-)
    echo ""

    if [[ -n "$article_url" ]]; then
        echo "▶ Step 3: tweet draft"
        cmd_tweet --url "$article_url" --topic "$topic"
    else
        echo "  ⚠️  No article URL, skipping tweet"
    fi

    echo ""
    echo "✅ Pipeline complete!"
    [[ -n "$article_url" ]] && echo "   Article: $article_url"
    echo "   Drafts:  $DRAFT_FILE"
}

cmd_help() {
    cat << 'EOF'
content-pipeline — Full content pipeline: use-cases + article + tweet draft

Usage:
  bash scripts/script.sh run --slugs "slug1,slug2" --topic "topic string"
  bash scripts/script.sh usecase --slugs "slug1,slug2" --topic "topic"
  bash scripts/script.sh article --slugs "slug1,slug2" --topic "topic"
  bash scripts/script.sh tweet --url "https://..." --topic "topic"
  bash scripts/script.sh help

Commands:
  run      Run full pipeline (steps 1+2+3)
  usecase  Step 1: add use-case to use-cases.ts + push
  article  Step 2: generate & write article to Supabase
  tweet    Step 3: generate tweet draft → /tmp/x-drafts-DATE.json
  help     Show this help

Required env vars (for run):
  XAI_API_KEY, SUPABASE_URL, SUPABASE_KEY, SITE_DIR
  X_API_KEY, X_API_SECRET, X_ACCESS_TOKEN, X_ACCESS_TOKEN_SECRET

Example:
  XAI_API_KEY=xai-xxx SUPABASE_URL=https://xxx.supabase.co SUPABASE_KEY=xxx \
  SITE_DIR=/home/admin/bytesagain-next \
  bash scripts/script.sh run \
    --slugs "ai-product-description-writer,ai-product-description-from-image" \
    --topic "AI tools for product description writing"

Powered by BytesAgain | bytesagain.com
EOF
}

case "${1:-help}" in
    run)     shift; cmd_run "$@" ;;
    usecase) shift; cmd_usecase "$@" ;;
    article) shift; cmd_article "$@" ;;
    tweet)   shift; cmd_tweet "$@" ;;
    help|*)  cmd_help ;;
esac
