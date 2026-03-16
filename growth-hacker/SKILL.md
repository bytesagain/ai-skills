---
version: "2.0.0"
name: Growth Hacker
description: "🏴‍☠️ 增长策略生成器（AARRR模型）. Use when you need growth hacker capabilities. Triggers on: growth hacker."
  增长黑客工具。用户增长策略、AARRR模型、裂变方案、留存优化。Growth hacking with AARRR funnel, viral loops, retention optimization. 用户增长、拉新促活、转化率。Use when designing growth strategies.
---

# growth-hacker

增长策略和用户增长方案生成器。拉新、留存、转化、裂变。AARRR模型。

## Description

基于AARRR海盗模型生成用户增长策略，覆盖获客（Acquisition）、激活（Activation）、留存（Retention）、变现（Revenue）、推荐（Referral）全链路。

## Commands

| 命令 | 用法 | 说明 |
|------|------|------|
| `aarrr` | `growth.sh aarrr "产品"` | AARRR漏斗全链路分析 |
| `acquisition` | `growth.sh acquisition "产品" "预算"` | 拉新获客方案 |
| `retention` | `growth.sh retention "产品"` | 用户留存策略 |
| `viral` | `growth.sh viral "产品"` | 裂变增长方案 |
| `help` | `growth.sh help` | 显示帮助信息 |

## Usage

当用户需要增长策略、拉新方案、留存优化或裂变玩法时，运行对应脚本命令。

```bash
# AARRR漏斗分析
bash {{SKILL_DIR}}/scripts/growth.sh aarrr "社区团购App"

# 拉新方案
bash {{SKILL_DIR}}/scripts/growth.sh acquisition "社区团购App" "50万/月"

# 留存策略
bash {{SKILL_DIR}}/scripts/growth.sh retention "社区团购App"

# 裂变方案
bash {{SKILL_DIR}}/scripts/growth.sh viral "社区团购App"
```

## Notes

- 纯本地生成，无需API
- Python 3.6+ 兼容
- 基于AARRR海盗模型
- 输出可执行的增长策略框架
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
