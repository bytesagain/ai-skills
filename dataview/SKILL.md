---
name: DataView
description: "Data file viewer and analyzer for CSV and JSON files. Preview CSV files with formatted tables, inspect JSON structure and contents, calculate column statistics (min, max, mean, median), and get quick file summaries. Essential for data exploration without loading heavy tools."
version: "2.0.0"
author: "BytesAgain"
tags: ["data","csv","json","analysis","statistics","viewer","explorer","developer"]
categories: ["Developer Tools", "Data Analysis", "Utility"]
---

# DataView

Explore data files from your terminal. No pandas, no notebooks — just quick answers.

## Why DataView?

- **CSV viewer**: Formatted table display with column alignment
- **JSON inspector**: Understand JSON structure instantly
- **Column stats**: Min, max, mean, median for numeric columns
- **File summary**: Quick counts of rows, columns, and file size
- **Lightweight**: Pure Python, no heavy dependencies

## Commands

- `csv <file> [rows]` — Preview CSV file as formatted table (default: 10 rows)
- `json <file>` — Inspect JSON file structure and contents
- `stats <csv_file> [column_index]` — Calculate statistics for a numeric column
- `count <file>` — Quick file summary (size, lines, rows, columns)
- `info` — Version info
- `help` — Show commands

## Usage Examples

```bash
dataview csv sales-data.csv 20
dataview json config.json
dataview stats revenue.csv 3
dataview count users.csv
```

## Supported Formats

- **CSV**: Comma-separated values with header detection
- **JSON**: Arrays and objects with nested structure display

---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
