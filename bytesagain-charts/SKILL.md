---
name: "BytesAgain Charts — Professional Data Visualization & Plotting"
description: "Generate beautiful ASCII and HTML charts from data (CSV/JSON). 支持数据可视化、自动生成条形图、折线图及饼图。Use when analyzing performance trends, creating terminal dashboards, or visualizing dataset distributions."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["visualization", "charts", "data-science", "analytics", "plotting", "bilingual", "数据可视化"]
---

# BytesAgain Charts / 楼台图表助手

Turn your raw data into insightful visualizations instantly.

## Quick Start / 快速开始
Just ask your AI assistant: / 直接告诉 AI 助手：
- "Create a bar chart for these monthly sales: Jan:100, Feb:150, Mar:130" (根据月度销售额生成柱状图)
- "Plot a line chart showing the CPU usage trend from data.csv" (根据CSV数据绘制趋势图)
- "Generate a pie chart to visualize budget distribution" (生成饼图展示预算分布情况)

## Features / 功能特性
- **Multiple Types**: Bar charts, Line plots, Pie charts, and Candlestick support.
- **Bilingual Output**: Clear descriptions for both English and Chinese users.
- **Local & Fast**: Zero external dependencies (beyond Python), no data leaves your machine.

## Commands / 常用功能

### bar
Generate a terminal-based bar chart.
```bash
bash scripts/script.sh bar "Jan:10,Feb:20,Mar:15" --title "Sales"
```

### line
Generate a trend line chart.
```bash
bash scripts/script.sh line "1,5,3,8,2" --title "Growth"
```

## Requirements / 要求
- bash 4+
- python3

## Feedback
Report issues or suggest chart types: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com
