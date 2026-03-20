---
version: "1.0.0"
name: Ua Parser Js
description: "UAParser.js - The Essential Web Development Tool for User-Agent Detection. Detect Browsers, OS, Devi ua parser js, javascript, analytics, bot-detection."
---

# Useragent Parser

An AI-oriented toolkit for user-agent string analysis. Configure parsing rules, benchmark performance, compare results, manage prompts, evaluate accuracy, fine-tune models, analyze patterns, track costs, monitor usage, optimize workflows, run tests, and generate reports — all with persistent logging and history.

## Why Useragent Parser?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Persistent timestamped logging for every action
- Export to JSON, CSV, or plain text anytime
- Built-in search across all logged entries
- Automatic history and activity tracking

## Commands

| Command | Description |
|---------|-------------|
| `useragent-parser configure <input>` | Configure parsing rules or settings. Without args, shows recent entries |
| `useragent-parser benchmark <input>` | Benchmark parsing performance. Without args, shows recent entries |
| `useragent-parser compare <input>` | Compare parsing results across engines. Without args, shows recent entries |
| `useragent-parser prompt <input>` | Manage AI prompts for user-agent analysis. Without args, shows recent entries |
| `useragent-parser evaluate <input>` | Evaluate parsing accuracy or model output. Without args, shows recent entries |
| `useragent-parser fine-tune <input>` | Fine-tune parsing models or rulesets. Without args, shows recent entries |
| `useragent-parser analyze <input>` | Analyze user-agent string patterns. Without args, shows recent entries |
| `useragent-parser cost <input>` | Track and log cost of parsing operations. Without args, shows recent entries |
| `useragent-parser usage <input>` | Monitor usage statistics and patterns. Without args, shows recent entries |
| `useragent-parser optimize <input>` | Optimize parsing rules for speed or accuracy. Without args, shows recent entries |
| `useragent-parser test <input>` | Run tests against user-agent strings. Without args, shows recent entries |
| `useragent-parser report <input>` | Generate or review parsing reports. Without args, shows recent entries |
| `useragent-parser stats` | Show summary statistics across all command categories |
| `useragent-parser export <fmt>` | Export all data (formats: json, csv, txt) |
| `useragent-parser search <term>` | Search across all logged entries |
| `useragent-parser recent` | Show the 20 most recent activity entries |
| `useragent-parser status` | Health check — version, data dir, entry count, disk usage |
| `useragent-parser help` | Show help with all available commands |
| `useragent-parser version` | Show version (v2.0.0) |

Each action command (configure, benchmark, compare, etc.) works in two modes:
- **With arguments:** Logs the input with a timestamp and saves it to the corresponding log file
- **Without arguments:** Displays the 20 most recent entries from that category

## Data Storage

All data is stored locally at `~/.local/share/useragent-parser/`. Each command category maintains its own `.log` file with timestamped entries in `timestamp|value` format. A unified `history.log` tracks all activity across commands. Use `export` to back up your data in JSON, CSV, or plain text format at any time.

## Requirements

- Bash 4.0+ with `set -euo pipefail` support
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies or API keys required

## When to Use

1. **Benchmarking UA parsing engines** — Compare performance and accuracy of different user-agent parsing approaches with logged results
2. **Analyzing browser and device patterns** — Use analyze and compare to track user-agent string patterns across datasets
3. **Fine-tuning detection models** — Log fine-tune and evaluate sessions to track improvements in bot detection and device fingerprinting
4. **Tracking API usage and costs** — Use cost and usage commands to monitor parsing operation expenses over time
5. **Generating compliance and analytics reports** — Export parsed data in JSON, CSV, or text format for downstream analytics pipelines

## Examples

```bash
# Analyze a user-agent string
useragent-parser analyze "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"

# Benchmark parsing speed
useragent-parser benchmark "10000 UA strings batch test"

# Compare two parsing engines
useragent-parser compare "uap-core vs woothee"

# Test against known bot signatures
useragent-parser test "Googlebot/2.1 (+http://www.google.com/bot.html)"

# Export all logged data as JSON
useragent-parser export json

# Search for Chrome-related entries
useragent-parser search Chrome

# View summary statistics
useragent-parser stats
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
