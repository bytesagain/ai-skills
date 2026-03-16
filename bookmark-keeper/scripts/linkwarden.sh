#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# Bookmark manager — save, organize, search bookmarks
set -euo pipefail
BM_DIR="${BM_DIR:-$HOME/.bookmarks}"
mkdir -p "$BM_DIR"
DB="$BM_DIR/bookmarks.json"
[ ! -f "$DB" ] && echo '[]' > "$DB"
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "Bookmark Manager — save & organize links
Commands:
  add <url> [title] [tags]   Save bookmark
  list [n]                   List recent (default 20)
  search <query>             Search bookmarks
  tag <tag>                  Filter by tag
  tags                       Show all tags
  check                      Check dead links
  export [format]            Export (md/html/json)
  import <file>              Import from file
  delete <url>               Remove bookmark
  stats                      Statistics
  info                       Version info
Powered by BytesAgain | bytesagain.com";;
add)
    url="${1:-}"; title="${2:-}"; tags="${3:-}"
    [ -z "$url" ] && { echo "Usage: add <url> [title] [tags]"; exit 1; }
    python3 << PYEOF
import json, time
try:
    from urllib.request import urlopen, Request
except:
    from urllib2 import urlopen, Request
url = "$url"
title = "$title"
tags = "$tags"
if not title:
    try:
        import re
        resp = urlopen(Request(url, headers={"User-Agent":"Mozilla/5.0"}), timeout=5)
        html = resp.read().decode("utf-8","ignore")
        m = re.search(r'<title>(.*?)</title>', html, re.DOTALL)
        if m: title = m.group(1).strip()[:100]
    except: pass
    if not title: title = url[:50]
with open("$DB") as f: bms = json.load(f)
bms.append({"url": url, "title": title, "tags": tags.split(",") if tags else [],
            "added": time.strftime("%Y-%m-%d %H:%M"), "id": len(bms)+1})
with open("$DB","w") as f: json.dump(bms, f, indent=2, ensure_ascii=False)
print("✅ Saved: {} ({})".format(title, url[:50]))
PYEOF
;;
list)
    n="${1:-20}"
    python3 << PYEOF
import json
with open("$DB") as f: bms = json.load(f)
print("🔖 Bookmarks ({} total):".format(len(bms)))
for b in bms[-int("$n"):][::-1]:
    tags = " ".join(["#"+t for t in b.get("tags",[]) if t])
    print("  {:>3d}. {} {}".format(b.get("id",0), b["title"][:40], tags))
    print("       {}".format(b["url"][:60]))
PYEOF
;;
search)
    q="${1:-}"; [ -z "$q" ] && { echo "Usage: search <query>"; exit 1; }
    python3 -c "
import json
with open('$DB') as f: bms = json.load(f)
q = '$q'.lower()
found = [b for b in bms if q in b['title'].lower() or q in b['url'].lower() or any(q in t for t in b.get('tags',[]))]
print('🔍 Found {} results:'.format(len(found)))
for b in found[:10]:
    print('  {}. {} — {}'.format(b.get('id',0), b['title'][:40], b['url'][:50]))
";;
tag)
    t="${1:-}"; [ -z "$t" ] && { echo "Usage: tag <tag>"; exit 1; }
    python3 -c "
import json
with open('$DB') as f: bms = json.load(f)
found = [b for b in bms if '$t' in b.get('tags',[])]
print('🏷 #{} ({} bookmarks):'.format('$t', len(found)))
for b in found:
    print('  {}. {} — {}'.format(b.get('id',0), b['title'][:40], b['url'][:50]))
";;
tags)
    python3 -c "
import json
from collections import Counter
with open('$DB') as f: bms = json.load(f)
tags = Counter(t for b in bms for t in b.get('tags',[]) if t)
print('🏷 Tags:')
for t, c in tags.most_common(20):
    print('  #{} ({})'.format(t, c))
";;
check)
    python3 << 'PYEOF'
import json
try:
    from urllib.request import urlopen, Request
except:
    from urllib2 import urlopen, Request
with open("$DB") as f: bms = json.load(f)
print("🔍 Checking {} bookmarks...".format(len(bms)))
dead = 0
for b in bms[:50]:
    try:
        req = Request(b["url"], headers={"User-Agent":"Mozilla/5.0"})
        resp = urlopen(req, timeout=5)
        code = resp.getcode()
        if code >= 400:
            print("  ❌ {} — HTTP {}".format(b["title"][:30], code))
            dead += 1
    except Exception as e:
        print("  ❌ {} — {}".format(b["title"][:30], str(e)[:30]))
        dead += 1
print("\nResult: {}/{} alive, {} dead".format(len(bms)-dead, len(bms), dead))
PYEOF
;;
export)
    fmt="${1:-md}"
    python3 -c "
import json
with open('$DB') as f: bms = json.load(f)
fmt = '$fmt'
if fmt == 'md':
    print('# Bookmarks\n')
    for b in bms:
        tags = ' '.join(['#'+t for t in b.get('tags',[]) if t])
        print('- [{}]({}) {}'.format(b['title'], b['url'], tags))
elif fmt == 'html':
    print('<html><head><title>Bookmarks</title></head><body><h1>Bookmarks</h1><ul>')
    for b in bms:
        print('<li><a href=\"{}\">{}</a></li>'.format(b['url'], b['title']))
    print('</ul></body></html>')
else:
    print(json.dumps(bms, indent=2, ensure_ascii=False))
";;
delete)
    url="${1:-}"; [ -z "$url" ] && { echo "Usage: delete <url>"; exit 1; }
    python3 -c "
import json
with open('$DB') as f: bms = json.load(f)
new = [b for b in bms if b['url'] != '$url']
with open('$DB','w') as f: json.dump(new, f, indent=2)
print('Removed {} bookmark(s)'.format(len(bms)-len(new)))
";;
import)
    f="${1:-}"; [ -z "$f" ] && { echo "Usage: import <file>"; exit 1; }
    python3 -c "
import json, re
with open('$DB') as fh: bms = json.load(fh)
with open('$f') as fh: content = fh.read()
urls = re.findall(r'https?://[^\s<>\"]+', content)
added = 0
existing = set(b['url'] for b in bms)
for url in urls:
    if url not in existing:
        bms.append({'url':url,'title':url[:50],'tags':[],'added':'import','id':len(bms)+1})
        added += 1
with open('$DB','w') as fh: json.dump(bms, fh, indent=2)
print('Imported {} new bookmarks'.format(added))
";;
stats)
    python3 -c "
import json
from collections import Counter
with open('$DB') as f: bms = json.load(f)
domains = Counter(b['url'].split('/')[2] if '/' in b['url'] else '?' for b in bms)
print('📊 Bookmark Stats:')
print('  Total: {}'.format(len(bms)))
print('  Domains: {}'.format(len(domains)))
print('  Top domains:')
for d, c in domains.most_common(5):
    print('    {} ({})'.format(d, c))
";;
info) echo "Bookmark Manager v1.0.0"; echo "Save, organize, search your bookmarks"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
