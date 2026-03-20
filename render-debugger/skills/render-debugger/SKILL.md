---
version: "1.0.0"
name: Why Did You Render
description: "render-debugger by Welldone Software monkey patches React to notify you about potentially avoidab why did you render, javascript, component, hooks-tracking."
---

# Render Debugger

Developer tools CLI for checking, validating, generating, and debugging render performance issues. Lint components for unnecessary re-renders, explain render behavior, convert between profiling formats, generate optimization templates, diff render snapshots, preview component trees, fix render issues, and produce performance reports — all from the command line with persistent local logging.

## Commands

Run `render-debugger <command> [args]` to use.

| Command | Description |
|---------|-------------|
| `check` | Check components for render performance issues |
| `validate` | Validate render optimization patterns and memo usage |
| `generate` | Generate render-optimized component boilerplate |
| `format` | Format render profiling data for readability |
| `lint` | Lint components for unnecessary re-renders and anti-patterns |
| `explain` | Explain why a component re-rendered and suggest fixes |
| `convert` | Convert between render profiling data formats |
| `template` | Apply or manage render optimization templates |
| `diff` | Diff render snapshots to identify regression |
| `preview` | Preview component render tree and dependency graph |
| `fix` | Auto-fix common render performance issues |
| `report` | Generate render performance and optimization reports |
| `stats` | Show summary statistics across all categories |
| `export <fmt>` | Export data in json, csv, or txt format |
| `search <term>` | Search across all logged entries |
| `recent` | Show recent activity from history log |
| `status` | Health check — version, data dir, disk usage |
| `help` | Show help and available commands |
| `version` | Show version (v2.0.0) |

Each domain command (check, validate, generate, etc.) works in two modes:
- **Without arguments**: displays the most recent 20 entries from that category
- **With arguments**: logs the input with a timestamp and saves to the category log file

## Data Storage

All data is stored locally in `~/.local/share/render-debugger/`:

- Each command creates its own log file (e.g., `check.log`, `validate.log`, `lint.log`)
- A unified `history.log` tracks all activity across commands
- Entries are stored in `timestamp|value` pipe-delimited format
- Export supports JSON, CSV, and plain text formats

## Requirements

- Bash 4+ with `set -euo pipefail` strict mode
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies or API keys required

## When to Use

1. **Debugging slow React renders** — use `check` and `lint` to identify components that re-render unnecessarily, then `explain` to understand the root cause
2. **Optimizing component performance** — generate memoized component templates with `template`, apply fixes with `fix`, and validate optimizations with `validate`
3. **Profiling render behavior across releases** — take render snapshots, use `diff` to compare before/after, and track regression with `report` over time
4. **Onboarding team members on render best practices** — use `explain` to break down render cycles in plain language, share `template` patterns for optimized components
5. **CI/CD render performance gates** — integrate `lint` and `check` into your pipeline to catch render regressions before they ship, export results with `export` for dashboards

## Examples

```bash
# Check a component for render issues
render-debugger check "UserProfile: 12 re-renders in 3s, props unchanged"

# Validate memo usage
render-debugger validate "useMemo deps OK, useCallback stable, React.memo applied"

# Generate optimized component boilerplate
render-debugger generate "MemoizedList: React.memo + useCallback for handlers"

# Lint for anti-patterns
render-debugger lint "inline object in JSX prop — creates new ref every render"

# Explain a re-render
render-debugger explain "Parent state change propagated to Child via context"

# Diff render snapshots
render-debugger diff "before: 45 renders/s, after: 12 renders/s — 73% reduction"

# Fix common issues
render-debugger fix "extracted inline handler to useCallback, wrapped child in memo"

# Preview component tree
render-debugger preview "App → Dashboard → [UserList, StatsPanel, ActivityFeed]"

# Generate performance report
render-debugger report "sprint-22: avg renders reduced 40%, LCP improved 200ms"

# View summary statistics
render-debugger stats

# Export all data as CSV
render-debugger export csv

# Search for specific components
render-debugger search "UserProfile"

# Check recent activity
render-debugger recent

# Health check
render-debugger status
```

## Output

All commands output to stdout. Redirect to a file if needed:

```bash
render-debugger report "weekly perf review" > report.txt
render-debugger export json  # saves to ~/.local/share/render-debugger/export.json
```

## Configuration

Set `RENDER_DEBUGGER_DIR` environment variable to change the data directory. Default: `~/.local/share/render-debugger/`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
