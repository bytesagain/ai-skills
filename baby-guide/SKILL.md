---
version: "2.0.0"
name: Baby Guide
description: "育儿指南。按月龄发育指标、辅食添加、早教建议、疫苗提醒。. Use when you need baby guide capabilities. Triggers on: baby guide."
  育儿指南助手。新生儿护理、辅食添加、疫苗接种、早教启蒙、睡眠训练、亲子互动。Baby care guide with feeding, vaccination, sleep training, early education. 育儿百科、宝宝成长、母婴护理。Use when parents need baby care advice.
author: BytesAgain
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

