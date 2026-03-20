---
version: "1.0.0"
name: Yellowbrick
description: "Visual analysis and diagnostic tools to help machine learning model selection. ml-visualizer, python, anaconda, estimator, machine-learning, matplotlib."
---

# ML Visualizer

A data toolkit for ingesting, transforming, querying, and visualizing machine learning datasets. Manage your entire data pipeline — from raw ingestion through profiling and validation — all from the command line.

## Commands

| Command | Description |
|---------|-------------|
| `ml-visualizer ingest <input>` | Ingest raw data or record a data source entry |
| `ml-visualizer transform <input>` | Log a data transformation step or operation |
| `ml-visualizer query <input>` | Record a query against your dataset |
| `ml-visualizer filter <input>` | Log a filter operation applied to data |
| `ml-visualizer aggregate <input>` | Record an aggregation or rollup operation |
| `ml-visualizer visualize <input>` | Log a visualization request or chart specification |
| `ml-visualizer export <input>` | Record an export operation or export all data |
| `ml-visualizer sample <input>` | Log a data sampling operation |
| `ml-visualizer schema <input>` | Record or describe a data schema |
| `ml-visualizer validate <input>` | Log a data validation check |
| `ml-visualizer pipeline <input>` | Record a full pipeline definition or step |
| `ml-visualizer profile <input>` | Log a data profiling run |
| `ml-visualizer stats` | Show summary statistics across all entry types |
| `ml-visualizer export <fmt>` | Export all data (formats: `json`, `csv`, `txt`) |
| `ml-visualizer search <term>` | Search across all entries by keyword |
| `ml-visualizer recent` | Show the 20 most recent activity log entries |
| `ml-visualizer status` | Health check — version, disk usage, last activity |
| `ml-visualizer help` | Show the built-in help message |
| `ml-visualizer version` | Print the current version (v2.0.0) |

Each data command (ingest, transform, query, etc.) works in two modes:
- **Without arguments** — displays the 20 most recent entries of that type
- **With arguments** — saves the input as a new timestamped entry

## Data Storage

All data is stored as plain-text log files in `~/.local/share/ml-visualizer/`:

- Each command type gets its own log file (e.g., `ingest.log`, `transform.log`, `visualize.log`)
- Entries are stored in `timestamp|value` format for easy parsing
- A unified `history.log` tracks all activity across command types
- Export to JSON, CSV, or TXT at any time with the `export` command

Set the `ML_VISUALIZER_DIR` environment variable to override the default data directory.

## Requirements

- Bash 4.0+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies or API keys required

## When to Use

1. **Building a data pipeline journal** — use `ingest`, `transform`, and `pipeline` to document each step of your ML data preparation workflow
2. **Tracking data quality** — use `validate` and `profile` to log validation checks and profiling runs, ensuring data integrity before model training
3. **Logging visualization requests** — use `visualize` to record what charts and plots you've generated for model diagnostics (confusion matrices, ROC curves, feature importance)
4. **Managing dataset schemas** — use `schema` to document the structure of your datasets, track schema changes over time, and share definitions with your team
5. **Auditing data operations** — use `search`, `recent`, and `stats` to review your complete data processing history and find specific operations

## Examples

```bash
# Ingest a new data source
ml-visualizer ingest "Loaded training set from s3://ml-data/train.csv — 50,000 rows, 24 features"

# Record a transformation step
ml-visualizer transform "Applied StandardScaler to numeric columns, one-hot encoded categoricals"

# Log a visualization
ml-visualizer visualize "Generated confusion matrix for RandomForest classifier — 94% accuracy"

# Define a schema entry
ml-visualizer schema "users table: id(int), age(int), income(float), segment(str), churn(bool)"

# Search past operations
ml-visualizer search "StandardScaler"
```

## Output

All commands print results to stdout. Redirect to a file if needed:

```bash
ml-visualizer stats > pipeline-report.txt
ml-visualizer export json
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
