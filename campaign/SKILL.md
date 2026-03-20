---
name: campaign
version: "2.0.0"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
license: MIT-0
tags: [campaign, tool, utility]
description: "Plan marketing campaigns with A/B testing, budgets, and ROI tracking. Use when launching ad campaigns, optimizing creatives, or scheduling content."
---

# Campaign

Campaign manager — plan campaigns, track performance, A/B testing, budget allocation, timeline management, and ROI reporting.

## Commands

| Command | Description |
|---------|-------------|
| `campaign run` | Execute main function |
| `campaign list` | List all items |
| `campaign add <item>` | Add new item |
| `campaign status` | Show current status |
| `campaign export <format>` | Export data |
| `campaign help` | Show help |

## Usage

```bash
# Show help
campaign help

# Quick start
campaign run
```

## Examples

```bash
# Run with defaults
campaign run

# Check status
campaign status

# Export results
campaign export json
```

- Run `campaign help` for all commands
- Data stored in `~/.local/share/campaign/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*


## When to Use

- Quick campaign tasks from terminal
- Automation pipelines
