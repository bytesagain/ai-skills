---
name: "Website Change Monitor & Alert System"
description: "Use when monitoring websites for content changes, comparing page snapshots with diff, scheduling periodic checks, or sending alerts via email and webhook notifications."
version: "2.0.1"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["website", "monitor", "change-detection", "alert", "diff", "notification", "scraping"]
---

# Website Change Monitor & Alert System

Monitor web pages for content changes. Take snapshots, diff comparisons, schedule periodic checks, and send alerts via email or webhook when changes are detected.

## Commands

### watch
Add a URL to the watch list.
```bash
bash scripts/script.sh watch "https://example.com/pricing"
bash scripts/script.sh watch "https://example.com/status" --selector ".status-text"
```

### check
Check a URL for changes right now.
```bash
bash scripts/script.sh check "https://example.com/pricing"
bash scripts/script.sh check --all
```

### diff
Show diff between last two snapshots of a URL.
```bash
bash scripts/script.sh diff "https://example.com/pricing"
```

### schedule
Set up periodic checking (cron-based).
```bash
bash scripts/script.sh schedule "https://example.com" 30
```

### notify
Configure notification channels (email, webhook, stdout).
```bash
bash scripts/script.sh notify webhook "https://hooks.slack.com/..."
bash scripts/script.sh notify email "admin@example.com"
```

### help
Show all commands.
```bash
bash scripts/script.sh help
```

## Output
- Change detection results with diff
- Snapshot history
- Notification delivery confirmation

## Feedback
https://bytesagain.com/feedback/
Powered by BytesAgain | bytesagain.com
