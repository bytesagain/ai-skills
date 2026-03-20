---
version: "1.0.0"
name: Oxc
description: "Compile, bundle, and optimize JavaScript with high-performance build tools. Use when bundling modules, minifying builds, or analyzing bundle output sizes."
---
# JS Compiler

JS Compiler v2.0.0 — a devtools toolkit for logging, tracking, and managing JavaScript compilation and build operations from the command line.

Each command accepts free-text input. When called without arguments it displays recent entries; when called with input it logs the entry with a timestamp for future reference.

## Commands

| Command | Description |
|---------|-------------|
| `js-compiler check <input>` | Log a check entry (e.g. verify build output, check syntax) |
| `js-compiler validate <input>` | Log a validation entry (e.g. validate config, confirm bundle integrity) |
| `js-compiler generate <input>` | Log a generation entry (e.g. generate boilerplate, scaffold modules) |
| `js-compiler format <input>` | Log a format entry (e.g. format source code, prettify output) |
| `js-compiler lint <input>` | Log a lint entry (e.g. lint source files, check for code issues) |
| `js-compiler explain <input>` | Log an explanation entry (e.g. explain build errors, annotate warnings) |
| `js-compiler convert <input>` | Log a conversion entry (e.g. convert ESM→CJS, transform syntax) |
| `js-compiler template <input>` | Log a template entry (e.g. save build config templates for reuse) |
| `js-compiler diff <input>` | Log a diff entry (e.g. compare build outputs, highlight bundle changes) |
| `js-compiler preview <input>` | Log a preview entry (e.g. preview build plan before execution) |
| `js-compiler fix <input>` | Log a fix entry (e.g. fix compilation errors, resolve warnings) |
| `js-compiler report <input>` | Log a report entry (e.g. summarize build results, bundle size report) |

### Utility Commands

| Command | Description |
|---------|-------------|
| `js-compiler stats` | Show summary statistics across all entry types |
| `js-compiler export <fmt>` | Export all data in `json`, `csv`, or `txt` format |
| `js-compiler search <term>` | Search all entries for a keyword (case-insensitive) |
| `js-compiler recent` | Show the 20 most recent activity log entries |
| `js-compiler status` | Health check — version, data dir, entry count, disk usage |
| `js-compiler help` | Show the built-in help message |
| `js-compiler version` | Print version string (`js-compiler v2.0.0`) |

## Data Storage

All data is stored locally in `~/.local/share/js-compiler/`. Each command writes to its own log file (e.g. `check.log`, `validate.log`, `lint.log`). A unified `history.log` tracks all activity with timestamps. Exports are written to the same directory as `export.json`, `export.csv`, or `export.txt`.

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies or network access required

## When to Use

1. **Tracking build and compilation results** — use `report` to log bundle sizes, build times, and success/failure status after each compilation, then `search` to find historical results.
2. **Debugging compilation errors** — use `explain` to annotate error messages with root cause analysis, `fix` to log resolution steps, and `check` to verify the fix worked.
3. **Comparing build outputs across versions** — use `diff` to log side-by-side comparisons of bundle sizes or build artifacts, then `export csv` to chart trends over time.
4. **Managing build configuration templates** — use `template` to save webpack/rollup/esbuild configs for different environments (dev, staging, prod), then `search` to find the right one quickly.
5. **Linting and formatting JavaScript codebases** — use `lint` to log code quality issues found, `format` to track formatting operations, and `validate` to confirm config files are correct before building.

## Examples

```bash
# Log a build result
js-compiler report "Production build: 142KB gzipped, 0 errors, 3 warnings, 8.2s"

# Explain a compilation error
js-compiler explain "TypeError: Cannot read 'default' of undefined — circular import in utils/index.js"

# Fix a build issue
js-compiler fix "Resolved circular import by extracting shared types to types/common.ts"

# Compare two builds
js-compiler diff "v2.1: 138KB | v2.2: 155KB — 12% increase from new charting library"

# Save a build config template
js-compiler template "esbuild prod config: --bundle --minify --target=es2020 --splitting"

# Lint the codebase
js-compiler lint "ESLint run: 0 errors, 12 warnings (unused imports)"

# Search for all entries about bundle size
js-compiler search "bundle"

# View summary statistics
js-compiler stats

# Export all data to JSON
js-compiler export json
```

## How It Works

JS Compiler is a lightweight Bash script that stores timestamped entries in plain-text log files. Each command follows the same pattern:

- **No arguments** → display the 20 most recent entries from that command's log
- **With arguments** → append a timestamped entry to the log and confirm the save

The `stats` command aggregates line counts across all `.log` files. The `export` command serializes all logs into your chosen format. The `search` command greps case-insensitively across every log file in the data directory.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
