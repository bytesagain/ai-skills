---
name: WeatherNow
description: "Fetch current weather and forecasts for any city. Use when checking temperature, planning outdoor activities, comparing forecasts, or packing for trips."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["weather","forecast","temperature","climate","wttr","location","utility"]
categories: ["Utility", "Productivity"]
---

# WeatherNow

A terminal-first travel toolkit for planning trips, checking weather, managing budgets, building packing lists, tracking routes, journaling, and more — all with persistent logging, search, and export capabilities.

## Why WeatherNow?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface, no GUI needed
- Persistent timestamped logging for every action
- Export to JSON, CSV, or plain text anytime
- Built-in search across all logged entries
- Automatic history and activity tracking

## Commands

| Command | Description |
|---------|-------------|
| `weathernow plan <input>` | Plan a trip or activity. Without args, shows recent plan entries |
| `weathernow search <input>` | Search for destinations, activities, or info. Without args, shows recent entries |
| `weathernow book <input>` | Log a booking (flights, hotels, etc.). Without args, shows recent entries |
| `weathernow pack-list <input>` | Manage packing lists for trips. Without args, shows recent entries |
| `weathernow budget <input>` | Track travel budgets and expenses. Without args, shows recent entries |
| `weathernow convert <input>` | Convert currencies, units, or timezones. Without args, shows recent entries |
| `weathernow weather <input>` | Log or check weather conditions. Without args, shows recent entries |
| `weathernow route <input>` | Plan or log travel routes. Without args, shows recent entries |
| `weathernow checklist <input>` | Manage pre-trip checklists. Without args, shows recent entries |
| `weathernow journal <input>` | Write travel journal entries. Without args, shows recent entries |
| `weathernow compare <input>` | Compare destinations, prices, or options. Without args, shows recent entries |
| `weathernow remind <input>` | Set travel reminders. Without args, shows recent entries |
| `weathernow stats` | Show summary statistics across all command categories |
| `weathernow export <fmt>` | Export all data (formats: json, csv, txt) |
| `weathernow search <term>` | Search across all logged entries |
| `weathernow recent` | Show the 20 most recent activity entries |
| `weathernow status` | Health check — version, data dir, entry count, disk usage |
| `weathernow help` | Show help with all available commands |
| `weathernow version` | Show version (v2.0.0) |

Each action command (plan, search, book, etc.) works in two modes:
- **With arguments:** Logs the input with a timestamp and saves it to the corresponding log file
- **Without arguments:** Displays the 20 most recent entries from that category

## Data Storage

All data is stored locally at `~/.local/share/weathernow/`. Each command category maintains its own `.log` file with timestamped entries in `timestamp|value` format. A unified `history.log` tracks all activity across commands. Use `export` to back up your data in JSON, CSV, or plain text format at any time.

## Requirements

- Bash 4.0+ with `set -euo pipefail` support
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies or API keys required

## When to Use

1. **Planning a trip from scratch** — Use plan, route, and checklist commands to organize your travel from itinerary to pre-departure tasks
2. **Tracking travel expenses** — Log bookings and budgets to keep a persistent record of travel costs and compare options
3. **Building packing lists** — Use pack-list to create and manage what you need for each trip, with history of past lists
4. **Checking weather at destinations** — Log weather conditions for travel destinations and compare forecasts across locations
5. **Keeping a travel journal** — Use journal to write timestamped entries during your trip and export them later as a keepsake

## Examples

```bash
# Plan a weekend trip
weathernow plan "Weekend trip to Shanghai, March 22-24"

# Log a hotel booking
weathernow book "Hilton Garden Inn, Shanghai, $120/night"

# Check weather conditions
weathernow weather "Tokyo: 15°C, partly cloudy, 60% humidity"

# Add items to packing list
weathernow pack-list "passport, charger, umbrella, sunscreen"

# Track travel budget
weathernow budget "Flight: $450, Hotel: $360, Food: $200"

# Export all logged data as JSON
weathernow export json

# Search for entries about Tokyo
weathernow search Tokyo

# View summary statistics
weathernow stats
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
