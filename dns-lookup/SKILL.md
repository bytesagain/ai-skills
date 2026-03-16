---
version: "2.0.0"
name: dns-lookup
description: "Error: --domain required. Use when you need dns lookup capabilities. Triggers on: dns lookup, domain, type, server, format, output."
---

# dns-lookup

DNS record lookup tool supporting A, AAAA, MX, NS, TXT, CNAME, SOA, and PTR record types. Provides multiple output formats (table, JSON, CSV, zone-file style) for easy integration into scripts and reports. Supports custom DNS servers, reverse lookups, batch queries, and record comparison. Uses Python3 socket module and system dig/nslookup as fallback — no external Python dependencies required.


## Commands

| Command | Description |
|---------|-------------|
| `lookup <domain>` | Look up all common DNS records for a domain |
| `a <domain>` | Query A records (IPv4) |
| `aaaa <domain>` | Query AAAA records (IPv6) |
| `mx <domain>` | Query MX records (mail servers) |
| `ns <domain>` | Query NS records (nameservers) |
| `txt <domain>` | Query TXT records (SPF, DKIM, etc.) |
| `cname <domain>` | Query CNAME records |
| `soa <domain>` | Query SOA record |
| `ptr <ip>` | Reverse DNS lookup |
| `batch <file>` | Look up records for multiple domains from a file |
| `compare <domain1> <domain2>` | Compare DNS records between two domains |

## Options

- `--format table|json|csv|zone` — Output format (default: table)
- `--server <dns-ip>` — Use custom DNS server (default: system resolver)
- `--type <record-type>` — Record type filter for lookup command
- `--timeout <seconds>` — Query timeout (default: 5)
- `--output <file>` — Save output to file
- `--verbose` — Show query metadata (TTL, query time)
- `--short` — Show only record values, no headers

## Examples

```bash
# Look up all records for a domain
bash scripts/main.sh lookup example.com

# Query MX records in JSON format
bash scripts/main.sh mx example.com --format json

# Reverse DNS lookup
bash scripts/main.sh ptr 8.8.8.8

# Use Google DNS server
bash scripts/main.sh lookup example.com --server 8.8.8.8

# Batch lookup from file
bash scripts/main.sh batch domains.txt --format csv --output results.csv

# Compare DNS records
bash scripts/main.sh compare example.com example.org
```

## Output Formats

### Table (default)
```
DOMAIN          TYPE    VALUE                   TTL
example.com     A       93.184.216.34           3600
example.com     MX      10 mail.example.com     3600
```

### JSON
```json
{"domain": "example.com", "records": [{"type": "A", "value": "93.184.216.34", "ttl": 3600}]}
```

### Zone File
```
example.com.  3600  IN  A  93.184.216.34
```
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
