---
name: Banner
description: "Create ASCII art banners and styled text for terminal displays. Use when decorating CLI output, generating headers, or adding flair to scripts."
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["ascii","art","banner","text","figlet","generator","terminal","font"]
categories: ["Utility", "Developer Tools"]
---

# Banner

A command-line design toolkit for creating, managing, and exporting color palettes, gradients, swatches, and visual design elements. All entries are timestamped and logged locally for easy retrieval, search, and export.

## Commands

| Command | Description |
|---------|-------------|
| `palette <input>` | Create or view palette entries. Without args, shows recent palette entries. With args, saves a new palette entry with timestamp. |
| `preview <input>` | Create or view preview entries. Without args, shows recent previews. With args, logs a new preview. |
| `generate <input>` | Generate design elements. Without args, shows recent generations. With args, saves a new generation entry. |
| `convert <input>` | Convert between formats. Without args, shows recent conversions. With args, logs a new conversion. |
| `harmonize <input>` | Create color harmonies. Without args, shows recent harmonize entries. With args, saves a new harmony. |
| `contrast <input>` | Check or log contrast values. Without args, shows recent contrast entries. With args, saves a new contrast entry. |
| `export <input>` | Export design data. Without args, shows recent export entries. With args, logs a new export operation. |
| `random <input>` | Generate random design elements. Without args, shows recent random entries. With args, saves a new random entry. |
| `browse <input>` | Browse existing designs. Without args, shows recent browse entries. With args, logs a new browse action. |
| `mix <input>` | Mix colors or design elements. Without args, shows recent mixes. With args, saves a new mix entry. |
| `gradient <input>` | Create or view gradients. Without args, shows recent gradient entries. With args, saves a new gradient. |
| `swatch <input>` | Manage color swatches. Without args, shows recent swatch entries. With args, saves a new swatch. |
| `stats` | Show summary statistics — entry counts per category, total entries, data size, and activity start date. |
| `export <fmt>` | Export all data to a file in `json`, `csv`, or `txt` format. |
| `search <term>` | Case-insensitive search across all log files for matching entries. |
| `recent` | Show the 20 most recent activity entries from the history log. |
| `status` | Health check — shows version, data directory, total entries, disk usage, last activity, and status. |
| `help` | Show usage information and available commands. |
| `version` | Print version number (`v2.0.0`). |

## Data Storage

All data is stored in `~/.local/share/banner/`:

- `palette.log` — Palette entries (timestamped)
- `preview.log` — Preview entries
- `generate.log` — Generation entries
- `convert.log` — Conversion entries
- `harmonize.log` — Harmony entries
- `contrast.log` — Contrast entries
- `export.log` — Export entries
- `random.log` — Random generation entries
- `browse.log` — Browse activity entries
- `mix.log` — Mix entries
- `gradient.log` — Gradient entries
- `swatch.log` — Swatch entries
- `history.log` — Full command history with timestamps

Each entry is stored as `YYYY-MM-DD HH:MM|<input>` (pipe-delimited).

## Requirements

- Bash 4+ (uses `local` variables and standard Unix utilities)
- No external dependencies or API keys required

## When to Use

1. **Building a color palette** — Use `palette` to log and iterate on color combinations for a design project.
2. **Previewing design elements** — Use `preview` to record design preview notes before committing to final assets.
3. **Generating design assets** — Use `generate` to log generation parameters and track what you've created over time.
4. **Creating gradients and swatches** — Use `gradient` and `swatch` to catalog reusable gradient definitions and color swatch collections.
5. **Auditing design history** — Use `stats`, `recent`, `search`, and `export` to review past design decisions, find old entries, and export data for reporting.

## Examples

```bash
# Add a new palette entry
banner palette "#FF5733 sunset warm tones"

# View recent palette entries
banner palette

# Generate a design element and log it
banner generate "header-image 1920x1080 blue-gradient"

# Create a gradient entry
banner gradient "linear #000 to #FFF 90deg"

# Mix two color references
banner mix "#FF0000 + #0000FF = purple blend"

# Search across all categories for a keyword
banner search "sunset"

# Show summary stats
banner stats

# Export all data as JSON
banner export json

# Check system status
banner status
```

## Output

All commands print results to stdout. Each logging command confirms the save and shows the total entry count for that category. Use shell redirection to capture output: `banner stats > report.txt`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
