---
description: "Analyze CSV files with statistical summaries, correlations, and pivot tables. Use when exploring new datasets, checking data quality, finding column correlations, ranking top values, or charting trends."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# bytesagain-data-analytics

Terminal data analysis toolkit for CSV files. Compute statistical summaries, correlation matrices, top value rankings, trend charts, data quality reports, and pivot tables — no Python data science libraries required.

## Usage

```
bytesagain-data-analytics describe <csv_file>
bytesagain-data-analytics correlate <csv_file>
bytesagain-data-analytics top <csv_file> <column>
bytesagain-data-analytics trend <csv_file> <column>
bytesagain-data-analytics clean <csv_file>
bytesagain-data-analytics pivot <csv_file> <row_col> <value_col>
```

## Commands

- `describe` — Per-column statistics: count, mean, std, percentiles, top categories
- `correlate` — Pearson correlation matrix across all numeric columns
- `top` — Rank top 15 values in any column with percentage and bar chart
- `trend` — ASCII line chart showing value trend over rows with direction indicator
- `clean` — Data quality report: null counts, low cardinality, coverage per column
- `pivot` — Group by a category column and aggregate a numeric column

## Examples

```bash
bytesagain-data-analytics describe sales.csv
bytesagain-data-analytics correlate metrics.csv
bytesagain-data-analytics top customers.csv country
bytesagain-data-analytics trend revenue.csv amount
bytesagain-data-analytics clean user-data.csv
bytesagain-data-analytics pivot orders.csv category revenue
```

## Requirements

- bash
- python3

## When to Use

Use when exploring a new dataset, checking data quality before analysis, finding correlations between metrics, or generating quick visual summaries from CSV exports without opening a spreadsheet.
