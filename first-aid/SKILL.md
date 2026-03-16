---
version: "2.0.0"
name: First Aid Guide
description: "🏥 急救指南 (First Aid Guide). Use when you need first aid capabilities. Triggers on: first aid."
  急救指南。烧伤处理、伤口护理、噎住急救、心肺复苏、急救包、紧急情况。First aid guide with burns, wounds, choking, CPR. 急救、应急、安全。
author: BytesAgain
---
# First Aid Guide

急救指南。烧伤处理、伤口护理、噎住急救、心肺复苏、急救包、紧急情况。First aid guide with burns, wounds, choking, CPR. 急救、应急、安全。

## 速查表

See commands above.

## 可用命令

- **guide** — guide
- **burn** — burn
- **wound** — wound
- **choking** — choking
- **cpr** — cpr
- **kit** — kit

> 💡 小技巧：先用 `help` 查看所有命令，再选择最适合的

---
*First Aid Guide by BytesAgain*
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Examples

```bash
# Show help
first-aid help

# Run
first-aid run
```

- Run `first-aid help` for all commands

## Commands

Run `first-aid help` to see all available commands.

## When to Use

- as part of a larger automation pipeline
- when you need quick first aid from the command line

## Output

Returns formatted output to stdout. Redirect to a file with `first-aid run > output.txt`.

## Configuration

Set `FIRST_AID_DIR` environment variable to change the data directory. Default: `~/.local/share/first-aid/`
