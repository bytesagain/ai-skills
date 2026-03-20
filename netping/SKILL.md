---
name: NetPing
description: "Check connectivity with ping, port scan, and DNS lookup in one fast tool. Use when testing reachability, scanning ports, resolving DNS records quickly."
version: "3.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["network","ping","connectivity","dns","port","latency","diagnostic","devops"]
categories: ["System Tools", "Developer Tools", "Utility"]
---

# NetPing

Network diagnostic tool: ping hosts, scan ports, traceroute, DNS lookup, latency measurement, and HTTP checks — all in one script.

## Commands

| Command | Description |
|---------|-------------|
| `netping ping <host> [count]` | Ping a host (default: 4 packets) |
| `netping ports <host> <port1,port2,...>` | Check if TCP ports are open |
| `netping trace <host>` | Traceroute to host |
| `netping dns <domain>` | DNS lookup (A, AAAA, MX, NS, TXT records) |
| `netping latency <host>` | Measure average latency (5 pings with stats) |
| `netping http <url>` | Check HTTP status and response timing |
| `netping sweep <subnet>` | Quick ping sweep of a /24 subnet |
| `netping version` | Show version |

## Examples

```bash
netping ping google.com         # → ping with 4 packets
netping ping 8.8.8.8 10         # → ping with 10 packets
netping ports example.com 80,443,8080  # → check 3 ports
netping trace cloudflare.com    # → traceroute
netping dns github.com          # → A, AAAA, MX, NS, TXT records
netping latency 1.1.1.1         # → avg latency over 5 pings
netping http https://example.com # → HTTP status + TTFB
netping sweep 192.168.1.0/24    # → find alive hosts
```

## Requirements

- `ping` (standard)
- `dig` or `nslookup` (for DNS lookups)
- `traceroute` or `tracepath` (for trace, optional — falls back to ping TTL)
- `curl` (for HTTP checks)
- Bash `/dev/tcp` (for port scanning — built into bash)
