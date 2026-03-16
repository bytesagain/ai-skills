---
name: leads
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [leads, tool, utility]
description: "Leads - command-line tool for everyday use"
---

# Leads

Lead management toolkit — capture leads, score prospects, track pipeline, automate follow-ups, export contacts, and conversion analytics.

## Commands

| Command | Description |
|---------|-------------|
| `leads add` | <name> <email> |
| `leads list` | [status] |
| `leads score` | <id> |
| `leads pipeline` | Pipeline |
| `leads followup` | Followup |
| `leads export` | <format> |

## Usage

```bash
# Show help
leads help

# Quick start
leads add <name> <email>
```

## Examples

```bash
# Example 1
leads add <name> <email>

# Example 2
leads list [status]
```

- Run `leads help` for all available commands

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

## Configuration

Set `LEADS_DIR` to change data directory. Default: `~/.local/share/leads/`

## When to Use

- Quick leads tasks from terminal
- Automation pipelines

## Output

Results go to stdout. Save with `leads run > output.txt`.
