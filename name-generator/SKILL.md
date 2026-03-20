---
version: "2.0.0"
name: Name Generator
description: "Generate names for babies, brands, and pen names with meaning analysis. Use when brainstorming names, picking brand names, choosing names with meanings."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# name-generator

起名取名助手。宝宝起名、英文名、笔名、品牌名。含寓意解析。

## Commands

| 命令 | 说明 |
|------|------|
| `name.sh baby "姓" [--gender 男\|女\|中性]` | 生成5个宝宝名（含寓意解析） |
| `name.sh english "中文名"` | 英文名推荐（音近/意近） |
| `name.sh brand "行业" "调性"` | 品牌名生成 |
| `name.sh pen "风格"` | 笔名/网名推荐 |
| `name.sh help` | 显示帮助信息 |

## Usage

当用户询问起名、取名、英文名、品牌名等话题时，使用对应命令。

**示例：**
```bash
# 姓李的女孩名字
bash scripts/name.sh baby "李" --gender 女

# 根据中文名推荐英文名
bash scripts/name.sh english "张明"

# 科技行业高端品牌名
bash scripts/name.sh brand "科技" "高端"

# 文艺风笔名
bash scripts/name.sh pen "文艺"
```

将脚本输出作为推荐基础，可根据用户喜好进一步调整。
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

- Run `name-generator help` for all commands

