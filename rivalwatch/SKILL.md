---
version: "2.0.0"
name: Competitor Analysis
description: "竞品分析报告生成器。SWOT分析、竞品对比、市场定位、差异化策略。. Use when you need rivalwatch capabilities. Triggers on: rivalwatch."
  竞品分析工具。SWOT分析、竞品对比、市场定位、差异化策略。Competitor analysis with SWOT, comparison matrix, market positioning. 竞争分析、行业分析、市场调研。Use when analyzing competitors.
---

# competitor-analysis

竞品分析报告生成器。SWOT分析、竞品对比、市场定位、差异化策略。

## Description

生成结构化的竞品分析报告，包括SWOT分析、竞品对比矩阵、市场定位分析和差异化策略建议。

## Commands

| 命令 | 用法 | 说明 |
|------|------|------|
| `swot` | `compete.sh swot "公司/产品"` | SWOT四象限分析 |
| `compare` | `compete.sh compare "产品A" "产品B"` | 竞品对比矩阵 |
| `positioning` | `compete.sh positioning "产品" "行业"` | 市场定位分析 |
| `strategy` | `compete.sh strategy "产品" "竞品"` | 差异化策略建议 |
| `help` | `compete.sh help` | 显示帮助信息 |

## Usage

当用户需要竞品分析、市场定位或差异化策略时，运行对应脚本命令。

```bash
# SWOT分析
bash {{SKILL_DIR}}/scripts/compete.sh swot "微信支付"

# 竞品对比
bash {{SKILL_DIR}}/scripts/compete.sh compare "微信支付" "支付宝"

# 市场定位
bash {{SKILL_DIR}}/scripts/compete.sh positioning "微信支付" "移动支付"

# 差异化策略
bash {{SKILL_DIR}}/scripts/compete.sh strategy "微信支付" "支付宝"
```

## Notes

- 纯本地生成，无需API
- Python 3.6+ 兼容
- 输出结构化分析框架，需结合实际数据补充
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
