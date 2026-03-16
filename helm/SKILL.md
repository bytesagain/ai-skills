---
name: helm
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [helm, tool, utility]
description: "Helm - command-line tool for everyday use"
---

# Helm

Helm chart toolkit — create, lint, template, package, and manage Kubernetes charts.

## Commands

| Command | Description |
|---------|-------------|
| `helm help` | Show usage info |
| `helm run` | Run main task |
| `helm status` | Check current state |
| `helm list` | List items |
| `helm add <item>` | Add new item |
| `helm export <fmt>` | Export data |

## Usage

```bash
helm help
helm run
helm status
```

## Examples

```bash
# Get started
helm help

# Run default task
helm run

# Export as JSON
helm export json
```

## Output

Results go to stdout. Save with `helm run > output.txt`.

## Configuration

Set `HELM_DIR` to change data directory. Default: `~/.local/share/helm/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*


## Features

- Simple command-line interface for quick access
- Local data storage with JSON/CSV export
- History tracking and activity logs
- Search across all entries

## Quick Start

```bash
# Check status
helm status

# View help
helm help

# Export data
helm export json
```

## How It Works

Helm stores all data locally in `~/.local/share/helm/`. Each command logs activity with timestamps for full traceability.

## Support

- Feedback: https://bytesagain.com/feedback/
- Website: https://bytesagain.com

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
