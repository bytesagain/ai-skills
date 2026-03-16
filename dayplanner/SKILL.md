---
version: "2.0.0"
name: dayplanner
description: "日程规划工具。周计划、月计划、时间块、会议安排、截止日期管理、工作生活平衡。Calendar planner with weekly, monthly, time-blocking, meeting scheduling, deadline management, and work-life balance. Use when you need dayplanner capabilities. Triggers on: dayplanner."
---

# Calendar Planner Skill

日程规划工具 — 科学安排时间，提升效率。

## Commands

Run via: `bash scripts/calplan.sh <command> [options]`

| Command | Description |
|---------|-------------|
| `weekly` | 生成周计划模板（按角色/优先级/精力） |
| `monthly` | 月度计划与目标分解 |
| `block` | 时间块规划（深度工作/浅层工作/休息） |
| `meeting` | 会议安排优化（议程/时长/频率） |
| `deadline` | 截止日期倒推计划（里程碑/缓冲/依赖） |
| `balance` | 工作生活平衡评估与调整建议 |

## Usage

Agent reads `tips.md` for prompt guidance, then runs the script to create schedules.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
dayplanner help
dayplanner run
```

## When to Use

- when you need quick dayplanner from the command line
- to automate dayplanner tasks in your workflow

## Output

Returns results to stdout. Redirect to a file with `dayplanner run > output.txt`.
