---
name: DiskMon
description: "Disk space monitor and analyzer. Check disk usage across all partitions, find largest directories and files, monitor disk usage trends, get low-space warnings, and clean up temporary files. Keep your storage under control with proactive monitoring."
version: "2.0.0"
author: "BytesAgain"
tags: ["disk","storage","monitor","space","cleanup","filesystem","admin","devops"]
categories: ["System Tools", "Utility"]
---
# DiskMon
Monitor disk space. Find space hogs. Stay ahead of storage issues.
## Commands
- `status` — Disk usage overview
- `largest [dir] [n]` — Find largest files
- `dirs [path] [n]` — Largest directories
- `clean` — Show cleanable temp files
- `warn [threshold]` — Check for low-space partitions
## Usage Examples
```bash
diskmon status
diskmon largest /home 20
diskmon dirs / 10
diskmon warn 90
```
---
Powered by BytesAgain | bytesagain.com

- Run `diskmon help` for all commands


## When to Use

- Quick diskmon tasks from terminal
- Automation pipelines

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
