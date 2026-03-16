---
version: "2.0.0"
name: checklist-maker
description: "清单生成器。旅行清单、项目清单、每日清单、搬家清单、应急清单(Markdown输出)。Checklist maker with travel, project, daily, moving, emergency checklists in Markdown. Use when you need checklist maker capabilities. Triggers on: checklist maker."
author: BytesAgain
---

# Checklist Maker ✅

Markdown清单生成器，覆盖各种生活和工作场景。

## 使用方式

| 需求 | 命令 | 说明 |
|------|------|------|
| 自定义清单 | `create` | 根据任意主题生成清单 |
| 旅行清单 | `travel` | 出行打包/准备清单 |
| 项目清单 | `project` | 项目启动/上线清单 |
| 每日清单 | `daily` | 每日待办/习惯清单 |
| 搬家清单 | `moving` | 搬家全流程清单 |
| 应急清单 | `emergency` | 应急准备/急救清单 |

## 运行

```bash
bash scripts/checklist.sh <command> [args...]
```
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Commands

- `create` — 自定义主题清单生成
- `travel` — 旅行打包/准备清单
- `project` — 项目启动/上线清单
- `daily` — 每日待办/习惯清单
- `moving` — 搬家全流程清单
- `emergency` — 应急准备/急救清单

- Run `checklist-maker help` for all commands


## Output

Results go to stdout. Save with `checklist-maker run > output.txt`.
