---
name: Sitemapper
description: "Generate and analyze XML sitemaps for SEO audits. Use when creating sitemaps, planning site structure, validating format, searching indexed pages."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["sitemap","xml","seo","website","crawler","url","search-engine","webmaster"]
categories: ["Developer Tools", "Utility"]
---

# Sitemapper

Travel planning and trip management toolkit. Plan trips, search destinations, manage bookings, track budgets, and journal your travels — all from the command line.

## Commands

Run `sitemapper <command> [args]` to use.

| Command | Description |
|---------|-------------|
| `plan <input>` | Plan a trip or itinerary and log it |
| `search <input>` | Search for destinations, flights, or accommodations |
| `book <input>` | Log a booking or reservation |
| `pack-list <input>` | Create or update a packing list |
| `budget <input>` | Track travel expenses and budget |
| `convert <input>` | Convert currencies or units for travel |
| `weather <input>` | Log weather info for a destination |
| `route <input>` | Plan and save travel routes |
| `checklist <input>` | Manage pre-trip or travel checklists |
| `journal <input>` | Write travel journal entries |
| `compare <input>` | Compare destinations, prices, or options |
| `remind <input>` | Set travel reminders or notes |
| `stats` | Show summary statistics across all log files |
| `export <fmt>` | Export all data (json, csv, or txt) |
| `search <term>` | Search all entries for a keyword |
| `recent` | Show the 20 most recent history entries |
| `status` | Health check — version, data size, entry count |
| `help` | Show help message |
| `version` | Show version (v2.0.0) |

Each data command (plan, search, book, pack-list, budget, convert, weather, route, checklist, journal, compare, remind) works in two modes:
- **Without arguments** — displays the 20 most recent entries from its log
- **With arguments** — saves the input with a timestamp to its dedicated log file

## Data Storage

All data is stored in `~/.local/share/sitemapper/`:

- `plan.log`, `search.log`, `book.log`, `pack-list.log`, `budget.log`, `convert.log` — per-command log files
- `weather.log`, `route.log`, `checklist.log`, `journal.log`, `compare.log`, `remind.log` — additional command logs
- `history.log` — unified activity history across all commands
- `export.json`, `export.csv`, `export.txt` — generated export files

Set `SITEMAPPER_DIR` environment variable to override the default data directory.

## Requirements

- Bash 4+ with standard coreutils (`date`, `wc`, `du`, `tail`, `grep`, `sed`)
- No external dependencies — pure shell implementation

## When to Use

1. **Planning a trip** — organize itineraries, destinations, and travel dates step by step
2. **Tracking travel expenses** — log costs, set budgets, and compare spending across trips
3. **Managing bookings** — keep a record of flights, hotels, and reservations in one place
4. **Packing preparation** — build and maintain packing lists for different trip types
5. **Travel journaling** — write timestamped journal entries during or after trips

## Examples

```bash
# Plan a trip
sitemapper plan "Tokyo 7-day trip: Apr 10-17, budget $2000"

# Search for destinations
sitemapper search "beach destinations southeast asia under $1500"

# Log a booking
sitemapper book "Flight: LAX→NRT Apr 10, ANA NH105, $890 confirmed"

# Create a packing list
sitemapper pack-list "passport, charger, umbrella, medication, camera"

# Track budget
sitemapper budget "Day 1: hotel $120, food $45, transport $15 = $180"

# Check weather for destination
sitemapper weather "Tokyo Apr 10-17: 15-22°C, partly cloudy, light rain expected"

# Write a journal entry
sitemapper journal "Visited Senso-ji temple. Amazing architecture, great street food nearby."

# Export all data as JSON
sitemapper export json

# View recent activity
sitemapper recent

# Show statistics
sitemapper stats
```

## Output

All commands output results to stdout. Log entries are stored with timestamps in pipe-delimited format (`YYYY-MM-DD HH:MM|value`). Use `export` to convert all data to JSON, CSV, or plain text.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
