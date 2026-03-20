---
name: ChartMaker
description: "Visualize data with bar charts, sparklines, and progress bars in terminal. Use when plotting metrics, rendering inline charts, or transforming data."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["chart","graph","visualization","bar","sparkline","data","terminal","ascii"]
categories: ["Developer Tools", "Utility", "Data"]
---

# ChartMaker

A data toolkit for chart-related data logging and export. Record, transform, query, and export data entries — all from the command line, all stored locally.

## Commands

| Command | What it does |
|---------|-------------|
| `chartmaker ingest <input>` | Log a new ingest entry (no args = show recent entries) |
| `chartmaker transform <input>` | Log a transform entry |
| `chartmaker query <input>` | Log a query entry |
| `chartmaker filter <input>` | Log a filter entry |
| `chartmaker aggregate <input>` | Log an aggregate entry |
| `chartmaker visualize <input>` | Log a visualize entry |
| `chartmaker export <input>` | Log an export entry (see also export with format below) |
| `chartmaker sample <input>` | Log a sample entry |
| `chartmaker schema <input>` | Log a schema entry |
| `chartmaker validate <input>` | Log a validate entry |
| `chartmaker pipeline <input>` | Log a pipeline entry |
| `chartmaker profile <input>` | Log a profile entry |
| `chartmaker stats` | Show summary statistics across all log files |
| `chartmaker export <fmt>` | Export all data to json, csv, or txt format |
| `chartmaker search <term>` | Search all entries for a term (case-insensitive) |
| `chartmaker recent` | Show the 20 most recent activity log entries |
| `chartmaker status` | Health check — version, entry count, disk usage |
| `chartmaker help` | Show usage and available commands |
| `chartmaker version` | Print version string |

Each logging command (ingest, transform, query, etc.) accepts free-form text. Called without arguments, it shows the 20 most recent entries for that category.

## Data Storage

All data is stored locally in `~/.local/share/chartmaker/`. Each command category writes to its own `.log` file, and all actions are recorded in `history.log` with timestamps.

## Requirements

- Bash 4+

## When to Use

- Logging chart and visualization data points from the command line
- Tracking data transformations and schema changes over time
- Exporting accumulated entries to JSON, CSV, or plain text for reports
- Searching across all logged entries to find specific visualization data
- Checking health and statistics of your local chart data store

## Examples

```bash
# Log visualization data
chartmaker ingest "Monthly revenue: Jan=10k Feb=12k Mar=15k"

# Transform and record a data step
chartmaker transform "Normalized Q1 values to percentage scale"

# Search across all logs
chartmaker search "revenue"

# Export everything to CSV
chartmaker export csv

# View recent activity
chartmaker recent
```

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
