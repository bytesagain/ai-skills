#!/usr/bin/env bash
# indexnow-pro — Instant search engine notification via IndexNow
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

show_help() {
    cat << 'HELPEOF'
indexnow-pro v1.0.0 — Search Engine Instant Notification

Usage: indexnow-pro <command>

Commands:
  ping-url        Notify about a single URL
  ping-batch      Submit multiple URLs at once
  ping-sitemap    Submit all URLs from sitemap.xml
  key-setup       Generate and host your API key
  verify          Check if key is properly hosted
  engines         List supported search engines
  protocol        IndexNow protocol reference
  best-practices  Usage guidelines and tips

Powered by BytesAgain | bytesagain.com
HELPEOF
}

cmd_ping_url() {
    cat << 'EOF'
# Ping Single URL

## Quick Start
```bash
# Notify all IndexNow engines about a URL
KEY="your-indexnow-key"
URL="https://yoursite.com/new-page"

# Bing
curl -s "https://www.bing.com/indexnow?url=${URL}&key=${KEY}"

# Yandex
curl -s "https://yandex.com/indexnow?url=${URL}&key=${KEY}"

# IndexNow API (covers all participating engines)
curl -s "https://api.indexnow.org/indexnow?url=${URL}&key=${KEY}"
```

## Response Codes
| Code | Meaning |
|------|---------|
| 200 | URL submitted successfully |
| 202 | Accepted, will be processed |
| 400 | Invalid request (check URL format) |
| 403 | Key not valid for this URL's host |
| 422 | URL doesn't belong to the host |
| 429 | Too many requests (rate limited) |

## Node.js Version
```javascript
const engines = [
  'https://api.indexnow.org/indexnow',
  'https://www.bing.com/indexnow',
  'https://yandex.com/indexnow',
];

for (const engine of engines) {
  const res = await fetch(`${engine}?url=${encodeURIComponent(url)}&key=${key}`);
  console.log(`${new URL(engine).hostname}: HTTP ${res.status}`);
}
```

## When to Ping
- New page published
- Existing page content significantly updated
- Page URL changed (also submit old URL)
- After fixing important SEO issues
EOF
}

cmd_ping_batch() {
    cat << 'EOF'
# Batch URL Submission

## Submit up to 10,000 URLs at once

```bash
curl -X POST "https://api.indexnow.org/indexnow" \
  -H "Content-Type: application/json" \
  -d '{
    "host": "yoursite.com",
    "key": "your-indexnow-key",
    "keyLocation": "https://yoursite.com/your-indexnow-key.txt",
    "urlList": [
      "https://yoursite.com/page1",
      "https://yoursite.com/page2",
      "https://yoursite.com/page3"
    ]
  }'
```

## Batch Rules
- Maximum 10,000 URLs per request
- All URLs must belong to the same host
- Key must be hosted at the specified keyLocation
- POST request with JSON body (not GET)

## Generate URL List from Sitemap
```bash
# Extract URLs from sitemap.xml
curl -s https://yoursite.com/sitemap.xml \
  | grep -oP '<loc>\K[^<]+' \
  | head -10000 > urls.txt

# Convert to JSON array
python3 -c "
import json, sys
urls = [l.strip() for l in open('urls.txt') if l.strip()]
print(json.dumps(urls))
" > urls.json
```

## Rate Limits
- No official rate limit documented
- Best practice: max 1 batch per hour
- Spread large sites across multiple batches
- 10,000 URLs × 24 batches = 240,000 URLs/day
EOF
}

cmd_ping_sitemap() {
    cat << 'EOF'
# Sitemap-Based Submission

## Auto-submit all pages from sitemap.xml

```bash
#!/bin/bash
SITE="yoursite.com"
KEY="your-indexnow-key"
SITEMAP="https://${SITE}/sitemap.xml"

# Fetch and parse sitemap
URLS=$(curl -s "$SITEMAP" | grep -oP '<loc>\K[^<]+')
COUNT=$(echo "$URLS" | wc -l)

echo "Found $COUNT URLs in sitemap"

# Submit in batches of 100
echo "$URLS" | while mapfile -t -n 100 batch && [ ${#batch[@]} -gt 0 ]; do
  JSON=$(printf '%s\n' "${batch[@]}" | python3 -c "
import sys, json
urls = [l.strip() for l in sys.stdin if l.strip()]
print(json.dumps({
  'host': '$SITE',
  'key': '$KEY',
  'keyLocation': 'https://$SITE/$KEY.txt',
  'urlList': urls
}))
  ")
  
  RESP=$(curl -s -w "%{http_code}" -X POST \
    "https://api.indexnow.org/indexnow" \
    -H "Content-Type: application/json" \
    -d "$JSON")
  
  echo "Batch ${#batch[@]} URLs: HTTP $RESP"
  sleep 5
done
```

## Sitemap Index Support
If your site uses a sitemap index (multiple sitemaps):
```bash
# Parse sitemap index first
curl -s https://yoursite.com/sitemap_index.xml \
  | grep -oP '<loc>\K[^<]+' \
  | while read sitemap_url; do
    echo "Processing: $sitemap_url"
    curl -s "$sitemap_url" | grep -oP '<loc>\K[^<]+'
  done > all-urls.txt
```

## WordPress Sites
WordPress auto-generates sitemap at:
- `https://yoursite.com/wp-sitemap.xml` (core)
- `https://yoursite.com/sitemap.xml` (Yoast SEO)
- `https://yoursite.com/sitemap_index.xml` (Yoast SEO)
EOF
}

cmd_key_setup() {
    cat << 'EOF'
# IndexNow Key Setup

## Step 1: Generate a Key
```bash
# Generate a random key (32 hex chars)
KEY=$(openssl rand -hex 16)
echo "Your key: $KEY"
```

## Step 2: Create Key File
```bash
# The key file must contain only the key string
echo "$KEY" > "${KEY}.txt"
```

## Step 3: Host the Key File
Upload `{KEY}.txt` to your website root:
```
https://yoursite.com/{KEY}.txt
```

### WordPress
```bash
# Via WP REST API
curl -X POST "https://yoursite.com/wp-json/wp/v2/pages" \
  -u "user:password" \
  -d "title=${KEY}&content=${KEY}&slug=${KEY}&status=publish"
```

### Or via .htaccess / nginx
```nginx
# nginx
location = /your-key-here.txt {
    return 200 'your-key-here';
    add_header Content-Type text/plain;
}
```

## Step 4: Verify
```bash
curl -s "https://yoursite.com/${KEY}.txt"
# Should return: your-key-here
```

## Step 5: Test
```bash
curl -s "https://api.indexnow.org/indexnow?url=https://yoursite.com&key=${KEY}"
# Should return: HTTP 200 or 202
```

## Security Notes
- Key is NOT secret (it's publicly hosted)
- It proves you own the domain (like DNS TXT verification)
- One key per domain is sufficient
- Key doesn't expire
EOF
}

cmd_verify() {
    cat << 'EOF'
# Verify IndexNow Setup

## Checklist
```bash
SITE="yoursite.com"
KEY="your-key"

# 1. Key file accessible?
echo "Checking key file..."
RESP=$(curl -s -o /dev/null -w "%{http_code}" "https://${SITE}/${KEY}.txt")
[ "$RESP" = "200" ] && echo "✅ Key file accessible" || echo "❌ Key file not found (HTTP $RESP)"

# 2. Key file content correct?
CONTENT=$(curl -s "https://${SITE}/${KEY}.txt" | tr -d '\n\r ')
[ "$CONTENT" = "$KEY" ] && echo "✅ Key content matches" || echo "❌ Key mismatch: got '$CONTENT'"

# 3. Test submission
RESP=$(curl -s -o /dev/null -w "%{http_code}" \
  "https://api.indexnow.org/indexnow?url=https://${SITE}&key=${KEY}")
case $RESP in
  200|202) echo "✅ IndexNow accepts submissions" ;;
  403) echo "❌ Key not valid for this domain" ;;
  422) echo "❌ URL doesn't match host" ;;
  *) echo "⚠️ Unexpected response: HTTP $RESP" ;;
esac
```

## Common Issues
| Problem | Solution |
|---------|----------|
| 403 Forbidden | Key file not at domain root |
| Key file returns HTML | Check for redirect/CDN caching |
| 422 Invalid URL | URL host must match key file host |
| Timeout | API may be temporarily slow |
EOF
}

cmd_engines() {
    cat << 'EOF'
# Supported Search Engines

## IndexNow Participating Engines

| Engine | Endpoint | Market |
|--------|----------|--------|
| Bing | https://www.bing.com/indexnow | Global (#2) |
| Yandex | https://yandex.com/indexnow | Russia/CIS |
| Naver | https://searchadvisor.naver.com/indexnow | South Korea |
| Seznam | https://search.seznam.cz/indexnow | Czech Republic |
| IndexNow API | https://api.indexnow.org/indexnow | All participating |

## Notably Absent
- **Google**: Does NOT support IndexNow. Use Google Search Console API instead.
- **Baidu**: Does NOT support IndexNow. Use Baidu Webmaster push API.
- **DuckDuckGo**: Uses Bing results, benefits indirectly.

## Google Alternative
```bash
# Google Indexing API (requires OAuth2 setup)
curl -X POST "https://indexing.googleapis.com/v3/urlNotifications:publish" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://yoursite.com/page", "type": "URL_UPDATED"}'
```

## Baidu Alternative
```bash
# Baidu push API
curl -X POST "http://data.zz.baidu.com/urls?site=yoursite.com&token=YOUR_TOKEN" \
  -H "Content-Type: text/plain" \
  -d "https://yoursite.com/page1
https://yoursite.com/page2"
```

## Best Strategy
Submit to all three simultaneously:
1. IndexNow API (covers Bing + Yandex + others)
2. Google Search Console / Indexing API
3. Baidu Push (if targeting China)
EOF
}

cmd_protocol() {
    cat << 'EOF'
# IndexNow Protocol Specification

## Overview
IndexNow is an open protocol allowing website owners to instantly notify
search engines about content changes. It eliminates the delay between
publishing and indexing.

## How It Works
1. You host a key file at your domain root
2. When content changes, you send a GET/POST to an IndexNow endpoint
3. Search engines verify your key and queue the URL for crawling
4. URL is typically indexed within minutes to hours

## GET Request (Single URL)
```
GET https://api.indexnow.org/indexnow?
  url=https://yoursite.com/new-page&
  key=your-key-here&
  keyLocation=https://yoursite.com/your-key-here.txt
```

## POST Request (Batch)
```
POST https://api.indexnow.org/indexnow
Content-Type: application/json

{
  "host": "yoursite.com",
  "key": "your-key-here",
  "keyLocation": "https://yoursite.com/your-key-here.txt",
  "urlList": [
    "https://yoursite.com/page1",
    "https://yoursite.com/page2"
  ]
}
```

## Key File Requirements
- Plain text file containing only the key string
- Hosted at: https://yoursite.com/{key}.txt
- No HTML, no BOM, no extra whitespace
- Must be accessible via HTTPS
- 200 OK response required

## Protocol Details
- Open source protocol (https://indexnow.org)
- Launched 2021 by Microsoft (Bing)
- No cost, no registration required
- Submitting a URL is a hint, not a guarantee of indexing
- Search engines may ignore URLs they deem low quality
EOF
}

cmd_best_practices() {
    cat << 'EOF'
# IndexNow Best Practices

## DO
- Submit only URLs that actually changed
- Include new pages immediately after publishing
- Submit updated pages when content significantly changes
- Use batch API for bulk operations (sitemap resubmission)
- Monitor response codes for errors
- Set up automated submission in your CMS/CI pipeline

## DON'T
- Don't submit unchanged URLs repeatedly
- Don't submit URLs returning 404/500
- Don't submit non-canonical URLs (submit canonical only)
- Don't submit millions of URLs without need
- Don't submit noindex pages
- Don't expect instant indexing (it's a hint)

## Automation Ideas

### WordPress Hook
```php
// Auto-notify on post publish/update
add_action('publish_post', function($post_id) {
    $url = get_permalink($post_id);
    $key = 'your-indexnow-key';
    wp_remote_get("https://api.indexnow.org/indexnow?url=" .
        urlencode($url) . "&key=" . $key);
});
```

### Git Hook (Static Sites)
```bash
#!/bin/bash
# .git/hooks/post-push
CHANGED=$(git diff --name-only HEAD~1 | grep '\.html$')
for file in $CHANGED; do
  curl -s "https://api.indexnow.org/indexnow?url=https://yoursite.com/${file}&key=${KEY}"
done
```

### Cron (Daily Sitemap Sync)
```bash
0 6 * * * /path/to/indexnow-sitemap-sync.sh >> /tmp/indexnow.log 2>&1
```

## Measuring Impact
- Google Search Console → Coverage → Indexed pages
- Bing Webmaster Tools → URL Inspection
- Compare indexing speed: with vs without IndexNow
- Typical improvement: days → hours for new content
EOF
}

case "${1:-help}" in
    ping-url)       cmd_ping_url ;;
    ping-batch)     cmd_ping_batch ;;
    ping-sitemap)   cmd_ping_sitemap ;;
    key-setup)      cmd_key_setup ;;
    verify)         cmd_verify ;;
    engines)        cmd_engines ;;
    protocol)       cmd_protocol ;;
    best-practices) cmd_best_practices ;;
    help|-h)        show_help ;;
    version|-v)     echo "indexnow-pro v$VERSION" ;;
    *)              echo "Unknown: $1"; show_help ;;
esac
