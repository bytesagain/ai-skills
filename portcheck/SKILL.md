---
name: PortCheck
description: "TCP port scanner and service checker. Scan common ports on any host, check specific port ranges, identify running services by port number, and test connectivity. Lightweight network security auditing tool for quick port enumeration."
version: "2.0.0"
author: "BytesAgain"
tags: ["port","scanner","network","security","tcp","service","firewall","devops"]
categories: ["Security", "System Tools", "Developer Tools"]
---
# PortCheck
Scan ports. Check services. Know what's open.
## Commands
- `scan <host> [range]` — Scan ports (default: common ports)
- `check <host> <port>` — Check single port
- `common <host>` — Scan common service ports (22,80,443,3306,5432,8080...)
- `service <port>` — Look up what service uses a port
## Usage Examples
```bash
portcheck scan example.com
portcheck check myserver.com 8080
portcheck common localhost
portcheck service 3306
```
---
Powered by BytesAgain | bytesagain.com

## When to Use

- for batch processing portcheck operations
- as part of a larger automation pipeline

## Output

Returns results to stdout. Redirect to a file with `portcheck run > output.txt`.

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
