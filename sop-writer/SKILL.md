---
version: "2.0.0"
name: sop-writer
description: "SOP标准操作流程编写工具。创建SOP、流程图、检查清单、审核评估、模板库、培训材料。SOP writer with create, flowchart, checklist, audit, template, and training materials. Use when you need sop writer capabilities. Triggers on: sop writer."
author: BytesAgain
---
# sop-writer

SOP标准操作流程编写工具。创建SOP、流程图、检查清单、审核评估、模板库、培训材料。SOP writer with create, flowchart, checklist, audit, template, and training materials.

## 与手动操作对比

| | 手动 | 使用本工具 |
| Command | Description |
|---------|-------------|
| `create` | 创建完整SOP文档（目的/范围/职责/步骤/记录） |
| `flowchart` | 生成ASCII/Mermaid流程图 |
| `checklist` | 从SOP提取执行检查清单 |
| `audit` | SOP审核评估（完整性/合规性/可执行性） |
| `template` | SOP模板库（按行业/场景） |
| `train` | 生成培训材料（测试题/操作手册/快速指南） |

## 命令列表

| 命令 | 功能 |
|------|------|
| `create` | create |
| `flowchart` | flowchart |
| `checklist` | checklist |
| `audit` | audit |
| `template` | template |
| `train` | train |

## 专业建议

- Identify the process to document
- Run: `bash scripts/sop.sh <command> [process] [industry]`
- Present the structured SOP document
- Offer enhancements: flowchart, checklist, training materials
- Document Control** — version, date, author, approver

---
*sop-writer by BytesAgain*
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Examples

```bash
# Show help
sop-writer help

# Run
sop-writer run
```

## Commands

Run `sop-writer help` to see all available commands.
