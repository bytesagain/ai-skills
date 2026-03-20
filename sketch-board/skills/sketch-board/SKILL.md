---
version: "1.0.0"
name: Drawnix
description: "开源白板工具（SaaS），一体化白板，包含思维导图、流程图、自由画等。All in one open-source whiteboard tool with mind, flowchart, free sketch-board, typescript, collaboration, drawing."
---

# Sketch Board

Design and color toolkit. Manage palettes, generate gradients, mix colors, check contrast, and browse swatches — all from the command line.

## Commands

Run `sketch-board <command> [args]` to use.

| Command | Description |
|---------|-------------|
| `palette <input>` | Create or log a color palette |
| `preview <input>` | Preview a design element or color scheme |
| `generate <input>` | Generate design assets or color combinations |
| `convert <input>` | Convert between color formats (hex, rgb, hsl, etc.) |
| `harmonize <input>` | Find harmonious color combinations |
| `contrast <input>` | Check color contrast ratios for accessibility |
| `export <input>` | Export design data (also supports `export <fmt>` for json/csv/txt) |
| `random <input>` | Generate random colors or design elements |
| `browse <input>` | Browse saved palettes or design entries |
| `mix <input>` | Mix two or more colors together |
| `gradient <input>` | Create or log gradient definitions |
| `swatch <input>` | Save or view color swatches |
| `stats` | Show summary statistics across all log files |
| `search <term>` | Search all entries for a keyword |
| `recent` | Show the 20 most recent history entries |
| `status` | Health check — version, data size, entry count |
| `help` | Show help message |
| `version` | Show version (v2.0.0) |

Each data command (palette, preview, generate, convert, harmonize, contrast, export, random, browse, mix, gradient, swatch) works in two modes:
- **Without arguments** — displays the 20 most recent entries from its log
- **With arguments** — saves the input with a timestamp to its dedicated log file

## Data Storage

All data is stored in `~/.local/share/sketch-board/`:

- `palette.log`, `preview.log`, `generate.log`, `convert.log`, `harmonize.log`, `contrast.log` — per-command log files
- `export.log`, `random.log`, `browse.log`, `mix.log`, `gradient.log`, `swatch.log` — additional command logs
- `history.log` — unified activity history across all commands
- `export.json`, `export.csv`, `export.txt` — generated export files

Set `SKETCH_BOARD_DIR` environment variable to override the default data directory.

## Requirements

- Bash 4+ with standard coreutils (`date`, `wc`, `du`, `tail`, `grep`, `sed`)
- No external dependencies — pure shell implementation

## When to Use

1. **Building color palettes** — create and store palettes for web design, branding, or UI work
2. **Checking accessibility contrast** — verify WCAG contrast ratios between foreground and background colors
3. **Generating gradients** — define and log CSS or design gradients for projects
4. **Mixing and harmonizing colors** — experiment with color blending and find complementary schemes
5. **Cataloging design swatches** — maintain a searchable library of color swatches and design tokens

## Examples

```bash
# Create a palette
sketch-board palette "sunset: #FF6B35, #F7931E, #FFD700, #C62368"

# Check contrast ratio
sketch-board contrast "#FFFFFF on #333333 ratio=12.63:1 PASS AAA"

# Generate a gradient
sketch-board gradient "linear 0deg: #667eea → #764ba2 (purple-blue)"

# Mix colors
sketch-board mix "#FF0000 + #0000FF = #800080 (purple)"

# Create harmonious combinations
sketch-board harmonize "base=#2196F3 complementary=#F39621 triadic=#21F396,#9621F3"

# Generate random color
sketch-board random "#A3E4D7 — mint green, warm and inviting"

# Save a swatch
sketch-board swatch "brand-primary=#1A73E8 brand-secondary=#34A853"

# Export all data as CSV
sketch-board export csv

# Search for entries
sketch-board search "purple"

# View recent activity
sketch-board recent

# Show statistics
sketch-board stats
```

## Output

All commands output results to stdout. Log entries are stored with timestamps in pipe-delimited format (`YYYY-MM-DD HH:MM|value`). Use `export` to convert all data to JSON, CSV, or plain text.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
