---
name: BudgetLy
description: "Smart category-based budget manager. Set monthly budgets by category (food, transport, entertainment, etc.), log spending against each category, see visual progress bars showing budget vs actual, get overspend warnings, and generate monthly spending reports with percentage breakdowns. Perfect for personal budgeting without spreadsheets."
version: "2.0.0"
author: "BytesAgain"
tags: ["budget","finance","money","spending","savings","personal-finance","categories"]
categories: ["Finance", "Personal Management", "Productivity"]
---

# BudgetLy

BudgetLy is a category-based budget tracker that helps you stay on top of your spending. Set budgets for different categories, log expenses, and see visual progress bars showing how much you've spent versus your limit.

## Why BudgetLy?

- **Visual tracking**: Progress bars show budget usage at a glance
- **Smart warnings**: Get alerts when approaching or exceeding limits
- **Category-based**: Organize spending by food, transport, entertainment, etc.
- **Monthly reports**: See where your money goes with percentage breakdowns
- **Local storage**: Your financial data never leaves your machine

## Commands

- `set <category> <amount>` — Set a monthly budget for a category
- `spend <category> <amount> [note]` — Log spending in a category
- `status` — View all budgets with visual progress bars and warnings
- `report` — Monthly spending report with category breakdowns
- `info` — Version information
- `help` — Show available commands

## Usage Examples

```bash
budgetly set food 500
budgetly set transport 200
budgetly set entertainment 150
budgetly spend food 45.50 groceries
budgetly spend transport 30 uber
budgetly status
budgetly report
```

## Status Display

The `status` command shows visual progress for each category:
```
food         $  245.50/$  500.00 [██████░░░░]  49.1%
transport    $  180.00/$  200.00 [█████████░]  90.0% ⚠️
entertainment$   75.00/$  150.00 [█████░░░░░]  50.0%
```

---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
