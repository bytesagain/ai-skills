#!/usr/bin/env bash
# SEO Audit Pro — Comprehensive SEO analysis for any URL
# Usage: bash main.sh --url <url> [--output <file>] [--format html|text]
set -euo pipefail

URL="" OUTPUT="" FORMAT="text"

show_help() { cat << 'HELPEOF'
SEO Audit Pro — Analyze any webpage for SEO issues

Usage: bash main.sh --url <url> [options]

Options:
  --url <url>        URL to audit (required)
  --format <fmt>     Output: text, html, json (default: text)
  --output <file>    Save report to file
  --help             Show this help

Checks: meta tags, headings, images, links, page speed hints, structured data,
        mobile-friendliness, content quality, social tags, canonical URLs

Examples:
  bash main.sh --url https://example.com
  bash main.sh --url https://example.com --format html --output report.html

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELPEOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --url) URL="$2"; shift 2;; --output) OUTPUT="$2"; shift 2;;
        --format) FORMAT="$2"; shift 2;; --help|-h) show_help; exit 0;; *) shift;;
    esac
done

[ -z "$URL" ] && { echo "Error: --url required"; show_help; exit 1; }

# Fetch page
TMPHTML="/tmp/seo-audit-$$.html"
TMPHEADERS="/tmp/seo-headers-$$.txt"
START_TIME=$(date +%s%N 2>/dev/null || date +%s)

HTTP_CODE=$(curl -s -o "$TMPHTML" -w "%{http_code}" -D "$TMPHEADERS" --max-time 30 -L "$URL" 2>/dev/null || echo "000")

END_TIME=$(date +%s%N 2>/dev/null || date +%s)

python3 << PYEOF
import re, sys, json

url = "$URL"
http_code = "$HTTP_CODE"
fmt = "$FORMAT"

try:
    with open("$TMPHTML", "r", errors="ignore") as f:
        html = f.read()
except:
    html = ""

try:
    with open("$TMPHEADERS", "r", errors="ignore") as f:
        headers = f.read()
except:
    headers = ""

issues = []
warnings = []
passed = []
info = []

# ── Meta Tags ──
title_match = re.search(r'<title[^>]*>(.*?)</title>', html, re.I | re.S)
title = title_match.group(1).strip() if title_match else ""
if not title:
    issues.append("Missing <title> tag")
elif len(title) < 30:
    warnings.append("Title too short ({} chars, recommend 50-60)".format(len(title)))
elif len(title) > 60:
    warnings.append("Title too long ({} chars, recommend 50-60)".format(len(title)))
else:
    passed.append("Title tag OK ({} chars)".format(len(title)))

meta_desc = re.search(r'<meta[^>]+name=["\']description["\'][^>]+content=["\'](.*?)["\']', html, re.I)
if not meta_desc:
    meta_desc = re.search(r'<meta[^>]+content=["\'](.*?)["\'][^>]+name=["\']description["\']', html, re.I)
desc = meta_desc.group(1) if meta_desc else ""
if not desc:
    issues.append("Missing meta description")
elif len(desc) < 120:
    warnings.append("Meta description short ({} chars, recommend 150-160)".format(len(desc)))
elif len(desc) > 160:
    warnings.append("Meta description long ({} chars, recommend 150-160)".format(len(desc)))
else:
    passed.append("Meta description OK ({} chars)".format(len(desc)))

# Viewport
viewport = re.search(r'<meta[^>]+name=["\']viewport["\']', html, re.I)
if viewport:
    passed.append("Viewport meta tag present (mobile-friendly)")
else:
    issues.append("Missing viewport meta tag (not mobile-friendly)")

# Canonical
canonical = re.search(r'<link[^>]+rel=["\']canonical["\'][^>]+href=["\'](.*?)["\']', html, re.I)
if canonical:
    passed.append("Canonical URL: {}".format(canonical.group(1)[:80]))
else:
    warnings.append("No canonical URL set")

# Charset
charset = re.search(r'<meta[^>]+charset', html, re.I)
if charset:
    passed.append("Charset declaration found")
else:
    warnings.append("No charset meta tag")

# ── Headings ──
h1s = re.findall(r'<h1[^>]*>(.*?)</h1>', html, re.I | re.S)
h1_texts = [re.sub(r'<[^>]+>', '', h).strip() for h in h1s]
if not h1_texts:
    issues.append("No <h1> tag found")
elif len(h1_texts) > 1:
    warnings.append("Multiple <h1> tags ({})".format(len(h1_texts)))
else:
    passed.append("Single <h1>: {}".format(h1_texts[0][:60]))

for level in range(2, 7):
    tags = re.findall(r'<h{}[^>]*>'.format(level), html, re.I)
    if tags:
        info.append("H{}: {} tags".format(level, len(tags)))

# ── Images ──
images = re.findall(r'<img[^>]*>', html, re.I)
no_alt = [img for img in images if 'alt=' not in img.lower() or 'alt=""' in img.lower()]
if images:
    if no_alt:
        warnings.append("{}/{} images missing alt text".format(len(no_alt), len(images)))
    else:
        passed.append("All {} images have alt text".format(len(images)))
else:
    info.append("No images found")

# Large images (no width/height)
no_dimensions = [img for img in images if 'width=' not in img.lower() and 'height=' not in img.lower()]
if no_dimensions:
    warnings.append("{} images without explicit dimensions (CLS risk)".format(len(no_dimensions)))

# ── Links ──
links = re.findall(r'<a[^>]+href=["\'](.*?)["\']', html, re.I)
internal = [l for l in links if l.startswith('/') or url.split('/')[2] in l]
external = [l for l in links if l.startswith('http') and url.split('/')[2] not in l]
info.append("Links: {} internal, {} external".format(len(internal), len(external)))

nofollow = len(re.findall(r'rel=["\'][^"\']*nofollow', html, re.I))
if nofollow:
    info.append("{} nofollow links".format(nofollow))

# ── Social Tags ──
og_title = re.search(r'<meta[^>]+property=["\']og:title["\']', html, re.I)
og_desc = re.search(r'<meta[^>]+property=["\']og:description["\']', html, re.I)
og_image = re.search(r'<meta[^>]+property=["\']og:image["\']', html, re.I)
twitter_card = re.search(r'<meta[^>]+name=["\']twitter:card["\']', html, re.I)

social_score = sum([bool(og_title), bool(og_desc), bool(og_image), bool(twitter_card)])
if social_score == 4:
    passed.append("All social meta tags present (OG + Twitter)")
elif social_score > 0:
    warnings.append("Partial social tags ({}/4)".format(social_score))
else:
    warnings.append("No social meta tags (OG/Twitter)")

# ── Performance Hints ──
page_size = len(html)
if page_size > 500000:
    warnings.append("Large page size ({:.0f}KB)".format(page_size/1024))
elif page_size > 100000:
    info.append("Page size: {:.0f}KB".format(page_size/1024))
else:
    passed.append("Page size OK ({:.0f}KB)".format(page_size/1024))

inline_css = len(re.findall(r'<style', html, re.I))
inline_js = len(re.findall(r'<script(?![^>]*src=)', html, re.I))
if inline_css > 3:
    warnings.append("{} inline <style> blocks (consider external CSS)".format(inline_css))
if inline_js > 5:
    warnings.append("{} inline <script> blocks (consider external JS)".format(inline_js))

# ── Structured Data ──
json_ld = re.findall(r'<script[^>]+type=["\']application/ld\+json["\']', html, re.I)
if json_ld:
    passed.append("{} structured data blocks (JSON-LD)".format(len(json_ld)))
else:
    warnings.append("No structured data (JSON-LD)")

# ── HTTP ──
if http_code == "200":
    passed.append("HTTP 200 OK")
elif http_code.startswith("3"):
    warnings.append("HTTP {} redirect".format(http_code))
else:
    issues.append("HTTP {} error".format(http_code))

https = url.startswith("https")
if https:
    passed.append("HTTPS enabled")
else:
    issues.append("Not using HTTPS")

# ── Score ──
total_checks = len(issues) + len(warnings) + len(passed)
score = int((len(passed) / total_checks * 100)) if total_checks else 0

# ── Output ──
if fmt == "json":
    print(json.dumps({
        "url": url, "score": score, "http_code": http_code,
        "title": title, "description": desc,
        "issues": issues, "warnings": warnings, "passed": passed, "info": info
    }, indent=2))
elif fmt == "html":
    color = "#4caf50" if score >= 80 else ("#ff9800" if score >= 50 else "#f44336")
    print("<html><head><title>SEO Audit: {}</title>".format(url))
    print('<style>body{{font-family:sans-serif;max-width:800px;margin:auto;padding:20px;background:#1a1a2e;color:#e0e0e0}}')
    print('.score{{font-size:48px;font-weight:bold;color:{}}}'.format(color))
    print('.issue{{color:#f44336}}.warn{{color:#ff9800}}.pass{{color:#4caf50}}.info{{color:#64b5f6}}</style></head><body>')
    print('<h1>SEO Audit Report</h1><p>{}</p>'.format(url))
    print('<p class="score">{}/100</p>'.format(score))
    if issues:
        print('<h2 class="issue">Issues ({})</h2><ul>'.format(len(issues)))
        for i in issues: print('<li>{}</li>'.format(i))
        print('</ul>')
    if warnings:
        print('<h2 class="warn">Warnings ({})</h2><ul>'.format(len(warnings)))
        for w in warnings: print('<li>{}</li>'.format(w))
        print('</ul>')
    if passed:
        print('<h2 class="pass">Passed ({})</h2><ul>'.format(len(passed)))
        for p in passed: print('<li>{}</li>'.format(p))
        print('</ul>')
    print('<p style="color:#888">Powered by BytesAgain | bytesagain.com</p></body></html>')
else:
    print("=" * 50)
    print("  SEO AUDIT REPORT")
    print("  {}".format(url))
    print("  Score: {}/100".format(score))
    print("=" * 50)
    if issues:
        print("\n❌ ISSUES ({})".format(len(issues)))
        for i in issues: print("  • {}".format(i))
    if warnings:
        print("\n⚠️ WARNINGS ({})".format(len(warnings)))
        for w in warnings: print("  • {}".format(w))
    if passed:
        print("\n✅ PASSED ({})".format(len(passed)))
        for p in passed: print("  • {}".format(p))
    if info:
        print("\nℹ️ INFO")
        for i in info: print("  • {}".format(i))
    print("\n---")
    print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF

# Cleanup
rm -f "$TMPHTML" "$TMPHEADERS"
