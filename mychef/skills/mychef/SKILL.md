---
version: "1.0.0"
name: mychef
description: "Manage recipes, plan daily meals, and organize ingredients with a kitchen helper. Use when looking up recipes, planning cooking, organizing shopping lists."
---

# MyChef

A devtools-style toolkit for managing recipes, validating configurations, generating templates, and organizing your kitchen workflow. Check ingredients, lint recipes, diff versions, preview meal plans, and generate reports — all from the command line.

## Commands

| Command | Description |
|---------|-------------|
| `mychef check <input>` | Check recipe validity, ingredient availability, or prerequisites |
| `mychef validate <input>` | Validate a recipe, configuration, or meal plan |
| `mychef generate <input>` | Generate a new recipe, shopping list, or meal plan |
| `mychef format <input>` | Format a recipe or data entry for consistent structure |
| `mychef lint <input>` | Lint a recipe or config for common issues |
| `mychef explain <input>` | Explain a recipe step, technique, or ingredient substitution |
| `mychef convert <input>` | Convert measurements, formats, or recipe units |
| `mychef template <input>` | Create or record a recipe template |
| `mychef diff <input>` | Compare two recipe versions or meal plans |
| `mychef preview <input>` | Preview a recipe or meal plan before finalizing |
| `mychef fix <input>` | Fix issues in a recipe or configuration |
| `mychef report <input>` | Generate a summary report of recipes or meal history |
| `mychef stats` | Show summary statistics across all entry types |
| `mychef export <fmt>` | Export all data (formats: `json`, `csv`, `txt`) |
| `mychef search <term>` | Search across all entries by keyword |
| `mychef recent` | Show the 20 most recent activity log entries |
| `mychef status` | Health check — version, disk usage, last activity |
| `mychef help` | Show the built-in help message |
| `mychef version` | Print the current version (v2.0.0) |

Each command works in two modes:
- **Without arguments** — displays the 20 most recent entries of that type
- **With arguments** — saves the input as a new timestamped entry

## Data Storage

All data is stored as plain-text log files in `~/.local/share/mychef/`:

- Each command type gets its own log file (e.g., `check.log`, `generate.log`, `template.log`)
- Entries are stored in `timestamp|value` format for easy parsing
- A unified `history.log` tracks all activity across command types
- Export to JSON, CSV, or TXT at any time with the `export` command

Set the `MYCHEF_DIR` environment variable to override the default data directory.

## Requirements

- Bash 4.0+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies or API keys required

## When to Use

1. **Organizing your recipe collection** — use `generate` and `template` to create structured recipes, then `format` them for consistency across your collection
2. **Validating recipes before cooking** — use `check`, `validate`, and `lint` to verify ingredients are available, measurements are correct, and no steps are missing
3. **Converting recipe units** — use `convert` to switch between metric and imperial, scale servings up or down, or adapt recipes for different contexts
4. **Comparing recipe versions** — use `diff` to see what changed between iterations of a recipe, and `preview` to review before committing
5. **Tracking your cooking history** — use `report`, `stats`, and `search` to review what you've cooked, find past recipes by ingredient, and measure how often you cook

## Examples

```bash
# Check if you have ingredients for a recipe
mychef check "Pad Thai: rice noodles, shrimp, eggs, bean sprouts, peanuts, lime, fish sauce"

# Generate a weekly meal plan
mychef generate "Monday: pasta, Tuesday: stir-fry, Wednesday: soup, Thursday: tacos, Friday: pizza"

# Convert measurements
mychef convert "2 cups flour = 250g, 1 tbsp butter = 14g, oven 350F = 175C"

# Lint a recipe for missing info
mychef lint "Chocolate cake recipe — missing prep time, serving size, and oven temperature"

# Search for all pasta recipes
mychef search "pasta"
```

## Output

All commands print results to stdout. Redirect to a file if needed:

```bash
mychef stats > kitchen-report.txt
mychef export json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
