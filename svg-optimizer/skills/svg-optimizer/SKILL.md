---
version: "1.0.0"
name: Svgo
description: "Optimize SVG files by removing metadata and minifying paths. Use when previewing output, generating assets, converting formats, cleaning vectors."
---
# SVG Optimizer

SVG Optimizer v2.0.0 — a design toolkit for logging, tracking, and managing SVG optimization entries from the command line. Each command logs timestamped entries to individual log files, provides history viewing, summary statistics, data export, and full-text search across all records.

## Commands

Run `svg-optimizer <command> [args]` to use.

| Command | Description |
|---------|-------------|
| `palette <input>` | Log a palette entry (or view recent palette entries if no input given) |
| `preview <input>` | Log a preview entry (or view recent preview entries if no input given) |
| `generate <input>` | Log a generate entry (or view recent generate entries if no input given) |
| `convert <input>` | Log a convert entry (or view recent convert entries if no input given) |
| `harmonize <input>` | Log a harmonize entry (or view recent harmonize entries if no input given) |
| `contrast <input>` | Log a contrast entry (or view recent contrast entries if no input given) |
| `export <input>` | Log an export entry (or view recent export entries if no input given) |
| `random <input>` | Log a random entry (or view recent random entries if no input given) |
| `browse <input>` | Log a browse entry (or view recent browse entries if no input given) |
| `mix <input>` | Log a mix entry (or view recent mix entries if no input given) |
| `gradient <input>` | Log a gradient entry (or view recent gradient entries if no input given) |
| `swatch <input>` | Log a swatch entry (or view recent swatch entries if no input given) |
| `stats` | Show summary statistics across all log files (entry counts, data size) |
| `export <fmt>` | Export all data in json, csv, or txt format |
| `search <term>` | Full-text search across all log entries (case-insensitive) |
| `recent` | Show the 20 most recent entries from history.log |
| `status` | Health check — version, data dir, entry count, disk usage, last activity |
| `help` | Show usage help |
| `version` | Show version (v2.0.0) |

## How It Works

Every command (palette, preview, generate, convert, etc.) works the same way:

- **With arguments:** Saves a timestamped entry (`YYYY-MM-DD HH:MM|input`) to `<command>.log` and writes to `history.log`.
- **Without arguments:** Displays the 20 most recent entries from that command's log file.

This gives you a lightweight, file-based logging system for tracking SVG optimization tasks, color palette work, gradient design, and vector asset management.

## Data Storage

All data is stored locally in `~/.local/share/svg-optimizer/`:

```
~/.local/share/svg-optimizer/
├── palette.log      # Palette entries (timestamp|value)
├── preview.log      # Preview entries
├── generate.log     # Generate entries
├── convert.log      # Convert entries
├── harmonize.log    # Harmonize entries
├── contrast.log     # Contrast entries
├── export.log       # Export entries
├── random.log       # Random entries
├── browse.log       # Browse entries
├── mix.log          # Mix entries
├── gradient.log     # Gradient entries
├── swatch.log       # Swatch entries
├── history.log      # Master activity log
└── export.<fmt>     # Exported data files
```

## Requirements

- Bash (4.0+)
- Standard POSIX utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies — works on any Linux or macOS system out of the box

## When to Use

1. **Tracking SVG optimization runs** — Use `svg-optimizer convert "logo.svg minified"` to log each optimization pass with timestamps.
2. **Managing color palettes** — Use `svg-optimizer palette "#FF5733, #33FF57, #3357FF"` to record palette choices for design projects.
3. **Generating gradient records** — Use `svg-optimizer gradient "linear: blue→purple for header"` to log gradient configurations.
4. **Comparing contrast ratios** — Use `svg-optimizer contrast "foreground #333 vs background #FFF = 12.6:1"` to track accessibility checks.
5. **Browsing and reviewing design assets** — Use `svg-optimizer browse "icon set v2 review"` to log asset review sessions, then `search` to find specific entries.

## Examples

```bash
# Log a palette entry
svg-optimizer palette "#E63946, #F1FAEE, #A8DADC, #457B9D"

# Log a convert/optimization entry
svg-optimizer convert "hero-banner.svg - removed metadata, 45% smaller"

# Generate a design record
svg-optimizer generate "New icon set: 24 icons at 24x24"

# Create a gradient entry
svg-optimizer gradient "radial: sunset orange to deep purple"

# Check a swatch
svg-optimizer swatch "Brand primary: #1D3557"

# View recent activity
svg-optimizer recent

# Search for entries related to icons
svg-optimizer search "icon"

# Get summary statistics
svg-optimizer stats

# Export all data to JSON
svg-optimizer export json
```

## Output

All commands output to stdout. Redirect to a file if needed:

```bash
svg-optimizer stats > design-report.txt
svg-optimizer export csv  # writes to ~/.local/share/svg-optimizer/export.csv
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
