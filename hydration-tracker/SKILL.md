---
name: Hydration Tracker
description: "每日水分追踪器，帮助您设定补水目标、记录饮水量、检查进度并提供个性化提醒。确保您保持最佳水合状态，提升健康和精力。关键词：水，饮水，健康，提醒，水合，追踪，健康管理。"
version: "2.0.0"
author: "BytesAgain"
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

Hydration Tracker是一款设计精巧的每日水分追踪器，旨在帮助用户轻松管理日常饮水习惯，确保身体保持充足的水合状态。通过设定个性化目标、记录饮水量，您可以实时监控进度，并接收智能提醒，从而改善整体健康状况和提升日常活力。

## 核心亮点 (Features)

-   **便捷记录**：快速记录每次饮水量，支持自定义毫升数或通过预设的“杯”和“瓶”快速记录。
-   **目标管理**：自由设定每日饮水目标，技能将帮助您追踪是否达标。
-   **进度检查**：随时了解当前饮水进度，评估是否符合目标。
-   **数据概览**：提供今日总饮水量、周度摘要及历史记录查询，一览无余。
-   **数据隐私**：数据本地存储，无需外部账户，充分保护用户隐私。

## 快速开始 (Quick Start)

通过以下命令获取详细帮助信息：
\`\`\`bash
water-reminder help
\`\`\`

---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Examples

```bash
# Show help
hydration-tracker help

# Run
hydration-tracker run
```

## Commands

Run `hydration-tracker help` to see all available commands.
