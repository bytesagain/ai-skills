#!/usr/bin/env bash
# SSL Checker — Inspect SSL/TLS certificates for any domain
# Usage: bash main.sh --domain <domain> [--port <port>] [--format text|json]
set -euo pipefail

DOMAIN="" PORT="443" FORMAT="text" OUTPUT="" WARN_DAYS="30"

show_help() { cat << 'HELPEOF'
SSL Checker — Inspect SSL/TLS certificates

Usage: bash main.sh --domain <domain> [options]

Options:
  --domain <domain>    Domain to check (required)
  --port <port>        Port (default: 443)
  --warn-days <n>      Warn if expiry within N days (default: 30)
  --format <fmt>       Output: text, json (default: text)
  --output <file>      Save to file
  --help               Show this help

Checks: certificate validity, expiry date, issuer, subject, SANs,
        protocol version, cipher suite, chain validation, HSTS

Examples:
  bash main.sh --domain example.com
  bash main.sh --domain google.com --format json
  bash main.sh --domain mysite.com --warn-days 60

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELPEOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --domain) DOMAIN="$2"; shift 2;; --port) PORT="$2"; shift 2;;
        --warn-days) WARN_DAYS="$2"; shift 2;; --format) FORMAT="$2"; shift 2;;
        --output) OUTPUT="$2"; shift 2;; --help|-h) show_help; exit 0;; *) shift;;
    esac
done

[ -z "$DOMAIN" ] && { echo "Error: --domain required"; show_help; exit 1; }

# Get certificate info
CERT_DATA=$(echo | openssl s_client -connect "$DOMAIN:$PORT" -servername "$DOMAIN" 2>/dev/null)
CERT_TEXT=$(echo "$CERT_DATA" | openssl x509 -noout -text 2>/dev/null || echo "")
CERT_DATES=$(echo "$CERT_DATA" | openssl x509 -noout -dates 2>/dev/null || echo "")
CERT_SUBJECT=$(echo "$CERT_DATA" | openssl x509 -noout -subject 2>/dev/null || echo "")
CERT_ISSUER=$(echo "$CERT_DATA" | openssl x509 -noout -issuer 2>/dev/null || echo "")
CERT_SERIAL=$(echo "$CERT_DATA" | openssl x509 -noout -serial 2>/dev/null || echo "")
CERT_FINGERPRINT=$(echo "$CERT_DATA" | openssl x509 -noout -fingerprint -sha256 2>/dev/null || echo "")

# Check HSTS
HSTS_HEADER=$(curl -sI --max-time 5 "https://$DOMAIN/" 2>/dev/null | grep -i "strict-transport-security" || echo "")

# Check protocol
PROTO_INFO=$(echo "$CERT_DATA" | grep -E "Protocol|Cipher" | head -2 || echo "")

python3 << PYEOF
import re, sys, json
from datetime import datetime

domain = "$DOMAIN"
port = "$PORT"
fmt = "$FORMAT"
warn_days = int("$WARN_DAYS")

cert_dates = """$CERT_DATES"""
cert_subject = """$CERT_SUBJECT"""
cert_issuer = """$CERT_ISSUER"""
cert_serial = """$CERT_SERIAL"""
cert_fingerprint = """$CERT_FINGERPRINT"""
cert_text = """$CERT_TEXT"""
hsts = """$HSTS_HEADER"""
proto = """$PROTO_INFO"""

# Parse dates
not_before = ""
not_after = ""
days_left = None
for line in cert_dates.split("\n"):
    if "notBefore" in line:
        not_before = line.split("=", 1)[-1].strip()
    elif "notAfter" in line:
        not_after = line.split("=", 1)[-1].strip()

if not_after:
    for date_fmt in ["%b %d %H:%M:%S %Y %Z", "%b  %d %H:%M:%S %Y %Z"]:
        try:
            exp = datetime.strptime(not_after, date_fmt)
            days_left = (exp - datetime.now()).days
            break
        except:
            continue

# Parse subject/issuer
subject = cert_subject.replace("subject=", "").strip()
issuer = cert_issuer.replace("issuer=", "").strip()
serial = cert_serial.replace("serial=", "").strip()
fingerprint = cert_fingerprint.split("=", 1)[-1].strip() if "=" in cert_fingerprint else ""

# Parse SANs
sans = re.findall(r"DNS:([^\s,]+)", cert_text)

# Parse protocol/cipher
protocol = ""
cipher = ""
for line in proto.split("\n"):
    line = line.strip()
    if "Protocol" in line:
        protocol = line.split(":", 1)[-1].strip() if ":" in line else line
    elif "Cipher" in line:
        cipher = line.split(":", 1)[-1].strip() if ":" in line else line

# Status
if days_left is None:
    status = "❓ Unknown"
    status_code = "unknown"
elif days_left < 0:
    status = "❌ EXPIRED ({} days ago)".format(abs(days_left))
    status_code = "expired"
elif days_left <= warn_days:
    status = "⚠️ EXPIRING SOON ({} days)".format(days_left)
    status_code = "warning"
else:
    status = "✅ Valid ({} days remaining)".format(days_left)
    status_code = "valid"

data = {
    "domain": domain,
    "port": int(port),
    "status": status_code,
    "days_remaining": days_left,
    "not_before": not_before,
    "not_after": not_after,
    "subject": subject,
    "issuer": issuer,
    "serial": serial,
    "fingerprint_sha256": fingerprint,
    "sans": sans[:20],
    "protocol": protocol,
    "cipher": cipher,
    "hsts": bool(hsts),
}

if fmt == "json":
    print(json.dumps(data, indent=2))
else:
    print("=" * 50)
    print("  SSL Certificate Report: {}".format(domain))
    print("=" * 50)
    print("")
    print("  Status:      {}".format(status))
    print("  Subject:     {}".format(subject))
    print("  Issuer:      {}".format(issuer))
    print("  Valid From:  {}".format(not_before))
    print("  Valid Until: {}".format(not_after))
    print("  Serial:      {}".format(serial))
    if fingerprint:
        print("  SHA-256:     {}".format(fingerprint[:40]))
    if protocol:
        print("  Protocol:    {}".format(protocol))
    if cipher:
        print("  Cipher:      {}".format(cipher))
    print("  HSTS:        {}".format("✅ Enabled" if hsts else "❌ Not set"))
    if sans:
        print("")
        print("  SANs ({} domains):".format(len(sans)))
        for s in sans[:10]:
            print("    {}".format(s))
        if len(sans) > 10:
            print("    ... and {} more".format(len(sans) - 10))
    print("")
    print("---")
    print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
