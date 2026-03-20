---
name: Shell Gpt
description: "Run AI-powered shell commands and prompts for faster terminal workflows. Use when generating scripts, comparing outputs, evaluating prompts."
version: "1.0.0"
license: MIT
runtime: python3
---

# Shell Gpt

A command-line productivity tool powered by AI large language models like GPT-5, designed to help you accomplish terminal tasks faster and more efficiently. Log, track, and manage AI-related workflows including prompt evaluation, model benchmarking, cost tracking, and output analysis — all from a single CLI.

Inspired by [TheR1D/shell_gpt](https://github.com/TheR1D/shell_gpt) (11,891+ GitHub stars).

## Commands

- `configure` — Set up or review configuration parameters for Shell Gpt. Run without arguments to view recent config entries, or pass key-value pairs to save new settings. Useful for persisting API keys, model preferences, or runtime flags.

- `benchmark` — Record and review benchmark results for model or prompt performance. Without arguments it shows recent benchmark logs; with arguments it saves a new benchmark entry with a timestamp. Great for tracking latency, throughput, or quality metrics over time.

- `compare` — Log side-by-side comparison notes between models, prompts, or outputs. View previous comparisons with no arguments, or save a new comparison record. Helps you keep a structured journal of A/B test results.

- `prompt` — Store and retrieve prompt templates or prompt-engineering notes. Run bare to see recent prompts, or pass text to save a new prompt entry. Essential for iterating on prompt design and keeping a prompt library.

- `evaluate` — Record evaluation scores or qualitative assessments of model outputs. Without arguments it displays recent evaluations; with arguments it logs a new evaluation. Use this to build a track record of output quality over time.

- `fine-tune` — Track fine-tuning jobs, hyperparameters, and results. Shows recent fine-tune logs when called alone, or saves a new entry when given input. Handy for documenting training runs alongside their outcomes.

- `analyze` — Log analysis observations about data, outputs, or model behavior. View past analyses or record a new one. Use this as a lightweight lab notebook for your AI experiments.

- `cost` — Track API costs, token usage expenses, and billing notes. Without arguments it shows recent cost entries; with input it saves a new cost record. Critical for keeping cloud AI spending under control.

- `usage` — Record and review API usage statistics such as token counts or request volumes. Displays recent usage entries when called bare, or logs new usage data when given arguments. Helps you stay within rate limits and quotas.

- `optimize` — Document optimization attempts, parameter tweaks, and their effects. Shows recent optimization logs or saves a new entry. Use this to track what you tried and what worked.

- `test` — Log test cases, test results, and validation outcomes. View recent test entries or record a new one. Perfect for building a regression test journal for your prompts or pipelines.

- `report` — Save and review summary reports or periodic write-ups. Without arguments it shows recent reports; with text it saves a new report entry. Ideal for weekly summaries or stakeholder updates.

- `stats` — Display summary statistics across all logged categories. Shows total entry counts per category, overall totals, and data directory disk usage. A quick dashboard for your Shell Gpt activity.

- `export <fmt>` — Export all logged data to a file in the specified format: `json`, `csv`, or `txt`. The exported file is saved to the data directory and its size is reported. Use this for backups, data migration, or feeding logs into other tools.

- `search <term>` — Search across all log files for a given term (case-insensitive). Returns matching lines grouped by category. Helpful for finding a specific entry when you remember a keyword but not which command logged it.

- `recent` — Show the 20 most recent entries from the global activity history log. Gives you a quick at-a-glance view of what has been happening across all commands.

- `status` — Run a health check on the Shell Gpt installation. Reports the current version, data directory path, total log entries, disk usage, last activity timestamp, and overall status. Use this to verify the tool is working correctly.

- `help` — Display the full usage guide listing all available commands and their syntax. Also shows the current data directory path.

- `version` — Print the current Shell Gpt version string (`shell-gpt v2.0.0`).

## When to Use

- **Prompt engineering sessions** — When you are iterating on prompt designs, use `prompt` to save drafts, `evaluate` to score outputs, and `compare` to log A/B differences between prompt variants.
- **Model benchmarking and selection** — When comparing multiple LLMs or model versions, use `benchmark` to record performance metrics, `analyze` to note behavioral observations, and `report` to write up your conclusions.
- **Cost and usage monitoring** — When you need to keep cloud AI spending in check, use `cost` to log expenses, `usage` to track token consumption, and `stats` to get an overview of activity volume.
- **Fine-tuning workflow tracking** — When running fine-tuning jobs, use `fine-tune` to document hyperparameters and results, `test` to record validation outcomes, and `optimize` to log parameter adjustments.
- **Data export and auditing** — When you need to share logs, create backups, or feed data into dashboards, use `export` to dump everything to JSON/CSV/TXT, and `search` to locate specific entries quickly.

## Examples

```bash
# Save a new prompt template and review recent prompts
shell-gpt prompt "Summarize the following text in 3 bullet points:"
shell-gpt prompt

# Benchmark a model and check overall stats
shell-gpt benchmark "gpt-4o: 320ms avg latency, 92% accuracy on eval set"
shell-gpt stats

# Log API costs and export all data as CSV
shell-gpt cost "2026-03-18: $4.27 for 1.2M tokens on gpt-4o"
shell-gpt export csv

# Compare two models side by side
shell-gpt compare "gpt-4o vs claude-opus: gpt-4o faster, claude-opus more detailed"

# Search across all logs for a keyword and check system health
shell-gpt search "latency"
shell-gpt status
```

## Output

Returns reports and log entries to stdout. All data is persisted to per-command log files in the data directory. Redirect output to a file with `shell-gpt <command> > output.txt`.

## Configuration

Set the `SHELL_GPT_DIR` environment variable to change the data directory. Default: `~/.local/share/shell-gpt/`. All log files and exports are stored in this directory.

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
