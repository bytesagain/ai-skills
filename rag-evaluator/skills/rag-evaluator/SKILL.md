---
version: "1.0.0"
name: Ragaai Catalyst
description: "Python SDK for Agent AI Observability, Monitoring and Evaluation Framework. Includes features like a ragaai catalyst, python, agentic-ai."
---

# Rag Evaluator

AI-powered RAG (Retrieval-Augmented Generation) evaluation toolkit. Configure, benchmark, compare, and optimize your RAG pipelines from the command line. Track prompts, evaluations, fine-tuning experiments, costs, and usage — all with persistent local logging and full export capabilities.

## Commands

Run `rag-evaluator <command> [args]` to use.

| Command | Description |
|---------|-------------|
| `configure` | Configure RAG evaluation settings and parameters |
| `benchmark` | Run benchmarks against your RAG pipeline |
| `compare` | Compare results across different RAG configurations |
| `prompt` | Log and manage prompt templates and variations |
| `evaluate` | Evaluate RAG output quality and relevance |
| `fine-tune` | Track fine-tuning experiments and parameters |
| `analyze` | Analyze evaluation results and identify patterns |
| `cost` | Track and log API/inference costs |
| `usage` | Monitor token usage and API call volumes |
| `optimize` | Log optimization strategies and results |
| `test` | Run test cases against RAG configurations |
| `report` | Generate evaluation reports |
| `stats` | Show summary statistics across all categories |
| `export <fmt>` | Export data in json, csv, or txt format |
| `search <term>` | Search across all logged entries |
| `recent` | Show recent activity from history log |
| `status` | Health check — version, data dir, disk usage |
| `help` | Show help and available commands |
| `version` | Show version (v2.0.0) |

Each domain command (configure, benchmark, compare, etc.) works in two modes:
- **Without arguments**: displays the most recent 20 entries from that category
- **With arguments**: logs the input with a timestamp and saves to the category log file

## Data Storage

All data is stored locally in `~/.local/share/rag-evaluator/`:

- Each command creates its own log file (e.g., `configure.log`, `benchmark.log`)
- A unified `history.log` tracks all activity across commands
- Entries are stored in `timestamp|value` pipe-delimited format
- Export supports JSON, CSV, and plain text formats

## Requirements

- Bash 4+ with `set -euo pipefail` strict mode
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies or API keys required

## When to Use

1. **Evaluating RAG pipeline quality** — log evaluation scores, compare retrieval strategies, and track improvements over time
2. **Benchmarking different configurations** — run benchmarks across embedding models, chunk sizes, or retrieval methods and compare results side by side
3. **Tracking costs and usage** — monitor API costs and token usage across experiments to stay within budget
4. **Managing prompt engineering** — log prompt variations, test them against your pipeline, and analyze which templates perform best
5. **Generating reports for stakeholders** — export evaluation data as JSON/CSV for dashboards, or generate text reports summarizing RAG performance

## Examples

```bash
# Configure a new evaluation run
rag-evaluator configure "model=gpt-4 chunks=512 overlap=50 top_k=5"

# Run a benchmark and log results
rag-evaluator benchmark "latency=230ms recall@5=0.82 precision@5=0.71"

# Compare two retrieval strategies
rag-evaluator compare "bm25 vs dense: bm25 recall=0.78, dense recall=0.85"

# Track evaluation scores
rag-evaluator evaluate "faithfulness=0.91 relevance=0.87 coherence=0.93"

# Log API cost for a run
rag-evaluator cost "run-042: $0.23 (1.2k tokens input, 800 tokens output)"

# View summary statistics
rag-evaluator stats

# Export all data as CSV
rag-evaluator export csv

# Search for specific entries
rag-evaluator search "gpt-4"

# Check recent activity
rag-evaluator recent

# Health check
rag-evaluator status
```

## Output

All commands output to stdout. Redirect to a file if needed:

```bash
rag-evaluator report "weekly summary" > report.txt
rag-evaluator export json  # saves to ~/.local/share/rag-evaluator/export.json
```

## Configuration

Set `DATA_DIR` by modifying the script, or use the default: `~/.local/share/rag-evaluator/`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
