---
version: "1.0.0"
name: Lux
description: "👾 Fast and simple video download library and CLI tool written in Go video-fetcher, go, bilibili, crawler, download, downloader."
---

# Video Fetcher

A terminal-first utility toolkit for video fetching and management. Run, check, convert, analyze, generate, preview, batch process, compare, export, configure, monitor status, and generate reports — all with persistent logging, search, and export capabilities.

## Why Video Fetcher?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Persistent timestamped logging for every action
- Export to JSON, CSV, or plain text anytime
- Built-in search across all logged entries
- Automatic history and activity tracking

## Commands

| Command | Description |
|---------|-------------|
| `video-fetcher run <input>` | Run a video fetch operation. Without args, shows recent run entries |
| `video-fetcher check <input>` | Check video availability or status. Without args, shows recent entries |
| `video-fetcher convert <input>` | Convert video formats or metadata. Without args, shows recent entries |
| `video-fetcher analyze <input>` | Analyze video data, quality, or streams. Without args, shows recent entries |
| `video-fetcher generate <input>` | Generate configs, playlists, or reports. Without args, shows recent entries |
| `video-fetcher preview <input>` | Preview a video operation before executing. Without args, shows recent entries |
| `video-fetcher batch <input>` | Batch process multiple video operations. Without args, shows recent entries |
| `video-fetcher compare <input>` | Compare video sources, formats, or quality. Without args, shows recent entries |
| `video-fetcher export <input>` | Export video data or metadata. Without args, shows recent entries |
| `video-fetcher config <input>` | Manage configuration settings. Without args, shows recent entries |
| `video-fetcher status <input>` | Log or review fetch status. Without args, shows recent entries |
| `video-fetcher report <input>` | Generate or review fetch reports. Without args, shows recent entries |
| `video-fetcher stats` | Show summary statistics across all command categories |
| `video-fetcher export <fmt>` | Export all data (formats: json, csv, txt) |
| `video-fetcher search <term>` | Search across all logged entries |
| `video-fetcher recent` | Show the 20 most recent activity entries |
| `video-fetcher status` | Health check — version, data dir, entry count, disk usage |
| `video-fetcher help` | Show help with all available commands |
| `video-fetcher version` | Show version (v2.0.0) |

Each action command (run, check, convert, etc.) works in two modes:
- **With arguments:** Logs the input with a timestamp and saves it to the corresponding log file
- **Without arguments:** Displays the 20 most recent entries from that category

## Data Storage

All data is stored locally at `~/.local/share/video-fetcher/`. Each command category maintains its own `.log` file with timestamped entries in `timestamp|value` format. A unified `history.log` tracks all activity across commands. Use `export` to back up your data in JSON, CSV, or plain text format at any time.

## Requirements

- Bash 4.0+ with `set -euo pipefail` support
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies or API keys required

## When to Use

1. **Tracking video download operations** — Log fetch runs, status checks, and format conversions with persistent timestamped history
2. **Batch downloading videos** — Use the batch command to log and manage multiple video fetch operations in sequence
3. **Analyzing video quality and streams** — Run analyze and compare commands to track patterns across video sources and formats
4. **Converting and exporting video metadata** — Use convert and export commands to manage format transformations and data output
5. **Monitoring fetch health and generating reports** — Use stats, report, status, and export to produce activity summaries in JSON, CSV, or text

## Examples

```bash
# Run a video fetch operation
video-fetcher run "https://example.com/video.mp4"

# Check video availability
video-fetcher check "https://bilibili.com/video/BV1234"

# Batch process multiple downloads
video-fetcher batch "playlist-001 playlist-002 playlist-003"

# Analyze video stream quality
video-fetcher analyze "1080p vs 4K comparison"

# Export all logged data as JSON
video-fetcher export json

# Search for entries about a specific source
video-fetcher search bilibili

# View summary statistics
video-fetcher stats
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
