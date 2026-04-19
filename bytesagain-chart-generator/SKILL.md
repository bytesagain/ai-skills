---
description: "Generate ASCII bar, line, pie, and scatter charts from CSV or inline data in your terminal. Use when visualizing datasets, plotting trends, comparing values, or exploring data distributions without opening a spreadsheet."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# bytesagain-chart-generator

Generate ASCII bar charts, line charts, pie charts, and scatter plots from CSV or inline data. Visualize datasets directly in your terminal with no external dependencies.

## Usage

```
bytesagain-chart-generator bar  <file_or_inline_data>
bytesagain-chart-generator line <file_or_inline_data>
bytesagain-chart-generator pie  <file_or_inline_data>
bytesagain-chart-generator scatter <file_or_inline_data>
bytesagain-chart-generator demo
```

## Commands

- `bar` — Horizontal ASCII bar chart with percentage breakdown
- `line` — ASCII line chart with labeled axes for time-series data
- `pie` — ASCII pie chart showing proportional distribution
- `scatter` — ASCII scatter plot for x,y coordinate data
- `demo` — Show sample charts for all four types

## Examples

```bash
bytesagain-chart-generator bar "Q1:1200,Q2:1850,Q3:1420,Q4:2100"
bytesagain-chart-generator line "Jan:320,Feb:450,Mar:380,Apr:520"
bytesagain-chart-generator pie "Chrome:65,Firefox:15,Safari:12,Others:8"
bytesagain-chart-generator bar sales.csv
bytesagain-chart-generator demo
```

## Input Format

Inline: `Label:Value,Label:Value,...`
CSV file: two columns (label, value) with optional header row.

## Requirements

- bash
- python3

## When to Use

Use when you need to quickly visualize data in the terminal, create charts for reports, compare metrics, or analyze trends without leaving the command line.
