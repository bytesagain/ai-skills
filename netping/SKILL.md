---
name: NetPing
description: "Network connectivity checker and diagnostics. Ping hosts, check port availability, test DNS resolution, measure latency, and verify internet connectivity. Quick network troubleshooting from your terminal without remembering complex command syntax."
version: "2.0.0"
author: "BytesAgain"
tags: ["network","ping","connectivity","dns","port","latency","diagnostic","devops"]
categories: ["System Tools", "Developer Tools", "Utility"]
---
# NetPing
Check network connectivity fast. Ping, port check, DNS lookup in one tool.
## Commands
- `ping <host>` — Ping a host (3 packets)
- `port <host> <port>` — Check if a port is open
- `dns <domain>` — DNS lookup
- `internet` — Quick internet connectivity check
- `latency <host>` — Measure latency
## Usage Examples
```bash
netping ping google.com
netping port example.com 443
netping dns github.com
netping internet
```
---
Powered by BytesAgain | bytesagain.com

- Run `netping help` for all commands

## When to Use

- as part of a larger automation pipeline
- when you need quick netping from the command line

## Output

Returns structured data to stdout. Redirect to a file with `netping run > output.txt`.

## Configuration

Set `NETPING_DIR` environment variable to change the data directory. Default: `~/.local/share/netping/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
