---
version: "3.0.0"
name: data-visualizer
description: "Terminal ASCII chart toolkit. Create bar charts, sparklines, histograms, and gauges from CSV or JSON data in the terminal."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# data-visualizer

Terminal data visualization toolkit — create ASCII bar charts, sparklines, histograms, heatmaps, gauges, treemaps from data. Process CSV/JSON files with stats summaries, correlations, normalization, and pivoting. Export to SVG and HTML.

## Commands

### `bar`

Draw a horizontal bar chart from label:value pairs.

```bash
scripts/script.sh bar "Sales:42" "Revenue:87" "Profit:31"
```

### `histogram`

Show frequency distribution of numeric values as a histogram.

```bash
scripts/script.sh histogram 10 15 20 20 25 30 30 30 35 40
```

### `sparkline`

Render an inline sparkline chart from a series of values.

```bash
scripts/script.sh sparkline 4 8 15 16 23 42 38 29 18 10
```

### `heatmap`

Display a color-coded heat grid from row/column data.

```bash
scripts/script.sh heatmap 3 4 1 5 9 2 8 3 7 4 6 1
```

### `treemap`

Show proportional blocks for part-to-whole comparisons.

```bash
scripts/script.sh treemap "Chrome:65" "Safari:18" "Firefox:10" "Edge:7"
```

### `gauge`

Display a gauge meter showing a value against a maximum.

```bash
scripts/script.sh gauge 73 100 "CPU Usage"
```

### `matrix`

Render a CSV file as a formatted matrix/table view.

```bash
scripts/script.sh matrix data.csv
```

### `summarize`

Compute min/max/average/median statistics for each numeric column in a CSV file.

```bash
scripts/script.sh summarize sales.csv
```

### `distribution`

Show the value distribution of numeric data in a CSV file across bins.

```bash
scripts/script.sh distribution scores.csv 8
```

### `correlate`

Compute a Pearson correlation matrix across all numeric columns in a CSV file.

```bash
scripts/script.sh correlate metrics.csv
```

### `normalize`

Normalize all numeric columns to 0-1 range and output as CSV.

```bash
scripts/script.sh normalize raw_data.csv > normalized.csv
```

### `pivot`

Group rows by a column and aggregate numeric values (sum, avg, min, max).

```bash
scripts/script.sh pivot sales.csv region
```

### `from-csv`

Auto-visualize a CSV file with summary statistics.

```bash
scripts/script.sh from-csv data.csv
```

### `from-json`

Auto-visualize a JSON file — shows structure, keys, and numeric column summaries.

```bash
scripts/script.sh from-json data.json
```

### `to-svg`

Export CSV data as an SVG bar chart.

```bash
scripts/script.sh to-svg sales.csv
```

### `to-html`

Export CSV data as an HTML table with styling.

```bash
scripts/script.sh to-html report.csv
```

### `help`

```bash
scripts/script.sh help
```

### `version`

```bash
scripts/script.sh version
```

## Examples

```bash
# Quick terminal charts
scripts/script.sh bar "Q1:120" "Q2:185" "Q3:210" "Q4:170"
scripts/script.sh sparkline 10 20 30 25 40 35 50 45
scripts/script.sh gauge 78 100 "Memory"

# CSV analysis pipeline
scripts/script.sh summarize data.csv
scripts/script.sh correlate data.csv
scripts/script.sh pivot data.csv category

# Export
scripts/script.sh to-svg data.csv
scripts/script.sh to-html data.csv
```

## Configuration

| Variable | Required | Description |
|----------|----------|-------------|
| `DATAVIZ_DIR` | No | Data directory (default: `~/.local/share/data-visualizer/`) |

## Data Storage

History logged in `~/.local/share/data-visualizer/history.log`.

## Requirements

- bash 4.0+
- python3 (for CSV processing, correlations, JSON parsing, SVG export)

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
