---
version: "2.0.0"
name: Bookkeeping
description: "记账管家。收支记录、月度报表（含同比环比）、预算管理、存钱目标追踪。数据存本地JSON。. Use when you need beancount capabilities. Triggers on: beancount."
  记账理财助手。个人收支记录、月度报表、预算管理、消费分析、储蓄目标。Personal bookkeeping with income/expense tracking, monthly reports, budget management. 记账本、家庭账本、理财规划。Use when tracking personal finances.
author: BytesAgain
---

# bookkeeping

记账管家。收支记录、月度报表（含同比环比）、预算管理、存钱目标追踪。数据存本地JSON。

## Commands

All commands via `scripts/book.sh`:

| Command | Usage | Description |
|---------|-------|-------------|
| `add` | `book.sh add "金额" "类别" "备注" [--type income\|expense]` | 记一笔账（默认expense） |
| `list` | `book.sh list [--month 2026-03]` | 查看记录（默认当月） |
| `report` | `book.sh report [--month 2026-03]` | 月度收支报表（含同比环比+分类饼图+支出TOP3） |
| `budget` | `book.sh budget "类别" "月预算"` | 设置类别月预算（超支自动提醒） |
| `goal` | `book.sh goal "目标名" "金额" "月数"` | 设置存钱目标（计算每月需存） |
| `goal-save` | `book.sh goal-save "目标名" "金额"` | 往目标里存钱 |
| `goals` | `book.sh goals` | 查看所有存钱目标进度 |
| `help` | `book.sh help` | 显示帮助信息 |

## Data Storage

- 记录文件: `~/.bookkeeping/records.json`
- 预算文件: `~/.bookkeeping/budgets.json`
- 目标文件: `~/.bookkeeping/goals.json`
- 自动创建目录和文件

## Examples

```bash
# 记一笔支出
bash scripts/book.sh add 35.5 餐饮 "午餐外卖"

# 记一笔收入
bash scripts/book.sh add 15000 工资 "3月工资" --type income

# 查看当月记录
bash scripts/book.sh list

# 查看指定月份
bash scripts/book.sh list --month 2026-02

# 生成月度报表（含同比环比）
bash scripts/book.sh report

# 设置餐饮预算
bash scripts/book.sh budget 餐饮 2000

# 设置存钱目标（6个月存8000）
bash scripts/book.sh goal "买相机" 8000 6

# 往目标存钱
bash scripts/book.sh goal-save "买相机" 1500

# 查看所有目标进度
bash scripts/book.sh goals
```

## Categories (建议)

- 支出: 餐饮、交通、购物、娱乐、居住、医疗、教育、其他
- 收入: 工资、奖金、理财、兼职、其他

## Reference

- 参考文档: `tips.md` — 记账理财小贴士（50-30-20法则、存钱技巧等）

## Notes

- 数据存储在 `~/.bookkeeping/` 目录
- JSON 格式，可手动编辑
- 纯本地运行，无需联网
- Python 3.6+ 兼容
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
