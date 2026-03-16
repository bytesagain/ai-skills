#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# Network Monitor — network traffic & connectivity monitoring (inspired by sniffnet 32K+ stars)
set -euo pipefail
CMD="${1:-help}"
shift 2>/dev/null || true
case "$CMD" in
    help)
        echo "Network Monitor — connectivity & traffic analysis"
        echo "Commands:"
        echo "  status              Network interfaces status"
        echo "  connections         Active connections"
        echo "  ports               Listening ports"
        echo "  bandwidth           Bandwidth usage estimate"
        echo "  latency <host>      Latency test"
        echo "  trace <host>        Traceroute"
        echo "  dns <domain>        DNS resolution"
        echo "  whois <domain>      Domain info"
        echo "  speed               Download speed test"
        echo "  info                Version info"
        echo "Powered by BytesAgain | bytesagain.com";;
    status)
        python3 << 'PYEOF'
import os
print("Network Interfaces:")
for iface in os.listdir("/sys/class/net/"):
    state = open("/sys/class/net/{}/operstate".format(iface)).read().strip()
    try: mac = open("/sys/class/net/{}/address".format(iface)).read().strip()
    except: mac = "?"
    try:
        rx = int(open("/sys/class/net/{}/statistics/rx_bytes".format(iface)).read().strip())
        tx = int(open("/sys/class/net/{}/statistics/tx_bytes".format(iface)).read().strip())
    except: rx, tx = 0, 0
    print("  {:10s} {:5s} {:17s} RX:{:.1f}MB TX:{:.1f}MB".format(
        iface, state, mac, rx/1048576, tx/1048576))
PYEOF
        ;;
    connections)
        echo "Active Connections:"
        ss -tn 2>/dev/null | head -30 || netstat -tn 2>/dev/null | head -30
        echo ""
        echo "Summary:"
        ss -s 2>/dev/null || echo "(ss not available)";;
    ports)
        echo "Listening Ports:"
        ss -tlnp 2>/dev/null || netstat -tlnp 2>/dev/null;;
    bandwidth)
        python3 << 'PYEOF'
import time
def get_bytes():
    d = {}
    with open("/proc/net/dev") as f:
        for line in f:
            if ":" in line:
                parts = line.split(":")
                iface = parts[0].strip()
                vals = parts[1].split()
                d[iface] = {"rx": int(vals[0]), "tx": int(vals[8])}
    return d
print("Measuring bandwidth (5 seconds)...")
t1 = get_bytes()
time.sleep(5)
t2 = get_bytes()
print("{:10s} {:>12s} {:>12s}".format("Interface", "Download", "Upload"))
print("-" * 38)
for iface in sorted(t2):
    if iface in t1:
        rx = (t2[iface]["rx"] - t1[iface]["rx"]) / 5
        tx = (t2[iface]["tx"] - t1[iface]["tx"]) / 5
        if rx > 0 or tx > 0:
            print("{:10s} {:>10.1f}KB/s {:>10.1f}KB/s".format(iface, rx/1024, tx/1024))
PYEOF
        ;;
    latency)
        host="${1:-8.8.8.8}"; ping -c 5 "$host" 2>/dev/null || echo "ping failed";;
    trace)
        host="${1:-8.8.8.8}"; traceroute -m 15 "$host" 2>/dev/null || tracepath "$host" 2>/dev/null || echo "traceroute not available";;
    dns)
        domain="${1:-}"; [ -z "$domain" ] && { echo "Usage: dns <domain>"; exit 1; }
        python3 -c "
import socket
domain = '$domain'
print('DNS: {}'.format(domain))
for info in socket.getaddrinfo(domain, None):
    fam = 'IPv4' if info[0] == socket.AF_INET else 'IPv6'
    print('  {} {}'.format(fam, info[4][0]))
";;
    whois)
        domain="${1:-}"; [ -z "$domain" ] && { echo "Usage: whois <domain>"; exit 1; }
        whois "$domain" 2>/dev/null | head -30 || echo "whois not available";;
    speed)
        python3 << 'PYEOF'
import time
try:
    from urllib.request import urlopen
except:
    from urllib2 import urlopen
print("Download Speed Test...")
url = "http://speedtest.tele2.net/1MB.zip"
start = time.time()
try:
    data = urlopen(url, timeout=30).read()
    elapsed = time.time() - start
    mb = len(data) / 1048576
    print("  Downloaded: {:.1f} MB in {:.1f}s".format(mb, elapsed))
    print("  Speed: {:.1f} Mbps".format(mb * 8 / elapsed))
except Exception as e:
    print("  Error: {}".format(e))
PYEOF
        ;;
    info) echo "Network Monitor v1.0.0"; echo "Inspired by: sniffnet (32,000+ stars)"; echo "Powered by BytesAgain | bytesagain.com";;
    *) echo "Unknown: $CMD"; exit 1;;
esac
