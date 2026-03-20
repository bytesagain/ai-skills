---
version: "1.0.0"
name: Ohmyzsh
description: "🙃 A delightful community-driven (with 2,400+ contributors) framework for managing your zsh configu zsh-themes, shell, cli, cli-app, oh-my-zsh."
---

# Zsh Themes

🙃 A design toolkit for creating, previewing, and managing Zsh themes and color palettes. Generate palettes, preview themes, mix colors, create gradients, and export swatches — all from the command line.

## Commands

All commands accept optional `<input>` arguments. Without arguments, they display recent entries from their log.

| Command | Description |
|---------|-------------|
| `zsh-themes palette <input>` | Create or log a color palette for a theme |
| `zsh-themes preview <input>` | Preview a theme configuration or color scheme |
| `zsh-themes generate <input>` | Generate a new theme template or color set |
| `zsh-themes convert <input>` | Convert between theme formats or color notations |
| `zsh-themes harmonize <input>` | Find harmonious color combinations for a base color |
| `zsh-themes contrast <input>` | Check or log contrast ratios between colors |
| `zsh-themes export <input>` | Log an export operation for theme files |
| `zsh-themes random <input>` | Generate a random theme or color combination |
| `zsh-themes browse <input>` | Browse or log available themes and presets |
| `zsh-themes mix <input>` | Mix two or more colors to create a blend |
| `zsh-themes gradient <input>` | Create or log a color gradient specification |
| `zsh-themes swatch <input>` | Save or view a color swatch entry |
| `zsh-themes stats` | Show summary statistics across all log files |
| `zsh-themes export json\|csv\|txt` | Export all data in JSON, CSV, or plain text format |
| `zsh-themes search <term>` | Search across all log entries for a keyword |
| `zsh-themes recent` | Show the 20 most recent activity entries |
| `zsh-themes status` | Health check — version, data dir, entry count, disk usage |
| `zsh-themes help` | Show all available commands |
| `zsh-themes version` | Print version (v2.0.0) |

## Data Storage

All data is stored locally in `~/.local/share/zsh-themes/`. Each command maintains its own `.log` file with timestamped entries in `YYYY-MM-DD HH:MM|value` format. A unified `history.log` tracks all operations across commands.

**Export formats supported:**
- **JSON** — Array of objects with `type`, `time`, and `value` fields
- **CSV** — Standard comma-separated with `type,time,value` header
- **TXT** — Human-readable grouped by command type

## Requirements

- Bash 4.0+ with `set -euo pipefail` (strict mode)
- Standard Unix utilities: `date`, `wc`, `du`, `grep`, `tail`, `sed`, `cat`
- No external dependencies — runs on any POSIX-compliant system

## When to Use

1. **Designing custom Zsh themes** — Use `palette`, `generate`, and `preview` to iterate on color schemes
2. **Checking accessibility** — Use `contrast` to verify color combinations meet readability standards
3. **Exploring color combinations** — Use `harmonize`, `mix`, and `random` to discover new palettes
4. **Managing a theme collection** — Use `browse`, `swatch`, and `search` to organize and find saved themes
5. **Exporting theme data** — Export palettes and gradient specs to JSON/CSV for use in other tools or dotfiles

## Examples

```bash
# Create a color palette
zsh-themes palette "Nord: #2E3440 #3B4252 #434C5E #4C566A"

# Preview a theme
zsh-themes preview "Dracula: purple prompt, green git status"

# Generate a random theme
zsh-themes random "warm tones, minimal prompt"

# Check contrast ratio
zsh-themes contrast "#282A36 on #F8F8F2 — ratio 11.3:1 AAA"

# Create a gradient
zsh-themes gradient "#FF6B6B → #4ECDC4 — 5 steps"

# Mix two colors
zsh-themes mix "blend #FF0000 + #0000FF = #800080"

# Export all theme data to JSON
zsh-themes export json

# Search for a specific theme
zsh-themes search "nord"

# View summary statistics
zsh-themes stats
```

## How It Works

Zsh Themes stores all data locally in `~/.local/share/zsh-themes/`. Each command creates a dedicated log file (e.g., `palette.log`, `preview.log`, `gradient.log`). Every entry is timestamped and appended, providing a full history of all theme design activity. The `history.log` file aggregates operations across all commands for unified tracking.

When called without arguments, each command displays its most recent 20 entries, making it easy to review past design work without manually inspecting log files.

## Output

All output goes to stdout. Redirect to a file with:

```bash
zsh-themes stats > report.txt
zsh-themes export json  # writes to ~/.local/share/zsh-themes/export.json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
