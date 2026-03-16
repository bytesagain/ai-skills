---
version: "2.0.0"
name: Gaokao Essay
description: "高考作文生成器。议论文、记叙文、材料作文。提供范文、素材、开头结尾模板。. Use when you need gaokao essay capabilities. Triggers on: gaokao essay."
  高考作文助手。议论文模板、素材库、开头结尾、审题技巧、满分作文分析。Gaokao essay assistant with templates, materials, scoring tips. 高考语文、作文素材、议论文、记叙文。Use when preparing for gaokao essays.
author: BytesAgain
---

# gaokao-essay

高考作文生成器。议论文、记叙文、材料作文。提供范文、素材、开头结尾模板。

## Commands

All commands via `scripts/essay.sh`:

| Command | Description |
|---------|-------------|
| `essay.sh write "题目" [--type 议论文\|记叙文\|材料作文]` | 生成一篇完整作文（默认议论文） |
| `essay.sh opening "主题"` | 生成5个万能开头 |
| `essay.sh ending "主题"` | 生成5个万能结尾 |
| `essay.sh material "话题"` | 作文素材库（名人名言+事例） |
| `essay.sh help` | 显示帮助信息 |

## Usage

Agent should run the script and return output to user. Example:

```bash
bash scripts/essay.sh write "人生的选择" --type 议论文
bash scripts/essay.sh opening "奋斗"
bash scripts/essay.sh material "创新"
```

## Notes

- Python 3.6+ compatible
- No external dependencies
- All content generated locally from built-in templates
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
