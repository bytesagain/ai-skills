---
name: Funnlp
description: "Detect sensitive words, extract phone/ID numbers, and run Chinese NLP tasks. Use when filtering content, extracting entities, or detecting text language."
version: "1.0.0"
license: MIT-0
runtime: python3
---

# Funnlp

Funnlp v2.0.0 — an AI toolkit for managing NLP workflows from the command line. Log configurations, benchmarks, prompts, evaluations, fine-tuning runs, and more. Each entry is timestamped and persisted locally. Works entirely offline — your data never leaves your machine.

Inspired by [fighting41love/funNLP](https://github.com/fighting41love/funNLP) (79,378+ GitHub stars).

## Commands

### Domain Commands

Each domain command works in two modes: **log mode** (with arguments) saves a timestamped entry, **view mode** (no arguments) shows the 20 most recent entries.

| Command | Description |
|---------|-------------|
| `funnlp configure <input>` | Log a configuration note (model settings, parameters, etc.) |
| `funnlp benchmark <input>` | Log a benchmark result or observation |
| `funnlp compare <input>` | Log a model/tool comparison note |
| `funnlp prompt <input>` | Log a prompt template or prompt engineering note |
| `funnlp evaluate <input>` | Log an evaluation result or metric |
| `funnlp fine-tune <input>` | Log a fine-tuning run or hyperparameter note |
| `funnlp analyze <input>` | Log an analysis observation or insight |
| `funnlp cost <input>` | Log cost tracking data (API costs, compute, etc.) |
| `funnlp usage <input>` | Log usage metrics or consumption data |
| `funnlp optimize <input>` | Log optimization attempts or improvements |
| `funnlp test <input>` | Log test results or test case notes |
| `funnlp report <input>` | Log a report entry or summary finding |

### Utility Commands

| Command | Description |
|---------|-------------|
| `funnlp stats` | Show summary statistics across all log files |
| `funnlp export <fmt>` | Export all data to a file (formats: `json`, `csv`, `txt`) |
| `funnlp search <term>` | Search all log entries for a term (case-insensitive) |
| `funnlp recent` | Show the 20 most recent entries from the activity log |
| `funnlp status` | Health check — version, data dir, entry count, disk usage |
| `funnlp help` | Show the built-in help message |
| `funnlp version` | Print the current version (v2.0.0) |

## Data Storage

All data is stored locally at `~/.local/share/funnlp/`. Each domain command writes to its own log file (e.g., `configure.log`, `benchmark.log`). A unified `history.log` tracks all actions across commands. Use `export` to back up your data at any time.

## Requirements

- Bash (4.0+)
- No external dependencies — pure shell script
- No network access required

## When to Use

- Tracking Chinese NLP experiments (sensitive word detection, entity extraction, etc.)
- Logging benchmark results for text classification, NER, or sentiment models
- Comparing NLP tools and libraries with persistent, searchable notes
- Managing prompt engineering iterations for Chinese language tasks
- Recording fine-tuning runs and evaluation metrics
- Building a local knowledge base of NLP experiment results
- Exporting experiment logs for team sharing or archival

## Examples

```bash
# Log a new configuration
funnlp configure "BERT-base-chinese, max_len=512, batch=32"

# Record a benchmark result
funnlp benchmark "NER F1=0.91 on MSRA dataset"

# Compare two approaches
funnlp compare "jieba vs pkuseg: pkuseg +3% on news domain"

# Log a prompt template
funnlp prompt "Extract all phone numbers from: {text}"

# Track fine-tuning
funnlp fine-tune "Epoch 5/10, loss=0.23, lr=2e-5"

# Search across all logs
funnlp search "BERT"

# Export everything as CSV
funnlp export csv

# Check overall status
funnlp status

# View recent activity
funnlp recent
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
