---
version: "2.0.0"
name: Inventory Manager
description: "Inventory Manager. Use when you need inventory manager capabilities. Triggers on: inventory manager."
  库存管理。库存盘点、补货策略、ABC分析、安全库存、周转率、预警系统。Inventory management helper. 库存、进销存。
author: BytesAgain
---
# Inventory Manager

库存管理。库存盘点、补货策略、ABC分析、安全库存、周转率、预警系统。Inventory management helper. 库存、进销存。

## 核心特点

🎯 **精准** — 针对具体场景定制化输出
📋 **全面** — 多个命令覆盖完整工作流
🇨🇳 **本土化** — 完全适配中文用户习惯

## 命令列表

| 命令 | 功能 |
|------|------|
| `count` | count |
| `reorder` | reorder |
| `abc` | abc |
| `safety` | safety |
| `turnover` | turnover |
| `alert` | alert |

---
*Inventory Manager by BytesAgain*
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Examples

```bash
# Show help
inventory-manager help

# Run
inventory-manager run
```

- Run `inventory-manager help` for commands
- No API keys needed

- Run `inventory-manager help` for all commands

## Commands

Run `inventory-manager help` to see all available commands.

## Configuration

Set `INVENTORY_MANAGER_DIR` to change data directory. Default: `~/.local/share/inventory-manager/`
