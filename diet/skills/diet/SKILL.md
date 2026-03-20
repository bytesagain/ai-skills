---
name: diet
description: "Track food and nutrition. Use when logging meals, checking calories, tracking protein/carbs/fat, or generating diet reports."
version: "3.4.0"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags:
  - nutrition
  - calories
  - meal-tracking
  - health
  - diet-plan
---

# Diet — Meal & Nutrition Tracker

Track what you eat, monitor macros, plan meals, and review nutrition trends.

## Commands

### log — Record a meal

```bash
bash scripts/script.sh log "<food_item>" <calories> <protein_g> <carbs_g> <fat_g> [meal_type]
```

Records a food entry with calorie and macro data. `meal_type` defaults to `snack`. Options: `breakfast`, `lunch`, `dinner`, `snack`.

### calories — Query calorie totals

```bash
bash scripts/script.sh calories [YYYY-MM-DD]
```

Shows total calories consumed for a given date. Defaults to today.

### plan — Generate a meal plan

```bash
bash scripts/script.sh plan <target_calories> <days>
```

Generates a simple meal plan for the specified number of days targeting the given daily calorie goal, based on previously logged foods.

### macros — Macronutrient breakdown

```bash
bash scripts/script.sh macros [YYYY-MM-DD]
```

Shows protein, carbs, and fat totals and percentages for a given date. Defaults to today.

### water — Log water intake

```bash
bash scripts/script.sh water <ml> [YYYY-MM-DD]
```

Records water intake in milliliters. Defaults to today.

### report — Nutrition report

```bash
bash scripts/script.sh report [daily|weekly] [YYYY-MM-DD]
```

Produces a nutrition summary. `daily` shows one day; `weekly` shows 7-day trends. Defaults to daily report for today.

## Output

All commands print plain text to stdout. Data is stored in `~/.diet/` as JSON files (`meals.json`, `water.json`).


## Requirements
- bash 4+
- python3 (standard library only)

## Feedback

Report issues or suggestions: [https://bytesagain.com/feedback/](https://bytesagain.com/feedback/)

---

Powered by BytesAgain | bytesagain.com
