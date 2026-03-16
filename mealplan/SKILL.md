---
name: MealPlan
description: "Weekly meal planner with shopping list generator. Plan breakfast, lunch, dinner, and snacks for each day of the week. Auto-generate shopping lists from your meal plan. Includes meal templates for balanced, vegan, and keto diets. Simple meal prep organization."
version: "2.0.0"
author: "BytesAgain"
tags: ["meal","food","planning","diet","nutrition","cooking","health","weekly"]
categories: ["Health & Wellness", "Personal Management", "Productivity"]
---

# MealPlan

Plan your meals for the week. Generate shopping lists automatically. Eat better with less thinking.

## Why MealPlan?

- **Weekly view**: Plan all 7 days at a glance
- **Auto shopping list**: Generate ingredient lists from your plan
- **Diet templates**: Quick-start with balanced, vegan, or keto plans
- **Flexible**: Any meal type, any food
- **Simple**: One command to plan, one to view

## Commands

- `set <day> <meal> <food>` — Plan a meal (days: mon-sun, meals: breakfast/lunch/dinner/snack)
- `show [day]` — View meal plan (specific day or all)
- `shopping` — Generate shopping list from current plan
- `clear <day|all>` — Clear meals for a day or all
- `template [style]` — Show meal templates (balanced/vegan/keto)
- `info` — Version info
- `help` — Show commands

## Usage Examples

```bash
mealplan set mon breakfast Oatmeal with berries
mealplan set mon lunch Chicken salad sandwich
mealplan set mon dinner Pasta with tomato sauce
mealplan show mon
mealplan shopping
mealplan template keto
```

---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
