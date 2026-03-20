---
version: "2.0.0"
name: Baby Guide
description: "Track infant milestones, plan feeding schedules, and manage vaccines. Use when checking development, planning meals, or scheduling immunizations."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# baby-guide

育儿指南。按月龄发育指标、辅食添加、早教建议、疫苗提醒。

## Commands

| 命令 | 说明 |
|------|------|
| `baby.sh milestone "月龄"` | 发育指标（身高体重/大运动/精细运动/语言/社交） |
| `baby.sh food "月龄"` | 辅食添加指南 |
| `baby.sh education "月龄"` | 早教建议与亲子活动 |
| `baby.sh vaccine "月龄"` | 疫苗接种提醒 |
| `baby.sh help` | 显示帮助信息 |

## Usage

当用户询问宝宝发育、辅食、早教、疫苗等育儿话题时，使用对应命令。

**示例：**
```bash
# 6个月宝宝发育指标
bash scripts/baby.sh milestone "6"

# 8个月辅食添加指南
bash scripts/baby.sh food "8"

# 12个月早教建议
bash scripts/baby.sh education "12"

# 3个月疫苗提醒
bash scripts/baby.sh vaccine "3"
```

将脚本输出作为参考，提醒用户具体情况请咨询儿科医生。
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

- Run `baby-guide help` for all commands

