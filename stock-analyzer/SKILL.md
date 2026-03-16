---
version: "2.0.0"
name: stock-analyzer
description: "股票分析工具。基本面分析、PE估值、技术指标、股息分析、个股对比、自选股管理。Stock analyzer with fundamental analysis, PE valuation, technical indicators, dividend analysis, stock comparison, watchlist management. Use when you need stock analyzer capabilities. Triggers on: stock analyzer."
---
# stock-analyzer

股票分析工具。基本面分析、PE估值、技术指标、股息分析、个股对比、自选股管理。Stock analyzer with fundamental analysis, PE valuation, technical indicators, dividend analysis, stock comparison, watchlist management.

## 常见问题

**Q: 这个工具适合谁用？**
A: 任何需要stock-analyzer的人，无论是个人还是企业用户。

**Q: 输出格式是什么？**
A: 主要输出Markdown格式，方便复制和编辑。

## 可用命令

- **add** — add
- **remove** — remove
- **show** — show
- **analyze** — analyze
- **pe** — pe
- **technical** — technical
- **dividend** — dividend
- **compare** — compare


## 专业建议

- `analyze` 是最全面的命令，一次看完基本面+估值+趋势
- `pe` 适合做估值对比，输入行业名称可获得行业平均PE
- `compare` 最多支持5只股票同时对比
- 基本面优先** — 先看公司质地（营收、利润、负债率）
- 估值其次** — PE/PB/PS 多维度估值

---
*stock-analyzer by BytesAgain*
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Commands

| Command | Description |
|---------|-------------|
| `stock-analyzer help` | Show usage info |
| `stock-analyzer run` | Run main task |

## Examples

```bash
stock-analyzer help
stock-analyzer run
```
