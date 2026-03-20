---
version: "1.0.0"
name: Labelimg
description: "LabelImg is now part of the Label Studio community. The popular image annotation tool created by Tzu image-labeler, python, annotations, deep-learning."
---

# Image Labeler

Image Labeler v2.0.0 — a design toolkit for working with color palettes, previews, generation, conversion, harmonization, contrast analysis, random colors, browsing, mixing, gradients, and swatches. All entries are timestamped and logged locally for history tracking.

## Commands

### Core Commands

- `palette <input>` — Record and log a palette entry. Without arguments, shows the 20 most recent palette entries.
- `preview <input>` — Record and log a preview entry. Without arguments, shows recent preview entries.
- `generate <input>` — Record and log a generate entry. Without arguments, shows recent generate entries.
- `convert <input>` — Record and log a convert entry. Without arguments, shows recent convert entries.
- `harmonize <input>` — Record and log a harmonize entry. Without arguments, shows recent harmonize entries.
- `contrast <input>` — Record and log a contrast entry. Without arguments, shows recent contrast entries.
- `export <input>` — Record and log an export entry. Without arguments, shows recent export entries.
- `random <input>` — Record and log a random entry. Without arguments, shows recent random entries.
- `browse <input>` — Record and log a browse entry. Without arguments, shows recent browse entries.
- `mix <input>` — Record and log a mix entry. Without arguments, shows recent mix entries.
- `gradient <input>` — Record and log a gradient entry. Without arguments, shows recent gradient entries.
- `swatch <input>` — Record and log a swatch entry. Without arguments, shows recent swatch entries.

### Utility Commands

- `stats` — Show summary statistics across all log files (entry counts per type, total entries, disk usage).
- `export <fmt>` — Export all logged data to a file. Supported formats: `json`, `csv`, `txt`. (Note: also doubles as a core command when given non-format arguments.)
- `search <term>` — Search all log files for a case-insensitive term match.
- `recent` — Show the 20 most recent entries from the activity history log.
- `status` — Health check showing version, data directory, total entries, disk usage, and last activity.
- `help` — Display the full help message with all available commands.
- `version` — Print the current version (v2.0.0).

## Data Storage

All data is stored in `~/.local/share/image-labeler/`:

- Each core command writes timestamped entries to its own log file (e.g., `palette.log`, `gradient.log`).
- A unified `history.log` tracks all operations across commands.
- Export files are written to the same directory as `export.json`, `export.csv`, or `export.txt`.

## Requirements

- Bash (with `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`, `basename`

## When to Use

- When you need to log and track design-related operations (palettes, gradients, swatches, color mixing, etc.)
- For maintaining an audit trail of image labeling and design activities
- To export accumulated design data in JSON, CSV, or plain text for downstream processing
- As part of a larger design automation pipeline that needs timestamped operation records
- When you need to search across historical design and labeling entries

## Examples

```bash
# Record a palette entry
image-labeler palette "ocean-blue #0077be warm-sand #c2b280"

# Generate a new entry
image-labeler generate "monochromatic from #3498db"

# Create a gradient record
image-labeler gradient "linear #ff0000 to #0000ff 5 steps"

# Mix colors
image-labeler mix "#ff0000 #00ff00 50%"

# Check contrast
image-labeler contrast "#ffffff on #333333"

# Browse swatches
image-labeler browse "earth tones"

# View recent activity
image-labeler recent

# Search across all logs
image-labeler search "blue"

# Export everything to CSV
image-labeler export csv

# Show stats
image-labeler stats

# Health check
image-labeler status
```

## Output

All commands output results to stdout. Redirect to a file if needed:

```bash
image-labeler stats > report.txt
image-labeler export json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
