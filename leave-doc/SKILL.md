---
version: "2.0.0"
name: Leave Doc
description: "请假条生成器。支持多种请假类型、多天请假自动计算工作日、紧急请假模板、年假最优规划。. Use when you need leave doc capabilities. Triggers on: leave doc."
  请假条生成器。事假、病假、年假、婚假、产假模板、多天请假自动计算工作日、紧急请假、年假规划。Leave application generator for personal, sick, annual, marriage, maternity leave with workday calculation, emergency templates, annual leave planning. 请假模板、请假理由、OA审批。Use when writing leave applications.
author: BytesAgain
---

# leave-doc

请假条生成器。支持多种请假类型、多天请假自动计算工作日、紧急请假模板、年假最优规划。

## Usage

Run the script at `scripts/doc.sh` with the following commands:

| Command | Description |
|---------|-------------|
| `doc.sh leave "类型" "天数" "原因"` | 基础请假条 |
| `doc.sh multi-day "类型" "天数" "原因"` | 多天请假（自动排除周末计算工作日） |
| `doc.sh emergency` | 紧急请假模板（含微信消息模板） |
| `doc.sh annual-plan "年假天数"` | 年假最优规划（拼假方案） |
| `doc.sh help` | 显示帮助信息 |

## Supported Leave Types

事假 | 病假 | 年假 | 婚假 | 产假 | 陪产假 | 丧假 | 调休

## Examples

```bash
# 基础请假条
bash scripts/doc.sh leave "事假" "2" "家中有事需要处理"

# 多天请假（自动计算工作日，排除周末）
bash scripts/doc.sh multi-day "年假" "5" "出国旅行"

# 紧急请假
bash scripts/doc.sh emergency

# 年假规划
bash scripts/doc.sh annual-plan "10"
```

## Requirements

- Python 3.6+
- No external dependencies
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
