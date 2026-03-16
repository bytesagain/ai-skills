---
version: "2.0.0"
name: spend-tracker
description: "Personal expense and budget tracker with trends and category breakdowns. Use when you need to log expenses, record income, set category budgets, view monthly summaries, check budget status, or export financial data. Triggers on: expense, budget, spending, money, finance, income, cost tracking."
---

# Wallos

Expense Tracker — personal finance manager

## Why This Skill?

- Designed for personal daily use — simple and practical
- No external dependencies — works with standard system tools
- Original implementation by BytesAgain

## Commands

Run `scripts/wallos.sh <command>` to use.

- `add` — <amount> <cat> [note]  Add expense
- `income` — <amount> [note]     Add income
- `list` — [n]                   Recent transactions
- `today` —                      Today's spending
- `month` —                      Monthly summary
- `categories` —                 Spending by category
- `budget` — <cat> <amount>      Set budget
- `budget-check` —               Check budgets
- `trend` — [months]             Spending trend
- `export` — [format]            Export (csv/json/md)
- `info` —                       Version info

## Quick Start

```bash
wallos.sh help
```

> **Disclaimer**: This is an independent, original implementation by BytesAgain. Not affiliated with or derived from any third-party project. No code was copied.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
