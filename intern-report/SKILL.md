---
version: "2.0.0"
name: Intern Report
description: "实习报告和实习总结生成器。日报、周报、实习总结、心得体会、答辩PPT大纲、深度反思与职业规划。. Use when you need intern report capabilities. Triggers on: intern report."
  实习报告生成器。实习总结、周记、心得体会、答辩PPT大纲、深度反思。Intern report generator with weekly logs, summaries, defense outlines, deep reflection. 实习周记、实习心得、毕业实习。Use when writing internship reports.
author: BytesAgain
---

# intern-report

实习报告和实习总结生成器。日报、周报、实习总结、心得体会、答辩PPT大纲、深度反思与职业规划。

## Usage

Run the script at `scripts/intern.sh` with the following commands:

| Command | Description |
|---------|-------------|
| `intern.sh daily "今日工作"` | 生成实习日报 |
| `intern.sh weekly "本周内容"` | 生成实习周报（结构化+学到了什么） |
| `intern.sh summary "实习单位" "岗位" "实习天数"` | 生成实习总结 |
| `intern.sh reflection "收获和感悟"` | 生成心得体会 |
| `intern.sh defense "实习内容"` | 答辩PPT大纲（8页，含答辩技巧） |
| `intern.sh reflect "经历"` | 深度反思（可迁移能力+职业规划） |
| `intern.sh help` | 显示帮助信息 |

## Examples

```bash
# 实习日报
bash scripts/intern.sh daily "参与需求评审会议，完成登录页面UI开发"

# 实习周报
bash scripts/intern.sh weekly "完成用户模块前端开发，学习了React Hooks"

# 实习总结
bash scripts/intern.sh summary "阿里巴巴" "前端开发实习生" "90"

# 心得体会
bash scripts/intern.sh reflection "学会了团队协作，提升了编码能力"

# 答辩PPT大纲
bash scripts/intern.sh defense "前端页面开发,API对接,性能优化,代码评审"

# 深度反思
bash scripts/intern.sh reflect "参与产品开发,学习了敏捷流程,独立完成模块设计"
```

## Requirements

- Python 3.6+
- No external dependencies
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
