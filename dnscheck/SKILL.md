---
name: DNSCheck
description: "DNS lookup and diagnostics tool. Query DNS records (A, AAAA, MX, NS, TXT, CNAME, SOA), check domain propagation, compare nameservers, verify SPF and DKIM records, and reverse lookup IP addresses. Essential network troubleshooting utility."
version: "2.0.0"
author: "BytesAgain"
tags: ["dns","lookup","domain","nameserver","mx","txt","network","diagnostic"]
categories: ["System Tools", "Developer Tools"]
---
# DNSCheck
Query DNS records. Debug domain issues. Verify email configs.
## Commands
- `lookup <domain> [type]` — DNS lookup (A/AAAA/MX/NS/TXT/CNAME/SOA)
- `all <domain>` — Show all record types
- `mx <domain>` — Mail server records
- `ns <domain>` — Nameserver records
- `reverse <ip>` — Reverse DNS lookup
- `propagation <domain>` — Check propagation across DNS servers
## Usage Examples
```bash
dnscheck lookup google.com
dnscheck all example.com
dnscheck mx gmail.com
dnscheck reverse 8.8.8.8
```
---
Powered by BytesAgain | bytesagain.com

- Run `dnscheck help` for all commands

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
