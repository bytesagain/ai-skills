---
version: "1.0.0"
name: Genai Toolbox
description: "Bridge AI models to databases through MCP with config and evaluation tools. Use when setting up DB tools, comparing engines, or evaluating prompt quality."
---

# Genai Toolkit

Genai Toolkit v2.0.0 — an AI toolkit for managing generative AI workflows from the command line. Log configurations, benchmarks, prompts, evaluations, fine-tuning runs, cost tracking, and optimization notes. Each entry is timestamped and persisted locally. Works entirely offline — your data never leaves your machine.

## Why Genai Toolkit?

- Works entirely offline — your data never leaves your machine
- Simple command-line interface with no GUI dependency
- Export to JSON, CSV, or plain text at any time for sharing or archival
- Automatic activity history logging across all commands
- Each domain command doubles as both a logger and a viewer

## Commands

### Domain Commands

Each domain command works in two modes: **log mode** (with arguments) saves a timestamped entry, **view mode** (no arguments) shows the 20 most recent entries.

| Command | Description |
|---------|-------------|
| `genai-toolkit configure <input>` | Log a configuration note such as model parameters, API keys, or environment settings. Use this to record setup changes and track which configurations were active during experiments. |
| `genai-toolkit benchmark <input>` | Log a benchmark result or performance observation. Record latency, throughput, accuracy, or other metrics to compare across runs and model versions. |
| `genai-toolkit compare <input>` | Log a comparison note between models, configurations, or approaches. Useful for side-by-side evaluations like GPT-4 vs Claude on specific tasks. |
| `genai-toolkit prompt <input>` | Log a prompt template or prompt engineering note. Track iterations on prompt design, record what worked, and document prompt versioning. |
| `genai-toolkit evaluate <input>` | Log an evaluation result or quality metric. Record accuracy scores, F1 metrics, human ratings, or any qualitative assessment of model outputs. |
| `genai-toolkit fine-tune <input>` | Log a fine-tuning run or hyperparameter note. Track epochs, learning rates, dataset sizes, and resulting model performance after fine-tuning. |
| `genai-toolkit analyze <input>` | Log an analysis observation or insight. Record patterns found in data, failure mode analysis, or trends across experiments. |
| `genai-toolkit cost <input>` | Log cost tracking data including API costs, compute expenses, and token consumption. Essential for budget monitoring across projects and providers. |
| `genai-toolkit usage <input>` | Log usage metrics or consumption data. Track request volumes, token counts, rate limit encounters, and daily/monthly consumption patterns. |
| `genai-toolkit optimize <input>` | Log optimization attempts or performance improvements. Record what was changed, the expected vs actual impact, and next steps. |
| `genai-toolkit test <input>` | Log test results or test case notes. Record pass/fail outcomes, edge cases discovered, and regression test results. |
| `genai-toolkit report <input>` | Log a report entry or summary finding. Capture weekly summaries, milestone reports, or executive-level findings from AI workflows. |

### Utility Commands

| Command | Description |
|---------|-------------|
| `genai-toolkit stats` | Show summary statistics across all log files, including entry counts per category and total data size on disk. |
| `genai-toolkit export <fmt>` | Export all data to a file in the specified format. Supported formats: `json`, `csv`, `txt`. Output is saved to the data directory. |
| `genai-toolkit search <term>` | Search all log entries for a term using case-insensitive matching. Results are grouped by log category for easy scanning. |
| `genai-toolkit recent` | Show the 20 most recent entries from the unified activity log, giving a quick overview of recent work across all commands. |
| `genai-toolkit status` | Health check showing version, data directory path, total entry count, disk usage, and last activity timestamp. |
| `genai-toolkit help` | Show the built-in help message listing all available commands and usage information. |
| `genai-toolkit version` | Print the current version (v2.0.0). |

## Data Storage

All data is stored locally at `~/.local/share/genai-toolkit/`. Each domain command writes to its own log file (e.g., `configure.log`, `benchmark.log`). A unified `history.log` tracks all actions across commands. Use `export` to back up your data at any time.

## Requirements

- Bash (4.0+)
- No external dependencies — pure shell script
- No network access required

## When to Use

- Tracking AI model benchmarks and comparisons across different providers and versions over time
- Logging prompt engineering iterations to understand what improvements actually moved the needle
- Monitoring API costs and token usage across multiple projects and billing periods
- Evaluating fine-tuning experiments with detailed hyperparameter and metric tracking
- Building a searchable knowledge base of optimization attempts and analysis insights

## Examples

```bash
# Log a benchmark result
genai-toolkit benchmark "GPT-4o latency: avg 1.2s, p99 3.8s on summarization task, 500 samples"

# Track a cost entry
genai-toolkit cost "March batch processing: $42.50 across 15k requests, avg $0.0028/req"

# Compare two models
genai-toolkit compare "Claude 3.5 vs GPT-4o on code generation — Claude 15% faster, GPT-4o 5% more accurate"

# Log a prompt iteration
genai-toolkit prompt "v3: Added chain-of-thought instruction, reduced hallucination rate from 12% to 3%"

# Record a fine-tuning run
genai-toolkit fine-tune "SQL-gen model epoch 5: accuracy=0.96, loss=0.12, lr=2e-5, dataset=50k rows"

# View all statistics
genai-toolkit stats

# Export everything to JSON
genai-toolkit export json

# Search for entries mentioning latency
genai-toolkit search latency

# Check recent activity
genai-toolkit recent

# Health check
genai-toolkit status
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
