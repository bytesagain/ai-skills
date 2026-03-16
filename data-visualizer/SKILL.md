---
version: "2.0.0"
name: data-visualizer
description: "SVG chart generator for data visualization. Create bar charts, line charts, pie charts, scatter plots, heatmaps, dashboards, comparison charts, and trend analysis. Outputs pure SVG code that opens in any browser. No external dependencies. Use when creating charts, visualizing data, or building dashboards. Triggers on: data visualizer."
author: BytesAgain
---

# 📊 Data Visualizer — SVG Chart Generator

> Pure-code SVG charts. No chart libraries, no dependencies. Open in any browser.

## 🗂️ Command Quick Reference

```
┌─────────────┬────────────────────────────────┐
│ Command     │ Description                    │
├─────────────┼────────────────────────────────┤
│ bar         │ Bar chart — category compare   │
│ line        │ Line chart — trend over time   │
│ pie         │ Pie chart — proportions        │
│ scatter     │ Scatter plot — correlation     │
│ heatmap     │ Heatmap — matrix data          │
│ dashboard   │ Dashboard — multi-metric view  │
│ compare     │ Comparison — side-by-side bars │
│ trend       │ Trend — annotated line chart   │
└─────────────┴────────────────────────────────┘
```

## 📥 Input Format

Comma-separated label:value pairs: `Label1:100,Label2:85,Label3:200`

## 📤 Output

- Complete SVG code — save as `.svg` and open in browser
- Scales without pixelation (vector graphics)
- Embeddable in HTML, Markdown, or email

## 🎨 Features

- Auto color palette (8-color cycle)
- Responsive sizing
- Multi-language label support
- Zero external dependencies

## 📂 Scripts
- `scripts/visualize.sh` — Main script
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Commands

Run `data-visualizer help` to see all available commands.
