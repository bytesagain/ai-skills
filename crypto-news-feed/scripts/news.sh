#!/usr/bin/env bash
# Crypto News Feed — Aggregate crypto news from multiple sources
# Usage: bash news.sh <command> [options]
set -euo pipefail

COMMAND="${1:-latest}"
shift 2>/dev/null || true

DATA_DIR="${HOME}/.crypto-news"
mkdir -p "$DATA_DIR"

case "$COMMAND" in
  latest|feed)
    LIMIT="${1:-20}"
    FILTER="${2:-all}"
    
    python3 << 'PYEOF'
import sys, os, json, time
try:
    from urllib2 import urlopen, Request
except ImportError:
    from urllib.request import urlopen, Request
import xml.etree.ElementTree as ET

limit = int(sys.argv[1]) if len(sys.argv) > 1 else 20
topic_filter = sys.argv[2] if len(sys.argv) > 2 else "all"

rss_feeds = [
    {"name": "CoinDesk", "url": "https://www.coindesk.com/arc/outboundfeeds/rss/", "category": "general"},
    {"name": "CoinTelegraph", "url": "https://cointelegraph.com/rss", "category": "general"},
    {"name": "The Block", "url": "https://www.theblock.co/rss.xml", "category": "general"},
    {"name": "Decrypt", "url": "https://decrypt.co/feed", "category": "general"},
    {"name": "Bitcoin Magazine", "url": "https://bitcoinmagazine.com/feed", "category": "bitcoin"},
    {"name": "DeFi Pulse", "url": "https://defipulse.com/blog/feed/", "category": "defi"},
    {"name": "Blockworks", "url": "https://blockworks.co/feed", "category": "general"},
    {"name": "CryptoSlate", "url": "https://cryptoslate.com/feed/", "category": "general"}
]

if topic_filter != "all":
    rss_feeds = [f for f in rss_feeds if topic_filter.lower() in f["category"]]

all_items = []

for feed in rss_feeds:
    try:
        req = Request(feed["url"])
        req.add_header("User-Agent", "CryptoNewsFeed/1.0")
        resp = urlopen(req, timeout=10)
        content = resp.read().decode("utf-8", errors="replace")
        
        root = ET.fromstring(content)
        
        # Handle both RSS 2.0 and Atom feeds
        items = root.findall(".//item")
        if not items:
            items = root.findall(".//{http://www.w3.org/2005/Atom}entry")
        
        for item in items[:5]:
            title = item.findtext("title", "")
            if not title:
                title = item.findtext("{http://www.w3.org/2005/Atom}title", "")
            
            link = item.findtext("link", "")
            if not link:
                link_elem = item.find("{http://www.w3.org/2005/Atom}link")
                if link_elem is not None:
                    link = link_elem.get("href", "")
            
            pub_date = item.findtext("pubDate", "")
            if not pub_date:
                pub_date = item.findtext("{http://www.w3.org/2005/Atom}published", "")
            
            description = item.findtext("description", "")[:200] if item.findtext("description", "") else ""
            
            all_items.append({
                "source": feed["name"],
                "title": title.strip(),
                "link": link.strip(),
                "date": pub_date.strip(),
                "summary": description.strip(),
                "category": feed["category"]
            })
    except Exception as e:
        pass

# Sort by date (newest first) — simple string sort works for most date formats
all_items.sort(key=lambda x: x["date"], reverse=True)
all_items = all_items[:limit]

print("=" * 70)
print("CRYPTO NEWS FEED — {} articles".format(len(all_items)))
print("Time: {}".format(time.strftime("%Y-%m-%d %H:%M")))
print("=" * 70)
print("")

for i, item in enumerate(all_items, 1):
    print("{}. [{}] {}".format(i, item["source"], item["title"]))
    if item["date"]:
        print("   Date: {}".format(item["date"][:30]))
    if item["link"]:
        print("   Link: {}".format(item["link"]))
    if item["summary"]:
        clean = item["summary"].replace("<p>", "").replace("</p>", "").replace("&amp;", "&")[:150]
        print("   {}...".format(clean))
    print("")

# Cache results
cache_file = os.path.join(os.path.expanduser("~/.crypto-news"), "latest.json")
with open(cache_file, "w") as f:
    json.dump({"timestamp": time.strftime("%Y-%m-%d %H:%M:%S"), "items": all_items}, f, indent=2)
print("Cached {} articles to {}".format(len(all_items), cache_file))
PYEOF
    ;;

  search)
    KEYWORD="${1:-bitcoin}"
    
    python3 << 'PYEOF'
import json, os, sys

keyword = sys.argv[1] if len(sys.argv) > 1 else "bitcoin"
cache_file = os.path.expanduser("~/.crypto-news/latest.json")

if not os.path.exists(cache_file):
    print("No cached news. Run 'bash news.sh latest' first.")
    sys.exit(1)

with open(cache_file, "r") as f:
    data = json.load(f)

items = data.get("items", [])
matches = [i for i in items if keyword.lower() in i.get("title", "").lower() or keyword.lower() in i.get("summary", "").lower()]

print("=" * 60)
print("SEARCH: '{}' — {} results".format(keyword, len(matches)))
print("=" * 60)
print("")
for i, item in enumerate(matches, 1):
    print("{}. [{}] {}".format(i, item["source"], item["title"]))
    if item["link"]:
        print("   {}".format(item["link"]))
    print("")

if not matches:
    print("No matches found. Try 'bash news.sh latest' to refresh cache.")
PYEOF
    ;;

  digest)
    python3 << 'PYEOF'
import json, os, time

data_dir = os.path.expanduser("~/.crypto-news")
cache_file = os.path.join(data_dir, "latest.json")

if not os.path.exists(cache_file):
    print("No cached news. Run 'bash news.sh latest' first.")
    exit(1)

with open(cache_file, "r") as f:
    data = json.load(f)

items = data.get("items", [])
ts = data.get("timestamp", "?")

# Generate HTML digest
html = """<!DOCTYPE html>
<html><head><title>Crypto News Digest</title>
<meta charset="utf-8">
<style>
body {{ font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; max-width: 800px; margin: 40px auto; background: #0d1117; color: #c9d1d9; padding: 20px; }}
h1 {{ color: #58a6ff; }}
.article {{ border: 1px solid #30363d; border-radius: 8px; padding: 16px; margin: 12px 0; background: #161b22; }}
.source {{ color: #8b949e; font-size: 0.85em; }}
.title {{ color: #f0f6fc; font-size: 1.1em; font-weight: bold; }}
a {{ color: #58a6ff; text-decoration: none; }}
a:hover {{ text-decoration: underline; }}
.summary {{ color: #8b949e; margin-top: 8px; }}
.footer {{ margin-top: 30px; padding-top: 15px; border-top: 1px solid #30363d; color: #484f58; font-size: 0.8em; }}
</style></head><body>
<h1>Crypto News Digest</h1>
<p style="color:#8b949e">Generated: {ts}</p>
""".format(ts=ts)

for item in items[:15]:
    source = item.get("source", "")
    title = item.get("title", "")
    link = item.get("link", "#")
    summary = item.get("summary", "").replace("<", "&lt;").replace(">", "&gt;")[:200]
    date = item.get("date", "")[:20]
    
    html += """<div class="article">
<div class="source">{source} — {date}</div>
<div class="title"><a href="{link}">{title}</a></div>
<div class="summary">{summary}</div>
</div>
""".format(source=source, date=date, link=link, title=title, summary=summary)

html += """<div class="footer">
<p>Powered by BytesAgain | bytesagain.com | hello@bytesagain.com</p>
</div></body></html>"""

digest_file = os.path.join(data_dir, "digest-{}.html".format(time.strftime("%Y%m%d")))
with open(digest_file, "w") as f:
    f.write(html)
print("Digest saved to: {}".format(digest_file))
print("Contains {} articles from {} sources".format(len(items[:15]), len(set(i["source"] for i in items[:15]))))
PYEOF
    ;;

  sources)
    python3 << 'PYEOF'
sources = [
    ("CoinDesk", "https://coindesk.com", "general", "Major crypto news outlet"),
    ("CoinTelegraph", "https://cointelegraph.com", "general", "Global crypto media"),
    ("The Block", "https://theblock.co", "general", "Institutional crypto news"),
    ("Decrypt", "https://decrypt.co", "general", "Accessible crypto coverage"),
    ("Bitcoin Magazine", "https://bitcoinmagazine.com", "bitcoin", "Bitcoin-focused"),
    ("Blockworks", "https://blockworks.co", "general", "DeFi and institutional"),
    ("CryptoSlate", "https://cryptoslate.com", "general", "Research-oriented"),
    ("DeFi Pulse", "https://defipulse.com", "defi", "DeFi analytics")
]

print("=" * 70)
print("NEWS SOURCES")
print("=" * 70)
print("")
print("{:<20} {:<12} {}".format("Source", "Category", "Focus"))
print("-" * 70)
for name, url, cat, desc in sources:
    print("{:<20} {:<12} {}".format(name, cat, desc))
print("")
print("Filter by category: bash news.sh latest 20 defi")
print("Available categories: general, bitcoin, defi")
PYEOF
    ;;

  help|*)
    cat << 'HELPEOF'
Crypto News Feed — Aggregate news from top crypto sources

COMMANDS:
  latest [limit] [category]    Fetch latest news (default: 20 articles)
  search <keyword>             Search cached news articles
  digest                       Generate HTML news digest
  sources                      List available news sources

CATEGORIES: all, general, bitcoin, defi

EXAMPLES:
  bash news.sh latest
  bash news.sh latest 10 defi
  bash news.sh search ethereum
  bash news.sh digest
  bash news.sh sources
HELPEOF
    ;;
esac

echo ""
echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
