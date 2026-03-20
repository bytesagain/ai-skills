---
version: "1.0.0"
name: Shell Gpt
description: "A command-line productivity tool powered by AI large language models like GPT-5, will help you accom shell gpt, python, chatgpt, cheat-sheet, cli, commands."
---

# Shell AI

Terminal-first AI toolkit for configuring, benchmarking, comparing, prompting, evaluating, and fine-tuning AI models — all from the command line.

## Why Shell AI?

- Works entirely offline — your data never leaves your machine
- Full AI workflow: configure → prompt → evaluate → benchmark → compare → optimize
- Fine-tuning tracking, cost analysis, and usage monitoring built in
- Export to JSON, CSV, or plain text anytime
- Automatic history and activity logging with timestamps

## Getting Started

```bash
# See all available commands
shell-ai help

# Check current health status
shell-ai status

# View summary statistics
shell-ai stats

# Show recent activity
shell-ai recent
```

## Commands

| Command | What it does |
|---------|-------------|
| `shell-ai configure <input>` | Configure AI model settings (or view recent configs with no args) |
| `shell-ai benchmark <input>` | Benchmark model performance (or view recent benchmarks) |
| `shell-ai compare <input>` | Compare models or outputs side-by-side (or view recent comparisons) |
| `shell-ai prompt <input>` | Store and manage prompts (or view recent prompts) |
| `shell-ai evaluate <input>` | Evaluate model outputs for quality (or view recent evaluations) |
| `shell-ai fine-tune <input>` | Track fine-tuning jobs and parameters (or view recent fine-tunes) |
| `shell-ai analyze <input>` | Analyze model behavior or outputs (or view recent analyses) |
| `shell-ai cost <input>` | Track API costs and token usage (or view recent cost entries) |
| `shell-ai usage <input>` | Monitor usage patterns and quotas (or view recent usage logs) |
| `shell-ai optimize <input>` | Record optimization strategies (or view recent optimizations) |
| `shell-ai test <input>` | Log test runs and results (or view recent tests) |
| `shell-ai report <input>` | Generate reports on AI activity (or view recent reports) |
| `shell-ai stats` | Show summary statistics across all data categories |
| `shell-ai export <fmt>` | Export all data in a format: json, csv, or txt |
| `shell-ai search <term>` | Search across all log entries for a keyword |
| `shell-ai recent` | Show the 20 most recent activity entries |
| `shell-ai status` | Health check: version, disk usage, entry counts |
| `shell-ai help` | Show the full help message |
| `shell-ai version` | Print current version (v2.0.0) |

Each AI command works in two modes:
- **With arguments:** saves the input with a timestamp to `<command>.log` and logs to history
- **Without arguments:** displays the 20 most recent entries for that command

## Data Storage

All data is stored locally at `~/.local/share/shell-ai/`:

- `configure.log`, `benchmark.log`, `prompt.log`, etc. — one log file per command
- `history.log` — unified activity log with timestamps
- `export.json`, `export.csv`, `export.txt` — generated export files

Data format: each entry is stored as `YYYY-MM-DD HH:MM|<value>` (pipe-delimited).

Set the `SHELL_AI_DIR` environment variable to change the data directory.

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- Standard UNIX utilities: `wc`, `du`, `grep`, `tail`, `sed`, `date`, `cat`, `basename`
- No external dependencies or network access required

## When to Use

1. **Configuring AI models** — use `configure` to save model parameters, API keys references, and default settings
2. **Benchmarking and comparing models** — run `benchmark` and `compare` to track performance across different models or prompts
3. **Managing prompts and evaluations** — store prompts with `prompt`, then evaluate output quality with `evaluate`
4. **Tracking costs and usage** — monitor API spend with `cost` and usage patterns with `usage` to stay within budget
5. **Optimizing and fine-tuning** — log fine-tuning experiments with `fine-tune` and optimization strategies with `optimize`

## Examples

```bash
# Configure a model
shell-ai configure "model=gpt-4 temperature=0.7 max_tokens=2048"

# Store and evaluate a prompt
shell-ai prompt "Summarize the following article in 3 bullet points"
shell-ai evaluate "gpt-4 summary: accuracy=9/10 coherence=8/10"

# Benchmark and compare
shell-ai benchmark "gpt-4 latency=1.2s tokens/sec=45 cost=$0.03"
shell-ai compare "gpt-4 vs claude-3: gpt-4 faster, claude more detailed"

# Track costs and fine-tuning
shell-ai cost "2024-01 total: $47.20 (gpt-4: $32, claude: $15.20)"
shell-ai fine-tune "job-abc123: 500 samples, 3 epochs, loss=0.42"

# Export everything as CSV, then search
shell-ai export csv
shell-ai search "gpt-4"

# Check overall health
shell-ai status
shell-ai stats
```

## Output

All commands return human-readable output to stdout. Redirect to a file for scripting:

```bash
shell-ai stats > report.txt
shell-ai export json
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
