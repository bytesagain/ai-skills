---
name: LogRotate
description: "Log file rotation and management tool. Rotate log files by size or age, compress old logs, clean up expired log files, monitor log directory sizes, and configure retention policies. Keep your log directories clean and manageable without complex logrotate configs."
version: "2.0.0"
author: "BytesAgain"
tags: ["log","rotate","cleanup","archive","compress","admin","sysadmin","devops"]
categories: ["System Tools", "Developer Tools"]
---
# LogRotate
Rotate logs. Compress old files. Keep your log dirs clean.
## Commands
- `rotate <file> [max_count]` — Rotate a log file (file → file.1 → file.2...)
- `clean <dir> [days]` — Remove log files older than N days
- `compress <dir>` — Gzip uncompressed log files
- `status <dir>` — Show log directory status and sizes
- `monitor <dir> [max_mb]` — Alert if dir exceeds size limit
## Usage Examples
```bash
logrotate rotate /var/log/app.log 5
logrotate clean /var/log 30
logrotate compress /var/log
logrotate status /var/log
```
---
Powered by BytesAgain | bytesagain.com

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
