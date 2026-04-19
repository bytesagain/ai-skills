---
name: "Budget Tracker — Personal Finance & Expense Auditor"
description: "Track income, expenses, and generate monthly reports locally. 支持多币种记账、预算设置及收支报表生成。Use when managing personal finances, tracking project costs, or auditing monthly spending."
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["finance", "budgeting", "expense-tracker", "personal-finance", "accounting", "money-management", "理财", "记账"]
---

# Budget Tracker / 楼台理财助手

Your personal financial auditor that stays 100% local and private.

## Quick Start / 快速开始
Just ask your AI assistant: / 直接告诉 AI 助手：
- "Log an expense: $50 for dinner today" (记录今日晚餐支出50元)
- "I earned $2000 from a freelance project" (记录一笔2000元的自由职业收入)
- "Show my spending summary for March 2026" (显示2026年3月的收支汇总)

## When to Use / 使用场景
- **Daily Expenses**: Keeping track of where every penny goes.
- **Budget Control**: Setting limits and getting alerts for overspending.
- **Data Export**: Generating clean CSV reports for your accountant.

## Commands / 常用功能

### add
Record an income or expense.
```bash
bash scripts/script.sh add --amount -50 --category "Food" --note "Dinner"
```

### list
Show recent transactions.
```bash
bash scripts/script.sh list
```

### report
Generate a monthly financial summary.
```bash
bash scripts/script.sh report --month "2026-03"
```

## Requirements / 要求
- bash 4+
- python3

## Feedback
Report issues or suggest features: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com
