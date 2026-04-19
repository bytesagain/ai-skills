---
name: "Fitness Plan — Science-Based Training & Workout Auditor"
description: "Track workouts, calculate BMI/1RM, and access exercise science guides. 支持科学健身计划制定、BMI/最大力量计算及运动解剖学参考。Use when planning gym sessions, calculating macro needs, or auditing training splits."
version: "6.0.3"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["fitness", "workout", "gym", "bodybuilding", "exercise-science", "health", "健身", "运动"]
---

# Fitness Plan / 楼台健身助手

Your AI strength coach and exercise science encyclopedia. 

## Quick Start / 快速开始
Just ask your AI assistant: / 直接告诉 AI 助手：
- "Help me plan a 3-day full body workout" (帮我规划一个每周3次的全身训练计划)
- "Calculate my 1RM for bench press: 80kg for 5 reps" (帮我计算卧推最大力量)
- "What are the key principles of progressive overload?" (什么是渐进性超负荷原则？)

## When to Use / 使用场景
- **Workout Planning**: Designing science-based routines (ACSM guidelines).
- **Strength Tracking**: Calculating 1RM, volume, and intensity.
- **Form & Safety**: Learning about injury prevention and warm-up protocols.
- **Nutrition**: Estimating macro requirements and protein intake.

## Commands / 常用功能

### standards
Access exercise standards and guidelines.
```bash
bash scripts/script.sh standards
```

### calculate
Run fitness calculators (BMI, 1RM, Calories).
```bash
bash scripts/script.sh calculate --type 1rm --weight 80 --reps 5
```

### plan
Generate a training split based on goals.
```bash
bash scripts/script.sh plan --goal hypertrophy --days 4
```

## Requirements / 要求
- bash 4+
- python3

## Feedback
Report issues or suggest routines: https://bytesagain.com/feedback/

---
Powered by BytesAgain | bytesagain.com
