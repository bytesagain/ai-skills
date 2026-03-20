---
name: Hydration Tracker
description: "Track daily water intake, set hydration goals, and get drink reminders. Use when logging water, setting targets, or reviewing weekly intake trends."
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["health", "hydration", "water", "reminder", "wellness", "utility", "健康", "饮水"]
categories: ["Health & Wellness", "Utility", "Personal Management"]
commands:
  - name: "drink"
    description: "记录一次饮水量。如不指定，默认为250ml。示例：`water-reminder drink 500`"
    usage: "hydration-tracker drink [ml]"
    parameters:
      - name: "ml"
        type: "number"
        description: "饮水量，单位毫升。"
        required: false
  - name: "cup"
    description: "快速记录一杯水（默认为250ml）。"
    usage: "hydration-tracker cup"
  - name: "bottle"
    description: "快速记录一瓶水（默认为500ml）。"
    usage: "hydration-tracker bottle"
  - name: "today"
    description: "查看今日总饮水量。"
    usage: "hydration-tracker today"
  - name: "goal"
    description: "设定每日饮水目标。如不指定，默认为2000ml。示例：`water-reminder goal 2500`"
    usage: "hydration-tracker goal [ml]"
    parameters:
      - name: "ml"
        type: "number"
        description: "每日饮水目标，单位毫升。"
        required: false
  - name: "check"
    description: "检查当前饮水进度是否达标。"
    usage: "hydration-tracker check"
  - name: "week"
    description: "查看本周饮水量的汇总摘要。"
    usage: "hydration-tracker week"
  - name: "history"
    description: "查看最近N天的饮水记录（默认为7天）。示例：`water-reminder history 30`"
    usage: "hydration-tracker history [n]"
    parameters:
      - name: "n"
        type: "number"
        description: "查看历史记录的天数。"
        required: false
  - name: "stats"
    description: "显示详细的水合统计数据和趋势。"
    usage: "hydration-tracker stats"
  - name: "remind"
    description: "获取水合小贴士和个性化提醒。"
    usage: "hydration-tracker remind"
  - name: "info"
    description: "显示Hydration Tracker的版本信息。"
    usage: "hydration-tracker info"
changelog:
  - version: "2.0.0"
    date: "2026-03-15"
    changes:
      - "初始版本发布：提供每日饮水追踪、目标设定和进度检查功能。"
pricing_model: "free"
license: "MIT"
docs_url: "https://bytesagain.com/skills/hydration-tracker"
support_url: "https://bytesagain.com/feedback"
---

# Hydration Tracker

A daily water intake tracker that helps you build and maintain healthy hydration habits. Log every drink, set personalized daily goals, check your progress throughout the day, and review weekly summaries — all from the command line with local-only data storage.

## Commands

| Command | Description |
|---------|-------------|
| `drink [ml]` | Log water intake in milliliters (default: 250ml). Shows running total and goal progress with celebration when goal is reached |
| `cup` | Quick-log a cup of water (250ml) — shortcut for `drink 250` |
| `bottle` | Quick-log a bottle of water (500ml) — shortcut for `drink 500` |
| `today` | Display today's total intake vs. daily goal, with remaining amount or goal-reached indicator |
| `goal [ml]` | Set your daily hydration goal in milliliters (default: 2000ml) |
| `check` | Check if you're on track — compares current intake against expected intake based on time of day |
| `week` | Show a 7-day hydration summary with daily breakdowns, weekly total, and daily average |
| `history [n]` | Show hydration history for the last N days (default: 7, max: 30) |
| `stats` | Display overall statistics — total days tracked, total intake, and average daily intake |
| `remind` | Get a random hydration tip (e.g., "Drink a glass of water before each meal") |
| `info` | Show version info (v1.0.0) |
| `help` | Show all available commands with usage examples |

## Data Storage

- **Data directory:** `~/.water_reminder/`
- **Intake data:** `data.json` — JSON object mapping dates (YYYY-MM-DD) to cumulative daily intake in ml
- **Goal config:** `goal.json` — stores your current daily goal (default: 2000ml)
- **Max history:** 30 days of lookback for the `history` command
- All data is stored locally in JSON format; no external services, accounts, or network access required

## Requirements

- Bash 4+
- Python 3 (standard library only — used for JSON read/write)
- Standard POSIX utilities (`date`, `seq`)
- No API keys or external dependencies

## When to Use

1. **Building a daily hydration habit** — log each drink throughout the day and let the progress tracker keep you motivated with goal-reached celebrations
2. **Checking mid-day progress** — use `check` to see if your intake is on track relative to the time of day, so you can catch up before evening
3. **Reviewing weekly trends** — run `week` to see a 7-day summary with emoji indicators showing which days you hit your goal
4. **Adjusting your hydration goal** — use `goal` to increase or decrease your daily target based on activity level, weather, or health needs
5. **Getting gentle reminders** — run `remind` for evidence-based hydration tips to keep healthy habits top of mind

## Examples

```bash
# Log 300ml of water
hydration-tracker drink 300

# Quick-log a cup (250ml)
hydration-tracker cup

# Quick-log a bottle (500ml)
hydration-tracker bottle

# Check today's progress
hydration-tracker today

# Set a custom daily goal of 2500ml
hydration-tracker goal 2500
```

### Example Output

```
$ hydration-tracker drink 300
Logged 300ml. Today's total: 1200ml / 2000ml.
Almost there! Keep going!

$ hydration-tracker today
Today's intake (2026-03-18): 1200ml / 2000ml
Remaining: 800ml

$ hydration-tracker week
--- Weekly Hydration Summary ---
2026-03-18: (1200ml / 2000ml) 💧
2026-03-17: (2100ml / 2000ml) 🎉
2026-03-16: (1800ml / 2000ml) 💧
...
Weekly total: 12300ml
Daily average: 1757ml (Goal: 2000ml)

$ hydration-tracker remind
💧 Hydration Tip: Drink a glass of water before each meal.
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
