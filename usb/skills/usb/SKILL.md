---
name: "Usb"
description: "List and manage USB devices and storage from the terminal. Use when enumerating devices, formatting drives, mounting volumes, or diagnosing connections."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["tool", "terminal", "cli", "utility", "usb"]
---

# Usb

A terminal-first utility toolkit for managing USB-related tasks. Run, check, convert, analyze, and generate data with persistent logging, search, and export capabilities — all from the command line.

## Why Usb?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Persistent timestamped logging for every action
- Export to JSON, CSV, or plain text anytime
- Built-in search across all logged entries
- Automatic history and activity tracking

## Commands

| Command | Description |
|---------|-------------|
| `usb run <input>` | Run a USB operation. Without args, shows recent run entries |
| `usb check <input>` | Check USB device status or connectivity. Without args, shows recent entries |
| `usb convert <input>` | Convert data or formats. Without args, shows recent entries |
| `usb analyze <input>` | Analyze USB device data or logs. Without args, shows recent entries |
| `usb generate <input>` | Generate reports or configurations. Without args, shows recent entries |
| `usb preview <input>` | Preview an operation before executing. Without args, shows recent entries |
| `usb batch <input>` | Batch process multiple USB operations. Without args, shows recent entries |
| `usb compare <input>` | Compare devices, configs, or data. Without args, shows recent entries |
| `usb export <input>` | Export device data or logs. Without args, shows recent entries |
| `usb config <input>` | Manage configuration settings. Without args, shows recent entries |
| `usb status <input>` | Log or review device status. Without args, shows recent entries |
| `usb report <input>` | Generate or review reports. Without args, shows recent entries |
| `usb stats` | Show summary statistics across all command categories |
| `usb export <fmt>` | Export all data (formats: json, csv, txt) |
| `usb search <term>` | Search across all logged entries |
| `usb recent` | Show the 20 most recent activity entries |
| `usb status` | Health check — version, data dir, entry count, disk usage |
| `usb help` | Show help with all available commands |
| `usb version` | Show version (v2.0.0) |

Each action command (run, check, convert, etc.) works in two modes:
- **With arguments:** Logs the input with a timestamp and saves it to the corresponding log file
- **Without arguments:** Displays the 20 most recent entries from that category

## Data Storage

All data is stored locally at `~/.local/share/usb/`. Each command category maintains its own `.log` file with timestamped entries in `timestamp|value` format. A unified `history.log` tracks all activity across commands. Use `export` to back up your data in JSON, CSV, or plain text format at any time.

## Requirements

- Bash 4.0+ with `set -euo pipefail` support
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies or API keys required

## When to Use

1. **Tracking USB device operations** — Log device checks, data transfers, and format conversions with persistent timestamped history
2. **Batch processing USB tasks** — Use the batch command to log and manage multiple USB operations in sequence
3. **Analyzing device data** — Run analyze and compare commands to track patterns across USB devices and configurations
4. **Generating device reports** — Use stats, report, and export to produce summaries of USB activity in JSON, CSV, or text
5. **Auditing device configurations** — Track config changes, run status checks, and search historical entries for troubleshooting

## Examples

```bash
# Check a USB device
usb check /dev/sdb1

# Analyze device transfer speeds
usb analyze "USB 3.0 hub throughput test"

# Batch process multiple devices
usb batch "format sdb1 sdb2 sdb3"

# Export all logged data as CSV
usb export csv

# Search for entries about a specific device
usb search sdb1

# View summary statistics
usb stats

# Show recent activity
usb recent
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
