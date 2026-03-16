---
version: "2.0.0"
name: CSV Data Analyzer
description: "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━. Use when you need csv analyzer capabilities. Triggers on: csv analyzer."
  CSV数据分析工具。数据统计摘要、SVG图表生成、条件筛选、文件合并、数据清洗、格式转换(JSON/HTML/Markdown/SQL)、HTML分析报告。CSV analyzer with stats, SVG charts, filtering, merging, cleaning, format conversion, HTML reports. 数据分析、数据清洗、可视化。Use when analyzing CSV data.
---

# CSV Data Analyzer

Analyze CSV data: statistics, charts, filtering, cleaning, conversion, and HTML reports.

## Commands

| Command | Description |
|---------|------------|
| `analyze [file.csv]` | 数据统计摘要（行列数、类型、缺失值、基本统计） |
| `chart [数据] [类型]` | 生成SVG图表（bar/pie/line） |
| `filter [数据] [条件]` | 按条件筛选数据 |
| `merge [file1] [file2] [key]` | 合并两个CSV（类似SQL JOIN） |
| `clean [数据]` | 数据清洗（去重、修剪、标准化） |
| `convert [数据] [格式]` | 格式转换（json/markdown/html/sql） |
| `report [数据]` | 生成完整HTML分析报告 |
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
csv-analyzer help
csv-analyzer run
```
