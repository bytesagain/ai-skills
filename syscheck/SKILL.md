---
name: SysCheck
description: "System health checker and diagnostics tool. Quick overview of CPU usage, memory, disk space, uptime, load average, and running processes. Monitor system resources, check service status, and get instant system health reports. Essential sysadmin toolkit."
version: "2.0.0"
author: "BytesAgain"
tags: ["system","monitor","health","cpu","memory","disk","admin","devops","linux"]
categories: ["System Tools", "Developer Tools", "Utility"]
---
# SysCheck
Quick system health at a glance. Know your machine's status in one command.
## Commands
- `overview` — Full system health summary
- `cpu` — CPU usage and load average
- `memory` — Memory and swap usage
- `disk` — Disk space usage
- `processes` — Top processes by CPU/memory
- `uptime` — System uptime info
## Usage Examples
```bash
syscheck overview
syscheck cpu
syscheck disk
```
---
Powered by BytesAgain | bytesagain.com

## When to Use

- when you need quick syscheck from the command line
- to automate syscheck tasks in your workflow

## Output

Returns logs to stdout. Redirect to a file with `syscheck run > output.txt`.

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
