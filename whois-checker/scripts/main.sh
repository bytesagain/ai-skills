#!/usr/bin/env bash
# WHOIS Checker — Domain registration lookup
# Usage: bash main.sh --domain <domain> [--format text|json] [--output <file>]
set -euo pipefail

DOMAIN="" FORMAT="text" OUTPUT=""

show_help() { cat << 'HELPEOF'
WHOIS Checker — Domain registration and ownership lookup

Usage: bash main.sh --domain <domain> [options]

Options:
  --domain <domain>    Domain to check (required)
  --format <fmt>       Output: text, json (default: text)
  --output <file>      Save to file
  --help               Show this help

Checks: registrar, registration date, expiry date, nameservers, status,
        DNSSEC, registrant info (if available), days until expiry

Examples:
  bash main.sh --domain example.com
  bash main.sh --domain google.com --format json
  bash main.sh --domain bytesagain.com --output whois-report.txt

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELPEOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --domain) DOMAIN="$2"; shift 2;; --format) FORMAT="$2"; shift 2;;
        --output) OUTPUT="$2"; shift 2;; --help|-h) show_help; exit 0;; *) shift;;
    esac
done

[ -z "$DOMAIN" ] && { echo "Error: --domain required"; show_help; exit 1; }

# Run whois and parse
WHOIS_DATA=$(whois "$DOMAIN" 2>/dev/null || echo "WHOIS lookup failed")

python3 << PYEOF
import re, sys, json
from datetime import datetime

domain = "$DOMAIN"
fmt = "$FORMAT"
raw = '''$WHOIS_DATA'''

# If whois failed, try python socket
if "WHOIS lookup failed" in raw or not raw.strip():
    try:
        import socket
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(10)
        tld = domain.split(".")[-1]
        whois_server = {"com":"whois.verisign-grs.com","net":"whois.verisign-grs.com",
                        "org":"whois.pir.org","io":"whois.nic.io","dev":"whois.nic.google",
                        "ai":"whois.nic.ai"}.get(tld, "whois.iana.org")
        s.connect((whois_server, 43))
        s.send((domain + "\r\n").encode())
        raw = b""
        while True:
            chunk = s.recv(4096)
            if not chunk: break
            raw += chunk
        raw = raw.decode("utf-8", errors="ignore")
        s.close()
    except:
        raw = "Unable to perform WHOIS lookup"

def extract(patterns, text):
    for p in patterns:
        m = re.search(p, text, re.I | re.M)
        if m: return m.group(1).strip()
    return ""

registrar = extract([r"Registrar:\s*(.+)", r"registrar:\s*(.+)", r"Sponsoring Registrar:\s*(.+)"], raw)
created = extract([r"Creation Date:\s*(.+)", r"created:\s*(.+)", r"Registration Date:\s*(.+)", r"Created on:\s*(.+)"], raw)
expires = extract([r"Expir.*Date:\s*(.+)", r"expiry.*:\s*(.+)", r"Expiration Date:\s*(.+)", r"paid-till:\s*(.+)"], raw)
updated = extract([r"Updated Date:\s*(.+)", r"last-modified:\s*(.+)", r"Last Modified:\s*(.+)"], raw)
status_lines = re.findall(r"(?:Domain )?Status:\s*(.+)", raw, re.I | re.M)
nameservers = re.findall(r"Name Server:\s*(.+)", raw, re.I | re.M)
if not nameservers:
    nameservers = re.findall(r"nserver:\s*(.+)", raw, re.I | re.M)
dnssec = extract([r"DNSSEC:\s*(.+)", r"dnssec:\s*(.+)"], raw)
registrant = extract([r"Registrant Organization:\s*(.+)", r"Registrant:\s*(.+)", r"org:\s*(.+)"], raw)

# Days until expiry
days_left = None
if expires:
    for date_fmt in ["%Y-%m-%dT%H:%M:%SZ", "%Y-%m-%d", "%d-%b-%Y", "%Y-%m-%dT%H:%M:%S%z"]:
        try:
            exp_date = datetime.strptime(expires[:19], date_fmt[:len(expires)])
            days_left = (exp_date - datetime.now()).days
            break
        except:
            continue

data = {
    "domain": domain,
    "registrar": registrar,
    "created": created,
    "expires": expires,
    "updated": updated,
    "days_until_expiry": days_left,
    "status": [s.strip() for s in status_lines[:5]],
    "nameservers": [ns.strip().lower() for ns in nameservers[:6]],
    "dnssec": dnssec,
    "registrant": registrant
}

if fmt == "json":
    print(json.dumps(data, indent=2))
else:
    print("=" * 50)
    print("  WHOIS Report: {}".format(domain))
    print("=" * 50)
    print("")
    if registrar: print("  Registrar:    {}".format(registrar))
    if registrant: print("  Registrant:   {}".format(registrant))
    if created: print("  Created:      {}".format(created))
    if expires:
        expiry_warning = ""
        if days_left is not None:
            if days_left < 0: expiry_warning = " ❌ EXPIRED"
            elif days_left < 30: expiry_warning = " ⚠️ EXPIRING SOON"
            elif days_left < 90: expiry_warning = " ⚠️ {} days left".format(days_left)
            else: expiry_warning = " ✅ {} days left".format(days_left)
        print("  Expires:      {}{}".format(expires, expiry_warning))
    if updated: print("  Updated:      {}".format(updated))
    if dnssec: print("  DNSSEC:       {}".format(dnssec))
    if status_lines:
        print("")
        print("  Status:")
        for s in status_lines[:5]:
            print("    {}".format(s.strip()))
    if nameservers:
        print("")
        print("  Nameservers:")
        for ns in nameservers[:6]:
            print("    {}".format(ns.strip().lower()))
    print("")
    print("---")
    print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
