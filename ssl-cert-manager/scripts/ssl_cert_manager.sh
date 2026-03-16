#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# SSL Cert Manager — SSL certificate management (inspired by acme.sh 45K+ stars)
set -euo pipefail
CMD="${1:-help}"
shift 2>/dev/null || true
case "$CMD" in
    help)
        echo "SSL Cert Manager — certificate checking & management"
        echo "Commands:"
        echo "  check <domain>      Check SSL certificate details"
        echo "  expiry <domain>     Days until expiry"
        echo "  chain <domain>      Show certificate chain"
        echo "  compare <d1> <d2>   Compare two domains' certs"
        echo "  batch <file>        Check multiple domains"
        echo "  monitor <domain>    Monitor and alert if <30 days"
        echo "  info                Version info"
        echo "Powered by BytesAgain | bytesagain.com";;
    check)
        domain="${1:-}"; [ -z "$domain" ] && { echo "Usage: check <domain>"; exit 1; }
        echo | openssl s_client -servername "$domain" -connect "${domain}:443" 2>/dev/null | openssl x509 -noout -subject -issuer -dates -fingerprint 2>/dev/null || echo "Failed to connect";;
    expiry)
        domain="${1:-}"; [ -z "$domain" ] && { echo "Usage: expiry <domain>"; exit 1; }
        python3 << PYEOF
import ssl, socket, datetime
domain = "$domain"
try:
    ctx = ssl.create_default_context()
    conn = ctx.wrap_socket(socket.socket(), server_hostname=domain)
    conn.settimeout(10); conn.connect((domain, 443))
    cert = conn.getpeercert(); conn.close()
    exp = datetime.datetime.strptime(cert["notAfter"], "%b %d %H:%M:%S %Y %Z")
    days = (exp - datetime.datetime.utcnow()).days
    icon = "✅" if days > 30 else ("⚠" if days > 7 else "🚨")
    print("{} {}: {} days left (expires {})".format(icon, domain, days, cert["notAfter"]))
except Exception as e:
    print("Error: {}".format(e))
PYEOF
        ;;
    chain)
        domain="${1:-}"; [ -z "$domain" ] && { echo "Usage: chain <domain>"; exit 1; }
        echo | openssl s_client -showcerts -servername "$domain" -connect "${domain}:443" 2>/dev/null | grep -E "s:|i:" | head -20;;
    compare)
        d1="${1:-}"; d2="${2:-}"; [ -z "$d1" ] || [ -z "$d2" ] && { echo "Usage: compare <d1> <d2>"; exit 1; }
        echo "=== $d1 ==="; bash "$0" check "$d1"; echo ""; echo "=== $d2 ==="; bash "$0" check "$d2";;
    batch)
        file="${1:-}"; [ -z "$file" ] && { echo "Usage: batch <file>"; exit 1; }
        while IFS= read -r d; do [ -z "$d" ] && continue; bash "$0" expiry "$d"; done < "$file";;
    monitor)
        domain="${1:-}"; [ -z "$domain" ] && { echo "Usage: monitor <domain>"; exit 1; }
        bash "$0" expiry "$domain";;
    info) echo "SSL Cert Manager v1.0.0"; echo "Inspired by: acme.sh (45,000+ stars)"; echo "Powered by BytesAgain | bytesagain.com";;
    *) echo "Unknown: $CMD"; exit 1;;
esac
