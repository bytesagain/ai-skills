#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# Website Monitor — website change detection & uptime monitoring (inspired by changedetection.io 30K+ stars)
set -euo pipefail
CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in
    help)
        echo "Website Monitor — uptime & change detection"
        echo ""
        echo "Commands:"
        echo "  check <url>           Check website status"
        echo "  ping <url> [count]    Latency test (default 5)"
        echo "  headers <url>         Show response headers"
        echo "  ssl <domain>          SSL certificate check"
        echo "  speed <url>           Page load speed test"
        echo "  diff <url>            Detect content changes"
        echo "  batch <file>          Check multiple URLs from file"
        echo "  dns <domain>          DNS lookup"
        echo "  info                  Version info"
        echo ""
        echo "Powered by BytesAgain | bytesagain.com"
        ;;
    check)
        url="${1:-}"
        [ -z "$url" ] && { echo "Usage: check <url>"; exit 1; }
        python3 << PYEOF
import time
try:
    from urllib.request import urlopen, Request
except:
    from urllib2 import urlopen, Request
url = "$url"
if not url.startswith("http"): url = "https://" + url
start = time.time()
try:
    req = Request(url, headers={"User-Agent": "WebsiteMonitor/1.0"})
    resp = urlopen(req, timeout=15)
    elapsed = time.time() - start
    code = resp.getcode()
    size = len(resp.read())
    print("URL: {}".format(url))
    print("Status: {} {}".format(code, "OK" if code == 200 else "WARNING"))
    print("Response time: {:.3f}s".format(elapsed))
    print("Content size: {:,} bytes".format(size))
    print("Content type: {}".format(resp.headers.get("Content-Type", "?")))
    print("Server: {}".format(resp.headers.get("Server", "?")))
except Exception as e:
    elapsed = time.time() - start
    print("URL: {}".format(url))
    print("Status: DOWN")
    print("Error: {}".format(str(e)[:100]))
    print("Response time: {:.3f}s".format(elapsed))
PYEOF
        ;;
    ping)
        url="${1:-}"; count="${2:-5}"
        [ -z "$url" ] && { echo "Usage: ping <url> [count]"; exit 1; }
        python3 << PYEOF
import time
try:
    from urllib.request import urlopen, Request
except:
    from urllib2 import urlopen, Request
import statistics
url = "$url"
if not url.startswith("http"): url = "https://" + url
count = int("$count")
times = []
print("Pinging {} ({} times)".format(url, count))
for i in range(count):
    start = time.time()
    try:
        resp = urlopen(Request(url, headers={"User-Agent":"Monitor/1.0"}), timeout=10)
        resp.read()
        elapsed = (time.time() - start) * 1000
        times.append(elapsed)
        print("  {:>2d}: {:.0f}ms [{}]".format(i+1, elapsed, resp.getcode()))
    except Exception as e:
        print("  {:>2d}: TIMEOUT".format(i+1))
if times:
    print("\nLatency: avg={:.0f}ms min={:.0f}ms max={:.0f}ms".format(
        statistics.mean(times), min(times), max(times)))
PYEOF
        ;;
    headers)
        url="${1:-}"
        [ -z "$url" ] && { echo "Usage: headers <url>"; exit 1; }
        curl -sI "$url" 2>/dev/null || echo "Failed to reach $url"
        ;;
    ssl)
        domain="${1:-}"
        [ -z "$domain" ] && { echo "Usage: ssl <domain>"; exit 1; }
        python3 << PYEOF
import ssl, socket, datetime
domain = "$domain"
try:
    ctx = ssl.create_default_context()
    conn = ctx.wrap_socket(socket.socket(), server_hostname=domain)
    conn.settimeout(10)
    conn.connect((domain, 443))
    cert = conn.getpeercert()
    conn.close()
    subject = dict(x[0] for x in cert["subject"])
    issuer = dict(x[0] for x in cert["issuer"])
    not_after = cert["notAfter"]
    # Parse expiry
    try:
        exp = datetime.datetime.strptime(not_after, "%b %d %H:%M:%S %Y %Z")
        days_left = (exp - datetime.datetime.utcnow()).days
    except:
        days_left = "?"
    print("SSL Certificate: {}".format(domain))
    print("  Subject: {}".format(subject.get("commonName", "?")))
    print("  Issuer: {}".format(issuer.get("organizationName", "?")))
    print("  Expires: {}".format(not_after))
    print("  Days left: {}".format(days_left))
    print("  SAN: {}".format(", ".join(x[1] for x in cert.get("subjectAltName", []))[:80]))
    if isinstance(days_left, int):
        if days_left < 7:
            print("  ⚠ CRITICAL: Certificate expiring soon!")
        elif days_left < 30:
            print("  ⚠ WARNING: Less than 30 days")
        else:
            print("  ✅ Certificate valid")
except Exception as e:
    print("SSL check failed for {}: {}".format(domain, e))
PYEOF
        ;;
    speed)
        url="${1:-}"
        [ -z "$url" ] && { echo "Usage: speed <url>"; exit 1; }
        python3 << PYEOF
import time
try:
    from urllib.request import urlopen, Request
except:
    from urllib2 import urlopen, Request
url = "$url"
if not url.startswith("http"): url = "https://" + url
print("Speed Test: {}".format(url))
# DNS + Connect
t0 = time.time()
try:
    req = Request(url, headers={"User-Agent": "SpeedTest/1.0"})
    resp = urlopen(req, timeout=30)
    t_connect = time.time() - t0
    # First byte
    first_chunk = resp.read(1)
    t_first = time.time() - t0
    # Full download
    rest = resp.read()
    t_total = time.time() - t0
    total_size = len(first_chunk) + len(rest)
    print("  Connect:    {:.3f}s".format(t_connect))
    print("  First byte: {:.3f}s".format(t_first))
    print("  Total:      {:.3f}s".format(t_total))
    print("  Size:       {:,} bytes".format(total_size))
    if t_total > 0:
        print("  Speed:      {:.1f} KB/s".format(total_size/1024/t_total))
except Exception as e:
    print("  Error: {}".format(e))
PYEOF
        ;;
    diff)
        url="${1:-}"
        [ -z "$url" ] && { echo "Usage: diff <url>"; exit 1; }
        python3 << PYEOF
import hashlib, os, time, json
try:
    from urllib.request import urlopen, Request
except:
    from urllib2 import urlopen, Request
url = "$url"
if not url.startswith("http"): url = "https://" + url
state_file = "/tmp/webmon_state.json"
state = {}
if os.path.exists(state_file):
    try:
        with open(state_file) as f: state = json.load(f)
    except: pass
try:
    resp = urlopen(Request(url, headers={"User-Agent":"Monitor/1.0"}), timeout=15)
    content = resp.read()
    current_hash = hashlib.md5(content).hexdigest()
    current_size = len(content)
except Exception as e:
    print("Error fetching {}: {}".format(url, e))
    exit(1)
prev = state.get(url, {})
if prev:
    if prev["hash"] != current_hash:
        print("⚠ CHANGED: {}".format(url))
        print("  Previous: {} ({:,} bytes) at {}".format(prev["hash"][:12], prev.get("size",0), prev.get("time","?")))
        print("  Current:  {} ({:,} bytes)".format(current_hash[:12], current_size))
        print("  Size diff: {:+,d} bytes".format(current_size - prev.get("size",0)))
    else:
        print("✅ No change: {}".format(url))
        print("  Hash: {} ({:,} bytes)".format(current_hash[:12], current_size))
else:
    print("📝 First check: {}".format(url))
    print("  Hash: {} ({:,} bytes)".format(current_hash[:12], current_size))
state[url] = {"hash": current_hash, "size": current_size, "time": time.strftime("%Y-%m-%d %H:%M")}
with open(state_file, "w") as f: json.dump(state, f, indent=2)
PYEOF
        ;;
    batch)
        file="${1:-}"
        [ -z "$file" ] && { echo "Usage: batch <file> (one URL per line)"; exit 1; }
        [ ! -f "$file" ] && { echo "File not found: $file"; exit 1; }
        while IFS= read -r url; do
            [ -z "$url" ] && continue
            [[ "$url" == \#* ]] && continue
            echo "--- $url ---"
            bash "$0" check "$url" 2>/dev/null
            echo ""
        done < "$file"
        ;;
    dns)
        domain="${1:-}"
        [ -z "$domain" ] && { echo "Usage: dns <domain>"; exit 1; }
        python3 << PYEOF
import socket
domain = "$domain"
print("DNS Lookup: {}".format(domain))
try:
    ips = socket.getaddrinfo(domain, None)
    seen = set()
    for info in ips:
        ip = info[4][0]
        fam = "IPv4" if info[0] == socket.AF_INET else "IPv6"
        if ip not in seen:
            seen.add(ip)
            print("  {} {}".format(fam, ip))
except Exception as e:
    print("  Error: {}".format(e))
PYEOF
        ;;
    info)
        echo "Website Monitor v1.0.0"
        echo "Inspired by: changedetection.io (30,000+ GitHub stars)"
        echo "Powered by BytesAgain | bytesagain.com"
        ;;
    *)
        echo "Unknown: $CMD — run 'help' for usage"; exit 1
        ;;
esac
