---
version: "1.0.0"
name: Business Plan Generator
description: "Create business plans, lean canvases, and financial projections. Use when pitching investors, planning startups, or modeling revenue scenarios."
---

# Business Plan Generator

A data toolkit for business planning. Log, transform, query, and export business data — all from the command line, all stored locally.

## Commands

| Command | What it does |
|---------|-------------|
| `bizplanner ingest <input>` | Log a new ingest entry (no args = show recent entries) |
| `bizplanner transform <input>` | Log a transform entry |
| `bizplanner query <input>` | Log a query entry |
| `bizplanner filter <input>` | Log a filter entry |
| `bizplanner aggregate <input>` | Log an aggregate entry |
| `bizplanner visualize <input>` | Log a visualize entry |
| `bizplanner export <input>` | Log an export entry (see also export with format below) |
| `bizplanner sample <input>` | Log a sample entry |
| `bizplanner schema <input>` | Log a schema entry |
| `bizplanner validate <input>` | Log a validate entry |
| `bizplanner pipeline <input>` | Log a pipeline entry |
| `bizplanner profile <input>` | Log a profile entry |
| `bizplanner stats` | Show summary statistics across all log files |
| `bizplanner export <fmt>` | Export all data to json, csv, or txt format |
| `bizplanner search <term>` | Search all entries for a term (case-insensitive) |
| `bizplanner recent` | Show the 20 most recent activity log entries |
| `bizplanner status` | Health check — version, entry count, disk usage |
| `bizplanner help` | Show usage and available commands |
| `bizplanner version` | Print version string |

Each logging command (ingest, transform, query, etc.) accepts free-form text. Called without arguments, it shows the 20 most recent entries for that category.

## Data Storage

All data is stored locally in `~/.local/share/bizplanner/`. Each command category writes to its own `.log` file, and all actions are recorded in `history.log` with timestamps.

## Requirements

- Bash 4+

## When to Use

- Logging business planning data points from the command line
- Tracking data transformations and queries over time
- Exporting accumulated entries to JSON, CSV, or plain text for reports
- Searching across all logged entries to find specific data
- Checking health and statistics of your local business data store

## Examples

```bash
# Log a new data point
bizplanner ingest "Q1 revenue: $450k from SaaS subscriptions"

# Search all logs for a keyword
bizplanner search "revenue"

# Export everything to CSV
bizplanner export csv

# Check how much data you have
bizplanner stats

# View recent activity
bizplanner recent
```

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
