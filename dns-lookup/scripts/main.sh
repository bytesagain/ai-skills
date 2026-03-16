#!/usr/bin/env bash
# DNS Lookup — Query DNS records for any domain
# Usage: bash main.sh --domain <domain> [--type <record-type>] [--server <dns-server>]
set -euo pipefail

DOMAIN="" RECORD_TYPE="ALL" DNS_SERVER="" OUTPUT="" FORMAT="text"

show_help() { cat << 'HELPEOF'
DNS Lookup — Query DNS records for any domain

Usage: bash main.sh --domain <domain> [options]

Options:
  --domain <domain>    Domain to lookup (required)
  --type <type>        Record type: A, AAAA, MX, NS, TXT, CNAME, SOA, SRV, ALL
  --server <server>    DNS server (default: system resolver)
  --format <fmt>       Output: text, json (default: text)
  --output <file>      Save to file
  --help               Show this help

Examples:
  bash main.sh --domain example.com
  bash main.sh --domain example.com --type MX
  bash main.sh --domain example.com --type TXT --server 8.8.8.8
  bash main.sh --domain example.com --format json

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELPEOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --domain) DOMAIN="$2"; shift 2;; --type) RECORD_TYPE="$2"; shift 2;;
        --server) DNS_SERVER="$2"; shift 2;; --format) FORMAT="$2"; shift 2;;
        --output) OUTPUT="$2"; shift 2;; --help|-h) show_help; exit 0;; *) shift;;
    esac
done

[ -z "$DOMAIN" ] && { echo "Error: --domain required"; show_help; exit 1; }

lookup_records() {
    python3 << PYEOF
import subprocess, json, re, sys, socket

domain = "$DOMAIN"
record_type = "$RECORD_TYPE".upper()
dns_server = "$DNS_SERVER"
fmt = "$FORMAT"

types_to_check = ["A", "AAAA", "MX", "NS", "TXT", "CNAME", "SOA"] if record_type == "ALL" else [record_type]
results = {}

def run_dig(domain, rtype, server=""):
    cmd = ["dig", "+short", "+time=5", "+tries=2", domain, rtype]
    if server:
        cmd.insert(1, "@{}".format(server))
    try:
        out = subprocess.check_output(cmd, stderr=subprocess.PIPE, timeout=10).decode().strip()
        return [line.strip() for line in out.split("\n") if line.strip()] if out else []
    except FileNotFoundError:
        return run_host(domain, rtype)
    except:
        return []

def run_host(domain, rtype):
    try:
        if rtype == "A":
            addrs = socket.getaddrinfo(domain, None, socket.AF_INET)
            return list(set(a[4][0] for a in addrs))
        elif rtype == "AAAA":
            addrs = socket.getaddrinfo(domain, None, socket.AF_INET6)
            return list(set(a[4][0] for a in addrs))
        elif rtype == "MX":
            cmd = ["host", "-t", "MX", domain]
            out = subprocess.check_output(cmd, stderr=subprocess.PIPE, timeout=10).decode()
            return [line.split("mail is handled by ")[-1].strip() for line in out.split("\n") if "mail is handled by" in line]
        elif rtype == "NS":
            cmd = ["host", "-t", "NS", domain]
            out = subprocess.check_output(cmd, stderr=subprocess.PIPE, timeout=10).decode()
            return [line.split("name server ")[-1].strip() for line in out.split("\n") if "name server" in line]
        elif rtype == "TXT":
            cmd = ["host", "-t", "TXT", domain]
            out = subprocess.check_output(cmd, stderr=subprocess.PIPE, timeout=10).decode()
            return [line.split("descriptive text ")[-1].strip() for line in out.split("\n") if "descriptive text" in line]
        else:
            cmd = ["host", "-t", rtype, domain]
            out = subprocess.check_output(cmd, stderr=subprocess.PIPE, timeout=10).decode()
            return [line.strip() for line in out.split("\n") if line.strip() and "not found" not in line]
    except:
        return []

for rtype in types_to_check:
    records = run_dig(domain, rtype, dns_server)
    if records:
        results[rtype] = records

if fmt == "json":
    print(json.dumps({"domain": domain, "server": dns_server or "default", "records": results}, indent=2))
else:
    print("=" * 50)
    print("  DNS Lookup: {}".format(domain))
    if dns_server:
        print("  Server: {}".format(dns_server))
    print("=" * 50)
    
    if not results:
        print("\n  No records found")
    else:
        for rtype in types_to_check:
            records = results.get(rtype, [])
            if records:
                print("\n  {} Records:".format(rtype))
                for r in records:
                    print("    {}".format(r))
    
    print("\n---")
    print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
}

if [ -n "$OUTPUT" ]; then
    lookup_records > "$OUTPUT"
    echo "Saved to $OUTPUT"
else
    lookup_records
fi
