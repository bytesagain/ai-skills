---
name: "clamav"
version: "1.0.0"
description: "ClamAV open-source antivirus reference. clamscan, freshclam database updates, clamd daemon configuration, custom signatures, quarantine workflows, automated scanning, and performance tuning."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [clamav, antivirus, security, malware, linux, scanning]
category: "sysops"
---

# ClamAV

ClamAV open-source antivirus reference. Real scan commands, daemon config, signature management.

## Commands

| Command | Description |
|---------|-------------|
| `intro` | What is ClamAV, components, architecture |
| `scan` | clamscan options, recursive, infected-only output |
| `update` | freshclam, database mirrors, proxy config |
| `daemon` | clamd.conf, clamdscan, socket configuration |
| `signatures` | Custom signatures, .ndb/.ldb format |
| `quarantine` | Moving infected files, --move/--copy |
| `automation` | Cron scanning, email notifications |
| `performance` | Multithreading, exclude patterns, memory limits |
