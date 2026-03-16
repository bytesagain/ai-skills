---
name: ChartMaker
description: "Terminal chart and graph generator. Create bar charts, line charts, histograms, and sparklines from data. Visualize CSV files, compare values, show trends, and generate progress bars. Data visualization without leaving the command line."
version: "2.0.0"
author: "BytesAgain"
tags: ["chart","graph","visualization","bar","sparkline","data","terminal","ascii"]
categories: ["Developer Tools", "Utility", "Data"]
---
# ChartMaker
Visualize data in your terminal. Bar charts, sparklines, progress bars.
## Commands
- `bar <label:value ...>` — Horizontal bar chart
- `spark <values>` — Sparkline from comma-separated values
- `progress <current> <total> [label]` — Progress bar
- `csv <file> <col>` — Chart from CSV column
- `compare <val1:label1> <val2:label2>` — Compare values visually
## Usage Examples
```bash
chartmaker bar "Sales:85" "Marketing:62" "Engineering:93"
chartmaker spark "10,20,35,42,38,52,48,60"
chartmaker progress 73 100 "Upload"
```
---
Powered by BytesAgain | bytesagain.com

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
