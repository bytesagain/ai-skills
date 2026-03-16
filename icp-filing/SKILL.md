---
version: "2.0.0"
name: ICP Filing Guide
description: "ICP Filing Assistant. Use when you need icp filing capabilities. Triggers on: icp filing."
  ICP备案指南。备案流程、材料清单、服务商选择、时间线、常见问题。ICP filing guide for China websites. ICP备案、网站备案。
author: BytesAgain
---
# ICP Filing Guide

ICP备案指南。备案流程、材料清单、服务商选择、时间线、常见问题。ICP filing guide for China websites. ICP备案、网站备案。

## 推荐工作流

```
需求分析 → 选择命令 → 输入描述 → 获取结果 → 调整优化
```

## 命令列表

| 命令 | 功能 |
|------|------|
| `guide` | guide |
| `checklist` | checklist |
| `document` | document |
| `provider` | provider |
| `timeline` | timeline |
| `faq` | faq |

---
*ICP Filing Guide by BytesAgain*
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

- Run `icp-filing help` for all commands

## Commands

Run `icp-filing help` to see all available commands.

## When to Use

- as part of a larger automation pipeline
- when you need quick icp filing from the command line

## Output

Returns summaries to stdout. Redirect to a file with `icp-filing run > output.txt`.

## Configuration

Set `ICP_FILING_DIR` environment variable to change the data directory. Default: `~/.local/share/icp-filing/`
