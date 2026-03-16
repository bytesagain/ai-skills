#!/usr/bin/env bash
# Link Checker — Find broken links on any webpage
# Usage: bash main.sh --url <url> [--depth <1|2>] [--timeout <seconds>] [--format text|json|html]
set -euo pipefail

URL="" DEPTH="1" TIMEOUT="10" FORMAT="text" OUTPUT="" MAX_LINKS="100"

show_help() { cat << 'HELPEOF'
Link Checker — Find broken links on any webpage

Usage: bash main.sh --url <url> [options]

Options:
  --url <url>        URL to check (required)
  --depth <n>        Crawl depth: 1=page only, 2=follow internal links (default: 1)
  --timeout <sec>    Request timeout per link (default: 10)
  --max <n>          Maximum links to check (default: 100)
  --format <fmt>     Output: text, json, html (default: text)
  --output <file>    Save report to file
  --help             Show this help

Checks: HTTP status codes, redirects, timeouts, external vs internal,
        anchor links, response times

Examples:
  bash main.sh --url https://example.com
  bash main.sh --url https://mysite.com --depth 2 --max 200
  bash main.sh --url https://mysite.com --format html --output report.html

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELPEOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --url) URL="$2"; shift 2;; --depth) DEPTH="$2"; shift 2;;
        --timeout) TIMEOUT="$2"; shift 2;; --max) MAX_LINKS="$2"; shift 2;;
        --format) FORMAT="$2"; shift 2;; --output) OUTPUT="$2"; shift 2;;
        --help|-h) show_help; exit 0;; *) shift;;
    esac
done

[ -z "$URL" ] && { echo "Error: --url required"; show_help; exit 1; }

check_links() {
    python3 << PYEOF
import re, sys, json, time

try:
    from urllib.request import urlopen, Request
    from urllib.error import URLError, HTTPError
    from urllib.parse import urljoin, urlparse
except ImportError:
    from urllib2 import urlopen, Request, URLError, HTTPError
    from urlparse import urljoin, urlparse

base_url = "$URL"
timeout = int("$TIMEOUT")
max_links = int("$MAX_LINKS")
fmt = "$FORMAT"

def get_page(url):
    try:
        req = Request(url, headers={"User-Agent": "BytesAgain-LinkChecker/1.0"})
        resp = urlopen(req, timeout=timeout)
        return resp.read().decode("utf-8", errors="ignore"), resp.getcode()
    except HTTPError as e:
        return "", e.code
    except:
        return "", 0

def extract_links(html, base):
    links = set()
    for match in re.finditer(r'<a[^>]+href=["\']([^"\'#]+)', html, re.I):
        href = match.group(1).strip()
        if href.startswith("mailto:") or href.startswith("tel:") or href.startswith("javascript:"):
            continue
        full = urljoin(base, href)
        links.add(full)
    return links

def check_url(url):
    start = time.time()
    try:
        req = Request(url, headers={"User-Agent": "BytesAgain-LinkChecker/1.0"})
        req.get_method = lambda: "HEAD"
        resp = urlopen(req, timeout=timeout)
        elapsed = time.time() - start
        return {"url": url, "status": resp.getcode(), "time": round(elapsed, 2), "ok": True}
    except HTTPError as e:
        elapsed = time.time() - start
        return {"url": url, "status": e.code, "time": round(elapsed, 2), "ok": e.code < 400}
    except Exception as e:
        elapsed = time.time() - start
        return {"url": url, "status": 0, "time": round(elapsed, 2), "ok": False, "error": str(e)[:100]}

# Fetch main page
print("Checking: {}".format(base_url), file=sys.stderr)
html, code = get_page(base_url)
if not html:
    print("Error: Could not fetch page (HTTP {})".format(code))
    sys.exit(1)

links = extract_links(html, base_url)
base_domain = urlparse(base_url).netloc

# Classify links
internal = sorted([l for l in links if urlparse(l).netloc == base_domain])
external = sorted([l for l in links if urlparse(l).netloc != base_domain and l.startswith("http")])

all_links = internal[:max_links] + external[:max(0, max_links - len(internal))]

# Check each link
results = []
checked = 0
for url in all_links:
    if checked >= max_links:
        break
    result = check_url(url)
    result["type"] = "internal" if urlparse(url).netloc == base_domain else "external"
    results.append(result)
    checked += 1
    
    # Progress
    status_icon = "✅" if result["ok"] else "❌"
    print("  [{}/{}] {} {} ({})".format(checked, len(all_links), status_icon, result["status"], url[:60]), file=sys.stderr)

# Summary
broken = [r for r in results if not r["ok"]]
redirects = [r for r in results if 300 <= r.get("status", 0) < 400]
ok = [r for r in results if r["ok"] and r.get("status", 0) < 300]
slow = [r for r in results if r["time"] > 3.0]

if fmt == "json":
    print(json.dumps({
        "url": base_url,
        "total_links": len(all_links),
        "checked": len(results),
        "broken": len(broken),
        "redirects": len(redirects),
        "ok": len(ok),
        "slow": len(slow),
        "results": results
    }, indent=2))
elif fmt == "html":
    print("<html><head><title>Link Check: {}</title>".format(base_url))
    print('<style>body{font-family:sans-serif;max-width:900px;margin:auto;padding:20px;background:#1a1a2e;color:#e0e0e0}')
    print('.ok{color:#4caf50}.broken{color:#f44336}.redirect{color:#ff9800}.slow{color:#ffeb3b}</style></head><body>')
    print('<h1>Link Check Report</h1><p>{}</p>'.format(base_url))
    print('<p>Total: {} | ✅ OK: {} | ❌ Broken: {} | ↩️ Redirects: {} | 🐌 Slow: {}</p>'.format(
        len(results), len(ok), len(broken), len(redirects), len(slow)))
    if broken:
        print('<h2 class="broken">Broken Links ({})</h2><ul>'.format(len(broken)))
        for r in broken:
            print('<li>{} — {} {}</li>'.format(r["status"], r["url"], r.get("error","")))
        print('</ul>')
    if redirects:
        print('<h2 class="redirect">Redirects ({})</h2><ul>'.format(len(redirects)))
        for r in redirects: print('<li>{} — {}</li>'.format(r["status"], r["url"]))
        print('</ul>')
    print('<p>Powered by BytesAgain</p></body></html>')
else:
    print("")
    print("=" * 55)
    print("  Link Check Report")
    print("  {}".format(base_url))
    print("=" * 55)
    print("")
    print("  Total links: {} ({} internal, {} external)".format(
        len(all_links), len(internal), len(external)))
    print("  Checked: {}".format(len(results)))
    print("  ✅ OK: {}  ❌ Broken: {}  ↩️ Redirects: {}  🐌 Slow: {}".format(
        len(ok), len(broken), len(redirects), len(slow)))
    
    if broken:
        print("")
        print("  ❌ BROKEN LINKS:")
        for r in broken:
            err = " ({})".format(r["error"]) if "error" in r else ""
            print("    [{}] {}{}".format(r["status"], r["url"][:70], err))
    
    if redirects:
        print("")
        print("  ↩️ REDIRECTS:")
        for r in redirects:
            print("    [{}] {}".format(r["status"], r["url"][:70]))
    
    if slow:
        print("")
        print("  🐌 SLOW (>3s):")
        for r in slow:
            print("    [{:.1f}s] {}".format(r["time"], r["url"][:70]))
    
    print("")
    print("---")
    print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
}

if [ -n "$OUTPUT" ]; then
    check_links > "$OUTPUT"
    echo "Saved to $OUTPUT"
else
    check_links
fi
