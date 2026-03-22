---
name: "pivot"
version: "1.0.0"
description: "Data pivot operations reference — pivot tables, crosstab transformations, melt/unpivot, data reshaping in SQL/pandas/spreadsheets. Use when transforming data between long and wide formats or building summary pivot tables."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [pivot, crosstab, data, reshape, pandas, sql, atomic]
category: "atomic"
---

# Pivot — Data Pivot Operations Reference

Quick-reference skill for pivot table operations, data reshaping between long and wide formats, and crosstab analysis.

## When to Use

- Reshaping data from long to wide format (pivot) or wide to long (unpivot/melt)
- Building pivot tables for summary analysis
- Understanding SQL PIVOT/UNPIVOT operations
- Using pandas pivot_table, melt, stack/unstack
- Designing crosstab reports and contingency tables

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of pivot operations — long vs wide format, when to pivot, terminology.

### `pandas`

```bash
scripts/script.sh pandas
```

Pandas pivot operations — pivot(), pivot_table(), melt(), stack(), unstack().

### `sql`

```bash
scripts/script.sh sql
```

SQL PIVOT/UNPIVOT — syntax for SQL Server, PostgreSQL crosstab, MySQL alternatives.

### `spreadsheet`

```bash
scripts/script.sh spreadsheet
```

Spreadsheet pivot tables — Excel, Google Sheets construction and analysis.

### `crosstab`

```bash
scripts/script.sh crosstab
```

Cross-tabulation — frequency tables, contingency tables, chi-square analysis.

### `reshape`

```bash
scripts/script.sh reshape
```

Data reshaping patterns — tidy data principles, normalization, denormalization.

### `aggregation`

```bash
scripts/script.sh aggregation
```

Aggregation functions in pivots — sum, mean, count, custom aggregations, multi-agg.

### `visualization`

```bash
scripts/script.sh visualization
```

Visualizing pivoted data — heatmaps, stacked charts, pivot-to-dashboard patterns.

### `help`

```bash
scripts/script.sh help
```

### `version`

```bash
scripts/script.sh version
```

## Configuration

| Variable | Description |
|----------|-------------|
| `PIVOT_DIR` | Data directory (default: ~/.pivot/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
