---
version: "1.0.0"
name: Responsively App
description: "A modified web browser that helps in responsive web development. A web developer's must have dev-too responsively app, typescript, contributions-welcome."
---

# Responsive Tester

Responsive Tester v2.0.0 is a utility toolkit for testing, analyzing, and managing responsive web development workflows. It provides a thorough CLI with timestamped logging, multi-format data export, and full activity history tracking.

## Commands

All commands accept optional `<input>` arguments. When called without arguments, they display the 20 most recent entries from their respective logs. When called with input, they record a new timestamped entry.

| Command | Usage | Description |
|---------|-------|-------------|
| `run` | `responsive-tester run [input]` | Run a responsive test and log the result |
| `check` | `responsive-tester check [input]` | Check a URL or component for responsiveness |
| `convert` | `responsive-tester convert [input]` | Convert viewport data or test formats |
| `analyze` | `responsive-tester analyze [input]` | Analyze responsive behavior across breakpoints |
| `generate` | `responsive-tester generate [input]` | Generate responsive test reports or configs |
| `preview` | `responsive-tester preview [input]` | Preview layout at different viewport sizes |
| `batch` | `responsive-tester batch [input]` | Batch test multiple URLs or components |
| `compare` | `responsive-tester compare [input]` | Compare responsive behavior across devices |
| `export` | `responsive-tester export [input]` | Log an export operation |
| `config` | `responsive-tester config [input]` | Manage test configuration settings |
| `status` | `responsive-tester status [input]` | Log or view status entries |
| `report` | `responsive-tester report [input]` | Generate or log responsive testing reports |

### Utility Commands

| Command | Usage | Description |
|---------|-------|-------------|
| `stats` | `responsive-tester stats` | Show summary statistics across all log files |
| `export <fmt>` | `responsive-tester export json\|csv\|txt` | Export all data in JSON, CSV, or plain text format |
| `search <term>` | `responsive-tester search <term>` | Search across all log entries (case-insensitive) |
| `recent` | `responsive-tester recent` | Show the 20 most recent activity entries |
| `status` | `responsive-tester status` | Health check — version, data dir, entry count, disk usage |
| `help` | `responsive-tester help` | Show full command reference |
| `version` | `responsive-tester version` | Print version string (`responsive-tester v2.0.0`) |

## Data Storage

All data is stored locally in `~/.local/share/responsive-tester/`:

- **`history.log`** — Master activity log with timestamps for every operation
- **`run.log`**, **`check.log`**, **`analyze.log`**, etc. — Per-command log files storing `timestamp|input` entries
- **`export.json`**, **`export.csv`**, **`export.txt`** — Generated export files

Each entry is stored in pipe-delimited format: `YYYY-MM-DD HH:MM|value`. The data directory is created automatically on first use.

## Requirements

- **Bash** 4.0+ (uses `set -euo pipefail`, `local` variables)
- **Standard Unix tools**: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `basename`, `cat`
- No external dependencies, API keys, or network access required
- Works on Linux, macOS, and WSL

## When to Use

1. **Testing responsive layouts across breakpoints** — Use `run` or `check` to log responsive test results for different viewport sizes and devices
2. **Comparing mobile vs desktop behavior** — Use `compare` to track differences in how a page renders across screen widths
3. **Batch testing multiple pages or components** — Use `batch` to queue and process several URLs or components with logged results
4. **Generating responsive audit reports** — Use `report` and `export json` to produce structured test history for stakeholder review
5. **Previewing layout changes before deployment** — Use `preview` to verify responsive behavior at target breakpoints before going live

## Examples

```bash
# Run a responsive test on a URL
responsive-tester run https://example.com --viewport=375x812

# Check a component at a specific breakpoint
responsive-tester check header-nav tablet

# Analyze breakpoint behavior
responsive-tester analyze landing-page --breakpoints=sm,md,lg

# Compare rendering across two devices
responsive-tester compare mobile-safari desktop-chrome

# Batch test multiple pages
responsive-tester batch /home /about /contact /pricing

# Export all test history as CSV
responsive-tester export csv

# Search for past test results
responsive-tester search "landing-page"

# View summary statistics
responsive-tester stats
```

## Output

All commands output structured text to stdout. Use standard shell redirection to capture output:

```bash
responsive-tester stats > summary.txt
responsive-tester export json  # writes to ~/.local/share/responsive-tester/export.json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
