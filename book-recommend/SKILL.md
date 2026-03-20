---
version: "2.0.0"
name: book-recommend
description: "书单推荐助手。个性化推荐、书籍摘要、同类书推荐、阅读清单、读书会方案、年度书单。Book recommendation with personalized picks, summaries, similar books, reading lists, book clubs."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Book Recommend Skill

书单推荐助手 — 遇见下一本好书。

## Commands

Run via: `bash scripts/book.sh <command> [args...]`

| Command      | Description                  |
|--------------|------------------------------|
| recommend    | 按兴趣推荐书籍                |
| summary      | 生成书籍摘要和要点            |
| similar      | 找类似的书                    |
| reading-list | 创建主题阅读清单              |
| club         | 读书会方案设计                |
| annual       | 年度书单推荐                  |

## Usage Examples

```bash
# 推荐书籍（兴趣 类型 难度）
bash scripts/book.sh recommend "创业,商业模式" "non-fiction" "intermediate"

# 书籍摘要
bash scripts/book.sh summary "思考，快与慢"

# 类似推荐
bash scripts/book.sh similar "人类简史"

# 阅读清单
bash scripts/book.sh reading-list "产品经理入门" "10"

# 读书会方案
bash scripts/book.sh club "原则" "4weeks"

# 年度书单
bash scripts/book.sh annual "2024" "business"
```
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
